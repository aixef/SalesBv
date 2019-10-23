/**
* ------------------------------------------------------------------------------------------------
* @Name     MX_WB_EvaluacionOportunidades_ctrl
* @Author   Salvador Reyna Gonzalez
* @Date     Created: 2019-01-09
* @Group  	Telemarketing
* @Description This class works as a controller for the component MX_WB_EvaluacionOportunidades
* @Changes
*/
public with sharing class MX_WB_EvaluacionOportunidades_ctrl {
    /**
    * --------------------------------------------------------------------------------------
    * @Description Searches and returns a list of Won/Lost Opportunities
    * @return List<Opportunity>
    **/

    @auraEnabled
    public static List<Opportunity> getOpportunities() {
        return [SELECT Id, Name, CloseDate, FolioCotizacion__c, StageName, Owner.Name, MX_WB_EvaluacionCalidad__c FROM Opportunity WHERE RecordType.Name = 'Outbound' AND (StageName = 'Closed Won' OR StageName = 'Closed Lost')  AND CloseDate >= LAST_N_MONTHS:4];
    }
}