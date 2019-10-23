/*
* Quote Asing class
* @Autor: XXXXX
* @Create Date:27/03/2019
* @Proyect: BBVA_SEGUROS
* @Description: XXX
* -----Version-----
* 1.0 Creation ... 27/03/2019
*           No  |     Date     |     Author      |    Description
* @version  1.0    04/10/2019     Arsenio Perez      Creacion
*
*/
public without sharing class MX_SB_VTS_QuoteAsingOli_cls {
    /**Lista ListaMeta */
    static List<MX_SB_VTS_Generica__c> ListaMeta;
    /** */
    public static void reasingQuote(Map<id, Quote> trigerEntry,Map<Id,Quote> trigerOutEntry) {
        final set<Id> idOpps = new set<Id>();
        for(Quote temp:trigerEntry.values()) {
            if(temp.Status.equalsIgnoreCase(System.Label.MX_SB_VTS_STATUSEMITIDA_LBL)) {
                idOpps.add(temp.OpportunityId);
            }
        }
        if(idOpps.isEmpty() == false) {
            ftrreasingQuote(idOpps);
        }
    }

    /**
    * @@author Arsenio Perez Lopez
    * @Methodo de llamado a futuro para la asignacion correcta de los campos de QUote a OLI.
    */
    @future
    public static void ftrreasingQuote(set<id> trigerEntry) {
        try {
            List<SObject> LitUpdate = new LIST<SObject>();
            List<QuoteLineItem> Quoli= new List<QuoteLineItem>();
            final set<Id> idOpps = new set<Id>();
            String QueryFielsQuoLi = llenarArreglo();
            idOpps.addAll(trigerEntry);
            final String EMITIDA=system.Label.MX_SB_VTS_STATUSEMITIDA_LBL;
            Quoli = Database.Query('SELECT id, OpportunityLineItemID'+ String.escapeSingleQuotes(QueryFielsQuoLi) +' FROM QuoteLineItem WHERE Quote.IsSyncing =true and Quote.OpportunityId=:idOpps and Quote.status=:EMITIDA and Quote.MX_SB_VTS_Numero_de_Poliza__c !=null ');
            if(Quoli.isEmpty()==false) {
                for(QuoteLineItem Quolitemp: Quoli) {
                    SObject Olitemp = new OpportunityLineItem();
                    Olitemp.id=Quolitemp.OpportunityLineItemID;
                    for(MX_SB_VTS_Generica__c meta: ListaMeta) {
                        if(meta.MX_SB_VTS_Type__c=='CP1') {
                            if(meta.MX_SB_VTS_Quoli_Item__c.contains('Quote.')) {
                                final Quote quotesx = (Quote)Quolitemp.getSObject('Quote');
                                final String temp = meta.MX_SB_VTS_Quoli_Item__c.substringAfter('.');
                                Olitemp.put(meta.MX_SB_VTS_Oli_Item__c,quotesx.get(temp));
                            }else {
                                Olitemp.put(meta.MX_SB_VTS_Oli_Item__c,Quolitemp.get(meta.MX_SB_VTS_Quoli_Item__c));
                            }
                        }
                    }
                    LitUpdate.add(Olitemp);
                }
                update LitUpdate;
            }
        }
        catch(System.ListException ex) {
            throw new ListException(ex);
        }
    }
    /**Metodo llenarArreglo */
    public static String llenarArreglo() {
        string tempQueryFielsQuoLi='';
        ListaMeta = MX_SB_VTS_Generica__c.getall().values();
        for(MX_SB_VTS_Generica__c meta: ListaMeta) {
            if(meta.MX_SB_VTS_Type__c=='CP1') {
                tempQueryFielsQuoLi+=', '+meta.MX_SB_VTS_Quoli_Item__c;
            }
        }
        return tempQueryFielsQuoLi;
    }
}