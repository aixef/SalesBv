/*
* BBVA - Mexico
* @Author: Diego Olvera
* MX_SB_VTS_OpportunityTrigger
* @Version 1.0
* @LastModifiedBy: Diego Olvera
* @ChangeLog
* 1.0 Created class - Diego Olvera
*/

public without sharing class MX_SB_VTS_OpportunityTrigger {//NOSONAR
    /**
    * @method: susbtractContactTouchOpp
    * @description: substract counter
    * @params: oppItem <Trigger.new>, oldMap <Trigger.oldMap>
    */
    public static void substractContactTouchOpp(List<Opportunity> oppItem, Map<Id, Opportunity> oldMap) {
        final Id recordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_Telemarketing_LBL).getRecordTypeId();
        for(Opportunity lst : oppItem) {
            final Opportunity oldOpp = oldMap.get(lst.Id);
            final Integer contador = MX_SB_VTS_LeadAutoAssigner.checkNullVals(lst.MX_SB_VTS_ContadorRemarcado__c);
            if (lst.RecordTypeId.equals(recordType) && contador>0 && System.Label.MX_SB_VTS_Nocontacto.equals(lst.MX_SB_VTS_Tipificacion_LV2__c) && String.isBlank(oldOpp.MX_SB_VTS_Tipificacion_LV2__c)) {
                lst.MX_SB_VTS_ContadorRemarcado__c = contador-1;

            }
        }
    }
	/**
	* @method: substracteffectiveContactOpp
    * @description: adds +1 to counter
    * @params: oppItem <Trigger.new>, oldMap <Trigger.oldMap>
	*/
    public static void substractEffectiveContactOpp (List<Opportunity> oppItem, Map<Id, Opportunity> oldMap) {
        final Id recordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_Telemarketing_LBL).getRecordTypeId();
        for(Opportunity lst: oppItem) {
            final Opportunity oldOpp = oldMap.get(lst.Id);
            final Integer contador2 = MX_SB_VTS_LeadAutoAssigner.checkNullVals(lst.MX_SB_VTS_Llamadas_Efectivas__c);
            if(lst.RecordTypeId.equals(recordType) && System.Label.MX_SB_VTS_ContactoEfectivo.equals(lst.MX_SB_VTS_Tipificacion_LV2__c)   && String.isBlank(oldOpp.MX_SB_VTS_Tipificacion_LV2__c)) {
                lst.MX_SB_VTS_Llamadas_Efectivas__c = contador2+1;
            }
        }
    }
	/**
	* @method: substractNoEffectiveContactOpp
    * @description: adds +1 to counter to MX_SB_VTS_Llamadas_No_Efectivas
    * @params: oppItem <Trigger.new>, oldMap <Trigger.oldMap>
	*/
    public static void substractNoEffectiveContactOpp(List<Opportunity> oppItem, Map<Id, Opportunity> oldMap) {
        final Id recordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_Telemarketing_LBL).getRecordTypeId();
        for(Opportunity lst: oppItem) {
            final Opportunity oldOpp = oldMap.get(lst.Id);
            final Integer contador3 = MX_SB_VTS_LeadAutoAssigner.checkNullVals(lst.MX_SB_VTS_Llamadas_No_Efectivas__c);
            if(lst.RecordTypeId.equals(recordType) && System.Label.MX_SB_VTS_Nocontacto.equals(lst.MX_SB_VTS_Tipificacion_LV2__c)  && String.isBlank(oldOpp.MX_SB_VTS_Tipificacion_LV2__c)) {
                lst.MX_SB_VTS_Llamadas_No_Efectivas__c = contador3 + 1;

             }

        }

    }
}