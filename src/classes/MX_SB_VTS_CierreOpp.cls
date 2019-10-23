/*
*
* @author Jaime Terrats
* @description This class will be to validate opportunity stage name closed won or lost
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    04/10/2019     Jaime Terrats     Create data structure to get incoming data from web tracking
* @version  1.1    05/15/2019     Sergio Alvarez    Corrección de codeSmells
* @version  1.2    05/16/2019     Arsenio Perez     Corrección de codeSmells
* @version  1.3    05/21/2019     Jaime Terrats     Corrección de CodeSmells
* @version  1.3    05/27/2019     Eduardo Hernandez Corrección de CodeSmells
* @version  1.4    06/17/2019     Jaime Terrats     Se agrega validacion para closed won
* @version  1.5    06/20/2019     Jaime Terrats     Se agrega label para error en closed won
*
*/
public without sharing class MX_SB_VTS_CierreOpp extends MX_SB_VTS_ValidCorrectNamesASD {

    private MX_SB_VTS_CierreOpp(){//NOSONAR
    }
    /*
	 * Method to validate if opportunity should be closed as won or lost
	 * only works for Telemarketing - outbound and inbound - asd
	 */
    public static void validaCierre(List<Opportunity> oppsToProcess) {
        // Opp Id set to get contracts
        final Set<Id> oppIds = new Set<Id>();
        // Contract list to validate if opp can be closed as won
        final List<Contract> getContracts = new List<Contract>();
        // This list will be filter to work only in the opps that we need
        final List<Opportunity> oppFilter = new List<Opportunity>();
		// List of quotes to validate close - lost reason
        final List<Quote> getQuotes = new List<Quote>();

        // Get RT Ids
        final Id tlmkRt = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(System.label.MX_SB_VTS_RecordTypeOutOpp).getRecordTypeId();
        final Id asdRt = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(System.label.MX_SB_VTS_RecordTypeASD).getRecordTypeId();

        for(Opportunity opp: oppsToProcess) {
            if(opp.RecordTypeId == tlmkRt || opp.RecordTypeId == asdRt) {
                oppIds.add(opp.Id);
                oppFilter.add(opp);
            }
        }
        getContracts.addAll([Select Id from Contract where MX_WB_Oportunidad__c in: oppIds]);

        getQuotes.addAll([Select Id, MX_SB_VTS_Motivos_de_no_venta__c from Quote where OpportunityId in: oppIds]);

        for(Opportunity opp: oppFilter) {
            switch on opp.StageName {
                when 'Closed Won' {
                	oppCerradaGanada(opp);
                }
                when 'Closed Lost' {
                    if(getQuotes.isEmpty()) {
                        validaOpp(opp);
                    } else {
                        validateQuote(getQuotes, opp);
                    }
                }
            }
        }
    }

    /**
     * validateQuote Valida Quote
     * @param  listQuote Una lista de Quote
     * @param  opp Una oportunidad
    */
    public static void validateQuote(List<Quote> listQuote, Opportunity opp) {
        for(Quote q: listQuote) {
            if(String.isNotBlank(q.MX_SB_VTS_Motivos_de_no_venta__c) && String.isNotBlank(opp.Motivosnoventa__c)) {
                opp.StageName = System.label.SAN163_WSOppotunityBlackListStageName;
            } else {
                opp.addError(System.label.MX_SB_VTS_NOVENTASQUOTE);
            }
        }
    }

    /**
     * validaOpp Valida Oportunidad
     * @param  opp Una oportunidad
    */
    public static void validaOpp (Opportunity opp) {
        if(String.isNotBlank(opp.Motivosnoventa__c)) {
            opp.StageName = System.label.SAN163_WSOppotunityBlackListStageName;
        } else {
            opp.addError(System.label.MX_SB_VTS_NOVENTASOPP);
        }
    }

    /**
     * validNamesOppASD Valida nombre de productos ASD
     * @param  oppsToProcess Lista de Oportunidades
     */
    public static void validNamesOppASD(List<Opportunity> oppsToProcess) {
        final List<Product2> lstProduct = [Select Id, Name from Product2 where MX_WB_FamiliaProductos__r.Name =: System.Label.MX_SB_VTS_RecordTypeASD];
        final Id idRecTypOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_RecordTypeASD).getRecordTypeId();
        final Id idRTOpp =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_Telemarketing_LBL).getRecordTypeId();
        for(Opportunity oppObj : oppsToProcess) {
            if(oppObj.RecordTypeId.equals(idRecTypOpp) || oppObj.RecordTypeId.equals(idRTOpp)) {
                final String correctName = validacionProducto(oppObj.Producto__c);
                oppObj.Producto__c = correctName;
                findProduct(oppObj, correctName, lstProduct);
            }
        }
    }

    /**
    * Obtiene un Nombre correcto para producto
    * @param String producto Respuesta String
    */
    public static String validacionProducto(String producto) {
        String correctName = producto;
        correctName = MX_SB_VTS_ValidCorrectNamesASD.validProASD(producto);
        final String vartem1 = correctName;
        correctName = MX_SB_VTS_ValidCorrectNamesASD.validProMoto(vartem1);
        final String vartem2 = correctName;
        correctName = MX_SB_VTS_ValidCorrectNamesASD.validProFront(vartem2);
        final String vartem3 = correctName;
        correctName = MX_SB_VTS_ValidCorrectNamesASD.validProLegal(vartem3);
        return correctName;
    }

    /**
     * findProduct Encuentra producto correspondiente
     * @param  opp        Oportunidad
     * @param  name       nombre correcto
     * @param  lstProduct Lista de productos
     */
    public static void findProduct(Opportunity opp, String name, List<Product2> lstProduct) {
        for(Product2 prodObject : lstProduct) {
            if (prodObject.Name.equals(name)) {
                opp.MX_WB_Producto__c = prodObject.Id;
            }
        }
    }

    /*
     * @param opp que sera cerrada como ganada
     * Method empleado para el cierre de opps ganadas
     *
     */
    private static void oppCerradaGanada(Opportunity opp) {
    	if(opp.MX_SB_VTS_Aplica_Cierre__c) {
            opp.StageName = System.Label.MX_SB_VTS_CLOSEDWON_LBL;
        } else {
            opp.addError(System.Label.MX_SB_VTS_errorClosedWon);
        }
    }
}
