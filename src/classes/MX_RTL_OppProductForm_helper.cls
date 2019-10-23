/********************************************************************************
*	  @Autor:					Jair Ignacio Gonzalez Gayosso
*	  @Proyecto:				Migracion BPyP
*	  @Descripción:			Clases para complementar funcionalidad de
*							Product Form en Oportunidades
*
*	  Cambios (Versiones)
*	  --------------------------------------------------------------------------
*	  No.		Fecha				Autor					Descripción
*	  ------  ----------  ----------------------		---------------------------
*	  1.0		29/08/2019	Jair Ignacio Gonzalez G       	Creacion de Clase
*********************************************************************************/
public with sharing class MX_RTL_OppProductForm_helper {

    @TestVisible
	  private MX_RTL_OppProductForm_helper() {

    }

    /**
      * @description Este metodo regresa una consulta con todos los campos de OpportunityLineItem.
      * @return String: La consulta con los campos
      */
    public static String queryOppItem() {
        final Map <String, Schema.SObjectField> fieldMap = Schema.SObjectType.OpportunityLineItem.fields.getMap();
        final list<Schema.SObjectField> lfi = fieldMap.values();
        final List<String> definitiveFields = new List<String>();

        for (Schema.SObjectField f: lfi ) {
            if ( f.getDescribe().getName().contains('__c') ) {
                definitiveFields.add(f.getDescribe().getName());
            }
        }

        final String allFields = String.join(definitiveFields,',');
        return 'select Id, Product2.Name, Product2Id, ProductCode, Quantity, UnitPrice, TotalPrice, Subtotal, Description,' +
        'CurrencyIsoCode, CreatedById, OpportunityId, PriceBookEntryId, fprd__GBL_Product_version__r.fprd__Version_number__c,' +allFields+
        ' from OpportunityLineItem';
    }

      /**
      *   @description Este metodo regresa una lista de OpportunityLineItem con todos los campos
      *   @return List: Lista con las OpportunityLineItem
      */
    public static List <OpportunityLineItem> getOptyProducts(List<Opportunity> optyIds) {

        List <OpportunityLineItem> toReturn;
        String query = String.escapeSingleQuotes(MX_RTL_OppProductForm_helper.queryOppItem()) + ' WHERE OpportunityId =: optyIds';
        query += ' ORDER BY Product2.Name asc';
        System.debug(query);
        toReturn = (List <OpportunityLineItem>)database.query(query);

        return toReturn;
    }

      /**
      *   @description Este metodo regresa un map con la relacion del Id del producto y sus registros de Product Configuration
      *   @return List: Map: Id del Producto, Registros de Product Configuration
      */
    public static Map<Id,List<fprd__GBL_Product_Configuration__c>> getMapProdConf(Set<Id> idProds) {
        final Map<Id,List<fprd__GBL_Product_Configuration__c>> mapProdConf = new Map<Id,List<fprd__GBL_Product_Configuration__c>>();

        final List <Product2> allProducts = [SELECT Name, Id, ProductCode, Family, IsActive,
                                    	(SELECT Id, fprd__Version_number__c, fprd__Active__c FROM fprd__Product_versions__r WHERE fprd__Active__c = true LIMIT 1),
                                    	(SELECT Id, fprd__Map_field__c, fprd__DeveloperName__c, fprd__Version_from__c, fprd__Version_to__c FROM fprd__Product_configurations__r WHERE fprd__Mandatory__c = true)
                                    	FROM Product2 WHERE Id =: idProds ORDER BY Name asc];

        for(Product2 objProd: allProducts) {
       		mapProdConf.put(objProd.id, objProd.fprd__Product_configurations__r);
        }

        return mapProdConf;
    }

      /**
      *   @description Metodo helper de afInsertProd regresa un OpportunityLineItem
      *   @return OpportunityLineItem
      */
      public static OpportunityLineItem afInsertProdHelper(Opportunity opp, Product2 prd2) {
        final OpportunityLineItem oppItem = new OpportunityLineItem();
        if(prd2.fprd__Product_versions__r.size()>0 ) {
          oppItem.fprd__GBL_All_fields_informed__c = false;
          oppItem.fprd__GBL_Cloned__c = false;
          oppItem.fprd__GBL_Product_version__c = prd2.fprd__Product_versions__r[0].Id;
          oppItem.fprd__GBL_Sample_Checkbox__c = false;

          for(fprd__GBL_Product_Configuration__c prdConf: prd2.fprd__Product_configurations__r) {
            if(String.isEmpty(oppItem.fprd__GBL_Visible_configurations__c)) {
              oppItem.fprd__GBL_Visible_configurations__c = prdConf.fprd__Map_field__c;
            } else {
              oppItem.fprd__GBL_Visible_configurations__c = oppItem.fprd__GBL_Visible_configurations__c + ',' + prdConf.fprd__Map_field__c;
            }

            if(String.isEmpty(oppItem.fprd__GBL_Visible_configurations__c)) {
              oppItem.fprd__GBL_Visible_configurations__c = prdConf.fprd__DeveloperName__c;
            } else {
              oppItem.fprd__GBL_Visible_configurations__c = oppItem.fprd__GBL_Visible_configurations__c + ',' + prdConf.fprd__DeveloperName__c;
            }
          }

          oppItem.OpportunityId = opp.Id;
          oppItem.PricebookEntryId = prd2.PricebookEntries[0].Id;
          oppItem.Product2Id = prd2.Id;
          oppItem.Quantity = 1;
          oppItem.UnitPrice = opp.Amount;

        }
        	return oppItem;
      }

      /**
      *   @description Metodo helper de bfupdateProd verifica que no se modifique la oportunidad si tiene campos pendientes el producto
      */
      public static void bfupdateProdHelper(Opportunity opp, Map<Id,List<fprd__GBL_Product_Configuration__c>> mapProdConf, OpportunityLineItem objOppItem) {
        for(fprd__GBL_Product_Configuration__c objProdConf : mapProdConf.get(objOppItem.Product2Id)) {

                	if((objProdConf.fprd__Version_from__c <= objOppItem.fprd__GBL_Product_version__r.fprd__Version_number__c || objProdConf.fprd__Version_from__c == null)
                   		&& (objProdConf.fprd__Version_to__c <= objOppItem.fprd__GBL_Product_version__r.fprd__Version_number__c || objProdConf.fprd__Version_to__c == null)
                        && (objOppItem.get(objProdConf.fprd__Map_field__c) == null || objOppItem.get(objProdConf.fprd__Map_field__c)== '')) {
                                opp.addError(System.Label.MX_RTL_NullFieldsProductForm);
                   	}
                }
      }

}