/********************************************************************************
*	@Autor:					Jair Ignacio Gonzalez Gayosso						*
*	@Proyecto:				Migracion BPyP										*
*	@Descripción:			Clases para complementar funcionalidad de 			*
*							Product Form en Oportunidades						*
*																				*
*	Cambios (Versiones)															*
*	--------------------------------------------------------------------------	*
*	No.		Fecha				Autor					Descripción				*
*	------  ----------  ----------------------		---------------------------	*
*	1.0		29/08/2019	Jair Ignacio Gonzalez G       	Creacion de Clase		*
*********************************************************************************/
public without sharing class MX_RTL_OppProductForm_cls {

    /** String RecordTypeDeveloperName Opportunity */
    static final String RTOPP = 'MX_BPP_RedBpyp';

    @TestVisible
	private MX_RTL_OppProductForm_cls() {

    }

	/**
      * @description Se le asigna una lista de precio a la oportunidad.
      */
    public static void bfInsertProd(List<Opportunity> triggerNew, Map<Id, RecordType> mapRT) {
        RecordType rTp;
    	Id idPB;

        for(PriceBook2 oPB:[SELECT Id, Name FROM PriceBook2 WHERE IsStandard = true LIMIT 1]) {
        	idPB = oPB.Id; //NOSONAR
    	}

        for(Opportunity opp: triggerNew) {
            rTP = mapRT.get(opp.RecordTypeId);
            if(rTP.DeveloperName == RTOPP) {
                opp.Name = 'Oportunidad ' + opp.MX_RTL_Producto__c;
            	opp.Pricebook2Id = idPB;
                opp.Amount = opp.op_amountPivote_dv__c;
            }
        }
    }

    /**
      * @description Crea un OpportunityLineItem a la Oportunidad de acuerdo al producto seleccionado
      */
    public static void afInsertProd(List<Opportunity> triggerNew, Map<Id, RecordType> mapRT) {
        RecordType rTp;
        final String oppCurrency = triggerNew[0].CurrencyIsoCode;
        final List<OpportunityLineItem> lstOppItem = new List<OpportunityLineItem>();

        final List <Product2> allProducts = [SELECT Name, Id, ProductCode, Family, IsActive,
                                    (SELECT Id, fprd__Version_number__c, fprd__Active__c FROM fprd__Product_versions__r WHERE fprd__Active__c = true LIMIT 1),
                                    (SELECT Id, CurrencyIsoCode FROM PricebookEntries WHERE CurrencyIsoCode =: oppCurrency),
                                    (SELECT Id, fprd__Map_field__c, fprd__DeveloperName__c FROM fprd__Product_configurations__r)
                                    FROM Product2 WHERE isActive = true AND Banca__c INCLUDES ('Red BPyP') ORDER BY Name asc];

        final Map <String, Product2> map_products = new Map <String, Product2>(); //NOSONAR
		for(Product2 prd2:allProducts) {
            if(prd2.ProductCode != null) {
             map_products.put(prd2.ProductCode, prd2);
            }
        }

        for(Opportunity opp: triggerNew) {
	        Product2 prd2;
            rTP = mapRT.get(opp.RecordTypeId);
            if(rTP.DeveloperName == RTOPP) {
                if(map_products.containsKey(opp.MX_RTL_Producto__c)) {
                    prd2 = map_products.get(opp.MX_RTL_Producto__c);
                    OpportunityLineItem oppItem = MX_RTL_OppProductForm_helper.afInsertProdHelper(opp, prd2); //NOSONAR
                    if (oppItem.OpportunityId <> null) {
                        lstOppItem.add(oppItem);
                    }
                } else {
                    opp.addError(System.Label.MX_RTL_ErrorProductCode);
                }
            }
        }

        insert lstOppItem;
    }

    /**
      * @description Validacion para que no se pueda modificar la Oportunidad si su producto tiene
      * 				campos obligatorios vacios
      */
    public static void bfUpdateProd(List<Opportunity> triggerNew, Map<id, RecordType> mapRT) {
        RecordType rTp;
        final List<OpportunityLineItem> lstOppItem = MX_RTL_OppProductForm_helper.getOptyProducts(triggerNew);
        final Set <Id> idProds = new Set<Id>();
        final Map<Id,OpportunityLineItem> mapOppItem = new Map<Id,OpportunityLineItem>();

        for(OpportunityLineItem oOppItem: lstOppItem) {
            mapOppItem.put(oOppItem.OpportunityId, oOppItem);
            idProds.add(oOppItem.Product2Id);
        }

        final Map<Id,List<fprd__GBL_Product_Configuration__c>> mapProdConf =  MX_RTL_OppProductForm_helper.getMapProdConf(idProds); //NOSONAR

        for(Opportunity opp: triggerNew) {
            rTP = mapRT.get(opp.RecordTypeId);
            if(rTP.DeveloperName == RTOPP && opp.StageName != 'Abierta') {

            	OpportunityLineItem objOppItem = mapOppItem.get(opp.Id); //NOSONAR
             	MX_RTL_OppProductForm_helper.bfUpdateProdHelper(opp, mapProdConf, objOppItem);
            }
        }
    }
}