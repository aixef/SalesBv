/*******************************************************************************
@Name                   MX_PYME_CampTrigHand_Cls
Desarrollado por:       Indra
@Author                 Ricardo Almanza
@Date                   2019-01-25
Proyecto:               PYME
@Group                  Trigger Campaign
*************************************************************************************
@Description            Clase para métodos de trigger de Campaign Manteniendo relación entre Account Campaign
*************************************************************************************
@Changes
2019-04-02  ricardo.almanza.contractor@bbva.com     Mejora para procesar AccCamp relacionados por batch
/*******************************************************************************/
public with sharing class MX_PYME_CampTrigHand_Cls {

    //Constructor with no arguments
    @TestVisible
    private MX_PYME_CampTrigHand_Cls() {}

    /*
    *@Description   Update AccCamp when Campaign has Products
    *@param         newCamp List of Campaign updated to Match changes and update related Account Campaigns
    *@param         oldCamp List of old Campaign updated to Match changes and update related Account Campaigns
    *@return        void
    *@example       updAccCamponPrd(newCamp, oldCamp)
    */
    public static void updAccCamponPrd(Map<Id,Campaign> newCamp,Map<Id,Campaign> oldCamp) {
        Map<Id,Campaign> newCampPrd = new Map<Id,Campaign>();
        for (Campaign camp : newCamp.values()) {
            if(camp.MX_PYME_Productos__c != null && (oldCamp == null || oldCamp.get(camp.Id).MX_PYME_Productos__c == null)) {
                newCampPrd.put(camp.Id, camp);
            }
        }
        if(!newCampPrd.isEmpty()) {
            MX_PYME_AccCamp_ActRecType_Batch_Cls bacc = new MX_PYME_AccCamp_ActRecType_Batch_Cls(newCampPrd.keySet() , 'MX_PYME_Campania_CargadaPrd' , 'Select Id, RecordTypeId from cond__Account_Campaign__c where cond__campaign_id__c in (' , ')' );
            database.executebatch(bacc , 2000);
        }
    }
}