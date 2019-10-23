/*
*Desarrollado por:
*Autor:
*Proyecto:               BPyP
*Descripción:
*Cambios (Versiones)
********************************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
********************************************************************************************************
*1.0    |      			 |    				       |           Creación
*1.1    | 07-01-2019     |    Hugo Carrillo        |  Correcciones de Code Smell identificados por Sonar
*/
({
	init : function(component,e,h) {

		if (window.location.pathname==='/lightning/n/MX_BPP_Cumpleanios'&&!component.get('v.isFull')) {
			component.set('v.isFull', !component.get('v.isFull'));
		}
		h.obtTotPag(component,e,h);
		var action = component.get('c.fetchAcc');
		var mth=typeof component.find("pklMthBrth") === "undefined"||typeof component.find("pklMthBrth").get("v.value") === "undefined"?0:component.find("pklMthBrth").get("v.value");

		if (!component.get('v.isFull'))
			action.setParams({sLim : component.get('v.previewSize'),sOff : component.get('v.offsetFull'),sMth : String(mth)});
		else
			action.setParams({sLim : component.get('v.fullSize'),sOff : component.get('v.offsetFull'),sMth : String(mth)});
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=null){
                	component.set('v.ListOfAcc', response.getReturnValue());
                }
            }
            else if (state === "ERROR"){
            	alert(response.getError());
            	alert(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
	},
	geturl : function(component,e,h){
		var action= component.get('c.fetchbaseurl');
		action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=null){
                	component.set('v.baseurl', response.getReturnValue());
                }
            }
            else if (state === "ERROR"){
            	alert(response.getError());
            	alert(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
	},
	setoffset : function(component,e,h,v){
		component.set('v.offsetFull',String(v));
	},
	obtTotPag : function(component,e,h){
		var action = component.get('c.fetchNumAcc');
		var mth=typeof component.find("pklMthBrth") === "undefined"||typeof component.find("pklMthBrth").get("v.value") === "undefined"?0:component.find("pklMthBrth").get("v.value");

		action.setParams({sLim : component.get('v.fullSize'),sMth : String(mth)});
		action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=null){
                	component.set('v.totPage', response.getReturnValue());
                	component.set('v.nTotPage', response.getReturnValue());
                }
            }
            else if (state === "ERROR"){
            	alert(response.getError());
            	alert(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
	},
})
