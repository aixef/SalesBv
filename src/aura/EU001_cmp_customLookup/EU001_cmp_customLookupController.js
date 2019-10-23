/*
*Desarrollado por:       Luis Fernando Romero
*Autor:                  Luis Fernando Romero
*Proyecto:               Experiencia Única
*Descripción:            Se administran las llamadas y efectos al realizar una búsqueda de sObjects
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 13/08/18	    |    Luis Fernando Romero	| Creación
*1.2    | 27/05/19      |    Hugo I. Carrillo B.    | Correción de code smells detectados por sonar
*/
({
   onfocus : function(component,event,helper){
        var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
         var getInputkeyWord = '';
         helper.searchHelper(component,event,getInputkeyWord);
    },
    keyPressController : function(component, event, helper) {
		var getInputkeyWord = component.get("v.SearchKeyWord");
        if( getInputkeyWord.length > 0 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        } else{
             component.set("v.listOfSearchRecords", null );
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
	},
    clear :function(component,event,heplper){
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField");

         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
         component.set("v.selectedRecord", {} );
            var cmpEvent = component.getEvent("loadCom");
            cmpEvent.setParams({
                "lock" : true,
                "obj": component.get("v.objectAPIName")
            });
            cmpEvent.fire();
    },
    handleComponentEvent : function(component, event, helper) {
       var selectedAccountGetFromEvent = event.getParam("recordByEvent");
	   component.set("v.selectedRecord" , selectedAccountGetFromEvent);
        if(component.get("v.objectAPIName")==='opportunity'){
            var cmpEvent = component.getEvent("loadCom");
			cmpEvent.setParams({
                "lock" : false,
                "obj": component.get("v.objectAPIName")
            });
            cmpEvent.fire();
        }
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
        var forclose2 = component.find("searchRes");
           $A.util.addClass(forclose2, 'slds-is-close');
           $A.util.removeClass(forclose2, 'slds-is-open');
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');
	},
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();
    },
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();
    },
})
