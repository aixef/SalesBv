({
    init: function (cmp, event, helper) {

        cmp.set('v.columns', [
            {label: 'Nombre corto', fieldName: 'MX_WF_Nombre_Producto__c', type: 'text'},
            {label: 'Nombre detallado del producto', fieldName: 'Name', type: 'text'},
            {label: 'Marca', fieldName: 'MX_WF_Marca__c', type: 'text'},
            {label: 'Tipo de producto', fieldName: 'MX_WF_Producto__c', type: 'text'},
            {label: 'CAT', fieldName: 'MX_WF_CAT__c', type: 'text'},
        ]);

        helper.getCampanas(cmp);
    },

    campSelected: function (cmp, event) {
       var selectedRows = event.getParam('selectedRows');
         var inicializar="";
        cmp.set('v.Tarjetas', inicializar);
        var resul = cmp.get('v.Tarjetas');

        if(selectedRows!==null && selectedRows!=='') {
            resul[0] = selectedRows[0].Id;
            var i;
            for (i=1;i<selectedRows.length;i++) {
                resul.push(selectedRows[i].Id);
            }
            cmp.set('v.Tarjetas', resul);

        }
    }
})
