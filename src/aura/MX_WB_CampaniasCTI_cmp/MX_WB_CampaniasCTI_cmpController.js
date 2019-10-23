/**
  @Component Name     : MX_WB_CampaniasCTI_cmpController.cmp
  @Description        :
  @Author             :
  @Group              :
  @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
  @Last Modified On   : 26/4/2019 12:07:00
  @Modification Log   :
  ==============================================================================
  Ver         Date                     Author      		      Modification
  ==============================================================================
  1.0    26/4/2019 10:56:46   Arsenio Perez Lopez      Modificacion nuevo modelo
 */
({
	search: function(component, event, helper) {
		var searchField = component.find('searchField');
		var isValueMissing = searchField.get('v.validity').valueMissing;
		if (isValueMissing) {
			searchField.showHelpMessageIfInvalid();
			searchField.focus();
		} else {
			helper.searchHelper(component, event);
		}
	},

	sendCTI: function(component, event, helper) {
		helper.SendCTIHelper(component, event);
	},

	doInit: function(component, event, helper) {
		helper.helperFields(component);
	},

	onSingleSelectChange: function(component, event, helper) {
		var value = component.find('mySelect').get('v.value');

		if (value !== 'None') {
			component.set('v.value', value);
			component.set('v.enableDetail', true);
			component.set('v.enableModal', true);
		}
	},

	closeModal: function(component, event, helper) {
		component.set('v.enableModal', false);
		component.set('v.operatorSelect', 'None');
		component.set('v.valueOperator', '');
	},

	selectChangeOperator: function(component, event, helper) {
		var selectIdOperator = component.find('selectIdOperator').get('v.value');
		component.set('v.valueSelectOperator', selectIdOperator);
	},

	aplicar: function(component, event, helper) {
		var inputFilter = component.get('v.valueOperator');
		var lstFilters = component.get('v.valuesFilter');
		var lstOperators = component.get('v.operators');
		var filter = {};
		component.set('v.selectedOperator', lstOperators[component.get('v.operatorSelect')].value);
		filter.operator = lstOperators[component.get('v.operatorSelect')].value;
		filter.labelOperator = lstOperators[component.get('v.operatorSelect')].label;
		filter.field = component.get('v.value');
		filter.fieldFilter = inputFilter;
		lstFilters.push(filter);
		component.set('v.valuesFilter', lstFilters);
		component.set('v.enableModal', false);
		helper.helperActualiza(component);
		component.set('v.operatorSelect', 'None');
		component.find('mySelect').set('v.value', 'None');
		component.set('v.valueOperator', '');
	},

	clear: function(component, event, helper) {
		var cardFilter = event.getSource();
		var buttonIndex = event.getSource().get('v.name');
		var lstQueries = component.get('v.lstQeryRsult');
		var cadena = '';
		var indexList = 0;
		var index = 0;
		lstQueries.forEach(function(queryStatement) {
			if (queryStatement.iteration === buttonIndex) {
				indexList = index;
			} else {
				cadena += ' ' + queryStatement.query;
			}
			index++;
		});
		lstQueries.splice(indexList, 1);
		component.set('v.lstQeryRsult', lstQueries);
		helper.busqueda(component, cadena);

		if (Array.isArray(cardFilter)) {
			if (cardFilter.length > 1) {
				console.log('Error');
				cardFilter = cardFilter[buttonIndex];
			} else {
				cardFilter = cardFilter[0];
			}
		}
		cardFilter.destroy();
	},
	//Valio madres
	onfocus2: function(component, event, helper) {
		$A.util.addClass(component.find('mySpinner'), 'slds-show');
		var forOpen = component.find('searchRes');
		$A.util.addClass(forOpen, 'slds-is-open');
		$A.util.removeClass(forOpen, 'slds-is-close');
		// Get Default 5 Records order by createdDate DESC
		var getInputkeyWord = '';
		helper.searchHelper2(component, event, getInputkeyWord);
	},
	onblur2: function(component, event, helper) {
		component.set('v.listOfSearchRecords', null);
		var forclose = component.find('searchRes');
		$A.util.addClass(forclose, 'slds-is-close');
		$A.util.removeClass(forclose, 'slds-is-open');
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
			var forclosex = component.find('searchRes');
			$A.util.addClass(forclosex, 'slds-is-close');
			$A.util.removeClass(forclosex, 'slds-is-open');
		}
	},

	// function for clear the Record Selaction
	clear2: function(component, event, heplper) {
		var pillTarget3 = component.find('lookup-pill');
		var lookUpTarget4 = component.find('lookupField');

		$A.util.addClass(pillTarget3, 'slds-hide');
		$A.util.removeClass(pillTarget3, 'slds-show');
		$A.util.addClass(lookUpTarget4, 'slds-show');
		$A.util.removeClass(lookUpTarget4, 'slds-hide');

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
		component.set('v.segmentado2', false);
		helper.searchHelper(component, event);
		var segtemp = component.get('v.enableSegmentado');
		component.set('v.segmentado2', segtemp);
		var forclose = component.find('lookup-pill');
		$A.util.addClass(forclose, 'slds-show');
		$A.util.removeClass(forclose, 'slds-hide');

		var forclose2 = component.find('searchRes');
		$A.util.addClass(forclose2, 'slds-is-close');
		$A.util.removeClass(forclose2, 'slds-is-open');

		var lookUpTarget = component.find('lookupField');
		$A.util.addClass(lookUpTarget, 'slds-hide');
		$A.util.removeClass(lookUpTarget, 'slds-show');
	},
	handleComponentLeadEvent: function(component, event, helper) {
		var SelectDate = event.getParam('DateToLead');
		var SelectBandeja = event.getParam('Bandeja');
		component.set('v.DateLEad', SelectDate);
		component.set('v.Bandeja', SelectBandeja);
	}
});
