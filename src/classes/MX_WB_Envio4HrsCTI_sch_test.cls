/**
* 
*Creacion de clase MX_WB_Envio4HrsCTI_sch_test
*/
@isTest
public class MX_WB_Envio4HrsCTI_sch_test {

    @testSetup
    static void initData() {
        final MX_WB_FamiliaProducto__c testFamilia = MX_WB_TestData_cls.createProductsFamily('Test Familia');
        insert testFamilia;
        final Campaign testCampaign = MX_WB_TestData_cls.createCampania('Test Camp');
        testCampaign.MX_WB_FamiliaProductos__c = testFamilia.Id;
        insert testCampaign;
        final Lead testLead = MX_WB_TestData_cls.createLead('Test Data');
        testLead.MX_WB_ph_Telefono1__c = '5551040002';
        testLead.MX_WB_ph_Telefono2__c = '5551040003';
        testLead.MX_WB_ph_Telefono3__c = '5551040004';
        testLead.LeadSource = 'Outbound TLMK';
        insert testLead;
        final CampaignMember testMember = MX_WB_TestData_cls.createCampaignMember(testLead.Id, testCampaign.Id);
        insert testMember;
    }

    testMethod static void scheduleTest() {
        Test.StartTest();
        final MX_WB_Envio4HrsCTI_sch sh1 = new MX_WB_Envio4HrsCTI_sch();
        final String sch = '0 0 23 * * ?';
        final String jobId = system.schedule('Test Territory Check', sch, sh1);
        System.assertNotEquals(null, jobId, 'no se ejecuto el chron job');
        Test.stopTest();
    }
}