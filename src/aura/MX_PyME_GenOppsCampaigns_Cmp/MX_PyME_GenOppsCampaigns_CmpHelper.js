({
    helperInit : function(component,event,helper) {
        this.helperAccCampaign(component,event,helper);
        this.helperGetProducts(component,event,helper);
    },
    helperSelectProduct: function(component,event,helper) {
        var action = component.get("c.relatedRecordType");
        var createRecordEvent = $A.get("e.force:createRecord");
        var idProduct2 = component.get("v.MapIds").get(component.get("v.selectedValue"));
        var product2 = component.get("v.mapProd2").get(idProduct2);
        action.setParams({
            "idProduct2" : idProduct2,
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            var respuesta = response.getReturnValue();
            if (state === "SUCCESS" && respuesta !== '' && respuesta !== null && product2 !== '' && product2 !== null ) {
                createRecordEvent.setParams({
                    "entityApiName": "Opportunity",
                    "recordTypeId":respuesta,
                    "defaultFieldValues": {
                        'AccountId' : component.get("v.AccCampaign").cond__participant_id__c,
                        'cond__participant_campaign_id__c' : component.get("v.AccCampaign").Id,
                        'MX_RTL_Familia__c' : product2.Family,
                    }
                });
                createRecordEvent.fire();
            }
        }); $A.enqueueAction(action);
    },
    helperGetProducts : function(component,event,helper) {
        var recordid = component.get("v.recordId");
        var action = component.get("c.getProductCampaign");
        action.setParams({
            "idCampaign": recordid,
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            var respuesta = response.getReturnValue();
            if (state === "SUCCESS" && respuesta !== '' && respuesta !== null && respuesta.length > 0) {
                var prodlist= new Map();
                var mapProd2 = new Map();
                var i = 0;
                component.set("v.Products",respuesta);
                for(i ; i < respuesta.length ; i++ ) {
                    prodlist.set(respuesta[i].ProductCode, respuesta[i].Id);
                    mapProd2.set(respuesta[i].Id, respuesta[i]);
                }
            }
            component.set("v.MapIds",prodlist);
            component.set("v.mapProd2",mapProd2);
        }); $A.enqueueAction(action);
    },

    helperAccCampaign : function(component,event,helper) {
        var recordid = component.get("v.recordId");
        var action = component.get("c.getAccountCampaignFields");
        action.setParams({
            "idCampaign": recordid,
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            var respuesta = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.AccCampaign",respuesta);
            }
        }); $A.enqueueAction(action);
    }
})
