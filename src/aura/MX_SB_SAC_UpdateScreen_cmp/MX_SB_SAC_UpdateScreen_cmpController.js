({
  invoke: function(component, event, helper) {
    var recordLoader = component.find('recordLoader');
    recordLoader.reloadRecord(true, $A.getCallback(function() {}));
  },
});
