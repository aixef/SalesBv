/**
* ------------------------------------------------------------------------------------------------
* @Name     MX_PyME_Campaign_GenOpp_Test
* @Author   Jhovanny De La Cruz Cruz jhovanny.delacruz.contractor@bbva.com
* @Date     Created: 2019-01-29
* @Group    Test Class for the functionality MX_PyME_Campaign_GenOpp_cls
* @Description Test class for the creation of opportunities functionality
* @Changes
*
*  |2019-01-29  jhovanny.delacruz.contractor@bbva.com
*				Test methods are added for MX_PyME_Campaign_GenOpp_cls
*/
@isTest
public class MX_PyME_Campaign_GenOpp_Test {

    /** Colocación */
	static final String STGAHORRO = 'Ahorro';
    /**
    * Crea un usuario ejecutivo PyME
     */
    public static User creaUserEjecPyme() {
        return UtilitysDataTest_tst.crearUsuario('USUARIO EJEC', 'Ejecutivo PyME Plus', 'EJEC PYME PLUS AGUASCALIENTES');
    }

    /**
    * Test de prueba con campaña con productos
     */
    static testMethod void getAccountCampaignFieldsTest() {
        final User usr = [SELECT Id,ProfileId,VP_ls_Banca__c,Divisi_n__c FROM User WHERE Id =: UserInfo.getUserId()];
        UtilitysDataTest_tst.crearProdForm('Colocación', STGAHORRO);
        final Account testAccount = UtilitysDataTest_tst.crearCuenta('Empresa 1 TEST', 'Grupo');
        testAccount.No_de_cliente__c = '1396008';
        insert testAccount;
        final List<Campaign> camps = new List<Campaign>();
        final List<cond__Account_Campaign__c> accCamp = new List<cond__Account_Campaign__c>();
        final Campaign cmp = new Campaign();
        cmp.Name = 'TEST CAMPAÑA';
        cmp.MX_PYME_Productos__c = STGAHORRO;
        cmp.RecordTypeId=  RecordTypeMemory_cls.getRecType('Campaign','AccountCampaign_Campaign');
        camps.add(cmp);
        insert camps;
        cond__Account_Campaign__c acccmp = new cond__Account_Campaign__c();
        acccmp =  UtilitysDataTest_tst.crearAccCampaign(String.valueOf(usr.id) , 'Pre_Validated_Account_Campaign', 'TEST', String.valueOf(testAccount.id));
        acccmp.cond__campaign_id__c = camps[0].id;
        acccmp.cond__campaign_name__c = 'Test Campaign';
        acccmp.cond__priority_campaign_type__c = 'High';
        accCamp.add(acccmp);
        insert accCamp;
        MX_PyME_Campaign_GenOpp_cls.getAccountCampaignFields(acccmp.id);
        MX_PyME_Campaign_GenOpp_cls.relatedRecordType();
        List<Product2> pdts = new List<Product2>();
        pdts = MX_PyME_Campaign_GenOpp_cls.getProductCampaign(acccmp.id);
        System.assert(pdts.isEmpty(),'There are no products associated with the campaign to generate an opportunity. Please contact your system administrator.');
    }

    /**
    * Test de prueba de campaña sin productos
     */
    static testMethod void getAccountCampaignFieldsTest2() {
        final User usr = [SELECT Id,ProfileId,VP_ls_Banca__c,Divisi_n__c FROM User WHERE Id =: UserInfo.getUserId()];
        UtilitysDataTest_tst.crearProdForm('Colocación', STGAHORRO);
        final Account testAccount = UtilitysDataTest_tst.crearCuenta('Empresa 1 TEST', 'Grupo');
        testAccount.No_de_cliente__c = '1396008';
        insert testAccount;
        final List<Campaign> camps = new List<Campaign>();
        final List<cond__Account_Campaign__c> accCamp = new List<cond__Account_Campaign__c>();
        final Campaign cmp = new Campaign();
        cmp.Name = 'TEST CAMPAÑA';
        cmp.cond__campaign_id__c = 'TEST';
        cmp.MX_PYME_Productos__c = STGAHORRO;
        cmp.RecordTypeId=  RecordTypeMemory_cls.getRecType('Campaign','AccountCampaign_Campaign');
        camps.add(cmp);
        insert camps;
        cond__Account_Campaign__c acccmp = new cond__Account_Campaign__c();
        acccmp =  UtilitysDataTest_tst.crearAccCampaign(String.valueOf(usr.id) , 'Pre_Validated_Account_Campaign', 'TEST', String.valueOf(testAccount.id));
        acccmp.cond__campaign_id__c = camps[0].id;
        acccmp.cond__campaign_name__c = 'Test Campaign';
        acccmp.cond__priority_campaign_type__c = 'High';
        accCamp.add(acccmp);
        insert accCamp;
        MX_PyME_Campaign_GenOpp_cls.getAccountCampaignFields(acccmp.id);
        MX_PyME_Campaign_GenOpp_cls.relatedRecordType();
        List<Product2> pdts = new List<Product2>();
        pdts = MX_PyME_Campaign_GenOpp_cls.getProductCampaign(acccmp.id);
        System.assert(pdts.isEmpty(),'There are no products associated with the campaign to generate an opportunity. Please contact your system administrator.');
    }
}