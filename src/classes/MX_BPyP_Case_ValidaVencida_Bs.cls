/**
* _________________________________________________________________________________
* @Name     MX_BPyP_Case_ValidaVencida_Bs
* @Author   Mario Calderón
* @Date     2019-07-11
* @Group    BPyP
* @Description Clase schedule, necesaria para programar la clase
*			   MX_BPyP_Case_ValidaVencida_Bs.
*              *Clase de pruebas MX_BPyP_Case_ValidaVencida_Test.
* @Changes
*
* _________________________________________________________________________________
*/
global without sharing class MX_BPyP_Case_ValidaVencida_Bs implements Schedulable {
	/**
    * @Method:      execute
    * @param:       SchedulableContext shdlctx
    * @Description: Método que ejecuta batch
    */
    global void execute(SchedulableContext shdlctx) {
        final MX_BPyP_Case_ValidaVencida_Batch batchCls = new MX_BPyP_Case_ValidaVencida_Batch();
        Database.executeBatch(batchCls);
    }
}