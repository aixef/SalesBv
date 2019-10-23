/*
* BBVA - Mexico
* @Author: Diego Olvera
* MX_SB_VTS_APX_ReagendaLead_Test
* @Description: Provides test coverage for apex class MX_SB_VTS_APX_ReagendaLead
* @LastModifiedBy: Diego Olvera
* @Version: 1.0
*/
@isTest
private class MX_SB_VTS_APX_ReagendaLead_Test {
    /** variable operaciones */
    static String txtPost = 'POST', txtDescription = 'DESCRIPCION', txtServicio='SERVICEID', txtMsj='NOT iS EMPTY',
    txtUrl='http://www.example.com', txttelf='5511223344', txtUsername='UserOwnerTest01';
    /** lead name */
    final static String LEADNAME = 'Test Lead Hogar';
    /** nombre de usuario */
    final static String USERNAME = 'testHogar';
    /** nombre de manager */
    final static String MANAGER = 'Manager';
    /** email para usuarios */
    final static String EMAIL = 'test@bbva.com.smart';
    /** cadena vacia */
    final static string EMPTYSTR='';

    /** nombre de la opp */
    final static String OPPNAME = 'Test Opportunity Hogar';
    /** nombre de la opp */
    final static String NAMEOP = 'Test';
    /*
	* @Method: makeData
	* @Description: create test data set
	*/
    @TestSetup
    public static void makeData() {

        final User tManager = MX_WB_TestData_cls.crearUsuario(MANAGER, System.Label.MX_SB_VTS_ProfileAdmin);
        final User tUser = MX_WB_TestData_cls.crearUsuario(USERNAME, System.Label.MX_SB_VTS_ProfileAdmin);
        tUser.MX_SB_VTS_ProveedorCTI__c = 'SMART CENTER';
        insert tManager;
        tUser.ManagerId = tManager.Id;
        insert tUser;
        final MX_SB_VTS_ProveedoresCTI__c Proveedor = MX_WB_TestData_cls.crearProveedor(tUser.MX_SB_VTS_ProveedorCTI__c);
        insert proveedor;
        final MX_SB_VTS_Lead_tray__c Bandeja = MX_WB_TestData_cls.crearBandeja(System.Label.MX_SB_VTS_HotLeads,'1');
        insert Bandeja;
        final Group queu = new Group(Name = 'MX_SB_VTS_Reagenda', type='Queue');
        insert queu;
     	final Lead myLead = MX_WB_TestData_cls.vtsTestLead(LEADNAME, System.Label.MX_SB_VTS_Telemarketing_LBL);
        myLead.LeadSource = Label.MX_SB_VTS_OrigenCallMeBack;
        myLead.Email = EMAIL;
        insert myLead;
        final Task newTask  = MX_WB_TestData_cls.crearTarea(MyLead.ID,'Tarea en Lead test');
        insert newTask;
        myLead.MX_SB_VTS_LookActivity__c=newTask.Id;
        update mylead;
      	final Account acc = MX_WB_TestData_cls.createAccount('Test acc', System.Label.MX_SB_VTS_PersonRecord);
        insert acc;
        final Opportunity opp = MX_WB_TestData_cls.crearOportunidad('Test Opp Reagenda', acc.Id, tUser.Id, System.Label.MX_SB_VTS_Telemarketing_LBL);
        opp.Producto__c = 'Hogar';
        opp.Reason__c = 'Venta';
        insert opp;
        final Task nuevaTarea = MX_WB_TestData_cls.crearTarea(opp.Id,'Tarea en Opportunity test');
        insert nuevaTarea;
        opp.MX_SB_VTS_LookActivity__c=nuevaTarea.Id;
        update opp;
	    insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenters_Crear_Carga', iaso__Url__c = txtUrl, iaso__Cache_Partition__c = 'local.MXSBVTSCache');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'Authentication', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.MXSBVTSCache');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenter', iaso__Url__c = 'https://bbvacifrado.smartcenterservicios.com/ws_salesforce_desarrollo/api/login/authenticate', iaso__Cache_Partition__c = 'local.MXSBVTSCache');
    }
    /*
    * @Method: testGetUser
    * @Description: provides coverage for method finUsers
    */
    @isTest
    private static void testGetUsers() {
        final User  cUser=[SELECT ID,MX_SB_VTS_ProveedorCTI__c,Name FROM User  WHERE NAME = 'testHogar' LIMIT 1];
        System.runAs(cUser) {
            final object test = MX_SB_VTS_APX_ReagendaLead.getUsers();
            System.assertNotEquals(test, null,'El objeto no esta vacio');
        }
    }
    /** Recupera Lead */
    @isTest
    private static void testGetLead() {
        final User  cUser=[SELECT ID,MX_SB_VTS_ProveedorCTI__c,Name FROM User  WHERE NAME = 'testHogar' LIMIT 1];
        System.runAs(cUser) {
            Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_APX_ReagendaLeadMockClass());
            iaso.GBL_Mock.setMock(new MX_SB_VTS_APX_ReagendaLeadMockClass());
            final Id leadId = [SELECT Id FROM Lead LIMIT 1].ID;
            final Task testTask =[SELECT ID,FechaHoraReagenda__c FROM Task WHERE Subject = 'Tarea en Lead test' LIMIT 1];
            Test.startTest();
            MX_SB_VTS_APX_ReagendaLead.saveTask(testTask, false,leadId);
            Test.stopTest();
            System.assertEquals(testTask.WhoId, leadId, 'Lead Id');
        }
    }
    /** Recupera Lead 2 */
    @isTest
    private static void testGetLead2() {
        final User  cUser=[SELECT ID,MX_SB_VTS_ProveedorCTI__c,Name FROM User  WHERE NAME = 'testHogar' LIMIT 1];
        System.runAs(cUser) {
            Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_APX_ReagendaLeadMockClass());
            iaso.GBL_Mock.setMock(new MX_SB_VTS_APX_ReagendaLeadMockClass());
            final Id leadId = [SELECT Id FROM Lead LIMIT 1].ID;
            final Task testTask =[SELECT ID,FechaHoraReagenda__c FROM Task WHERE Subject = 'Tarea en Lead test' LIMIT 1];
            Test.startTest();
            MX_SB_VTS_APX_ReagendaLead.saveTask(testTask, true,leadId);
            Test.stopTest();
            System.assertEquals(testTask.WhoId, leadId, 'Lead Id');
        }
    }
    /** Error en Lead */
    @isTest
    private static void testGetLeadError() {
        final AuraHandledException err = new AuraHandledException(EMPTYSTR);
        final User  cUser=[SELECT ID,MX_SB_VTS_ProveedorCTI__c,Name FROM User  WHERE NAME = 'testHogar' LIMIT 1];
        System.runAs(cUser) {
            Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_APX_ReagendaLeadMockClass());
            iaso.GBL_Mock.setMock(new MX_SB_VTS_APX_ReagendaLeadMockClass());
            final Lead leadObj = [SELECT Id FROM Lead LIMIT 1];
            final Task testTask =[SELECT ID,FechaHoraReagenda__c FROM Task WHERE Subject = 'Tarea en Lead test' LIMIT 1];
            testTask.FechaHoraReagenda__c=Date.valueOf('12-12-12');
            test.startTest();
            try {
                MX_SB_VTS_APX_ReagendaLead.saveTask(testTask, true,leadObj.Id);
            } catch(Exception ex) {
                System.assertEquals(ex.getMessage(), err.getMessage(), 'Fallo esperado');
            }
            test.StopTest();

        }
    }
    /** Error al recuperar usuario */
    @isTest
    private static void testGetUserError() {
        final AuraHandledException err = new AuraHandledException(EMPTYSTR);
        try {
            MX_SB_VTS_APX_ReagendaLead.getUsers();
        } catch(System.AuraHandledException eAhEx) {
            System.assertEquals(eAhEx.getMessage() , err.getMessage(), 'Fallo');
        }
    }
    /** Error al recuperar opty */
    @isTest
    private static void testGetOpportunity() {
        final User  cUser=[SELECT ID,MX_SB_VTS_ProveedorCTI__c,Name FROM User  WHERE NAME = 'testHogar' LIMIT 1];
        System.runAs(cUser) {
            Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_APX_ReagendaLeadMockClass());
            iaso.GBL_Mock.setMock(new MX_SB_VTS_APX_ReagendaLeadMockClass());
            final String oppId = [select Id,MX_SB_VTS_LookActivity__c from Opportunity where Name = 'Test Opp Reagenda'].Id;
            final Task testTask =[SELECT Id,FechaHoraReagenda__c FROM Task WHERE Subject = 'Tarea en Opportunity test' LIMIT 1];
            Test.startTest();
            MX_SB_VTS_APX_ReagendaLead.saveTask(testTask, false,oppId);
            Test.stopTest();
            System.assertEquals(testTask.WhatId, oppId, 'Opportunity Id');
        }
    }
    /** Recupera oppty */
    @isTest
    private static void testGetOpportunity2() {
        final User  cUser=[SELECT ID,MX_SB_VTS_ProveedorCTI__c,Name FROM User  WHERE NAME = 'testHogar' LIMIT 1];
        System.runAs(cUser) {
            Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_APX_ReagendaLeadMockClass());
            iaso.GBL_Mock.setMock(new MX_SB_VTS_APX_ReagendaLeadMockClass());
            final String oppId = [select Id,MX_SB_VTS_LookActivity__c, Name from Opportunity where Name = 'Test Opp Reagenda'].Id;
            final Task testTask =[SELECT ID,FechaHoraReagenda__c FROM Task WHERE Subject = 'Tarea en Opportunity test' LIMIT 1];
            Test.startTest();
            MX_SB_VTS_APX_ReagendaLead.saveTask(testTask, true,oppId);
            Test.stopTest();
            System.assertEquals(testTask.WhatId, oppId, 'Opportunity Id');
        }
    }

    /** Fallo en opty */
    @isTest
    private static void testGetOpportunityError() {
        final AuraHandledException err = new AuraHandledException(EMPTYSTR);
        final User  cUser=[SELECT ID,MX_SB_VTS_ProveedorCTI__c,Name FROM User  WHERE NAME = 'testHogar' LIMIT 1];
        System.runAs(cUser) {
            Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_APX_ReagendaLeadMockClass());
            iaso.GBL_Mock.setMock(new MX_SB_VTS_APX_ReagendaLeadMockClass());
            final Opportunity oppObj = [SELECT Id, Name FROM Opportunity where Name = 'Test Opp Reagenda' LIMIT 1];
            final Task testTask =[SELECT Id,FechaHoraReagenda__c FROM Task WHERE Subject = 'Tarea en Opportunity test' LIMIT 1];
            testTask.FechaHoraReagenda__c=Date.valueOf('10-10-10');
            test.startTest();
            try {
                MX_SB_VTS_APX_ReagendaLead.saveTask(testTask, true,oppObj.Id);
            } catch(Exception ex) {
                System.assertEquals(ex.getMessage(), err.getMessage(), 'Fallo esperado');
            }
            test.StopTest();

        }
    }
}