({
    helperCreateNewTask: function(component) {
        var newTask = component.get("v.newTask");
        var action = component.get("c.saveTask");
        let isSegmented = component.get("v.isSegmented");
        let leadId = component.get("v.recordId");

        console.log("id lead " + leadId);
        action.setParams({
            "myTask": newTask,
            "segmented": isSegmented,
            "leadId": leadId
        });
        action.setCallback(this,function(response){
            var toastEvent = $A.get("e.force:showToast");
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            var state = response.getState();

            if(component.isValid() && state === "SUCCESS"){
                toastEvent.setParams({
        			"title": "Éxito!",
        			"message": "Se ha reagendado con exito.",
                     "duration": "1000",
                     "type": "success"
    				});

                	toastEvent.fire();
        			dismissActionPanel.fire();
            }
            else {
                console.log("Falló con estado: "+state);
            }
        });
        $A.enqueueAction(action);
    },
    helperGetUsr: function(component) {
        let getU = component.get("c.getUsers");
        getU.setCallback(this, function(response){
            let result = response.getReturnValue();
            component.set("v.manager", result);
            component.set("v.taskSubject", "Reagenda");
            console.log(component.get("v.manager"));
            component.set("v.isSegmented", result[1].MX_SB_VTS_TieneSegmento__c);
            component.set("v.isDisabled", true);
        });
     	$A.enqueueAction(getU);
    },
    helperHandleChange: function(component) {
        let task = component.get("v.newTask");
        task.Subject = component.get("v.taskSubject");
        task.Description = component.get("v.taskDescription");
        task.FechaHoraReagenda__c = component.get("v.taskActivityDate");

        let currentDate = component.get("v.manager[2]");
        if(task.FechaHoraReagenda__c < currentDate) {
            component.set("v.isDisabled", true);
            let toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "La fecha no puede ser menor al dia actual.",
                "duration": "1000",
                "type": "error"
            });
            toastEvent.fire();
        } else {
            component.set("v.isDisabled", false);
        }
        component.set("v.newTask", task);
    }
})
