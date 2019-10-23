/**
* Nombre: MX_WB_CMP_TelemarketingController
* Autor Alexis Pérez
* Proyecto: MX WB TLMKT - BBVA Bancomer
* Descripción : Controller del componente MX_WB_CMP_Telemarketing
* Versión       Fecha           Autor                   Desripción<p />
* 1.0           20/12/2018      Alexis Pérez		    Creación
**/
({
	initTlmkt : function(component, event, helper) {
        helper.recuperaEtapa(component, event, helper);
        helper.recuperaScript(component, event, helper);
	},
    muestraTabla: function(component, event, helper) {
        if(component.get("v.showTab")){
            component.set("v.showTab", false);
        }else{
            component.set("v.showTab", true);
        }
    },

    muestraRichText: function(component, event, helper) {
        if(component.get("v.showRichText")){
            component.set("v.showRichText", false);
        }else{
            component.set("v.showRichText", true);
        }
    }
})
