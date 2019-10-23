/*
  @Class Name			: MX_WB_controllerMasterChecklist_tst
  @Description        	: Clase test Happy Path
  @Author             	: Eduardo Hernández Cuamatzi
  @Proyecto				: MW WB TLMKT - BBVA Bancomer
  @Last Modified By   	: Eduardo Hernández Cuamatzi
  ==============================================================================
  Ver         Date                     Author      		      	Modification
  ==============================================================================
  1.0    	02/08/2019 			Eduardo Hernández Cuamatzi		Versión inicial
  1.0.1    	02/12/2019 			Eduardo Hernández Cuamatzi		cobertura 100%
  1.0.2    	20/06/2019 			Eduardo Hernández Cuamatzi		Fix clase test para validar nombre correcto de Productos
*/
@isTest
private class MX_WB_controllerMasterChecklist_tst {

    @testSetup static void setup() {
        final String sysAdminString = System.Label.MX_SB_VTS_ProfileAdmin;
        final User uTelemarketing = MX_WB_TestData_cls.crearUsuario('Telemarketing1', sysAdminString);
        insert uTelemarketing;
        final Id idAgente = UserInfo.getUserId();
        final Account accountRecord = MX_WB_TestData_cls.crearCuenta('LastName', 'PersonAccount');
        accountRecord.OwnerId = uTelemarketing.Id;
        insert accountRecord;
        final MX_WB_FamiliaProducto__c objFamilyPro = MX_WB_TestData_cls.createProductsFamily ( 'ASD' );
        insert objFamilyPro;
        Product2 proTst = MX_WB_TestData_cls.productNew ( 'Auto Seguro Dinamico' );
        proTst.IsActive = true;
        proTst.MX_WB_FamiliaProductos__c = objFamilyPro.Id;
        insert proTst;
        final Opportunity opp = MX_WB_TestData_cls.crearOportunidad('LastName', accountRecord.Id, idAgente, 'ASD');
        opp.Producto__c = 'Auto Seguro Dinamico';
        insert opp;
        final MX_WB_preguntasEtapa__c createPreguntasEtapa = MX_WB_TestData_cls.createPreguntasEtapa('ObjecionesTest', 'Telemarketing', 'MX_WB_objecionesReales');
        insert createPreguntasEtapa;
        final Id recordTypeId = [Select Id,Name, DeveloperName from RecordType where DeveloperName = 'MX_WB_objecionesReales'].Id;
        final Master_Checklist__c createMasterCheck = MX_WB_TestData_cls.createMasterCheck('ObjecionesTest', recordTypeId, uTelemarketing.Id);
        insert createMasterCheck;
        final Opportunity_CheckList__c createOppChkLst = MX_WB_TestData_cls.createOppChkLst(createMasterCheck.Id, uTelemarketing.Id, opp.Id, false);
        insert createOppChkLst;
    }

    @isTest
    static void inicializaObjeciones() {
        final User uTelemarketing = [Select Id, LastName from User where LastName = 'Telemarketing1'];
        System.runAs(uTelemarketing) {
            final MX_WB_preguntasEtapa__c createPreguntasEtapa = MX_WB_TestData_cls.createPreguntasEtapa('ObjecionesTest', 'Telemarketing', 'MX_WB_objecionesReales');
            insert createPreguntasEtapa;
            final Id recordTypeId = [Select Id,Name, DeveloperName from RecordType where DeveloperName = 'MX_WB_objecionesReales'].Id;
            final Master_Checklist__c createMasterCheck = MX_WB_TestData_cls.createMasterCheck('ObjecionesTest', recordTypeId, uTelemarketing.Id);
            insert createMasterCheck;
            Test.startTest();
            	final List<sObject> inicializaObjeciones = MX_WB_controllerMasterChecklist_cls.inicializaObjeciones('ObjecionesTest');
            	System.assert(String.isNotEmpty(((Master_Checklist__c)inicializaObjeciones[0]).Name), 'Name vacío');
            Test.stopTest();
        }
    }
    
