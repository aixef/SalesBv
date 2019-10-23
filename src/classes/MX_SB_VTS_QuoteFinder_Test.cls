/*
*
* @author Jaime Terrats
* @description Unit tests for controller
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    04/10/2019     Jaime Terrats     Create Unit Test
* @version  1.0.1  06/20/2019	  Jaime Terrats     Remove code smells
*/
@isTest
private class MX_SB_VTS_QuoteFinder_Test {
    /*
    *
    * error message for asserts
    *
    */
    final static String FOLIO_COT = '9999';

    /*
    * Test setup method
    *
    */
    @TestSetup
    static void makeData() {
        final User tUser = MX_WB_TestData_cls.crearUsuario('testUser qf', System.Label.MX_SB_VTS_ProfileAdmin);
        insert tUser;

        System.runAs(tUser) {
            MX_WB_TestData_cls.createStandardPriceBook2();

            final Product2 producto = MX_WB_TestData_cls.productNew('Hogar');
            producto.isActive = true;
            insert producto;

            final PricebookEntry pbe = MX_WB_TestData_cls.priceBookEntryNew(producto.Id);
            Insert pbe;

            final Account acc = MX_WB_TestData_cls.crearCuenta('test qf', 'PersonAccount');
            insert acc;

            final Opportunity opp = MX_WB_TestData_cls.crearOportunidad('testOpp fq', acc.Id, tUser.Id, 'ASD');
            opp.StageName = 'Objeciones';
            opp.Producto__c = 'Hogar';
            final Opportunity opp2 = MX_WB_TestData_cls.crearOportunidad('test2 qf', acc.Id, tUser.Id, 'ASD');
            opp2.StageName = 'Objeciones';
            opp2.Producto__c = 'Hogar';
           	final List<Opportunity> oppTests = new List<Opportunity>();
            oppTests.add(opp);
            oppTests.add(opp2);
            insert oppTests;


            final OpportunityLineItem oli = MX_WB_TestData_cls.oppLineItmNew(opp.Id, pbe.Id, producto.Id, 1, 1);
            insert oli;

            final Quote quo = MX_WB_TestData_cls.crearQuote(opp.Id, '9999 1 OppTest findQuote', FOLIO_COT);
            insert quo;
        }
    }

    /*
    *  Scenario: will search quote based on folioCotizacion
    *
    */
    @isTest
    static void testFindQuote() {
        Test.startTest();
        final Quote fQuote = MX_SB_VTS_QuoteFinder.findQuote(FOLIO_COT);
        Test.stopTest();
        System.assertNotEquals(fQuote, null, 'Se encontro quote');
    }

    /*
    *  Scenario: updates data from search result
    *
    */
    @isTest
    static void testUpdateQuote() {
        Quote updQuote = new Quote();
        Boolean flag;
        Test.startTest();
        updQuote = MX_SB_VTS_QuoteFinder.findQuote(FOLIO_COT);
        updQuote.MX_SB_VTS_Motivos_de_no_venta__c = 'Cliente molesto';
        flag = MX_SB_VTS_QuoteFinder.updateQuote(updQuote);
        Test.stopTest();
        System.assertNotEquals(flag, null, 'Se actualizo la cotizacion');
    }

    @isTest
    static void testLast5Quotes() {
        final List<Quote> last5Quotes = new List<Quote>();
        final Opportunity opp = [Select Id from Opportunity where Name =: 'testOpp fq'];
        Test.startTest();
        last5Quotes.addAll(MX_SB_VTS_QuoteFinder.getLast5Quotes(opp.Id));
        Test.stopTest();
        System.assertEquals('9999 1 OppTest findQuote', last5Quotes[0].Name, 'Los nombres coinciden');
    }

    /*
    *
    * Scenario: fail search
    *
    */
    @isTest
    static void failQuoteSearch() {
        Test.startTest();
        try {
            MX_SB_VTS_QuoteFinder.findQuote('8888');
            throw new AuraHandledException(System.Label.MX_WB_LG_ErrorBack);
        } catch(AuraHandledException aEx) {
            final Boolean expectedException =  aEx.getMessage().contains('Script-thrown') ? true : false;
            System.AssertNotEquals(expectedException, false, 'Error Esperado');
        }
        Test.stopTest();
    }

    @isTest
    static void failGet5Quotes() {
        Test.startTest();
        try {
            final String oppId = [Select Id from Opportunity where Name =: 'test2 qf'].Id;
            final List<Quote> quotes = new List<Quote>();
            quotes.addAll(MX_SB_VTS_QuoteFinder.getLast5Quotes(oppId));
            throw new AuraHandledException(System.Label.MX_WB_LG_ErrorBack);
        } catch(AuraHandledException aEx) {
            final Boolean expectedException =  aEx.getMessage().contains('Script-thrown') ? true : false;
            System.AssertNotEquals(expectedException, false, 'Error Esperado');
        }
        Test.stopTest();
    }

    @isTest
    static void failUpdate() {
        Test.startTest();
        try {
            Quote updQuote = new Quote();
            updQuote = MX_SB_VTS_QuoteFinder.findQuote(FOLIO_COT);
            updQuote.MX_SB_VTS_Motivos_de_no_venta__c = 'Lorem Ipsum';
            MX_SB_VTS_QuoteFinder.updateQuote(updQuote);
        } catch(AuraHandledException aEx) {
            final Boolean expectedException =  aEx.getMessage().contains('Script-thrown') ? true : false;
            System.assertNotEquals(expectedException, false, 'Error al actualizar');
        }
        Test.stopTest();
    }
}
