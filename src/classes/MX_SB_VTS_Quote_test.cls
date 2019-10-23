/*
 * Quote Trigger
 * @Autor: Arsenio Perez Lopez
 * @Create Date:27/03/2019
 * @Proyect: BBVA_SEGUROS
 * @Description: XXXX
 * -----Version-----
 * 1.0 Creation ... 27/03/2019
 * 
 *           No  |     Date     |     Author      |    Description
 * @version  1.0    04/10/2019     Arsenio Perez      Creacion
 * 
*/
@istest()
public without sharing class MX_SB_VTS_Quote_test {
    @TestSetup
        static void makeData() {
       User admin = MX_WB_TestData_cls.crearUsuario('Adminprueba',system.label.MX_SB_VTS_ProfileAdmin);
       Insert admin;
       User PerfilASD = MX_WB_TestData_cls.crearUsuario('Perfil Asd','Asesores ASD');
       Insert PerfilASD;
       final Account Actemp;
       final PricebookEntry PbE;
       final Product2 pro;
       final Opportunity opp;
       system.runAs(admin) {
       pro = MX_WB_TestData_cls.productNew('Exampleproduct');
                pro.IsActive=true;
       Insert pro;
       MX_WB_TestData_cls.createStandardPriceBook2();
       PbE = MX_WB_TestData_cls.priceBookEntryNew(Pro.Id);
       Insert PbE;
       final MX_SB_VTS_Generica__c mKsegurosGenerica = new MX_SB_VTS_Generica__c(Name='Temp1',MX_SB_VTS_Type__c='CP1',MX_SB_VTS_Quoli_Item__c='Description',MX_SB_VTS_Oli_Item__c='Description');
       Insert mKsegurosGenerica;
       final MX_SB_VTS_Generica__c mKsegurosGenericaQe = new MX_SB_VTS_Generica__c(Name='Temp2',MX_SB_VTS_Type__c='CP1',MX_SB_VTS_Quoli_Item__c='Quote.MX_SB_VTS_RFC__c',MX_SB_VTS_Oli_Item__c='MX_SB_VTS_RFC__c');
       Insert mKsegurosGenericaQe;
       }
       system.runAs(PerfilASD) {
        Actemp = MX_WB_TestData_cls.crearCuenta('strName', 'PersonAccount');
        Insert Actemp;
        opp = MX_WB_TestData_cls.crearOportunidad('OppEjemplo', Actemp.Id, PerfilASD.Id, 'MX_WB_RT_Telemarketing');
        Insert opp;
        OpportunityLineItem Oli = MX_WB_TestData_cls.oppLineItmNew(opp.Id, PbE.Id, pro.Id, 1, 1);
       Insert Oli;
       }
    }   
    @istest static void TestTrigger1() {
        final Pricebook2 prB2 = MX_WB_TestData_cls.createStandardPriceBook2();
        final Opportunity tempOpp = [Select id from Opportunity where name = 'OppEjemplo'  limit 1];
        final List<OpportunityLineItem> temOli = [select id from OpportunityLineItem where OpportunityId=:tempOpp.Id];
        final Product2 ptemp = [select id from Product2 where name = 'Exampleproduct' limit 1];
        final PricebookEntry pEntry = [select id from PricebookEntry where product2Id=:ptemp.id];
        Test.startTest();
            final Quote Qtem = new Quote(Name= 'temp', OpportunityId = tempOpp.Id, Pricebook2Id= prB2.Id,status='Emitida',MX_SB_VTS_Numero_de_Poliza__c='POL1234567');
            insert Qtem;
            final QuoteLineItem Qltem = new QuoteLineItem(
            QuoteId=Qtem.Id, 
            PricebookEntryId=pEntry.Id, 
            Quantity=1, 
            UnitPrice=1, 
            Product2Id=ptemp.Id);
            Insert Qltem;
            final QuoteLineItem Qltem2 = new QuoteLineItem(
            QuoteId=Qtem.Id, 
            PricebookEntryId=pEntry.Id, 
            Quantity=1, 
            UnitPrice=1, 
            Product2Id=ptemp.Id);
            Insert Qltem2;
            tempOpp.SyncedQuoteId=Qtem.Id;
            Update tempOpp;
            final List<OpportunityLineItem> temOli2 = [select id from OpportunityLineItem where OpportunityId=:tempOpp.Id];
            system.assert(temOli2.size()>1,'Valida que se creen correctamente mas de un Quoli');
        Test.stopTest();
    }
    
    @istest static void TestTrigger2() {
        final Opportunity tempOpp = [Select id from Opportunity where name = 'OppEjemplo'  limit 1];
        final List<OpportunityLineItem> temOli = [select id from OpportunityLineItem where OpportunityId=:tempOpp.Id];
        Test.startTest();
            final Quote Qtem = new Quote(Name= 'temp', OpportunityId = tempOpp.Id,status='Emitida',MX_SB_VTS_Numero_de_Poliza__c='POL1234567');
            insert Qtem;
            tempOpp.SyncedQuoteId=Qtem.Id;
            Update tempOpp;
            final Opportunity tempOpp2 = [Select id, SyncedQuoteId from Opportunity where name = 'OppEjemplo'  limit 1];
            system.assertEquals(Qtem.Id, tempOpp2.SyncedQuoteId,'Valida que se sincronice un nuevo QuolineItem en la oportunidad');
        Test.stopTest();
    }

    @istest static void TestTrigger3() {
        final Pricebook2 prB2 = MX_WB_TestData_cls.createStandardPriceBook2();
        final Opportunity tempOpp = [Select id from Opportunity where name = 'OppEjemplo'  limit 1];
        final List<OpportunityLineItem> temOli = [select id from OpportunityLineItem where OpportunityId=:tempOpp.Id];
        final Product2 ptemp = [select id from Product2 where name = 'Exampleproduct' limit 1];
        final PricebookEntry pEntry = [select id from PricebookEntry where product2Id=:ptemp.id];
        Test.startTest();
            final Quote Qtem = new Quote(Name= 'temp', OpportunityId = tempOpp.Id, Pricebook2Id= prB2.Id,status='Emitida',MX_SB_VTS_Numero_de_Poliza__c='POL1234567');
            Insert Qtem;
            final QuoteLineItem Qltem = new QuoteLineItem(
                QuoteId=Qtem.Id, 
                PricebookEntryId=pEntry.Id, 
                Quantity=1, 
                UnitPrice=1, 
                Product2Id=ptemp.Id);
            Insert Qltem;
                tempOpp.SyncedQuoteId=Qtem.Id;
            Update tempOpp;        
            final QuoteLineItem Qltem2 = new QuoteLineItem(
                QuoteId=Qtem.Id, 
                PricebookEntryId=pEntry.Id, 
                Quantity=1, 
                UnitPrice=1, 
                Product2Id=ptemp.Id);
            Insert Qltem2;
            final List<OpportunityLineItem> temOli2 = [select id from OpportunityLineItem where OpportunityId=:tempOpp.Id];
            final List<QuoteLineItem> temOli3 = [select id from QuoteLineItem where Quote.OpportunityId=:tempOpp.Id];
            system.assertNOTEquals(temOli2.size(), temOli.size(),'Valida la creacion correcta del OpportunityLineItem');
            system.assertEquals(temOli2.size(), temOli3.size(),'Valida que los QuoteLineItem y los OLis existentes sean iguales');
        Test.stopTest();
    }
     @istest static void TestTrigger5() {
         Test.startTest();
            try {
                final Opportunity tempOpp = [Select id from Opportunity where name = 'OppEjemplo'  limit 1];
                final List<OpportunityLineItem> temOli = [select id from OpportunityLineItem where OpportunityId=:tempOpp.Id];
                    final Quote Qtem = new Quote(Name= 'temp', OpportunityId = tempOpp.Id );
                    insert Qtem;
                    tempOpp.SyncedQuoteId=Qtem.Id;
                    Update tempOpp;
                    final List<OpportunityLineItem> temOli2 = [select id from OpportunityLineItem where OpportunityId=:tempOpp.Id];
            }catch(System.ListException e) {
                system.assert(String.isEmpty(e.getMessage()),'Valida el ListException');
            }
         Test.stopTest();
    }
}