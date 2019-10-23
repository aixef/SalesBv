({
	recuperaEtapa : function(component, event, helper) {
		var action = component.get("v.opport");
        if(action) {
            component.set('v.etapa',action.fields.Status.value);
        }
	},

    recuperaScript : function(component, event, helper) {
        var action = component.get("c.getScript");
        var recordId = component.get("v.recordId");
        action.setParams({ strIdOpportunity : recordId});
        action.setCallback(this, function(response)
        {
            var states = response.getState();
            if(states === "SUCCESS")
            {
                component.set("v.script",response.getReturnValue());
            }
            else
            {
                component.set("v.script",'');
            }
		})
        $A.enqueueAction(action);
    },
})
