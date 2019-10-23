({
	doInit : function(component, event, helper) {
		helper.getOpportunities(component);
	},

    filter : function(component, event, helper){
        helper.filterValues(component);
    },

    closeModal : function(component){
        var childComponent = component.find('modalOpen');
        childComponent.destroy();
        $A.get('e.force:refreshView').fire();
        component.set("v.openModal",false);
    },

    handleRowAction: function (component, event) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        if (action.name === 'verModal'){
            component.set("v.body",[]);
            $A.createComponent(
                "c:MX_WB_EvaluacionCalidad",
                {
                    'aura:id':'modalOpen',
                    tipoVenta: row.StageName,
                    oppId: row.Id,
                    folioCotizacion: row.FolioCotizacion__c,
                    nombrePropietario: row.Owner.Name,
                    evaluacionCalidad:row.MX_WB_EvaluacionCalidad__c
                },
                function(newButton, status){
                    if (status === "SUCCESS") {
                        var body = component.get("v.body");
                        body.push(newButton);
                        component.set("v.body", body);
                    }
                }
            );
            component.set("v.openModal",true);
        }
    },

    updateColumnSorting: function (component, event, helper) {
        setTimeout(function() {
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            component.set("v.sortedBy", fieldName);
            component.set("v.sortedDirection", sortDirection);
            helper.sortData(component, fieldName, sortDirection);
        }, 0);
    },

    toSave: function (component){
        const button = component.find('buttonSave');
        button.set('v.disabled',true);
        var childComponent = component.find('modalOpen');
        childComponent.toSave();
    },

    buttonDisabled: function(component,event){
        const button = component.find('buttonSave');
        button.set('v.disabled',event.getParam("disabled"));
    },

    openHelpDoc : function(){
        var helpDocumentURL = $A.get("$Label.c.MX_WB_HelpDocURL");
        window.open(helpDocumentURL,'_blank');
    }
})
