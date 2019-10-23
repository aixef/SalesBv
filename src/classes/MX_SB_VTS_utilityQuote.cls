/**-------------------------------------------------------------------------
* Name: Utility Quote Class
* @author Julio Medellin
* Proyect: MW SB VTS - BBVA
* Description : Utility class for the Quotes
* --------------------------------------------------------------------------
*                         Date           Author                   Description
* -------------------------------------------------------------------
* @version 1.0           May/22/2019      Julio Medellin            Header
* @version 1.1           May/27/2019      Jaime Terrats         Add new method to get pricebook entry id
* @version 1.1.1         Jun/06/2019      Eduardo Hernández     Fix para cotización Pricebook2Id
* @version 1.2           Jun/19/2019      Jaime Terrats         Se agrega validacion de numero de poliza cuando
*                                                               se emite un quote
* @version 1.2.1         06/28/2019       Eduardo Hernandez     Correccion para emisión de contratos
* @version 1.2.2         06/28/2019       Jaime Terrats         Refactor de method prepareQuoteSync
*--------------------------------------------------------------------------------**/

/**
* @description: update quote for synchronization
*/
public without sharing class MX_SB_VTS_utilityQuote {
    private  MX_SB_VTS_utilityQuote(){}//NOSONAR

    /*
    * method to sync opportunity with quote
    * @param quoteToSync quote object from service
    */
    public static string prepareQuoteSync(Quote quoteToSync) {
        String sOpportunityId = quoteToSync.OpportunityId;
        if(quoteToSync.status.equals(System.Label.MX_SB_VTS_STATUSEMITIDA_LBL) && String.isNotBlank(quoteToSync.MX_SB_VTS_Numero_de_Poliza__c)) {
            Opportunity opp = [SELECT Id,SyncedQuoteId FROM Opportunity WHERE Id=: sOpportunityId];
            opp.SyncedQuoteId=quoteToSync.Id;
            try {
                Database.update(opp);
            } catch(DmlException dmlEx) {
                throw new DmlException(System.Label.MX_WB_LG_ErrorBack + dmlEx);
            }
        }
        return  sOpportunityId;
    }

    /**
     * getPricebookEntry Obtine el precio
     * @param	presupuesto	Busca el presupuesto
     * @param	quoli	Id del quoli
     * @param	datosCotizacion	Datos de la cotización
     * @return	PriceBookEntryId	Regresa Id
    */
    public static Id getPricebookEntry(Quote presupuesto, QuoteLineItem quoli, List<String> datosCotizacion) {
        Boolean hasPriceBook = true;
        Id pbe1;
        try {
            for ( PricebookEntry pbe : [select Id,Pricebook2Id FROM PricebookEntry where Product2Id =: datosCotizacion[0] ] ) {
                quoli.PricebookEntryId = pbe.Id;
                presupuesto.Pricebook2Id = pbe.Pricebook2Id;
                pbe1 = pbe.Id;
                hasPriceBook = false;
            }
        } catch(QueryException qEx) {
            throw new QueryException('Error: ' + qEx);
        }

        if(hasPriceBook && String.isNotBlank(datosCotizacion[1])) {
            final Product2 product = [select ID, Name from Product2 where Id =: datosCotizacion[0]];
            final PricebookEntry pbe = MX_WB_OppoLineItemUtil_cls.crearPricebookEntry(product.ID, Decimal.valueOf(datosCotizacion[1]));
            try {
                Database.upsert(pbe);
            	quoli.PriceBookEntryId = pbe.Id;
                presupuesto.Pricebook2Id = pbe.Pricebook2Id;
                pbe1 = pbe.Id;
            } catch(DmlException dmlEx) {
                throw new DmlException('Fail: '+ dmlEx);
            }
            quoli.PriceBookEntryId = pbe.Id;
        }
        final Quote quotePB = [select Id, Pricebook2Id from Quote where Id =: presupuesto.Id ];
        quotePB.Pricebook2Id = presupuesto.Pricebook2Id;
        try {
            Database.update(quotePB);
        } catch(DmlException dmlEx) {
            throw new DmlException('Failed: '+ dmlEx);
        }
        return pbe1;
    }

    /*
    * Returns a boolean value to validate input
    * @params value: incoming string from api
    */
    public static Boolean checkBooleanValues(Boolean value) {
        return String.isNotBlank(String.valueOf(value)) ? true : false;
    }
}
