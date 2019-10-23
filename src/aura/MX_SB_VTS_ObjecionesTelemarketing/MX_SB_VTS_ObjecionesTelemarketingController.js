({
    init : function(component, event, helper) {
        component.set('v.isActive', false);
        component.set('v.isLoading', true);
    },
    afterUpDate: function(component, event, helper) {
        let varSObject = component.get('v.genericRecord');
        if($A.util.isEmpty(varSObject.Id)) {
            helper.manageErrors(component, event, helper, $A.get("{!$Label.c.MX_SB_VTS_errorGetRecords}"), $A.get("{!$Label.c.MX_SB_VTS_errorGetObjetions}"));
        } else {
            try {
                helper.getObjetions(component, event, helper);
            } catch (error) {
                helper.manageErrors(component, event, helper, $A.get("{!$Label.c.MX_SB_VTS_errorPermisions}"), $A.get("{!$Label.c.MX_WB_lg_TlmktError}"));
            }
        }
    },
    saveObjections: function(component, event, helper) {
        component.set('v.errorMsjTitle', 'Éxito');
        component.set('v.errorMsj', $A.get("{!$Label.c.MX_SB_VTS_ObjecionCorrecta}"));
        helper.showToast(component, event, helper, 'success');
        helper.saveObjectCall(component, event, helper);
    },
    changeValLeft : function(component, event, helper) {
        component.set('v.isLoading', true);
        let vales = event.getSource().get('v.value');
        let lstText = component.get('v.listaTextos');
        lstText[vales].usoObjecion = true;
        lstText[vales].noUsoCatObject = false;
        component.get('v.listaTextos',lstText);
        component.set('v.isLoading', false);
    },
    changeValRight : function(component, event, helper) {
        component.set('v.isLoading', true);
        let valR = event.getSource().get('v.value');
        let lstText = component.get('v.listaTextos');
        lstText[valR].noUsoCatObject = true;
        lstText[valR].usoObjecion = false;
        component.get('v.listaTextos',lstText);
        component.set('v.isLoading', false);
    }
})
