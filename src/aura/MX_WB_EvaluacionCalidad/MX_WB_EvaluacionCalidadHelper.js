({
    sumasecciones : 0,
    sumaBaseEvaluación : 0,
    porcentajeTotal:0,
    erroresFatales:0,
    erroresNoFatales:0,
    tieneErrorFatal : false,
    clasificacionSecciones : [],
    lstEvaluaConcepto : [],

	inicializaEvaluacion : function(component) {
		var action = component.get("c.obtieneEvaluacion");
		action.setParams({
			"idOpportunity" : component.get('v.oppId')
		});
		action.setCallback(this,function(response){
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS"){
                var result = response.getReturnValue();
				var evalSecciones = this.seccionActualiza(result.evaluacionSecciones, component);
                var lstConfigura = this.conceptosActualiza(result.evaluacionConceptos, evalSecciones);
                component.set('v.configuraciones',lstConfigura);
                component.set('v.evaluaConcepto',result.evaluacionConceptos);
                component.set('v.evaluacion',result.evaluacion);

                var puntosEntrenamiento = component.get('v.lstPuntosEntrenamiento');
                puntosEntrenamiento.forEach(function(puntos){
                    puntos.PuntosEntrenamiento.forEach(function(element){
                        result.evaluacionPuntosEntrenamiento.forEach(function(evaPunto){
                           	var aEvaluar = element.label.replace(/[\n\r]+/g, '');
                            if(evaPunto.MX_WB_PuntoEntrenamiento__c === aEvaluar && evaPunto.MX_WB_Concepto__c === element.idConcepto){
                                element.Id = evaPunto.Id;
                                element.checked = true;

                            }
                        });
                    });
                });

                this.handlePath(component,''+lstConfigura.length);
                this.porcentajes(component, true);
			}
		});
		$A.enqueueAction(action);
	},

	inicializaConfiguracion : function(component) {
		var action = component.get("c.cargaConfiguracion");
		action.setCallback(this,function(response){
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS"){
                var result = response.getReturnValue().wrapperSSC;
                var puntosEntrenamiento = this.obtenerPuntosEntrenamiento(result);
                result[0].seccion.Clase = 'slds-path__item slds-is-current slds-is-active';
                for(var i = 1; i< result.length; i++){
                    result[i].seccion.Clase = 'slds-path__item slds-is-incomplete';
                }
                //Inserción del último hijo
                var seccion= {NumeroSeccion__c: result.length+1, Nombre__c: "Cierre de encuesta", Clase: "slds-path__item slds-is-incomplete"};
                var lastChild = {};
                lastChild.seccion = seccion;
                lastChild.listWrapperSubseccionConceptos = [];
                lastChild.nombreInicial = 'Resultados obtenidos';
                result.push(lastChild);
				component.set('v.configuraciones',result);
                component.set('v.lstPuntosEntrenamiento', puntosEntrenamiento);
                if(component.get('v.evaluacionCalidad') === 'Realizada'){
                    this.inicializaEvaluacion(component);
                    component.set('v.isUpdate',true);
                    component.set('v.crearModificarEvaluacion',response.getReturnValue().permisoModificar);
                }
			}
		});
		$A.enqueueAction(action);
	},

    obtenerPuntosEntrenamiento : function(lstConfigura){
        var puntosEntrenamiento = [];
      	lstConfigura.forEach(function(primerNivel){
            primerNivel.listWrapperSubseccionConceptos.forEach(function(segundoNivel){
                segundoNivel.listWrapperEvaluacionConcepto.forEach(function(tercerNivel){
                    if(tercerNivel.conceptos.MX_WB_PuntosEntrenamiento__c !== undefined){
                        var elemento = {};
                        elemento.Id = tercerNivel.conceptos.Id
                        elemento.PuntosEntrenamiento = [];
                        tercerNivel.conceptos.MX_WB_PuntosEntrenamiento__c.split('\n').forEach(function(punto){
                            var puntoEntrenamiento = {};
                            puntoEntrenamiento.label = punto;
                            puntoEntrenamiento.idConcepto = tercerNivel.conceptos.Id;
                            puntoEntrenamiento.checked = false;
                            elemento.PuntosEntrenamiento.push(puntoEntrenamiento);
                        });
                        puntosEntrenamiento.push(elemento);
                    }
                });
            });
        });
        return puntosEntrenamiento;
    },

	conceptosActualiza : function(mapConcepto, lstConfigura){
        lstConfigura.forEach(function(primerNivel){
            primerNivel.listWrapperSubseccionConceptos.forEach(function(segundoNivel){
                segundoNivel.listWrapperEvaluacionConcepto.forEach(function(tercerNivel){
                    tercerNivel.evaluacionConcepto.Calificacion__c = mapConcepto[tercerNivel.conceptos.Id].Calificacion__c;
                    tercerNivel.evaluacionConcepto.Id = mapConcepto[tercerNivel.conceptos.Id].Id;
                });
            });
        });
        return lstConfigura;
	},

    seccionActualiza : function(mapSeccion, component){
        var lstConfigura = component.get('v.configuraciones');
        lstConfigura.forEach(function(primerNivel){
            if(primerNivel.seccion.Id !== undefined){
                primerNivel.seccion.EvaluacionSeccion__c = mapSeccion[primerNivel.seccion.Id].Id;
                primerNivel.seccion.SeguirHaciendo__c= mapSeccion[primerNivel.seccion.Id].MX_WB_SeguirHaciendo__c;
                primerNivel.seccion.EmpezarAHacer__c= mapSeccion[primerNivel.seccion.Id].MX_WB_EmpezarAHacer__c;
                primerNivel.seccion.DejarDeHacer__c= mapSeccion[primerNivel.seccion.Id].MX_WB_DejarDeHacer__c;
            }
        });
        return lstConfigura;
	},

    handlePath:function(component,stage){
        var lastStage = component.get('v.stage');
        var self = this;
        if(stage !== lastStage){
            var records = component.get('v.configuraciones');
            records.forEach(function(element){
                self.checkComplete(element, stage);
            });
            component.set('v.configuraciones', records);
            component.set('v.stage', parseInt(stage));
        }
    },

    checkComplete : function(element, stage){
        if(element.seccion.NumeroSeccion__c === parseInt(stage)){
            element.seccion.Clase = 'slds-path__item slds-is-current slds-is-active';
        }else{
            var complete = true;
            if(element.seccion.Nombre__c === "Cierre de encuesta"){
                complete = false;
            }
            element.listWrapperSubseccionConceptos.forEach(function(subseccion){
                subseccion.listWrapperEvaluacionConcepto.forEach(function(concepto){
                    if(concepto.evaluacionConcepto.Calificacion__c === undefined){
                        complete = false;
                    }
                });
            });
            if(complete){
                element.seccion.Clase = 'slds-path__item slds-is-complete';
            }else{
                element.seccion.Clase = 'slds-path__item slds-is-incomplete';
            }
        }
    },
	porcentajes : function (component, disableBtn){
        this.radioCheck(component);
        var lstConfigura = component.get('v.configuraciones');
        var detenerEvaluacion = false;
         lstConfigura.forEach(function(primerNivel){
            primerNivel.listWrapperSubseccionConceptos.forEach(function(segundoNivel){
                segundoNivel.listWrapperEvaluacionConcepto.forEach(function(tercerNivel){
                    var calificacion = tercerNivel.evaluacionConcepto.Calificacion__c;
                    if(calificacion === undefined){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Revisa nuevamente",
                            "duration":"500",
                            "mode":"pester",
                            "type":"warning",
                            "message": "No se han respondido todas las preguntas del cuestionario"
                        });
                        toastEvent.fire();
                        detenerEvaluacion = true;
                    }
                });
            });
        });
        if(!detenerEvaluacion){
            this.getResults(component,disableBtn);
        }
	},

    getResults : function(component, disableBtn){
        var lstConfigura = component.get('v.configuraciones');
        var evalua = component.get('v.evaluacion');
		this.lstEvaluaConcepto = [];
        this.sumasecciones = 0;
        this.sumaBaseEvaluacion = 0;
        this.porcentajeTotal = 0;
        this.erroresFatales = 0;
        this.erroresNoFatales = 0;
        this.tieneErrorFatal = false;
        this.clasificacionSecciones = [];
        var self = this;
        evalua = self.analizaNiveles(lstConfigura, evalua, this);
        evalua.MX_WB_PuntajeTotal__c = this.porcentajeTotal;
        evalua.Encuestado__c = component.get('v.nombrePropietario');
        evalua.IDGrabacion__c = component.get('v.folioCotizacion');
        evalua.MX_WB_PuntajeBase__c = this.sumaBaseEvaluación;
        evalua.MX_WB_ErroresFatales__c = this.erroresFatales;
        evalua.MX_WB_ErroresNoFatales__c = this.erroresNoFatales;
        evalua.MX_WB_Cotizacion__c = component.get('v.oppId');
        if(self.tieneErrorFatal){
            evalua.PorcentajeTotal__c = 0;
        }else{
            evalua.PorcentajeTotal__c = (this.porcentajeTotal/this.sumaBaseEvaluación)*100;
        }
        var appEvent = component.getEvent('saveDisabled');
        appEvent.setParams({"disabled" : disableBtn });
        appEvent.fire();
        component.set('v.clasificacionSecciones',this.clasificacionSecciones);
        component.set('v.configuraciones',lstConfigura);
        component.set('v.evaluacion',evalua);
        component.set('v.lstEvaluacionCon',this.lstEvaluaConcepto);
    },

    analizaNiveles : function(lstConfigura, evalua, helper){
        lstConfigura.forEach(function(primerNivel){
            if(primerNivel.seccion.NumeroSeccion__c !== lstConfigura.length){
                var clasificacionSeccion = {};
                clasificacionSeccion.catalogoSeccion = primerNivel.seccion.Id;
                clasificacionSeccion.idEvaluacionSeccion = primerNivel.seccion.EvaluacionSeccion__c;
                clasificacionSeccion.dejarDeHacer = primerNivel.seccion.DejarDeHacer__c === undefined ? '': primerNivel.seccion.DejarDeHacer__c;
                clasificacionSeccion.empezarAHacer = primerNivel.seccion.EmpezarAHacer__c === undefined ? '': primerNivel.seccion.EmpezarAHacer__c;
                clasificacionSeccion.seguirHaciendo = primerNivel.seccion.SeguirHaciendo__c === undefined ? '': primerNivel.seccion.SeguirHaciendo__c;
                helper.clasificacionSecciones.push(clasificacionSeccion);
            }
            var sumacalif = 0;
            var baseSeccion = 0;
            var helperSelf = helper;
            primerNivel.listWrapperSubseccionConceptos.forEach(function(segundoNivel){
                var analisisSegundoNivel = helperSelf.analizaSegundoTercerNivel(segundoNivel, helperSelf, primerNivel);
                baseSeccion += analisisSegundoNivel.baseSeccion;
                sumacalif += analisisSegundoNivel.sumacalif;
            });
            helper.sumaBaseEvaluación = baseSeccion;
            primerNivel.baseseccion = baseSeccion;
            primerNivel.promediosecciones = sumacalif;
            helper.sumasecciones +=  parseFloat(primerNivel.promediosecciones);
            helper.porcentajeTotal = helper.sumasecciones;
            switch(primerNivel.NumeroSeccion__c){
                case '0':
                    evalua.PorcentajeReglasJuego__c = primerNivel.promediosecciones;
                    break;
                case '1':
                    evalua.PorcentajeProductoProceso__c = primerNivel.promediosecciones;
                    break;
                case '2':
                    evalua.PorcentajeExperienciaConCliente__c = primerNivel.promediosecciones;
                    break;
                case '3':
                    evalua.PorcentajeVentas__c = primerNivel.promediosecciones;
                    break;
                default:
                    break;
            }
        });
        return evalua;
    },

    analizaSegundoTercerNivel : function(segundoNivel, helperSelf, primerNivel){
        var returnValues = {};
        var cuentaSubSecc = 0;
        var helperTercer = helperSelf;
        var baseSeccion = 0;
        segundoNivel.listWrapperEvaluacionConcepto.forEach(function(tercerNivel){
            var calificacion = tercerNivel.evaluacionConcepto.Calificacion__c;
            var evaluaConcepto = {};
            if(tercerNivel.evaluacionConcepto.ErrorFatal === true || tercerNivel.evaluacionConcepto.ErrorFatal === 'true'){
                helperTercer.tieneErrorFatal = true;
                helperTercer.erroresFatales +=1;
            }
            if((tercerNivel.evaluacionConcepto.ErrorFatal === false || tercerNivel.evaluacionConcepto.ErrorFatal === 'false')
            && tercerNivel.evaluacionConcepto.ErrorFatal !== undefined ){
                helperTercer.erroresNoFatales +=1;
            }
            if(parseInt(calificacion) === 0 ) {
                baseSeccion += tercerNivel.conceptos.MX_WB_Ponderacion__c;
            } else if(parseInt(calificacion) === 1) {
                baseSeccion += tercerNivel.conceptos.MX_WB_Ponderacion__c;
                cuentaSubSecc += tercerNivel.conceptos.MX_WB_Ponderacion__c;
            }
            evaluaConcepto.idEvaluacionConcepto = tercerNivel.evaluacionConcepto.Id;
            evaluaConcepto.subseccionEvaConcepto = segundoNivel.subseccion.Nombre__c;
            evaluaConcepto.seccionEvaConcepto = primerNivel.seccion.Nombre__c;
            evaluaConcepto.concepto = tercerNivel.conceptos.Id;
            evaluaConcepto.ponderacion = tercerNivel.conceptos.MX_WB_Ponderacion__c;
            evaluaConcepto.calificacion = tercerNivel.evaluacionConcepto.Calificacion__c;
            evaluaConcepto.conceptoEvaConcepto = tercerNivel.conceptos.Descripcion__c;
            evaluaConcepto.ejemploEvaConcepto = tercerNivel.conceptos.Ejemplo__c;
            evaluaConcepto.guardadoDeConceptos = true;
            evaluaConcepto.errorFatal = helperTercer.tieneErrorFatal;
            helperTercer.lstEvaluaConcepto.push(evaluaConcepto);
        });
        segundoNivel.promediosubseccion = cuentaSubSecc;
        returnValues.sumacalif = cuentaSubSecc;
        returnValues.baseSeccion = baseSeccion;
        return returnValues;
    },

    guardaOActualiza : function(component,isUpdate){
        var evaluacioPuntosEntrenamiento = this.getPuntosEntrenamiento(component);
        var evaluacioPuntosEntrenamientoBorrados = this.getDeletedPuntosEntrenamiento(component);
    	var evaluacion = component.get('v.evaluacion');
        var evaluaConceptos = component.get('v.lstEvaluacionCon');
        var evaluacionSecciones = component.get('v.clasificacionSecciones');
		var action = component.get("c.guardaEvaluacion");
        action.setParams({
            "evaluacion":evaluacion,
            "evaluacionesConcepto":JSON.stringify(evaluaConceptos),
            "evaluacionesSeccion":JSON.stringify(evaluacionSecciones),
            "evaluacionPuntosEntrenamiento":JSON.stringify(evaluacioPuntosEntrenamiento),
            "toDelete": evaluacioPuntosEntrenamientoBorrados,
            "isUpdate":isUpdate
        });

        action.setCallback(this,function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if(result.status === 'OK' && state === "SUCCESS"){
                var toastEventSuccess = $A.get("e.force:showToast");
                toastEventSuccess.setParams({
                    "title": "Guardado correcto",
                    "duration":"300",
                    "mode":"pester",
                    "type":"success",
                    "message": result.message
                });
                toastEventSuccess.fire();
            }
            else{
                var toastEventError = $A.get("e.force:showToast");
                toastEventError.setParams({
                    "title": "Error",
                    "mode":"dismissable",
                    "type":"error",
                    "message": result.message
                });
                toastEventError.fire();
            }
        });
        $A.enqueueAction(action);
    },

    getPuntosEntrenamiento : function(component){
        var puntosEntrenamiento = component.get('v.lstPuntosEntrenamiento');
        var puntosEntrenamientoObtenidos = [];
        puntosEntrenamiento.forEach(function(puntos){
            puntos.PuntosEntrenamiento.forEach(function(element){
                if(element.checked && element.Id === undefined){
                    puntosEntrenamientoObtenidos.push(element);
                }
            })
        });
        return puntosEntrenamientoObtenidos;
    },

    getDeletedPuntosEntrenamiento : function(component){
        var puntosEntrenamiento = component.get('v.lstPuntosEntrenamiento');
        var puntosEntrenamientoObtenidos = [];
        puntosEntrenamiento.forEach(function(puntos){
            puntos.PuntosEntrenamiento.forEach(function(element){
                if(!element.checked && element.Id !== undefined){
                    puntosEntrenamientoObtenidos.push(element.Id);
                }
            })
        });
        return puntosEntrenamientoObtenidos;
    },

    radioCheck : function(component){
        var records = component.get('v.configuraciones');
        var self = this;
        records.forEach(function(seccion){
            seccion.listWrapperSubseccionConceptos.forEach(function(subseccion){
                subseccion.listWrapperEvaluacionConcepto.forEach(function(concepto){
                    self.analizeRadioLevel(concepto, component);
                });
            });
        });
    },

    analizeRadioLevel : function(concepto, component){
        if(concepto.evaluacionConcepto.Calificacion__c !== 0){
        	concepto.evaluacionConcepto.ErrorFatal = null;
        }
        if(concepto.evaluacionConcepto.Calificacion__c === 0 && component.get('v.tipoVenta') === 'Closed Lost'){
            this.setErrorFatalNoVenta(concepto);
        }
        if(concepto.evaluacionConcepto.Calificacion__c === 0 && component.get('v.tipoVenta') === 'Closed Won'){
            this.setErrorFatalNoVenta(concepto);
        }
    },

    setErrorFatalNoVenta : function(concepto){
        if(concepto.conceptos.MX_WB_ClasificacionErrorNoVenta__c !== 'Selecciona'){
            if(concepto.conceptos.MX_WB_ClasificacionErrorNoVenta__c === 'ENF'){
                concepto.evaluacionConcepto.ErrorFatal = false;
            }else{
                concepto.evaluacionConcepto.ErrorFatal = true;
            }
        }
    },
    setErrorFatalVenta : function(concepto){
        if(concepto.conceptos.MX_WB_ClasificacionErrorVenta__c !== 'Selecciona'){
            if(concepto.conceptos.MX_WB_ClasificacionErrorVenta__c === 'ENF'){
                concepto.evaluacionConcepto.ErrorFatal = false;
            }else{
                concepto.evaluacionConcepto.ErrorFatal = true;
            }
        }
    },

    openModalPuntosEntrenamiento :function(component, idConcepto, valueConcepto){
        var puntosEntrenamiento = component.get('v.lstPuntosEntrenamiento');
        var puntosEntrenamientoObtenidos = [];
        puntosEntrenamiento.forEach(function(element){
            if(element.Id === idConcepto){
                puntosEntrenamientoObtenidos = element.PuntosEntrenamiento.slice(0);
            }
        });
        if(valueConcepto === 0 && puntosEntrenamientoObtenidos.length !== 0){
        	component.set("v.body",[]);
            component.set("v.idConcepto", idConcepto);
            component.set("v.PuntosEntrenamientoSelected",[]);
            $A.createComponent(
                "c:MX_WB_EvaluacionPuntosEntrenamiento",
                {'aura:id':'modalEntrenamientoOpen', lstPuntosEntrenamiento : puntosEntrenamientoObtenidos, 'idConcepto':idConcepto},
                function(newButton, status){
                    if (status === "SUCCESS") {
                        var body = component.get("v.body");
                        body.push(newButton);
                        component.set("v.body", body);
                    }
                }
            );
            component.set("v.openModal",true);
        }
    },

    getCountPuntosEntrenamiento:function(puntosEntrenamiento, puntosEntrenamientoSelected, idConcepto){
        var countTrues = 0;
        puntosEntrenamiento.forEach(function(puntoEnt){
            var innerCount = countTrues;
            if(puntoEnt.Id === idConcepto ){
                puntoEnt.PuntosEntrenamiento.forEach(function(punto){
                    var dobleInnerCount = innerCount;
                    var puntoEncontrado = false;
                    puntosEntrenamientoSelected.forEach(function(puntoSeleccionado){
                        if(puntoSeleccionado.label === punto.label && puntoSeleccionado.checked){
                            dobleInnerCount ++;
                        }
                        if(puntoSeleccionado.label === punto.label && !puntoSeleccionado.checked){
                            puntoEncontrado = true;
                        }
                    });
                    if(!puntoEncontrado && punto.checked){
                        dobleInnerCount ++;
                    }
                    innerCount = dobleInnerCount;
                });
                countTrues = innerCount;
            }
        });
        return countTrues;
    }
})
