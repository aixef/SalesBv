/**-------------------------------------------------------------------------
* Nombre: WB_ProcNotif_cls
* @author Karen Sanchez (KB)
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Clase test que sirve para la cobertura del schedulable MX_WB_EnvioLeadsCTI_shc

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           13/02/2019      Karen Sanchez            Creación
* --------------------------------------------------------------------------*/

global with sharing class MX_WB_EnvioLeadsCTI_shc implements Schedulable {
    /**
	*
	*
	*/
	global String sQuery {get;set;}
/**
*
*
*/
	global void execute(SchedulableContext scheCont) {
		final MX_WB_EnvioLeadsCTI_bch leadEnvio = new MX_WB_EnvioLeadsCTI_bch(sQuery);
		final Id batchInstanceId = Database.executeBatch(leadEnvio, 200);
		System.debug('batch id: ' + batchInstanceId);
	}
}