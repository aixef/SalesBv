({
    getCampanas: function (cmp) {

        var action = cmp.get("c.getListCampanas");
        action.setParams({  fFinVigCamp : cmp.get("v.FechaFinVigenciaCampania"),
                            fIniVigCamp : cmp.get("v.FechaInicioVigenciaCampania")});
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                cmp.set('v.data', response.getReturnValue());
            }
            else{
                console.log('error ' + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})
