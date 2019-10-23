({
    navigate : function(component, event, helper) {
                let naVLightning = component.find('navigate');
                let pageReference = {
                    type: "standard__webPage",
                    attributes: {
                        url: "http://www2.repuve.gob.mx:8080/ciudadania/"
                    }
                };
                naVLightning.navigate(pageReference);
            }
})
