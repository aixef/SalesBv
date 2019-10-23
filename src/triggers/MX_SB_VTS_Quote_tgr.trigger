/*
 * Quote Trigger
 * @Autor: XXXXX
 * @Create Date:27/03/2019
 * @Proyect: BBVA_SEGUROS
 * @Description: XXXX
 * -----Version-----
 * 1.0 Creation ... 27/03/2019
 * 
*/
trigger MX_SB_VTS_Quote_tgr on Quote (After Update) {
	New MX_SB_VTS_QuoteHandler_cls().run();
}