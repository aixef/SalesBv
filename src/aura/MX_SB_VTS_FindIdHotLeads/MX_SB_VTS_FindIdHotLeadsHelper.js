({
	findIdTray : function(component, event, helper) {
		var idRecord = component.get('v.recordId');
		var actionCall = component.get('c.updateLeadsTray');
		actionCall.setParams({"recordId": idRecord});
		actionCall.setCallback(this, function(response){
			component.set('v.isLoading', false);
			var state = response.getState();
            if ( state === 'SUCCESS' ) {
				var responseCall = response.getReturnValue();
				if(responseCall.isOk) {
					console.log('Ok');
					helper.showToast(component, event, helper, $A.get("{!$Label.c.MX_SB_VTS_CotizadorExito_LBL}"), '', 'success');
				} else {
					console.log('no Ok');
					helper.showToast(component, event, helper, $A.get("{!$Label.c.MX_SB_VTS_errorGetRecords}"), '', 'error');
				}
			} else {
				console.log('no success');
				helper.showToast(component, event, helper, $A.get("{!$Label.c.MX_SB_VTS_errorGetRecords}"), '', 'error');
			}
			$A.get("e.force:refreshView").fire();
			$A.get("e.force:closeQuickAction").fire();
		});
		$A.enqueueAction( actionCall );
	},
	showToast : function(component, event, helper, msjTitle, msjBody, type) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": msjTitle,
            "message": msjBody,
            "type": type,
            "mode": "pester",
            "duration": "2000"
        });
        toastEvent.fire();
    }
})
