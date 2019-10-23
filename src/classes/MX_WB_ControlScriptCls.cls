/**-------------------------------------------------------------------------
* Nombre: MX_WB_ControlScriptsTgr_tst
* Autor Alexis Pérez
* Proyecto: MW WB TLMKT - BBVA Bancomer
* Descripción : Clase con lógica de trigger para evitar la inserción de más de un script
*				en la misma etapa y asociado a un mismo producto.
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Desripción<p />
* -------------------------------------------------------------------
* 1.0           06/12/2018      Alexis Pérez   			Creación
* 2.0           05/02/2019      Alexis Pérez   			Cambio de producto a Familia de producto.
* --------------------------------------------------------------------------
*/
public without sharing class MX_WB_ControlScriptCls {

    private MX_WB_ControlScriptCls() {}
    /*
     * Avoid inserting a record if it has the same stage and is associated with the same product as an existing record.
     * @param List<Scripts_Stage_Product__c> lstTgrNewScript	 incoming records.
     */
    public static void verificaExistenciaScript(List<Scripts_Stage_Product__c> lstTgrNewScript) {
        final List<Scripts_Stage_Product__c> lstTgrOldScript = [SELECT Id, MX_WB_Etapa__c, MX_WB_FamiliaProductos__c, MX_WB_Script__c
                                                          FROM Scripts_Stage_Product__c
                                                          WHERE NOT(MX_WB_Etapa__c = null)];
        System.debug('lstTgrOldScript::: ' + lstTgrOldScript);
        for(Scripts_Stage_Product__c iteratorOld : lstTgrOldScript) {
            for(Scripts_Stage_Product__c iteratorNew : lstTgrNewScript) {
                if(iteratorNew.MX_WB_Etapa__c == iteratorOld.MX_WB_Etapa__c && iteratorNew.MX_WB_FamiliaProductos__c == iteratorOld.MX_WB_FamiliaProductos__c) {
                    iteratorNew.addError(Label.MX_WB_lbl_MsgScriptException);
                }
            }
        }
    }
}