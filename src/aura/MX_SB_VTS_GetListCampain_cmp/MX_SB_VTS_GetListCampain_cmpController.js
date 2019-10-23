({
	doInit: function(component, event, helper) {
		helper.searchBandejas(component, event);
	},
	closeModal: function(component, event, helper) {
		component.set('v.Descrip', '');
		component.set('v.NameCamp', '');
		component.set('v.IDBandeja', '');
		component.set('v.selectedRecord', '');
		component.set('v.enableModal', false);
	},
	handleClick: function(component, event, helper) {
		component.set('v.enableModal', true);
	},
	handleSubmit: function(component, event, helper) {
		helper.helperBandeja(component, event);
	},
	handleSave: function(component, event, helper) {
		helper.helperBandeja(component, event);
		component.set('v.Descrip', '');
		component.set('v.NameCamp', '');
		component.set('v.IDBandeja', '');
		component.set('v.selectedRecord', '');
		component.set('v.enableModal', false);
	},
	onfocus2: function(component, event, helper) {
		$A.util.addClass(component.find('mySpinner'), 'slds-show');
		var forOpe = component.find('searchRes');
		$A.util.addClass(forOpe, 'slds-is-open');
		$A.util.removeClass(forOpe, 'slds-is-close');
		// Get Default 5 Records order by createdDate DESC
		var getInputkeyWord = '';
		helper.searchHelper2(component, event, getInputkeyWord);
	},
	onblur2: function(component, event, helper) {
		component.set('v.listOfSearchRecords', null);
		var forclos = component.find('searchRes');
		$A.util.addClass(forclos, 'slds-is-close');
		$A.util.removeClass(forclos, 'slds-is-open');
	},
	keyPressController2: function(component, event, helper) {
		// get the search Input keyword
		var getInputkeyWord = component.get('v.SearchKeyWord2');
		// check if getInputKeyWord size id more then 0 then open the lookup result List and
		// call the helper
		// else close the lookup result List part.
		if (getInputkeyWord.length > 0) {
			var forOpen = component.find('searchRes');
			$A.util.addClass(forOpen, 'slds-is-open');
			$A.util.removeClass(forOpen, 'slds-is-close');
			helper.searchHelper2(component, event, getInputkeyWord);
		} else {
			component.set('v.listOfSearchRecords', null);
			var forclose = component.find('searchRes');
			$A.util.addClass(forclose, 'slds-is-close');
			$A.util.removeClass(forclose, 'slds-is-open');
		}
	},
	// function for clear the Record Selaction
	clear2: function(component, event, heplper) {
		var pillTarget = component.find('lookup-pill');
		var lookUpTarget = component.find('lookupField');

		$A.util.addClass(pillTarget, 'slds-hide');
		$A.util.removeClass(pillTarget, 'slds-show');

		$A.util.addClass(lookUpTarget, 'slds-show');
		$A.util.removeClass(lookUpTarget, 'slds-hide');

		component.set('v.SearchKeyWord2', null);
		component.set('v.listOfSearchRecords', null);
		component.set('v.selectedRecord', {});
	},

	// This function call when the end User Select any record from the result list.
	handleComponentEvent: function(component, event, helper) {
		// get the selected Account record from the COMPONETN event
		var selectedAccountGetFromEvent = event.getParam('recordByEvent');
		component.set('v.selectedRecord', selectedAccountGetFromEvent);
		component.set('v.searchKeyword', selectedAccountGetFromEvent.Id);
		var forclose = component.find('lookup-pill');
		$A.util.addClass(forclose, 'slds-show');
		$A.util.removeClass(forclose, 'slds-hide');

		var forclose1 = component.find('searchRes');
		$A.util.addClass(forclose1, 'slds-is-close');
		$A.util.removeClass(forclose1, 'slds-is-open');

		var lookUpTarget = component.find('lookupField');
		$A.util.addClass(lookUpTarget, 'slds-hide');
		$A.util.removeClass(lookUpTarget, 'slds-show');
	},
	handleChange: function(component, event, helper) {
		var Datelead1 = component.get('v.Datelead');
		var Bamdeja1 = component.get('v.Bamdeja');
		var compEvent = component.getEvent('oSelectedLEadEvent');
		compEvent.setParams({ DateToLead: Datelead1 });
		compEvent.setParams({ Bandeja: Bamdeja1 });
		compEvent.fire();
	}
});
