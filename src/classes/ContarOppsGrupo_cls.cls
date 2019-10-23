/**
******************************************************************************
*	@Desarrollado por:		Indra												*
*	@Autor:					Arsenio Perez Lopez								*
*	@Proyecto:				Bancomer											*
*	@Descripción:			Trigger de usuarios									*
*																				*
*	Cambios (Versiones)															*
*	--------------------------------------------------------------------------	*
*	No.		Fecha				Autor					Descripción				*
*	------  ----------  ----------------------		---------------------------	*
*	1.0		21/11/2017	Arsenio perez lopez         Creación Trigger	        *
*   1.1     20/04/2018  Sergio Ortiz                Se Elimina Querys en for en *
*                                                   OppClienteGrupoBeforeInsert *
*	1.2		11/07/2019	Jair Ignacio Gonzalez G.	Se depuro clase con los		*
*													metodos confirmados en la	*
*													migracion de bpyp y pymes	*
********************************************************************************
*/
public without sharing class ContarOppsGrupo_cls {
	/** Varianbles Integer */
    static Integer oppsAbiertas, oppsCerradas, oppsDescartadas, oppsTotales;
	/** Set de Ids de Oportunidades */
    static Set<Id> oportunidadIds = new Set<Id>();// EGL
	/** Lista de Oportunidades */
	static List<Opportunity> lOpp = new list<Opportunity>();
	/** Set de Ids Usuarios */
	static set<Id> sUsr = new set<Id>();
	/** Set con las etapas */
	static set<String> etapasAbiertas = new set<String>{'Diagnóstico de necesidades','Diagnóstico de necesidades','Propuesta','Manejo de objeciones','Integración de información',
    												'Formalización','Firmas','Áreas centrales','Producto activado','Promoción','Análisis','Admisión','Formalización crédito',
    												'Desembolso','Autorizada','Negociación de tarea/Comisión','En contratación','Firmada'};
	/** Set con Ids de Clientes */
	static  Set<Id> clienteIds = new Set<Id>();

	private ContarOppsGrupo_cls() {
  	}

    /*****************
    +
    +
    +Base del trigger OppUsrTrigger.Trigger Se parte la logica acorde a su tiempo de ejecucion
    +Before Insert y Before Update
    +
    ******************/
	public static void oppUsrTiggerTrig(List<Opportunity>triggerNew, map<Id,Opportunity> triggerOldMap) {
		for(Opportunity opp : triggerNew) {
			if(Trigger.isUpdate) {
				final Opportunity oldOpp = triggerOldMap.get(opp.Id);
				if(opp.OwnerId!=oldOpp.OwnerId) {
					lOpp.add(opp);
					sUsr.add(opp.OwnerId);
				}
			} else {
				lOpp.add(opp);
				sUsr.add(opp.OwnerId);
			}
		}
		if (!sUsr.isEmpty()) {
			final map<Id,User> mpUsr = new map<Id,User>([SELECT Id,CR__c,Oficina__c,Divisi_n__c FROM User WHERE Id IN:sUsr]);
			for(Opportunity op : lOpp) {
				op.CR__c=mpUsr.get(op.OwnerId).CR__c;
				op.Oficina__c=mpUsr.get(op.OwnerId).Oficina__c;
				op.Division__c=mpUsr.get(op.OwnerId).Divisi_n__c;
			}
		}
	}

}