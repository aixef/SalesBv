/*
*Proyecto:               Banca Patrimonial y Privada
*Descripción:
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0	| 		N/A	     |	   N/A					|	  	Creación
*1.1    |   28/06/2019   |  Hugo I. Carrillo B.     |       Correcciones de Code Smell identificados por Sonar
*/
({
    initdraw: function (component, e, helper) {
        var action2 = component.get('c.fetchusdata');
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.helperSetProfile(component, e, helper, response);
            }
        });
        $A.enqueueAction(action2);
    },
    helperSetProfile: function (component, e, helper, response) {
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
        }
        if (title === 'PATRIMONIAL') {
            title = 'Pa';
        }
        if (title === 'PATRIMONIAL SR') {
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
        }
        else if (perfil === bpypestandar) {
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
        else if (perfil === dirdiv) {
            component.set('v.isDiv', true);
            component.set('v.seldiv', division);
            helper.fetchoff(component, e, helper);
            chartdrawn = true;
        }
        else if (perfil === diroff) {
            component.set('v.isOff', true);
            component.set('v.seldiv', division);
            helper.fetchoff(component, e, helper);
            chartdrawn = true;
            component.set('v.seloff', oficina);
            helper.fetchbkm(component, e, helper);
        }
        if (!chartdrawn) {
            helper.drawdiv(component, e);
        }
    },
    helperSetDisabled: function (component) {
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
    helperLabels: function (res) {
        var labels = [];
        for (var i = res.lsLabels.toString().split(',').length - 1; i >= 0; i--) {
            myChartt2.config.data.labels.push(res.lsLabels.toString().split(',')[i]);
            labels.push(res.lsLabels.toString().split(',')[i]);
        }

        for (var j = res.lsTyOpp.toString().split(',').length - 1; j >= 0; j--) {
            var datatemp = [];

            for (var k = 0; k < labels.length; k++) {
                datatemp.push(res.lsData[(res.lsTyOpp.toString().split(',')[j] + labels[k])] == null ? 0 : res.lsData[(res.lsTyOpp.toString().split(',')[j] + labels[k])]);
            }

            var newDataset = { label: res.lsTyOpp.toString().split(',')[j], backgroundColor: res.lsColor.toString().split('),')[j] + ')', data: datatemp, }
            myChartt2.data.datasets.push(newDataset);
        }
        myChartt2.update();
    },
    drawdiv: function (component, e) {
        component.find("pklDivBpyP").set("v.disabled", false);
        component.find("pklBkMnBpyP").set("v.disabled", true);
        component.find("pklOffBpyP").set("v.disabled", true);

        this.helperSetDisabled(component);
        //Get the context of the canvas element we want to select
        var ctx2 = component.find("myChartt2").getElement();
        //call apex class method
        var action2 = component.get('c.fetchDivChanData');
        action2.setParams({
            type: component.find("pklTyAccBpyP").get("v.value"),
            sD: component.find("expsdate").get("v.value"),
            eD: component.find("expedate").get("v.value"),
        });
        action2.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var height = 100 + (res.lsLabels.toString().split(',').length * 30);
                component.set('v.chart2Height', height);
                if (window.myChartt2 != null) {
                    window.myChartt2.clear();
                    window.myChartt2.destroy();
                }
                window.myChartt2 = new Chart(ctx2, {
                    type: 'horizontalBar',
                    data: {},
                    options: window.barOptions_stacked
                });
                this.helperLabels(res);
            }
        });
        $A.enqueueAction(action2);
        this.helperSetDisabled(component);
    },
    drawoff: function (component, e) {
        component.find("pklBkMnBpyP").set("v.disabled", true);
        component.find("pklOffBpyP").set("v.disabled", false);

        this.helperSetDisabled(component);
        //Get the context of the canvas element we want to select
        var ctx4 = component.find("myChartt2").getElement();
        //call apex class method
        var action4 = component.get('c.fetchOffChanData');
        action4.setParams({
            type: component.find("pklTyAccBpyP").get("v.value"),
            div: component.find("pklDivBpyP").get("v.value"),
            sD: component.find("expsdate").get("v.value"),
            eD: component.find("expedate").get("v.value"),
        });

        action4.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var height = 100 + (res.lsLabels.toString().split(',').length * 30);
                component.set('v.chart2Height', height);
                if (window.myChartt2 != null) {
                    window.myChartt2.clear();
                    window.myChartt2.destroy();
                }
                window.myChartt2 = new Chart(ctx4, {
                    type: 'horizontalBar',
                    data: {},
                    options: window.barOptions_stacked
                });
                this.helperLabels(res);
            }
        });
        $A.enqueueAction(action4);
        this.helperSetDisabled(component);
    },
    drawbkm: function (component, e) {
        component.find("pklBkMnBpyP").set("v.disabled", false);

        this.helperSetDisabled(component);
        //Get the context of the canvas element we want to select
        var ctx6 = component.find("myChartt2").getElement();
        //call apex class method
        var action6 = component.get('c.fetchBkMChanData');
        action6.setParams({
            type: component.find("pklTyAccBpyP").get("v.value"),
            div: component.find("pklDivBpyP").get("v.value"),
            off: component.find("pklOffBpyP").get("v.value"),
            sD: component.find("expsdate").get("v.value"),
            eD: component.find("expedate").get("v.value"),
        });

        action6.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var height = 100 + (res.lsLabels.toString().split(',').length * 30);
                component.set('v.chart2Height', height);
                if (window.myChartt2 != null) {
                    window.myChartt2.clear();
                    window.myChartt2.destroy();
                }
                window.myChartt2 = new Chart(ctx6, {
                    type: 'horizontalBar',
                    data: {},
                    options: window.barOptions_stacked
                });
                this.helperLabels(res);
            }
        });
        $A.enqueueAction(action6);
        this.helperSetDisabled(component);
    },
    drawbkmo: function (component, e) {
        this.helperSetDisabled(component);
        if (window.redraw === false) { return; }
        //Get the context of the canvas element we want to select
        var ctx8 = component.find("myChartt2").getElement();
        //call apex class method
        var action8 = component.get('c.fetchBkMOnlyChanData');
        action8.setParams({
            type: component.find("pklTyAccBpyP").get("v.value"),
            bkM: component.find("pklBkMnBpyP").get("v.value"),
            sD: component.find("expsdate").get("v.value"),
            eD: component.find("expedate").get("v.value"),
        });
        action8.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var height = 100 + (res.lsLabels.toString().split(',').length * 30);
                component.set('v.chart2Height', height);
                if (window.myChartt2 != null) {
                    window.myChartt2.clear();
                    window.myChartt2.destroy();
                }
                window.myChartt2 = new Chart(ctx8, { type: 'horizontalBar', data: {}, options: window.barOptions_stacked });
                this.helperLabels(res);
            }
        });
        $A.enqueueAction(action8);
        this.helperSetDisabled(component);
    },
    resetdates: function (component, e) {
        var stdt = component.find("expsdate").get("v.value");
        var eddt = component.find("expedate").get("v.value");
        if (!((String(e.getSource()).includes("expedate")) || (String(e.getSource()).includes("expsdate"))) && (stdt == null || stdt === '' || eddt == null || eddt === '')) {
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
        component.set('v.selbkm', '');
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
        component.set('v.selbkm', '');
        var divsel = component.find("pklDivBpyP").get("v.value");
        var offsel = component.find("pklOffBpyP").get("v.value");
        // alert(divsel); alert(offsel);
        //call apex class method
        var action = component.get('c.fetchBankMan');
        action.setParams({
            div: divsel,
            office: offsel
        });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.ListOfBkMn', response.getReturnValue());
                if (response.getReturnValue() != null) {
                    component.find("pklBkMnBpyP").set("v.disabled", false);
                    helper.drawbkm(component, e);
                }
                else {
                    component.find("pklBkMnBpyP").set("v.disabled", true);
                    helper.drawoff(component, e);
                }
            }
        });
        $A.enqueueAction(action);
    },
    helperGenerateChart: function (component, e, helper) {
        window.barOptions_stacked = {
            tooltips: {
                enabled: true,
                position: 'nearest',
            },
            legend: {
                position: 'bottom',
                padding: 10,
                onClick: function (event, legendItem) { },
            },
            hover: {
                animationDuration: 10
            },
            responsive: true,
            maintainAspectRatio: false,
            scales: {
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
                    helper.helperOnComplete(this, "uno");
                }
            },
        };
        window.barOptions_stacked_perc = {
            tooltips: {
                enabled: true,
                position: 'nearest',
                callbacks: {
                    label: function (tooltipItem, data) {
                        return data.datasets[tooltipItem.datasetIndex].label + ': ' + window.val[tooltipItem.datasetIndex][tooltipItem.index] +
                            ' (' + tooltipItem.xLabel.toString() + '%)';
                    },
                }
            },
            legend: {
                position: 'bottom',
                padding: 10,
                onClick: function (event, legendItem) { },
            },
            hover: {
                animationDuration: 10
            },
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                xAxes: [{
                    scaleLabel: {
                        display: false
                    },
                    gridLines: {
                        display: false
                    },
                    stacked: true,
                    ticks: {
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
                    helper.helperOnComplete(this, "dos");
                }
            },
        };
        window.redraw = true;
        helper.initdraw(component, e, helper);
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
                if (data !== 0 && tipo === "uno") {
                    ctx.fillText(data, bar._model.x - 20, bar._model.y - 10);
                } else if (data !== 0 && tipo === "dos") {
                    ctx.fillText(data + '%', bar._model.x - 40, bar._model.y - 10);
                }
            }), this)
        }), fun);
    }
})
