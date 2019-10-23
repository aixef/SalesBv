/*
*Desarrollado por:       Indra
*Autor:                  Abraham Alfonso Tinajero Sanchez
*Proyecto:               Experiencia Única
*Descripción:            Componente helper
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 02-02-2018     |    Abraham Tinajero      |           Creación
*1.2    | 04-07-2018     |  Ricardo Hernandez       | Solución incidencia
1.3     | 27-05-2019     |  Hugo I. Carrillo B.     | Solución de errores detectados por Sonar
*/
({
    VerificaDirector : function(component){
        var action = component.get("c.VerificaDirector");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.DORI", response.getReturnValue());
            }
        });

        $A.enqueueAction(action);
    },
    verificaSTAFF : function(cmp){
        var action = cmp.get("c.verificaStaff");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.staff", response.getReturnValue());

            }
        });
        $A.enqueueAction(action);
    },

    generaNuevoRI:function(cmp,event,helper){
        var action = cmp.get("c.generaNuevoRI");

        action.setCallback(this, function(response) {

            var state = response.getState();

            if(state==="SUCCESS"){
                var result =  response.getReturnValue();

                if(result.startsWith("Error")){
                    cmp.set("v.leyendaErrorGeneraRI", result);
                    cmp.set("v.banderaErrorGeneraRI", true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "error",
                        "message": result
                    });
                    toastEvent.fire();
                }else {

                    cmp.set("v.idRi",String(result).split(';')[0]);
                    cmp.set("v.RiName",String(result).split(';')[1]);
                    var toastEvent2 = $A.get("e.force:showToast");
                    toastEvent2.setParams({
                        "title": "Correcto!",
                        "type": "success",
                        "message": "Se generó la Reunión Individual"
                    });

                    toastEvent2.fire();
                    this.activaVista(cmp,event,helper,String(result).split(';')[0]);
                }
            }
        });
        $A.enqueueAction(action);

    },

    activaVista:function(cmp,event,helper,rIs){

        var action = cmp.get("c.getRISelect");
        var Ri = rIs;
        var RiName ="";
        if(event.target.name==null || event.target.name==="")
        {
            RiName = cmp.get("v.RiName");
        }
        else
        {
            RiName = event.target.name;
        }

        if(Ri == null){
            Ri = event.target.id;
        }
        action.setParams({
            "IdRI":Ri
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state==="SUCCESS"){
                var EnvioParametros= cmp.getEvent("PasoParametrosPadre");
                var result =  response.getReturnValue();
                EnvioParametros.setParams({
                    "UserUG":result,
                    "RISeleccionada": Ri,
                    "Showvista1" : true,
                    "Showvista2": false,
                    "RISucces": cmp.get("v.banderaErrorGeneraRI"),
                    "RISelName" : RiName
                });
                EnvioParametros.fire();

            }
        });
        $A.enqueueAction(action);
    },

})
