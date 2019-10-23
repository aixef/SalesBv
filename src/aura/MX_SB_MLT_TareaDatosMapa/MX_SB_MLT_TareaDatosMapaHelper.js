({
     initHelper: function(component, event, helper) {
          helper.utilSetMarkers(component, event, helper);
     },
     utilSetMarkers: function(component, event, helper) {
         let markers = [];
          let action = component.get('c.datosMapa');
          action.setParams({'idCase': component.get('v.recordId') });
          action.setCallback(this, function(response) {
               const data = response.getReturnValue();
               let latLong = [];
               latLong = data[0].MX_SB_MLT_URLLocation__c.split(',');
                 markers.push({
                     'location': {
                          'Latitude': latLong[0],
                          'Longitude': latLong[1]
                     },
                     'icon': 'utility:Tower',
                     'title': data[0].MX_SB_MLT_Event__c,
                     'description': data[0].MX_SB_MLT_URLLocation__c,
                     'draggable': true,
                 });
               component.set('v.markersTitle', 'Ubicación del siniestro');
               component.set('v.mapMarkers', markers);
               component.set('v.zoomLevel', 17);
          });
          $A.enqueueAction(action);
     }
});
