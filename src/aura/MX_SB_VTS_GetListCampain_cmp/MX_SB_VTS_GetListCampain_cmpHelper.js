({
	helperBandeja: function(component, event) {
		var SearchResul = component.get('v.Descrip');
		var serviciote = component.get("v.Servicio");
		var SearchNam = component.get('v.NameCamp');
		var selectedRecordID = component.get('v.selectedRecord');
		var action = component.get('c.Carga_invoke');
		action.setParams({
			servicio : serviciote,
			DESCRIPCION: SearchResul,
			Nam: SearchNam,
			IdCampa: selectedRecordID.Id,
			IdProducto: '',
			Descrip: SearchResul
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					title: 'Exito ',
					mode: 'dismissible',
					duration: 3000,
					type: 'success',
					message: 'Se han enviado los registros a CTI.'
				});
				toastEvent.fire();
				component.set('v.IDBandeja', response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},
	searchHelper2: function(component, event, getInputkeyWord2) {
		var action2 = component.get('c.fetchLookUpValues');
		action2.setParams({
			searchKeyWord: getInputkeyWord2,
			ObjectName: component.get('v.objectAPIName')
		});
		action2.setCallback(this, function(response) {
			$A.util.removeClass(component.find('mySpinner'), 'slds-show');
			var state = response.getState();
			if (state === 'SUCCESS') {
				var storeResponse = response.getReturnValue();
				if (storeResponse.length === 0) {
					component.set('v.Message', 'No Result Found...');
				} else {
					component.set('v.Message', '');
				}
				component.set('v.listOfSearchRecords', storeResponse);
			}
		});
		$A.enqueueAction(action2);
	},
	searchBandejas: function(component, event) {
		var selectedRecordID = component.get('v.selectedRecord');
		var action = component.get('c.searchBandejas');
		action.setParams({
			searchKeyWord: selectedRecordID.Id
		});
		action.setCallback(this, function(response) {
			$A.util.removeClass(component.find('mySpinner'), 'slds-show');
			var state = response.getState();
			if (state === 'SUCCESS') {
				var storeResponse = response.getReturnValue();
				if (storeResponse.length === 0) {
					component.set('v.Message', 'No Result Found...');
				} else {
					component.set('v.Message', '');
				}
				var stroecero = storeResponse[0].ID;
				component.set('v.Bandejas', storeResponse);
				component.set('v.Bamdeja', stroecero);
			} else {
				alert('Error');
			}
		});
		$A.enqueueAction(action);
    },
    searchServicios: function (component, event) {
        var action = component.get("c.searchServicios");
		action.setParams({
        });
        action.setCallback(this, function (response) {
			var state = response.getState();
           	if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length === 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                var stroecero=storeResponse[0].Name;
                component.set("v.ListServicio", storeResponse);
                component.set("v.Servicio", stroecero);
            }
            else {
                alert("Error");
            }
        });
        $A.enqueueAction(action);
    },
})
