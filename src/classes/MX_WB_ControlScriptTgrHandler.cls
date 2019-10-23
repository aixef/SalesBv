/**-------------------------------------------------------------------------
* Nombre: MX_WB_ControlScriptsTgr_tst
* Autor Alexis Pérez
* Proyecto: MW WB TLMKT - BBVA Bancomer
* Descripción : Clase handler para trigger de Scripts_Stage_Product__c. 
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Desripción<p />
* -------------------------------------------------------------------
* 1.0           06/12/2018      Alexis Pérez   			Creación
* --------------------------------------------------------------------------
*/
public class MX_WB_ControlScriptTgrHandler extends TriggerHandler {
    
    /**
    * Incoming records list.
    */
    List<Scripts_Stage_Product__c> lstTgrNewScript = (list<Scripts_Stage_Product__c>)(Trigger.new);
    
    /**
    * Overwrite the event beforeInsert following the structure of Kevin O'hara framework 
    */
    public override void beforeInsert() {
        MX_WB_ControlScriptCls.verificaExistenciaScript(lstTgrNewScript);
  	}
}