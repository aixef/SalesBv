/*
* Fecha            Autor               Descripción
*                                            Creación del componente
* 27/12/2018        Mario Calderón        Creación de funcion "OtroMotivo" que muestra un textArea si el motivo de descarte de la oportunidad es "Otros factores (campo abierto)"
* 27/12/2018        Mario Calderón        Creación de funcion "CambioMotivo" que muestra los motivos de descarte si la etapa es Descartada/Rechazada"
                                            y los oculta si la etapa es diferente
* 27/03/2019        Antony de la rosa     Se modifica función  closeOpp y se agrega etapa de oportunidad gestionada.
* 04/04/2019        Antony de la rosa     Se Cambia el nombre de etapa de gestionada a En Gestión.
* 14/08/2019        Cindy Hernández	      Se agrega el tipo de registro MX_BPP_PersonAcc_NoClient a la primera validación de la función helperContinueModelCerrada.
*/
({
	doInit: function(component,event, helper) {
        var action = component.get('c.fetchOpp');
		var recordTypeName = '';
        action.setParams({oppId:component.get('v.recordId')});
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.oppSel', response.getReturnValue());
				recordTypeName = component.get('v.oppSel.RecordType.Name');
                helper.helperStage(component);
				//Get List Values
                helper.listValues(component, recordTypeName);
            }
        });
        $A.enqueueAction(action);
        var action2 = component.get('c.fetchUsr');
        action2.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.usr', response.getReturnValue());
            }
        });
        $A.enqueueAction(action2);
    },
    closeOpp:function(component,e,helper){
        var etapaOpp = component.get('v.EtapaOPP');
        if(etapaOpp==="Abierta"){
            window.Stg="En Gestión";
            helper.saveopp(component,e);
        }else{component.set("v.isOpenEtapa", true);}
    },
	closeModel: function(component) {
                component.set("v.isOpenEtapa", false);
                component.set("v.mDescarte", false);
                component.set("v.oMotivo", false);
                component.set('v.razonCierre', 'Seleccione una etapa cerrada...');
                component.set('v.razonDescarte', '--Ninguno--');
			},
	closeEt: function(component) {component.set("v.isOpenAmm", false); },
	closeCnfEt: function(component) {component.set("v.isOpenCnfmAmm", false); },
	closeClN: function(component) {component.set("v.isOpenClN", false); },

	CambioMotivo: function(component,event){
        var motivo = component.get('v.razonCierre');
        if(motivo==="Descartada / Rechazada"){
            component.set("v.mDescarte", true);
        }else{
            component.set("v.mDescarte", false);
            component.set("v.oMotivo", false);
            component.set("v.oMDescarte",null);
            component.set("v.razonDescarte",'--Ninguno--');
        }
    },
    OtroMotivo: function(component,event){
        var mDescarte = component.get('v.razonDescarte');
        if(mDescarte==="Otros factores (campo abierto)"){
            component.set("v.oMotivo", true);
        }else{
            component.set("v.oMotivo", false);
            component.set("v.oMDescarte", null);
        }
    },
	continueModel: function(component,e,helper) {
        var motivo = component.get('v.razonCierre');
		if (component.find("pklTyCloseOpp").get("v.value")===component.get('v.oppSel.StageName')) {
			alert('Seleccione una etapa diferente a la actual');
			return;
		}
		else if (component.find("pklTyCloseOpp").get("v.validity").valid && motivo!=="Descartada / Rechazada") {
			component.set("v.isOpenEtapa", false);
			window.Stg=component.find("pklTyCloseOpp").get("v.value");
			window.CliNum=null;
        }
		if (component.find("pklTyCloseOpp").get("v.value")==="Abierta" || component.find("pklTyCloseOpp").get("v.value")==="En Gestión"){
            helper.saveopp(component,e);
        }else if (component.find("pklTyCloseOpp").get("v.value")==="Descartada / Rechazada"){
            var helperDesRec = component.get('c.helperContinueModelDesRec');
            $A.enqueueAction(helperDesRec);
		}
		else if (component.find("pklTyCloseOpp").get("v.value")==="Cerrada Ganada") {
			// codigo para pedir numero de cliente en prospecto
			var helperCerrada = component.get('c.helperContinueModelCerrada');
            $A.enqueueAction(helperCerrada);
		}

    },
    helperContinueModelDesRec:function(component,e,helper) {
        var motivoDescarte = component.get('v.razonDescarte');
        var oMotivo = component.get('v.oMDescarte');
        if(motivoDescarte!=='--Ninguno--'){
            if(motivoDescarte!=="Otros factores (campo abierto)"){
                component.set("v.isOpenEtapa", false);
                window.Stg=component.find("pklTyCloseOpp").get("v.value");
                window.CliNum=null;
                helper.saveopp(component,e);
                return;
            }else{
                if(oMotivo==null){
                    //MOTIVO OBL
                    alert('El campo Otro motivo de descarte, es obligatorio.');
                }else{
                    component.set("v.isOpenEtapa", false);
                    window.Stg=component.find("pklTyCloseOpp").get("v.value");
                    window.CliNum=null;
                    helper.saveopp(component,e);
                    return;
                }
            }
        }else{
            alert('El campo Motivo de descarte, es obligatorio.');
        }
    },
    helperContinueModelCerrada:function(component,e,helper){
        if((component.get('v.oppSel.Account.RecordType.DeveloperName')==='BPyP_tre_noCliente') ||
        (component.get('v.oppSel.Account.RecordType.DeveloperName')==='MX_BPP_PersonAcc_NoClient')){
            component.set("v.isOpenClN", true);
            return;
        }
        if (component.get('v.oppSel.MX_RTL_Familia__c')==='Servicios') {
            helper.saveopp(component,e);
            return;
        }
        component.set("v.isOpenAmm", true);
    },
	continueClNu:function(component,e,helper){
		if(component.find("NumeroCliente").get("v.validity").valid){
			window.CliNum=component.find("NumeroCliente").get("v.value");
			component.set("v.isOpenClN", false);
			if (component.get('v.oppSel.MX_RTL_Familia__c')==='Servicios') {
                helper.saveopp(component,e);
                return;
            }
			component.set("v.isOpenAmm", true);
		}
	},
	continueAmmount:function(component,e,helper){
		if (component.find("Ammount").get("v.validity").valid) {
			// // guardar como cerrada ganada y mandando numero de cliente y StageName
            var num=component.find("Ammount")===undefined?null:parseFloat(component.find("Ammount").get("v.value"));
            if (num != null) {

                window.amm=num;
                component.set("v.isOpenAmm", false);
                component.set("v.isOpenCnfmAmm", true);
                // ¿Es correcto el monto de cierre de la oportunidad?  (monto de la oportunidad)
                component.set("v.msgConfirm", '¿Es correcto el monto de cierre de la oportunidad? $'+num.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,"));
            }
	    }
	},
	continueCnfmAmmount:function(component,e,helper){
		// guardar como cerrada ganada y mandando numero de cliente y StageName
		helper.saveopp(component,e);
        component.set("v.isOpenCnfmAmm", false);
	},
	continueMotDes:function(component,e,helper){
        if (component.find("pklTyCloseOppDes").get("v.value")==="9") {
            component.set("v.isOpenDes", false);
            component.set("v.isOpenOtroMot", true);
            return;
        }else{
            helper.saveopp(component,e);
        }
    },
})
