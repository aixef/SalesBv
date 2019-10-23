/**
* _________________________________________________________________________________
* @Name     MX_BPyP_CompEU_ValidaVencida_Bs 
* @Author   Edmundo Zacarias edmundo.zacarias.contractor@bbva.com
* @Date     2019-07-11
* @Group    BPyP
* @Description Clase schedule, necesaria para programar la clase
*			   MX_BPyP_CompEU_ValidaVencida_Batch. 
*              *Clase de pruebas MX_BPyP_CompEU_ValidaVencida_Test.
* @Changes
*
* _________________________________________________________________________________
*/
global without sharing class MX_BPyP_CompEU_ValidaVencida_Bs implements Schedulable {
    /**
    * _____________________________________________________________________________
    * @Description   Método que ejecuta el Batch
    * _____________________________________________________________________________
    * @Date 2019-07-11
    * @param schdctxt ScheduleContext
    * @example Database.executeBatch(BatchInstance)
    * _____________________________________________________________________________
    **/
	global void execute(SchedulableContext schdctxt) {
        final MX_BPyP_CompEU_ValidaVencida_Batch batchCls = new MX_BPyP_CompEU_ValidaVencida_Batch();
        Database.executeBatch(batchCls, 3);
    }
}