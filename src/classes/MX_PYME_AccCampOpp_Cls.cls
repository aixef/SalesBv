/*******************************************************************************
@Name                   MX_PYME_AccCampOpp_Cls
Desarrollado por:       Indra
@Author                 Ricardo Almanza
@Date                   2019-01-15
Proyecto:               PYME
@Group                  Trigger Oportunidad
*************************************************************************************
@Description            Clase para métodos de trigger de Oportunidad manteniendo relación con AccountCampaign
*************************************************************************************
@Changes                (most recent first)
2019-02-28              Error on comparison making double count of new Opps on AccCamp
2019-02-11              verify Maps to query only when Opps with AccCamp
2019-07-11     Jair Ignacio Gonzalez Gayosso         Se depuro clase con los metodos confirmados en la migracion de bpyp y pymes
/*******************************************************************************/
public with sharing class MX_PYME_AccCampOpp_Cls {

    /** Map de relacion campañas con oportunidades */
    static Map<string,string[]> relAddAccCampOpp = new Map<string,string[]>(),relDelAccCampOpp = new Map<string,string[]>();

    private MX_PYME_AccCampOpp_Cls() {
  	}

    /*
    *@Description   Update AccCamp when adding an Opp related
    *@param         newOpportunity Opp to match relation and identify if new relation
    *@param         oldOpportunity Opp to match relation and identify if new relation
    *@return        void
    *@example       addOppToAccCampaign(newOpportunity, oldOpportunity)
    */
    public static void addOppToAccCampaign(Map<Id,Opportunity> newOpportunity, Map<Id,Opportunity> oldOpportunity) {
        //Map<string,string[]> relAddAccCampOpp = new Map<string,string[]>(),relDelAccCampOpp = new Map<string,string[]>();
        addDelAcc(newOpportunity,oldOpportunity);
        final List<cond__Account_Campaign__c> updDelAccCamp = new List<cond__Account_Campaign__c>(); //NOSONAR
        if(!relDelAccCampOpp.isEmpty()) {
            for(cond__Account_Campaign__c accCampDel  :   [Select id,Name,MX_PYME_RelOpp__c,cond__Campaign_status_approval_type__c,RecordTypeId,cond__campaign_id__c,cond__campaign_id__r.MX_PYME_Productos__c,cond__participant_id__c from cond__Account_Campaign__c where Id =  :  relDelAccCampOpp.keySet()]) {
                accCampDel.MX_PYME_RelOpp__c = accCampDel.MX_PYME_RelOpp__c == null || accCampDel.MX_PYME_RelOpp__c<=1 ? 0 :  accCampDel.MX_PYME_RelOpp__c-1;
                updDelAccCamp.add(accCampDel);
            }
            if(!updDelAccCamp.isEmpty()) {
                update updDelAccCamp;
            }
        }

        //Contar oportunidades y si está en cero poner como aprobada el acc campaign si error opp.addError
        if(!relAddAccCampOpp.isEmpty()) {
            countOppApp(relAddAccCampOpp, newOpportunity);
        }
    }

    /** Agrega Oportunidades a relDelAccCampOpp */
    public static void addDelAcc(Map<Id,Opportunity> newOpportunity, Map<Id,Opportunity> oldOpportunity) {
        String accCampId,oaccCampId;
        string[] opps;
        for(Opportunity opt : newOpportunity.values()) {
            accCampId = opt.cond__participant_campaign_id__c;
            if (oldOpportunity != null) {
                oaccCampId = oldOpportunity.get(opt.Id).cond__participant_campaign_id__c;
            }
            if(String.isNotEmpty(accCampId) && (oldOpportunity == null || !accCampId.equals(oaccCampId))) {
                opps = addAcc(opps, opt, accCampId);
                relAddAccCampOpp.put(accCampId,opps);
            }
            if(String.isNotEmpty(oaccCampId) && !accCampId.equals(oaccCampId)) {
                opps = addDel(opps, opt, oaccCampId);
                relDelAccCampOpp.put(oaccCampId,opps);
            }
        }
    }

    /** Regresa una lista con nuevas oportunidades añadidas para relAddAccCampOpp*/
    public static List<String> addAcc(List<String> opps, Opportunity opt, String accCampId) {
        String[] opps2 = opps == null ? opps : opps.clone();
        opps2 = relAddAccCampOpp.containsKey(accCampId) ? relAddAccCampOpp.get(accCampId) :  new List<string>();
        opps2.add(opt.Id);
        return opps2;
    }

    /** Regresa una lista con nuevas oportunidades añadidas para relDelAccCampOpp*/
    public static List<String> addDel(List<String> opps, Opportunity opt, String oaccCampId) {
        String[] opps2 = opps == null ? opps : opps.clone();
        opps2 = relDelAccCampOpp.containsKey(oaccCampId) ? relDelAccCampOpp.get(oaccCampId) :  new List<string>();
        opps2.add(opt.Id);
        return opps2;
    }

    /** Actualiza las oportunidades */
    public static void countOppApp(Map<string,string[]> relAddAccCampOpp, Map<Id,Opportunity> newOpportunity) {
        List<cond__Account_Campaign__c> updAccCamp = new List<cond__Account_Campaign__c>();
        Opportunity opp;
        String campPrd,oppPrd,campCln,oppCln;
        Boolean err;
        Boolean noClnO,noClnC,diffCam,noPrdO,noPrdCam,diffPrd;
        for(cond__Account_Campaign__c accCamp  :   [Select id,Name,MX_PYME_RelOpp__c,cond__Campaign_status_approval_type__c,RecordTypeId,cond__campaign_id__c,cond__campaign_id__r.MX_PYME_Productos__c,cond__participant_id__c from cond__Account_Campaign__c where Id =  :  relAddAccCampOpp.keySet()]) {
                for(String oppid  :   relAddAccCampOpp.get(accCamp.Id)) {
                    opp = newOpportunity.get(oppid);
                    campPrd = accCamp.cond__campaign_id__r.MX_PYME_Productos__c;
                    oppPrd = opp.MX_RTL_Producto__c;
                    campCln = accCamp.cond__participant_id__c;
                    oppCln = opp.AccountId;
                    noClnO = String.isEmpty(oppCln);
                    noClnC = String.isEmpty(campCln);
                    diffCam = !oppCln.equals(campCln);
                    noPrdO = String.isEmpty(oppPrd);
                    noPrdCam = String.isEmpty(campPrd);
                    diffPrd = (String.isNotEmpty(oppPrd) && !campPrd.containsIgnoreCase(oppPrd));
                    err = (noClnO || noClnC || diffCam || noPrdO || noPrdCam || diffPrd) ? true :  false;
                    if(err) {
                        opp = addErrorOpp(opp,noClnO, noClnC, diffCam, noPrdO, noPrdCam, diffPrd);
                    }
                    if(!err) {
                        updAccCamp = MX_PYME_AccCampTrigHand_Cls.updAccCampaignPls(accCamp,updAccCamp,'MX_PYME_Campania_CargadaPrd','MX_PYME_ValAccCamp');
                    }
                }
            }
            if(!updAccCamp.isEmpty()) {
                update updAccCamp;
            }
    }

    /** Agrega un error a la oportunidad */
    public static Opportunity addErrorOpp(Opportunity opp, Boolean noClnO, Boolean noClnC, Boolean diffCam, Boolean noPrdO, Boolean noPrdCam, Boolean diffPrd) {
        opp.addError(noClnO ? Label.MX_PYME_OppAccErrAccCamp : noClnC ? Label.MX_PYME_AccCampAccErrOpp : diffCam ? Label.MX_PYME_OppAccDifAccCamp : noPrdO ? Label.MX_PYME_OppPrdErrAccCamp : noPrdCam ? Label.MX_PYME_AccCampPrdErrOpp : diffPrd ? Label.MX_PYME_OppPrdDifAccCamp : '');
        return opp;
    }
}