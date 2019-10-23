({
    doInit: function (component) {
        component.find("pklOffBpyP").set("v.disabled", true);
        component.find("pklBkMnBpyP").set("v.disabled", true);
        component.set('v.ListOfOpp', null);
        var action = component.get('c.fetchDiv');
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfOpp attribute on component.
                component.set('v.ListOfDiv', response.getReturnValue());
                if (component.get('v.bandera')) {
                    $A.enqueueAction(component.get('c.cargaDiv'));
                    component.set('v.bandera', true);
                }
            }
        });
        $A.enqueueAction(action);

        var action2 = component.get('c.fetchTyoOp');
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.ListOfTyOpp', response.getReturnValue());
            }
        });
        $A.enqueueAction(action2);
    },
    cargaDiv: function (component, e, helper) {
        var Ri = component.get("v.RISelect");

        component.find("pklDivBpyP").set("v.disabled", true);
        var act = component.get('c.getRISelect');
        act.setParams({
            idRI: Ri
        });
        act.setCallback(this, function (resp) {
            var state = resp.getState();
            var result = resp.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.seldiv', result.Divisi_n__c);
                component.set('v.seloff', result.BPyP_ls_NombreSucursal__c);
                helper.updivi(component, e, helper);
                helper.fetchbkmolydata(component, e);
                helper.updoffi(component, e, helper);
            }
        });
        $A.enqueueAction(act);
    },
    generateChart: function (component, e, helper) {
        window.dataToTable = function (dataset, title) {
            var html = '<table>';
            html += '<thead><tr><th >' + title + '</th>';
            var columnCount = 0;
            jQuery.each(dataset.datasets, function (idx, item) {
                html += '<th style="background-color:' + item.fillColor + ';">' + item.label + '</th>';
                columnCount += 1;
            });
            html += '</tr></thead>';
            jQuery.each(dataset.labels, function (idx, item) {
                html += '<tr><td>' + item + '</td>';
                for (var i = 0; i < columnCount; i++) {
                    html += '<td style="background-color:' + dataset.datasets[i].fillColor
                        + ';">' + (dataset.datasets[i].data[idx] === '0' ? '-' : dataset.datasets[i].data[idx]) + '</td>';
                }
                html += '</tr>';
            });
            html += '</tr><tbody></table>';
            return html;
        };
        window.barOptions_stacked = {
            tooltips: {
                enabled: true,
                callbacks: {
                    afterLabel: function (tooltipItem, data) {
                        var ts = [];
                        ts = ([window.amm[tooltipItem.datasetIndex][tooltipItem.index]].toString()).split("ralm ");
                        return ts;
                    },
                }
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
                                ctx.fillText(data, bar._model.x - 20, bar._model.y - 15);
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
                    gridLines: { display: false },
                }],
                yAxes: [{
                    stacked: true,
                    gridLines: {
                        display: false
                    },
                }]
            },
        };

        //Get the context of the canvas element we want to select
        var action2 = component.get('c.fetchusdata');
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                var chartdrawn = false;
                var perfil = String(response.getReturnValue()).split(',')[0];
                var division = String(response.getReturnValue()).split(',')[1];
                var oficina = String(response.getReturnValue()).split(',')[2];
                var adm = $A.get("$Label.c.MX_PERFIL_SystemAdministrator");
                var dwpPerfil = "DWP Delegados";
                var dirdiv = "BPyP Director Divisional";
                var diroff = "BPyP Director Oficina";
                if (perfil === (dwpPerfil) || perfil === (adm)) {
                    component.set('v.isDiv', true);
                    component.set('v.isOff', true);
                    component.set('v.seldiv', division);
                    helper.updivi(component, e, helper);
                    chartdrawn = true;
                    component.set('v.seloff', oficina);
                    helper.updoffi(component, e, helper);
                } else if (perfil === dirdiv) {
                    component.set('v.isDiv', true);
                    component.set('v.seldiv', division);
                    helper.updivi(component, e, helper);
                    chartdrawn = true;
                } else if (perfil === diroff) {
                    component.set('v.isOff', true);
                    component.set('v.seldiv', division);
                    helper.updivi(component, e, helper);
                    chartdrawn = true;
                    component.set('v.seloff', oficina);
                    helper.updoffi(component, e, helper);
                }
                if (!chartdrawn)
                    helper.fetchdivdata(component, e);
            }
        });
        $A.enqueueAction(action2);
    },
    updDiv: function (component, e, helper) {
        component.set('v.isOpp', false);

        component.set('v.ListOfOpp', null);

        helper.updivi(component, e, helper);
    },
    updOffice: function (component, e, helper) {
        component.set('v.isOpp', false);

        component.set('v.ListOfOpp', null);
        helper.updoffi(component, e, helper);
    },
    updOpAc: function (component, e, helper) {
        component.set('v.isOpp', false);
        component.set('v.bandera', false);

        component.set('v.ListOfOpp', null);
        if (component.find("pklDivBpyP").get("v.value") === "") {
            component.find("pklOffBpyP").set("v.disabled", true);
            component.set('v.ListOfBkMn', null);
            component.find("pklBkMnBpyP").set("v.disabled", true);
            helper.fetchdivdata(component, e);
        }
        else if (component.find("pklOffBpyP").get("v.value") === "") {
            component.find("pklOffBpyP").set("v.disabled", false);
            component.set('v.ListOfBkMn', null);
            component.find("pklBkMnBpyP").set("v.disabled", true);
            helper.fetchoffdata(component, e);
        }
        else if (component.find("pklBkMnBpyP").get("v.value") === "") {
            component.find("pklBkMnBpyP").set("v.disabled", false);
            helper.fetchbkmdata(component, e);
        }
        else {
            helper.fetchbkmolydata(component, e);
            helper.fetchopps(component, e, helper);
        }
    },
    updBkM: function (component, e, helper) {
        component.set('v.ListOfOpp', null);
        helper.fetchbkmolydata(component, e);
        helper.fetchopps(component, e, helper);
    },
    frst: function (component) {
        //call apex class method
        var action = component.get('c.fetchOpp');
        action.setParams({
            bkMn: component.find("pklBkMnBpyP").get("v.value"),
            tyAcc: component.find("pklTyAccBpyP").get("v.value"),
            tyOpp: component.find("pklTyOppBpyP").get("v.value"),
            sDate: component.find("expsdate").get("v.value"),
            eDate: component.find("expedate").get("v.value"),
            off: '0'
        });

        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfAccount attribute on component.

                component.set('v.ListOfOpp', response.getReturnValue());
                component.set('v.ActPag', 1);
            }
        });
        $A.enqueueAction(action);
    },
    prev: function (component) {
        //call apex class method
        var action = component.get('c.fetchOpp');
        var actPg = component.get('v.ActPag');
        var prv = actPg === 1 ? 1 : actPg - 1;
        prv--;
        prv = prv * window.sizeofAcc;
        action.setParams({
            bkMn: component.find("pklBkMnBpyP").get("v.value"),
            tyAcc: component.find("pklTyAccBpyP").get("v.value"),
            tyOpp: component.find("pklTyOppBpyP").get("v.value"),
            sDate: component.find("expsdate").get("v.value"),
            eDate: component.find("expedate").get("v.value"),
            off: prv.toString()
        });

        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                prv = prv / window.sizeofAcc;
                //set response value in ListOfAccount attribute on component.
                if (component.find("pklBkMnBpyP").get("v.value") !== "") {
                    component.set('v.isOpp', true);
                }
                prv++;
                component.set('v.ListOfOpp', response.getReturnValue());
                component.set('v.ActPag', prv);
            }
        });
        $A.enqueueAction(action);
    },
    next: function (component) {
        //call apex class method
        var action = component.get('c.fetchOpp');
        var actPg = component.get('v.ActPag');
        var totPg = component.get('v.NumOfPag');
        var nxt = actPg === totPg ? totPg : actPg + 1;
        nxt--;
        nxt = nxt * window.sizeofAcc;
        action.setParams({
            bkMn: component.find("pklBkMnBpyP").get("v.value"),
            tyAcc: component.find("pklTyAccBpyP").get("v.value"),
            tyOpp: component.find("pklTyOppBpyP").get("v.value"),
            sDate: component.find("expsdate").get("v.value"),
            eDate: component.find("expedate").get("v.value"),
            off: nxt.toString()
        });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfAccount attribute on component.
                nxt = nxt / window.sizeofAcc;
                if (component.find("pklBkMnBpyP").get("v.value") !== "") {
                    component.set('v.isOpp', true);
                }
                nxt++;
                component.set('v.ListOfOpp', response.getReturnValue());
                component.set('v.ActPag', nxt);
            }
        });
        $A.enqueueAction(action);
    },
    lst: function (component) {
        //call apex class method
        var action = component.get('c.fetchOpp');
        var totPg = component.get('v.NumOfPag');
        totPg--;
        totPg = totPg * window.sizeofAcc;
        action.setParams({
            bkMn: component.find("pklBkMnBpyP").get("v.value"),
            tyAcc: component.find("pklTyAccBpyP").get("v.value"),
            tyOpp: component.find("pklTyOppBpyP").get("v.value"),
            sDate: component.find("expsdate").get("v.value"),
            eDate: component.find("expedate").get("v.value"),
            off: totPg.toString()
        });

        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                totPg = totPg / window.sizeofAcc;
                //set response value in ListOfAccount attribute on component.
                if (component.find("pklBkMnBpyP").get("v.value") !== "") {
                    component.set('v.isOpp', true);
                }
                totPg++;
                component.set('v.ListOfOpp', response.getReturnValue());
                component.set('v.ActPag', totPg);
            }
        });
        $A.enqueueAction(action);
    },
})
