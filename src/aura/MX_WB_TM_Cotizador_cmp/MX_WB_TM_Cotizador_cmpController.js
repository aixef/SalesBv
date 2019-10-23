({
    doInit : function(component, event, helper) {
        component.set('v.msjError', '');
    },
    addProductCtrl : function(component, event, helper) {
        var valueSelect = component.find("selProd").get("v.value");
        if ( valueSelect === 'option' ) {
            component.set('v.blShowMsgPro', true);
        } else {
            component.set('v.blShowMsgPro', false);
            helper.addProductHlp(component, event, helper);
        }
    },
    afterUpDate : function(component, event, helper) {
        helper.validQuotes(component, event, helper);
    },
    updateQuote : function(component, event, helper) {
        var folio = event.getParam("FolioCotizacion");
        if ($A.util.isEmpty(folio) === false) {
            helper.buildUrlbyNumber(component, event, helper);
        }
    }
})
