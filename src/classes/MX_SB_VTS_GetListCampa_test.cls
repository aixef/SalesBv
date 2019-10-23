/**-------------------------------------------------------------------------
* Nombre: MX_SB_VTS_GetListCampa_test
* @author Julio Medellín Oliva
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Description : Test class for MX_SB_VTS_GetListCampa_cls

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           03/10/2019      julio Medellin Oliva            Creación
* --------------------------------------------------------------------------*/
@isTest
public class MX_SB_VTS_GetListCampa_test {
    /** se usa para tipo de accion */
    final static String DESCRIPCION='LOADID';
    /** id del servicio */
    final static String NAM='SERVICEID';
    /** id de la campania */
    static String idCampa;
    /** id del producto */
    static String idProducto;
    /** descripcion para la prueba */
    final static String DESCRIP='A description for the Test';
    /** nombre para test user */
    final static String ADMINNAME='ADMIN1';
    /** mensaje de assert */
    final static String EXITO = 'Exito';
    /**Request service */
    final static String TXTPOST = 'POST', URLLOCAL = 'local.MXSBVTSCache',URLEXA='http://www.example.com';
    /** make test data method */
    @TestSetup
    private static void createTestData() {
        test.startTest();
        final User admin = MX_WB_TestData_cls.crearUsuario(ADMINNAME, system.label.MX_SB_VTS_ProfileAdmin);
        Insert admin;

        System.runAs(admin) {
            final Campaign cam =     MX_WB_TestData_cls.createCampania('Camp1');
            insert cam;
            idCampa = cam.Id;
            final Product2 pro =   MX_WB_TestData_cls.crearProducto('Product1','FamilyProduct');
            insert Pro;
            idProducto = Pro.Id;
            final MX_SB_VTS_Lead_tray__c ban =   MX_WB_TestData_cls.crearBandeja('TrackingWeb','Bandeja1');
            ban.MX_SB_VTS_Campa_a_relacionada__c=cam.Id;
            insert ban;
            final MX_SB_VTS_Generica__c objGenerica = MX_WB_TestData_cls.GeneraGenerica('Generica1', 'CP3');
            insert objGenerica;

        }
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenters_Crear_Carga', iaso__Url__c = URLEXA, iaso__Cache_Partition__c = URLLOCAL);
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'Authentication', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = URLLOCAL);
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenter', iaso__Url__c = 'https://bbvacifrado.smartcenterservicios.com/ws_salesforce_desarrollo/api/login/authenticate', iaso__Cache_Partition__c = URLLOCAL);

        test.stopTest();
    }

    /** happy path first scenario */
    public testMethod static void positive1() {
        Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new MX_SB_VTS_Integration_MockGenerator());
        Test.startTest();
        final System.HttpRequest req = new System.HttpRequest();
        req.setEndpoint(URLEXA);
        req.setHeader(DESCRIPCION, DESCRIPCION);
        req.setHeader(NAM, '2');
        req.setMethod(TXTPOST);
        system.assertEquals('9',MX_SB_VTS_GetListCampa_cls.Carga_invoke('2',DESCRIPCION, NAM,  idCampa, idProducto, DESCRIP), EXITO);
        test.stopTest();
    }

    /** happy path 2nd scenario */
    public testMethod static void positive2() {
        Test.startTest();
        System.assertNotEquals(Null, MX_SB_VTS_GetListCampa_cls.fetchLookUpValues('Bandeja1','Lead'),EXITO);
        test.stopTest();
    }
    /** happy path 3rd scenario */
    public testMethod static void positive3() {
        Test.startTest();
        Campaign camp = [SELECT ID FROM Campaign WHERE NAME = 'Camp1'];
        System.AssertNotEquals(null,MX_SB_VTS_GetListCampa_cls.searchBandejas(camp.Id),EXITO);
        test.stopTest();
    }
    /** happy path 4th scenario */
    public testMethod static void positive4() {
        Test.startTest();
        System.AssertNotEquals(null,MX_SB_VTS_GetListCampa_cls.searchServicios(),EXITO);
        test.stopTest();
    }
}
