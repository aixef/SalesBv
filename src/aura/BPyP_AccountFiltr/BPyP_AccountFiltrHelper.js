/*
*Proyecto:               Banca Patrimonial y Privada
*Descripción:
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0	| 		N/A	     |	   N/A					|	  	Creación
*1.1    |   02/07/2019   |  Hugo I. Carrillo B.     |       Correcciones de Code Smell identificados por Sonar
*/
({
    piediv: function (component, e) {
        if (component.get("v.isOff")) {
            component.find("pklDivBpyP").set("v.disabled", true);
            component.find("pklOffBpyP").set("v.disabled", true);
        }
        if (component.get("v.isDiv")) {
            component.find("pklDivBpyP").set("v.disabled", true);
        }
        //Get the context of the canvas element we want to select
        var ctx = component.find("piechart").getElement();
        var chartdata = {
            labels: [],
            datasets: [{
                data: [],
                backgroundColor: [],
            }]
        }
        if (window.pieChart != null) {
            window.pieChart.clear();
            window.pieChart.destroy();
        }
        window.pieChart = new Chart(ctx, {
            type: 'pie',
            data: chartdata,
            options: window.optPie
        });
        //call apex class method
        var action = component.get('c.fetchDivData');
        action.setParams({
            type: component.find("pklTyInfBpyP").get("v.value")
        });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                this.helpersetResponseValue(component, response, ctx, 'DIVISION');
            }
        });
        $A.enqueueAction(action);
        if (component.get("v.isOff")) {
            component.find("pklDivBpyP").set("v.disabled", true);
            component.find("pklOffBpyP").set("v.disabled", true);
        }
        if (component.get("v.isDiv")) {
            component.find("pklDivBpyP").set("v.disabled", true);
        }
    },
    updivi: function (component, e, helper) {
        //call apex class method
        // alert(component.find("pklDivBpyP").get("v.value"));
        var action = component.get('c.fetchOff');
        component.set('v.seloff', '');
        action.setParams({
            div: component.find("pklDivBpyP").get("v.value")
        });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfAccount attribute on component.
                component.set('v.ListOfOff', response.getReturnValue());
                if (response.getReturnValue() != null) {
                    component.find("pklOffBpyP").set("v.disabled", false);
                    component.set('v.ListOfBkMn', null);
                    component.find("pklBkMnBpyP").set("v.disabled", true);
                    helper.pieoff(component, e);

                }
                else {
                    component.find("pklOffBpyP").set("v.disabled", true);
                    component.set('v.ListOfBkMn', null);
                    component.find("pklBkMnBpyP").set("v.disabled", true);
                    helper.piediv(component, e);
                }
            }
        });
        $A.enqueueAction(action);
    },
    updoffi: function (component, e, helper) {
        var divsel = component.find("pklDivBpyP").get("v.value");
        var offsel = component.find("pklOffBpyP").get("v.value");
        // alert('updoffi'); alert(divsel); alert(offsel);
        //call apex class method
        var action = component.get('c.fetchBankMan');
        action.setParams({ div: divsel, office: offsel });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfAccount attribute on component.
                component.set('v.ListOfBkMn', response.getReturnValue());
                if (response.getReturnValue() != null) {
                    component.find("pklBkMnBpyP").set("v.disabled", false);
                    helper.piebkm(component, e, '');
                }
                else {
                    component.find("pklBkMnBpyP").set("v.disabled", true);
                    helper.pieoff(component, e);
                }
            }
        });
        $A.enqueueAction(action);
    },
    pieoff: function (component, e) {
        if (component.get("v.isOff")) {
            component.find("pklDivBpyP").set("v.disabled", true);
            component.find("pklOffBpyP").set("v.disabled", true);
        }
        if (component.get("v.isDiv")) {
            component.find("pklDivBpyP").set("v.disabled", true);
        }
        //Get the context of the canvas element we want to select
        var ctx = component.find("piechart").getElement();
        //call apex class method
        var action2 = component.get('c.fetchOffData');
        action2.setParams({
            divi: component.find("pklDivBpyP").get("v.value"),
            type: component.find("pklTyInfBpyP").get("v.value")
        });
        action2.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                this.helpersetResponseValue(component, response, ctx, 'OFICINA');
            }
        });
        $A.enqueueAction(action2);
        if (component.get("v.isOff")) {
            component.find("pklDivBpyP").set("v.disabled", true);
            component.find("pklOffBpyP").set("v.disabled", true);
        }
        if (component.get("v.isDiv")) {
            component.find("pklDivBpyP").set("v.disabled", true);
        }
    },
    helpersetResponseValue: function (component, response, ctx, type) {
        //set response value in ListOfAccount attribute on component.
        var res = response.getReturnValue();
        var height = 100 + (res.lsLabels.toString().split(',').length * 30);
        component.set('v.chartHeight', height);
        if (window.pieChart != null) {
            window.pieChart.clear();
            window.pieChart.destroy();
        }
        window.pieChart = new Chart(ctx, {
            type: 'horizontalBar',
            data: {},
            options: window.optPie
        });

        var labels = [];
        for (var i = res.lsLabels.toString().split(',').length - 1; i >= 0; i--) {
            pieChart.config.data.labels.push(res.lsLabels.toString().split(',')[i]);
            labels.push(res.lsLabels.toString().split(',')[i]);
        }
        for (var j = res.lsTyAcc.toString().split(',').length - 1; j >= 0; j--) {
            var datatemp = [];
            var acc = res.lsTyAcc.toString().split(',')[j].replace(' BPyP', '');
            var accor = res.lsTyAcc.toString().split(',')[j];
            for (var k = 0; k < labels.length; k++) {
                datatemp.push(res.lsData[(labels[k] + accor)] == null ? 0 : res.lsData[(labels[k] + accor)]);
            }
            var newDataset = {
                label: acc,
                backgroundColor: res.lscolor.toString().split('),')[j] + ')',
                data: datatemp,
            }
            pieChart.data.datasets.push(newDataset);
        }
        pieChart.update();
        jQuery('#wrapperAcc').html(window.dataToTableAcc(pieChart.data, type));
        component.set('v.DateOfUpd', new Date().getDate() + '-' + (new Date().getMonth() + 1) + '-' + new Date().getFullYear());
    },
    piebkm: function (component, e, bk) {
        if (component.get("v.isOff")) {
            component.find("pklDivBpyP").set("v.disabled", true);
            component.find("pklOffBpyP").set("v.disabled", true);
        }
        if (component.get("v.isDiv")) {
            component.find("pklDivBpyP").set("v.disabled", true);
        }
        //Get the context of the canvas element we want to select
        var ctx = component.find("piechart").getElement();
        //call apex class method
        var action3 = component.get('c.fetchBkMData');
        var banquero = '';
        if(bk === "bmkoly"){
            banquero = component.find("pklBkMnBpyP").get("v.value");
        }
        action3.setParams({
            divi: component.find("pklDivBpyP").get("v.value"),
            office: component.find("pklOffBpyP").get("v.value"),
            bkm: banquero,
            type: component.find("pklTyInfBpyP").get("v.value")
        });
        action3.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                this.helpersetResponseValue(component, response, ctx, 'BANQUERO');
            }
        });
        $A.enqueueAction(action3);
        if (component.get("v.isOff")) {
            component.find("pklDivBpyP").set("v.disabled", true);
            component.find("pklOffBpyP").set("v.disabled", true);
        }
        if (component.get("v.isDiv")) {
            component.find("pklDivBpyP").set("v.disabled", true);
        }
    },
    fetchacc: function (component, e, helper) {
        //call apex class method
        var action = component.get('c.fetchAcc');
        component.set('v.DateOfUpd', new Date().getDate() + '-' + (new Date().getMonth() + 1) + '-' + new Date().getFullYear());
        action.setParams({ BkMn: component.find("pklBkMnBpyP").get("v.value"), type: component.find("pklTyInfBpyP").get("v.value"), off: '0' });
        window.sizeofAcc = 10;
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfAccount attribute on component.
                if (component.find("pklBkMnBpyP").get("v.value") !== "") {
                    component.set('v.isCln', true);
                }
                else {
                    component.set('v.isCln', false);
                    helper.updoffi(component, e, helper);
                }
                component.set('v.ListOfAccount', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        var action2 = component.get('c.fetchPgs');
        action2.setParams({ BkMn: component.find("pklBkMnBpyP").get("v.value"), type: component.find("pklTyInfBpyP").get("v.value") });
        action2.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfAccount attribute on component.
                component.set('v.NumOfPag', response.getReturnValue());
                component.set('v.ActPag', 1);
            }
        });
        $A.enqueueAction(action2);
        var action7 = component.get('c.fetchbaseurl');
        action7.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfAccount attribute on component.
                component.set('v.baseurl', response.getReturnValue());
            }
        });
        $A.enqueueAction(action7);
    },
})
