/*
*Proyecto:               Banca Patrimonial y Privada
*Descripción:            Componente Lightning para gestión de contactabilidad del cliente.
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0	| 		N/A	     |	   N/A					|	  	Creación
*2.0    |   15-01-2019   |    Francisco J Licona    |       Se crean métodos para llamado a helper con funcionalidad de clientes contactados y no contactados.
*2.1	|   28/01/2019   |	Adrián Pastor Pineda	|		Se crea método para el llamado a helper con funcionalidad de setear el cargo del Banquero.
*3.0    |   11/03/2019   |  Francisco J Licona      |       Se modifican los métodos para gestionar la tabla de contactabilidad del cliente.
*3.1	|	19/03/2019	 |	Francisco J Licona	    |		Se eliminan los métodos correspondientes al paginado de lista.
*3.2    |   21/05/2019   |  Hugo I. Carrillo B.     |       Correcciones de Code Smell identificados por Sonar
*/
({
    doInit: function (component, event, helper) {
        component.find("pklOffBpyP").set("v.disabled", true);
        component.find("pklBkMnBpyP").set("v.disabled", true);
        component.set('v.ListOfOpp', null);
        component.set("v.url", window.location.origin);
        var action = component.get('c.fetchDiv');
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfOpp attribute on component.
                component.set('v.ListOfDiv', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        if (component.get('v.bandera')) {
            helper.initdraw(component, event, helper);
            helper.cargoBkm(component, event);
            component.set('v.bandera', true);
        }
        component.set('v.columns', [
            { label: 'Nombre del Cliente', fieldName: 'LinkName', type: 'url', sortable: true, typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' } },
            { label: 'Número de Cliente', fieldName: 'No_de_cliente__c', type: 'text', sortable: true },
            { label: 'Teléfono', fieldName: 'Phone', type: 'phone', sortable: true },
            { label: 'Última visita', fieldName: 'BPyP_Fecha_de_ultima_visita__c', type: 'Date', sortable: true }
        ]);
        helper.doFetchContact(component);
    },
    generateChart: function (component, e, helper){
        helper.helperGenerateChart(component, e, helper);
    },
    updDiv: function (component, e, helper) {
        helper.resetdates(component, e);
        helper.fetchoff(component, e, helper);
        helper.doFetchContact(component);
    },
    updOffice: function (component, e, helper) {
        helper.resetdates(component, e);
        helper.fetchbkm(component, e, helper);
        helper.doFetchContact(component);
    },
    updOpAc: function (component, e, helper) {
        helper.resetdates(component, e);
        if (component.find("pklDivBpyP").get("v.value") === "") {
            helper.drawdiv(component, e);
        }
        else if (component.find("pklOffBpyP").get("v.value") === "") {
            helper.drawoff(component, e);
        }
        else if (component.find("pklBkMnBpyP").get("v.value") === "") {
            helper.drawbkm(component, e);
        }
        else {
            helper.drawbkmo(component, e);
        }
        helper.doFetchContact(component);
    },
    updBkM: function (component, e, helper) {
        helper.resetdates(component, e);
        component.set('v.ListOfOpp', null);
        if (component.find("pklBkMnBpyP").get("v.value") === "") {
            helper.drawbkm(component, e);
        }
        else {
            helper.drawbkmo(component, e);
        }
        helper.doFetchContact(component);
    },
    updateAcc: function (component, event, helper) {
        helper.doFetchContact(component);
    },
    updateColumnSorting: function (cmp, event, helper) {
        setTimeout(function () {
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            cmp.set("v.sortedBy", fieldName);
            cmp.set("v.sortedDirection", sortDirection);
            helper.sortData(cmp, fieldName, sortDirection);
        }, 0);
    }
})
