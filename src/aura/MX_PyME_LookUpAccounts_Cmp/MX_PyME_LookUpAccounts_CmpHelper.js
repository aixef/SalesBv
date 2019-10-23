({
    addAccount:function(component, event, helper) {
        var allData = component.get("v.allData");
        var accountSelected = component.get("v.selItem");
        var action = component.get('c.checkDuplicatedRecords');
        action.setParams({
            "allData":allData,
            "accountSelected": accountSelected
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.totalPages", Math.ceil(response.getReturnValue().length/component.get("v.pageSize")));
                component.set("v.allData", response.getReturnValue());
                component.set("v.currentPageNumber",1);
                helper.buildData(component, helper);
                helper.clearSelection(component, event, helper);
                component.set("v.showPagination",true);
            }
        });
        $A.enqueueAction(action);
    },
    createTable : function(component, event, helper) {
        var actions = [{label: 'Eliminar', name: 'delete'}];
        component.set('v.columns', [
            {type: 'action', typeAttributes: { rowActions: actions } } ,
            { label: 'Nombre',fieldName: 'text', type: 'text' },
            { label: 'No. de cliente', fieldName: 'clientNumber',type: 'text' }
        ]);
        helper.buildData(component, helper);
    },
    buildData : function(component, helper) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber-1)*pageSize;
        for(; x < (pageNumber)*pageSize; x++){
            if(allData[x]){
                data.push(allData[x]);
            }
        }
        component.set("v.data", data);
    },
    removeAccount: function (cmp, row) {
        var rows = cmp.get('v.data');
        var allData=cmp.get("v.allData");
        var rowIndex = rows.indexOf(row);
        rows.splice(rowIndex, 1);
        cmp.set('v.data', rows);
        allData.splice(rowIndex, 1);
        cmp.set("v.allData",allData);
    },
    clearSelection: function(component, event, helper){
        component.set("v.selItem",null);
    },
    Carterizar : function(component, event, helper) {
        var allData = component.get("v.allData");
        var userSelected = component.get("v.selItem1");
        var action1 = component.get('c.createCase');
        action1.setParams({
            "allData":JSON.stringify(allData),
            "userSelected":JSON.stringify(userSelected),
            "isObject" : false
        });
        action1.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var message=response.getReturnValue();
                if(message!=null){
                    helper.showToast(component,event,helper,'error','Error',message);
                }else{
                    helper.showToast(component,event,helper,'success','Éxito','Se ha creado el caso correctamente');
                }
            }
        })
        $A.enqueueAction(action1);
    },
    onNext : function(component, event, helper) {
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    onPrev : function(component, event, helper) {
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    processNum : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    onFirst : function(component, event, helper) {
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    onLast : function(component, event, helper) {
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
    showToast : function(component, event, helper, typet, title, msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ title : title, message: msg, duration:' 5000', type: typet });
        toastEvent.fire();
    },
})
