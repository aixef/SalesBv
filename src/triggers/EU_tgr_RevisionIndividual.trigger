/**
*Desarrollado por:       Indra
*Autor:                  Abraham Tinajero
*Proyecto:               Experiencia Unica
*Descripción:            Genera compromisos a partir de las oportunidades generadas por el ejecutivo
*
*Cambios (Versiones)
*-------------------------------------------------------------------------------
*No.         Fecha           Autor                           Descripción
*------   ----------------   --------------------            ---------------
*1.0      16-08-2017         Abraham Tinajero	             Creación
*2.0      06-03-2018         Abraham Tinajero	             Se implementa framwork de kevin O'hara
**/
trigger EU_tgr_RevisionIndividual on EU001_RI__c (before insert,after insert, before update, after update, after delete) {
	new EU001_cls_RITriggerHandler().run();
}