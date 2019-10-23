/*******************************************************************************
@Name                   MX_PYME_AccCamp_ActRecType_Batch_Cls
Desarrollado por:       Indra
@Author                 Ricardo Almanza
@Date                   2019-04-02
Proyecto:               PYME
@Group                  Trigger Campaign
*************************************************************************************
@Description            Class used in Batch de AccountCampaign updating record type
*************************************************************************************

/*******************************************************************************/
global without sharing class MX_PYME_AccCamp_ActRecType_Batch_Cls implements Database.Batchable<sObject>, Database.AllowsCallouts {
    /*
    *@Description   Set String for query
    *@param         camps Set of id to find
    *@param         recType recordtype to update
    *@param         beginquery prefix of query
    *@param         endquery suffix of query
    *@return        void
    *@example       MX_PYME_AccCamp_ActRecType_Batch_Cls(newCampPrd.keySet(),
                    'MX_PYME_Campania_CargadaPrd','Select Id, RecordTypeId
                    from cond__Account_Campaign__c where cond__campaign_id__c in (',')')
    */
    String query;
    /**variable rec */
    String rec;
    /**variable */
    global MX_PYME_AccCamp_ActRecType_Batch_Cls(Set<Id> camps,String recType,String beginquery,String endquery)
    {
        String ids = '';
        for(Id campId : camps) {
            ids += '\'' + campId + '\',';
        }
        rec = recType;
        query = beginquery + ids.removeEnd(',') + endquery;
    }
    /*
    *@Description   Start of batchable
    *@param         Database.BatchableContext
    *@return        void
    *@example       QueryLocator(bc)
    */
    global Database.QueryLocator start(Database.BatchableContext bC)
    {
        return Database.getQueryLocator(query);
    }
    /*
    *@Description   Process batchable
    *@param         Database.BatchableContext
    *@param         List<cond__Account_Campaign__c> AccCamp to update
    *@return        void
    *@example       execute(bc,scope)
    */
    global void execute(Database.BatchableContext bC, List<cond__Account_Campaign__c> scope) {
        for(cond__Account_Campaign__c accCamp : scope) {
            accCamp.RecordTypeId = RecordTypeMemory_cls.getRecType('cond__Account_Campaign__c', rec);
        }
        if(!scope.isEmpty()) {
            update scope;
        }
    }
    /*
    *@Description   Finish of batchable
    *@param         Database.BatchableContext
    *@return        void
    *@example       finish(bc)
    */
    global void finish(Database.BatchableContext bC) {
    }
}