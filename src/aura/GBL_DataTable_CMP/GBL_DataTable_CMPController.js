({
    doInit : function(component, event, helper) {
        helper.doValidationRoleHelper(component,event,helper);
        helper.doInitHelper(component, event, helper);
    },
    Previous: function(component, event, helper) {
        helper.getElementsToShow( component, -1);
    },
    Next: function(component, event, helper) {
        helper.getElementsToShow( component, 1);
    },
    reloadTable: function(component,event,helper){
        helper.doInitHelper(component, event, helper);
    },
    goNavigation: function(component,event,helper){
        component.set('v.LoggedInF',false);
        helper.goNavigationHelper(component,event,helper);
    },
    goNavigationBack : function(component,event,helper){
        component.set('v.LoggedInF',false);
        helper.goNavigationBackHelper(component,event,helper);
    },
    showSpinner: function(component, event, helper) {
        helper.helpershowSpinner(component,event,helper);
    },
    hideSpinner : function(component,event,helper){
        helper.helperhideSpinner(component,event,helper);
    },
    getFlag : function(component,event,helper){
        helper.setNumContract(component,event,helper);
		helper.ConstruyeComponent(component);
        helper.getProductsDetailHelper(component,event,helper);
    }
})
