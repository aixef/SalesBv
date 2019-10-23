({
    searchHelper: function (component, event) {
        component.find("Id_spinner").set("v.class", 'slds-show');
        var action = component.get("c.lstCampaignMember");
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword")
        });
        action.setCallback(this, function (response) {
            component.find("Id_spinner").set("v.class", 'slds-hide');
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length === 0) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Lo sentimos: ",
                        "mode": 'dismissible',
                        "type": "warning",
                        "duration": 1000,
                        "message": "No se encontraron registros."
                    });
                    toastEvent.fire();
                }
                component.set("v.TotalNumberOfRecord", storeResponse.length);
                component.set("v.searchResult", storeResponse);
                var tempr = storeResponse[0];
                var temp2 = tempr.Campaign;
                component.set("v.enableSegmentado", temp2.MX_SB_VTS_Segmentada__c);
                component.set("v.segmentado2",temp2.MX_SB_VTS_Segmentada__c);
                this.helperFields(component);
            } else if (state === "INCOMPLETE" || state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);

    },
    busqueda: function (component, cadena) {
        var action = component.get("c.lstCampaignMember");
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword"),
            'cadena': cadena

        });
        action.setCallback(this, function (response) {
            component.find("Id_spinner").set("v.class", 'slds-hide');
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length === 0) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Lo sentimos: ",
                        "mode": 'dismissible',
                        "type": "warning",
                        "duration": 1000,
                        "message": "No se encontraron registros."
                    });
                    toastEvent.fire();
                }
                component.set("v.TotalNumberOfRecord", storeResponse.length);
                component.set("v.searchResult", storeResponse);
            } else if (state === "INCOMPLETE" || state === "ERROR") {
                var errors = response.getError();
                var toastEvt = $A.get("e.force:showToast");
                toastEvt.setParams({
                    "title": "Lo sentimos: ",
                    "mode": 'pester',
                    "type": "warning",
                    "duration": 5000,
                    "message": errors
                });
                toastEvt.fire();
            }
        });
        $A.enqueueAction(action);
    },

    SendCTIHelper: function (component, event) {
        var SearchResul = component.get("v.searchResult");
        var Segmentado = component.get("v.enableSegmentado");
        var fechaHora = component.get("v.DateLEad");
        var bandeja = component.get("v.Bandeja");
        var Ejecuta = true;

        if ((Segmentado && (bandeja === null||bandeja === undefined)) || (Segmentado && (fechaHora === null || fechaHora === undefined))) {
            Ejecuta = false;
            var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error de validado ",
                        "mode": 'dismissible',
                        "duration": 3000,
                        "type": "error",
                        "message": "Los campos Bandeja y fecha  no pueden estar vacios."
                    });
                    toastEvent.fire();
        }
        if (SearchResul.length > 0 && Ejecuta) {
            var action = component.get("c.lstLeadEnviarCTI");
            action.setParams({
                'searchResult': SearchResul,
                'Segmentado': Segmentado,
                'fechaHora': fechaHora,
                'bandeja': bandeja
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Exito ",
                        "mode": 'dismissible',
                        "duration": 3000,
                        "type": "success",
                        "message": "Se han enviado los registros a CTI."
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
    },

    helperFields: function (component) {
        var optionValue = component.get("c.getListSettings");
        optionValue.setParams({
            'Segmentado': component.get("v.enableSegmentado")
        });
        optionValue.setCallback(this, function (a) {
            component.set("v.optVal", a.getReturnValue());
        });
        $A.enqueueAction(optionValue);
    },

    helperActualiza: function (component, event) {
        var action = component.get("c.getListFilter");
        action.setParams({
            'addValue': component.get("v.valueOperator"),
            'field': component.get("v.value"),
            'selectedOperator': component.get("v.selectedOperator"),
            'Segmentado': component.get("v.enableSegmentado")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                var lstQueries = component.get('v.lstQeryRsult');
                var objQuery = {};
                objQuery.iteration = component.get('v.iterationQueries');
                objQuery.query = storeResponse;
                lstQueries.push(objQuery);
                var cadena = '';
                lstQueries.forEach(function (queryStatement) {
                    cadena += ' ' + queryStatement.query;
                });
                component.set('v.iterationQueries', component.get('v.iterationQueries') + 1)
                component.set('v.lstQeryRsult', lstQueries);
                this.busqueda(component, cadena);
            } else if (state === "INCOMPLETE" || state === "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Lo sentimos: ",
                    "mode": 'pester',
                    "type": "warning",
                    "duration": 5000,
                    "message": errors
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    searchHelper2: function (component, event, getInputkeyWord) {
        // call the apex class method
        var action = component.get("c.fetchLookUpValues");
        // set param to method
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName': component.get("v.objectAPIName")
        });
        // set a callBack
        action.setCallback(this, function (response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length === 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }

        });
        // enqueue the Action
        $A.enqueueAction(action);

    },
})
