({
	afterRender: function (component, helper) {
        this.superAfterRender();
        helper.doAfterRender(component, helper);
    }
})
