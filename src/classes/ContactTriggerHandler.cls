/************************************************************************************************************
*	@Desarrollado por:		Indra																			*
*	@Autor:					Arsenio Perez Lopez																*
*	@Proyecto:				Bancomer																		*
*	@Descripción:			Trigger de usuarios																*
*																											*
*	Cambios (Versiones)																						*
*	--------------------------------------------------------------------------								*
*	No.		Fecha				Autor					Descripción											*
*	------  ----------  ----------------------		---------------------------								*
*	1.0		18/10/2017	Arsenio perez lopez         	Creación Trigger									*
*	1.01	13/03/2018	Ricardo Almanza Angeles        	ContUsr_Trigger agregado por incidencia BPyP        *
*	1.02    08/11/2018  Fernando Jaime					Unificación Trigger ADQ	                            *
*	1.03    17/12/2018  Angel Fuertes Gomez			    GBL_ARCEProcessB Agregado para Ficha Grupo (ARCE)	*
*************************************************************************************************************/
public with sharing class ContactTriggerHandler extends TriggerHandler {

	/** Mapa mapRecordtypeContacts*/
	map<Id, RecordType> mapRecordtypeContacts = new map<Id, RecordType>([Select Id, DeveloperName from RecordType where sObjectType='Contact']);
	/** Lista TriggerNew*/
	List<Contact> TriggerNew= (list<Contact>)(Trigger.new);
	/** Lista TriggerOld*/
	List<Contact> TriggerOld= (list<Contact>)(Trigger.old);
	/** Mapa TriggerNewMap*/
	Map<Id,Contact> TriggerNewMap= (Map<Id,Contact>)(Trigger.newMap);
	/** Mapa TriggerOldMap*/
	Map<Id,Contact> TriggerOldMap= (Map<Id,Contact>)(Trigger.oldMap);

	/*
    	@beforeInsert event override en la Clase TriggerHandler
    	Logica Encargada de los Eventos BeforeInsert */
	protected override void beforeInsert() {
        CheckContactField_cls.checkContactFields(TriggerNew, TriggerOld, TriggerNewMap, TriggerOldMap, mapRecordtypeContacts);
	}

	/*
		@beforeUpdate event override en la Clase TriggerHandler
		Logica Encargada de los Eventos BeforeUpdate*/
	protected override void beforeUpdate() {
		CheckContactField_cls.checkContactFields(TriggerNew, TriggerOld, TriggerNewMap, TriggerOldMap, mapRecordtypeContacts);
        //MX_ADQ_ReasignaActividadesContactoGoogle.updateContactsGoogle(TriggerOld, TriggerNewMap);
    }
}