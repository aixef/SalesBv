({
	doInit: function(component, event, helper) {
		helper.cargarDatos(component, event, helper);
		helper.ConstruyeTostadas(component);
	},
	waiting: function(component, event, helper) {
		component.set('v.HideSpinner', true);
	},
	doneWaiting: function(component, event, helper) {
		component.set('v.HideSpinner', false);
	}
});
