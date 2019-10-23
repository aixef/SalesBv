/*
 * 		?
 * ________________________________________________________________________________
 * Versión		Fecha		Autor				Descripción
 * 1.0			???			???					???
 * 1.1			22/01/18	Cristian Espinosa	Corrección de incidencia, se valida
 * 												el tipo de usuario antes de imprimir
 * 												las gráficas.
 * 2.0          15-01-2019  Francisco J Licona  Se crea método que gestiona la información
 *                                              de contactabilidad de clientes y la funcionalidad
 *                                              de paginado de listado de clientes.
 * 2.1			11-02-2019	Francisco J Licona	Se elimina lógica que muestra tabla de contactabilidad, se deja tabla default.
 * 2.2			28/01/2019  Adrián Pastor		Se crea función para setear el cargo de un banquero.
 * 3.0          11/03/2019  Francisco J Licona  Se modifican los métodos para gestionar la tabla de contactabilidad
 *                                              del cliente.
 * 3.1			19/03/2019	Francisco J Licona	Se eliminan los métodos correspondientes al paginado
 * 												de lista.
 * 3.2          24/05/2019  Hugo I. Carrillo B. Correcciones de Code Smell identificadas por Sonar
 */
({
    initdraw: function (component, e, helper) {
        var action2 = component.get('c.fetchusdata');
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.verifyPerfil(component, e, helper, response);
            }
        });
        $A.enqueueAction(action2);
    },
    verifyPerfil: function (component, e, helper, response) {
        var chartdrawn = false;
        var perfil = String(response.getReturnValue()).split(',')[0];
        var division = String(response.getReturnValue()).split(',')[1];
        var oficina = String(response.getReturnValue()).split(',')[2];
        var usrname = String(response.getReturnValue()).split(',')[3];
        var title = String(response.getReturnValue()).split(',')[4];
        var adm = $A.get("$Label.c.MX_PERFIL_SystemAdministrator");
        var dwpPerfil = "DWP Delegados";
        var dirdiv = "BPyP Director Divisional";
        var diroff = "BPyP Director Oficina";
        var bpypestandar = "BPyP Estandar";
        if (title === 'PRIVADO') {
            title = 'Pr';
        } else if (title === 'PATRIMONIAL') {
            title = 'Pa';
        } else if (title === 'PATRIMONIAL SR') {
            title = 'Pas';
        }
        if (perfil === (dwpPerfil) || perfil === (adm)) {
            component.set('v.isBkm', true);
            component.set("v.seltitle", title);
            component.find("pklTyAccBpyP").set("v.disabled", true);
            component.set('v.isDiv', true);
            component.set('v.isOff', true);
            component.set('v.seldiv', division);
            helper.fetchoff(component, e, helper);
            chartdrawn = true;
            component.set('v.seloff', oficina);
            helper.fetchbkm(component, e, helper);
            component.set('v.selbkm', usrname);
            helper.drawbkmo(component, e);
        } else if (perfil === dirdiv) {
            component.set('v.isDiv', true);
            component.set('v.seldiv', division);
            helper.fetchoff(component, e, helper);
            chartdrawn = true;
        } else if (perfil === diroff) {
            component.set('v.isOff', true);
            component.set('v.seldiv', division);
            helper.fetchoff(component, e, helper);
            chartdrawn = true;
            component.set('v.seloff', oficina);
            helper.fetchbkm(component, e, helper);
        } else if (perfil === bpypestandar) {
            component.set('v.isBkm', true);
            component.set("v.seltitle", title);
            component.find("pklTyAccBpyP").set("v.disabled", true);
            component.set('v.seldiv', division);
            helper.fetchoff(component, e, helper);
            chartdrawn = true;
            component.set('v.seloff', oficina);
            helper.fetchbkm(component, e, helper);
            component.set('v.selbkm', usrname);
            helper.drawbkmo(component, e);
        }
        if (!chartdrawn) { helper.drawdiv(component, e); }
    },
    helperProfileValidation: function (component) {
        if (component.get("v.isOff")) {
            component.find("pklDivBpyP").set("v.disabled", true);
            component.find("pklOffBpyP").set("v.disabled", true);
        }
        if (component.get("v.isDiv")) {
            component.find("pklDivBpyP").set("v.disabled", true);
        }
        if (component.get("v.isBkm")) {
            component.find("pklDivBpyP").set("v.disabled", true);
            component.find("pklOffBpyP").set("v.disabled", true);
            component.find("pklBkMnBpyP").set("v.disabled", true);
        }
        if (window.redraw === false) {
            return;
        }
    },
    drawdiv: function (component, e) {
        component.find("pklDivBpyP").set("v.disabled", false);
        component.find("pklBkMnBpyP").set("v.disabled", true);
        component.find("pklOffBpyP").set("v.disabled", true);
        this.helperProfileValidation(component);
        //Get the context of the canvas element we want to select
        var ctx = component.find("myChartt").getElement();
        //call apex class method
        var action = component.get('c.fetchDivData');
        this.verifyBandera07(component, action, "action");

        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();

                var height = 100 + (res.lsLabels.toString().split(',').length * 30);

                component.set('v.chartHeight', height);
                if (window.myChartt != null) {
                    window.myChartt.clear();
                    window.myChartt.destroy();
                }
                window.myChartt = new Chart(ctx, { type: 'horizontalBar', data: {}, options: window.barOptions_stacked_perc });
                this.helperLabels(res);
                myChartt.update();
                jQuery('#wrapper').html(window.window.dataToTablePerc(window.myChartt.data, 'DIVISION'));
            }
        });
        $A.enqueueAction(action);
        this.helperProfileValidation(component);
    },
    verifyBandera07: function (component, action, name) {
        if (component.get('v.bandera')) {
            var seltitle = component.get('v.seltitle');
            switch (seltitle) {
                case 'PRIVADO':
                    seltitle = 'Pr';
                    break;
                case 'PATRIMONIAL':
                    seltitle = 'Pa';
                    break;
                case 'PATRIMONIAL SR':
                    seltitle = 'Pas';
                    break;
            }
            if (name === "action") {
                action.setParams({
                    type: seltitle,
                    sD: component.find("expsdate").get("v.value"),
                    eD: component.find("expedate").get("v.value"),
                });
            } else if (name === "action7") {
                action.setParams({
                    type: seltitle,
                    bkM: component.find("pklBkMnBpyP").get("v.value"),
                    sD: component.find("expsdate").get("v.value"),
                    eD: component.find("expedate").get("v.value"),
                });
            }
        } else {
            if (name === "action") {
                action.setParams({
                    type: component.find("pklTyAccBpyP").get("v.value"),
                    sD: component.find("expsdate").get("v.value"),
                    eD: component.find("expedate").get("v.value"),
                });
            } else if (name === "action7") {
                action.setParams({
                    type: component.find("pklTyAccBpyP").get("v.value"),
                    bkM: component.find("pklBkMnBpyP").get("v.value"),
                    sD: component.find("expsdate").get("v.value"),
                    eD: component.find("expedate").get("v.value"),
                });
            }
        }
    },
    helperLabels: function (res) {
        var labels = [];
        for (var i = res.lsLabels.toString().split(',').length - 1; i >= 0; i--) {
            myChartt.config.data.labels.push(res.lsLabels.toString().split(',')[i]);
            labels.push(res.lsLabels.toString().split(',')[i]);
        }
        if (window.val != null) { window.val = null; }
        window.val = [];
        for (var j = res.lsTyOpp.toString().split(',').length - 1; j >= 0; j--) {
            var datatemp = [];
            var dataval = [];
            for (var k = 0; k < labels.length; k++) {
                datatemp.push(res.lsData[(res.lsTyOpp.toString().split(',')[j] + labels[k])] == null ? 0 : res.lsData[(res.lsTyOpp.toString().split(',')[j] + labels[k])]);
                dataval.push(res.numVis[(res.lsTyOpp.toString().split(',')[j] + labels[k])] == null ? 0 : res.numVis[(res.lsTyOpp.toString().split(',')[j] + labels[k])]);
            }
            window.val.push(dataval);

            var newDataset = { label: res.lsTyOpp.toString().split(',')[j], backgroundColor: res.lsColor.toString().split('),')[j] + ')', data: datatemp, }
            myChartt.data.datasets.push(newDataset);
        }
    },
    drawoff: function (component, e) {
        component.find("pklBkMnBpyP").set("v.disabled", true);
        component.find("pklOffBpyP").set("v.disabled", false);
        this.helperProfileValidation(component);
        //Get the context of the canvas element we want to select
        var ctx3 = component.find("myChartt").getElement();
        //call apex class method
        var action3 = component.get('c.fetchOffData');
        this.verifyBandera35(component, action3, "action3");

        action3.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();

                var height = 100 + (res.lsLabels.toString().split(',').length * 30);

                component.set('v.chartHeight', height);
                if (window.myChartt != null) {
                    window.myChartt.clear();
                    window.myChartt.destroy();
                }
                window.myChartt = new Chart(ctx3, { type: 'horizontalBar', data: {}, options: window.barOptions_stacked_perc });
                this.helperLabels(res);
                myChartt.update();
                jQuery('#wrapper').html(window.window.dataToTablePerc(window.myChartt.data, 'OFICINA'));
            }
        });
        $A.enqueueAction(action3);
        this.helperProfileValidation(component);
    },
    verifyBandera35: function (component, action, name) {
        if (component.get('v.bandera')) {
            var seltitle = component.get('v.seltitle');
            var selbkm = component.get('v.selbkm');
            component.set('v.selbkm', selbkm);
            switch (seltitle) {
                case 'PRIVADO':
                    seltitle = 'Pr';
                    break;
                case 'PATRIMONIAL':
                    seltitle = 'Pa';
                    break;
                case 'PATRIMONIAL SR':
                    seltitle = 'Pas';
                    break;
            }
            if (name === "action3") {
                action.setParams({
                    type: seltitle,
                    divi: component.find("pklDivBpyP").get("v.value"),
                    sD: component.find("expsdate").get("v.value"),
                    eD: component.find("expedate").get("v.value"),
                });
            } else if (name === "action5") {
                action.setParams({
                    type: seltitle,
                    divi: component.find("pklDivBpyP").get("v.value"),
                    off: component.find("pklOffBpyP").get("v.value"),
                    sD: component.find("expsdate").get("v.value"),
                    eD: component.find("expedate").get("v.value"),
                });
            }
        } else {
            if (name === "action3") {
                action.setParams({
                    type: component.find("pklTyAccBpyP").get("v.value"),
                    divi: component.find("pklDivBpyP").get("v.value"),
                    sD: component.find("expsdate").get("v.value"),
                    eD: component.find("expedate").get("v.value"),
                });
            } else if (name === "action5") {
                action.setParams({
                    type: component.find("pklTyAccBpyP").get("v.value"),
                    divi: component.find("pklDivBpyP").get("v.value"),
                    off: component.find("pklOffBpyP").get("v.value"),
                    sD: component.find("expsdate").get("v.value"),
                    eD: component.find("expedate").get("v.value"),
                });
            }
        }
    },
    drawbkm: function (component, e) {
        component.find("pklBkMnBpyP").set("v.disabled", false);
        this.helperProfileValidation(component);
        //Get the context of the canvas element we want to select
        var ctx5 = component.find("myChartt").getElement();
        //call apex class method
        var action5 = component.get('c.fetchBkMData');
        this.verifyBandera35(component, action5, "action5");

        action5.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();

                var height = 100 + (res.lsLabels.toString().split(',').length * 30);

                component.set('v.chartHeight', height);
                if (window.myChartt != null) {
                    window.myChartt.clear();
                    window.myChartt.destroy();
                }
                window.myChartt = new Chart(ctx5, { type: 'horizontalBar', data: {}, options: window.barOptions_stacked_perc });
                this.helperLabels(res);
                myChartt.update();
                jQuery('#wrapper').html(window.window.dataToTablePerc(window.myChartt.data, 'BANQUERO'));
            }
        });
        $A.enqueueAction(action5);
        this.helperProfileValidation(component);
    },
    drawbkmo: function (component, e) {
        this.helperProfileValidation(component);
        //Get the context of the canvas element we want to select
        var ctx7 = component.find("myChartt").getElement();
        //call apex class method
        var action7 = component.get('c.fetchBkMOnlyData');
        this.verifyBandera07(component, action7, "action7");

        action7.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();

                var height = 100 + (res.lsLabels.toString().split(',').length * 30);

                component.set('v.chartHeight', height);
                if (window.myChartt != null) {
                    window.myChartt.clear();
                    window.myChartt.destroy();
                }
                window.myChartt = new Chart(ctx7, { type: 'horizontalBar', data: {}, options: window.barOptions_stacked_perc });
                this.helperLabels(res);
                myChartt.update();
                jQuery('#wrapper').html(window.window.dataToTablePerc(window.myChartt.data, 'BANQUERO'));
            }
        });
        $A.enqueueAction(action7);
        this.helperProfileValidation(component);
    },
    resetdates: function (component, e) {
        var stdt = component.find("expsdate").get("v.value");
        var eddt = component.find("expedate").get("v.value");
        if (!((String(e.getSource()).includes("expedate")) || (String(e.getSource()).includes("expsdate"))) &&
            (stdt == null || stdt === '' || eddt == null || eddt === '')) {
            component.set('v.sDate', null);
            component.set('v.eDate', null);

        }
        else if ((stdt == null || stdt === '' || eddt == null || eddt === '')) {
            window.redraw = false;
            return;
        }
        window.redraw = true
    },
    fetchoff: function (component, e, helper) {
        component.set('v.ListOfOpp', null);

        component.set('v.seloff', '');
        if (!component.get('v.bandera')) {
            component.set('v.selbkm', '');
        }
        //call apex class method
        var action = component.get('c.fetchOff');
        action.setParams({ div: component.find("pklDivBpyP").get("v.value") });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.ListOfOff', response.getReturnValue());
                if (response.getReturnValue() != null) {
                    component.find("pklOffBpyP").set("v.disabled", false);
                    component.set('v.ListOfBkMn', null);
                    component.find("pklBkMnBpyP").set("v.disabled", true);
                    helper.drawoff(component, e);
                }
                else {
                    component.find("pklOffBpyP").set("v.disabled", true);
                    component.set('v.ListOfBkMn', null);
                    component.find("pklBkMnBpyP").set("v.disabled", true);
                    helper.drawdiv(component, e);
                }
            }
        });
        $A.enqueueAction(action);
    },
    fetchbkm: function (component, e, helper) {
        component.set('v.ListOfOpp', null);
        if (!component.get('v.bandera')) {
            component.set('v.selbkm', '');
        }
        var divsel = component.find("pklDivBpyP").get("v.value");
        var offsel = component.find("pklOffBpyP").get("v.value");
        //call apex class method
        var action = component.get('c.fetchBankMan');
        action.setParams({ div: divsel, office: offsel });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.ListOfBkMn', response.getReturnValue());
                if (response.getReturnValue() != null) {
                    component.find("pklBkMnBpyP").set("v.disabled", false);
                    if (component.get("v.isBkm")) {
                        helper.drawbkmo(component, e);
                    } else {
                        helper.drawbkm(component, e);
                    }
                }
                else {
                    component.find("pklBkMnBpyP").set("v.disabled", true);
                    helper.drawoff(component, e);
                }
            }
        });
        $A.enqueueAction(action);
    },
    cargoBkm: function (component) {
        var Ri = component.get("v.RISelect");
        var action = component.get('c.getRISelect');
        action.setParams({ IdRI: Ri });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.seltitle', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    doFetchContact: function (component) {
        var action = component.get('c.contactabilityAccount');
        var banquero = component.get("v.selbkm");
        var contactType = component.get("v.contactStatus");
        var type = component.get("v.seltitle");
        var tittle = '';
        if (type === 'Pr') {
            tittle = 'PRIVADO'
        } else if (type === 'Pa') {
            tittle = "PATRIMONIAL";
        } else if (type === 'Pa') {
            tittle = "PATRIMONIAL SR";
        } else {
            tittle = type;
        }
        action.setParams({
            banquero: banquero,
            contactType: contactType,
            sD: component.find("expsdate").get("v.value"),
            eD: component.find("expedate").get("v.value"),
            tittle: tittle
        });
        action.setCallback(this, function (response) {
            this.helperDoFetchContact(component, response);
        });
        $A.enqueueAction(action);
    },
    helperDoFetchContact: function (component, response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
            var pageSize = component.get("v.pageSize");
            component.set('v.ContactData', response.getReturnValue());
            component.set("v.totalRecords", component.get("v.ContactData").length);
            component.set("v.startPage", 0);
            component.set("v.endPage", pageSize - 1);
            var PaginationList = [];
            var records = response.getReturnValue();
            records.forEach(function (record) {
                record.LinkName = component.get('v.url') + '/' + record.Id;
            });
            for (var i = 0; i < pageSize; i++) {
                if (component.get("v.ContactData").length > i)
                    PaginationList.push(records[i]);
            }
            if (component.get("v.ContactData").length > 0) {
                component.set("v.tableHeight", 'height:300px;');
            } else {
                component.set("v.tableHeight", 'height:0px;');
            }
            component.set('v.PaginationList', PaginationList);
        }
    },
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.PaginationList");
        var reverse = sortDirection !== 'asc';
        data = Object.assign([],
            data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
        );
        cmp.set("v.PaginationList", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer
            ? function (x) { return primer(x[field]) }
            : function (x) { return x[field] };
        return function (a, b) {
            var A = key(a);
            var B = key(b);
            return reverse * ((A > B) - (B > A));
        };
    },
    helperGenerateChart: function (component, e, helper) {
        window.dataToTable = function (dataset, title) {
            var html = '<html> <head> <style> th, td {border-bottom: 2px solid #ddd; text-align: center}</style> </head> <body><table>';
            html += '<thead><tr><th>' + title + '</th>';
            var columnCount1 = 0;
            jQuery.each(dataset.datasets, function (idx, item) {
                html += '<th style="text-align:center; background-color:' +
                    String(item.backgroundColor).substring(0, String(item.backgroundColor).length - 2) +
                    '0.5);">' +
                    String(item.label).substring(0, String(item.label).indexOf(' ', 4)) +
                    '<br/>' +
                    (String(item.label).substring(String(item.label).indexOf(' ', 4) + 1
                        , String(item.label).length)) + '</th>';
                columnCount1 += 1;
            });
            html += '</tr></thead>';
            jQuery.each(dataset.labels, function (idx, item) {
                html += '<tr><td>' + item + '</td>';
                for (var i = 0; i < columnCount1; i++) {
                    html += '<td style="text-align:center; background-color:' +
                        String(dataset.datasets[i].backgroundColor).substring(0, dataset.datasets[i].backgroundColor.length - 2) +
                        '0.5);">' +
                        (dataset.datasets[i].data[idx] === '0' ? '-' : dataset.datasets[i].data[idx]) +
                        '</td>';
                }
                html += '</tr>';
            });
            html += '</tr><tbody></table>';
            return html;
        };
        window.window.dataToTablePerc = function (dataset, title) {
            var html = '<html> <head> <style> th, td {border-bottom: 2px solid #ddd; text-align: center}</style> </head> <body><table>';
            html += '<thead><tr><th rowspan="2">' + title + '</th>';
            var columnCount = 0;
            jQuery.each(dataset.datasets, function (idx, item) {
                html += '<th colspan="2" style="text-align:center; background-color:' +
                    String(item.backgroundColor).substring(0, String(item.backgroundColor).length - 2) +
                    '0.5);">' +
                    item.label +
                    '' +
                    '</th>';
                columnCount += 1;
            });
            html += '</tr>';
            html += '<tr>';
            columnCount = 0;
            jQuery.each(dataset.datasets, function (idx, item) {
                html += '<th style="text-align:center; background-color:' +
                    String(item.backgroundColor).substring(0, String(item.backgroundColor).length - 2) +
                    '0.5);">' +
                    'Clientes' +
                    '</th>';
                html += '<th style="text-align:center; background-color:' +
                    String(item.backgroundColor).substring(0, String(item.backgroundColor).length - 2) +
                    '0.5);">' +
                    'Porcentaje' +
                    '</th>';
                columnCount += 1;
            });
            html += '</tr></thead>';
            jQuery.each(dataset.labels, function (idx, item) {
                html += '<tr><td>' + item + '</td>';
                for (var i = 0; i < columnCount; i++) {
                    html += '<td style="text-align:center; background-color:' +
                        String(dataset.datasets[i].backgroundColor).substring(0, dataset.datasets[i].backgroundColor.length - 2) +
                        '0.5);">' +
                        (window.val[i][idx] === '0' ? '-' : window.val[i][idx]) +
                        '</td>';
                    html += '<td style="text-align:center; background-color:' +
                        String(dataset.datasets[i].backgroundColor).substring(0, dataset.datasets[i].backgroundColor.length - 2) +
                        '0.5);">' +
                        '' +
                        (dataset.datasets[i].data[idx] === '0' ? '-' : dataset.datasets[i].data[idx]) +
                        '%' +
                        '</td>';
                } html += '</tr>';
            });
            html += '</tr><tbody></table>';
            return html;
        };
        window.barOptions_stacked_perc = {
            tooltips: {
                enabled: true, position: 'nearest', callbacks: {
                    label: function (tooltipItem, data) {
                        return data.datasets[tooltipItem.datasetIndex].label + ': ' +
                            window.val[tooltipItem.datasetIndex][tooltipItem.index] + ' (' +
                            tooltipItem.xLabel.toString() + '%)';
                    },
                }
            },
            legend: {
                position: 'bottom', padding: 10, onClick: function (event, legendItem) { },
            },
            hover: { animationDuration: 10 }, responsive: true, maintainAspectRatio: false, scales: {
                xAxes: [{
                    scaleLabel: {
                        display: false
                    },
                    gridLines: {
                        display: false
                    },
                    stacked: true, ticks: {
                        callback: function (value, index, values) {
                            return value + '%';
                        }
                    }
                }],
                yAxes: [{
                    scaleLabel: {
                        display: false
                    },
                    gridLines: {
                        display: false
                    },
                    stacked: true
                }]
            },
            animation: {
                onComplete: function () {
                    helper.helperOnComplete(this, "tipo1");
                }
            },
        };
        window.barOptions_stacked = {
            tooltips: {
                enabled: true, position: 'nearest',
            },
            legend: {
                position: 'bottom', padding: 10, onClick: function (event, legendItem) { },
            },
            hover: {
                animationDuration: 10
            },
            responsive: true, maintainAspectRatio: false, scales: {
                xAxes: [{
                    scaleLabel: {
                        display: false
                    },
                    gridLines: {
                        display: false
                    },
                    stacked: true,
                }],
                yAxes: [{
                    scaleLabel: {
                        display: false
                    },
                    gridLines: {
                        display: false
                    },
                    stacked: true
                }]
            },
            animation: {
                onComplete: function () {
                    helper.helperOnComplete(this, "tipo2");
                }
            },
        };
        window.redraw = true;
        helper.initdraw(component, e, helper);
        helper.doFetchContact(component);
    },
    helperOnComplete: function (fun, tipo) {
        var chartInstance = fun.chart;
        var ctx = chartInstance.ctx;
        ctx.textAlign = "left";
        ctx.fillStyle = "#fff";
        Chart.helpers.each(fun.data.datasets.forEach(function (dataset, i) {
            var meta = chartInstance.controller.getDatasetMeta(i);
            Chart.helpers.each(meta.data.forEach(function (bar, index) {
                var data = dataset.data[index];
                if (data !== 0 && tipo === "tipo1") {
                    ctx.fillText(data + '%', bar._model.x - 40, bar._model.y - 10);
                } else if (data !== 0 && tipo === "tipo2") {
                    ctx.fillText(data, bar._model.x - 20, bar._model.y - 10);
                }
            }), this)
        }), fun);
    },
})
