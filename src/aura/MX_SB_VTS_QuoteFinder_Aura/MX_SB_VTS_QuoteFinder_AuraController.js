({
    handleChange: function(component, event, helper) {
        const searchTerm = component.get("v.searchTerm");
        if(isNaN(searchTerm)) {
            component.set("v.searchTerm", event.preventDefault());
        } else if(searchTerm === "") {
            component.set("v.hasRecord", false);
        } else {
            helper.getData(component);
        }
    },
    handleVerificationCode: function(component, event, helper) {
        const verificationCode = component.get("v.verification");
        if(isNaN(verificationCode)) {
            component.set("v.verification", event.preventDefault());
        } else {
            component.set("v.verification", verificationCode);
        }
    },
    get5Quotes: function(component, event, helper) {
        var action = component.get("c.getLast5Quotes");
		action.setParams({
			oppId: component.get("v.recordId")
		});

		action.setCallback(this, function(response) {
			let state = response.getState();
			if(state === "SUCCESS") {
				component.set("v.last5Quotes", response.getReturnValue());
			}
		});
        $A.enqueueAction(action);
    },
    handleSave: function(component, event, helper) {
       helper.handleSave(component);
    },
    handleSelectChange: function(component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        component.set("v.selectedOption", selectedOptionValue);
    },
    isRefreshed: function(component, event, helper) {
        var action = component.get("c.getLast5Quotes");
		action.setParams({
			oppId: component.get("v.recordId")
		});

		action.setCallback(this, function(response) {
			let state = response.getState();
			if(state === "SUCCESS") {
                component.set("v.last5Quotes", response.getReturnValue());
                component.set("v.searchTerm", "");
                component.set("v.hasRecord", false);
                $A.get("e.force:refreshView").fire();
			}
		});
        $A.enqueueAction(action);
    },
    changeQuote : function (component, event, helper) {
        var folioSelected = event.getSource().get('v.value');
        if($A.util.isEmpty(folioSelected)) {
            component.set('v.searchTerm', '');
            component.set('v.hasRecord', false);
        } else {
            component.set('v.searchTerm', folioSelected);
            component.set('v.hasRecord', true);
            var appEvent = $A.get("e.c:MX_SB_VTS_UpdateQuoteCot");
            appEvent.setParams({"FolioCotizacion" : folioSelected });
            appEvent.fire();
            helper.getData(component);
        }
    }
})
