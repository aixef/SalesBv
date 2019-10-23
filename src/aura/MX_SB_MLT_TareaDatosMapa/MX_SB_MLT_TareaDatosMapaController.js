({
     handleInit: function(component, event, helper) {
          helper.initHelper(component, event, helper);
     },
     fullScreen: function(component) {
          component.set('v.bModal', true);
     },
});
