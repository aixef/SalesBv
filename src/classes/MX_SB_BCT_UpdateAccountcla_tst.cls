/*
*
* @author Tania Vazquez
* @description This class will be used to test MX_SB_BCT_BanqueroTriggerHandler
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    08/10/2019     Tania Vazquez     Create Banquero__c, cuentas
*
*
*/
@isTest
public class MX_SB_BCT_UpdateAccountcla_tst {
    
     @testSetup
    static void testData() {
		final User admin = MX_WB_TestData_cls.crearUsuario('test hogar', system.label.MX_SB_VTS_ProfileAdmin);
        Insert admin;
        final User admin2 = MX_WB_TestData_cls.crearUsuario('test hogar2', system.label.MX_SB_VTS_ProfileAdmin);
        admin2.FederationIdentifier='MX000011';
        Insert admin2;
        System.runAs(admin) {
        MX_WB_TestData_cls.createStandardPriceBook2();
            final Account acc = MX_WB_TestData_cls.crearCuenta('Doe', 'MX_WB_rt_PAcc_Telemarketing');
            acc.MX_SB_BCT_Id_Cliente_Banquero__c ='99';
            Insert acc;
    	}
    }
    @isTest static void updateAccountQuickAction() {
            Test.startTest();
        	Final Account acc = [select id, OwnerId from Account where FirstName='Doe'];
                final String result = MX_SB_BCT_UpdateAccountcla.UpdateAcc(acc.Id);
        		system.assert(String.isNotEmpty(result),'Funcionó');
            Test.stopTest();
    }
}