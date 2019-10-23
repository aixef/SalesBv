({
    doInit: function(component, event, helper) {
        helper.createTable(component, event, helper);
    },
    addRecordToList : function(component, event, helper) {
        helper.addAccount(component, event, helper);
    },
    handleRowAction : function (cmp, event, helper) {
        var row = event.getParam('row');
        helper.removeAccount(cmp, row)
    },
    clicOnNextButton : function(component,event,helper){
        helper.onNext(component,event,helper);
    },
    clicOnLastButton : function(component,event,helper){
        helper.onLast(component,event,helper);
    },
    clicOnPrevButton : function(component,event,helper){
        helper.onPrev(component,event,helper);
    },
    clicOnIniButton : function(component,event,helper){
        helper.onFirst(component,event,helper);
    },
    carterizar : function(component,event,helper){
        helper.Carterizar(component,event,helper);
    }
})
