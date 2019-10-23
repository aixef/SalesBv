/*
*Proyecto:               Banca Patrimonial y Privada
*Descripción:
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0	| 		N/A	     |	   N/A					|	  	Creación
*1.1    |   04/07/2019   |  Hugo I. Carrillo B.     |       Correcciones de Code Smell identificados por Sonar
*/
({
    doInit: function (component, e, helper) {
        component.find("pklOffBpyP").set("v.disabled", true);
        component.find("pklBkMnBpyP").set("v.disabled", true);
        component.set('v.ListOfAccount', null);
        var action = component.get('c.fetchDiv');
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfAccount attribute on component.
                component.set('v.ListOfDiv', response.getReturnValue());

            }
        });
        $A.enqueueAction(action);
    },
    generateChart: function (component, e, helper) {
        window.optPie = {
            tooltips: {
                enabled: true,
            },
            hover: {
                animationDuration: 10
            },
            legend: {
                position: 'bottom',
                padding: 10,
                onClick: function (event, legendItem) { },
            },
            animation: {
                onComplete: function () {
                    var chartInstance = this.chart;
                    var ctx = chartInstance.ctx;
                    ctx.textAlign = "left";
                    ctx.fillStyle = "#fff";
                    Chart.helpers.each(this.data.datasets.forEach(function (dataset, i) {
                        var meta = chartInstance.controller.getDatasetMeta(i);
                        Chart.helpers.each(meta.data.forEach(function (bar, index) {
                            var data = dataset.data[index];
                            if (data !== 0) {
                                ctx.fillText(data, bar._model.x - 20, bar._model.y - 10);
                            }
                        }), this)
                    }), this);
                }
            },
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                xAxes: [{
                    stacked: true,
                    gridLines: {
                        display: false
                    },
                }],
                yAxes: [{
                    stacked: true,
                    gridLines: {
                        display: false
                    },
                }]
            },
        };

        window.dataToTableAcc = function (dataset, title) {
            var html = '<table>';
            html += '<thead><tr><th >' + title + '</th>';
            var columnCount = 0;
            jQuery.each(dataset.datasets,
                function (idx, item) {
                    html += '<th style="background-color:' + item.fillColor + ';">' + item.label + '</th>';
                    columnCount += 1;
                }); html += '</tr></thead>';
            jQuery.each(dataset.labels, function (idx, item) {
                html += '<tr><td>' + item + '</td>';
                for (var i = 0; i < columnCount; i++) {
                    html += '<td style="background-color:' + dataset.datasets[i].fillColor + ';">' +
                        (dataset.datasets[i].data[idx] === '0' ? '-' : dataset.datasets[i].data[idx]) + '</td>';
                }
                html += '</tr>';
            });
            html += '</tr><tbody></table>';
            return html;
        };

        var action2 = component.get('c.fetchusdata');
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var chartdrawn = false;
                var perfil = String(response.getReturnValue()).split(',')[0];
                var division = String(response.getReturnValue()).split(',')[1];
                var oficina = String(response.getReturnValue()).split(',')[2];
                var adm = $A.get("$Label.c.MX_PERFIL_SystemAdministrator");
                var dirdiv = "BPyP Director Divisional";
                var diroff = "BPyP Director Oficina";
                if (perfil === (adm) || perfil === dirdiv || perfil === 'DWP Delegados') {
                    component.set('v.isDiv', true)
                }
                if (perfil === (adm) || perfil === diroff || perfil === 'DWP Delegados') {
                    component.set('v.isOff', true)
                }
                if (perfil === (adm) || perfil === dirdiv || perfil === diroff || perfil === 'DWP Delegados') {
                    component.set('v.seldiv', division);
                    helper.updivi(component, e, helper);
                    chartdrawn = true;
                }
                if (perfil === (adm) || perfil === diroff || perfil === 'DWP Delegados') {
                    component.set('v.seloff', oficina);
                    helper.updoffi(component, e, helper);
                    chartdrawn = true;
                }
                if (!chartdrawn) {
                    helper.piediv(component, e);
                }
            }
        });
        $A.enqueueAction(action2);
    },
    updDiv: function (component, e, helper) {

        component.set('v.ListOfAccount', null);
        component.set('v.isCln', false);
        helper.updivi(component, e, helper);
    },
    updOffice: function (component, e, helper) {

        component.set('v.ListOfAccount', null);
        component.set('v.isCln', false);
        helper.updoffi(component, e, helper);
    },
    updTyInf: function (component, e, helper) {
        component.set('v.isCln', false);
        component.set('v.ListOfAccount', null);
        if (component.find("pklDivBpyP").get("v.value") === "") {
            helper.piediv(component, e);
        }
        else if (component.find("pklOffBpyP").get("v.value") === "") {
            helper.pieoff(component, e);
        }
        else if (component.find("pklBkMnBpyP").get("v.value") === "") {
            helper.piebkm(component, e, '');
        }
        else {
            helper.piebkm(component, e, 'bmkoly');
            helper.fetchacc(component, e, helper);
        }
    },
    updBkM: function (component, e, helper) {
        helper.piebkm(component, e, 'bmkoly');
        helper.fetchacc(component, e, helper);
    },
    frst: function (component, e, helper) {
        //call apex class method
        var action = component.get('c.fetchAcc');
        action.setParams({ BkMn: component.find("pklBkMnBpyP").get("v.value"), type: component.find("pklTyInfBpyP").get("v.value"), off: '0' });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfAccount attribute on component.
                if (component.find("pklBkMnBpyP").get("v.value") !== "") { component.set('v.isCln', true); }
                component.set('v.ListOfAccount', response.getReturnValue());
                component.set('v.ActPag', 1);
            }
        });
        $A.enqueueAction(action);
    },
    prev: function (component, e, helper) {
        //call apex class method
        var action = component.get('c.fetchAcc');
        var actPg = component.get('v.ActPag');
        var prv = actPg === 1 ? 1 : actPg - 1;
        prv--;
        prv = prv * window.sizeofAcc;
        action.setParams({ BkMn: component.find("pklBkMnBpyP").get("v.value"), type: component.find("pklTyInfBpyP").get("v.value"), off: prv.toString() });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                prv = prv / window.sizeofAcc;
                //set response value in ListOfAccount attribute on component.
                if (component.find("pklBkMnBpyP").get("v.value") !== "") {
                    component.set('v.isCln', true);
                }
                prv++;
                component.set('v.ListOfAccount', response.getReturnValue());
                component.set('v.ActPag', prv);
            }
        });
        $A.enqueueAction(action);
    },
    next: function (component, e, helper) {
        //call apex class method
        var action = component.get('c.fetchAcc');
        var actPg = component.get('v.ActPag');
        var totPg = component.get('v.NumOfPag');
        var nxt = actPg === totPg ? totPg : actPg + 1;
        nxt--;
        nxt = nxt * window.sizeofAcc;
        action.setParams({ BkMn: component.find("pklBkMnBpyP").get("v.value"), type: component.find("pklTyInfBpyP").get("v.value"), off: nxt.toString() });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfAccount attribute on component.
                nxt = nxt / window.sizeofAcc;
                if (component.find("pklBkMnBpyP").get("v.value") !== "") {
                    component.set('v.isCln', true);
                }
                nxt++;
                component.set('v.ListOfAccount', response.getReturnValue());
                component.set('v.ActPag', nxt);
            }
        });
        $A.enqueueAction(action);
    },
    lst: function (component, e, helper) {
        //call apex class method
        var action = component.get('c.fetchAcc');
        var totPg = component.get('v.NumOfPag');
        totPg--;
        totPg = totPg * window.sizeofAcc;
        action.setParams({ BkMn: component.find("pklBkMnBpyP").get("v.value"), type: component.find("pklTyInfBpyP").get("v.value"), off: totPg.toString() });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                totPg = totPg / window.sizeofAcc;
                //set response value in ListOfAccount attribute on component.
                if (component.find("pklBkMnBpyP").get("v.value") !== "") {
                    component.set('v.isCln', true);
                }
                totPg++;
                component.set('v.ListOfAccount', response.getReturnValue());
                component.set('v.ActPag', totPg);
            }
        });
        $A.enqueueAction(action);
    },
})
