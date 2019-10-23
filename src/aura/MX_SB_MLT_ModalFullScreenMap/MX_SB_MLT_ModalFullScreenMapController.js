({
   fullScreen : function(component) {
			component.set("v.bModal", true);
   },
     handleCancel: function(component) {
        component.set('v.bModal', false);
    },
})