    @isTest
    static void inicializaObjecionesSobrecarga() {
        final MX_WB_FamiliaProducto__c objFamilyPro = MX_WB_TestData_cls.createProductsFamily ( 'ASD' );
        insert objFamilyPro;
        final Product2 proTst = MX_WB_TestData_cls.productNew ( 'Auto Seguro Dinámico' );
        proTst.IsActive = true;
        proTst.MX_WB_FamiliaProductos__c = objFamilyPro.Id;
        insert proTst;
        final User uTelemarketing = [Select Id, LastName from User where LastName = 'Telemarketing1'];
        final MX_WB_preguntasEtapa__c createPreguntasEtapa = MX_WB_TestData_cls.createPreguntasEtapa('ObjecionesTest', 'Telemarketing', 'MX_WB_objecionesReales');
        createPreguntasEtapa.MX_SB_VTS_Producto__c =  'Auto Seguro Dinámico';
        insert createPreguntasEtapa;
        final Id recordTypeId = [Select Id,Name, DeveloperName from RecordType where DeveloperName = 'MX_WB_objecionesReales'].Id;
        final Master_Checklist__c createMasterCheck = MX_WB_TestData_cls.createMasterCheck('ObjecionesTest', recordTypeId, uTelemarketing.Id);
        createMasterCheck.MX_WB_Producto__c = proTst.Id;
        insert createMasterCheck;
        System.runAs(uTelemarketing) {        
            Test.startTest();
            	final List<sObject> inicializaObjeciones = MX_WB_controllerMasterChecklist_cls.inicializaObjeciones('ObjecionesTest', 'Auto Seguro Dinámico');
            	System.assert(String.isNotEmpty(((Master_Checklist__c)inicializaObjeciones[0]).Name), 'Name vacío');
            Test.stopTest();
        }
    }

    @isTest
    static void guardaRespuestas() {
        final User uTelemarketing = [Select Id, LastName from User where LastName = 'Telemarketing1'];
        System.runAs(uTelemarketing) {
            Test.startTest();
             	final Opportunity opp = [Select Id from Opportunity];
                final Master_Checklist__c createMasterCheck = [Select Id,Name,RecordTypeId from Master_Checklist__c where Name = 'ObjecionesTest'];
                final MX_WB_controllerMasterChecklist_cls.RespuestasPar respuestasPar = new MX_WB_controllerMasterChecklist_cls.RespuestasPar();
                respuestasPar.Id = String.valueOf(createMasterCheck.Id);
                respuestasPar.Name = createMasterCheck.Name;
                respuestasPar.RecordTypeId = createMasterCheck.RecordTypeId;
                respuestasPar.check = false;
                final List<MX_WB_controllerMasterChecklist_cls.RespuestasPar> lstRespuestasPar = new List<MX_WB_controllerMasterChecklist_cls.RespuestasPar>();
                lstRespuestasPar.add(respuestasPar);
                final String jsonRespuestas = JSON.serialize(lstRespuestasPar);
                final Boolean guardaRespuestas = MX_WB_controllerMasterChecklist_cls.guardaRespuestas(jsonRespuestas, opp.Id);
                System.assert(guardaRespuestas, 'Error en guardaRespuestas');
            Test.stopTest();
        }
    }

    @isTest
    static void guardaRespuestasNoOwner() {
        final String sysAdminString = System.Label.MX_SB_VTS_ProfileAdmin;
        final User uTelemarketing = [Select Id, LastName from User where LastName = 'Telemarketing1'];
        final User uTelemarketing2 = MX_WB_TestData_cls.crearUsuario('Telemarketing 1', sysAdminString);
        insert uTelemarketing2;
        final Account accountRecord = MX_WB_TestData_cls.crearCuenta('LastName', 'PersonAccount');
        accountRecord.OwnerId = uTelemarketing.Id;
        insert accountRecord;
        final MX_WB_FamiliaProducto__c objFamilyPro = MX_WB_TestData_cls.createProductsFamily ( 'ASD' );
        insert objFamilyPro;
        Product2 proTst = MX_WB_TestData_cls.productNew ( 'Auto Seguro Dinamico' );
        proTst.IsActive = true;
        proTst.MX_WB_FamiliaProductos__c = objFamilyPro.Id;
        insert proTst;
        final Opportunity opp = MX_WB_TestData_cls.crearOportunidad('Test', accountRecord.Id, uTelemarketing2.Id, '');
        opp.Producto__c = 'Auto Seguro Dinamico';
        insert opp;
        final Id recordTypeId = [Select Id,Name, DeveloperName from RecordType where DeveloperName = 'MX_WB_objecionesReales'].Id;
        final Master_Checklist__c createMasterCheck = MX_WB_TestData_cls.createMasterCheck('ObjecionesTest', recordTypeId, uTelemarketing2.Id);
        insert createMasterCheck;
        final Opportunity_CheckList__c createOppChkLst = MX_WB_TestData_cls.createOppChkLst(createMasterCheck.Id, uTelemarketing2.Id, opp.Id, false);
        insert createOppChkLst;
        final MX_WB_controllerMasterChecklist_cls.RespuestasPar respuestasPar = new MX_WB_controllerMasterChecklist_cls.RespuestasPar();
        System.runAs(uTelemarketing) {
            	Test.startTest();
            	respuestasPar.Id = String.valueOf(createMasterCheck.Id);
                respuestasPar.Name = createMasterCheck.Name;
                respuestasPar.RecordTypeId = createMasterCheck.RecordTypeId;
                respuestasPar.check = false;
            	final List<MX_WB_controllerMasterChecklist_cls.RespuestasPar> lstRespuestasPar = new List<MX_WB_controllerMasterChecklist_cls.RespuestasPar>();
            	lstRespuestasPar.add(respuestasPar);
            	final String jsonRespuestas = JSON.serialize(lstRespuestasPar);
            	final Boolean guardaRespuestas = MX_WB_controllerMasterChecklist_cls.guardaRespuestas(jsonRespuestas, opp.Id);
            	System.assert(guardaRespuestas, 'Error en guardaRespuestas');
            Test.stopTest();
        }
    }

