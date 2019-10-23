/**
 * @File Name          : MX_WB_cmp_MasterChecklistHelper.js
 * @Description        :
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              :
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 24/4/2019 18:30:21
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    24/4/2019 18:25:06   Eduardo Hernández Cuamatzi     Initial Version
**/
({
	getTextos : function(component, event, helper) {
        var etapaActual = component.get("v.etapaActual");
        var producto = component.get("v.producto");
        var action = component.get("c.inicializaObjeciones");
        action.setParams({
            'etapa':etapaActual,
            'producto' :producto
        });
        action.setCallback(this, function(response) {
	        var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var reg = response.getReturnValue();
                var respuestas = [];
                for(var i = 0; i < reg.length; i++){
                    var subset = reg[i];
                    subset.check = false;
                    respuestas.push(subset);
                }
	            component.set("v.listaTextos", respuestas);
                component.set("v.guardarView", true);
	        }
	    });
	    $A.enqueueAction(action);
	},
    guardar : function(component, event, helper){
        var subsets = component.get("v.listaTextos");
        var action = component.get("c.guardaRespuestas");
        action.setParams({
            respuestas:JSON.stringify(subsets),
            OportunidadId :component.get("v.idOpp")
        });
        action.setCallback(this, function(response) {
	        var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("{!v.respSave}", response.getReturnValue());
	        }
	    });

	    $A.enqueueAction(action);
    }
})
