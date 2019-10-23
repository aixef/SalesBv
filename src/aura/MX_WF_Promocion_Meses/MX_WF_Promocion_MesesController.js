({
	Showhide : function(component, event, helper) {
         var vidcheck = event.getSource().get('v.name');
         let checkBoxState = event.getSource().get('v.value');
         console.log(event.getSource().get('v.value'));

         switch (vidcheck) {
             case "2":
                         component.find("Minimo2").set("v.disabled", !checkBoxState);
                         component.find("Maximo2").set("v.disabled", !checkBoxState);
                         component.set("v.mes2",checkBoxState);
                 break;
             case "3":
                           component.find("Minimo3").set("v.disabled", !checkBoxState);
                           component.find("Maximo3").set("v.disabled", !checkBoxState);
                           component.set("v.mes3",checkBoxState);
                 break;
             case "4":
                          component.find("Minimo4").set("v.disabled", !checkBoxState);
                          component.find("Maximo4").set("v.disabled", !checkBoxState);
                          component.set("v.mes4",checkBoxState);
                 break;
             case "5":
                          component.find("Minimo5").set("v.disabled", !checkBoxState);
                          component.find("Maximo5").set("v.disabled", !checkBoxState);
                          component.set("v.mes5",checkBoxState);
                 break;
             case "6":
                           component.find("Minimo6").set("v.disabled", !checkBoxState);
                           component.find("Maximo6").set("v.disabled", !checkBoxState);
                           component.set("v.mes6",checkBoxState);
                 break;
             case "7":
                           component.find("Minimo7").set("v.disabled", !checkBoxState);
                           component.find("Maximo7").set("v.disabled", !checkBoxState);
                           component.set("v.mes7",checkBoxState);
                 break;
             case "8":
                           component.find("Minimo8").set("v.disabled", !checkBoxState);
                           component.find("Maximo8").set("v.disabled", !checkBoxState);
                           component.set("v.mes8",checkBoxState);
                 break;
             case "9":
                           component.find("Minimo9").set("v.disabled", !checkBoxState);
                           component.find("Maximo9").set("v.disabled", !checkBoxState);
                           component.set("v.mes9",checkBoxState);
                 break;
             case "10":
                           component.find("Minimo10").set("v.disabled", !checkBoxState);
                           component.find("Maximo10").set("v.disabled", !checkBoxState);
                           component.set("v.mes10",checkBoxState);
                 break;
             case "11":
                           component.find("Minimo11").set("v.disabled", !checkBoxState);
                           component.find("Maximo11").set("v.disabled", !checkBoxState);
                           component.set("v.mes11",checkBoxState);
                 break;
             case "12":
                           component.find("Minimo12").set("v.disabled", !checkBoxState);
                           component.find("Maximo12").set("v.disabled", !checkBoxState);
                           component.set("v.mes12",checkBoxState);
                 break;
             case "13":
                           component.find("Minimo13").set("v.disabled", !checkBoxState);
                           component.find("Maximo13").set("v.disabled", !checkBoxState);
                           component.set("v.mes13",checkBoxState);
                 break;
             case "14":
                           component.find("Minimo14").set("v.disabled", !checkBoxState);
                           component.find("Maximo14").set("v.disabled", !checkBoxState);
                           component.set("v.mes14",checkBoxState);
                 break;
             case "15":
                           component.find("Minimo15").set("v.disabled", !checkBoxState);
                           component.find("Maximo15").set("v.disabled", !checkBoxState);
                           component.set("v.mes15",checkBoxState);
                 break;
             case "16":
                           component.find("Minimo16").set("v.disabled", !checkBoxState);
                           component.find("Maximo16").set("v.disabled", !checkBoxState);
                           component.set("v.mes16",checkBoxState);
                 break;
             case "17":
                           component.find("Minimo17").set("v.disabled", !checkBoxState);
                           component.find("Maximo17").set("v.disabled", !checkBoxState);
                           component.set("v.mes17",checkBoxState);
                 break;
             case "18":
                           component.find("Minimo18").set("v.disabled", !checkBoxState);
                           component.find("Maximo18").set("v.disabled", !checkBoxState);
                           component.set("v.mes18",checkBoxState);
                 break;
                       }
    }
})
