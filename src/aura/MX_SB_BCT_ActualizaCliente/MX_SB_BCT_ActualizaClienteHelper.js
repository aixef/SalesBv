({
    helperMethod : function(component, event) {
        var idAcc = component.get("{!v.recordId}");
        var idOwnerAction = component.get("c.UpdateAcc");
         idOwnerAction.setParams({
            'idAcc': idAcc
          });
        idOwnerAction.setCallback(this, function (response) {
            var state = response.getState();
            var ownerIdResult = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.ownerId",response.getReturnValue());
                this.showAlert(component, event, "Exito", "dismissible","SUCCESS", "La cuenta ha actualizado la información de la cuenta correctamente"+ ownerIdResult);
            }
            else {
                this.showAlert(component, event, "Error", "dismissible","Error", "La cuenta no fue encontrada dentro de los registros BBVA"+ ownerIdResult);
            }
        });
        $A.enqueueAction(idOwnerAction);
    },
    showAlert : function(component, event, title, mode,type, message) {
    	     var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": title,
                    "mode": mode,
                    "duration": 3000,
                    "type": type,
                    "message": message
                });
                toastEvent.fire();
    }
})
