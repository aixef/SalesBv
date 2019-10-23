({
	fireComponent : function(component, event, helper) {
        var compEvent = component.getEvent("notifyConcept");
        compEvent.setParams({
            "idConcepto": component.get('v.idConcepto'),
            "label" : event.currentTarget.name,
            "checked" : event.currentTarget.checked
        });
        compEvent.fire();
	}
})
