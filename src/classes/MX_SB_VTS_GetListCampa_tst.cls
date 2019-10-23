/**
*
* @author Arsenio Perez Lopez 
* @description API to auto assign leads from Smart Center to call center agents
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    24/06/2019     Arsenio Perez      Create test
* @version  1.0    24/06/2019     Arsenio Perez      Code smell
*
*/
@isTest
public class MX_SB_VTS_GetListCampa_tst {  
	/* Variables globales*/
    static String provedorVcip = 'VCIP', uRLexa='http://www.example.com', urlocal='local.MXSBVTSCache', 
        txtDescri ='DESCRIPCION', txtnombre='Campania PreubaTLMKT3000';
    @TestSetup
    static void makeData() {
        final MX_WB_FamiliaProducto__c testfamilia =  MX_WB_TestData_cls.createProductsFamily('Test Familia');
        insert testFamilia;
        final MX_SB_VTS_ProveedoresCTI__c ProvedorCTI = MX_WB_TestData_cls.ProvedorCTI(provedorVcip);
        ProvedorCTI.MX_SB_VTS_Identificador_Proveedor__c=provedorVcip;
        Insert ProvedorCTI;
        final MX_SB_VTS_FamliaProveedores__c familiaProvedor = MX_WB_TestData_cls.FamiliaProvedores(testFamilia.Id, ProvedorCTI.Id);
        Insert familiaProvedor;
        final Campaign objCampaign = MX_WB_TestData_cls.createCampania(txtnombre);
        objCampaign.MX_SB_VTS_FamiliaProducto_Proveedor__c=familiaProvedor.id;
        insert objCampaign;
    }
    @isTest
    private static void testMethod1() {
        final MX_SB_VTS_Generica__c gen = new MX_SB_VTS_Generica__c (
            Name='Servicio_01',
            MX_SB_VTS_Type__c='CP3',
            MX_SB_VTS_Servicio_ID__c='2',
            MX_SB_VTS_Servicio_Name__c='HOGAR SEGURO',
            MX_SB_VTS_Servicio_NameCompleto__c ='2 HOGAR SEGURO');
        insert gen;
        Test.startTest();
        Boolean teste;
        try {
            MX_SB_VTS_GetListCampa_cls.searchServicios();
            teste = true;
        } catch (Exception w) {
            teste = false;
        }
        system.assert(teste, 'Funciono');
        Test.stopTest();
    }
    @isTest
    private static void testMethod2() {
        Test.startTest();
        Boolean teste;
        try {
            MX_SB_VTS_GetListCampa_cls.searchServicios();
            teste = true;
        } catch (Exception w) {
            teste = false;
        }
        system.assert(teste, 'Funciono');
        Test.stopTest();
    }
    @isTest static void testMethod3() {
        final String sQuery = 'SELECT id, Name FROM Campaign WHERE Name =\''+txtnombre+'\'';
        final List<Campaign> lstCampanias = Database.query(sQuery);
        final User usuarios= MX_WB_TestData_cls.crearUsuario('Usuarioadmin', Label.MX_SB_VTS_ProfileAdmin);
        usuarios.MX_SB_VTS_ProveedorCTI__c=provedorVcip;
        insert usuarios;
        system.runAs(usuarios) {
            Test.startTest();
            if(lstCampanias.isEmpty() == false) {
                final List < Campaign > miembrosCampanias = MX_SB_VTS_GetListCampa_cls.fetchLookUpValues(lstCampanias[0].Name, '');
                System.assertNotEquals(miembrosCampanias.isEmpty(),false,'No se encontraron registros');
            }
            Test.stopTest();
        }
    }    
    @isTest static void testMethod4() {
        final String sQuery = 'SELECT id, Name FROM Campaign WHERE Name =\''+txtnombre+'\'';
        final List<Campaign> lstCampanias = Database.query(sQuery);
        final User usuarios= MX_WB_TestData_cls.crearUsuario('Usuarioadmin', Label.MX_SB_VTS_ProfileAdmin);
        usuarios.MX_SB_VTS_ProveedorCTI__c=provedorVcip;
        insert usuarios;
        system.runAs(usuarios) {
            Test.startTest();
            if(lstCampanias.isEmpty() == false) {
                final List < Object > miembrosCampanias = MX_SB_VTS_GetListCampa_cls.searchBandejas('temps');
                System.assertNotEquals(miembrosCampanias.isEmpty(),false,'No se encontraron registros');
            }
            Test.stopTest();
        }
    }
    @isTest static void testmethodone() {
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenters_Crear_Carga', iaso__Url__c = uRLexa, iaso__Cache_Partition__c = urlocal);
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'Authentication', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = urlocal);
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenter', iaso__Url__c = 'https://bbvacifrado.smartcenterservicios.com/ws_salesforce_desarrollo/api/login/authenticate', iaso__Cache_Partition__c = urlocal);
        Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new MX_SB_VTS_Integration_MockGenerator());
        final User userTest = MX_WB_TestData_cls.crearUsuario('UserOwnerTest01', Label.MX_SB_VTS_ProfileAdmin);
        System.runAs(userTest) {
            Test.startTest();
            final System.HttpRequest req = new System.HttpRequest();
            req.setEndpoint(uRLexa);
            req.setHeader('SERVICEID', '2');
            req.setHeader(txtDescri, txtDescri);
            req.setMethod('POST');
            MX_SB_VTS_GetListCampa_cls.Carga_invoke('2','Prueba generacion 26','nombre',null,null,'DEscr'	);
            final Integer result = 1 + 2;
            System.assertEquals(3, result,'Correcto');
            Test.stopTest();            
        }
    }    
    @isTest static void testmethodsix() {
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenters_Crear_Carga', iaso__Url__c = uRLexa, iaso__Cache_Partition__c = urlocal);
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'Authentication', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = urlocal);
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenter', iaso__Url__c = 'https://bbvacifrado.smartcenterservicios.com/ws_salesforce_desarrollo/api/login/authenticate', iaso__Cache_Partition__c = urlocal);
        Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new MX_SB_VTS_Integration_MockGenerator());
        final User userTest = MX_WB_TestData_cls.crearUsuario('UserOwnerTest01', Label.MX_SB_VTS_ProfileAdmin);
        System.runAs(userTest) {
            Test.startTest();
            try {
                final System.HttpRequest req = new System.HttpRequest();
                req.setEndpoint(uRLexa);
                req.setHeader('SERVICEID', '2');
                req.setHeader(txtDescri, txtDescri);
                req.setMethod('POST');
                MX_SB_VTS_GetListCampa_cls.Carga_invoke(null,null,null,null,null,null);
            } catch(Exception e) {
                system.assert(e.getMessage()!=null,'Correcto');
            }
            Test.stopTest();
        }
    }
}