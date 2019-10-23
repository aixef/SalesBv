@isTest
/** Creacion de clase OppUpdEnvEmail_tst*/
private class OppUpdEnvEmail_tst {
     @TestSetup
    static void  sendCTI() {
        final MX_WB_CredencialesCTI__c credenciales = new MX_WB_CredencialesCTI__c();
        credenciales.MX_WB_Usuario__c ='testwibewt';
        credenciales.MX_WB_Contrasenia__c ='p-wajU!8ebR7';
        credenciales.Name ='Seguro de Auto1';
        insert credenciales;
    }
	
	@isTest static void test_method_two() { 	
        final OppUpdEnvEmailSch_cls objOppUpdEnvEmailSch = new OppUpdEnvEmailSch_cls();
        objOppUpdEnvEmailSch.sMinuto = ''; 
        objOppUpdEnvEmailSch.minutoCreada = '';
        objOppUpdEnvEmailSch.minutoFormalizada = '';
        objOppUpdEnvEmailSch.minutoTarificada = '';
        objOppUpdEnvEmailSch.isCupon = false;
        
		Test.startTest();
		final String CRON_EXP = '0 0 0 15 3 ? 2022';
		final String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP, objOppUpdEnvEmailSch);
		final CronTrigger ct = [SELECT Id, CronExpression FROM CronTrigger WHERE id = :jobId];
		Test.stopTest();        
        System.assertEquals(CRON_EXP, ct.CronExpression);
	}	
}