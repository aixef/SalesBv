/**
*
* @author Arsenio Perez Lopez
* @description API to auto assign leads from Smart Center to call center agents
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    24/07/2019     Arsenio Perez      Create API for Smart Center
* @version  1.0    24/07/2019     Arsenio Perez      Code smell
* @version  1.1    25/09/2019     Jaime Terrats      Class Update for new params
*/

@isTest
private class MX_SB_VTS_SMARTNOCONTACTO_tst {
    /** */
    final static String IDGRABACION = 'no contesto',
        IDCERTIFICACION ='',
        CALLID = '1',
        URI = '/services/apexrest/leadNoContacto',
        METHOD = 'POST',
        TXTCERTIFICADA ='Certificada', TXTTIDGRABACION='IDGrabacion',TXTTIPO='Tipo',TXTMOTIVO='MotivoNocontacto',
        TXTLEADID='LeadId';
    /** */
    @TestSetup
    static void makeData() {
        final User usr = MX_WB_TestData_cls.crearUsuario('Auto Assigner', system.label.MX_SB_VTS_ProfileAdmin);
        usr.RFC__c = 'LEAS190719VTS';
        Insert usr;
        final MX_WB_MotivosNoContacto__c no_cont = new MX_WB_MotivosNoContacto__c(
            Name='1', MX_SB_VTS_Nivel_1__c='1', MX_SB_VTS_Nivel_2__c='1', MX_SB_VTS_Nivel_3__c='1',
            MX_SB_VTS_Nivel_4__c='1', MX_SB_VTS_Nivel_5__c='1', MX_SB_VTS_Nivel_6__c='1',
            MX_SB_VTS_Nivel_7__c='1', MX_SB_VTS_Nivel_8__c='1', MX_SB_VTS_Nivel_9__c='1',
            MX_SB_VTS_Nivel_10__c='1', MX_SB_VTS_IDACCION__c=1, MX_WB_MotivoNoContacto__c='1',
            MX_SB_VTS_HoraDuracion__c=1
        );
        final MX_WB_MotivosNoContacto__c no_cont2 = new MX_WB_MotivosNoContacto__c(
            Name='2', MX_SB_VTS_Nivel_1__c='', MX_SB_VTS_Nivel_2__c='Creada', MX_SB_VTS_Nivel_3__c='',
            MX_SB_VTS_Nivel_4__c='', MX_SB_VTS_Nivel_5__c='', MX_SB_VTS_Nivel_6__c='',
            MX_SB_VTS_Nivel_7__c='', MX_SB_VTS_Nivel_8__c='', MX_SB_VTS_Nivel_9__c='',
            MX_SB_VTS_Nivel_10__c='', MX_SB_VTS_IDACCION__c=1, MX_WB_MotivoNoContacto__c='',
            MX_SB_VTS_HoraDuracion__c=1
        );
        insert no_cont;
        insert no_cont2;
        System.runAs(usr) {
            final Lead leadToAssign = MX_WB_TestData_cls.createLead('Lead Auto Assigner');
            insert leadToAssign;
            final Account accToAssign = MX_WB_TestData_cls.crearCuenta('Doe', 'PersonAccount');
            accToAssign.PersonEmail = 'test@test.com.leas';
            insert accToAssign;
            final Opportunity oppToAssign = MX_WB_TestData_cls.crearOportunidad('Opp Auto Assigner', accToAssign.Id, usr.Id, 'ASD');
            oppToAssign.Producto__c = 'Hogar';
            oppToAssign.Reason__c = 'Venta';
            insert oppToAssign;
        }
    }
    /** */
    @isTest
    private static void testNocontactoXcons() {
        test.startTest();
        Boolean tbolean = true;
        try {
        MX_SB_VTS_SMARTNOCONTACTO_cls x = new MX_SB_VTS_SMARTNOCONTACTO_cls(); //NOSONAR
        } catch(Exception s) {
            tbolean = false;
        }
        System.assert(tbolean, 'Correcto ');
        test.stopTest();
    }
    /** */
    @isTest
    private static void testNocontacto() {
        final Lead getLead = [select Id from Lead where Name = 'Lead Auto Assigner'];
        final RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf('{ "'+TXTLEADID+'": "' + getLead.Id + '", "'+TXTMOTIVO+'": "' + CALLID + '", "'+ TXTTIPO + '": "' + TXTMOTIVO + '", "'+TXTTIDGRABACION+'": "' + IDGRABACION +'", "'+TXTCERTIFICADA+'": "' + IDCERTIFICACION +'" }');
        request.requestURI = URI;
        request.httpMethod = METHOD;
        RestContext.request = request;
        Test.startTest();
        final String testAssigner = MX_SB_VTS_SMARTNOCONTACTO_cls.leadActionCont();
        System.assertNotEquals(testAssigner, System.Label.MX_WB_LG_ErrorBack, 'Exito testNocontacto');
        Test.stopTest();
    }
    /** */
    @isTest
    private static void testNocontacto2() {
        final RestRequest request = new RestRequest();
        final Lead getLead = [select Id from Lead where Name = 'Lead Auto Assigner'];
        request.requestURI = URI;
        request.httpMethod = METHOD;
        request.requestBody = Blob.valueOf('{ "'+TXTLEADID+'": "' + getLead.Id + '", "'+TXTMOTIVO+'": "' + CALLID + '", "'+ TXTTIPO + '": "Grabacion", "'+TXTTIDGRABACION+'": "' + IDGRABACION +'", "'+TXTCERTIFICADA+'": "' +IDCERTIFICACION+'" }');
        RestContext.request = request;
        Test.startTest();
        final String testAssigner = MX_SB_VTS_SMARTNOCONTACTO_cls.leadActionCont();
        System.assertNotEquals(testAssigner, System.Label.MX_WB_LG_ErrorBack, 'Exito testNocontacto2');
        Test.stopTest();
    }
    /** */
    @isTest
    private static void testNocontacto3() {
        final Lead getLead = [select Id from Lead where Name = 'Lead Auto Assigner'];
        final RestRequest request = new RestRequest();
		request.requestBody = Blob.valueOf('{ "'+TXTLEADID+'": "' + getLead.Id + '", "'+TXTMOTIVO+'": "' + CALLID + '", "'+ TXTTIPO + '": "", "'+TXTTIDGRABACION+'": "' + IDGRABACION +'", "'+TXTCERTIFICADA+'": "' + IDCERTIFICACION + '"}');
        request.httpMethod = METHOD;
        request.requestURI = URI;
        RestContext.request = request;
        Test.startTest();
        final String testAssigner = MX_SB_VTS_SMARTNOCONTACTO_cls.leadActionCont();
        System.assertEquals(testAssigner, System.Label.MX_WB_LG_ErrorBack, 'Exito testNocontacto3');
        Test.stopTest();
    }
    /** */
    @isTest
    private static void testNocontacto4() {
        final Lead getLead = [select Id from Lead where Name = 'Lead Auto Assigner'];
        getLead.MX_SB_VTS_Numero_de_Llamadas__c= 1;
        update getLead;
        final RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf('{ "'+TXTLEADID+'": "' + getLead.Id + '", "'+TXTMOTIVO+'": "' + CALLID + '", "'+ TXTTIPO + '": "' + TXTMOTIVO + '", "'+TXTTIDGRABACION+'": "' + IDGRABACION +'", "'+TXTCERTIFICADA+'": "' +IDCERTIFICACION+ '"}');
        request.requestURI = URI;
        request.httpMethod = METHOD;
        RestContext.request = request;
        Test.startTest();
        final String testAssigner = MX_SB_VTS_SMARTNOCONTACTO_cls.leadActionCont();
        System.assertNotEquals(testAssigner, System.Label.MX_WB_LG_ErrorBack, 'Exito testNocontacto4');
        Test.stopTest();
    }
    /** */
    @isTest
    private static void testNocontacto5() {
        final Task Tarea          = new Task();
        Tarea.Description   = 'Call';
        Tarea.Priority      = 'Normal';
        Tarea.Status        = 'No Iniciado';
        Tarea.Subject       = 'call';
        Tarea.MX_WB_idGrabacion__c='12345';
        insert Tarea;
        final Lead getLead = [select Id from Lead where Name = 'Lead Auto Assigner'];
        getLead.MX_SB_VTS_Numero_de_Llamadas__c= 1;
        update getLead;
        final RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf('{ "'+TXTLEADID+'": "' + getLead.Id + '", "'+TXTMOTIVO+'": "' + CALLID + '", "'+ TXTTIPO + '": "Grabacion", "'+TXTTIDGRABACION+'": "' + IDGRABACION +'", "'+TXTCERTIFICADA+'": "' + IDCERTIFICACION +'"}');
        request.requestURI = URI;
        request.httpMethod = METHOD;
        RestContext.request = request;
        Test.startTest();
        final String testAssigner = MX_SB_VTS_SMARTNOCONTACTO_cls.leadActionCont();
        System.assertNotEquals(testAssigner, System.Label.MX_WB_LG_ErrorBack, 'Exito testNocontacto5');
        Test.stopTest();
    }
    /** */
    @isTest
    private static void testNocontacto6() {
        final Opportunity getOppor = [select Id from Opportunity where Name = 'Opp Auto Assigner'];
        final RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf('{ "'+TXTLEADID+'": "' + getOppor.Id + '", "'+TXTMOTIVO+'": "' + CALLID + '", "'+ TXTTIPO + '": "' + TXTMOTIVO + '", "'+TXTTIDGRABACION+'": "' + IDGRABACION +'", "'+TXTCERTIFICADA+'": "'+IDCERTIFICACION+ '" }');
        request.requestURI = URI;
        request.httpMethod = METHOD;
        RestContext.request = request;
        Test.startTest();
        final String testAssigner = MX_SB_VTS_SMARTNOCONTACTO_cls.leadActionCont();
        System.assertNotEquals(testAssigner, System.Label.MX_WB_LG_ErrorBack, 'Exito testNocontacto6');
        Test.stopTest();
    }
    /** */
    @isTest
    private static void testNocontacto7() {
        final Opportunity getOppor = [select Id from Opportunity where Name = 'Opp Auto Assigner'];
        getOppor.MX_SB_VTS_ContadorRemarcado__c=1;
        update getOppor;
        final RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf('{ "'+TXTLEADID+'": "' + getOppor.Id + '", "'+TXTMOTIVO+'": "' + CALLID + '", "'+ TXTTIPO + '": "' + TXTMOTIVO + '", "'+TXTTIDGRABACION+'": "' + IDGRABACION +'", "'+TXTCERTIFICADA+'": "'+IDCERTIFICACION+'"}');
        request.requestURI = URI;
        request.httpMethod = METHOD;
        RestContext.request = request;
        Test.startTest();
        String testAssigner = MX_SB_VTS_SMARTNOCONTACTO_cls.leadActionCont();
        System.assertNotEquals(testAssigner, System.Label.MX_WB_LG_ErrorBack, 'Exito testNocontacto7');
        getOppor.MX_SB_VTS_ContadorRemarcado__c=5;
        update getOppor;
        testAssigner = MX_SB_VTS_SMARTNOCONTACTO_cls.leadActionCont();
        System.assertNotEquals(testAssigner, System.Label.MX_WB_LG_ErrorBack, 'Exito testNocontacto7_2');
        Test.stopTest();
    }
}
