/*
*
* @author Jaime Terrats
* @description controller for lwc quote finder
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    04/10/2019     Jaime Terrats     Create controller
* @version  1.1    06/10/2019     Jaime Terrats    Add fields for each product type
*
*/
public without sharing class MX_SB_VTS_QuoteFinder {

    /*
    * Method to add values to for Quote Status search
    */
    private static Set<String> quoteStatus() {
        final Set<String> qStatus = new Set<String>();
        qStatus.add('Creada');
        qStatus.add('Cotizada');
        qStatus.add('Tarificada');
        qStatus.add('Formalizada');

        return qStatus;
    }

    /*
    * Private constructor to avoid singleton issue
    */
    private MX_SB_VTS_QuoteFinder() {//NOSONAR
    }

    /*
    * Method to return last 5 quotes from opportunity
    */
    @AuraEnabled(cacheable=true)
    public static List<Quote> getLast5Quotes(String oppId) {
        try {
            List<Quote> getQuotes = new List<Quote>();
            getQuotes = [Select Id, Name, Status, CreatedDate, Owner.Name,
                        MX_SB_VTS_Folio_Cotizacion__c,
                        (Select Product2.Name from QuoteLineItems) from Quote where
                        OpportunityId =: oppId and Status in: quoteStatus() order
                        by CreatedDate desc limit 5];
            return getQuotes;
        } catch(QueryException qEx) {
            throw new AuraHandledException(System.Label.MX_SB_VTS_Quote_Not_Found + qEx);
        }
    }

    /*
    * Method to search quote by number
    */
    @AuraEnabled(cacheable=true)
    public static Quote findQuote(String searchTerm) {
        try {
            Quote findQuote = new Quote();
            if(String.isNotBlank(searchTerm)) {
                findQuote = [Select Id, Name, Owner.Name, MX_SB_VTS_Folio_Cotizacion__c,
                        MX_SB_VTS_Familia_Productos__r.Name, MX_SB_VTS_Numero_de_Poliza__c,
                        MX_SB_VTS_Nombre_Contrante__c, MX_SB_VTS_Motivos_de_no_venta__c,
                        MX_SB_VTS_Codigo_verificacion__c, LastModifiedDate,
                        (select Product2.Name, MX_WB_nombreAsegurado__c,
                        MX_WB_Tipo_de_auto__c, MX_SB_VTS_Plan__c, MX_WB_Marca__c,
                        MX_WB_placas__c,MX_WB_numeroSerie__c, MX_SB_VTS_Version__c,
                        MX_WB_subMarca__c,MX_SB_VTS_Anio__c, TotalPrice, MX_WB_Modelo__c,
                        MX_SB_VTS_Casa_o_Departamento__c, MX_SB_VTS_Danos_Contenidos__c,
                        MX_SB_VTS_Danos_Inmueble__c, MX_SB_VTS_Equipo_Electronico__c,
                        MX_SB_VTS_RespPrivada_Familiar__c, MX_SB_VTS_Rotura_Cristales__c
                        from QuoteLineItems) from Quote where MX_SB_VTS_Folio_Cotizacion__c =: searchTerm
                        and Status in: quoteStatus()];
                }
            return findQuote;
        } catch(QueryException qEx) {
            throw new AuraHandledException(System.Label.MX_SB_VTS_Quote_Not_Found + qEx);
        }
    }

    /*
    * Method to update Quote
    */
    @AuraEnabled
    public static Boolean updateQuote(Quote quo) {
        final List<Quote> quoteToUpdate = new List<Quote>();
        try {
            Boolean flag = false;
            quoteToUpdate.add(quo);
            Database.update(quoteToUpdate);
            flag = true;
            return flag;
        } catch(DmlException dmlEx) {
            throw new AuraHandledException(System.Label.MX_SB_VTS_Quote_Not_Found + dmlEx);
        }
    }
}