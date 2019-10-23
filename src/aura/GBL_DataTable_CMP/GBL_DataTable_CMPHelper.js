({
    doInitHelper: function(component,helper,event){
        var BVariable = component.get('v.BVariable');
        var showRecords = component.get('v.showRecords');
        var nameFunction = component.get('v.functionTable');
        var action = component.get('c.valuesHandler');
        if(!component.get("v.PyMEFlagProcess")){
            if(component.get('v.TamSolucion') === undefined){
                component.set('v.TamSolucion','Cobranza');
            }
            action.setStorable();
            action.setParams({
                functionRow: nameFunction,
                bVariable: BVariable,
                Solucion: component.get('v.TamSolucion'),
            });
            action.setCallback(this, function(response) {
                this.responseDoInitHelper(component, response, showRecords);
            });
            $A.enqueueAction(action);
        }else{
            var resp = component.get("v.listParentData");
            component.set('v.resultResponse', resp.gblResultResponse);
            if (resp.gblResultResponse) {
                component.set('v.nameColumn', resp.nameColumn);
                component.set('v.ltsData', resp.allData);
                component.set('v.pages', Math.ceil(resp.allData.length/showRecords));
                this.getElementsToShow( component, 0);
            }
        }
    },

    responseDoInitHelper: function(component, response, showRecords){
        var state = response.getState();
        var resp = response.getReturnValue();
        component.set('v.listParentData',resp);
        if (state === 'SUCCESS') {
            component.set('v.resultResponse', resp.gblResultResponse);
            if (resp.gblResultResponse) {
                component.set('v.nameColumn', resp.nameColumn);
                component.set('v.ltsData', resp.allData);
                component.set('v.pages', Math.ceil(resp.allData.length/showRecords));
                this.getElementsToShow( component, 0);
            } else {
                component.set('v.errorMessage', resp.gblDescriptionResponse);
            }
        } else if (state === 'INCOMPLETE' || state === 'ERROR') {
            var errorMesg = {
                'INCOMPLETE' : 'LLamada incompleta',
                'ERROR' : 'Error desconocido contacte a su administrador de sistema'};
            component.set('v.resultResponse', false);
            component.set('v.errorMessage', errorMesg[state]);
            var errors = response.getError();
            if (errors && errors[0] && errors[0].message) {
                component.set('v.errorMessage', errors[0].message);
            }
        }
    },

    getElementsToShow: function(component, num) {
        component.set('v.resultResponse', false);
        var pageVar = component.get('v.page') + num;
        component.set('v.page', pageVar);
        var allData = component.get('v.ltsData');
        var showRecords = component.get('v.showRecords');
        var elemMin = (pageVar * showRecords) - showRecords;
        var elemMax = elemMin + showRecords;
        var ltsTem =  new Array();
        for (var i = 0; i < allData.length; i++) {
            if( i >= elemMin && i < elemMax)
                ltsTem.push(allData[i]);
        }
        component.set('v.resultResponse', true);
        component.set('v.ltsTempData', ltsTem);
    },

    getElementsToShowCashManagement: function(component, num) {
        component.set('v.resultResponse', false);
        var page = component.get('v.page') + num;
        component.set('v.page', page);
        var allData = component.get('v.ltsData');
        var showRecords = component.get('v.showRecords');
        var elemMin = (page * showRecords) - showRecords;
        var elemMax = elemMin + showRecords;
        var ltsTem =  new Array();
        for (var i = 0; i < allData.length; i++) {
            if( i >= elemMin && i < elemMax)
                ltsTem.push(allData[i]);
        }
        component.set('v.ltsTempData', ltsTem);
        component.set('v.resultResponse', true);
    },

    doValidationRoleHelper:function (component,event,helper){
        var action = component.get("c.userRoleValidation");
        component.set('v.LoggedInF',true);
        action.setCallback(this,function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === 'SUCCESS') {
                component.set('v.PrefixRole',result);
                component.set('v.NivelMax',result);
                this.doInitStacks(component,event,helper,result);
            }else if (state === 'INCOMPLETE' || state === 'ERROR') {
                var errorMesg = {
                    'INCOMPLETE' : 'LLamada incompleta',
                    'ERROR' : 'Error desconocido contacte a su administrador de sistema'};
                component.set('v.resultResponse', false);
                component.set('v.errorMessage', errorMesg[state]);
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    component.set('v.errorMessage', errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    goNavigationHelper: function(component,event,helper){
        component.set('v.ValidStackTitle',true);
        var Temp=component.get("v.StackInit").pop();
        if((typeof Temp !== 'undefined' )){
            component.set('v.VTitle', event.getSource().get("v.label"));
            component.get('v.StackTitle').push(event.getSource().get("v.label"));
            component.set('v.PrefixRole',Temp);
            component.get("v.StackStorage").push(Temp);
            this.doInitHelper(component,event,helper);
        }
    },

    goNavigationBackHelper:function(component,event,helper){
        var Temp=component.get("v.StackStorage").pop();
        if(Temp !== component.get('v.NivelMax')){
            if(component.get('v.ValidStackTitle')){
                component.set('v.VTitle',component.get('v.StackTitle').pop());
            }
            component.set('v.VTitle',component.get('v.StackTitle').pop());
            if((typeof component.get('v.VTitle') === 'undefined' )){
                component.set('v.LoggedInF',true);
            }
            component.set('v.ValidStackTitle',false);
            component.get("v.StackInit").push(Temp);
            component.set('v.PrefixRole',component.get("v.StackStorage").pop());
            component.get("v.StackStorage").push(component.get('v.PrefixRole'));
            this.doInitHelper(component,event,helper);
        }else{
            component.get("v.StackStorage").push(Temp);
        }
    },
    doInitStacks: function(component,event,helper,result){
        var LoopStack = component.get('v.StackInit').length;
        var LoopStack2 = component.get('v.StackInit');
        var TempValue= '';
        var flag= true;
        for (var i = 0 ; i < LoopStack; i++ ){
            if(flag){
                TempValue=LoopStack2.pop();
                component.get("v.StackStorage").push(TempValue);
                if(TempValue === result){
                    flag=false;
                }
            }
        }
    },
    helpershowSpinner: function(component, event, helper) {
        component.set("v.Spinner", true);
    },
    helperhideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    },
    getProductsDetailHelper : function(component,event,helper){
        var clientId = component.get("v.BVariable");
        var action = component.get("c.callBalanceService");
        action.setParams({
            clientId:clientId,
            numContract:component.get("v.numContract")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {console.log("callBalanceService success");}
        });
        $A.enqueueAction(action);
    },
    setNumContract:function(component,event,helper){
        var target = event.getSource();
        var numContract=target.get("v.label");
        component.set('v.numContract',numContract);
        component.set('v.isActive',true);
    },
    ConstruyeComponent:function(component){
        var item = component.find("component2");
        $A.createComponent(
            "c:MX_PyME_MdalDataTable_Cmp",
            {
                "numContract":component.get("{!v.numContract}"),
                "isActive":component.get("{!v.isActive}")
            },
            function(cmp) {
                item.set("v.body", cmp);
            }
        );
    }
})
