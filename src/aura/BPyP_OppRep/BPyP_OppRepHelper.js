({
    fetchdivdata: function (component, e) {
        if (component.get("v.isOff")) {
            component.find("pklDivBpyP").set("v.disabled", true);
            component.find("pklOffBpyP").set("v.disabled", true);
        }
        if (component.get("v.isDiv")) {
            component.find("pklDivBpyP").set("v.disabled", true);
        }
        var ctx = component.find("myChart").getElement();

        //call apex class method
        var action = component.get('c.fetchDivData');
        action.setParams({
            tyAcc: component.find("pklTyAccBpyP").get("v.value"),
            tyOpp: component.find("pklTyOppBpyP").get("v.value"),
            sDate: component.find("expsdate").get("v.value"),
            eDate: component.find("expedate").get("v.value")
        });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();

                var height = 100 + (res.lsLabels.toString().split(',').length * 30);

                component.set('v.chartHeight', height);
                if (window.myChart != null) {
                    window.myChart.clear();
                    window.myChart.destroy();
                }
                window.myChart = new Chart(ctx, { type: 'horizontalBar', data: {}, options: window.barOptions_stacked });
                this.actionHelper(component, res, 'DIVISION');
            }
        });
        $A.enqueueAction(action);
        if (component.get("v.isOff")) {
            component.find("pklDivBpyP").set("v.disabled", true);
            component.find("pklOffBpyP").set("v.disabled", true);
        }
        if (component.get("v.isDiv")) { component.find("pklDivBpyP").set("v.disabled", true); }
    },
    updivi: function (component, e, helper) {
        //call apex class method
        if (!component.get('v.bandera')) {
            component.set('v.seloff', '');
        }
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
                    helper.fetchoffdata(component, e);
                }
                else {
                    component.find("pklOffBpyP").set("v.disabled", true);
                    component.set('v.ListOfBkMn', null);
                    component.find("pklBkMnBpyP").set("v.disabled", true);
                    helper.fetchdivdata(component, e);
                }
            }
        });
        $A.enqueueAction(action);
    },
    updoffi: function (component, e, helper) {
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
                    if (component.get('v.bandera')) {
                        component.find("pklOffBpyP").set("v.disabled", true);
                    }
                    helper.fetchbkmdata(component, e);
                }
                else {
                    component.find("pklBkMnBpyP").set("v.disabled", true);
                    helper.fetchoffdata(component, e);
                }
            }
        });
        $A.enqueueAction(action);
    },
    fetchoffdata: function (component, e) {
        if (component.get("v.isOff")) {
            component.find("pklDivBpyP").set("v.disabled", true);
            component.find("pklOffBpyP").set("v.disabled", true);
        }
        if (component.get("v.isDiv")) { component.find("pklDivBpyP").set("v.disabled", true); }
        var ctx2 = component.find("myChart").getElement();
        //call apex class method
        var action2 = component.get('c.fetchOffData');
        action2.setParams({
            div: component.find("pklDivBpyP").get("v.value"),
            tyAcc: component.find("pklTyAccBpyP").get("v.value"),
            tyOpp: component.find("pklTyOppBpyP").get("v.value"),
            sDate: component.find("expsdate").get("v.value"),
            eDate: component.find("expedate").get("v.value")
        });
        action2.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();

                var height = 100 + (res.lsLabels.toString().split(',').length * 30);

                component.set('v.chartHeight', height);
                if (window.myChart != null) {
                    window.myChart.clear();
                    window.myChart.destroy();
                }
                window.myChart = new Chart(ctx2, { type: 'horizontalBar', data: {}, options: window.barOptions_stacked });

                this.actionHelper(component, res, 'OFICINA');

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
    fetchbkmdata: function (component, e) {
        if (component.get("v.isOff")) {
            component.find("pklDivBpyP").set("v.disabled", true);
            component.find("pklOffBpyP").set("v.disabled", true);
        }
        if (component.get("v.isDiv")) {
            component.find("pklDivBpyP").set("v.disabled", true);
        }
        var ctx3 = component.find("myChart").getElement();
        //call apex class method
        var action3 = component.get('c.fetchBkMData');
        if (!component.get('v.bandera')) {
            action3.setParams({
                office: component.find("pklOffBpyP").get("v.value"),
                div: component.find("pklDivBpyP").get("v.value"),
                bkMn: '',
                tyAcc: component.find("pklTyAccBpyP").get("v.value"),
                tyOpp: component.find("pklTyOppBpyP").get("v.value"),
                sDate: component.find("expsdate").get("v.value"),
                eDate: component.find("expedate").get("v.value")
            });
        } else {
            action3.setParams({
                office: component.find("pklOffBpyP").get("v.value"),
                div: component.find("pklDivBpyP").get("v.value"),
                bkMn: component.get("v.selbkm"),
                tyAcc: component.find("pklTyAccBpyP").get("v.value"),
                tyOpp: component.find("pklTyOppBpyP").get("v.value"),
                sDate: component.find("expsdate").get("v.value"),
                eDate: component.find("expedate").get("v.value")
            });
        }
        action3.setCallback(this, function (response) {
            this.helperActions(component, response, ctx3, 1);
        });
        $A.enqueueAction(action3);
        this.helperIfs(component);
    },
    fetchbkmolydata: function (component, e) {
        if (component.get("v.isOff")) {
            component.find("pklDivBpyP").set("v.disabled", true);
            component.find("pklOffBpyP").set("v.disabled", true);
        }
        if (component.get("v.isDiv")) {
            component.find("pklDivBpyP").set("v.disabled", true);
        }
        var ctx4 = component.find("myChart").getElement();
        // window.myChart = new Chart(ctx, { type: 'horizontalBar', data: { }, options: window.barOptions_stacked });
        //call apex class method
        var action4 = component.get('c.fetchBkMData');
        action4.setParams({
            office: component.find("pklOffBpyP").get("v.value"),
            div: component.find("pklDivBpyP").get("v.value"),
            bkMn: component.find("pklBkMnBpyP").get("v.value"),
            tyAcc: component.find("pklTyAccBpyP").get("v.value"),
            tyOpp: component.find("pklTyOppBpyP").get("v.value"),
            sDate: component.find("expsdate").get("v.value"),
            eDate: component.find("expedate").get("v.value")
        });
        action4.setCallback(this, function (response) {
            this.helperActions(component, response, ctx4, 2);
        });
        $A.enqueueAction(action4);
        this.helperIfs(component);
    },
    helperActions: function (component, response, ctx, actType) {
        //store state of response
        var state = response.getState();
        if (state === "SUCCESS") {
            var res = response.getReturnValue();
            if (actType === 1 && component.get('v.bandera')) {
                component.find("pklBkMnBpyP").set("v.value", component.get("v.selbkm"));
                component.find("pklBkMnBpyP").set("v.disabled", true);
            }
            var height = 100 + (res.lsLabels.toString().split(',').length * 30);
            component.set('v.chartHeight', height);
            if (window.myChart != null) {
                window.myChart.clear();
                window.myChart.destroy();
            }
            window.myChart = new Chart(ctx, { type: 'horizontalBar', data: {}, options: window.barOptions_stacked });

            this.actionHelper(component, res, 'BANQUERO');

        }
    },
    helperIfs: function (component) {
        if (component.get("v.isOff")) {
            component.find("pklDivBpyP").set("v.disabled", true);
            component.find("pklOffBpyP").set("v.disabled", true);
        }
        if (component.get("v.isDiv")) {
            component.find("pklDivBpyP").set("v.disabled", true);
        }
    },
    fetchopps: function (component, e, helper) {
        var action5 = component.get('c.fetchOpp');
        action5.setParams({
            bkMn: component.find("pklBkMnBpyP").get("v.value"),
            tyAcc: component.find("pklTyAccBpyP").get("v.value"),
            tyOpp: component.find("pklTyOppBpyP").get("v.value"),
            sDate: component.find("expsdate").get("v.value"),
            eDate: component.find("expedate").get("v.value"), off: '0'
        });
        action5.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfOpp attribute on component.
                if (component.find("pklBkMnBpyP").get("v.value") !== "") {
                    component.set('v.isOpp', true);
                }
                else {
                    component.set('v.isOpp', false);
                    helper.updoffi(component, e, helper);
                }
                component.set('v.ListOfOpp', response.getReturnValue());
            }
        });
        $A.enqueueAction(action5);
        var action6 = component.get('c.fetchPgs');
        action6.setParams({
            bkMn: component.find("pklBkMnBpyP").get("v.value"),
            tyAcc: component.find("pklTyAccBpyP").get("v.value"),
            tyOpp: component.find("pklTyOppBpyP").get("v.value"),
            sDate: component.find("expsdate").get("v.value"),
            eDate: component.find("expedate").get("v.value")
        });
        action6.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfAccount attribute on component.
                component.set('v.NumOfPag', response.getReturnValue());
                component.set('v.ActPag', 1);
                window.sizeofAcc = 10;
            }
        });
        $A.enqueueAction(action6);
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
    actionHelper: function (component, res, types) {
        var labels = [];
        for (var i = res.lsLabels.toString().split(',').length - 1; i >= 0; i--) {
            myChart.config.data.labels.push(res.lsLabels.toString().split(',')[i]);
            labels.push(res.lsLabels.toString().split(',')[i]);
        }
        window.amm = [];
        for (var j = res.lsTyOpp.toString().split(',').length - 1; j >= 0; j--) {
            var datatemp = [];
            var dataamm = [];
            for (var k = 0; k < labels.length; k++) {
                datatemp.push(res.lsData[(res.lsTyOpp.toString().split(',')[j] + labels[k])] == null ? 0 : res.lsData[(res.lsTyOpp.toString().split(',')[j] + labels[k])]);
                dataamm.push(res.lsTool[(res.lsTyOpp.toString().split(',')[j] + labels[k])] == null ? '' : res.lsTool[(res.lsTyOpp.toString().split(',')[j] + labels[k])]);
            }
            window.amm.push(dataamm);

            var newDataset = { label: res.lsTyOpp.toString().split(',')[j], backgroundColor: res.lsColor.toString().split('),')[j] + ')', data: datatemp, }
            myChart.data.datasets.push(newDataset);
        }
        myChart.update();
        component.set('v.DateOfUpd', new Date().getDate() + '-' + (new Date().getMonth() + 1) + '-' + new Date().getFullYear());
        jQuery('#wrapperOpp').html(window.dataToTable(myChart.data, types));
    }
})
