/**-------------------------------------------------------------------------
* Nombre: MX_WB_TelemarketingController
* Autor Alexis Pérez
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Controller del componente lightning MX_WB_CMP_Telemarketing.

* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Desripción<p />
* -------------------------------------------------------------------
* 1.0           06/12/2018      Alexis Pérez		   	Creación
* 2.0			05/02/2019		Alexis Pérez			Cambio de producto a familia de producto.
* 2.1		05/02/2019	Eduardo Hernández	Cambio a familia de productos por proveedor para Outbound
* 2.1			23/06/2019		Eduardo Hernandez   	Fix coincidencias de productos
* --------------------------------------------------------------------------
*/
public without sharing class MX_WB_TelemarketingController {

    private MX_WB_TelemarketingController() {}

    /**
     * Return the relevant script based on the opportunity
     * @param String strIdOpportunity
     * @return String The required script.
     */
    @AuraEnabled
    public static String getScript(String strIdOpportunity) {

        Opportunity objOpp = null;
        Campaign objCampana = null;
        Scripts_Stage_Product__c objScriptStageProduct = null;
        String strScript = '';

        try {
            if(String.isNotBlank(strIdOpportunity)) {
                objOpp = [SELECT Id, CampaignId, Producto__c, StageName, Origen__c, LeadSource, RecordTypeId, RecordType.DeveloperName,MX_WB_Producto__c FROM Opportunity WHERE Id =: strIdOpportunity];
                String origen = String.isNotBlank(objOpp.Origen__c) ? objOpp.Origen__c : objOpp.LeadSource;
                if( objOpp.RecordType.DeveloperName.equals(System.Label.MX_SB_VTS_RecordTypeOutOpp) ) {
                    objCampana = recuperaCampana(objOpp.CampaignId);
                    objScriptStageProduct = recuperaScripts(objOpp.StageName, objCampana.MX_SB_VTS_FamiliaProducto_Proveedor__r.MX_SB_VTS_Familia_de_productos__c, origen);
                } else if( objOpp.RecordType.DeveloperName.equals(System.Label.MX_SB_VTS_RecordTypeASD) || objOpp.RecordType.DeveloperName.equals(System.Label.MX_SB_VTS_Telemarketing_LBL)) {
                    String prodCorrectName = MX_SB_VTS_CierreOpp.validacionproducto(objOpp.Producto__c);
                    Product2 product = findCorrectProd(prodCorrectName, objOpp.MX_WB_Producto__c);
                    objScriptStageProduct = recuperaScriptsInbound(objOpp.StageName, product.MX_WB_FamiliaProductos__c, origen);
                }
                if(String.isNotBlank(objScriptStageProduct.MX_WB_Script__c)) {
                    strScript = objScriptStageProduct.MX_WB_Script__c;
                }
            }
        } catch(QueryException ex) {
            throw new AuraHandledException(Label.MX_WB_lg_TlmktError + ex);
        }
        return strScript;
    }

    /**
     * Retrieve a campaign from your id.
     * @param String idCampana
     * @return Campaign The campaign object.
     */
    public static Campaign recuperaCampana(String idCampana) {
        Campaign objCampana = null;
        objCampana = [SELECT Id, Name, MX_SB_VTS_FamiliaProducto_Proveedor__r.MX_SB_VTS_Familia_de_productos__c
                      FROM Campaign
                      WHERE Id =: idCampana AND IsActive = true];

        return objCampana;
    }

    /**
     * Retrieves the script from the stage and the id of the product to which it is associated.
     * @param String strStageNameOpp, String strProducto
     * @return Scripts_Stage_Product__c The Scripts_Stage_Product__c object.
     */
    public static Scripts_Stage_Product__c recuperaScripts(String strStageNameOpp, String strFamProducto, String origen) {
        Scripts_Stage_Product__c objScriptStageProduct = null;
        objScriptStageProduct = [SELECT Id, Name, MX_WB_Etapa__c, MX_WB_FamiliaProductos__c, MX_WB_Script__c
                                 FROM Scripts_Stage_Product__c
                                 WHERE MX_WB_Etapa__c =: strStageNameOpp AND MX_WB_FamiliaProductos__c =: strFamProducto
                                 AND MX_SB_VTS_OrigenOpp__c =: origen];

        return objScriptStageProduct;
    }

     /**
     * Retrieves the script from the stage and the id of the product to which it is associated.
     * @param String strStageNameOpp, String strProducto
     * @return Scripts_Stage_Product__c The Scripts_Stage_Product__c object.
     */
    public static Scripts_Stage_Product__c recuperaScriptsInbound(String strStageNameOpp, String strFamProducto, String origen) {
        return [SELECT Id, Name, MX_WB_Etapa__c, MX_WB_FamiliaProductos__c, MX_WB_Script__c FROM Scripts_Stage_Product__c WHERE MX_WB_Etapa__c =: strStageNameOpp AND MX_WB_FamiliaProductos__c =: strFamProducto AND MX_SB_VTS_OrigenOpp__c =: origen];
    }

    /**
     * findCorrectProd Recupera registro correcto de productos
     * @param  nameProd nombre correcto
     * @param  prodId   id producto de la oportunidad
     * @return          retorna producto correcto
     */
    public static Product2 findCorrectProd(String nameProd, String prodId) {
        Product2 prod = new Product2();
        for(Product2 prods : [Select Id, Name,MX_WB_FamiliaProductos__c from Product2 where (Id =: prodId OR Name =: nameProd) AND MX_SB_SAC_Proceso__c = 'VTS']) {
            if(prods.Name.equals(nameProd)) {
                prod = prods;
            }
        }
        return prod;
    }
}
