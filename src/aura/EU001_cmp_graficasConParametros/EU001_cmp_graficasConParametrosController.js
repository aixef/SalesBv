({
    iniciaGraficas: function (component, event, helper) {
        var decide = component.get("v.banderaJsonConsulta");
        if(!decide){
            helper.graficaEvolucion(component);
        }else{
            helper.graficaConsulta(component);
        }
    },
    cambio : function(component,event,helper){
        var evolucion = component.find('grafEvolucion').getElement();
        helper.dibujaGrafico(component, evolucion);
    },
    rerender : function(component,event,helper){
       this.superUnrender();
    },
})
