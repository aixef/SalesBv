/*
*Desarrollado por:       Indra
*Autor:                  Alberto Galindo
*Proyecto:               Experiencia Única
*Descripción:            Componente Controller
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor             |          Descripción
*************************************************************************************
*1.0    | 23-08-2017     |   Alberto Galindo     |          Creación
*1.1	| 08-01-2019	 |	 Cristian Espinosa	 |			Corrección de incidencia, se castean los parametros
		|				 |						 |			enviados al método apex 'setSobjectRating', mediante
        |				 | 						 |			el método action.setParams.
*1.2    | 27-5-2019      |  Hugo I. Carrillo B.  |          Corrección de errores de code smell, detectados por
*       |                |                       |          sonar.
*/
({
    starClick : function(component, event, helper) {
        var colorOn = component.get("v.colorOn");
        var colorOff = component.get("v.colorOff");
        var rating = 0;
        var el = event.target;

        while (el) {
            rating++;
            el.style.fill = colorOn;
            el = el.previousElementSibling;
        }
        el = event.target.nextElementSibling;
        while (el) {
            el.style.fill = colorOff;
            el = el.nextElementSibling;
        }
        if(component.get("v.status")!=='Finalizacion'){
        component.set("v.rating", rating);
        var action = component.get("c.setSobjectRating");

        action.setParams({
            "apiName" : String(component.get("v.apiName")),
            "recordId" : String(component.get("v.recordId")),
            "rating" : String(rating),
            "evaluador": String(component.get("v.childAttribute"))
        });

        action.setCallback(this, function(response){
        });

        $A.enqueueAction(action);
        }

        var ratingEvent = component.getEvent("change");
        ratingEvent.setParams({
            "rating": rating
        });
        ratingEvent.fire();
	}
})
