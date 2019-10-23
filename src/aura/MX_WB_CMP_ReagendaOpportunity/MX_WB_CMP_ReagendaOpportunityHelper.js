({
    getFechaMin : function(component, event) {
        var today = new Date();
        var fechaMin = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();
        component.set('v.fechaMin',fechaMin);
    },

    creaElementoHora : function(component, event) {
        var horarios = component.get('v.horariosXTurno');
        var turno = component.get('v.turnoSeleccionado');
        for(let i=0; i< horarios.length; i++) {
            if(horarios[i].Name === turno) {

                $A.createComponent(
                    "lightning:input",
                    {
                        "aura:id": "validaHora",
                        "type":"time",
                        "min":horarios[i].MX_WB_HorarioMinimo__c,
                        "max":horarios[i].MX_WB_HorarioMaximo__c,
                        "label":"Hora de llamada",
                        "name":"pagovencimiento",
                        "required":"true",
                        "messageWhenValueMissing":"Campo requerido"
                    },
                    function(newInput, status, errorMessage){
                        if (status === "SUCCESS") {
                            component.set("v.body","");
                            var elemento = component.get("v.body");
                            elemento.push(newInput);
                            component.set("v.body", elemento);
                        }
                    }
                );
            }
        }
    },

    getUserTurno : function(component, event, turno) {
        var usuarios = component.get('v.lstUsuarios');
        var usuario = component.get('v.objUser');
        var usuariosTurno = [];
        for(let i=0; i<usuarios.length ;i++) {
            if(usuarios[i].Turno__c === turno){
                usuariosTurno.push(usuarios[i]);
            }
        }
        usuariosTurno.push(usuario);
        component.set('v.lstUsuariosTurno',"");
        component.set('v.lstUsuariosTurno',usuariosTurno);
    },

    creaTarea : function(component, event) {
        var action = component.get("c.insertaTarea");
        console.log(component.get("v.fechaElegida"));
        console.log(component.find("validaHora").get("v.value"));
        action.setParams({ "owner" : component.get("v.idUsuarioSeleccionado"), "fecha" : component.get("v.fechaElegida"),
                          "hora": component.find("validaHora").get("v.value"), "comentarios": component.get("v.strComentarios"),
                          "idOpp": component.get("v.recordId")});

        action.setCallback(this, function(response)
        {
            var state = response.getState();
            console.log(state);
            if(state === "SUCCESS")
            {
                component.set("v.tipoMensaje"," slds-theme--success");
                component.set("v.mensaje",response.getReturnValue());
                window.setTimeout(
                    $A.getCallback(function() {
                        $A.get("e.force:closeQuickAction").fire();
                    }), 1500
                );
            }
            else if(state === "ERROR"){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                    	component.set("v.tipoMensaje"," slds-theme--error slds-theme--alert-texture");
                    	component.set("v.mensaje",errors[0].message);
                    }
                }
            }
		})
        $A.enqueueAction(action);
    },

    getAllData : function(component, event) {
        var action = component.get("c.reuneData");
        action.setCallback(this,function(response){
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS"){
                var responseValues = response.getReturnValue();
				component.set('v.lstTurnos',responseValues.turnos);
                component.set('v.horariosXTurno',responseValues.horarios);
                component.set('v.lstUsuarios',responseValues.usuarios);
                component.set('v.lstUsuariosTurno',responseValues.usuarios);
                component.set('v.objUser',responseValues.current);
            }
		});
		$A.enqueueAction(action);
    }
})
