/**-------------------------------------------------------------------------
* Nombre: MX_WB_TM_Cotizador_tst
* Autor Ing. Daniel Goncalves
* Proyecto: MW WB TLMK - BBVA Bancomer
* Descripción : Clase Test de MX_WB_TM_Cotizador_cls

* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           15/01/2019      Ing. Daniel Goncalves   Creación
* 1.1           11/02/2019      Ing. Daniel Goncalves   Cobertura al 95%
* 1.2           11/02/2019      Ing. Daniel Goncalves   Correcciones Asserts Pull #130
* 1.3           18/06/2019      Vincent Juárez          Prueba de clase crearURLCotNum
* 1.3.1         24/06/2019      Vincent Juárez        Fix proceso productos
* --------------------------------------------------------------------------
**/
@isTest
public class MX_WB_TM_Cotizador_tst {
    /**
    * Setup the data for the tests
    * @return List String
    **/
    @testSetup static void setup() {
        final User testUser = MX_WB_TestData_cls.crearUsuario ( 'TestLastName', label.MX_SB_VTS_ProfileAdmin); //System Administrator Administrador del sistema
        insert testUser;
        final MX_WB_FamiliaProducto__c objFamilyPro = MX_WB_TestData_cls.createProductsFamily ( 'ASD' );
        insert objFamilyPro;
        final List<Product2> lstProd = new List<Product2>();
        Product2 proTst = MX_WB_TestData_cls.productNew ( 'Seguro de Moto Bancomer' );
        proTst.IsActive = true;
        proTst.MX_WB_FamiliaProductos__c = objFamilyPro.Id;
        lstProd.add(proTst);
        proTst = MX_WB_TestData_cls.productNew ( 'Seguro Fronterizo' );
        proTst.IsActive = true;
        proTst.MX_WB_FamiliaProductos__c = objFamilyPro.Id;
        lstProd.add(proTst);
        proTst = MX_WB_TestData_cls.productNew ( 'Auto Seguro Dinamico' );
        proTst.IsActive = true;
        proTst.MX_WB_FamiliaProductos__c = objFamilyPro.Id;
        lstProd.add(proTst);
        proTst = MX_WB_TestData_cls.productNew ( 'Auto Seguro Dinámico' );
        proTst.IsActive = true;
        proTst.MX_SB_SAC_Proceso__c = 'VTS';
        proTst.MX_WB_FamiliaProductos__c = objFamilyPro.Id;
        lstProd.add(proTst);
        proTst = MX_WB_TestData_cls.productNew ( 'PRUEBA' );
        proTst.IsActive = true;
        proTst.MX_WB_FamiliaProductos__c = objFamilyPro.Id;
        lstProd.add(proTst);
        insert lstProd;
        MX_WB_TestData_cls.createStandardPriceBook2 ();
        final campaign objCamp = MX_WB_TestData_cls.createCampania ('TstCampaing');
        objCamp.MX_WB_FamiliaProductos__c = objFamilyPro.Id;
        insert objCamp;
        final PricebookEntry objPriBooEnt = MX_WB_OppoLineItemUtil_cls.crearPricebookEntry (lstProd[0].Id , 0);
        insert objPriBooEnt;

        final Account accRec = MX_WB_TestData_cls.crearCuenta ( 'LastName', 'PersonAccount' );
        accRec.OwnerId = testUser.Id;
        accRec.Correo_Electronico__c = 'prueba@wibe.com';
        accRec.CodigoPostal__c = '11520';
        accRec.PersonEmail ='prueba@wibe.com';
        accRec.PersonMobilePhone ='5512345162';
        accRec.BillingPostalCode = '11520';
        insert accRec;
        final Opportunity oppRec = MX_WB_TestData_cls.crearOportunidad ( 'Test', accRec.Id, testUser.Id, 'MX_WB_RT_Telemarketing' );
        oppRec.FolioCotizacion__c = null;
        oppRec.TelefonoCliente__c = '5580808080';
        insert oppRec;
        final OpportunityLineItem objOppLin = MX_WB_OppoLineItemUtil_cls.crearOpportunityLineItem ( oppRec , objPriBooEnt );
        insert objOppLin;
    }

    @isTest
    static void initDataQuotes() {
        final Opportunity objOppTst = [ SELECT Id,AccountId, MX_WB_Producto__c, FolioCotizacion__c, RecordTypeId FROM Opportunity LIMIT 1 ];
        final Product2 productASD = [Select Id from Product2 where Name = 'Auto Seguro Dinamico'];
        objOppTst.Producto__c = 'Auto Seguro Dinámico';
        objOppTst.MX_WB_Producto__c = productASD.Id;
        update objOppTst;
        final String jsonOpp = JSON.serialize(objOppTst);
        Test.startTest();
        final Map<String, Object> response  = MX_WB_TM_Cotizador_cls.initDataQuotes(jsonOpp);
        System.assert ( response.size() > 1, true);
        Test.stopTest();
    }