     @isTest
    static void guardaRespuestasNoResId() {
        final String sysAdminString = System.Label.MX_SB_VTS_ProfileAdmin;
       	final User uTelemarketing = MX_WB_TestData_cls.crearUsuario('Telemarketing 1', sysAdminString);
        insert uTelemarketing;
        final User uTelemarketing2 = MX_WB_TestData_cls.crearUsuario('Telemarketing 1', sysAdminString);
        insert uTelemarketing2;
        final Account accountRecord = MX_WB_TestData_cls.crearCuenta('LastName', 'PersonAccount');
        accountRecord.OwnerId = uTelemarketing.Id;
        insert accountRecord;
        final MX_WB_FamiliaProducto__c objFamilyPro = MX_WB_TestData_cls.createProductsFamily ( 'ASD' );
        insert objFamilyPro;
        Product2 proTst = MX_WB_TestData_cls.productNew ( 'Auto Seguro Dinamico' );
        proTst.IsActive = true;
        proTst.MX_WB_FamiliaProductos__c = objFamilyPro.Id;
        insert proTst;
        final Opportunity opp = MX_WB_TestData_cls.crearOportunidad('Test', accountRecord.Id, uTelemarketing2.Id, '');
        opp.Producto__c = 'Auto Seguro Dinamico';
        insert opp;
        final MX_WB_preguntasEtapa__c createPreguntasEtapa = MX_WB_TestData_cls.createPreguntasEtapa('ObjecionesTest', 'Telemarketing', 'MX_WB_objecionesReales');
        insert createPreguntasEtapa;
        final Id recordTypeId = [Select Id,Name, DeveloperName from RecordType where DeveloperName = 'MX_WB_objecionesReales'].Id;
        final Master_Checklist__c createMasterCheck = MX_WB_TestData_cls.createMasterCheck('ObjecionesTest', recordTypeId, uTelemarketing2.Id);
        insert createMasterCheck;
        final MX_WB_controllerMasterChecklist_cls.RespuestasPar respuestasPar = new MX_WB_controllerMasterChecklist_cls.RespuestasPar();
        System.runAs(uTelemarketing) {
            	Test.startTest();
            	respuestasPar.Id = String.valueOf(createMasterCheck.Id);
                respuestasPar.Name = createMasterCheck.Name;
                respuestasPar.RecordTypeId = createMasterCheck.RecordTypeId;
                respuestasPar.check = false;
            	final List<MX_WB_controllerMasterChecklist_cls.RespuestasPar> lstRespuestasPar = new List<MX_WB_controllerMasterChecklist_cls.RespuestasPar>();
            	lstRespuestasPar.add(respuestasPar);
            	final String jsonRespuestas = JSON.serialize(lstRespuestasPar);
            	final Boolean guardaRespuestas = MX_WB_controllerMasterChecklist_cls.guardaRespuestas(jsonRespuestas, opp.Id);
            	System.assert(guardaRespuestas, 'Error en guardaRespuestas');
            Test.stopTest();
        }
    }
}