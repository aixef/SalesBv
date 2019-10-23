({
    cargarDatosServicios : function(component,event,helper) {
        var clientId = component.get("v.recordId");
        var action0 = component.get('c.getServices');
        action0.setParams({
            "clientId": clientId
        });
        action0.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var res= response.getReturnValue();
                component.set('v.wrapperVPF', res);
            }
        });
        $A.enqueueAction(action0);
    }
})