    /**
    * Prueba que crea la URL CASO EXITO Seguro Moto Bancomer
    **/
    @isTest static void crearURLSuccessCaseSMBtst() {
        final Opportunity objOppTst = [ SELECT Id,AccountId, MX_WB_Producto__c, FolioCotizacion__c, RecordTypeId FROM Opportunity LIMIT 1 ];
        final Product2 productASD = [Select Id from Product2 where Name = 'Auto Seguro Dinamico'];
        objOppTst.Producto__c = 'Auto Seguro Dinámico';
        objOppTst.MX_WB_Producto__c = productASD.Id;
        update objOppTst;
        final PricebookEntry objPriBooEntASD = MX_WB_OppoLineItemUtil_cls.crearPricebookEntry (productASD.Id , 1.00);
        insert objPriBooEntASD;
        Test.startTest();
        MX_WB_TM_Cotizador_cls.addProduct ( objOppTst.Id, productASD.Id);
        final Quote quoteId = [Select Id from Quote];
        final String urlTst = MX_WB_TM_Cotizador_cls.crearURL ( quoteId.Id );
        System.assertEquals(urlTst.contains( quoteId.Id ), false);
        Test.stopTest();
    }   

    /**
    * Prueba que agrega el Producto a la Oportunidad SUCCESS CASE
    **/
    @isTest static void addProductSuccessCasetst() {        
        final Opportunity objOppTst = [ SELECT Id,AccountId, MX_WB_Producto__c, FolioCotizacion__c FROM Opportunity LIMIT 1 ];
        final Product2 productASD = [Select Id from Product2 where Name = 'Auto Seguro Dinamico'];
        objOppTst.Producto__c = 'Auto Seguro Dinámico';
        objOppTst.MX_WB_Producto__c = productASD.Id;
        update objOppTst;
        final PricebookEntry objPriBooEntASD = MX_WB_OppoLineItemUtil_cls.crearPricebookEntry (productASD.Id , 1.00);
        insert objPriBooEntASD;
        Test.startTest();
        final boolean blResult = MX_WB_TM_Cotizador_cls.addProduct( objOppTst.Id, productASD.Id);
        System.assert ( blResult, ' Test Agregar Producto Caso Éxito ' );
        Test.stopTest();    
    }

    /**
    * Prueba que agrega el Producto a la Oportunidad SUCCESS CASE
    **/
    @isTest static void addProductBookEntry() {        
        final Opportunity objOppTst = [ SELECT Id,AccountId, MX_WB_Producto__c, FolioCotizacion__c FROM Opportunity LIMIT 1 ];
        final Product2 productASD = [Select Id from Product2 where Name = 'Seguro Fronterizo'];
        objOppTst.Producto__c = 'Auto Seguro Dinámico';
        objOppTst.MX_WB_Producto__c = productASD.Id;
        update objOppTst;
        Test.startTest();
        final boolean blResult = MX_WB_TM_Cotizador_cls.addProduct( objOppTst.Id, productASD.Id);
        System.assert ( blResult, ' Test Agregar Producto Caso Éxito ' );
        Test.stopTest();    
    }

    /**
    * Prueba que agrega el Producto a la Oportunidad SUCCESS CASE
    **/
    @isTest static void addProductSuccessFol() {        
        final Opportunity objOppTst = [ SELECT Id,AccountId, MX_WB_Producto__c, FolioCotizacion__c FROM Opportunity LIMIT 1 ];
        final Product2 productASD = [Select Id from Product2 where Name = 'Auto Seguro Dinamico'];
        objOppTst.Producto__c = 'Auto Seguro Dinámico';
        objOppTst.MX_WB_Producto__c = productASD.Id;
        update objOppTst;
        final PricebookEntry objPriBooEntASD = MX_WB_OppoLineItemUtil_cls.crearPricebookEntry (productASD.Id , 1.00);
        insert objPriBooEntASD;
        Test.startTest();
        MX_WB_TM_Cotizador_cls.addProduct ( objOppTst.Id, productASD.Id);
        final Quote quoteId = [Select Id,MX_SB_VTS_Folio_Cotizacion__c from Quote];
        quoteId.MX_SB_VTS_Folio_Cotizacion__c  = 'Folio-Test0001';
        update quoteId;
        final String urlTst = MX_WB_TM_Cotizador_cls.crearURL ( quoteId.Id );
        System.assertEquals(urlTst.contains( quoteId.Id ), false);
        Test.stopTest();  
    }

