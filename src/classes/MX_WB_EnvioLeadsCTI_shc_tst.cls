/**-------------------------------------------------------------------------
* Nombre: WB_ProcNotif_cls
* @author Karen Sanchez (KB)
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Clase test que sirve para la cobertura del schedulable MX_WB_EnvioLeadsCTI_shc

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           13/02/2019      Karen Sanchez            Creación
* --------------------------------------------------------------------------*/
@isTest
private class MX_WB_EnvioLeadsCTI_shc_tst {
	/**
	* 
	* 
	*/
	public static final String CRON_EXP = '0 0 0 1 1 ? 2022';

	@isTest static void ejecutaSchedulable() {
		final MX_WB_EnvioLeadsCTI_shc objEnvioLeadsSCH = new MX_WB_EnvioLeadsCTI_shc();
		final Id idRecordType = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('MX_WB_rt_Telemarketing').getRecordTypeId();
		final Campaign objCampaign = MX_WB_TestData_cls.createCampania('Campania Preuba500');
		insert objCampaign;
		final Lead objLeads = MX_WB_TestData_cls.createLead('Sanchez');
		objLeads.RecordTypeId = idRecordType;
		objLeads.LeadSource = 'Outbound TLMK';
		objLeads.MX_WB_ContadorRemarcado__c = '2';
		insert objLeads;
		final CampaignMember objCampaignMember = MX_WB_TestData_cls.createCampaignMember(objLeads.Id, objCampaign.Id);
		database.insert (objCampaignMember, false);


		Test.startTest();
		final String noBloqueado = 'No bloqueado';
        final Integer sCantidadEnvio = Integer.valueOf(label.MX_WB_CantidadEnvioCTI);
		String sQuery = 'SELECT l.Id,l.Folio_Cotizacion__c,l.OwnerId,l.FirstName,l.MX_WB_ph_Telefono1__c,l.MX_WB_ph_Telefono2__c,l.MX_WB_ph_Telefono3__c,l.MX_WB_ContadorRemarcado__c, l.EnviarCTI__c,CreatedDate';
        sQuery += ', l.LeadSource, l.RecordTypeId, l.MX_WB_TM_Congelado__c From Lead l WHERE MX_WB_TM_Congelado__c = false AND RecordTypeId =\'' + objLeads.RecordTypeId + '\''+' AND LeadSource =\''+objLeads.LeadSource + '\''+' AND MX_WB_ContadorRemarcado__c <= \''+ objLeads.MX_WB_ContadorRemarcado__c + '\''+'AND MX_WB_lst_EstatusBloqueado__c !=  \''+ noBloqueado+ '\''+'AND Id in (\''+ objCampaignMember.Id+ '\''+') limit '+sCantidadEnvio;
        objEnvioLeadsSCH.sQuery = sQuery;
        final String jobId = System.schedule('Test EnvioLeadsCTI_shc',CRON_EXP,objEnvioLeadsSCH);
        final CronTrigger cronTrig = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id =: jobId];

        System.assertEquals(0, cronTrig.TimesTriggered,'No hay ninguno en cola');

        objEnvioLeadsSCH.execute(null);

		Test.stopTest();

	}
}