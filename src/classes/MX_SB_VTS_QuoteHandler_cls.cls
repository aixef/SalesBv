/*
 * Quote Handler class
 * @Autor: XXXXX
 * @Create Date:27/03/2019
 * @Proyect: BBVA_SEGUROS
 * @Description: XXX
 * -----Version-----
 * 1.0 Creation ... 27/03/2019
 *
*/
public without sharing class MX_SB_VTS_QuoteHandler_cls extends TriggerHandler {
        /** Mapa MapNewQuote */
        Map<Id,Quote> MapNewQuote = (Map<Id,Quote>) Trigger.newMap;
    	/** Mapa MapOldQuote*/
        Map<Id,Quote> MapOldQuote = (Map<Id,Quote>) Trigger.oldMap;

    /**
     * @Method: Override the After Update method of the trigger
     * */
    protected override void afterUpdate() {
    	MX_SB_VTS_QuoteAsingOli_cls.reasingQuote(MapNewQuote,MapOldQuote);
        System.debug('MX_WB_QuoteHandler_cls');
    }
}