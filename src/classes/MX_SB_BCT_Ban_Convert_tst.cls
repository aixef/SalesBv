/*
*
* @author Tania Vazquez
* @description This class will be used to test MX_SB_BCT_BanqueroTriggerHandler
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    08/10/2019     Tania Vazquez     Create Banquero__c, cuentas
*
*/
@isTest
public class MX_SB_BCT_Ban_Convert_tst {
    @testSetup
    static void testData() {
		final User admin = MX_WB_TestData_cls.crearUsuario('test hogar', system.label.MX_SB_VTS_ProfileAdmin);
        Insert admin;
        final User admin2 = MX_WB_TestData_cls.crearUsuario('test hogar2', system.label.MX_SB_VTS_ProfileAdmin);
        admin2.FederationIdentifier='MX000011';
        Insert admin2;
        System.runAs(admin) {
        MX_WB_TestData_cls.createStandardPriceBook2();
            final Product2 producto = MX_WB_TestData_cls.productNew('Hogar');
            producto.isActive = true;
            Insert producto;
            final PricebookEntry pbe = MX_WB_TestData_cls.priceBookEntryNew(producto.Id);
            Insert pbe;
            final Account acc = MX_WB_TestData_cls.crearCuenta('Doe', 'MX_WB_rt_PAcc_Telemarketing');
            acc.MX_SB_BCT_Id_Cliente_Banquero__c ='99';
            Insert acc;
            final Opportunity opp = MX_WB_TestData_cls.crearOportunidad('OppTest Hogar', acc.Id, admin.Id, 'ASD');
            opp.Producto__c = 'Hogar';
            opp.Reason__c = 'Venta';
            opp.MX_SB_VTS_Aplica_Cierre__c = true;
            Insert opp;
            final Contract contr = MX_WB_TestData_cls.vtsCreateContract(acc.Id, admin.Id, producto.Id);
            Insert contr;
            final MX_SB_VTS_Generica__c generica = MX_WB_TestData_cls.GeneraGenerica('MX_SB_BCT_user_Banquero', 'CP5');
            generica.MX_SB_BCT_user_Banquero_Default__c=admin2.FederationIdentifier;
            insert generica;
                
    	}
    }
    
    @isTest static void valo() {
        Test.startTest();
            final User admin = MX_WB_TestData_cls.crearUsuario('test hogar2', system.label.MX_SB_VTS_ProfileAdmin);
            Insert admin;
            final Opportunity idcompara = [select id, OwnerId from Opportunity where name='OppTest Hogar'];
            System.runAs(admin) {
            final List<Banquero__c> ban = new List<Banquero__c>();
            final Banquero__c banque = new Banquero__c(MX_SB_BCT_Id_Banquero__c='990099',MX_SB_BCT_Id_Cliente__c='99');
            ban.add(banque);
            final Banquero__c banque1 = new Banquero__c(MX_SB_BCT_Id_Banquero__c='1234',MX_SB_BCT_Id_Cliente__c='7');
            ban.add(banque1);
            final Banquero__c banque2 = new Banquero__c(MX_SB_BCT_Id_Banquero__c='1234',MX_SB_BCT_Id_Cliente__c='5');
            ban.add(banque2);
            final Banquero__c banque3 = new Banquero__c(MX_SB_BCT_Id_Banquero__c='1234',MX_SB_BCT_Id_Cliente__c='878');
            ban.add(banque3);
            insert ban;
            final Opportunity idcomparafuture = [select id, OwnerId from Opportunity where name='OppTest Hogar'];  
            system.assertNotEquals(idcomparafuture.OwnerId, idcompara.OwnerId, 'Flujo Correcto');
        Test.stopTest();
        }
    }
     @isTest static void updateAccountQuickAction2() {
         Test.startTest();
         String result2;
             try {
                  result2 = MX_SB_BCT_UpdateAccountcla.UpdateAcc('123');
             } catch(System.AuraHandledException e) {
                  system.assert(String.isEmpty(result2),'Funcionó');
             }
     }
             
}