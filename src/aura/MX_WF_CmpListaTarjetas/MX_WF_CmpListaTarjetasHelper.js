({
    getCampanas: function (cmp) {
        var action = cmp.get("c.getListTarjetas");
        action.setParams({  vfecha : cmp.get("v.Fecha")});
        action.setCallback(this, function(response) {
            if(response.getState()==='SUCCESS') {
                cmp.set('v.data', response.getReturnValue());
            }
            else{
                console.log('error ' + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})
