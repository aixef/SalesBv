/*
<!--
*Desarrollado por:       Indra
*Autor:                  Monserrat Gonzalez
*Proyecto:               BPyP
*Descripción:            Basado en EU001_cmp_listOpp
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 17-05-2018     |    Monserrat Gonzalez      |           Creación
*1.1	| 24-01-2019	 |	  Mario Calderón		  |		Se agrega función que recibe dos campos nuevos para agregarlos al filtrado
															de las oportunidades.
-->
*/
({
	// Load expenses from Salesforce
	doInit: function(component, event, helper) {
            helper.setInitDates(component);
    },
    getOppRange: function(component, event, helper){
        if(!component.get("v.DATEINIT")){
        	helper.getOppWrapper(component);
        }
    },
    generaCompromisosView : function(component, event, helper) {
        helper.generaCompromisos(component);
	},
    ObtenerCamposPadreEHijo : function(component, event, helper) {
        var campoPadre = event.getParam("campoPadre");
        var campoHijo = event.getParam("campoHijo");
        component.set("v.campoPadre",campoPadre);
        component.set("v.campoHijo",campoHijo);
   		helper.getOppWrapper(component,event);
    }
})
