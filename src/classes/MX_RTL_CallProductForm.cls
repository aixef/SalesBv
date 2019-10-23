/**_____________________________________________________________________________________
*MX_RTL_CallProductForm
*Proyecto:      Migracion Salesforce Retail
*Descripción:   Apex Controller del componente MX_RTL_CallProductForm
*_______________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        10/09/2019     Jair Ignacio Gonzalez                  Creación.
**/
public with sharing class MX_RTL_CallProductForm {

    @TestVisible
	private MX_RTL_CallProductForm() {

    }

    @AuraEnabled
    /**
     * Buscamos si el producto seleccionado tiene campos configurados
     */
    public static Integer getProdConf(String oppId) {
        Integer nProdConf;
        try {
            final OpportunityLineItem oppItem = [SELECT Id, Product2Id FROM OpportunityLineItem WHERE OpportunityId =:oppId LIMIT 1];

        if(oppItem != null) {
            final Product2 prod2 = [SELECT Id, ProductCode, Family, IsActive,
                                    (SELECT Id, fprd__Map_field__c, fprd__DeveloperName__c FROM fprd__Product_configurations__r WHERE fprd__Header__c = FALSE AND fprd__Hidden__c = FALSE)
                                    FROM Product2 WHERE Id =:oppItem.Product2Id];

            nProdConf = prod2.fprd__Product_configurations__r.size(); //NOSONAR
            }
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return nProdConf;
    }

    @AuraEnabled
	/**
	*Query a Opportunity de acuerdo al Id
	*/
    public static Opportunity getOpp(String oppId) {
        try {
            System.debug('Regreso Info getOpp');
    		return [SELECT Id, Name, RecordType.Name, RecordType.DeveloperName, RecordType.Id, MX_RTL_BanderaOpp__c FROM Opportunity WHERE Id=:oppId];
		} catch(QueryException e) { System.debug('Excepcion getOpp');throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e); }
    }

    @AuraEnabled
	/**
	* Quita el check MX_RTL_BanderaOpp__c de la oportunidad
	*/
    public static void updCheckOpp(String oppId) {
        Opportunity objOpp = new Opportunity();
		try {
    		objOpp = [Select Id, Name, MX_RTL_BanderaOpp__c from Opportunity where Id=:oppId];

            if(objOpp.MX_RTL_BanderaOpp__c == true) {
            	objOpp.MX_RTL_BanderaOpp__c = false;
            	update objOpp;
            }

		} catch(QueryException e) { throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e); }
    }


}