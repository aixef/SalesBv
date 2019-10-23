({
    navigate : function(component, event, helper) {
        let cmpRecord = component.get("v.simpleRecord.MX_SB_MLT_External_Id__c");
        let action = component.get("c.usuarioId");
        let staticLabel = component.get("v.urlClaimLbl");
        helper.idFederation(component, action).then(
            function(res) {
                let naVLightning = component.find('navigate');
                let fedId = component.get('v.idFed');
                let pageReference = {
                    type: "standard__webPage",
                    attributes: {
                        url: staticLabel+cmpRecord+"&idAgent="+fedId
                    }
                };
                naVLightning.navigate(pageReference);
            }
        ).catch(function(err) { console.log(err) });
    }
})
