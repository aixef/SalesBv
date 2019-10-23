({
    invoke : function(component, event, helper) {       
        var destObject = component.get("v.SObject");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": destObject,
            "slideDevName": "related"
        });
        navEvt.fire();
    }
})
