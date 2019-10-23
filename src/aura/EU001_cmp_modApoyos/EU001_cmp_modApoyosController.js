/*
*Desarrollado por:       Indra
*Autor:                  Isaías Velázquez Cortés
*Proyecto:               Experiencia Única
*Descripción:            Componente Controller
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 06-03-2018     |  Isaías Velázquez Cortés |           Creación
*1.1    | 12-06-2019     |  Hugo I. Carrillo Béjar  |   Corrección de code smells detectados por sonar
*/
({
    init: function (cmp, evt, helper) {
        var Ri = cmp.get("v.IdRICompromiso");
        if (Ri != null) {
            helper.helperAction2(cmp, Ri);
        }
    },
    handleCancel: function (component) {
        component.set('v.isActive', false);
    },
    saveRecord: function (component, event, helper) {
        var action = component.get("c.getInsertApoyos");
        var sIdRIS = component.get("v.IdRICompromiso");
        var TipoApoyo = component.find("selTipoApoyo").get("v.value");
        var Descripcion = component.find("txtDesc").get("v.value")
        var FechaC = "";
        FechaC = component.find("dtFechaCierre").get("v.value");
        var Estado = component.find("selEstado").get("v.value");
        var errMsg = false;
        if (sIdRIS.length === 0) {
            helper.mensajeAlerta(component, "Selecciona un RI válido.");
            errMsg = true;
        }
        if (TipoApoyo === "") {
            helper.mensajeAlerta(component, "Selecciona un Tipo de apoyo Válido.");
            errMsg = true;
        }
        if (Descripcion === "" || Descripcion.length === 0) {
            helper.mensajeAlerta(component, "Escriba un Descripción Válida.");
            errMsg = true;

        }
        if (FechaC == null || FechaC === "null" || FechaC === "") {
            helper.mensajeAlerta(component, "Selecciona Fecha válida.");
            errMsg = true;
        }

        if (Estado === "") {
            helper.mensajeAlerta(component, "Selecciona Estatus Válido.");
            errMsg = true;
        }

        if (!errMsg) {
            event.getSource().set("v.disabled", true);
            helper.saveRecordHelper(component, event, action);
        }
    },
})
