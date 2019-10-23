({
    init : function(component, event, helper){
        helper.getTextos(component, event, helper);
    },
    guardar : function(component, event, helper){
        component.set("{!v.showSave}", false);
        helper.guardar(component, event, helper);
	},
    changeRes : function(component, event, helper){
        component.set("{!v.showSave}", true);
    }
})
