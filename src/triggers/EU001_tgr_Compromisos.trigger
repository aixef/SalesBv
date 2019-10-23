/**
*Desarrollado por:       Indra
*Autor:                  Abraham Tinajero
*Proyecto:               Experiencia Unica
*Descripción:            Actualiza el monto de la oportunidad
*
*Cambios (Versiones)
*-------------------------------------------------------------------------------
*No.         Fecha           Autor                           Descripción
*------   ----------------   --------------------            ---------------
*1.0      08-09-2017         Abraham Tinajero                 Creación
**/
trigger EU001_tgr_Compromisos on EU_001_Compromiso__c (before insert, before update, after insert, after update) {
	if(Trigger.isAfter) {
    	if(Trigger.isInsert) {
      		EU001_cls_CompHandler.actualizaMonto(Trigger.new);
    	} else if(Trigger.isUpdate) {
     		EU001_cls_CompHandler.actualizaMonto(Trigger.new);
    	}

  	}
}