/*
* Fecha            Autor               Descripción
*                                            Creación del componente
* 20/12/2018       Mario Calderón        Modificación de la función "saveopp" para cambiar la bandera de bypass y así evitar la regla de validación MX_BPP_CambioEtapaEnFlujo
* 26/12/2018       Mario Calderón        Creación de la función "listValues" que regresa los motivos de descarte según el tipo de registro de la oportunidad
* 27/12/2018       Mario Calderón        Modificación de la función "saveopp" para recibir los motivos de descarte de una oportunidad y otros motivos en caso de tenerlo
* 27/03/2019       Antony de la rosa     Se modifica función  saveopp y se agrega etapa de oportunidad gestionada.
* 04/04/2019        Antony de la rosa     Se Cambia el nombre de etapa de gestionada a En Gestión.
*/
({
	listValues: function(component, recordTypeName){
	        var action3 = component.get('c.motivosDescarte');
	        action3.setParams({
	            tgr: recordTypeName
	        });
	        action3.setCallback(this, function(response){
	            var result = response.getReturnValue();
	            //store state of response
	            var state = response.getState();
	            if (state === "SUCCESS"){
	                component.set('v.valInput',result);
	            }
	        });
	        $A.enqueueAction(action3);
	    },
    saveopp: function(component,e) {
            var bypass = component.get("v.StageBypass");
            var motivoDescarte = component.get('v.razonDescarte');
            var OtroMotivo = component.get('v.oMDescarte');
            var action = component.get('c.updOpp');
            var Ammount=window.amm===undefined?null:window.amm;
            action.setParams({
                oppId:component.get('v.recordId'),
                stgNm:window.Stg,
                clNum:window.CliNum,
                amm:Ammount,
                bypass: bypass,
                motivoDescarte : motivoDescarte,
                otroMDescarte : OtroMotivo
            });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var updStat=response.getReturnValue();
                if(updStat.resopp!=null){
                    var action2 = component.get('c.fetchOpp');
                    action2.setParams({oppId:component.get('v.recordId')})
                    action2.setCallback(this, function(response) {
                        //store state of response
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            component.set('v.oppSel', response.getReturnValue());
                            this.helperStage(component);
                        }
                    });
                    $A.enqueueAction(action2);
                    $A.get('e.force:refreshView').fire();

                    alert('Actualizada correctamente');
                }
                else if(updStat.err!=null){
                        alert(updStat.err.substring(updStat.err.indexOf('error: '),999));
                }
            }
        });
        $A.enqueueAction(action);
    },
    helperStage:function(component) {
        component.set('v.EtapaOPP',component.get('v.oppSel.StageName'));
        component.set('v.cerradaTitle',component.get('v.oppSel.StageName')==='Abierta' ||
                    component.get('v.oppSel.StageName')==='En Gestión'?'Cerrada':component.get('v.oppSel.StageName'));
        component.set('v.buttonTitle',component.get('v.oppSel.StageName')==='Abierta'||
                    component.get('v.oppSel.StageName')==='En Gestión' ?'Marcar etapa como completada':'Cambiar etapa cerrada');
        if (component.get('v.oppSel.StageName').toLowerCase()==='cerrada ganada') {
            component.set('v.abiertaClass','slds-path__item slds-is-complete');
            component.set('v.GestionadaClass','slds-path__item slds-is-complete');
            component.set('v.cerradaClass','slds-path__item slds-is-complete slds-is-won slds-is-active');
        }
        else if(component.get('v.oppSel.StageName')==='Descartada / Rechazada'){
            component.set('v.abiertaClass','slds-path__item slds-is-incomplete');
            component.set('v.GestionadaClass','slds-path__item slds-is-complete');
            component.set('v.cerradaClass','slds-path__item slds-is-lost slds-is-active');
        }
        else if(component.get('v.oppSel.StageName')==='En Gestión'){
            component.set('v.GestionadaClass','slds-path__item slds-is-current slds-is-active');
            component.set('v.abiertaClass','slds-path__item slds-is-complete');
            component.set('v.cerradaClass','slds-path__item slds-is-incomplete');
        }
        else{
            component.set('v.abiertaClass','slds-path__item slds-is-current slds-is-active');
            component.set('v.GestionadaClass','slds-path__item slds-is-incomplete');
            component.set('v.cerradaClass','slds-path__item slds-is-incomplete');
        }
    }
})
