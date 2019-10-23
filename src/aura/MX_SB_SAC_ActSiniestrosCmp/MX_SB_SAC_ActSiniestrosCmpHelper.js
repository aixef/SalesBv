({
  getResponse: function(component, event, helper, token) {
    var spinner = component.find('spinner');
    var oppInstances = {};
    var oppValues = component.get('v.record');
    oppInstances.Id = oppValues.fields.Id.value;
    oppInstances.MX_WB_noPoliza__c = oppValues.fields.MX_WB_noPoliza__c.value;
    var responseWS = component.get('c.responseActPol');
    responseWS.setParams({
      'jsonOpp': JSON.stringify(oppInstances), 'strToken': token
    });
    responseWS.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        component.set('v.allCorrect', true);
        $A.util.addClass(spinner, 'slds-hide');
      } else {
        component.set('v.allCorrect', false);
        var errorMsg = response.getError()[0].message;
        var wsCount = component.get('v.wsCount');
        wsCount++;
        component.set('v.wsCount', wsCount);
        if (wsCount <= 2 && (errorMsg === 'Token inválido')) {
          helper.createToken(component, event, helper, true);
        } else {
          component.set('v.detailError', errorMsg);
          $A.util.addClass(spinner, 'slds-hide');
        }
      }
    });
    $A.enqueueAction(responseWS);
  },
  createToken: function(component, event, helper, newToken) {
    var spinner = component.find('spinner');
    var responseToken = component.get('c.newToken');
    responseToken.setParams({
      'newToken': newToken
    });
    responseToken.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        helper.getResponse(component, event, helper, response.getReturnValue());
      } else {
        component.set('v.detailError', 'Error al consultar Web Service,No hubo respuesta');
        $A.util.addClass(spinner, 'slds-hide');
      }
    });
    $A.enqueueAction(responseToken);
  },
});
