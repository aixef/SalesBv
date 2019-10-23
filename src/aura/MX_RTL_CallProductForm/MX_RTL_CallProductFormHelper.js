({
    initialize: function(component, event, helper) {
        if(!component.get('v.recordId').isUndefinedOrNull){
            let promise =  helper.getProdConf(component, helper);
            promise.then(function() {
                let promise2 = helper.createComponent(component);
                promise2.then(function() {
                    helper.getOpp(component);
                });
            });
        }
	},
    getProdConf: function(cmp, helper) {
    	return new Promise(function(resolve, reject) {
            let action = cmp.get('c.getProdConf');
            action.setParams({oppId:cmp.get('v.recordId')});
            action.setCallback(this, function(response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    cmp.set('v.nProdConf', response.getReturnValue());
                    if(cmp.get('v.nProdConf')>0) {
                        cmp.set('v.editButton', '{"style":"neutral","unactiveStyle":"hidden","active":true}');
                    } else {
                        cmp.set('v.editButton', '{"style":"neutral","unactiveStyle":"hidden","active":false}');
                    }
                    resolve();
                }
            });
            $A.enqueueAction(action);
    	});
    },
    createComponent : function(cmp) {
     return new Promise(function(resolve, reject) {
        $A.createComponent(
                    "fprd:GBL_Opportunity_Products_cmp",
                    {
                        "aura:id": "productFormId",
                        "id": "htmlid",
                        "sObjectName": cmp.get('v.sObjectName'),
                        "recordId": cmp.get('v.recordId'),
                        "maxProductNumber": cmp.get('v.maxProductNumber'),
                        "maxDifferentProductNumber": cmp.get('v.maxDifferentProductNumber'),
                        "editButton": cmp.get('v.editButton'),
                        "cloneButton" : cmp.get('v.cloneButton'),
                        "deleteButton": cmp.get('v.deleteButton'),
                        "newButton": cmp.get('v.newButton'),
                        "compareButton": cmp.get('v.compareButton'),
                        "visibilityControlField": cmp.get('v.visibilityControlField'),
                        "visibilityControlValues": cmp.get('v.visibilityControlValues'),
                        "comparatorColumns": cmp.get('v.comparatorColumns'),
                        "comparatorFields": cmp.get('v.comparatorFields'),
                        "enableSharing": cmp.get('v.enableSharing'),
                        "onlyImportant": cmp.get('v.onlyImportant'),
                        "dynamicAttributes": cmp.get('v.dynamicAttributes'),
                        "disableRefresh": cmp.get('v.disableRefresh'),
                    },
                    function(productForm, status, errorMessage) {
                    	if (status === "SUCCESS") {
                            let body = cmp.get("v.ftProducForm");
                            body.push(productForm);
                            cmp.set("v.ftProducForm", body);
                            resolve();
                        }
                        else if (status === "INCOMPLETE") {
                            console.log("No response from server or client is offline.")
                            reject();
                        }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                            reject();
                        }
                    }
        );
     });

    },
    getOpp : function(cmp) {
        return new Promise(function(resolve, reject) {
        	let action = cmp.get('c.getOpp');
            action.setParams({oppId:cmp.get('v.recordId')});
            action.setCallback(this, function(response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    cmp.set('v.oppSel', response.getReturnValue());
                    if(cmp.get('v.nProdConf') === 0) {
                        let action2 = cmp.get('c.updCheckOpp');
                        action2.setParams({oppId:cmp.get('v.recordId')});
                        $A.enqueueAction(action2);
                    }
                	resolve();
                }
            });
            $A.enqueueAction(action);
        });
	},
	doAfterRender : function(component, helper){
    	helper.showModal(component, helper);
    },
    showModal : function(component, helper){
        let cont = 0;
    	let intervalId = window.setInterval (
        	$A.getCallback( function() {
                let checkPF = component.get('v.oppSel.MX_RTL_BanderaOpp__c'); //Si la Oportunidad es nueva
                let oppId = component.get('v.recordId');	//Id de la oportunidad
                let nProdCf = component.get('v.nProdConf'); //Si la OpportunityLineItem tiene campos que capturar
                if(component.get("v.ftProducForm").length > 0){
                    let cmpProdForm = component.get("v.ftProducForm")[0];	//componente product form
                    if(checkPF && (!oppId.isUndefinedOrNull) && nProdCf > 0 && cmpProdForm.get("v.allLoaded")){
                        let showModalevt = $A.get('e.fprd:GBL_ShowModal_evt');
                        showModalevt.fire();
                        component.set('v.truthy',cmpProdForm.get("v.allLoaded"));
                        if (showModalevt.getPhase()==='default') {
                            let action2 = component.get('c.updCheckOpp');
                            action2.setParams({oppId:component.get('v.recordId')});
                            $A.enqueueAction(action2);
                            clearInterval(intervalId);
                        }
                    } else if((!checkPF && cmpProdForm.get("v.allLoaded")) || (nProdCf === 0 && cmpProdForm.get("v.allLoaded"))) {
                        clearInterval(intervalId);
                        component.set('v.truthy',cmpProdForm.get("v.allLoaded"));
                    }
                }
                if(cont === 15) {
                    console.log("Error ");
                	clearInterval(intervalId);
                    helper.showWarn(component);
                }
                cont++;
    		}),1000
         );
	},
    showWarn: function(component) {
        component.set('v.error',true);
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
        	"title": "Alerta!",
            "message": $A.get("$Label.c.MX_RTL_ErrorLoadProductForm"),
            "mode": "sticky",
            "type": "warning"
        });
       	toastEvent.fire();
    }
})
