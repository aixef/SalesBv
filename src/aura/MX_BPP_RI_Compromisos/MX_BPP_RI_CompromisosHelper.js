/*
<!--
*Desarrollado por:       Indra
*Autor:                  Monserrat Gonzalez
*Proyecto:               BPyP
*Descripción:            Basado en EU001_cmp_listOpp
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 17-05-2018     |    Monserrat Gonzalez      |           Creación
*1.1	| 24-01-2019	 |	  Mario Calderón		  |		Se modifica función "getOppWrapper" para permitir
*															el envío de dos campos para agregar al filtro de las
*															oportunidades.
*1.2    | 27-05-2019     |    Hugo I. Carrillo        |     Corrección de code smells detectados por sonar
-->
*/
({
    getOppWrapper : function(component) {
        // Create the action
        var dateInit = component.find("dateInit");
        var dateEnd = component.find("dateEnd");
        var sendDate0 = dateInit.get("v.value") + ' 00:00:00';
        var sendDate1 = dateEnd.get("v.value") + ' 00:00:00';
		var campoPadre = component.get("v.campoPadre");
        var campoHijo = component.get("v.campoHijo");
        var action = component.get("c.getOppToComp");
        var paramId = component.get("v.idRI");
        // Add callback behavior for when response is received
        action.setParams({
            idRI:paramId,
            fechaInicio: sendDate0,
            fechaFin: sendDate1,
			campoPadre : campoPadre,
            campoHijo : campoHijo
        });
	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
                component.set("v.listaOportunidades", response.getReturnValue());
                component.set("v.DATEINIT", false);
	        }
	    });

	    $A.enqueueAction(action);
	},
	setInitDates: function(component){
        component.set("v.DATEINIT", true);
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth()+1;
        var yyyy = today.getFullYear();
        if(dd<10) {
            dd = '0'+dd
        }
        if(mm<10) {
            mm = '0'+mm
        }
        today = yyyy + '-' + mm + '-' + dd;
        var dateInit = component.find("dateInit");
        var dateEnd = component.find("dateEnd");
	    var action = component.get("c.getPrimerDiaMes");
        action.setParams({
            dateToday : today
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseDate = response.getReturnValue();
            if(state === 'SUCCESS'){
                var dateasign = responseDate.replace(" 00:00:00", "");
                dateInit.set("v.value", dateasign);
            }
            var action0 = component.get("c.getUltimoDiaDosMesesSig");
            action0.setParams({
                dateToday : today
            });
            action0.setCallback(this, function(response) {
            	var state = response.getState();
            	var responseDate = response.getReturnValue();
                if(state === 'SUCCESS'){
                    var dateasign = responseDate.replace(" 00:00:00", "");
                    dateEnd.set("v.value", dateasign);
                }
                this.getOppWrapper(component);
            });
            $A.enqueueAction(action0);
        });
        $A.enqueueAction(action);
    },
    generaCompromisos :  function(component){
		// Create the action
		var spinner = component.find("mySpinner");
	    $A.util.removeClass(spinner, 'slds-show');
		$A.util.addClass(spinner, 'slds-hide');
		var oppLis = component.get("v.listaOportunidades");
	    var action = component.get("c.generaCompromisosOppBPYP");

	    action.setParams({
	        listOpp : JSON.stringify(oppLis)
	    });

	    // Add callback behavior for when response is received
	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	        	this.getOppWrapper(component);
	        	$A.util.removeClass(spinner, 'slds-hide');
                $A.util.addClass(spinner, 'slds-show');
	        }
	    });

	    $A.enqueueAction(action);

	}
})
