({
	doInit : function(component, event, helper) {

        helper.callAction( component, 'c.getFieldLabel', {
            	'objectName' : component.get('v.objectName'),
            	'fieldName'  : component.get('v.fieldName')
        	}, function( data ) {
            component.set('v.label', data);
        });
        helper.callAction( component, 'c.getPicklistOptions', {
            	'objectName' : component.get('v.objectName'),
            	'fieldName'  : component.get('v.fieldName'),
            	'fieldEmpleado' : component.get('v.fieldEmpleado')
        	}, function( data ) {
            component.set('v.options', data);
             helper.callAction( component, 'c.getDataTablero', {
                    'indicador' : component.get('v.options[0].value'),
                    'fieldEmpleado' : component.get('v.fieldEmpleado')
                }, function( data ) {
                component.set('v.objTablero', data);
            });
        });

	},
    onchange:function (component, event, helper){
         helper.callAction( component, 'c.getDataTablero', {
                'indicador' : component.get('v.value'),
                'fieldEmpleado' : component.get('v.fieldEmpleado')
            }, function( data ) {
            component.set('v.objTablero', data);
        });
    }
})
