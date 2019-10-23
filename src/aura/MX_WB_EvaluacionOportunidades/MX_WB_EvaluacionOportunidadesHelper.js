({
	getOpportunities : function(component) {
		var getOpps = component.get("c.getOpportunities");
        getOpps.setCallback(this, function(response){
            var result = response.getReturnValue();
            if(result != null){
                component.set("v.oppRecords",result);
                component.set("v.oppRecordsFiltered",result);
            }
        });
        $A.enqueueAction(getOpps);
        var columnsWidths = this.getColumnWidths();
        var columns = [{label:'Nombre oportunidad', fieldName:'Name', type:'text', sortable:true},
                {label:'Folio Grabación', fieldName:'FolioCotizacion__c', type:'text', sortable:true},
                {label:'Estatus', fieldName:'StageName', type:'text', sortable:true},
                {label:'Fecha cierre', fieldName:'CloseDate', type:'date', sortable:true},
                {label:'Evaluación', fieldName:'MX_WB_EvaluacionCalidad__c', type:'text', sortable:true},
                {type :'button', initialWidth:80, typeAttributes:{iconName:'utility:new_window', name:'verModal', title:'Realizar encuesta'}}];

        if (columnsWidths.length === columns.length) {
            columns.map(function (col, index) {
                return Object.assign(col, { initialWidth: columnsWidths[index] });
            });
        }
        component.set('v.columns', columns);
	},

    sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.oppRecordsFiltered");
        var reverse = sortDirection !== 'asc';
        data = Object.assign([],
            data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
        );
        component.set("v.oppRecordsFiltered", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer
            ? function(x) { return primer(x[field]) }
            : function(x) { return x[field] };
        return function (a, b) {
            var A = key(a);
            var B = key(b);
            return reverse * ((A > B) - (B > A));
        };
    },

    getColumnWidths: function () {
        var widths = localStorage.getItem('datatable-in-action');
        try {
            widths = JSON.parse(widths);
        } catch(e) {
            return [];
        }
        return Array.isArray(widths) ? widths : [];
    },

    filterValues : function (component){
        var records = component.get("v.oppRecords");
        var wrapperEntries = {};
        wrapperEntries.nameFilter = component.get("v.filterByName");
        wrapperEntries.folioFilter= component.get("v.filterByFolio");
        wrapperEntries.typeFilter = component.get("v.filterByType");
        var wrapperBEntries = {};
        wrapperBEntries.booleanName = wrapperEntries.nameFilter.length > 1 ? true : false;
        wrapperBEntries.booleanFolio= wrapperEntries.folioFilter.length > 1 ? true : false;
        wrapperBEntries.booleanType = wrapperEntries.typeFilter !== '' ? true: false;
        var self = this;
        var recordsFiltered = [];
        records.forEach(function(record) {
            var reviewedBooleans = self.checkRecordsFilter(record, wrapperBEntries,wrapperEntries);

            if(reviewedBooleans.bname && reviewedBooleans.bfolio && reviewedBooleans.btype){
            	recordsFiltered.push(record);
            }
        });
        component.set('v.oppRecordsFiltered',recordsFiltered);
    },

    checkRecordsFilter : function(record, wrapperBEntries,wrapperEntries){
        var wrapperBooleans = {};
        wrapperBooleans.bname = true;
        wrapperBooleans.bfolio = true;
        wrapperBooleans.btype = true;
        if(wrapperBEntries.booleanName && !record.Name.toUpperCase().includes(wrapperEntries.nameFilter.toUpperCase())){
            wrapperBooleans.bname = false;
        }
        if(wrapperBEntries.booleanFolio && record.FolioCotizacion__c === undefined){
            wrapperBooleans.bfolio = false;
        }else if(wrapperBEntries.booleanFolio && record.FolioCotizacion__c !== undefined &&
            !record.FolioCotizacion__c.toUpperCase().includes(wrapperEntries.folioFilter.toUpperCase())){
            wrapperBooleans.bfolio = false;
        }

        if(wrapperBEntries.booleanType && record.StageName !== wrapperEntries.typeFilter){
            wrapperBooleans.btype = false;
        }
        return wrapperBooleans;
    }
})
