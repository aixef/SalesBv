/*
<!--
*Desarrollado por:       Indra
*Autor:                  Monserrat Gonzalez
*Proyecto:               BPP
*Descripción:            Basado en EU001_cmp_VistaCompromisos
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 18-05-2018     |    Monserrat Gonzalez		    |           Creación
*1.1	| 30-01-2019	 |	  Mario Calderón		|			Creación del método "ObtenerCampoPadreEHijo",
*																modificación del método "init" que pasa los valores de
*																de la familia y oportunidad al controlador Apex
*1.2	| 30-01-2019	 |    Adrián Pastor Pineda	|			Se agrega dentro de la función init un desarrollo para sumar las oportunidades y monto total segun sea el filtro
*1.3    | 27-05-2019     |    Hugo I. Carrillo B.   |           Resolución de errores de code smell detectados por sonar
-->
**/
({
    init: function(cmp, evt) {

        var action0 = cmp.get("c.VerificaDirector");

        action0.setCallback(this, function(response) {
            var state0 = response.getState();
            if (state0 === "SUCCESS") {
                cmp.set("v.isDO", response.getReturnValue());
            }
        });
        $A.enqueueAction(action0);

        var action = cmp.get("c.getTableCompromisos");
        var Ri = cmp.get("v.IdRICompromiso");
        var filtroEstatus = cmp.find("selEstatusCompTab").get("v.value");
		var campoPadre = cmp.get("v.campoPadre");
        var campoHijo = cmp.get("v.campoHijo");
        action.setParams({
            "IdRI":Ri,
            "filtroEstatus":filtroEstatus,
			"campoPadre":campoPadre,
            "campoHijo":campoHijo
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var contador=[];
            var monto;
            var suma='0';
            var str;
            if (state === "SUCCESS") {
                cmp.set("v.rows", response.getReturnValue());
				str = JSON.stringify(response.getReturnValue(), null, ' ');
                str = str.split(" ");
                for(var i = 0; i < str.length; i++) {
                    if (str[i].includes('OwnerId')){
                     contador.push(i);
                	}
                    if (str[i].includes('EU_001_dv_Compromiso__c')){
                        monto =parseInt(str[i+1]);
                        suma = parseInt(suma) + parseInt(monto);
                	}
                }
                cmp.set("v.contador", contador.length);
                cmp.set("v.montocompromiso",suma);
            }
        });
        $A.enqueueAction(action);

        var action2 = cmp.get("c.getUser");

        action2.setParams({
            "recordId":Ri
        });
        action2.setCallback(this, function(response) {
            var state2 = response.getState();
             if (state2 === "SUCCESS") {
                var result = response.getReturnValue();
                cmp.set("v.PropietarioRI",result[0].Owner.Name);
                cmp.set("v.NombreRI",result[0].Name);
            }
        });
        $A.enqueueAction(action2);
        var action3 = cmp.get("c.getRecordTypeId");
        action3.setParams({
            "sObjType":'EU_001_Compromiso__c',
            "Concepto":'General'
        });
        action3.setCallback(this, function(response) {
            var state3 = response.getState();
             if (state3 === "SUCCESS") {
                var result3 = response.getReturnValue();
                cmp.set("v.RecordTypeId",result3);
            }
        });
        $A.enqueueAction(action3);


    },
    toggleDialog : function(component, event, helper) {
        component.set('v.showModalNuevoCompromiso', false);
        component.set('v.bModal',false);
    },
    handleModalNuevoCompromisoOpen: function(component, event, helper) {
        component.set('v.bModal',true);

        component.set('v.showModalNuevoCompromiso', true);
    },
    saveRecord : function(component,event,helper) {
         var action =  component.get("c.getInsertaCompromiso");
         var sIdRIS=component.get("v.IdRICompromiso");
         var TipoCompromiso = component.find("selTipoComp").get("v.value");
         var FechaC="";
         FechaC=component.find("dtFechaCierre").get("v.value");
         var Estatus = component.find("selEstatusComp").get("v.value");
         var errMsg=false;
         if( sIdRIS.length===0 )
         {
            helper.mensajeAlerta(component,"Selecciona un RI válido.");
            errMsg=true;
         }
         if(TipoCompromiso === "")
         {
            helper.mensajeAlerta(component,"Selecciona un Tipo de compromiso Válido.");
            errMsg=true;
         }
         if(FechaC==null || FechaC==="")
         {
            helper.mensajeAlerta(component,"Selecciona Fecha válida.");
            errMsg=true;
         }

         if(Estatus==="")
         {
            helper.mensajeAlerta(component  ,"Selecciona Estatus Válido.");
            errMsg=true;
         }

         if(!errMsg) {
             event.getSource().set("v.disabled", true);
             helper.saveRecordHelper(component, event, action);
        }
    },
	 ObtenerCamposPadreEHijo : function(cmp, evt, helper)
    {
     var campoPadre = evt.getParam("campoPadre");
     var campoHijo = evt.getParam("campoHijo");
     cmp.set("v.campoPadre",campoPadre);
     cmp.set("v.campoHijo",campoHijo);
     console.log("Padre: " + campoPadre);
     console.log("Hijo: " + campoHijo);
     $A.enqueueAction(cmp.get('c.init'));
    }
})