    /**
    * Prueba que agrega el Producto a la Oportunidad SUCCESS CASE
    **/
    @isTest static void addProductSuccessInbound() {        
        Opportunity objOppTst = [ SELECT Id,AccountId, MX_WB_Producto__c, FolioCotizacion__c FROM Opportunity LIMIT 1 ];
        final Product2 productASD = [Select Id from Product2 where Name = 'Auto Seguro Dinámico' AND MX_SB_SAC_Proceso__c = 'VTS'];
        objOppTst.Producto__c = 'Auto Seguro Dinámico';
        objOppTst.MX_WB_Producto__c = productASD.Id;
        update objOppTst;
        Test.startTest();
         final PricebookEntry objPriBooEntASD = MX_WB_OppoLineItemUtil_cls.crearPricebookEntry (productASD.Id , 1.00);
        insert objPriBooEntASD;
        final boolean blResult = MX_WB_TM_Cotizador_cls.addProductInbound(objOppTst.Id,  'Auto Seguro Dinámico');
        System.assert ( blResult, ' Test Agregar Producto Caso Éxito ' );
        Test.stopTest();    
    }

    /**
    * Prueba que agrega el Producto a la Oportunidad NO PRODUCT CASE
    **/
    @isTest static void addProductNoProCasetst() {
        final Opportunity objOppTst = [ SELECT Id, MX_WB_Producto__c, FolioCotizacion__c FROM Opportunity LIMIT 1 ];
        Test.startTest();
        try {
            MX_WB_TM_Cotizador_cls.addProduct ( objOppTst.Id, 'NOPRODUCTXXX' );
        } catch ( AuraHandledException auExcep ) {
            System.assertEquals ( 'Script-thrown exception', auExcep.getMessage(), ' Test Agregar Producto Caso No Existe Producto ' );
        }
        Test.stopTest();
    }

    /**
    * Prueba que lista los productos SUCCESS CASE
    **/
    @isTest static void fetchProductsLstTst() {
        final Opportunity objOppTst = [ SELECT Id, MX_WB_Producto__c, FolioCotizacion__c FROM Opportunity LIMIT 1 ];
        System.debug('objOppTst tm cotizador tst' + objOppTst);
        Map<String, Object> lstProdstr = new Map<String, Object>();
        Test.startTest();
        lstProdstr = MX_WB_TM_Cotizador_cls.fetchProductsLst ( objOppTst.Id );
        System.assertEquals(((List<Product2>)lstProdstr.get('lstProdOut')).size(), 0);
        Test.stopTest();
    }
    
    @isTest static void fetchProductsLstExcepTst() {
        final ID idInvalid = [ SELECT Id FROM Account LIMIT 1 ].Id;
        Test.startTest();
        try {
            MX_WB_TM_Cotizador_cls.fetchProductsLst ( idInvalid );
        } catch ( AuraHandledException auExcep ) {
            System.assertEquals ( 'Script-thrown exception', auExcep.getMessage(), ' Test Fetch Products List Caso Excepción ' );
        }
        Test.stopTest();
    }

    /**
    * Prueba que crea URL EXCEPTION CASE
    **/
    @isTest static void crearUrlExcepTst() {
        final ID idInvalid = [ SELECT Id FROM Account LIMIT 1 ].Id;
        try {
            Test.startTest();
            MX_WB_TM_Cotizador_cls.crearURL ( idInvalid );
        } catch ( AuraHandledException auExcep ) {
            System.assertEquals ( 'Script-thrown exception', auExcep.getMessage(), ' Test Crear URL Caso Excepción ' );
        }
        Test.stopTest();
    }

    /**
    * Prueba que recupera URL por numero de Folio
    **/
    @isTest static void crearURLCotNum() {
        Opportunity objOppTst = [ SELECT Id,AccountId, MX_WB_Producto__c, FolioCotizacion__c FROM Opportunity LIMIT 1 ];
        final Product2 productASD = [Select Id from Product2 where Name = 'Auto Seguro Dinamico'];
        objOppTst.Producto__c = 'Auto Seguro Dinámico';
        objOppTst.MX_WB_Producto__c = productASD.Id;
        update objOppTst;
        final PricebookEntry objPriBooEntASD = MX_WB_OppoLineItemUtil_cls.crearPricebookEntry (productASD.Id , 1.00);
        insert objPriBooEntASD;
        MX_WB_TM_Cotizador_cls.addProduct ( objOppTst.Id, productASD.Id);
        Quote quoteId = [Select Id,MX_SB_VTS_Folio_Cotizacion__c from Quote];
        quoteId.MX_SB_VTS_Folio_Cotizacion__c  = 'Folio-Test0001';
        update quoteId;
        try {
            Test.startTest();
            MX_WB_TM_Cotizador_cls.crearURLCotNum ( 'Folio-Test0001' );
        } catch ( AuraHandledException auExcep ) {
            System.assertEquals ( 'Script-thrown exception', auExcep.getMessage(), ' Test recupera URL por numero de Folio ' );
        }
        Test.stopTest();
    }
    
     /**
    * Prueba que recupera erroneamente URL por numero de Folio
    **/
    @isTest static void crearURLCotNum1() {
        try {
            Test.startTest();
            MX_WB_TM_Cotizador_cls.crearURLCotNum ( 'Folio-Test0001' );
        } catch ( AuraHandledException auExcep ) {
            System.assertEquals ( 'Script-thrown exception', auExcep.getMessage(), ' Test recupera URL por numero de Folio ' );
        }
        Test.stopTest();
    }
    

}