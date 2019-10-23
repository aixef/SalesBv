/*
*Desarrollado por:       Accenture SC
*Autor:                  Mario A. Calderón Muñoz
*Proyecto:               BPyP
*Descripción:            Controlador de componente Lightning para recuperar valores dependientes de otros valores y
*						 mostrarlos de manera dinámica (Basado en MX_BPP_Opportunity_Creator).
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0	| 24-01-2019	 |	  Mario Calderón		|	Creación
*1.1    | 27-05-2019     |    Hugo Carrillo         |   Correción de code smells detectados por sonar
*/


({
    doInit : function(component, event, helper) {
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI);
    },

    onControllerFieldChange: function(component, event, helper) {
        var controllerValueKey = event.getSource().get("v.value");
        var depnedentFieldMap = component.get("v.depnedentFieldMap");

        if (controllerValueKey !== '') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);
                helper.fetchDepValues(component, ListOfDependentFields);
            }else{
                component.set("v.bDisabledDependentFld" , true);
                component.set("v.listDependingValues", ['']);
            }

        } else {
            component.set("v.listDependingValues", ['']);
            component.set("v.bDisabledDependentFld" , true);
        }
        if (controllerValueKey === '') {
            component.set("v.campoPadre",controllerValueKey);
        }
        component.set("v.campoPadre",controllerValueKey);
        var cmpEvent = component.getEvent("PasoFiltrosOpp");
        cmpEvent.setParams({
            				"campoPadre" : controllerValueKey
        				   });
        cmpEvent.fire();
    },
    onControllerdependentFieldChange: function(component, event, helper) {
        var dependentValueKey = event.getSource().get("v.value");
        component.set("v.campoHijo",dependentValueKey);
        var cmpEvent = component.getEvent("PasoFiltrosOpp");
        cmpEvent.setParams({
            				"campoPadre" : component.get("v.campoPadre"),
            				"campoHijo" : dependentValueKey
        				   });
        cmpEvent.fire();
    }
})
