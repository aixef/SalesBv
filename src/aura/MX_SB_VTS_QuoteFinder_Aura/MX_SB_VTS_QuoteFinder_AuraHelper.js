({
	getData: function(component) {
		var action = component.get("c.findQuote");
		action.setParams({
			"searchTerm": component.get("v.searchTerm")
		});
		action.setCallback(this, function(response) {
		 	let state = response.getState();
			if(state === "SUCCESS") {
				if(response.getReturnValue() === {}) {
					console.log('Nothing found');
				} else {
					component.set("v.updateQuote", response.getReturnValue());
					component.set("v.hasRecord", true);
					let selOp = component.get("v.updateQuote");
					if(selOp.MX_SB_VTS_Familia_Productos__r.Name === $A.get("$Label.c.MX_SB_VTS_Hogar")) {
						component.set("v.esHogar", true);
						component.set("v.esAuto", false);
						component.set("v.esVida", false);
					} else if(selOp.MX_SB_VTS_Familia_Productos__r.Name === $A.get("$Label.c.MX_SB_VTS_FamiliaASD")) {
						component.set("v.esHogar", false);
						component.set("v.esAuto", true);
						component.set("v.esVida", false);
					} else if(selOp.MX_SB_VTS_Familia_Productos__r.Name === 'Vida') {
						component.set("v.esHogar", false);
						component.set("v.esAuto", false);
						component.set("v.esVida", true);
					}
					component.set("v.selectedOption", selOp.MX_SB_VTS_Motivos_de_no_venta__c);
					component.set("v.verification", selOp.MX_SB_VTS_Codigo_verificacion__c);
					component.set("v.hasErrors", "");
				}
			} else if(state === "ERROR" || state === "INCOMPLETE") {
				var error = response.getError();
				if(error[0] && error[0].message) {
					component.set("v.hasErrors", error[0].message);
				}
			} else {
				component.set("v.updateQuote" , null);
			}
		});
		$A.enqueueAction(action);
	},
	handleSave: function(component) {
		var record = component.get("v.updateQuote");
		var action = component.get("c.updateQuote");
		record.MX_SB_VTS_Motivos_de_no_venta__c = component.get("v.selectedOption");
		record.MX_SB_VTS_Codigo_verificacion__c = component.get("v.verification");
		action.setParams({
			"quo": record
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if(state === "SUCCESS") {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"title": "Actualizado",
					"message": "La cotizacion se ha actualizado correctamente.",
					"type": "success",
					"duration": "2000"
				});
				toastEvent.fire();
			} else if(state === "ERROR" || state === "INCOMPLETE") {
				var error = response.getError();
				if(error[0] && error[0].message) {
					component.set("v.hasErrors", 'Error al aplicar los cambios');
				}
			}
		});
		$A.enqueueAction(action);
	},
	getMotivos : function(component) {
		var records = component.get("c.getMotivosNoVenta");
		records.setCallback(this, function(response) {
			var state = response.getState();
			if(state === "SUCCESS") {
				component.set('v.options', response.getReturnValue());
			}
		});
		$A.enqueueAction(records);
	}
})
