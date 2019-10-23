({
    getObjetions : function(component, event, helper) {
        let recordIVal = component.get('v.genericRecord');
        let recordId = recordIVal.Id.substring(0,3);
        let sObjectType = '';
        let product = '';
        var isLead = false;
        switch (recordId) {
            case '00Q':
                sObjectType = 'Lead';
                product = recordIVal.Producto_Interes__c;
                isLead = true;
                component.set('v.typeObject','Lead');
                break;
            case '006':
                sObjectType = 'Opportunity';
                product = recordIVal.Producto__c;
                component.set('v.typeObject','Opportunity');
                break;
            default:
                helper.manageErrors(component, event, helper, $A.get("{!$Label.c.MX_SB_VTS_ModuloNoDisponible}"), $A.get("{!$Label.c.MX_SB_VTS_ModuloNoDisponibleDet}"));
                break;
        }
        if($A.util.isEmpty(sObjectType) === false) {
            helper.getObjetionsCall(component, event, helper, product, isLead);
        }
    },
    getObjetionsCall : function(component, event, helper, product, isLead) {
        let objetionsCall = component.get("c.getObjetions");
        objetionsCall.setParams({"recordId": component.get('v.recordId'),"product": product, "isLead": isLead});
        objetionsCall.setCallback( this, function(response) {
            var state = response.getState();
            if ( state === 'SUCCESS' ) {
                var responseCall = response.getReturnValue();
                component.set('v.listaTextos', responseCall.lstObjects);
                component.set('v.activeCall', responseCall.activeCall);
                component.set('v.isLoading', false);
            } else {
                helper.manageErrors(component, event, helper, $A.get("{!$Label.c.MX_SB_VTS_errorGetRecords}"), $A.get("{!$Label.c.MX_SB_VTS_errorGetObjetions}"));
            }
        });
        $A.enqueueAction( objetionsCall );
    },
    manageErrors : function(component, event, helper, title, message) {
        component.set('v.errorMsj', message);
        component.set('v.errorMsjTitle', title);
        component.set('v.isLoading', false);
        helper.showToast(component, event, helper, 'error');
    },
    showToast : function(component, event, helper, type) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": component.get('v.errorMsjTitle'),
            "message": component.get('v.errorMsj'),
            "type": type,
            "mode": "pester",
            "duration": "2000"
        });
        toastEvent.fire();
    },
    saveObjectCall : function(component, event, helper) {
        let detailObjects = component.get('v.listaTextos');
        var lstRegObjec = [];
        let typeObject = component.get('v.typeObject');
        let recordId = component.get('v.recordId');
        let countSelect = 0;
        let countControl = 0;
        let activeCall = component.get('v.activeCall');
        detailObjects.forEach(catObject => {
            countControl +=1;
            if(catObject.usoObjecion || catObject.noUsoCatObject) {
                let regObjec = {};
                if(typeObject === 'Lead') {
                    regObjec.MX_SB_VTS_LeadLook__c = recordId;
                    regObjec.MX_SB_VTS_TipoObjecion__c = 'Objeciones';
                } else {
                    regObjec.MX_SB_VTS_ObjecionOpp__c = recordId;
                    regObjec.MX_SB_VTS_TipoObjecion__c = 'Objeciones Reales';
                }
                if($A.util.isEmpty(catObject.regObjec) === false) {
                    regObjec.Id = catObject.regObjec;
                }
                if($A.util.isEmpty(activeCall) === false) {
                    regObjec.MX_SB_VTS_LookActivity__c = activeCall;
                }
                regObjec.MX_SB_VTS_CatObjecion__c = catObject.catObject;
                regObjec.MX_SB_VTS_ObjecionUtil__c = catObject.usoObjecion;
                regObjec.MX_SB_VTS_NoUsoObjecion__c = catObject.noUsoCatObject;
                countSelect = countSelect+1;
                lstRegObjec.push(regObjec);
            }
        });
        if(countSelect > 0 && detailObjects.length === countControl) {
            helper.sendRecords(component, event, helper, lstRegObjec);
        }
    },
    sendRecords : function(component, event, helper, lstRegObjec) {
        var saveObjec = component.get('c.saveObjectionscls');
        let recorToUp = {};
        recorToUp.Id = component.get('v.recordId');
        recorToUp.MX_SB_VTS_UsoObjeciones__c = true;
        saveObjec.setParams({"objeciones": lstRegObjec});
        component.set('v.isLoading', true);
        saveObjec.setCallback(this, function (response){
            var state = response.getState();
            if ( state === 'SUCCESS' ) {
                component.set('v.isObjecSave', false);
            } else {
                helper.manageErrors(component, event, helper, $A.get("{!$Label.c.MX_SB_VTS_ObjecionError}"), $A.get("{!$Label.c.MX_SB_VTS_ObjecionErrorDet}"));
            }
            component.set('v.isLoading', false);
            $A.get("e.force:refreshView").fire();
        });
        $A.enqueueAction( saveObjec );
    },
})
