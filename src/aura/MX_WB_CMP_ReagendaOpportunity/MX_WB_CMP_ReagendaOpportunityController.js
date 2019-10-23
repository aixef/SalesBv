({
    init : function(component, event, helper) {
        helper.getFechaMin(component, event);
        helper.getAllData(component, event);

	},
    iniciaHorario: function(component, event, helper) {
        helper.creaElementoHora(component, event);
        helper.getUserTurno(component, event, component.get("v.turnoSeleccionado"));
	},

    cancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },

    save : function(component, event, helper) {
        helper.creaTarea(component, event);
    }
})
