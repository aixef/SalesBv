({
   consultaInicial: function(component, event) {
        var recordId = component.get('v.recordId');
        var objectIn = component.get('v.objectIn');
        var fieldReferenceIn = component.get('v.fieldReferenceIn');
        var objectOut = component.get('v.objectOut');
        var fieldOut = component.get('v.fieldOut');
        var fieldName = component.get('v.fielName');
        var action = component.get('c.getField');

        action.setParams({
            'recordId': recordId,
            'objectIn': objectIn,
            'fieldReferenceIn': fieldReferenceIn,
            'objectOut': objectOut,
            'fieldOut': fieldOut
        });

        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var StoreResponse = response.getReturnValue();
                component.set('v.resultado', StoreResponse);
            } else {
                alert('Error en consulta de campo: ' + fieldName);
            }
        });

        $A.enqueueAction(action);
    }
});
