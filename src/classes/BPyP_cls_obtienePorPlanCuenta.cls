/**
*Desarrollado por:       Indra
*Autor:                  Abraham Tinajero
*Proyecto:               BPyP
*Descripción:            Obtiene el porcentaje de preguntas contestadas en el plan de cuenta
*
*+Cambios (Versiones)
*+-------------------------------------------------------------------------------
*+No.         Fecha           	Autor                           Descripción
*------   ----------------   --------------------            ---------------
*1.0     	01-10-2015      	Abraham Tinajero (AATS)		    Creación
*1.1	 	18-01-2018			Cristian Espinosa				Sustitución del campo BPyP_tre_FolioCuenta__c por
*																No_de_cliente__c (SHIELD).
*1.2	 	20-02-2018			Ricardo Almanza					Se borró codigo ya que esos campos ya no existen en plan de cuenta y
																solo se dejo codigo de validación existente en un trigger
*1.21	 	26-03-2018			Ricardo Almanza					Se mejoró codigo para evitar query en for
**/

public with sharing virtual class BPyP_cls_obtienePorPlanCuenta {

	//Constructor with no arguments
	@TestVisible
	private BPyP_cls_obtienePorPlanCuenta() {}

	/** BPyP Valida si el Family Group esta aprobado. */
	public static Map<Id,Account> familyGroupAprobado(List<String> idCliente) {
		Map<Id,Account> familyGroup = new Map<Id,Account>([SELECT Id, Name,Estado__c FROM Account WHERE Id in: idCliente ]);
		return familyGroup;
	}
}