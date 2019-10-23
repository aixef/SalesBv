/*
*Proyecto:               Banca Patrimonial y Privada
*Descripción:
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0	| 		N/A	     |	   N/A					|	  	Creación
*1.1    |   01/07/2019   |  Hugo I. Carrillo B.     |       Correcciones de Code Smell identificados por Sonar
*/
({
	doInit: function(component) {
        component.set('v.ListOfOpp', null);
        component.find("pklBkMnBpyP").set("v.disabled", true);
        component.find("pklOffBpyP").set("v.disabled", true);
        var action = component.get('c.fetchDiv');
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfOpp attribute on component.
                component.set('v.ListOfDiv', response.getReturnValue());

            }
        });
        $A.enqueueAction(action);

    },
    generateChart : function(component,e,helper) {
        helper.helperGenerateChart(component,e,helper);
    },
    updDiv: function (component,e,helper){
        helper.resetdates(component,e);
        helper.fetchoff(component,e,helper);
    },
    updOffice: function (component,e,helper){
        helper.resetdates(component,e);
        helper.fetchbkm(component,e,helper);
    },
    updOpAc: function (component,e,helper) {
        helper.resetdates(component,e);
    	if (component.find("pklDivBpyP").get("v.value")==="") {
    		helper.drawdiv(component,e);
    	}
    	else if (component.find("pklOffBpyP").get("v.value")==="") {
    		helper.drawoff(component,e);
    	}
    	else if (component.find("pklBkMnBpyP").get("v.value")==="") {
	        helper.drawbkm(component,e);
    	}
    	else{
	        helper.drawbkmo(component,e);
    	}
	},
    updBkM: function(component,e,helper) {
    	component.set('v.ListOfOpp', null);
        helper.resetdates(component,e);
    	if (component.find("pklBkMnBpyP").get("v.value")==="") {
	        helper.drawbkm(component,e);
    	}
    	else{
	        helper.drawbkmo(component,e);
	    }
    },
})
