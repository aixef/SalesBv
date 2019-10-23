@isTest
/**
*
*@
 */
private class BPyP_AccFiltrTest {

    /**
     * This is a test method for fetchAcc
     */
    static testMethod void test_fetchAcc() {

        // PageReference pageRef = Page.BPyP_AccFiltr;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Test.startTest();

		List<Account> resultFetchAcc = BPyP_AccFiltr.fetchAcc('','CP',0);
        BPyP_AccFiltr.fetchPgs('','CP');
		resultFetchAcc = BPyP_AccFiltr.fetchAcc('','C',0);
        BPyP_AccFiltr.fetchPgs('','C');
		resultFetchAcc = BPyP_AccFiltr.fetchAcc('','P',0);
        BPyP_AccFiltr.fetchPgs('','P');
        resultFetchAcc = BPyP_AccFiltr.fetchAcc('','CP',10);
        BPyP_AccFiltr.fetchPgs('','CP');
        resultFetchAcc = BPyP_AccFiltr.fetchAcc('','C',10);
        BPyP_AccFiltr.fetchPgs('','C');
        resultFetchAcc = BPyP_AccFiltr.fetchAcc('','P',10);
        BPyP_AccFiltr.fetchPgs('','P');

		System.assert(resultFetchAcc.size()==0,'Exito');

        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }

    static User getNewUser() {
        User u=[Select Username, LastName, Email, Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey From User where id=:UserInfo.getUserId()];
        User newUser = new User();
        newUser.LastName = u.LastName;
        newUser.Email = u.Email;
        newUser.Alias = u.Alias;
        newUser.TimeZoneSidKey = u.TimeZoneSidKey;
        newUser.LocaleSidKey = u.LocaleSidKey;
        newUser.EmailEncodingKey = u.EmailEncodingKey;
        newUser.ProfileId = u.ProfileId;
        newUser.LanguageLocaleKey = u.LanguageLocaleKey;
        newUser.Username='test@ricardo.almanza.com';
        newUser.CommunityNickname='test@ricardo.almanza.com';
        newUser.VP_ls_Banca__c='Red BPyP';
        newUser.Divisi_n__c='BAJIO';
        newUser.BPyP_ls_NombreSucursal__c='6388 PACHUCA';
        newUser.IsActive=true;
        Insert newUser;
        return newUser;
    }

    static testMethod void createData() {
        User newUser = getNewUser();
        RecordType rec=[Select Id from RecordType where DeveloperName='BPyP_tre_Cliente'];
        Account a= new Account();
        a.Name= 'a';
        a.RecordTypeId = rec.Id;
        a.OwnerId = newUser.Id;
        Insert a;
        System.assert(a.Id!=null);
    }

    static testMethod User createDataRet() {
        User u = getNewUser();
        Account a= new Account();
        RecordType rec=[Select Id from RecordType where DeveloperName='BPyP_tre_Cliente'];
        a.RecordTypeId = rec.Id;
        a.Name='a';
        a.OwnerId = u.Id;
        Insert a;
        System.assert(a.Id!=null);
        u = [Select Username, LastName, Email, Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, Name From User where Id =: u.Id];
        return u;
    }


    /**
     * This is a test method for fetchDiv
     */
    static testMethod void test_fetchDiv() {

        // PageReference pageRef = Page.BPyP_AccFiltr;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        createData();

        Test.startTest();

		List<AggregateResult> resultFetchDiv = BPyP_AccFiltr.fetchDiv();
		//createData();
		BPyP_AccFiltr.WRP_Chart r=BPyP_AccFiltr.fetchDivData('CP');
        r=BPyP_AccFiltr.fetchDivData('C');
        r=BPyP_AccFiltr.fetchDivData('CP');
        r=BPyP_AccFiltr.fetchDivData('P');
		System.assert(r.lsData.size()>=0,'Exito');
        System.debug('agregateR: ' + resultFetchDiv.get(0));
        System.assertEquals('BAJIO', resultFetchDiv.get(0).get('Divisi_n__c'), 'La división de la cuenta insertada no corresponda a la del propietario');


        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }


    /**
     * This is a test method for fetchOff
     */
    static testMethod void test_fetchOff() {

        // PageReference pageRef = Page.BPyP_AccFiltr;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');
        createData();

        Test.startTest();

		String div = 'BAJIO';
		List<AggregateResult> resultFetchOff = BPyP_AccFiltr.fetchOff(div);
        System.assertEquals('6388 PACHUCA', resultFetchOff.get(0).get('BPyP_ls_NombreSucursal__c'),'La sucursal de la cuenta insertada no corresponda con la del propietario');
		resultFetchOff = BPyP_AccFiltr.fetchOff('');
		String Divisi_n='BAJIO';
        //createData();
		BPyP_AccFiltr.WRP_Chart r=BPyP_AccFiltr.fetchOffData(Divisi_n,'CP');
        r=BPyP_AccFiltr.fetchOffData(Divisi_n,'C');
        r=BPyP_AccFiltr.fetchOffData(Divisi_n,'CP');
		r=BPyP_AccFiltr.fetchOffData(Divisi_n,'P');
		System.assert(r.lsData.size()>=0,'Exito');

        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }


    /**
     * This is a test method for fetchBankMan
     */
    static testMethod void test_fetchBankMan() {

        // PageReference pageRef = Page.BPyP_AccFiltr;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');
        User u =createDataRet();

        Test.startTest();

		String div = 'BAJIO';
		String office = '6388 PACHUCA';
		List<AggregateResult> resultFetchBankMan = BPyP_AccFiltr.fetchBankMan(div,office);
        System.assertEquals(u.Id, resultFetchBankMan.get(0).get('OwnerId'), 'El propietario de la cuenta no es el correcto.');
		resultFetchBankMan = BPyP_AccFiltr.fetchBankMan(div,'');
		String Divisi_n='BAJIO';
		String BPyP_ls_NombreSucursal='6388 PACHUCA';
		//createData();
		BPyP_AccFiltr.WRP_Chart r=BPyP_AccFiltr.fetchBkMData(Divisi_n,BPyP_ls_NombreSucursal,'','CP');
        r=BPyP_AccFiltr.fetchBkMData(Divisi_n,BPyP_ls_NombreSucursal,'','C');
        r=BPyP_AccFiltr.fetchBkMData(Divisi_n,BPyP_ls_NombreSucursal,'','CP');
        r=BPyP_AccFiltr.fetchBkMData(Divisi_n,BPyP_ls_NombreSucursal,'','P');
        r=BPyP_AccFiltr.fetchBkMData(Divisi_n,BPyP_ls_NombreSucursal,u.Name,'C');
        r=BPyP_AccFiltr.fetchBkMData(Divisi_n,BPyP_ls_NombreSucursal,u.Name,'CP');
        r=BPyP_AccFiltr.fetchBkMData(Divisi_n,BPyP_ls_NombreSucursal,u.Name,'P');
		System.assert(r.lsData.size()>=0,'Exito');
        System.assert(BPyP_AccFiltr.fetchbaseurl()!=null);
        System.assert(BPyP_AccFiltr.fetchusdata()!=null);


        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }
}