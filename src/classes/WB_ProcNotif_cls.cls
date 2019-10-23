/**-------------------------------------------------------------------------
* Nombre: WB_ProcNotif_cls
* @author Karen Sanchez (KB)
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Clase que activa los procesos de tiempo para el envio de CTI tanto del objeto Lead como el de la Oportunidad

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 2.0           28/01/2019      Karen Sanchez            Actualización
* @version 2.1           28/06/2019      Julio/jaime/Arsenio      Modificacion y aislamiento de fecha creacion
* @version 2.1.1         04/07/2019      Eduardo Hernández        Filtro para envios de productos Hogar y vida en VCIP
* @version 2.1.2         19/07/2019      Eduardo Hernández        Filtro para folios vacios
* --------------------------------------------------------------------------*/



public with sharing class WB_ProcNotif_cls {

    /*
    *Método: Se ejecuta cuando se actualiza un registro del objeto ProcNotiOppNoAten__c para ejecutar 3 batch dependiendo del proceso
    *28-01-2019
    *Karen Belem Sanchez Ruiz*/
    public static void agendarProcesoNotif(List<ProcNotiOppNoAten__c>lsNotif, Map<Id,ProcNotiOppNoAten__c>mapOldNotif) {

        for (ProcNotiOppNoAten__c procNoti : lsNotif) {

            final OppUpdEnvEmailSch_cls objOppUpdEnvEmailSch = new OppUpdEnvEmailSch_cls();
            objOppUpdEnvEmailSch.isCupon = false;
            final String sHorario = procNoti.Minutos__c;
            String sEstatusProcess = '';
            String sch = '';
            String sQuery = '';
            final String leadSource = 'Outbound TLMK';
            final Integer contadorRemarcado = 5;
            final String noBloqueado = 'No bloqueado';
            final Integer sCantidadEnvio = Integer.valueOf(label.MX_WB_CantidadEnvioCTI);
	        final String sTypeRecord = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('MX_WB_rt_Telemarketing').getRecordTypeId();
            sQuery = 'Select Opportunity.Id, Opportunity.AccountId, Status, Opportunity.EnviarCTI__c, Opportunity.LastModifiedDate, ';
            sQuery += ' MX_SB_VTS_Folio_Cotizacion__c, Opportunity.OwnerId,Opportunity.Producto__c, Opportunity.Account.PersonEmail, MX_SB_VTS_Movil_txt__c From Quote ';
            sQuery += ' Where Opportunity.EnviarCTI__c = false ';
            sQuery += ' And Opportunity.LeadSource = \'Tracking Web\'';
            sQuery += ' And Opportunity.AccountId != null';
	        sQuery += ' And MX_SB_VTS_Folio_Cotizacion__c != null';
            sQuery += ' And Opportunity.Reason__c != \'' + System.Label.SAN163_WSOppotunityBlackListValues + '\'';
            sQuery += ' And Opportunity.StageName != \'' + System.Label.SAN163_WSOppotunityBlackListStageName + '\'';
            sQuery += ' And CreatedDate >= ' + System.label.MX_SB_VTS_SCHEDULE_DATE_LBL;
            sQuery += ' And Opportunity.Caso_Relacionado__c = null';
            sQuery += ' And Opportunity.MX_SB_VTS_OppCase__c = null';
            sQuery += ' And MX_SB_VTS_Familia_Productos__r.Name = \'' + System.label.MX_SB_VTS_FamiliaASD + '\'';
            if (procNoti.Activo__c && !mapOldNotif.get(procNoti.id).Activo__c && String.isBlank(procNoti.Proceso__c)) {

                sEstatusProcess = 'Creada-Formalizada-Tarificada';
                sch = '';
                sch = '0 ' + procNoti.Minutos__c + ' 0-23 1-31 1-12 ?';
                sQuery += ' And Opportunity.MX_WB_EnvioCTICupon__c = false ';

                objOppUpdEnvEmailSch.sQuery = sQuery;
                objOppUpdEnvEmailSch.sMinuto = sHorario;

                final String sNombreProc = procNoti.Horario__c + ' : ' + procNoti.Minutos__c + ' estatus : ' + sEstatusProcess;
                System.schedule(sNombreProc, sch, objOppUpdEnvEmailSch);
            } else {
                final String campaingMembers = sQueryOutboundMiembros();
                sch = '0 ' + procNoti.Minutos__c + ' 0-23 1-31 1-12 ?';
                String sNombreProc = procNoti.Horario__c + ' : ' + procNoti.Minutos__c + ' : ' + procNoti.Proceso__c;
                switch on (procNoti.Proceso__c) {
                    when 'Outbound'{
                        sQuery = 'SELECT l.Id,l.Folio_Cotizacion__c,l.OwnerId,l.FirstName,l.MX_WB_ph_Telefono1__c,l.MX_WB_ph_Telefono2__c,l.MX_WB_ph_Telefono3__c,l.MX_WB_ContadorRemarcado__c, l.EnviarCTI__c,CreatedDate';
                        sQuery += ', l.LeadSource, l.RecordTypeId, l.MX_WB_TM_Congelado__c,(SELECT Id, Motivos_CONTACTO__c, Telefono__c from Tasks) From Lead l WHERE MX_WB_Convertido__c = false AND MX_WB_TM_Congelado__c = false AND RecordTypeId =\'' + sTypeRecord + '\''+' AND LeadSource =\''+leadSource + '\''+'AND MX_WB_lst_EstatusBloqueado__c !=  \''+ noBloqueado+ '\''+' AND MX_WB_ContadorRemarcado__c <= \''+ contadorRemarcado + '\''+'AND Id in'+campaingMembers+'limit '+sCantidadEnvio;
                        final MX_WB_EnvioLeadsCTI_shc objEnvioLeadsShc = new MX_WB_EnvioLeadsCTI_shc();
                        objEnvioLeadsShc.sQuery = sQuery;
                        System.schedule(sNombreProc, sch, objEnvioLeadsShc);
                    }
                    when 'Cupon' {
                        sEstatusProcess = 'Cupon';
                        sch = '';
                        sch = '0 0 11 1-31 1-12 ?';
                        sQuery += ' And Opportunity.MX_WB_EnvioCTICupon__c = true';
                        sQuery += ' And Opportunity.CreatedDate >= YESTERDAY ';
                        sQuery += ' And Status != \'Emitida\'';

                        objOppUpdEnvEmailSch.sQuery = sQuery;
                        objOppUpdEnvEmailSch.isCupon = true;

                        sNombreProc = procNoti.Horario__c + ' : 11:00 AM : ' + sEstatusProcess;

                        System.schedule(sNombreProc, sch, objOppUpdEnvEmailSch);
                    }
                }
            }
        }
    }

    /*
    *Método: Regresa los miembros de la campaña activa para mandar a CTI
    *28-01-2019
    *Karen Belem Sanchez Ruiz*/
    public static String sQueryOutboundMiembros() {
        String campaingMembers = '(';
                for(CampaignMember miembro: [Select LeadId From CampaignMember Where Campaign.isActive=true]) {
                    campaingMembers += '\''+miembro.LeadId+'\',';
                }
                campaingMembers = campaingMembers.removeEnd(',');
                campaingMembers += ')';

        return campaingMembers;

    }
}
