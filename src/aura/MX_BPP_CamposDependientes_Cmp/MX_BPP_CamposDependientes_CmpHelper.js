/*
*Desarrollado por:       Accenture SC
*Autor:                  Mario A. Calderón Muñoz
*Proyecto:               BPyP
*Descripción:            Helper de componente Lightning para recuperar valores dependientes de otros valores y
*						 mostrarlos de manera dinámica (Basado en MX_BPP_Opportunity_Creator).
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0	| 24-01-2019	 |	  Mario Calderón		|	Creación
*1.1    | 27-05-2019     |    Hugo Carrillo         |   Solución de code smells detectados por sonar
*/


({
    fetchPicklistValues: function(component,objDetails,controllerField, dependentField) {
        var action = component.get("c.getDependentMap");
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var StoreResponse = response.getReturnValue();
                component.set("v.depnedentFieldMap",StoreResponse);

                var ControllerField = [];
                var SelectedRegisterTypes = [];
                SelectedRegisterTypes=component.get("v.listRecordTypes");

                for (var i = 0; i < SelectedRegisterTypes.length; i++){
                    ControllerField.push(SelectedRegisterTypes[i]);
                }
                component.set("v.listControllingValues", ControllerField);
            } else {
                  var toastEvent = $A.get("e.force:showToast");
        		  toastEvent.setParams({
            						  	title : 'Error',
            						  	message:'Ocurrió un error al cargar las dependencias',
            						  	duration:' 5000',
            						  	key: 'info_alt',
            						  	type: 'error',
            						  	mode: 'pester'
        							  });
        		  toastEvent.fire();
            	}
        });
        $A.enqueueAction(action);
    },
    fetchDepValues: function(component, ListOfDependentFields) {
        var dependentFields = [];
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        component.set("v.listDependingValues", dependentFields);
    },
})
