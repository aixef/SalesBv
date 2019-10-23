/****************************************************************************************************
author: Javier Ortiz Flores
company: Indra
Description:    Clase batch para recuperar llamadas de CTI

Information about changes (versions)
-------------------------------------
Number    Dates           Author                       Description
------    --------        --------------------------   -----------
1.0       01-Ene-2019     Javier Ortiz Flores          Creación de la Clase
****************************************************************************************************/
global with sharing class MX_WB_callCTI_sch implements Schedulable {
    /** */
	global void execute(SchedulableContext scheCont) {
        final String manana = String.valueOf(system.today()+1);
        final String ayer = String.valueOf(system.today()-1);
        final string servicio = 'SELECT Id FROM Lead WHERE MX_WB_EnvioCTI__c < '+manana+' AND MX_WB_EnvioCTI__c > '+ayer+' AND MX_WB_TM_Congelado__c = true LIMIT 5';
        final MX_WB_callBatch_bch objExecuteBatch = new MX_WB_callBatch_bch(String.escapeSingleQuotes(servicio));
        final Id batchInstanceId = Database.executeBatch(objExecuteBatch, 200);
    }
}