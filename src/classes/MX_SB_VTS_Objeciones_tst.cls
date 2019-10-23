/**
 * @File Name          : MX_SB_VTS_Objeciones_tst.cls
 * @Description        : Clase test de MX_SB_VTS_Objeciones_cls
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              : BBVA
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 7/10/2019 20:38:36
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    12/9/2019   Eduardo Hernández Cuamatzi     Initial Version
**/
@isTest
private class MX_SB_VTS_Objeciones_tst {
    /** valor precio alto */
    final static String OBJECIONSTR= 'Precio Alto';
    /** valor objeciones reales */
    final static String OBJECIONTREALSTR= 'Objeciones Reales';
    /** valor objeciones */
    final static String OBJECIONTOBLSTR= 'Objeciones';
    /** valores iaso */
    final static String TXTPOST = 'POST', URLLOCAL = 'local.MXSBVTSCache',URLEXA='http://www.example.com';

    @TestSetup
    static void makeData() {//NOSONAR
        final User usr = MX_WB_TestData_cls.crearUsuario('Auto Assigner', System.label.MX_SB_VTS_ProfileAdmin);
        usr.RFC__c = 'LEAS190719VTS';
        insert usr;

        final Product2 proTst = MX_WB_TestData_cls.productNew ( 'Hogar' );
        proTst.IsActive = true;
        insert proTst;

        final Lead leadAuto = MX_WB_TestData_cls.vtsTestLead('TestObjec', System.Label.MX_SB_VTS_Telemarketing_LBL);
        leadAuto.OwnerId = usr.Id;
        insert leadAuto;

        final Task taskCall = MX_WB_TestData_cls.crearTarea(null, leadAuto.Id, System.Label.MX_SB_VTS_TaskCall, 'Llamada', 'No Iniciado');
        taskCall.Priority = 'Normal';
        insert taskCall;

        leadAuto.MX_SB_VTS_LookActivity__c = taskCall.Id;
        update leadAuto;

        final MX_SB_VTS_CatalogoObjeciones__c catObj = new MX_SB_VTS_CatalogoObjeciones__c();
        catObj.MX_SB_VTS_DetOjecion__c = 'Objecion1';
        catObj.MX_SB_VTS_NombreObjecion__c = OBJECIONSTR;
        catObj.MX_SB_VTS_ObjecionActiva__c = true;
        catObj.MX_SB_VTS_ProductoObjecion__c = proTst.Id;
        catObj.MX_SB_VTS_Relevancia__c = 1;
        catObj.MX_SB_VTS_TipoObjecion__c = OBJECIONTOBLSTR;
        insert catObj;

        final MX_SB_VTS_CatalogoObjeciones__c catObjR = new MX_SB_VTS_CatalogoObjeciones__c();
        catObjR.MX_SB_VTS_DetOjecion__c = 'Objecion det';
        catObjR.MX_SB_VTS_NombreObjecion__c = 'Mal trato';
        catObjR.MX_SB_VTS_ObjecionActiva__c = true;
        catObjR.MX_SB_VTS_ProductoObjecion__c = proTst.Id;
        catObjR.MX_SB_VTS_Relevancia__c = 1;
        catObjR.MX_SB_VTS_TipoObjecion__c = OBJECIONTOBLSTR;
        insert catObjR;

        final MX_SB_VTS_CatalogoObjeciones__c catObj2 = new MX_SB_VTS_CatalogoObjeciones__c();
        catObj2.MX_SB_VTS_DetOjecion__c = 'Objecion2';
        catObj2.MX_SB_VTS_NombreObjecion__c = OBJECIONSTR;
        catObj2.MX_SB_VTS_ObjecionActiva__c = true;
        catObj2.MX_SB_VTS_ProductoObjecion__c = proTst.Id;
        catObj2.MX_SB_VTS_Relevancia__c = 1;
        catObj2.MX_SB_VTS_TipoObjecion__c = OBJECIONTREALSTR;
        insert catObj2;

        final Account accToAssign = MX_WB_TestData_cls.crearCuenta('Doe', 'PersonAccount');
        accToAssign.PersonEmail = 'test@test.com.leas';
        insert accToAssign;

        final Opportunity oppTelemarketing = MX_WB_TestData_cls.crearOportunidad('OppTelemarketing', accToAssign.Id, usr.Id, System.Label.MX_SB_VTS_Telemarketing_LBL);
        oppTelemarketing.Producto__c = System.Label.MX_SB_VTS_Hogar;
        oppTelemarketing.Reason__c = 'Venta';
        insert oppTelemarketing;

        final Task taskCallOpp = MX_WB_TestData_cls.crearTarea(oppTelemarketing.Id, null, System.Label.MX_SB_VTS_TaskCall, 'Llamada', 'No Iniciado');
        taskCallOpp.Priority = 'Normal';
        insert taskCallOpp;
        oppTelemarketing.MX_SB_VTS_LookActivity__c = taskCallOpp.Id;
        update oppTelemarketing;

        final MX_SB_VTS_ProveedoresCTI__c smartProv = new MX_SB_VTS_ProveedoresCTI__c();
        smartProv.Name = 'Smart Center';
        smartProv.MX_SB_VTS_Identificador_Proveedor__c = 'SMART CENTER';
        smartProv.MX_SB_VTS_TieneSegmento__c = true;
        smartProv.MX_SB_VTS_IsReadyCTI__c = true;
        insert smartProv;

        final MX_SB_VTS_Lead_tray__c leadTray = new MX_SB_VTS_Lead_tray__c();
        leadTray.MX_SB_VTS_Description__c = 'HotLeads';
        leadTray.MX_SB_VTS_ID_Bandeja__c = '6';
        leadTray.MX_SB_VTS_ProveedorCTI__c = smartProv.Id;
        leadTray.MX_SB_VTS_Producto__c = proTst.Id;
        leadTray.MX_SB_VTS_Tipo_bandeja__c = 'HotLeads';
        leadTray.MX_SB_VTS_ServicioID__c = '2';
        insert leadTray;

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenters_Crear_Carga', iaso__Url__c = URLEXA, iaso__Cache_Partition__c = URLLOCAL);
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'Authentication', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = URLLOCAL);
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenter', iaso__Url__c = 'https://bbvacifrado.smartcenterservicios.com/ws_salesforce_desarrollo/api/login/authenticate', iaso__Cache_Partition__c = URLLOCAL);

    }

    @isTest
    private static void getObjeciones() {
        Test.startTest();
        final Lead leadRecord = [Select Id from Lead where LastName = 'TestObjec'];
        final Id activeCall = MX_SB_VTS_Objeciones_cls.getActiveCall(leadRecord.Id, true);
        final Map<String, Object> response = MX_SB_VTS_Objeciones_cls.getObjetions(leadRecord.Id, System.Label.MX_SB_VTS_Hogar, true);
        System.assertEquals(response.get('activeCall'), activeCall, 'Exito getObjeciones');
        Test.stopTest();
    }

    @isTest
    private static void getObjecionesOpp() {
        Test.startTest();
        final Opportunity oppRecord = [Select Id from Opportunity where Name = 'OppTelemarketing'];
        final Id activeCall = MX_SB_VTS_Objeciones_cls.getActiveCall(oppRecord.Id, false);
        final Map<String, Object> response = MX_SB_VTS_Objeciones_cls.getObjetions(oppRecord.Id, System.Label.MX_SB_VTS_Hogar, false);
        System.assertEquals(response.get('activeCall'), activeCall, 'Exito getObjecionesOpp');
        Test.stopTest();
    }

    @isTest
    private static void saveObjects() {
        Test.startTest();
        final Lead leadRecord = [Select Id from Lead where LastName = 'TestObjec'];
        final MX_SB_VTS_CatalogoObjeciones__c catOb = [Select Id, MX_SB_VTS_NombreObjecion__c, MX_SB_VTS_TipoObjecion__c
            from MX_SB_VTS_CatalogoObjeciones__c where MX_SB_VTS_NombreObjecion__c =: OBJECIONSTR AND MX_SB_VTS_TipoObjecion__c =: OBJECIONTOBLSTR];
        final Id activeCall = MX_SB_VTS_Objeciones_cls.getActiveCall(leadRecord.Id, true);
        final List<MX_SB_VTS_RegistroObjeciones__c> lstObjects = new List<MX_SB_VTS_RegistroObjeciones__c>();
        final MX_SB_VTS_RegistroObjeciones__c regOb = new MX_SB_VTS_RegistroObjeciones__c(
            MX_SB_VTS_CatObjecion__c = catOb.Id,
            MX_SB_VTS_LeadLook__c = leadRecord.Id,
            MX_SB_VTS_LookActivity__c = activeCall,
            MX_SB_VTS_NoUsoObjecion__c = false,
            MX_SB_VTS_ObjecionUtil__c = true,
            MX_SB_VTS_TipoObjecion__c = catOb.MX_SB_VTS_TipoObjecion__c
        );
        lstObjects.add(regOb);
        MX_SB_VTS_Objeciones_cls.saveObjectionscls(lstObjects);
        final MX_SB_VTS_RegistroObjeciones__c regObj = [Select Id,MX_SB_VTS_CatObjecion__r.MX_SB_VTS_NombreObjecion__c from MX_SB_VTS_RegistroObjeciones__c where MX_SB_VTS_LeadLook__c =: leadRecord.Id];
        System.assertEquals(catOb.MX_SB_VTS_NombreObjecion__c, regObj.MX_SB_VTS_CatObjecion__r.MX_SB_VTS_NombreObjecion__c, 'Exito saveObjeciones');
        Test.stopTest();

    }

    @isTest
    private static void saveObjectsOpp() {
        Test.startTest();
        final Opportunity oppRecrod = [Select Id from Opportunity where Name = 'OppTelemarketing'];
        final MX_SB_VTS_CatalogoObjeciones__c catOb = [Select Id, MX_SB_VTS_NombreObjecion__c, MX_SB_VTS_TipoObjecion__c
            from MX_SB_VTS_CatalogoObjeciones__c where MX_SB_VTS_NombreObjecion__c =: OBJECIONSTR AND MX_SB_VTS_TipoObjecion__c =: OBJECIONTREALSTR];
        final Id activeCall = MX_SB_VTS_Objeciones_cls.getActiveCall(oppRecrod.Id, false);
        final List<MX_SB_VTS_RegistroObjeciones__c> lstObjects = new List<MX_SB_VTS_RegistroObjeciones__c>();
        final MX_SB_VTS_RegistroObjeciones__c regOb = new MX_SB_VTS_RegistroObjeciones__c(
            MX_SB_VTS_CatObjecion__c = catOb.Id,
            MX_SB_VTS_ObjecionOpp__c = oppRecrod.Id,
            MX_SB_VTS_LookActivity__c = activeCall,
            MX_SB_VTS_NoUsoObjecion__c = false,
            MX_SB_VTS_ObjecionUtil__c = true,
            MX_SB_VTS_TipoObjecion__c = catOb.MX_SB_VTS_TipoObjecion__c
        );
        lstObjects.add(regOb);
        MX_SB_VTS_Objeciones_cls.saveObjectionscls(lstObjects);
        final MX_SB_VTS_RegistroObjeciones__c regObj = [Select Id,MX_SB_VTS_CatObjecion__r.MX_SB_VTS_NombreObjecion__c from MX_SB_VTS_RegistroObjeciones__c where MX_SB_VTS_ObjecionOpp__c =: oppRecrod.Id];
        System.assertEquals(catOb.MX_SB_VTS_NombreObjecion__c, regObj.MX_SB_VTS_CatObjecion__r.MX_SB_VTS_NombreObjecion__c, 'Exito saveObjeOpp');
        Test.stopTest();
    }

    @isTest
    private static void getSavedRecObjs() {
        final Lead leadRecord = [Select Id from Lead where LastName = 'TestObjec'];
        final MX_SB_VTS_CatalogoObjeciones__c catOb = [Select Id, MX_SB_VTS_NombreObjecion__c, MX_SB_VTS_TipoObjecion__c
            from MX_SB_VTS_CatalogoObjeciones__c where MX_SB_VTS_NombreObjecion__c =: 'Mal trato' AND MX_SB_VTS_TipoObjecion__c =: OBJECIONTOBLSTR];
        final Id activeCall = MX_SB_VTS_Objeciones_cls.getActiveCall(leadRecord.Id, true);
        final MX_SB_VTS_RegistroObjeciones__c regOb = new MX_SB_VTS_RegistroObjeciones__c(
            MX_SB_VTS_CatObjecion__c = catOb.Id,
            MX_SB_VTS_LeadLook__c = leadRecord.Id,
            MX_SB_VTS_LookActivity__c = activeCall,
            MX_SB_VTS_NoUsoObjecion__c = false,
            MX_SB_VTS_ObjecionUtil__c = true,
            MX_SB_VTS_TipoObjecion__c = catOb.MX_SB_VTS_TipoObjecion__c
        );
        insert regOb;
        Test.startTest();
            final Map<String, Object> response = MX_SB_VTS_Objeciones_cls.getObjetions(leadRecord.Id, System.Label.MX_SB_VTS_Hogar, true);
            System.assertEquals(response.get('activeCall'), activeCall, 'Exito getSaveRecords');
        Test.stopTest();
    }

    @isTest
    private static void errorGetObjects() {
        Test.startTest();
            try {
                MX_SB_VTS_Objeciones_cls.getObjetions('', System.Label.MX_SB_VTS_Hogar, true);
            } catch (AuraHandledException auEx) {
                auEx.setMessage(System.Label.MX_WB_lg_TlmktError);
                System.assertEquals(auEx.getMessage(), System.Label.MX_WB_lg_TlmktError, 'Fallo esperado');
            }
        Test.stopTest();
    }
    
    @isTest
    private static void updateLeadsTray() {
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_Integration_MockGenerator());
            iaso.GBL_Mock.setMock(new MX_SB_VTS_Integration_MockGenerator());
            final Id bandejaId = [Select Id from MX_SB_VTS_Lead_tray__c where MX_SB_VTS_ID_Bandeja__c = '6'].Id;
            final Map<String, Object> response = MX_SB_VTS_Objeciones_cls.updateLeadsTray(bandejaId);
            System.assert((Boolean)response.get('isOk'), 'Guardado');
        Test.stopTest();
    }
}
