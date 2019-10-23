/**
* Nombre: MX_WB_CMP_ConvertirLeadRenderer
* Autor Alexis Pérez
* Proyecto: MX WB TLMKT - BBVA Bancomer
* Descripción : Renderer del componente MX_WB_CMP_ConvertirLead
* Versión       Fecha           Autor                   Desripción<p />
* 1.0           18/01/2019      Alexis Pérez		    Creación
**/
({
    afterRender : function(cmp, helper){
        this.superAfterRender();
        var action= cmp.get("c.convertir");
        $A.enqueueAction(action);
    }
})
