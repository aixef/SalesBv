/********************************************************************************
*	@Desarrollado por:		Indra												*
*	@Autor:					Arsenio Perez Lopez									*
*	@Proyecto:				Bancomer											*
*	@Descripción:			Trigger de usuarios									*
*																				*
*	Cambios (Versiones)															*
*	--------------------------------------------------------------------------	*
*	No.		Fecha				Autor					Descripción				*
*	------  ----------  ----------------------		---------------------------	*
*	1.0		21/11/2017	Arsenio perez lopez         	Creación Trigger		*
*	1.1		31/01/2018	Ing. Pedro Alan Sierra		Se agregan 2 métodos (ActualizaOLI y AsingaTipoTechoDesdeProduct2);	*
*   1.2     28/02/2018	Arsenio Perez Lopez		 	Se agregan 2 métodos mas 	*
*   1.3     23/05/2018  Luis Fernando Romero        Se cambian de clase los métodos para etapas de HP   *
*   1.4     24/08/2018  Jhovanny De La Cruz 		Se agrega un nuevo llamado a una clase tipo service "GBL_CS_OP_cls_CommercialAction" *
*	1.5		11/09/2018	Daniel García				Se agrega un método (turnOpInDev- Convertir oportunidad en desarrollo)
*	1.6		09/10/2018	Cristian Espinosa			Se elimina método que llamaba a AsignarUSAC_Oportunidad_cls.AsignarProductoOpp_tgr
*   1.7     29/ENE/2019 Ricardo Almanza             Se agrega método para Campaña y Oportunidad
*   2.0     16/04/2019  Lisandro Ortiz Reynosa      Se agrega método "countDisposicion" para contar las disposiciones de la oportunidad
*	2.1		15/05/2019	Cristian Espinosa			Se agrega el método asignaRTPiloto, el cual sirve para asignar el RT a las oportunidad cuando sean
													creadas por un usuario con los tipos de registro de pricing asignados
*   2.2     16/05/2019  Mario Calderón              Se agrega método en before Insert y before Update para Oportunidades de BHI
*	2.3		23/05/2019	Cristian Espinosa			Se elimina el método 'CrearPrimeraDisposicion' por problemas de límites.
*   2.4     09/07/2019  Jair Ignacio Gonzalez G     Se depuro clase con los metodos confirmados en la migracion de bpyp y pymes
*********************************************************************************/
public without sharing class OportunidadTriggerHandler extends TriggerHandler {

	/** Map con los RecordType de Oportunidades */
	map<Id, RecordType> mapRecordTypesOpp = new map<Id, RecordType>([Select Id, DeveloperName from RecordType where sObjectType='Opportunity']);
	/** Lista de Trigger.new */
	List<Opportunity> triggerNew= (list<Opportunity>)(Trigger.new);
	/** Lista de Trigger.old */
	List<Opportunity> triggerOld= (list<Opportunity>)(Trigger.old);
	/** Map de Trigger.new */
	Map<Id,Opportunity> triggerNewMap= (Map<Id,Opportunity>)(Trigger.newMap);
	/** Map de Trigger.old */
	Map<Id,Opportunity> triggerOldMap= (Map<Id,Opportunity>)(Trigger.oldMap);

    /*
    	@beforeInsert event override en la Clase TriggerHandler
    	Logica Encargada de los Eventos BeforeInsert */
	protected override void beforeInsert() {
        if(Trigger_Oportunidad__c.getInstance().TriggerOportunidad_Master__c || Test.isRunningTest()) {
            /** Escribe aqui el metodo de la clase que contiene la lógica de tu trigger para before insert */
            MX_RTL_OppProductForm_cls.bfInsertProd(triggerNew, mapRecordTypesOpp);
            EG009_OP_FinanciamientoPipeline_cls.updateRecordTypeOportunity(triggerNew, mapRecordTypesOpp);
            ContarOppsGrupo_cls.oppUsrTiggerTrig(triggerNew, triggerOldMap);
        }
        // MX_Opp_AsignaFamilia_cls.asignaFamilia(triggerNew,'Before ins');
    }

	/*
		@beforeUpdate event override en la Clase TriggerHandler
		Logica Encargada de los Eventos BeforeUpdate*/
	protected override void beforeUpdate() {
        if(Trigger_Oportunidad__c.getInstance().TriggerOportunidad_Master__c || Test.isRunningTest()) {
            /** Escribe aqui el metodo de la clase que contiene la lógica de tu trigger para before update */
                ContarOppsGrupo_cls.oppUsrTiggerTrig(triggerNew, triggerOldMap);
            	MX_RTL_OppProductForm_cls.bfUpdateProd(triggerNew, mapRecordTypesOpp);
            // AsignarUSAC_Oportunidad_cls.ADQ_ReasActiOporGo_beforeUpdate(triggerNewMap,triggerOld);
        }
        // MX_Opp_AsignaFamilia_cls.asignaFamilia(triggerNew,'Before Update');
	}

	/*
		@beforeDelete event override en la Clase TriggerHandler
		Logica Encargada de los Eventos BeforeDelete*/
	//protected override void beforeDelete() {

	//}

	/*
		@afterInsert event override en la Clase TriggerHandler
		Logica Encargada de los Eventos AfterInsert*/
	protected override void afterInsert() {
        if(Trigger_Oportunidad__c.getInstance().TriggerOportunidad_Master__c || Test.isRunningTest()) {
            MX_RTL_OppProductForm_cls.afInsertProd(triggerNew, mapRecordTypesOpp);
            /** Escribe aqui el metodo de la clase que contiene la lógica de tu trigger para after insert
            *EG009_OP_FinanciamientoPipeline_cls.CreaOLICuandoInsertaOportunidad(triggerNew, mapRecordTypesOpp);
			*/
            MX_PYME_AccCampOpp_Cls.addOppToAccCampaign(triggerNewMap,null);
        }
    }

	/*
		@afterUpdate event override en la Clase TriggerHandler
		Logica Encargada de los Eventos afterUpdate*/
	protected override void afterUpdate() {
        if(Trigger_Oportunidad__c.getInstance().TriggerOportunidad_Master__c || Test.isRunningTest()) {
            /**Escribe aqui el metodo de la clase que contiene la lógica de tu trigger para after update
            * EG009_OP_FinanciamientoPipeline_cls.ActualizaOLI(triggerNew, triggerOldMap, mapRecordTypesOpp);
			*/
            MX_PYME_AccCampOpp_Cls.addOppToAccCampaign(triggerNewMap,triggerOldMap);
        }
    }
}