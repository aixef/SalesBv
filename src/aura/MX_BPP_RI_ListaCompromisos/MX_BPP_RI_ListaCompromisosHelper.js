/*
<!--
*Desarrollado por:       Indra
*Autor:                  Monserrat Gonzalez
*Proyecto:               BPP
*Descripción:            Basado en EU001_cmp_VistaCompromisos
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 18-05-2018     |    Monserrat Gonzalez	|           Creación
*1.1    | 03-06-2018     |    Hugo Ivan Carrillo    |   Resolución de code smells detectados por sonar
-->
**/
({
    mensajeAlerta : function(component,errMsg) {
               var toastEvent = $A.get("e.force:showToast");
                   toastEvent.setParams({
                       "title": "Error!",
                       "type": "error",
                       "message": errMsg
                   });
                   toastEvent.fire();
    },
    saveRecordHelper : function(component,event,action) {
        var IdCliente= component.get("v.selectedLookUpRecordAcc");
        var RecordTypeId= component.get("v.RecordTypeId");
        var sIdRIS=component.get("v.IdRICompromiso");
        var TipoCompromiso = component.find("selTipoComp").get("v.value");
        var Compromiso = component.find("txtCompromiso").get("v.value");
        var Estatus = component.find("selEstatusComp").get("v.value");
        var HCambios = component.find("txtHCambios").get("v.value");
        var FechaCierre = component.find("dtFechaCierre").get("v.value");
        action.setParams({
            "RType":RecordTypeId,
            "Cliente":IdCliente,
            "TipoComp":TipoCompromiso,
            "Compromiso":Compromiso,
            "sFechaCierre":FechaCierre,
            "Estatus":Estatus,
            "HCambios":HCambios,
            "sIdRI":sIdRIS
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var a = component.get('c.toggleDialog')
                $A.enqueueAction(a);
                var b = component.get('c.init');
                $A.enqueueAction(b);
                 component.set('v.showModalNuevoCompromiso', false);
                component.set('v.bModal',false);
             }
            else if (state === "INCOMPLETE") {
                event.getSource().set("v.disabled", false);
                this.mensajeAlerta(component ,"Unknown error");
            }
            else if (state === "ERROR") {
                event.getSource().set("v.disabled", false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.mensajeAlerta(component ,"Error:"+errors[0].message +" "+sIdRIS+":"+RecordTypeId);
                    }
                } else {
                    this.mensajeAlerta(component ,"Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})
