({
    init: function (cmp, event, helper) {
             cmp.set('v.columns', [
            {label: 'Campaña', fieldName: 'Name', type: 'text'},
            {label: 'FIC', fieldName: 'CRM_WF_FIC__c', type: 'text'},
            {label: 'Fecha inicio de vigencia', fieldName: 'StartDate', type: 'date'},
            {label: 'Fecha fin de vigencia', fieldName: 'EndDate', type: 'date'},
            {label: 'Fecha fin publicación', fieldName: 'MX_WF_Fecha_de_publicacion__c', type: 'date'}
        ]);
        helper.getCampanas(cmp);
    },
    campSelected: function (cmp, event) {

       var selectedRows = event.getParam('selectedRows');
       var inicializar="";
       cmp.set('v.campana_seleccionada', inicializar);
        var resul = cmp.get('v.campana_seleccionada');
        if(selectedRows!==null && selectedRows!=='') {
            resul[0] = selectedRows[0].Id;
            var i;
            for (i=1;i<selectedRows.length;i++) {
                resul.push(selectedRows[i].Id);
            }
            cmp.set('v.campana_seleccionada', resul);
        }
    }
})
