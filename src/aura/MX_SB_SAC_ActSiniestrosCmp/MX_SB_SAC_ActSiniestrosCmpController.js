({
  doInit: function(component, event, helper) {
      component.set('v.detailError', '');
  },
  navToRecord: function(component, event, helper) {
      $A.get('e.force:closeQuickAction').fire();
      $A.get('e.force:refreshView').fire();
  },
  afterUpdateContract : function(component, event, helper) {
      component.get('v.OpptyRecord.MX_WB_noPoliza__c');
      var spinner = component.find('spinner');
      $A.util.removeClass(spinner, 'slds-hide');
      helper.getResponse(component, event, helper, false);
  },
});
