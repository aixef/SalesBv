/*
*Desarrollado por:       Luis Fernando Romero
*Autor:                  Luis Fernando Romero
*Proyecto:               Experiencia Única
*Descripción:            Se administran la lógica de las consultas para búsqueda de sObjects
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 13/08/18	    |    Luis Fernando Romero	| Creación
*1.2    | 27/05/19      |    Hugo I. Carrillo B.    | Correción de code smells detectados por sonar
*/
({
	searchHelper : function(component,event,getInputkeyWord) {
     var action = component.get("c.fetchLookUpValues");
      console.log(component.get("v.indicador"));
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'objectName' : component.get("v.objectAPIName"),
            'indicador': component.get("v.indicador")
          });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length === 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                component.set("v.listOfSearchRecords", storeResponse);
            }
        });
        $A.enqueueAction(action);
	},
})
