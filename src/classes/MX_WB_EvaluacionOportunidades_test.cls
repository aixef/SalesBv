/**
* ------------------------------------------------------------------------------------------------
* @Name     MX_WB_EvaluacionOportunidades_test
* @Author   Salvador Reyna Gonzalez
* @Date     Created: 2019-01-21
* @Group  	Telemarketing
* @Description This class works as a test Class for the APEX class MX_WB_EvaluacionOportunidades_ctrl
* @Coverage 100%
* @Changes
*/
@isTest
private class MX_WB_EvaluacionOportunidades_test {
    /** 
    *Field 
    */
    static Account aacountTest;
    /** 
    *Field
    */
    static Opportunity oppWon;
    /* --------------------------------------------------------------------------------------
    * @Description Inserts and Account and a Opportunity Type "ASD"
    **/
    static void init() {
        final RecordType rtOpp = [Select Id from RecordType Where SObjectType ='Opportunity' AND DeveloperName='MX_WB_RT_Telemarketing'];

        aacountTest = new Account();
        aacountTest.FirstName = 'Test Name';
        aacountTest.LastName = 'Test Last';
        aacountTest.PersonEmail = 'test@testbbva.com';
        aacountTest.PersonMobilePhone = '5551040002';
        aacountTest.PersonHomePhone = '5551040002';
        insert aacountTest;

        oppWon = new Opportunity();
        oppWon.Name = 'Test Opp';
        oppWon.StageName = 'Closed Won';
        oppWon.CloseDate = Date.today().addDays(1);
        oppWon.Producto__c = 'Auto Seguro Dinamico';
        oppWon.Reason__c = 'Venta';
        oppWon.MX_SB_VTS_Aplica_Cierre__c = true;
        oppWon.Estatus__c = 'Emitida';
        oppWon.LeadSource = 'Inbound';
        oppWon.FolioCotizacion__c = 'Test123';
        oppWon.Plan__c = 'Basico';
        oppWon.AccountId = aacountTest.Id;
        oppWon.RecordTypeId = rtOpp.Id;
        insert oppWon;
    }

    /* --------------------------------------------------------------------------------------
    * @Description Tests getOpportunities method from APEX Class MX_WB_EvaluacionOportunidades_ctrl
    **/
    static testMethod void getOpportunities() {
        init();
        final List<Opportunity> opps = MX_WB_EvaluacionOportunidades_ctrl.getOpportunities();
        System.assertEquals(opps[0].Name, oppWon.Name, 'Coinciden los nombres de opportunidad');
    }
}
