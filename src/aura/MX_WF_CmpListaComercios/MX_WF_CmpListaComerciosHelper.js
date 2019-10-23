({
    getCampanas: function (cmp) {
        var action = cmp.get("c.getListComercios");
        action.setParams({  grupoComercial : cmp.get("v.grupo_comercial")});
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
