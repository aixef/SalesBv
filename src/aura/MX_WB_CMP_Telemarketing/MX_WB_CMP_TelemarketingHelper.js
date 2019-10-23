/**
* Nombre: MX_WB_CMP_TelemarketingHelper
* Autor Alexis Pérez
* Proyecto: MX WB TLMKT - BBVA Bancomer
* Descripción : Helper del componente MX_WB_CMP_Telemarketing
* Versión       Fecha           Autor                   Desripción<p />
* 1.0           20/12/2018      Alexis Pérez		    Creación
**/
({
	recuperaEtapa : function(component, event, helper) {
		var action = component.get("v.opport");
        if(action) {
            component.set('v.etapa',action.fields.StageName.value);
            component.set('v.producto',action.fields.Producto__c.value);
        }
	},

    recuperaScript : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getScript");
        action.setParams({ strIdOpportunity : recordId});

        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if(state === "SUCCESS")
            {
                component.set("v.script",response.getReturnValue());
            }
            else
            {
                component.set("v.script",'');
            }
		})
        $A.enqueueAction(action);
    },
})
