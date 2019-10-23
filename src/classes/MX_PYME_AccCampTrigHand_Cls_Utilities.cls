/*******************************************************************************
@Name                   MX_PYME_AccCampTrigHand_Cls_Utilities
@Author                 Hugo Carrillo
@Date                   2019-07-16
@Group                  Trigger AccountCampaign
*************************************************************************************
@Description            Clase creada a aprtir de la partición de algunos métodos de
                        la clase MX_PYME_AccCampTrigHand_Cls
*************************************************************************************
@Changes				(most recent first)
/*******************************************************************************/

public with sharing class MX_PYME_AccCampTrigHand_Cls_Utilities {
    private MX_PYME_AccCampTrigHand_Cls_Utilities() {

    }
    /*
    *@Description   Method to help reduce de cyclomatic complexity setting the ParticipantId
    *@param         Boolean isAcc
    *@param         Boolean newAccEqOld
    *@param         Set<String> extAccId
    *@param         cond__Account_Campaign__c accCamp
    *@return        Set<String>
    *@example       setParticipantId(Boolean, Boolean, Set<String>, cond__Account_Campaign__c)
    */
    public static Set<String> setParticipantId(Boolean isAcc, Boolean newAccEqOld, Set<String> extAccId, cond__Account_Campaign__c accCamp) {
        Set<String> varTemp = extAccId;
        if(isAcc && !newAccEqOld) {
            varTemp.add(accCamp.cond__participant_load_id__c);
        }
        return varTemp;
    }

    /*
    *@Description   Method to help reduce de cyclomatic complexity
    *@param         Account acc
    *@param         Account acc, List<Account> updAcc
    *@return        void
    *@example       helperUpdtAcc(Account, List<Account>)
    */
    public static void helperUpdtAcc(Account acc, List<Account> updAcc) {
        if(!acc.no_de_cliente__c.equals(acc.cond__salesforce_unified_external_id__c)) {
            acc.cond__salesforce_unified_external_id__c = acc.no_de_cliente__c;
            updAcc.add(acc);
        }
    }


    /*
    *@Description   Method to help reduce de cyclomatic complexity
    *@param         Integer type
    *@param         List<SObject> lista
    *@return        void
    *@example       helperValidate(Integer, List<SObject>)
    */
    public static void helperValidate(Integer type, List<SObject> lista) {
        if(!lista.isEmpty() && type == 1) {
            update lista;
        }
        if(!lista.isEmpty() && type == 2) {
            insert lista;
        }
    }

    /*
    *@Description   Method to set name and dates values for the campaign
    *@param         cond__Account_Campaign__c accCamp
    *@param         String idCamp
    *@param         Map<string,Date> relCampStDt
    *@param         Map<string,Date> relCampEnDt
    *@return        List<String>
    *@example       setNameDateValues(accCamp, idCamp, relCampStDt, relCampEnDt)
    */
    public static List<String> setNameDateValues(cond__Account_Campaign__c accCamp, String idCamp, Map<string,Date> relCampStDt, Map<string,Date> relCampEnDt) {
        List<String> nameDates = new List<String>();
        String nameCamp;
        Date stDt;
        Date enDt;
        if(accCamp.Name == null) {
            nameCamp = idCamp;
        }else {
            nameCamp = accCamp.Name;
        }
        nameDates.add(nameCamp);
        if(accCamp.cond__campaign_start_date__c > relCampStDt.get(idCamp)) {
            stDt = relCampStDt.get(idCamp);
        }else {
            stDt = accCamp.cond__campaign_start_date__c;
        }
        nameDates.add(String.valueOf(stDt));
        if(accCamp.cond__campaign_end_date__c < relCampEnDt.get(idCamp)) {
            enDt = relCampEnDt.get(idCamp);
        }else {
            enDt = accCamp.cond__campaign_end_date__c;
        }
        nameDates.add(String.valueOf(enDt));
        return nameDates;
    }

    /*
    *@Description   Method to set the value of the category's name and type
    *@param         String catName
    *@param         String catType
    *@return        List<String>
    *@example       setCategoryNameType(accCamp.cond__solution_category_name__c, accCamp.cond__solution_category_type__c);
    */
    public static List<String> setCategoryNameType(String catName, String catType) {
        String name = catName;
        String type = catType;
        List<String> nameTypeValues = new List<String>();
        nameTypeValues.add(name);
        nameTypeValues.add(type);
        if(catName == null) {
            name = 'NA';
            nameTypeValues.set(0, name);
        }
        if (catType == null) {
            type = 'NA';
            nameTypeValues.set(1, type);
        }
        return nameTypeValues;
    }

    /*
    *@Description   Method to set the value of some varibles needed in the method CrtCampAccCamp
    *@param         Boolean isOld
    *@param         List<cond__Account_Campaign__c> oldAccCamp
    *@param         cond__Account_Campaign__c accCamp
    *@param         String idCamp
    *@return        List<Boolean>
    *@example       CrtCampAccCamp(newAccCamp, oldAccCamp)
    */
    public static List<Boolean> setValues(Boolean isOld, List<cond__Account_Campaign__c> oldAccCamp, cond__Account_Campaign__c accCamp, String idCamp) {
        Boolean isInOld,newAccEqOld,newCamEqOld;
        List<Boolean> values = new List<Boolean>();
        if(isOld) {
            isInOld = oldAccCamp.indexOf(accCamp) != -1;
        }else {
            isInOld = false;
        }
        if(isInOld) {
            newAccEqOld = accCamp.cond__participant_load_id__c.equals(oldAccCamp.get(oldAccCamp.indexOf(accCamp)).cond__participant_load_id__c);
            newCamEqOld = idCamp.equals(oldAccCamp.get(oldAccCamp.indexOf(accCamp)).cond__campaign_load_id__c);
        }else {
            newAccEqOld = false;
            newCamEqOld = false;
        }
        values.add(newAccEqOld);
        values.add(newCamEqOld);
        return values;
    }

    /*
    *@Description   Method to set some values for the AccCamp
    *@param         cond__Account_Campaign__c accCamp
    *@param         Account relAcc
    *@param         Boolean isAcc
    *@param         Boolean newAccEqOld
    *@return        cond__Account_Campaign__c
    *@example       setAccCampValues(relAcc, isAcc, newAccEqOld);
    */
    public static cond__Account_Campaign__c setAccCampValues(cond__Account_Campaign__c accCamp, Account relAcc, Boolean isAcc, Boolean newAccEqOld) {
        cond__Account_Campaign__c accCampVal = accCamp;
        String idAccOwn = null;
        String accNm = null;
        if(relAcc != null) {
            idAccOwn = relAcc.OwnerId;
            accNm = relAcc.Name;
        }
        if(isAcc && !newAccEqOld && idAccOwn != null) {
            accCampVal.OwnerId = idAccOwn;
        }
        if(isAcc && !newAccEqOld) {
            accCampVal.cond__participant_name__c = accNm;
        }else if(accNm != null) {
            accCampVal.cond__participant_name__c = 'No asignado';
        }
        return accCampVal;
    }

    /*
    *@Description   Method to set the OwnCamp values for the AccCamp
    *@param         cond__Account_Campaign__c accCamp
    *@param         Account relAcc
    *@param         Map<String,String> ownCamp
    *@return        String
    *@example       setOwnCamp(accCamp, relAcc, ownCamp);
    */
    public static String setOwnCamp(cond__Account_Campaign__c accCamp, Account relAcc, Map<String,String> ownCamp) {
        String cmpOwn = null;
        String usrOwnCamp = null;
        if(relAcc != null) {
            usrOwnCamp = relAcc.Owner.MX_PYME_Encargado_de_Campania__c;
        }
        cmpOwn = ownCamp.get(accCamp.cond__participant_load_id__c);
        if(cmpOwn == null || cmpOwn == Label.MX_PYME_Encargado_de_Campania) {
            if(usrOwnCamp == null) {
                cmpOwn = Label.MX_PYME_Encargado_de_Campania;
            }else {
                cmpOwn = usrOwnCamp;
            }
        }
        return cmpOwn;
    }

    /*
    *@Description   Method to create campaigns
    *@param
    *@param
    *@param
    *@return        List<Campaign>
    *@example       heperNoCampaign(exsCamp, camNew, relCampName, idCampSel, relCampDesc, relCampStDt, relCampEnDt, ownCamp, campPend);
    */
    public static List<Campaign> heperNoCampaign(Map<String,Campaign> exsCamp, Map<string,string> relCampName, String idCampSel, Map<string,string> relCampDesc, Map<string,Date> relCampStDt, Map<string,Date> relCampEnDt, Map<String,String> ownCamp, List<Campaign> campPend) {
        if(!exsCamp.containsKey(idCampSel)) {
            Campaign camNew = new Campaign();
            camNew.Name = relCampName.get(idCampSel);
            camNew.Description = relCampDesc.get(idCampSel);
            camNew.RecordTypeId = RecordTypeMemory_cls.getRecType('Campaign', 'AccountCampaign_Campaign');
            camNew.cond__campaign_id__c = idCampSel;
            camNew.StartDate = relCampStDt.get(idCampSel);
            camNew.EndDate = relCampEnDt.get(idCampSel);
            camNew.cond__campaign_subtitle_name__c = relCampName.get(idCampSel);
            camNew.cond__data_source_name__c = 'Archivo';
            camNew.cond__priority_campaign_type__c = 'High';
            camNew.OwnerId = ownCamp.get(idCampSel);
            //Crear campañas
            //Agregar a la lista para insertar
            campPend.add(camNew);
        }
        return campPend;
    }

}
