({
  handleChange: function(cmp, event, helper) {
    var newValue = cmp.find('detalle').get('v.value');
    cmp.set('v.pkValue', newValue);
  },
});
