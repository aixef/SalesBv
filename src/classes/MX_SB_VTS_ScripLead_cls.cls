/**-------------------------------------------------------------------------
* Nombre: MX_SB_VTS_ScripLead_cls
* @author Arsenio Perez Lopez (xemo)
* Proyecto: MW SB VTS - BBVA 
* Descripción : Clase control para componente MX_SB_VTS_ScripLead

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           25/04/2019      Arsenio  Perez            Creación
* @version 1.0           25/04/2019      Eduardo Hernandoez        Creación
* --------------------------------------------------------------------------*/
public without sharing class MX_SB_VTS_ScripLead_cls {
    /**
    * @Method: GetScrip: utilizado para obtener el Scrip en base al lead.
    * @Param: strIdOpportunity- Recibe el Id del lead que se va a consultar.
    */
    @AuraEnabled
    public static String getScript(String strIdOpportunity) {
        Campaign objCampana = null;
        Scripts_Stage_Product__c objScriptStageProduct = null;
        String strScript = '';
        try {
            Lead objOpp = [SELECT Id, LeadSource, RecordType.DeveloperName, Status FROM Lead WHERE Id =: strIdOpportunity];
            if(System.Label.MX_SB_VTS_RecordTypeASD.equals(objOpp.RecordType.DeveloperName) || System.Label.MX_SB_VTS_Telemarketing_LBL.equals(objOpp.RecordType.DeveloperName)) {
                if(System.Label.MX_SB_VTS_InboundLabel.equals(objOpp.LeadSource) || System.Label.MX_SB_VTS_OrigenCallMeBack.equals(objOpp.LeadSource )) {
                    objScriptStageProduct = recuperaScripts(objOpp.Status, objOpp.LeadSource);
                }
            } else if(System.Label.MX_SB_VTS_RecordTypeOut.equals(objOpp.RecordType.DeveloperName)) {
                objScriptStageProduct = recuperaScripts(objOpp.Status, objOpp.LeadSource);
            }
            if(String.isNotBlank(objScriptStageProduct.MX_WB_Script__c)) {
                strScript = objScriptStageProduct.MX_WB_Script__c;
            }
        } catch(QueryException ex) {
            throw new AuraHandledException(Label.MX_WB_lg_TlmktError + ex);
        }
        return strScript;
    }
    /**
     * Retrieves the script from the stage and the id of the product to which it is associated.
     * @param String strStageNameOpp 
     */
    public static Scripts_Stage_Product__c recuperaScripts(String strStageNameOpp, String origen) {
        return [SELECT Id, Name, MX_WB_Etapa__c, MX_WB_FamiliaProductos__c, MX_WB_Script__c
                                 FROM Scripts_Stage_Product__c
                                 WHERE MX_WB_Etapa__c =: strStageNameOpp AND MX_SB_VTS_OrigenOpp__c =: origen];
        
    }
}