({
    helperInit : function(component) {
        var activeContracts = component.get('c.fetchActiveContractsByAccount');
        let recordId = component.get('v.recordId');
        activeContracts.setParams({
            'oppId': recordId
        });
        activeContracts.setCallback(this, function(response){
            let result = response.getReturnValue();
            component.set('v.activeContracts', result);
            this.helperGetLength(component);

        });
     	$A.enqueueAction(activeContracts);
    },
    helperGetLength: function(component) {
        console.log('helperGetLength');
        let array = component.get('v.activeContracts');
        console.log(array.length);
        switch(array.length) {
            case null:
            case undefined:
                component.set('v.listLength', 0);
                break;
            default:
                component.set('v.listLength', array.length);
                break;
        }
    }
})
