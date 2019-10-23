({
  doInit: function(component, event, helper) {
    helper.initComponents(component, event, helper);
  },
  searchPol: function(component, event, helper) {
    var inputsPoliza = component
      .find("divFormAllInputs")
      .find({ instancesOf: "lightning:input" });
    var mapToSend = new Map();
    for (var i = 0; i < inputsPoliza.length; i++) {
      mapToSend.set(
        inputsPoliza[i].get("v.name"),
        inputsPoliza[i].get("v.value")
      );
    }
    helper.searchPoliza(component, event, helper, mapToSend);
  },
  modifCreatPoliza: function(component, event, helper) {
    var inputsPoliza = component
      .find("divFormAllInputs")
      .find({ instancesOf: "lightning:input" });
    var numeroPoliza;
    for (var i = 0; i < inputsPoliza.length; i++) {
      numeroPoliza = inputsPoliza[i].get("v.value");
    }
    helper.modifyCreatePoliza(component, event, helper, numeroPoliza);
  }
});
