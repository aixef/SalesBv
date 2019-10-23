({
	initScript : function(component, event, helper) {
        helper.recuperaEtapa(component, event, helper);
        helper.recuperaScript(component, event, helper);
	},
    muestraTabla: function(component, event, helper) {
        if(component.get("v.showTab")){
            component.set("v.showTab", false);
        }else{
            component.set("v.showTab", true);
        }
    },
})
