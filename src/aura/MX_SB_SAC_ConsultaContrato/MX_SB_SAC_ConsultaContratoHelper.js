({
  initComponents: function(component, event, helper) {
    var action = component.get("c.getParams");
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        console.log(response.getReturnValue());
        var custs = [];
        var conts = response.getReturnValue();
        for (var key in conts) {
          custs.push({ value: conts[key], key: key });
        }
        component.set("v.params", custs);
      }
    });
    $A.enqueueAction(action);
  },
  searchPoliza: function(component, event, helper, mapToSend) {
    component.set("v.isResponse", false);
    component.set("v.HideSpinner", true);
    component.set("v.HideCreatModify", false);
    var action = component.get("c.consultaPoliza");
    action.setParams({
      camposConsulta: this.getParamsJson(mapToSend),
      tipoConsulta: component.find("sTipoConsulta").get("v.value")
    });
    action.setCallback(this, function(response) {
      console.log(response.getState());
      var state = response.getState();
      if (state === "SUCCESS") {
        var results = response.getReturnValue();
        var strResult = JSON.parse(JSON.stringify(results));
        var strJsonResp = JSON.parse(strResult.jsonResp);
        console.log(strResult.error);
        console.log(strResult.msgError);
        component.set("v.isResponse", true);

        if (strResult.error) {
          component.set("v.msgResponse", strJsonResp.msjResponse);
        } else {
          if (strJsonResp.apellidoPaternoAsegurado == null) {
            component.set("v.msgResponse", "Número de póliza no existe");
          } else {
            component.set("v.msgResponse", "Número de póliza encontrado ");
            component.set("v.HideCreatModify", true);
            component.set("v.polizaDetail", results);
            console.log("Detalle de poliza", component.get("v.polizaDetail"));
          }
        }
      } else if (state === "ERROR") {
        var errors = response.getError();
        console.log(errors);
      }
      component.set("v.HideSpinner", false);
    });
    $A.enqueueAction(action);
  },
  modifyCreatePoliza: function(component, event, helper, numeroPoliza) {
    component.set("v.isResponse", false);
    component.set("v.HideSpinner", true);
    var action = component.get("c.creaModificaPoliza");
    var mapaPoliza = component.get("v.polizaDetail");

    action.setParams({
      numeroPoliza: numeroPoliza,
      mpPoliza: mapaPoliza
    });
    action.setCallback(this, function(response) {
      console.log(response.getState());
      var state = response.getState();
      component.set("v.isResponse", true);
      if (state === "SUCCESS") {
        var results = response.getReturnValue();
        var strResult = JSON.parse(JSON.stringify(results));
        console.log(strResult);
        component.set("v.HideCreatModify", false);
        if (strResult.error) {
          component.set("v.msgResponse", strResult.msjResponse);
        } else {
          component.set("v.msgResponse", strResult.msjResponse);
        }
      } else if (state === "ERROR") {
        var errors = response.getError();
        component.set("v.msgResponse", errors);
      }
      component.set("v.HideSpinner", false);
    });
    $A.enqueueAction(action);
  },
  getParamsJson: function(mapToSend) {
    var obj = {};
    mapToSend.forEach(function(v, k) {
      obj[k] = v;
    });
    var jsonToSend = JSON.stringify(obj);
    return jsonToSend;
  }
});
