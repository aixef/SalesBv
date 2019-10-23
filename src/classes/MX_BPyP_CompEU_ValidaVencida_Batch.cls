/**
* _________________________________________________________________________________
* @Name     MX_BPyP_CompEU_ValidaVencida_Batch
* @Author   Edmundo Zacarias edmundo.zacarias.contractor@bbva.com
* @Date     2019-07-09
* @Group    BPyP
* @Description Clase que contiene la lógica para el batch de CompromisosEU que
*              se encarga de validar la fecha de cierre del CompEU y cambia el
*			   estatus a vencido si es necesario.
*              *Clase de pruebas MX_BPyP_CompEU_ValidaVencida_Batch_Test.
* @Changes
*
* _________________________________________________________________________________
*/
global without sharing class MX_BPyP_CompEU_ValidaVencida_Batch implements Database.Batchable<SObject> {
    /**
    * _____________________________________________________________________________
    * @Description   Método que obtiene todos los registros a manipular durante
    * 				 la ejecución del Batch.
    * _____________________________________________________________________________
    * @Author Edmundo Zacarias edmundo.zacarias.contractor@bbva.com
    * @Date 2019-07-11
    * @param batchCtx BatchableContext
    * @example Database.executeBatch(BatchInstance)
    * _____________________________________________________________________________
    **/
	global Database.QueryLocator start(Database.BatchableContext batchCtx) {
        return Database.getQueryLocator([SELECT Id, Name, EU_001_Fm_Fecha_cierre__c, EU_001_ls_Estatus__c
                                          FROM EU_001_Compromiso__c
                                          WHERE EU_001_ls_Estatus__c IN ('Abierto', 'Reprogramado')
                                          AND RecordType.DeveloperName IN ('MX_BPP_Com_Captacion', 'MX_BPP_CompColocacion', 'MX_BPP_Seguros', 'MX_BPP_Servicios')
                                          ]);
    }

    /**
    * _____________________________________________________________________________
    * @Description   Método que ejecuta el proceso principal del Batch.
    * _____________________________________________________________________________
    * @Author Edmundo Zacarias edmundo.zacarias.contractor@bbva.com
    * @Date 2019-07-11
    * @param batchCtx BatchableContext
    * @param scope lista de registros a manipular durante la ejecución
    * @example Database.executeBatch(BatchInstance)
    * _____________________________________________________________________________
    **/
    global void execute(Database.BatchableContext batchCtx, List<EU_001_Compromiso__c> scope) {
        final List<EU_001_Compromiso__c> compromisosEU = new List<EU_001_Compromiso__c>();
        for (EU_001_Compromiso__c compromiso : scope) {
            if(compromiso.EU_001_Fm_Fecha_cierre__c < DateTime.now()) {
                compromiso.EU_001_ls_Estatus__c = 'Vencido';
                compromisosEU.add(compromiso);
            }
        }
        if (!compromisosEU.isEmpty()) {
        	update compromisosEU;
        }
    }

    /**
    * _____________________________________________________________________________
    * @Description   Método que ejecuta después del proceso principal del Batch.
    * 				 No tiene acciones, pero es oblgiatorio para la clase.
    * _____________________________________________________________________________
    * @Author Edmundo Zacarias edmundo.zacarias.contractor@bbva.com
    * @Date 2019-07-11
    * @param batchCtx BatchableContext
    * @example Database.executeBatch(BatchInstance)
    * _____________________________________________________________________________
    **/
    global void finish(Database.BatchableContext batchCtx) { }
}