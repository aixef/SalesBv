/*
*Desarrollado por:       Indra
*Autor:                  Javier Ortiz F.
*Proyecto:               Experiencia Única
*Descripción:            Componente helper
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 20-12-2017     |   Javier Ortiz F.        |           Creación
*1.1    | 10-07-2018     |   Ricardo Almanza        |    Mejora para no multiples RI
*/
({
    init: function(cmp, evt, helper) {
        helper.verificaSTAFF(cmp);
        helper.VerificaDirector(cmp);
        cmp.set("v.rows", null);
        var action = cmp.get("c.getRI");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.rows", response.getReturnValue());
            }
        });

        $A.enqueueAction(action);
    },
    toggle: function(cmp, evt) {
        var rows = cmp.get("v.rows");
        rows[evt.target.dataset.index].expanded = !rows[evt.target.dataset.index].expanded;
        cmp.set("v.rows", rows);
    },

    sendParams:function(cmp,event,helper){
        //Consulta la RI seleccionada para mostrar su detalle
        helper.activaVista(cmp,event,helper);
    },

    generaNuevoRIController: function(component, event, helper) {
        //Ejecuta el método de generar nueva RI
        component.set("v.Spinner", true);
        helper.generaNuevoRI(component,event);
    },
    // this function automatic call by aura:doneWaiting event
    // make Spinner attribute to false for hide loading spinner
    hideSpinner : function(component,event,helper){ component.set("v.Spinner", false); },
})
