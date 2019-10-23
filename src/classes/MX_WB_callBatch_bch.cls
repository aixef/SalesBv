/** 
*Create class 
*/
global without sharing class MX_WB_callBatch_bch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
	/** 
    */
    global String query { get; set; }
    /** 
    */
	global MX_WB_callBatch_bch(string query) {
		this.query = query;
	}
    /** 
    */
    global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(this.query);
	}
    /** 
    */
    global void execute(Database.BatchableContext BC, List<Lead> scope) {
        final Map<id, string> respuestasCTI = new Map<id, string>();
        for(Lead iteraLead : scope) {
            final string respuesta = MX_WB_regresosCall_cls.ftprocesaCall(iteraLead.id, 'ASD', '');
            respuestasCTI.put(iteraLead.id, respuesta);
        }
        system.debug('respuesta :::'+respuestasCTI);
        integer x = 0;
        if(!respuestasCTI.isEmpty()) {
            for(String iteraLead2 : respuestasCTI.values()) {
                x++;
                system.debug('contador entrada getListCall :::'+x);
                MX_WB_regresosCall_cls.getListCall(iteraLead2, true, '');
            }
        }

    }
    /** 
    *
    */
    global void finish(Database.BatchableContext BC) {
		System.debug('EN WB_DCPCSinPoliza_bch.finish Hora: ' + DateTime.now());
	}
}