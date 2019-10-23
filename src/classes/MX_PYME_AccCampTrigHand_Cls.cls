/*******************************************************************************
@Name                   MX_PYME_AccCampTrigHand_Cls
Desarrollado por:       Indra
@Author                 Ricardo Almanza
@Date                   2019-01-15
Proyecto:               PYME
@Group                  Trigger AccountCampaign
*************************************************************************************
@Description            Clase para métodos de trigger de AccountCampaign Manteniendo relación entre campaña y Oportunidad
*************************************************************************************
@Changes				(most recent first)
2019-02-11				method updSuccAccCamp to update AccCamp when Success
2019-02-18				method CrtCampAccCamp modified to set Desc as NA and set Campaign description as the long text custom
2019-07-17              Modifications done to solve Code Smells
/*******************************************************************************/

public with sharing class MX_PYME_AccCampTrigHand_Cls {

    //Constructor with no arguments
    @TestVisible
    private MX_PYME_AccCampTrigHand_Cls() {}


    /*
    *@Description   Update AccCamp when adding an Opp related
    *@param         accCamp AccCamp to update
    *@param         updAccCamp list to keep related AccCamp
    *@param         oldDevNameRecType Old Recordtype to Update if matched
    *@param         newDevNameRecType Recordtype to update
    *@return        List to keep updated AccCamp
    *@example       List<cond__Account_Campaign__c> updAccCampaignPls(accCamp,updAccCamp,'MX_PYME_Campania_Cargada','MX_PYME_ValAccCamp')
    */
    public static List<cond__Account_Campaign__c> updAccCampaignPls(cond__Account_Campaign__c accCamp,List<cond__Account_Campaign__c> updAccCamp,String oldDevNameRecType,String newDevNameRecType) {
        accCamp.MX_PYME_RelOpp__c = accCamp.MX_PYME_RelOpp__c == null ? 1 : accCamp.MX_PYME_RelOpp__c+1;
        accCamp.cond__Campaign_status_approval_type__c = 'In Progress';
        accCamp.RecordTypeId = accCamp.RecordTypeId == RecordTypeMemory_cls.getRecType('cond__Account_Campaign__c', oldDevNameRecType) ? RecordTypeMemory_cls.getRecType('cond__Account_Campaign__c', newDevNameRecType) : accCamp.RecordTypeId;
        updAccCamp.add(accCamp);
        return updAccCamp;
    }
    /*
    *@Description   Update Date of validity of AccCamp
    *@param         newAccCamp List of AccCamp updated to update end of validity
    *@return        void
    *@example       updDtEndAccCamp(newAccCamp)
    */
    public static void updDtEndAccCamp(List<cond__Account_Campaign__c> newAccCamp) {
        for(cond__Account_Campaign__c accCamp : newAccCamp) {
            if(accCamp.cond__data_source_name__c == 'UpdEndDt') {
                accCamp.cond__campaign_end_date__c = Date.today();
                accCamp.cond__data_source_name__c = 'ArchivoBaja';
            }
        }
    }
    /*
    *@Description   Update success of AccCamp
    *@param         newAccCamp List of AccCamp updated to update status
    *@return        void
    *@example       updSuccAccCamp(List<cond__Account_Campaign__c> newAccCamp)
    */
    public static void updSuccAccCamp(List<cond__Account_Campaign__c> newAccCamp) {
        for(cond__Account_Campaign__c accCamp : newAccCamp) {
            if(accCamp.MX_PYME_Success__c) {
                accCamp.cond__Campaign_status_approval_type__c='Closed';
                accCamp.cond__sub_status_type__c='Won';
            }
        }
    }
    /*
    *@Description   Update AccCamp when no related Products
    *@param         newAccCamp List of AccCamp updated to update when no related Products
    *@return        void
    *@example       updStatAccCamp(newAccCamp)
    */
    public static void updStatAccCamp(List<cond__Account_Campaign__c> newAccCamp) {
        List<cond__Account_Campaign__c> updAccCamp = new List<cond__Account_Campaign__c>();
        String devRecType = 'MX_PYME_Campania_Cargada';
        for(cond__Account_Campaign__c accCamp : newAccCamp) {
            if(accCamp.cond__Others_rejection_reason_desc__c == 'Gestión sin productos' && accCamp.RecordTypeId == RecordTypeMemory_cls.getRecType('cond__Account_Campaign__c', devRecType)) {
                updAccCamp = updAccCampaignPls(accCamp,updAccCamp,devRecType,'MX_PYME_ValAccCamp');
            }
        }
    }
    /*
    *@Description   Update AccCamp when Camp has Products
    *@param         newAccCamp List of AccCamp updated to update when Camp has Products
    *@return        void
    *@example       updRecTyAccCamp(NewAccCamp)
    */
    public static void updRecTyAccCamp(List<cond__Account_Campaign__c> NewAccCamp) {
        Set<String> campIds = new Set<String>(),campPrdIds = new Set<String>();
        for(cond__Account_Campaign__c accCamp : NewAccCamp) {
            if(accCamp.RecordTypeId == RecordTypeMemory_cls.getRecType('cond__Account_Campaign__c', 'MX_PYME_Campania_Cargada')) {
                campIds.add(accCamp.cond__campaign_load_id__c);
            }
        }
        for(Campaign camp : [Select Id, MX_PYME_Productos__c, cond__campaign_id__c from Campaign where cond__campaign_id__c in  : campIds]) {
            if(camp.MX_PYME_Productos__c != null) {
                campPrdIds.add(camp.cond__campaign_id__c);
            }
        }
        for(cond__Account_Campaign__c accCamp : NewAccCamp) {
            if(campPrdIds.contains(accCamp.cond__campaign_load_id__c)) {
                accCamp.RecordTypeId = RecordTypeMemory_cls.getRecType('cond__Account_Campaign__c', 'MX_PYME_Campania_CargadaPrd');
            }
        }
    }
    /*
    *@Description   Create Camp related to file, update account related to match on Managed Package
    *@param         newAccCamp List of AccCamp updated to match and identify changes
    *@param         oldAccCamp List of AccCamp updated to match and identify changes
    *@return        void
    *@example       CrtCampAccCamp(newAccCamp, oldAccCamp)
    */
    public static void CrtCampAccCamp(List<cond__Account_Campaign__c> newAccCamp, List<cond__Account_Campaign__c> oldAccCamp) {
        Map<string,string> relCampName = new Map<string,string>(),relCampDesc = new Map<string,string>();
        Map<string,Date> relCampStDt = new Map<string,Date>(),relCampEnDt = new Map<string,Date>();
        String idCamp;
        Set<String> extAccId = new Set<String>();
        Boolean isAcc,isCamp,isOld,newAccEqOld,newCamEqOld;
        List<Boolean> values = new List<Boolean>();
        List<String> nameType = new List<String>(), nameDates = new List<String>();
        for(cond__Account_Campaign__c accCamp : newAccCamp) {
            //condición para saber cuando aplica la asignación de campaña en account campaign
            if(accCamp.RecordTypeId == RecordTypeMemory_cls.getRecType('cond__Account_Campaign__c', 'MX_PYME_Campania_Cargada')) {
                idCamp = accCamp.cond__campaign_load_id__c;
                isAcc = String.isNotEmpty(accCamp.cond__participant_load_id__c);
                isCamp = String.isNotEmpty(idCamp);
                isOld = oldAccCamp != null;
                values = MX_PYME_AccCampTrigHand_Cls_Utilities.setValues(isOld, oldAccCamp, accCamp, idCamp);
                newAccEqOld = values[0];
                newCamEqOld = values[1];
                accCamp.cond__priority_campaign_type__c = 'High';
                nameType = MX_PYME_AccCampTrigHand_Cls_Utilities.setCategoryNameType(accCamp.cond__solution_category_name__c, accCamp.cond__solution_category_type__c);
                accCamp.cond__solution_category_name__c = nameType[0];
                accCamp.cond__solution_category_type__c = nameType[1];
                accCamp.cond__campaign_desc__c = 'NA';
                //id de cuenta cond__participant_load_id__c
                extAccId = MX_PYME_AccCampTrigHand_Cls_Utilities.setParticipantId(isAcc, newAccEqOld, extAccId, accCamp);

                //id de campaña cond__campaign_load_id__c
                if(isCamp && !newCamEqOld) {
                    nameDates = MX_PYME_AccCampTrigHand_Cls_Utilities.setNameDateValues(accCamp, idCamp, relCampStDt, relCampEnDt);
                    accCamp.cond__campaign_name__c = nameDates[0];
                    relCampName.put(idCamp,nameDates[0]);
                    relCampDesc.put(idCamp,accCamp.MX_PYME_DescLarga__c);
                    relCampStDt.put(idCamp,Date.valueOf(nameDates[1]));
                    relCampEnDt.put(idCamp,Date.valueOf(nameDates[2]));
                }
            }
        }
        List<Account> updAcc = new List<Account>();
        Map<String,Account> campAccrel = new Map<String,Account>();
        for(Account acc : [select Id,OwnerId,Owner.MX_PYME_Encargado_de_Campania__c,Name,no_de_cliente__c,cond__salesforce_unified_external_id__c from Account where no_de_cliente__c in  : extAccId]) {
            campAccrel.put(acc.no_de_cliente__c,acc);
            MX_PYME_AccCampTrigHand_Cls_Utilities.helperUpdtAcc(acc, updAcc);
        }
        MX_PYME_AccCampTrigHand_Cls_Utilities.helperValidate(1, updAcc);
        Map<String,String> ownCamp = setCampaignOwner(newAccCamp, oldAccCamp, idCamp, campAccrel);
        List<Campaign> campPend = new List<Campaign>();
        Map<String,Campaign> exsCamp = new Map<String,Campaign>();
        for(Campaign exCamp : [Select Id,Name,cond__campaign_id__c from Campaign where cond__campaign_id__c in  : relCampName.keyset()]) {
            exsCamp.put(exCamp.cond__campaign_id__c,exCamp);
        }
        for(String idCampSel : relCampName.keyset()) {
            //No existe campaña
            campPend = MX_PYME_AccCampTrigHand_Cls_Utilities.heperNoCampaign(exsCamp, relCampName, idCampSel, relCampDesc, relCampStDt, relCampEnDt, ownCamp, campPend);
        }
        MX_PYME_AccCampTrigHand_Cls_Utilities.helperValidate(2, campPend);
    }

    /*
    *@Description   Set Values to create the campaign owner.
    *@param         List<cond__Account_Campaign__c> newAccCamp
    *@param         List<cond__Account_Campaign__c> oldAccCamp
    *@param         String idCamp
    *@param         Map<String,Account> campAccrel
    *@return        Map<String,String>
    *@example       setCampaignOwner(newAccCamp, oldAccCamp, idCamp, campAccrel)
    */
    public static Map<String,String> setCampaignOwner(List<cond__Account_Campaign__c> newAccCamp, List<cond__Account_Campaign__c> oldAccCamp, String idCamp, Map<String,Account> campAccrel) {
        String cmpOwn = null;
        Account relAcc;
        Boolean isAcc, isOld;
        Map<String,String> ownCamp = new Map<String,String>();
        List<Boolean> values = new List<Boolean>();
        cond__Account_Campaign__c accCampVals;
        Boolean newAccEqOld;
        for(cond__Account_Campaign__c accCamp : newAccCamp) {
            isAcc = String.isNotEmpty(accCamp.cond__participant_load_id__c);
            isOld = oldAccCamp != null;
            values = MX_PYME_AccCampTrigHand_Cls_Utilities.setValues(isOld, oldAccCamp, accCamp, idCamp);
            newAccEqOld = values[0];
            relAcc = campAccrel.get(accCamp.cond__participant_load_id__c);
            accCampVals = MX_PYME_AccCampTrigHand_Cls_Utilities.setAccCampValues(accCamp, relAcc, isAcc, newAccEqOld);
            accCamp.OwnerId = accCampVals.OwnerId;
            accCamp.cond__participant_name__c = accCampVals.cond__participant_name__c;
            cmpOwn = MX_PYME_AccCampTrigHand_Cls_Utilities.setOwnCamp(accCamp, relAcc, ownCamp);
            ownCamp.put(accCamp.cond__campaign_load_id__c, cmpOwn);
        }

        return ownCamp;
    }

}