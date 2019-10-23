({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            {label: 'Comercio', fieldName: 'Name', type: 'text'},
            {label: 'Grupo comercial', fieldName: 'GBL_WF_Grupo_Comercial__r.Name', type: 'text'},
            {label: 'Asesor Comercial', fieldName: 'GBL_WF_Asesor_Comercial__r.GBL_WF_Nombre_Completo__c', type: 'text'},
            {label: 'Squad Journey', fieldName: 'GBL_WF_Squad_Journey__r.GBL_WF_Nombre_Completo__c', type: 'text'},
            {label: 'Squad Producto', fieldName: 'GBL_WF_Squad_Producto__r.GBL_WF_Nombre_Completo__c', type: 'text'}
        ]);
        helper.getCampanas(cmp);
    },
    campSelected: function (cmp, event) {
       var selectedRows = event.getParam('selectedRows');
       var inicializar="";
        cmp.set('v.comercio_seleccionado', inicializar);
        var resul = cmp.get('v.comercio_seleccionado');
        if(selectedRows!==null && selectedRows!=='') {
            resul[0] = selectedRows[0].Id;
            var i;
            for (i=1;i<selectedRows.length;i++) {
                resul.push(selectedRows[i].Id);
            }
            cmp.set('v.comercio_seleccionado', resul);
        }
    }
})
