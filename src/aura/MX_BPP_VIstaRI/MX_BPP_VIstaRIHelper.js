/*
*Desarrollado por:       Indra
*Autor:                  Ricardo Almanza
*Proyecto:               BpyP
*Descripción:            Componente Lightning vista Reunión Individual BPyP
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 17-05-2017     |    Ricardo Almanza  		|           Creación
*1.1	| 23-01-2019	 |    Adrián Pastor Pineda	|  Se setea en los componentes de oportunidades y contactabilidad el valor de false
*1.2    | 22-05-2019     |    Hugo I. Carrillo B.   |  Correcciones de Code Smell identificados por Sonar
*/
({
    getDatosUserRI: function (component, event) {
        var action = component.get("c.getTableUsrBPP");
        action.setParams({
            "IDRI": component.get("v.RISelect")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.rows", response.getReturnValue());
            }
        });

        $A.enqueueAction(action);
    },
    getCintillo: function (component, event) {
        var action = component.get("c.getCintillo");
        action.setParams({
            "IDRI": component.get("v.RISelect")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Cintillo", response.getReturnValue());
                var str = component.get("v.Cintillo.Id");
                component.set("v.CintilloSelect", str);
            }
        });
        $A.enqueueAction(action);

        var action2 = component.get("c.getCompApoy");
        action2.setParams({
            "IDRI": component.get("v.RISelect")
        });
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.CompApoyo", response.getReturnValue());
            }
        });
        $A.enqueueAction(action2);
    },
    VerificaDirector: function (component) {
        var action = component.get("c.VerificaDirectorPropietarioRI");
        action.setParams({
            "RIUser": component.get("v.RISelect")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.DORI", response.getReturnValue());
                if (component.get("v.DORI") === true) {
                    component.set("v.claseDirector", 'slds-p-horizontal--small slds-size--1-of-5');
                    component.set("v.RESUMENDIV", false);
                    component.set("v.RESUMENDGMDIV", true);
                    this.getPromedioDOR(component);
                }
                component.set("v.EjecutivoDO", false);
            }
        });

        $A.enqueueAction(action);
    },
    menuRESUMEN: function (component, event, secresumenId) {
        var idmenuRESUMEN = component.find(secresumenId);

        for (var cmpresumen in idmenuRESUMEN) {
            if (cmpresumen) {
                $A.util.toggleClass(idmenuRESUMEN[cmpresumen], 'slds-show');
                $A.util.toggleClass(idmenuRESUMEN[cmpresumen], 'slds-hide');
            }
        }

    },
    bppdetallePuntos: function (component, event, secresumenId) {
        var idmenuRESUMEN = component.find(secresumenId);

        for (var cmpresumen in idmenuRESUMEN) {
            if (cmpresumen) {
                $A.util.toggleClass(idmenuRESUMEN[cmpresumen], 'slds-show');
                $A.util.toggleClass(idmenuRESUMEN[cmpresumen], 'slds-hide');
            }
        }

    },
    helpermenuRESUMEN1: function (component, event, idsecc) {
        var listIdSecc = [
            'RESUMENDIV', 'CARTERACPDIV', 'CARTERALPDIV',
            'VISTAMNDIV', 'INVERSIONESDIV', 'RESTOCAPTACIONDIV',
            'INFORECURRENTEDIV', 'INFONORECURRENTEDIV', 'MARGENBRUTODIV',
            'STOCKNOMINADIV', 'ACCIONESCOMERCIALESDIV', 'PLANDECHOQUEDIV',
            'RESUMENEXPDIV', 'DIRECCIONDIV', 'GESTIONCOMERCIALDIV',
            'OPORTUNIDADESCOMPDIV', 'COMPROMISOSCOMPDIV', 'COMPEJECDIV',
            'PRIORCOMPDIV', 'RESUMENCRMDIV', 'RESUMENDGMDIV',
            'EUDECSDIV', 'ACRMDECSDIV', 'RESUMENAPOYOSDIV',
            'ABIERTOSAPOYOSDIV', 'OPORTUNIDADESACTIVDIV', 'ABIERTOSCONTACTABILIDADIV',
            'ABIERTOSOPORTUNIDADESDIV', 'INVRESTCAPDIV', 'CAPTACIONMEDIV',
            'sDetalle', 'GRAPHPUNTOS', 'GRAPHEU'
        ];
        var idseccUsed = [];
        for (var i = 0; i < listIdSecc.length; i++) {
            if (idsecc !== listIdSecc[i]) {
                idseccUsed.push(i);
            }
        }
        for (var j = 0; j < idseccUsed.length; j++) {
            var idx = idseccUsed[j];
            component.set(("v." + listIdSecc[idx]), false);
        }
    },
    helperSwitch: function (component, response, RIButton) {
        if (RIButton === true) {
            component.set("v.EtapaRIButton", response.getReturnValue());
        }
        component.set("v.EtapaRI", response.getReturnValue());
        var current = "current",
            incomplete = "incomplete",
            complete = "complete";
        switch (component.get("v.EtapaRI")) {
            case 'Preparación':
                this.setVistaPropiedad(component, current, incomplete, incomplete, incomplete);
                break;
            case 'Presentación':
                this.setVistaPropiedad(component, complete, current, incomplete, incomplete);
                break;
            case 'Evaluacion':
                this.setVistaPropiedad(component, complete, complete, current, incomplete);
                break;
            case 'Finalizacion':
                this.setVistaPropiedad(component, complete, complete, complete, complete);
                break;
        }
    },
    setVistaPropiedad: function (component, val1, val2, val3, val4) {
        component.set("v.VistaPropiedad1", "slds-tabs_path__item slds-is-" + val1);
        component.set("v.VistaPropiedad2", "slds-tabs_path__item slds-is-" + val2);
        component.set("v.VistaPropiedad3", "slds-tabs_path__item slds-is-" + val3);
        component.set("v.VistaPropiedad4", "slds-tabs_path__item slds-is-" + val4);
    },
    LlenarRuta: function (component, event, helper) {
        var select = component.get("v.RISelect");
        var action = component.get("c.getEtapa");
        action.setParams({
            "IdRI": select
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.helperSwitch(component, response, false);
            }
            component.set("v.EtapaRIButton", component.get("v.EtapaRI"));
        });
        $A.enqueueAction(action);

    },
    cambiaetapa: function (component, event, helper) {
        var ban1 = component.get("v.banderaEtapa1");
        if (ban1) {
            component.set("v.VistaPropiedad1", component.get("v.UltimoEstado1"));
            component.set("v.banderaEtapa1", '');
        } else {
            component.set("v.UltimoEstado1", component.get("v.VistaPropiedad1"));
            component.set("v.EtapaTemporal", 'Preparación');
            if ("v.VistaPropiedad1" != "slds-tabs--path__item slds-is-incomplete slds-is-active") {
                component.set("v.VistaPropiedad1", "slds-tabs--path__item slds-is-incomplete slds-is-active");
                component.set("v.banderaEtapa1", true);
            }
        }
    },
    cambiaetapa2: function (component, event, helper) {
        var ban2 = component.get("v.banderaEtapa2");
        if (ban2) {
            component.set("v.VistaPropiedad2", component.get("v.UltimoEstado2"));
            component.set("v.banderaEtapa2", '');
        } else {
            component.set("v.UltimoEstado2", component.get("v.VistaPropiedad2"));
            component.set("v.EtapaTemporal", 'Presentación');
            if ("v.VistaPropiedad2" != "slds-tabs--path__item slds-is-incomplete slds-is-active") {
                component.set("v.VistaPropiedad2", "slds-tabs--path__item slds-is-incomplete slds-is-active");
                component.set("v.banderaEtapa2", true);
            }
        }
    },
    cambiaetapa3: function (component, event, helper) {
        var ban3 = component.get("v.banderaEtapa3");
        if (!ban3) {
            component.set("v.UltimoEstado3", component.get("v.VistaPropiedad3"));
            component.set("v.EtapaTemporal", 'Evaluacion');
            if ("v.VistaPropiedad3" != "slds-tabs--path__item slds-is-incomplete slds-is-active") {
                component.set("v.VistaPropiedad3", "slds-tabs--path__item slds-is-incomplete slds-is-active");
                component.set("v.banderaEtapa3", true);
            }
        } else {
            component.set("v.VistaPropiedad3", component.get("v.UltimoEstado3"));
            component.set("v.banderaEtapa3", '');
        }
    },
    cambiaetapa4: function (component, event, helper) {
        var ban4 = component.get("v.banderaEtapa4");
        if (!ban4) {
            component.set("v.UltimoEstado4", component.get("v.VistaPropiedad4"));
            component.set("v.EtapaTemporal", 'Finalizacion');
            if ("v.VistaPropiedad4" != "slds-tabs--path__item slds-is-incomplete slds-is-active") {
                component.set("v.VistaPropiedad4", "slds-tabs--path__item slds-is-incomplete slds-is-active");
                component.set("v.banderaEtapa4", true);
            }
        } else {
            component.set("v.VistaPropiedad4", component.get("v.UltimoEstado4"));
            component.set("v.banderaEtapa4", '');
        }
    },
    avanzaEtapa: function (component, event, helper) {
        var etapaSeleccionada = component.get("v.EtapaTemporal");
        var action;
        if ((etapaSeleccionada != null) && (etapaSeleccionada !== "")) {
            action = component.get("c.cambioEtapa");
            action.setParams({
                "IdRI": component.get("v.RISelect"),
                "etapa": component.get("v.EtapaTemporal")
            });
        } else {
            action = component.get("c.cambioEtapa");
            switch (component.get("v.EtapaRI")) {
                case 'Preparación':
                    component.set("v.EtapaRI", 'Presentación');
                    break;
                case 'Presentación':
                    component.set("v.EtapaRI", 'Evaluacion');
                    break;
                case 'Evaluacion':
                    component.set("v.EtapaRI", 'Finalizacion');
                    break;
            }
            action.setParams({
                "IdRI": component.get("v.RISelect"),
                "etapa": component.get("v.EtapaRI")
            });
        }
        action.setCallback(this, function (response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                if (result.startsWith("Error")) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "error",
                        "message": result
                    });
                    toastEvent.fire();
                } else {
                    this.helperSwitch(component, response, true);
                    var toastEvent2 = $A.get("e.force:showToast");
                    toastEvent2.setParams({
                        "title": "Correcto!",
                        "type": "success",
                        "message": "Se cambio la Etapa correctamente."
                    });
                    toastEvent2.fire();
                }
            }
        });

        $A.enqueueAction(action);
    },
    getSObjectName: function (component) {
        var action = component.get('c.getApiName');

        action.setParams({
            "recordId": component.get("v.RISelect")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.apiName", result);
            }
        });
        $A.enqueueAction(action);
    },
    helperGetCreatedByName: function (component, llamada) {
        var record = component.get("v.RISelect");
        var action = component.get("c.getUser");

        action.setParams({
            recordId: record
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS" && record != null) {
                var result = response.getReturnValue();
                component.set("v.createdBy", result);
                component.set("v.nameEV", result[0].CreatedBy.Name);
                component.set("v.comentarioEV", result[0].EU001_tl_Comentario_EV__c);
                component.set("v.comentarioDO", result[0].EU001_tl_Comentario_DO__c);
                var estatus = result[0].EU001_tx_Estado__c;
                if (estatus === 'Preparación' || estatus === 'Presentación') {
                    var messages = {
                        'title': 'Etapa Incorrecta',
                        'severity': "error",
                        'closable': false,
                        'message': "Sólo puedes Evaluar la RI en la etapa de Evaluación",
                        'isVisible': false
                    };

                    component.set("v.MessageJson", messages);
                    component.set("v.showComponent", false);

                } else if (estatus === 'Evaluacion') {
                    component.set("v.showComponent", true);
                    component.set("v.showEvaluar", true);
                    component.set("v.showNotEvaluar", false);
                } else if (estatus === 'Finalizacion') {
                    component.set("v.showEvaluar", false);
                    component.set("v.showNotEvaluar", true);
                    component.set("v.showComponent", true);
                }
                this.helpergetDO(component);
                this.helperMachComentarios(component);
            }
        });
        $A.enqueueAction(action);
    },
    helpergetDO: function (component) {
        var usuario = component.get("v.nameEV");
        var action = component.get('c.getDO');

        action.setParams({
            propietario: usuario
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.nameDO", result);
            }

        });

        $A.enqueueAction(action);
    },
    helpergetUserSession2: function (component, helper) {
        var action = component.get('c.getUserSessionRoleRiSelect');
        var ejecutivo = ['EJECUTIVO EMPRESAS',
            'EJECUTIVO SECTOR',
            'EJECUTIVO CENTRO',
            'EJECUTIVO GOBIERNO',
            'EJECUTIVO HIPOTECARIO',
            'EJECUTIVO PROMOTOR',
            'EJECUTIVO VENTA',
            'BBVA ADMINISTRADOR'];

        var director = ['DIRECTOR DE OFICINA',
            'ADMINISTRADOR'];
        var directorRegional = ['DIRECTOR REGIONAL',
            'ADMINISTRADOR'];
        var directorDivisional = ['DIRECTOR DIVISIONAL',
            'DIVISIÓN',
            'ADMINISTRADOR'];
        action.setParams({
            UserUg: component.get('v.UgUser')
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();

                if (result != null) {
                    helper.helperEjecutivoDirector(component, result, ejecutivo, 'ejec');
                    helper.helperEjecutivoDirector(component, result, director, 'dir');
                    helper.helperEjecutivoDirector(component, result, directorRegional, 'dirReg');
                    helper.helperEjecutivoDirector(component, result, directorDivisional, 'dirDiv');
                }
                helper.helperGetCreatedByName(component, "helpergetUserSession2");
            }
        });
        $A.enqueueAction(action);
    },
    helperEjecutivoDirector: function (component, result, lista, name) {
        for (var i = 0; i < lista.length; i++) {
            if (result.indexOf(lista[i]) !== -1) {
                this.helperSwitchEjecDir(component, name);
            }
        }
    },
    helperSwitchEjecDir: function (component, name) {
        switch (name) {
            case 'ejec':
                component.set('v.who2', 'EV');
                break;
            case 'dir':
                component.set('v.who2', 'DO');
                break;
            case 'dirReg':
                component.set('v.who2', 'DR');
                component.set('v.ocultaganaMas', true);
                break;
            case 'dirDiv':
                component.set('v.who2', 'DD');
                component.set('v.ocultaganaMas', true);
                break;
        }
    },
    helpergetUserSession: function (component) {
        var action = component.get('c.getUserSessionRole');
        var ejecutivo = ['EJECUTIVO EMPRESAS',
            'EJECUTIVO SECTOR',
            'EJECUTIVO CENTRO',
            'EJECUTIVO GOBIERNO',
            'EJECUTIVO HIPOTECARIO',
            'EJECUTIVO PROMOTOR',
            'EJECUTIVO VENTA',
            'BBVA ADMINISTRADOR'];

        var director = ['DIRECTOR DE OFICINA',
            'ADMINISTRADOR'];
        var directorCorp = ['DIRECTOR CENTRO CORPORATIVO',
            'ADMINISTRADOR'];
        var directorRegional = ['DIRECTOR REGIONAL',
            'ADMINISTRADOR'];
        var directorDivisional = ['DIRECTOR DIVISIONAL',
            'DIVISIÓN ',
            'ADMINISTRADOR'];
        var dirRed = ['STAFF CENTRAL',
            'ADMINISTRADOR'];

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result != null) {
                    this.helperEjecutivoDirector2(component, result, ejecutivo, 'ejec');
                    this.helperEjecutivoDirector2(component, result, director, 'dir');
                    this.helperEjecutivoDirector2(component, result, directorCorp, 'dirCor');
                    this.helperEjecutivoDirector2(component, result, directorRegional, 'dirReg');
                    this.helperEjecutivoDirector2(component, result, directorDivisional, 'dirDiv');
                    this.helperEjecutivoDirector2(component, result, dirRed, 'dirRed');
                }
                //Aquí truena
                this.helperGetCreatedByName(component, "helpergetUserSession");
            }
        });

        $A.enqueueAction(action);
    },
    helperEjecutivoDirector2: function (component, result, lista, name) {
        for (var i = 0; i < lista.length; i++) {
            if (result.indexOf(lista[i]) !== -1) {
                this.helperSwitchEjecDir2(component, name);
            }
        }
    },
    helperSwitchEjecDir2: function (component, name) {
        var showEje = true;
        switch (name) {
            case 'ejec':
                showEje = false;
                component.set('v.who', 'EV');
                break;
            case 'dir':
                component.set('v.who', 'DO');
                break;
            case 'dirReg':
                component.set('v.who', 'DR');
                break;
            case 'dirDiv':
                component.set('v.who', 'DD');
                break;
            case 'dirCor':
                component.set('v.who', 'DC');
                break;
            case 'dirRed':
                component.set('v.who', 'DRED');
                break;
        }
        if (showEje) {
            component.set('v.showEjecutivo', true);
        } else {
            component.set('v.showDirector', true);
        }
    },
    helperUpdateComentario: function (component) {
        var record = component.get("v.RISelect");
        var comentario = component.get("v.comentario");
        var evaluador = component.get("v.who");
        var action = component.get("c.updateComentarios");

        action.setParams({
            recordId: record,
            comentario: comentario,
            evaluador: evaluador
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
            }

        });

        $A.enqueueAction(action);
    },
    helperMachComentarios: function (component) {
        var director = component.get("v.showDirector");
        var ejecutivo = component.get("v.showEjecutivo");
        if (director) {
            component.set("v.comentario", component.get("v.comentarioEV"));
        }
        if (ejecutivo) {
            component.set("v.comentario", component.get("v.comentarioDO"));
        }

    },
    getPromedioDOR: function (component, event) {
        var jerarquia = component.get("c.getJerarquia");
        jerarquia.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.jerarquia", result);
            }
            //PROMEDIO POTENCIAL DOR
            var action = component.get("c.PromedioPotDOR_DO");
            action.setParams({
                UgUser: component.get("v.UgUser")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                var result = response.getReturnValue();
                if (state === "SUCCESS") {
                    if (result > 0) {
                        component.set("v.PromDORPot", result);
                    }
                }
                this.helperAction0(component);
            });

            $A.enqueueAction(action);
        });

        $A.enqueueAction(jerarquia);

        var currentdate = new Date();
        var horasString = currentdate.getHours();
        var minutosString = currentdate.getMinutes();
        var time = horasString + ":"
            + minutosString;
        component.set("v.actualDate", time);

    },
    helperAction0: function (component) {
        //PROMEDIO DOR
        var action0 = component.get("c.PromedioDOR_DO");
        action0.setParams({
            UgUser: component.get("v.UgUser")
        });
        action0.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                if (result > 0) {
                    component.set("v.PromDOR", result);
                }
            }
            if (component.get("v.PromDORPot") <= 0) {
                component.set("v.PromDORPot", component.get("v.PromDOR"));
            }
            this.helperAction1(component);
        });

        $A.enqueueAction(action0);
    },
    helperAction1: function (component) {
        //PROMEDIO GANA MAS
        var action1 = component.get("c.PromedioGM_DO");
        action1.setParams({
            UgUser: component.get("v.UgUser")
        });
        action1.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                if (result > 0) {
                    component.set("v.PromGM", result);
                }
            }
            this.helperAction2(component);
        });

        $A.enqueueAction(action1);
    },
    helperAction2: function (component) {
        //PROMEDIO GANA MAS POTENCIAL
        var action2 = component.get("c.PromedioGMP_DO");
        action2.setParams({
            UgUser: component.get("v.UgUser")
        });
        action2.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                if (result > 0) {
                    component.set("v.PromGMPot", result);
                }
            }
            if (component.get("v.PromGMPot") <= 0) {
                component.set("v.PromGMPot", component.get("v.PromGM"));
            }
        });

        $A.enqueueAction(action2);
    },
    detallePuntos: function (component) {
        var usuario = component.get("v.nameEV");
        var action = component.get('c.getDO');

        action.setParams({
            propietario: usuario
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.nameDO", result);
            }

        });

        $A.enqueueAction(action);
    },

})
