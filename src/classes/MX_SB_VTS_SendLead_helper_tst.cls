/**-------------------------------------------------------------------------
* Nombre: MX_SB_VTS_SMARTCENTER_cargaBase_cls
* @author Vincent Juárez
* Proyecto: MW SB VTS - BBVA
* Descripción : Clase de ayuda para el componente de envio de leads

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           02/05/2019      Vincent Juárez           Creación
* @version 1.0           27/08/2019      Arsenio Perez            Code smell
* --------------------------------------------------------------------------*/
@isTest
public class MX_SB_VTS_SendLead_helper_tst {
    /* Variables de apoyo*/
    static String txtPost = 'POST', txtDescription = 'DESCRIPCION', txtServicio='SERVICEID', txtMsj='NOT iS EMPTY',
        txtUrl='http://www.example.com', txttelf='5511223344', txtUsername='UserOwnerTest01';

    @TestSetup
    static void makeData() {
        final User usr = MX_WB_TestData_cls.crearUsuario('Auto Assigner', system.label.MX_SB_VTS_ProfileAdmin);
        usr.RFC__c = 'LEAS190719VTS';
        Insert usr;

        System.runAs(usr) {
            final Lead leadToAssign = MX_WB_TestData_cls.createLead('Lead Auto Assigner');
            leadToAssign.MX_WB_ph_Telefono1__c=txttelf;
            leadToAssign.MX_WB_ph_Telefono2__c='5511223345';
            leadToAssign.MX_WB_ph_Telefono3__c='5511223346';
            insert leadToAssign;
            final Lead leadToAssign2 = MX_WB_TestData_cls.createLead('Lead Auto Assigner2');
            leadToAssign2.MX_WB_ph_Telefono1__c=txttelf;
            leadToAssign2.MX_WB_ph_Telefono2__c='5511223345';
            leadToAssign2.MX_WB_ph_Telefono3__c='5511223346';
            insert leadToAssign2;
            final Lead leadToAssign3 = MX_WB_TestData_cls.createLead('Lead Auto Assigner3');
            leadToAssign3.MX_WB_ph_Telefono1__c=txttelf;
            leadToAssign3.MX_WB_ph_Telefono2__c='5511223345';
            leadToAssign3.MX_WB_ph_Telefono3__c='5511223346';
            insert leadToAssign3;
            final Account accToAssign = MX_WB_TestData_cls.crearCuenta('Doe', 'PersonAccount');
            accToAssign.PersonEmail = 'test@test.com.leas';
            insert accToAssign;
            final Opportunity oppToAssign = MX_WB_TestData_cls.crearOportunidad('Opp Auto Assigner', accToAssign.Id, usr.Id, 'ASD');
            oppToAssign.Producto__c = 'Hogar';
            oppToAssign.Reason__c = 'Venta';
            oppToAssign.TelefonoCliente__c= txttelf;
            insert oppToAssign;
        	insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenters_Crear_Carga', iaso__Url__c = txtUrl, iaso__Cache_Partition__c = 'local.MXSBVTSCache');
        	insert new iaso__GBL_Rest_Services_Url__c(Name = 'Authentication', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.MXSBVTSCache');
        	insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenter', iaso__Url__c = 'https://bbvacifrado.smartcenterservicios.com/ws_salesforce_desarrollo/api/login/authenticate', iaso__Cache_Partition__c = 'local.MXSBVTSCache');
        }
    }
    /** */
        @isTest
    static void testmethodcero() {
        Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new MX_SB_VTS_Integration_MockGenerator());
        final User userTest = MX_WB_TestData_cls.crearUsuario(txtUsername, system.label.MX_SB_VTS_ProfileAdmin);
        System.runAs(userTest) {
            Test.startTest();
            final System.HttpRequest req = new System.HttpRequest();
            req.setEndpoint(txtUrl);
            req.setHeader(txtServicio, '2');
            req.setMethod('GET');
            final Map<String,Object> temp = MX_SB_VTS_SendLead_helper_cls.Consulta_Carga_invoke('{"SERVICEID": "2"}');
        	System.assert(!temp.isEmpty(),txtMsj);
            Test.stopTest();
        }
    }
    /** */
    @isTest
    static void testmethodone() {
        Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new MX_SB_VTS_Integration_MockGenerator());
        final User userTest = MX_WB_TestData_cls.crearUsuario(txtUsername, system.label.MX_SB_VTS_ProfileAdmin);
        System.runAs(userTest) {
            Test.startTest();
            final System.HttpRequest req = new System.HttpRequest();
            req.setEndpoint(txtUrl);
       		req.setHeader(txtDescription, txtDescription);
            req.setHeader(txtServicio, '2');
            req.setMethod(txtPost);
            final Map<String,Object> tem = MX_SB_VTS_SendLead_helper_cls.Crear_Carga_invoke('2','Prueba generacion 26');
        	System.assert(!tem.isEmpty(),txtMsj);
            Test.stopTest();
        }
    }
    /** */
    @isTest
    static void testmethodtwo() {
        Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new MX_SB_VTS_Integration_MockGenerator());
        final User userTest = MX_WB_TestData_cls.crearUsuario(txtUsername, system.label.MX_SB_VTS_ProfileAdmin);
        System.runAs(userTest) {
            Test.startTest();
            final System.HttpRequest req = new System.HttpRequest();
            req.setMethod(txtPost);
            req.setEndpoint(txtUrl);
            req.setHeader(txtServicio, '2');
       		req.setHeader(txtDescription, txtDescription);
			final List<Lead> leadTemp = [select id, MX_WB_ph_Telefono1__c, MX_WB_ph_Telefono2__c, MX_WB_ph_Telefono3__c from Lead where MX_WB_ph_Telefono1__c not in ('') and MX_WB_ph_Telefono2__c not in ('') and MX_WB_ph_Telefono3__c not in ('') limit 3];
            final Map<Id, String> data = new Map<Id, String>();
            data.put(leadTemp[0].Id, '15/04/2019 05:20:00');
            final Map<String,Object> tem = MX_SB_VTS_SendLead_helper_cls.EntRegistroGestion_invoke('EntRegistroGestion', leadTemp,'','2','6', data);
        	System.assert(!tem.isEmpty(),txtMsj);
            Test.stopTest();
        }
    }
    /** */
    @isTest
    static void testmethodthree() {
        Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new MX_SB_VTS_Integration_MockGenerator());
        final User userTest = MX_WB_TestData_cls.crearUsuario(txtUsername, system.label.MX_SB_VTS_ProfileAdmin);
        System.runAs(userTest) {
            Test.startTest();
            final System.HttpRequest req = new System.HttpRequest();
            req.setEndpoint(txtUrl);
            req.setHeader(txtDescription, txtDescription);
            req.setHeader(txtServicio, '2');
            req.setMethod(txtPost);
			final List<Lead> leadTemp = [select id, MX_WB_ph_Telefono1__c, MX_WB_ph_Telefono2__c, MX_WB_ph_Telefono3__c from Lead where MX_WB_ph_Telefono1__c not in ('') and MX_WB_ph_Telefono2__c not in ('') and MX_WB_ph_Telefono3__c not in ('') limit 3];
            final Map<Id, String> data = new Map<Id, String>();
            data.put(leadTemp[0].Id, '16/04/2019 05:20:00');
            final Map<String,Object> tem = MX_SB_VTS_SendLead_helper_cls.EntRegistroGestion_invoke('EntRegistroGestion', leadTemp,'','2','6', data);
        	System.assert(!tem.isEmpty(),txtMsj);
            Test.stopTest();
        }
    }
    /** */
    @isTest
    static void testmethodfour() {
        Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new MX_SB_VTS_Integration_MockGenerator());
        final User userTest = MX_WB_TestData_cls.crearUsuario(txtUsername, system.label.MX_SB_VTS_ProfileAdmin);
        System.runAs(userTest) {
            Test.startTest();
            final System.HttpRequest req = new System.HttpRequest();
            req.setEndpoint(txtUrl);
            req.setHeader(txtServicio, '2');
            req.setMethod('GET');
            req.setHeader('DESCRIPCION', 'DESCRIPCION');
            final HttpResponse HttpRest= iaso.GBL_Integration_GenericService.invoke('ConsultaCarga', '{"SERVICEID": "2"}');
            final Map<String,Object> tem = (Map<String,Object>) JSON.deserializeUntyped(HttpRest.getBody());
        	System.assert(!tem.isEmpty(),txtMsj);
            Test.stopTest();
        }
    }
    /** */
    @isTest
    static void testmethodfive() {
        Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new MX_SB_VTS_Integration_MockGenerator());
        final User userTest = MX_WB_TestData_cls.crearUsuario(txtUsername, system.label.MX_SB_VTS_ProfileAdmin);
        System.runAs(userTest) {
            Test.startTest();
            final System.HttpRequest req = new System.HttpRequest();
            req.setHeader(txtServicio, '2');
       		req.setHeader(txtDescription, txtDescription);
            req.setMethod(txtPost);
            req.setEndpoint(txtUrl);
			final List<Opportunity> leadTemp = [select id, TelefonoCliente__c from Opportunity where TelefonoCliente__c not in ('') limit 3];
            final Map<Id, String> data = new Map<Id, String>();
            data.put(leadTemp[0].Id, '17/04/2019 05:20:00');
			final Map<String,Object>   tem = MX_SB_VTS_SendLead_helper_cls.EntRegistroGestion_invoke('EntRegistroGestion', leadTemp,'','2','6', data);
        	System.assert(!tem.isEmpty(),txtMsj);
            Test.stopTest();
        }
    }
}
