/*
*Desarrollado por:       Indra
*Autor:                  Ricardo Almanza
*Proyecto:               BpyP
*Descripción:            Controller basado en RI EU
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 17-05-2018     |    Ricardo Almanza       |           Creación
*1.1    | 04-06-2018     |    Ricardo Almanza       |           Metodos para graficos
*1.2	| 23-01-2019	 |    Adrián Pastor Pineda  |           Se crean métodos para habilitar los DIV's de Contactabilidad y Oportunidades
*/
({
    init: function (component, event, helper) {
        var messages = {
            'title': 'Error',
            'severity': "error",
            'closable': false,
            'message': "Para Poder Evaluar el RI debes estar en la Etapa de Evaluación",
            'isVisible': false
        };
        component.set("v.MessageJson", messages);
        helper.helpergetUserSession(component);
        helper.getSObjectName(component);
    },
    gotoURL: function (component, event, helper) {
        component.set('v.showModalNuevoApoyo', true);
    },
    handleModalNuevoCompromisoOpen: function (component) {
        component.set('v.showComponent', true);
        component.set('v.showModalNuevoCompromiso', true);
    },
    handleModalNuevoCompromisoCancel: function (component) {
        component.set('v.showModalNuevoCompromiso', false);
    },
    guardar: function (component, event, helper) {
        helper.helperGetCreatedByName(component, "el controller");

        helper.helperUpdateComentario(component);

        component.set('v.showModalNuevoCompromiso', false);
    },
    cambio: function (component, event, helper) {
        helper.LlenarRuta(component, event, helper);
        helper.getDatosUserRI(component, event);
        helper.getCintillo(component, event);
        helper.VerificaDirector(component);
        helper.helpergetUserSession2(component, helper);
    },
    btn1: function (component, event, helper) {
        helper.cambiaetapa(component, event, helper);
    },
    btn2: function (component, event, helper) {
        helper.cambiaetapa2(component, event, helper);
    },
    btn3: function (component, event, helper) {
        helper.cambiaetapa3(component, event, helper);
    },
    btn4: function (component, event, helper) {
        helper.cambiaetapa4(component, event, helper);
    },
    displayCOMP: function (component, event, helper) {
        helper.menuRESUMEN(component, event, 'menuCOMP');
    },
    displayAPY: function (component, event, helper) {
        helper.menuRESUMEN(component, event, 'menuAPY');
    },
    GRAPHPUNTOSBPP: function (component, event, helper) {
        component.set("v.GRAPHPUNTOS", true);
        component.set("v.Titulo", "Puntos BPyP");
        helper.helpermenuRESUMEN1(component, event, 'GRAPHPUNTOS');
    },
    GRAPHEUBPP: function (component, event, helper) {
        component.set("v.GRAPHEU", true);
        component.set("v.Titulo", "EU BPyP");
        helper.helpermenuRESUMEN1(component, event, 'GRAPHEU');
    },
    OPORTUNIDADESCOMP: function (component, event, helper) {
        component.set("v.OPORTUNIDADESCOMPDIV", true);
        helper.helpermenuRESUMEN1(component, event, 'OPORTUNIDADESCOMPDIV');
    },
    COMPROMISOSCOMP: function (component, event, helper) {
        component.set("v.COMPROMISOSCOMPDIV", true);
        helper.helpermenuRESUMEN1(component, event, 'COMPROMISOSCOMPDIV');
    },

    RESUMENAPOYOS: function (component, event, helper) {
        component.set("v.RESUMENAPOYOSDIV", true);
        helper.helpermenuRESUMEN1(component, event, 'RESUMENAPOYOSDIV');
    },
    ABIERTOSAPOYOS: function (component, event, helper) {
        component.set("v.ABIERTOSAPOYOSDIV", true);
        helper.helpermenuRESUMEN1(component, event, 'ABIERTOSAPOYOSDIV');
    },
    ABIERTOSCONTACTABILIDAD: function (component, event, helper) {
        component.set("v.ABIERTOSCONTACTABILIDADIV", true);
        helper.helpermenuRESUMEN1(component, event, 'ABIERTOSCONTACTABILIDADIV');
    },
    ABIERTOSOPORTUNIDADES: function (component, event, helper) {
        component.set("v.ABIERTOSOPORTUNIDADESDIV", true);
        helper.helpermenuRESUMEN1(component, event, 'ABIERTOSOPORTUNIDADESDIV');
    },
    btnsig: function (component, event, helper) {
        helper.avanzaEtapa(component, event, helper);
    },
    RecibeParametros: function (cmp, event, helper) {
        var parametrohijo0 = event.getParam("UserUG");
        var parametrohijo1 = event.getParam("RISeleccionada");
        var parametrohijo2 = event.getParam("Showvista1");
        var parametrohijo3 = event.getParam("Showvista2");
        var parametrohijo4 = event.getParam("RISelName");
        var parametrohijo5 = event.getParam("CintilloSelect");
        var parametrohijo6 = event.getParam("Cintillo");
        var parametrohijo7 = event.getParam("CompApoyo");
        var parametrohijo8 = event.getParam("Titulo");
        var parametrohijo9 = event.getParam("fieldEmpleado");
        cmp.set("v.UgUser", parametrohijo0);
        cmp.set("v.RISelect", parametrohijo1);
        cmp.set("v.Showvista1", parametrohijo2);
        cmp.set("v.Showvista2", parametrohijo3);
        cmp.set("v.RISelName", parametrohijo4);
        cmp.set("v.CintilloSelect", parametrohijo5);
        cmp.set("v.Cintillo", parametrohijo6);
        cmp.set("v.CompApoyo", parametrohijo7);
        cmp.set("v.Titulo", parametrohijo8);
        cmp.set("v.Cintillo.MX_BPP_NumEmpleado__c", parametrohijo9);
    },
    DETALLEPUNTOS: function (c, e, h) {
        c.set("v.sDetalle", true);
        h.helpermenuRESUMEN1(c, e, 'sDetalle');
    }
})
