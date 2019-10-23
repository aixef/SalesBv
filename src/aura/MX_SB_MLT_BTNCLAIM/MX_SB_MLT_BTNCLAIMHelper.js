({
  idFederation : function(component, action) {
        return new Promise($A.getCallback(function(resolve, reject) {
            action.setCallback(this,
            function(response) {
               let idFed = response.getReturnValue();
               let state = response.getState();
               if (state === "SUCCESS") {
                   resolve(component.set("v.idFed", idFed));
               } else {
                  reject(new Error(response.getError()));
                }
            });
            $A.enqueueAction(action);
        }));
    }
})
