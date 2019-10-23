({
    createNewTask : function(component, event, helper) {
        helper.helperCreateNewTask(component);
    },
    getUsr : function(component, event, helper){
        helper.helperGetUsr(component);
	},

    cancelBtn : function(component, event, helper) {
        let dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	},

    handleChange : function(component, event, helper) {
        helper.helperHandleChange(component);
    }
})
