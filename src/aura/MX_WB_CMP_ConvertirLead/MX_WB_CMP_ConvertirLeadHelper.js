/**
* Nombre: MX_WB_CMP_ConvertirLeadHelper
* Autor Alexis Pérez
* Proyecto: MX WB TLMKT - BBVA Bancomer
* Descripción : Helper del componente MX_WB_CMP_ConvertirLead
* Versión       Fecha           Autor                   Desripción<p />
* 1.0           15/01/2019      Alexis Pérez		    Creación
**/
({
    convertir : function(component, event) {
         document.getElementById("spinner").style.display = "block";

        var action = component.get("c.convertirLead");
        action.setParams({ idLead : component.get("v.recordId")});
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if(state === "SUCCESS")
            {
                if(response.getReturnValue().ERROR !== undefined){
                    document.getElementById("spinner").style.display = "none";
                    component.set("v.mensaje",response.getReturnValue().ERROR);
                    component.set("v.tipoMensaje"," slds-theme--error slds-theme--alert-texture");
                } else {
                    document.getElementById("spinner").style.display = "none";
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": response.getReturnValue().OK
                    });
                    navEvt.fire();
                }
            }
            else if(state === "ERROR"){
                document.getElementById("spinner").style.display = "none";
                var errors = response.getError();
                console.log(errors);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                    	component.set("v.tipoMensaje"," slds-theme--error slds-theme--alert-texture");
                    	component.set("v.mensaje",errors[0].message);
                    }
                }
            }
		})
        $A.enqueueAction(action);
    }
})
