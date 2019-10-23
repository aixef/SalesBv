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
    mensajeAlerta: function (component, errMsg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type": "error",
            "message": errMsg
        });
        toastEvent.fire();
    },
    helperAction2: function (cmp, Ri) {
        var OwId;
        var action2 = cmp.get("c.getUser");
        action2.setParams({
            "recordId": Ri
        });
        action2.setCallback(this, function (response) {
            var state2 = response.getState();
            if (state2 === "SUCCESS") {
                var result = response.getReturnValue();
                cmp.set("v.PropietarioRI", result[0].Owner.Name);
                cmp.set("v.NombreRI", result[0].Name);
                cmp.set("v.UserID", result[0].OwnerId);
                OwId = result[0].OwnerId;
                this.helperAction3(cmp, OwId);
            }
        });
        $A.enqueueAction(action2);
    },
    helperAction3: function (cmp, OwId) {
        var action3 = cmp.get("c.getRecordTypeId");
        action3.setParams({
            "sObjType": 'Case',
            "Concepto": 'Apoyos'
        });
        action3.setCallback(this, function (response) {
            var state3 = response.getState();
            if (state3 === "SUCCESS") {
                var result3 = response.getReturnValue();
                cmp.set("v.RecordTypeId", result3);
                this.helperAction4(cmp, OwId);
            }
        });
        $A.enqueueAction(action3);
    },
    helperAction4: function (cmp, OwId) {
        var action4 = cmp.get("c.getSuperiorLevel");
        action4.setParams({
            "UserID": OwId
        });
        action4.setCallback(this, function (response) {
            var state4 = response.getState();
            if (state4 === "SUCCESS") {
                var result4 = response.getReturnValue();
                if (result4 !== "undefined" && result4 != null && result4 !== "") {
                    cmp.set("v.Responsable", result4[0].Name);
                    cmp.set("v.IdResponsable", result4[0].Id);
                }
                else {
                    cmp.set("v.Responsable", "Sin nivel superior asignado");
                }
            }
        });
        $A.enqueueAction(action4);
    },
    saveRecordHelper: function (component, event, action) {
        var IdCliente = component.get("v.selectedLookUpRecordAcc");
        var RecordTypeId = component.get("v.RecordTypeId");
        var sIdRIS = component.get("v.IdRICompromiso");
        var TipoApoyo = component.find("selTipoApoyo").get("v.value");
        var Descripcion = component.find("txtDesc").get("v.value");
        var Estado = component.find("selEstado").get("v.value");
        var Opportunity = component.get("v.selectedLookUpRecordOpp");
        var IdResponsable = component.get("v.IdResponsable");
        var CoResp1 = component.get("v.selectedLookUpRecordCorResponsable1");
        var CoResp2 = component.get("v.selectedLookUpRecordCorResponsable2");
        var FechaCierre = component.find("dtFechaCierre").get("v.value");

        action.setParams({
            "RType": RecordTypeId,
            "Cliente": IdCliente,
            "Tipo": TipoApoyo,
            "Descripcion": Descripcion,
            "sFechaCierre": FechaCierre,
            "Estado": Estado,
            "Opp": Opportunity,
            "sIdRI": sIdRIS,
            "idResponsable": IdResponsable,
            "idCoResp1": CoResp1,
            "idCoResp2": CoResp2

        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.isActive', false);
            } else if (state === "INCOMPLETE") {
                event.getSource().set("v.disabled", false);
                this.mensajeAlerta(component, "Unknown error");
            } else if (state === "ERROR") {
                event.getSource().set("v.disabled", false);
                var errors = response.getError();
                this.validateErrors(component, errors);
            }
        });
        $A.enqueueAction(action);
    },
    validateErrors: function (component, errors) {
        if (errors) {
            if (errors[0] && errors[0].message) {
                this.mensajeAlerta(component, "Error:" + errors[0].message + " " + sIdRIS + ":" + RecordTypeId);
            }
        } else {
            this.mensajeAlerta(component, "Unknown error");
        }
    }
})
