/**
* _________________________________________________________________________________
* @Name     MX_BPyP_Case_ValidaVencida_Batch
* @Author   Mario Calderón
* @Date     2019-07-11
* @Group    BPyP
* @Description Clase que contiene la lógica para el batch de Apoyos que
*              se encarga de validar la Fecha propuesta de cierre del Apoyo y cambia el
*			   estatus a "Vencido" si es necesario.
*              *Clase de pruebas MX_BPyP_CompEU_ValidaVencida_Batch_Test.
*			   *Basado en MX_BPyP_CompEU_ValidaVencidad_Batch.
* @Changes
*
* _________________________________________________________________________________
*/
global without sharing class MX_BPyP_Case_ValidaVencida_Batch implements Database.Batchable<SObject> {
    /**
    * _____________________________________________________________________________
    * @Description   Método que obtiene todos los registros a manipular durante
    * 				 la ejecución del Batch.
    * _____________________________________________________________________________
    * @Author Mario Calderón
    * @Date 2019-07-11
    * @param batchCtx BatchableContext
    * @example Database.executeBatch(BatchInstance)
    * _____________________________________________________________________________
    **/
	global Database.QueryLocator start(Database.BatchableContext batchCtx) {
        return Database.getQueryLocator([SELECT Id, EU001_fh_Fecha_propuesta_de_cierre__c, Status FROM Case WHERE Status = 'Abierto' AND RecordType.DeveloperName = 'Apoyos']);
    }

    /**
    * _____________________________________________________________________________
    * @Description   Método que ejecuta el proceso principal del Batch.
    * _____________________________________________________________________________
    * @Author Mario Calderón
    * @Date 2019-07-11
    * @param batchCtx BatchableContext
    * @param scope lista de registros a manipular durante la ejecución
    * @example Database.executeBatch(BatchInstance)
    * _____________________________________________________________________________
    **/
    global void execute(Database.BatchableContext batchCtx, List<Case> scope) {
        final List<Case> apoyosBPyP = new List<Case>();
        for (Case caso : scope) {
            if(caso.EU001_fh_Fecha_propuesta_de_cierre__c < DateTime.now()) {
                caso.Status = 'Vencido';
                apoyosBPyP.add(caso);
            }
        }
        if (!apoyosBPyP.isEmpty()) {
            update apoyosBPyP;
        }
    }
    
    /**
    * _____________________________________________________________________________
    * @Description   Método que ejecuta después del proceso principal del Batch.
    * 				 No tiene acciones, pero es oblgiatorio para la clase.
    * _____________________________________________________________________________
    * @Author Mario Calderón
    * @Date 2019-07-11
    * @param batchCtx BatchableContext
    * @example Database.executeBatch(BatchInstance)
    * _____________________________________________________________________________
    **/
    global void finish(Database.BatchableContext batchCtx) { }
}