/**
* ------------------------------------------------------------------------------------------------
* @Name     MX_PyME_Campaign_GenOpp_cls
* @Author   Jhovanny De La Cruz Cruz jhovanny.delacruz.contractor@bbva.com
* @Date     Created: 2019-01-29
* @Group    Account Campaign Opportunities
* @Description Generating class of Opportunities from products coming from Campaigns
* @Changes
*
*  |2019-01-29  jhovanny.delacruz.contractor@bbva.com
*				Account Campaign Opportunities functionality class
*/

public with sharing class MX_PyME_Campaign_GenOpp_Cls {

    /** String Id RecordType*/
    static String idRtOpp;

    @TestVisible
	private MX_PyME_Campaign_GenOpp_Cls() {

    }
/*------------------------------------------------------------------------------------------------------
*@Description Method to obtain the necessary fields of the account campaign
* -----------------------------------------------------------------------------------------------------
* @Author   Jhovanny De La Cruz Cruz
* @Date     2019-01-29
* @param    idCampaign ID of the current Account Campaign
* @return   cond__Account_Campaign__c  Account Campaign
* @example  var action = component.get("c.getAccountCampaignFields"); javascript method
* */

    @AuraEnabled
    public static cond__Account_Campaign__c getAccountCampaignFields(String idCampaign) {
        cond__Account_Campaign__c accCamp = new cond__Account_Campaign__c();
        try {
            accCamp = [SELECT id,Name,cond__participant_id__c,cond__campaign_id__c FROM cond__Account_Campaign__c WHERE id =: idCampaign LIMIT 1]; //NOSONAR
        } catch (Exception e) { throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return accCamp;
    }

/*------------------------------------------------------------------------------------------------------
*@Description Method to obtain all the related products in the main campaign
* -----------------------------------------------------------------------------------------------------
* @Author   Jhovanny De La Cruz Cruz
* @Date     2019-01-29
* @param    idCampaign ID of the current Account Campaign
* @return   List<Product2>
* @example  var action = component.get("c.getProductCampaign"); javascript method
* */
    @AuraEnabled
    public static List<Product2> getProductCampaign(String idCampaign) {
        List<cond__Account_Campaign__c> accCamp = new List<cond__Account_Campaign__c>();
        List<Campaign> camps = new List<Campaign>();
        final List<String> prodValues = new List<String>();
        List<Product2> lsProd2 = new List<Product2>(); //NOSONAR
        try {
            String banca = '';
            banca = [SELECT id,Name,UG__c,VP_ls_Banca__c FROM User WHERE isActive = true AND Id =: UserInfo.getUserId()].VP_ls_Banca__c; //NOSONAR
            accCamp = [SELECT id,Name,cond__participant_id__c,cond__campaign_id__c FROM cond__Account_Campaign__c WHERE id =: idCampaign LIMIT 1];
            if(!accCamp.isEmpty()) {
                camps = [SELECT id,Name,MX_PYME_Productos__c,recordtypeId FROM Campaign WHERE id =: accCamp[0].cond__campaign_id__c LIMIT 1];
            }
            if(!camps.isEmpty()) {
                if(camps[0].MX_PYME_Productos__c == null) {
                    prodValues.add('');
                } else {
                    prodValues.addall(camps[0].MX_PYME_Productos__c.split(';'));
                }
            }
            if (!prodValues.isEmpty()) {
                lsProd2 = [SELECT id,Name,Family,ProductCode,Banca__c FROM Product2 WHERE IsActive = true AND ProductCode IN:prodValues AND Banca__c INCLUDES (:banca)]; //NOSONAR
            }
        } catch (Exception e) { throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return lsProd2;
    }

/*------------------------------------------------------------------------------------------------------
*@Description Method to obtain the banking opportunity related to the products of the campaign
* -----------------------------------------------------------------------------------------------------
* @Author   Jhovanny De La Cruz Cruz
* @Date     2019-01-29
* @param    idProduct2 id of the related product2
* @return   String  recordtypeid of the type of record of the opportunity to generate
* @example  var action = component.get("c.relatedRecordType"); javascript method
* */
    @AuraEnabled
    public static String relatedRecordType() {
        try {
        idRtOpp=[SELECT id,Name,DeveloperName FROM Recordtype WHERE SobjectType = 'Opportunity' AND DeveloperName =: 'MX_BPP_RedBpyp' LIMIT 1].id; //NOSONAR
        } catch (Exception e) { throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return idRtOpp;
    }
}