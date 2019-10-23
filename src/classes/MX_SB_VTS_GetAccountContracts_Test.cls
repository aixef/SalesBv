/**
* BBVA - Mexico
* Jaime Terrats
* @Description Test class for aura component MX_SB_VTS_CMP_GetAccountContracts
* @Version 1.0
**/
@isTest
private class MX_SB_VTS_GetAccountContracts_Test {
    /**
    * User email
     */
    final static String EMAILUSER = 'tGetAccCon@test.com';
    /**
    * Account name
     */
    final static String ACCNAME = 'tAcc';
    /**
    * Opportunity name
     */
    final static String OPPNAME = 'tOpp';
    /**
    * Opportunity name
     */
    final static String EMAILACC = 'tAccCon@test.com';
    /**
    * TestSetup
    * mock data
    **/
    @TestSetup
    static void makeData() {
        final User tUser = MX_WB_TestData_cls.crearUsuario('tGetAccCon', System.Label.MX_SB_VTS_ProfileAdmin);
        tUser.email = EMAILUSER;
        insert tUser;
        System.runAs(tUser) {
            final Account acc = MX_WB_TestData_cls.createAccount(ACCNAME, System.Label.MX_SB_VTS_PersonRecord);
            acc.PersonEmail = EMAILACC;
            acc.PersonMobilePhone = '5555555555';
            acc.AccountSource = 'Inbound';
            insert acc;
            final Product2 producto = MX_WB_TestData_cls.productNew(System.Label.MX_SB_VTS_Hogar);
            producto.isActive = true;
            insert producto;
            final Opportunity opp = MX_WB_TestData_cls.crearOportunidad(OPPNAME, acc.Id, tUser.Id, System.Label.MX_SB_VTS_Telemarketing_LBL);
            opp.Reason__c = 'Venta';
            opp.Producto__c = System.Label.MX_SB_VTS_Hogar;
            opp.StageName = System.Label.MX_SB_VTS_COTIZACION_LBL;
            opp.TelefonoCliente__c = acc.PersonMobilePhone;
            opp.LeadSource = System.Label.MX_SB_VTS_OrigenCallMeBack;
            insert opp;
            final Contract con = MX_WB_TestData_cls.vtsCreateContract(acc.Id, tUser.Id, producto.Id);
            insert con;
        }
    }

    /**
    * Coverage: happy path
    **/
    @isTest
    static void testFetchActiveContractsByAccount() {
        final List<Contract> contracts = new List<Contract>();
        final Contract con = [Select Status from Contract where Account.LastName =: ACCNAME];
        con.Status = 'Activated';
        update con;
        final Id oppId = [Select Id from Opportunity where Name =: OPPNAME].Id;
        Test.startTest();
        contracts.addAll(MX_SB_VTS_GetAccountContracts.fetchActiveContractsByAccount(oppId));
        System.debug(contracts);
        Test.stopTest();
        System.assertEquals(con.Id, contracts[0].Id, 'Hacen match los ids');
    }
    /**
    * Coverage: wrong path
    **/
    @isTest
    static void testFail() {
        final Id accId = [Select Id from Account where LastName =: ACCNAME].Id;
        System.debug(accId);
        Test.startTest();
        try {
            MX_SB_VTS_GetAccountContracts.fetchActiveContractsByAccount(ACCId);
            throw new AuraHandledException(System.Label.MX_WB_LG_ErrorBack);
        } catch(AuraHandledException aEx) {
            final Boolean expectedException =  aEx.getMessage().contains('Script-thrown') ? true : false;
            System.AssertNotEquals(expectedException, false, 'Error Esperado');
        }
        Test.stopTest();
    }
}
