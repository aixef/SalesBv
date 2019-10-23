({
    initSelect : function(component, event, helper) {
        helper.inicializaConfiguracion(component);
	},
	guardarEvaluacion : function(component, event, helper) {
		helper.guardaOActualiza(component,component.get('v.isUpdate'));
	},
	calcularPorcentaje  : function(component, event, helper) {
		helper.porcentajes(component, false);
	},
    updatePath : function(component,event,helper){
        var stage = event.currentTarget.id;
       	helper.handlePath(component,stage);
    },
    radioChanged : function(component, event,helper){
        helper.openModalPuntosEntrenamiento(component, event.getSource().get('v.name'), event.getSource().get('v.value'));
        var lstConfigura = component.get('v.configuraciones');
        lstConfigura.forEach(function(primerNivel){
            primerNivel.listWrapperSubseccionConceptos.forEach(function(segundoNivel){
                segundoNivel.listWrapperEvaluacionConcepto.forEach(function(tercerNivel){
                    if(tercerNivel.conceptos.Id === event.getSource().get('v.name')){

                        var calificacion = tercerNivel.evaluacionConcepto.Calificacion__c;
                        if(calificacion === 0 && tercerNivel.conceptos.MX_WB_ClasificacionErrorNoVenta__c === 'Selecciona'){
                            tercerNivel.evaluacionConcepto.ErrorFatal = 'true';
                        }
                    }
                });
            });
        });
        component.set('v.configuraciones',lstConfigura);
        var appEvent = component.getEvent('saveDisabled');
        appEvent.setParams({"disabled" : true });
        appEvent.fire();
    },

    openModalPuntos :function(component, event, helper){
		helper.openModalPuntosEntrenamiento(component, event.getSource().get('v.name'), 0);
        var appEvent = component.getEvent('saveDisabled');
        appEvent.setParams({"disabled" : true });
        appEvent.fire();
    },

    closeSaveModal : function(component, event, helper){
        var idConcepto = component.get('v.idConcepto');
        var puntosEntrenamiento = component.get('v.lstPuntosEntrenamiento');
        var puntosEntrenamientoSelected = component.get('v.PuntosEntrenamientoSelected');
        var countTrues = helper.getCountPuntosEntrenamiento(puntosEntrenamiento, puntosEntrenamientoSelected, idConcepto);
        if(countTrues > 0){
            puntosEntrenamiento.forEach(function(puntoEnt){
                if(puntoEnt.Id === idConcepto){
                    puntoEnt.PuntosEntrenamiento.forEach(function(punto){
                        puntosEntrenamientoSelected.forEach(function(puntoSeleccionado){
                            if(punto.label === puntoSeleccionado.label){
                                punto.checked = puntoSeleccionado.checked;
                            }
                        });
                    });
                }
            });
            component.set('v.lstPuntosEntrenamiento', puntosEntrenamiento);
            component.set('v.openModal',false);
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Seleccione puntos de entrenamiento",
                "duration":"300",
                "mode":"pester",
                "type":"warning",
                "message": "Seleccione al menos un punto de entrenamiento"
            });
            toastEvent.fire();
        }
    },

    closeModal : function(component){
        var idConcepto = component.get('v.idConcepto');
        var puntosEntrenamiento = component.get('v.lstPuntosEntrenamiento');
        var countTrues = 0;
        puntosEntrenamiento.forEach(function(puntoEnt){
            if(puntoEnt.Id === idConcepto){
                puntoEnt.PuntosEntrenamiento.forEach(function(punto){
                    if(punto.checked){
                        countTrues ++;
                    }
                })
            }
        })
        if(countTrues === 0){
            var lstConfigura = component.get('v.configuraciones');
            lstConfigura.forEach(function(primerNivel){
                primerNivel.listWrapperSubseccionConceptos.forEach(function(segundoNivel){
                    segundoNivel.listWrapperEvaluacionConcepto.forEach(function(tercerNivel){
                        if(tercerNivel.conceptos.Id === idConcepto){
                            tercerNivel.evaluacionConcepto.Calificacion__c = null;
                        }
                    });
                });
            });
            component.set('v.configuraciones',lstConfigura);
        }
        component.set('v.openModal',false);
    },

    addTrainingPoint: function(component,event){
        var puntoSeleccionado = {};
        puntoSeleccionado.label = event.getParam('label');
        puntoSeleccionado.checked = event.getParam('checked');
        var puntosSeleccionados = component.get("v.PuntosEntrenamientoSelected");
        var puntoEncontrado = false;
        puntosSeleccionados.forEach(function(punto){
            if(punto.label === puntoSeleccionado.label){
                punto.checked = puntoSeleccionado.checked;
                puntoEncontrado = true;
            }
        });
        if(!puntoEncontrado){
            puntosSeleccionados.push(puntoSeleccionado);
        }
        component.set("v.PuntosEntrenamientoSelected",puntosSeleccionados);
    }
})
