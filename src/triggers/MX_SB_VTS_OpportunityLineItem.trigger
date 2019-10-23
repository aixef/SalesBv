/*
 * Quote Trigger
 * @Autor: Jaime Terrats  
 * @Create Date:27/03/2019
 * @Proyect: BBVA_SEGUROS
 * @Description: XXXX
 * -----Version-----
 * 1.0 Creation ... 27/03/2019
 * 
*/
trigger MX_SB_VTS_OpportunityLineItem on OpportunityLineItem (before insert,after update,after insert, after delete) {
    new MX_SB_VTS_OLITriggerHandler().run();
}