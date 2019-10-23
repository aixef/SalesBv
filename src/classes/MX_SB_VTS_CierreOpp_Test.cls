/*
*
* @author Jaime Terrats
* @description This class will be used to upsert data coming from Hogar tracking web
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    04/10/2019     Jaime Terrats     Create data structure to get incoming data from web tracking
* @version  1.1    06/17/2019     Jaime Terrats     Update closed won scenario
*
*/
@isTest
private class MX_SB_VTS_CierreOpp_Test {
    /*
    * Variable para Closed Lost
    */
    static final String closedLost = 'Closed Lost';
    /*
    * Variable para Closed Won
    */
	static final String closedWon = 'Closed Won';

    @TestSetup
    static void makeData() {
        final List<Opportunity> tempOpps = new List<Opportunity>();
        final User admin = MX_WB_TestData_cls.crearUsuario('test hogar', system.label.MX_SB_VTS_ProfileAdmin);
        Insert admin;

        System.runAs(admin) {
			final Product2 producto = MX_WB_TestData_cls.productNew('Hogar');
            producto.isActive = true;
            Insert producto;

         	final PricebookEntry pbe = MX_WB_TestData_cls.priceBookEntryNew(producto.Id);
            Insert pbe;
            final Account acc = MX_WB_TestData_cls.crearCuenta('Doe', 'PersonAccount');
            acc.PersonEmail = 'john.doe@test.close.opp.com';
            acc.FirstName = 'John';
            Insert acc;

            final Opportunity opp = MX_WB_TestData_cls.crearOportunidad('OppTest Close Opp', acc.Id, admin.Id, 'ASD');
            opp.Producto__c = 'test product';
            opp.Reason__c = 'Venta';
            final Opportunity opp2 = MX_WB_TestData_cls.crearOportunidad('OppTest Close Opp2', acc.Id, admin.Id, 'ASD');
            opp2.Producto__c = 'test product';
            opp2.Reason__c = 'Venta';
            final Opportunity opp3 = MX_WB_TestData_cls.crearOportunidad('OppTest Close Won', acc.Id, admin.Id, 'ASD');
            opp3.Producto__c = 'Auto Seguro Dinámico';
            opp3.Reason__c = 'Venta';
            opp3.MX_SB_VTS_Aplica_Cierre__c = true;
            tempOpps.add(opp);
            tempOpps.add(opp2);
            tempOpps.add(opp3);
            Insert tempOpps;

            final OpportunityLineItem oli = MX_WB_TestData_cls.oppLineItmNew(opp.Id, pbe.Id, producto.Id, 1, 1);
            Insert oli;

            final Contract contrTemp = new Contract();
            contrTemp.AccountId = acc.Id;
            contrTemp.StartDate = System.today();
            contrTemp.MX_WB_Oportunidad__c = opp3.Id;
			insert contrTemp;

            final Quote quoteTemp = MX_WB_TestData_cls.crearQuote(opp.Id, '999999 1 OppTest Close Opp', '999990');
            Insert quoteTemp;
        }
    }

    @isTest
    static void closedLostOpp1() {
        final Quote quo = [select Id, Name, MX_SB_VTS_Motivos_de_no_venta__c from Quote where Name =: '999999 1 OppTest Close Opp'];
        quo.MX_SB_VTS_Motivos_de_no_venta__c = 'Cliente molesto';
        final Opportunity opp = [select Id, StageName, Motivosnoventa__c from Opportunity where Name =: 'OppTest Close Opp'];
        opp.Motivosnoventa__c = 'Lorem Ipsum';
        opp.StageName = closedLost;
        Test.startTest();
        update quo;
        update opp;
        Test.stopTest();

        System.assertEquals(opp.StageName, closedLost, 'StageName doesnt match');
    }

    @isTest
    static void closedLostOpp2() {
        final Opportunity opp = [select Id, StageName, Motivosnoventa__c
                        from Opportunity where Name =: 'OppTest Close Opp2'];
        opp.Motivosnoventa__c = 'Lorem Ipsum';
        opp.StageName = closedLost;
        Test.startTest();
        update opp;
        Test.stopTest();

        System.assertEquals(opp.StageName, closedLost, 'StageName doesnt match');
    }

    @isTest
    static void closedWon() {
        final Opportunity opp = [select Id, StageName from Opportunity where Name =: 'OppTest Close Won'];
        opp.MX_SB_VTS_Aplica_Cierre__c = true;
        opp.StageName = closedWon;
        Test.startTest();
        update opp;
        Test.stopTest();

        System.assertEquals(opp.StageName, closedWon, 'Stage match');
    }
}
