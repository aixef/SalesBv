/**-------------------------------------------------------------------------
* Nombre: MX_SB_VTS_Hogar_Service_Test
* @author Jaime (JT)
* Proyecto: MX_Ventas - BBVA Bancomer
* Descripción : Clase test que sirve para la cobertura de la clase MX_SB_VTS_LeadAutoAssigner
*
* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* --------------------------------------------------------------------------
* @version 1.0           19/07/2019      Jaime T                   Creación
* @version 1.0           27/08/2019      Jaime T                   Codesmell
* --------------------------------------------------------------------------*/
@isTest
private class MX_SB_VTS_LeadAutoAssigner_Test {
    /*static var*/
    final static String TIPIFICACION = 'no contesto',
                        CALLID = '1',
                        URI = '/services/apexrest/leadAutoAssigner',
                        METHOD = 'POST';
    /**
    * Test setup method
     */
	@testSetup
    public static void makeData() {
       	final User usr = MX_WB_TestData_cls.crearUsuario('Auto Assigner', system.label.MX_SB_VTS_ProfileAdmin);
        usr.RFC__c = 'LEAS190719VTS';
        Insert usr;

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

    /**
    * Success test to assign lead
    */
    @isTest
    private static void testLeadAssignment() {
        final User usr = [select RFC__c from User where Name = 'Auto Assigner'];
        final Lead getLead = [select Id from Lead where Name = 'Lead Auto Assigner'];
        final String expectedURI = System.Url.getSalesforceBaseUrl().toExternalForm() + '/' + getLead.Id;
        final RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf('{ "recordId": "' + getLead.Id + '", "rfc": "' + usr.RFC__c + '", "callId": "' + CALLID + '", "tipificacion": "' + TIPIFICACION + '"}');
        request.requestURI = URI;
        request.httpMethod = METHOD;
        RestContext.request = request;
        Test.startTest();
        final String testLeadAutoAssigner = MX_SB_VTS_LeadAutoAssigner.assignLead();
        System.assertEquals(testLeadAutoAssigner, expectedURI, 'Exito');
        Test.stopTest();
    }

    /**
    * Success Test to assign opp
    */
    @isTest
    private static void testOppAssignment() {
        final User usr = [select RFC__c from User where Name = 'Auto Assigner'];
        final Opportunity getOpp = [select Id,MX_SB_VTS_LookActivity__c from Opportunity where Name = 'Opp Auto Assigner'];
        final String expectedURI = System.Url.getSalesforceBaseUrl().toExternalForm() + '/' + getOpp.Id;
        final RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf('{ "recordId": "' + getOpp.Id + '", "rfc": "' + usr.RFC__c + '", "callId": "' + CALLID + '", "tipificacion": "' + TIPIFICACION + '"}');
        request.httpMethod = METHOD;
        request.requestURI = URI;
        RestContext.request = request;
        Test.startTest();
        final String testLeadAutoAssigner = MX_SB_VTS_LeadAutoAssigner.assignLead();
        System.assertEquals(testLeadAutoAssigner, expectedURI, 'Exito');
        Test.stopTest();
    }
    /**
    * Fail scenario
    */
    @isTest
    private static void failTest() {
		final RestRequest request = new RestRequest();
		request.requestBody = Blob.valueOf('{ "recordId" : "", "rfc": "", "tipificacion":"", "callId":"" }');
        request.httpMethod = METHOD;
        request.requestURI = URI;
        RestContext.request = request;
        Test.startTest();
        final String testLeadAutoAssigner = MX_SB_VTS_LeadAutoAssigner.assignLead();
        System.assertEquals(testLeadAutoAssigner, System.Label.MX_WB_LG_ErrorBack, 'Fallo esperado');
        Test.stopTest();
    }
}
