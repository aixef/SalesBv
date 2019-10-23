/*-------------------------------------------------------------------------
* Nombre: WB_ProcNotifTriggerHandler
* @author Karen Sanchez (KB)
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Clase que manda a llamar la lógica en la clase WB_ProcNotif_cls para ejecutar procesos programados

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 2.0           13/01/2019      Karen Sanchez            Creación
* --------------------------------------------------------------------------*/
public with sharing class WB_ProcNotifTriggerHandler extends MX_RT_TriggerHandler {
    /** List*/
	List<ProcNotiOppNoAten__c> triggerNewProcNotif = (list<ProcNotiOppNoAten__c>)(Trigger.new);
    /** List*/
	List<ProcNotiOppNoAten__c> triggerOldProcNotif = (list<ProcNotiOppNoAten__c>)(Trigger.old);
    /** Map*/
	Map<Id,ProcNotiOppNoAten__c> triggerOldMapProcNotif= (Map<Id,ProcNotiOppNoAten__c>)(Trigger.oldMap);

	/*
    @afterUpdate event override en la Clase TriggerHandler
    Logica Encargada de los Eventos afterUpdate*/
    protected override void afterUpdate() {
       WB_ProcNotif_cls.agendarProcesoNotif(triggerNewProcNotif, triggerOldMapProcNotif);
       MX_SB_VTS_ScheduldOppsTele_cls.sendOppsHogar(triggerNewProcNotif, triggerOldMapProcNotif);
    }
}