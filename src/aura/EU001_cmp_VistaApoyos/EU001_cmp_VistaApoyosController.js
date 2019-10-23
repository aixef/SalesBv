({
	 init: function(cmp, evt) {
        var action = cmp.get("c.getTableApoyos");
        var Status = cmp.find("selEstatusApoyoTab").get("v.value");
         var Ri = cmp.get("v.IdRICompromiso");
         var RecordTypeFilter = cmp.get("v.RecordTypeFilter");

        action.setParams({
            "idRI":Ri,
            "RecordTypeFilter":RecordTypeFilter,
            "Status": Status
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.rows", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    gotoURL : function (component, event, helper) {
        alert(event.getSource().get("v.label"));
        component.set('v.showModalNuevoApoyo', true);
    }
})
