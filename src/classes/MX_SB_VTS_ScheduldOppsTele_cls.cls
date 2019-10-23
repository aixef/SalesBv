/**
 * @File Name          : MX_SB_VTS_ScheduldOppsTele_cls.cls
 * @Description        :
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              :
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 8/10/2019 0:02:10
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    7/10/2019   Eduardo Hernández Cuamatzi     Initial Version
**/
public without sharing class MX_SB_VTS_ScheduldOppsTele_cls {//NOSONAR
    /**
     * sendOppsHogar envia Oportunidades a SmartCenter
     */
    public static void sendOppsHogar(List<ProcNotiOppNoAten__c> lsNotif, Map<Id,ProcNotiOppNoAten__c> mapOldNotif) {
        for (ProcNotiOppNoAten__c procNoti : lsNotif) {
            if(String.isNotBlank(procNoti.Proceso__c) && procNoti.Proceso__c.equals(System.Label.MX_SB_VTS_SchdProces)) {
                createScheduldOpps(procNoti);
            }
        }
    }

    /**
     * createScheduldOpps crear query base de scheduld
     * @param  registro de trabajos programados
     */
    public static void createScheduldOpps(ProcNotiOppNoAten__c lsNotif) {
        final MX_SB_VTS_SendTrackingTelemarketing_sch scheduldOppTlmk = new MX_SB_VTS_SendTrackingTelemarketing_sch();
        String sQuery = 'Select Opportunity.Id, Opportunity.AccountId, Status, Opportunity.EnviarCTI__c, Opportunity.LastModifiedDate, MX_SB_VTS_Familia_Productos__c,';
        sQuery += ' MX_SB_VTS_Folio_Cotizacion__c, Opportunity.OwnerId,Opportunity.Producto__c, Opportunity.Account.PersonEmail, MX_SB_VTS_Movil_txt__c From Quote ';
        sQuery += ' Where Opportunity.LeadSource = \'Tracking Web\'';
        sQuery += ' And Opportunity.AccountId != null';
        sQuery += ' And MX_SB_VTS_Folio_Cotizacion__c != null';
        sQuery += ' And CreatedDate >= ' + System.label.MX_SB_VTS_SCHEDULE_DATE_LBL;
        sQuery += ' And Opportunity.Caso_Relacionado__c = null';
        sQuery += ' And Opportunity.MX_SB_VTS_OppCase__c = null';
        sQuery += ' And MX_SB_VTS_Familia_Productos__r.Name = \'' + System.label.MX_SB_VTS_HogarFam + '\'';
        final String sch = '0 ' + lsNotif.Minutos__c + ' 0-23 1-31 1-12 ?';
        final String sNombreProc = lsNotif.Horario__c + ' : ' + lsNotif.Minutos__c + ' estatus : ' + 'Tracking';
        scheduldOppTlmk.sQuery = sQuery;
        System.schedule(sNombreProc, sch, scheduldOppTlmk);
    }
}