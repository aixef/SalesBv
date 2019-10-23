({
	init : function(component, event, helper) {
		component.set('v.isLoading', true);
		helper.findIdTray(component, event, helper);
	}
})
