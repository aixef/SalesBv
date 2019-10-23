/**-------------------------------------------------------------------------
 * Nombre: MX_WB_OppoLineItemUtil_tst
 * Autor Ing. Daniel Goncalves
 * Proyecto: MW WB TM - BBVA Bancomer
 * Descripción : Clase Test de MX_WB_OppoLineItemUtil_cls
 * --------------------------------------------------------------------------
 * Versión      Fecha           Autor                   Descripción
 * -------------------------------------------------------------------
 * 1.0          11/02/2019      Ing. Daniel Goncalves   Creación
 * --------------------------------------------------------------------------
 */
@isTest
public class MX_WB_OppoLineItemUtil_tst {
    /**
    * Setup the data for the tests
    * @return List String
    **/
    @testSetup static void setup() {
        final User testUser = MX_WB_TestData_cls.crearUsuario ( 'TestLastName', 'System Administrator' );
        insert testUser;
        final Account accRec = MX_WB_TestData_cls.crearCuenta ( 'LastName', 'MX_WB_rt_PAcc_Telemarketing' );
        accRec.OwnerId = testUser.Id;
        accRec.Correo_Electronico__c = 'prueba@wibe.com';
        insert accRec;
        final Opportunity oppRec = MX_WB_TestData_cls.crearOportunidad ( 'Test', accRec.Id, testUser.Id, 'MX_WB_RT_Telemarketing' );
        oppRec.FolioCotizacion__c = null;
        oppRec.TelefonoCliente__c = '1234567890';
        insert oppRec;
        final MX_WB_FamiliaProducto__c objFamilyPro = MX_WB_TestData_cls.createProductsFamily ( 'ASD' );
        insert objFamilyPro;
        final Product2 proTst = MX_WB_TestData_cls.productNew ( 'Seguro de Moto Bancomer' );
        proTst.IsActive = true;
        proTst.MX_WB_FamiliaProductos__c = objFamilyPro.Id;
        insert proTst;
        MX_WB_TestData_cls.createStandardPriceBook2 ();
    }
    /**
    * Prueba para crear un PricebookEntry
    **/
    @isTest static void crearPricebookEntrytst () {
        final String strProId = [ SELECT ID FROM Product2 WHERE Name =: 'Seguro de Moto Bancomer' ].Id;
        Test.startTest();
        final PricebookEntry objPriBoEnt = MX_WB_OppoLineItemUtil_cls.crearPricebookEntry ( strProId, 0.00 );
        System.assertEquals ( strProId, objPriBoEnt.Product2Id, ' Test Creación PricebookEntry Caso Éxito ' );
        Test.stopTest();
    }
    /**
    * Prueba que crea un PricebookEntry Caso Existe el Pricebook
    **/
    @isTest static void crearPricebookEntryHasPriBootst () {
        final String strProId = [ SELECT ID FROM Product2 WHERE Name =: 'Seguro de Moto Bancomer' ].Id;
        PricebookEntry objPriceBookEntry;
        for ( Pricebook2 objPriBoo : [ SELECT ID FROM Pricebook2 WHERE isStandard = true LIMIT 1 ]) {
            objPriceBookEntry = new PricebookEntry();
            objPriceBookEntry.Pricebook2Id = objPriBoo.Id;
            objPriceBookEntry.Product2Id = strProId;
            objPriceBookEntry.IsActive = true;
            objPriceBookEntry.UnitPrice = 0;
        }
        insert objPriceBookEntry;
        Test.startTest();
        final PricebookEntry objPriBoEnt = MX_WB_OppoLineItemUtil_cls.crearPricebookEntry ( strProId, 0.00 );
        System.assertEquals ( strProId, objPriBoEnt.Product2Id, ' Test Creación PricebookEntry Caso Éxito ' );
        Test.stopTest();
    }
    /**
    * Prueba que crea un OpportunityLineItem
    **/
    @isTest static void crearOpportunityLineItemtst () {
        final Opportunity objOpp = [ SELECT ID, Name, CorreodelCliente__c, TelefonoCliente__c, Description, MX_WB_Producto__c, Sexo_conductor__c, Telefono__c FROM Opportunity LIMIT 1 ];
        final PricebookEntry objPriBoEnt = new PricebookEntry();
        Test.startTest();
        final OpportunityLineItem objOppLinIteTst = MX_WB_OppoLineItemUtil_cls.crearOpportunityLineItem ( objOpp, objPriBoEnt );
        System.assertEquals ( objOpp.ID, objOppLinIteTst.OpportunityId, ' Test Creación OpportunityLineItem Caso Éxito ' );
        Test.stopTest();
    }
}
