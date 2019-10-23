/**
 * @File Name          : MX_WB_Envio4HrsCTI_sch.cls
 * @Description        :
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              :
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 20/2/2019 3:29:13
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    20/2/2019 3:29:13   Eduardo Hernández Cuamatzi     Initial Version
**/
global with sharing class MX_WB_Envio4HrsCTI_sch implements Schedulable {
/**
*
* @
*/
    global void execute(SchedulableContext scheCont) {
        final String sTypeRecord = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('MX_WB_rt_Telemarketing').getRecordTypeId();
        final String leadSource = 'Outbound TLMK';
        final Integer contadorRemarcado = 5;
        final String noBloqueado = 'No bloqueado';
        String sQuery = '';

        String campaingMembers = '(';
        for(CampaignMember miembro: [Select LeadId From CampaignMember Where Campaign.isActive=true]) {
            campaingMembers += '\''+miembro.LeadId+'\',';
        }
        campaingMembers = campaingMembers.removeEnd(',');
        campaingMembers += ')';

        sQuery = 'SELECT l.Id, l.Folio_Cotizacion__c, l.OwnerId,l.FirstName, l.MX_WB_ph_Telefono1__c, l.MX_WB_ph_Telefono2__c, l.MX_WB_ph_Telefono3__c, l.MX_WB_ContadorRemarcado__c, l.EnviarCTI__c, CreatedDate, '
            	+ '(SELECT Id, Motivos_CONTACTO__c, Telefono__c from Tasks), l.MX_WB_TM_Congelado__c, '
        		+ 'l.LeadSource, l.RecordTypeId From Lead l WHERE RecordTypeId =\'' + sTypeRecord + '\''+' AND LeadSource =\''+leadSource + '\''+' AND MX_WB_ContadorRemarcado__c <= \''+ contadorRemarcado + '\' '
        		+ 'AND MX_WB_lst_EstatusBloqueado__c !=  \''+ noBloqueado + '\' AND MX_WB_TM_Congelado__c = false AND Id in '+campaingMembers;

        System.debug('sQuery'+ sQuery);
		final MX_WB_EnvioLeads4HrsCTI_bch leadEnvio = new MX_WB_EnvioLeads4HrsCTI_bch(sQuery);
		final Id batchInstanceId = Database.executeBatch(leadEnvio, 200);
        System.debug('batchInstanceId ' + batchInstanceId);
	}
}
