({
	cargarDatos: function(component, event, helper) {
		var clientId = component.get('v.recordId');
		var action0 = component.get('c.getInfoFicha');
		action0.setParams({
			clientId: clientId
		});
		$A.enqueueAction(action0);
	},
	ConstruyeTostadas: function(component) {
		var item = component.find('cmpTotadas');
		$A.createComponent(
			'qvcd:GBL_Carousel_CMP',
			{
				recordId: component.get('{!v.recordId}'),
				nameCards: component.get('{!v.nameCards}'),
				infinite: component.get('{!v.infinite}'),
				cardsToShow: component.get('{!v.cardsToShow}'),
				relationMode: component.get('{!v.relationMode}'),
				showButtonTable: component.get('{!v.showButtonTable}'),
				showButtonAdd: component.get('{!v.showButtonAdd}'),
				onClick: component.get('{!v.onClick}')
			},
			function(cmp) {
				item.set('v.body', cmp);
			}
		);
	}
});
