({
    buildUrl : function(component, event, helper, quoteId) {
        var action = component.get("c.crearURL");
        action.setParams( { 'quoteId': quoteId } );
        action.setCallback( this, function(response) {
            var state = response.getState();
            if ( state === "SUCCESS" ) {
                if ( response.getReturnValue() !== 'SINPRODUCTO' ) {
                    component.set( 'v.urlCoti', response.getReturnValue() )
                    component.set( 'v.blShowProdLst', false);
                    component.set( 'v.blShowUrl', true);
                    component.set( 'v.blShowError', false);
                } else if ( response.getReturnValue() === 'SINPRODUCTO' ) {
                    helper.fetchProducts(component, event);
                }
            } else if ( state === "ERROR" ) {
                component.set( 'v.blShowProdLst', false);
                component.set( 'v.blShowUrl', false);
                component.set( 'v.blShowError', true);
                component.set( 'v.msjError', $A.get("{!$Label.c.MX_WB_CL_CotizadorError}"));
            }
        });
        $A.enqueueAction( action );
    },

    fetchProducts : function( component, helper, oppValues, responseOpp ) {

        var action = component.get("c.fetchProductsLst");
        action.setParams( { 'idOppor': component.get( 'v.recordId' ) } );
        action.setCallback( this, function(response) {
            var state = response.getState();
            if(state === 'ERROR') {
                var errors = response.getError();
                this.manageErrors(component, true, errors[0].message);
            }
            else if( state === 'SUCCESS' ) {

                this.processProductList(component, helper, oppValues, responseOpp, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    processProductList : function(component, helper, oppValues, responseOpss, responseListProds) {

        if( responseOpss.recordOutBound === oppValues.RecordTypeId ) {
            if ( responseListProds.lstProdOut.length > 0 ) {
                component.set( 'v.blShowProdLst', true);
                component.set( 'v.lstProd', responseListProds.lstProdOut);
            } else {
                this.manageErrors(component, true, $A.get("{!$Label.c.MX_SB_VTS_ProductosNoActivos}"));
            }
        } else if (responseOpss.recordInBound === oppValues.RecordTypeId) {
            helper.validOrigin(component, helper, oppValues, responseOpss, responseListProds);
        }
    },
    addProductHlp : function(component, event, helper) {
        var action = component.get("c.addProduct");
        action.setParams( { 'idOpporWanted': component.get( 'v.recordId' ),
                           'strProdName': component.find("selProd").get("v.value") } );
        action.setCallback( this, function(response) {
            var state = response.getState();
            if(state === 'ERROR') {
                var errors = response.getError();
                if ( errors[0] && errors[0].message ) {
                    this.manageErrors(component, true, errors[0].message);
                }
            }
            else if( state === 'SUCCESS' ) {
                if (response.getReturnValue() === false) {
                    component.set( 'v.blShowError', true);
                } else {
                    $A.get('e.force:refreshView').fire();
                }
            }
        });
        $A.enqueueAction(action);
    },

    findQuotes : function(component, event, helper, oppValues) {
        var action = component.get("c.initDataQuotes");
        action.setParams( { 'oppVals': JSON.stringify(oppValues)} );
        action.setCallback( this, function(response) {
            var state = response.getState();
            if(state === 'ERROR') {
                this.manageErrors(component,false,errors[0].message);
            }
            else if( state === 'SUCCESS' ) {
                this.processResponse(component, event, helper, oppValues, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    processResponse : function(component, event, helper, oppValues, response) {
        var recordT = response.recordObject;
        if (response.recordInBound === oppValues.RecordTypeId || recordT.DeveloperName === 'MX_SB_VTS_Telemarketing') {
            if($A.util.isEmpty(oppValues.MX_SB_VTS_OppCase__c) && $A.util.isEmpty(oppValues.Caso_Relacionado__c)) {
                this.manageErrors(component,false,'');
                this.evalueteforInbound(component, event, helper, oppValues, response);
            } else if ((!($A.util.isEmpty(oppValues.MX_SB_VTS_OppCase__c)) ||
                !($A.util.isEmpty(oppValues.Caso_Relacionado__c)))
                && oppValues.Origen__c === $A.get("{!$Label.c.MX_SB_VTS_SAC_LBL}")){
                this.manageErrors(component,false,'');
                this.evalueteforSAC(component, event, helper, oppValues, response);
            }
        }else if(response.recordOutBound === oppValues.RecordTypeId) {
            var lstQuotes = response.lstQuotes;
            if(lstQuotes.length > 0) {
                component.set( 'v.blShowProdLst', false);
                this.buildUrl(component, event, helper, lstQuotes[0].Id);
            }else {
                this.fetchProducts(component, helper, oppValues, response);
            }
        }
    },
    manageErrors : function (component, error, msjsError) {
        component.set( 'v.blShowError', error);
        component.set( 'v.msjError', msjsError);
    },
    evalueteforSAC: function (component, event, helper, oppValues, response) {
        var lstQuotes = response.lstQuotes;
        var lstCase = response.lstCase;
        if(lstQuotes.length > 0 && lstCase.length > 0) {
            this.buildUrl(component, event, helper, lstQuotes[0].Id);
        }else {
            if(lstCase.length > 0) {
                var oppValues2 = JSON.stringify(oppValues);
                var oppValues22 = JSON.parse(oppValues2);
                    oppValues22.Producto__c = lstCase[0].Product.Name;
                this.addProductInbound(component, helper, oppValues2, oppValues22.Producto__c);
            }
        }
    },
    evalueteforInbound : function(component, event, helper, oppValues, response) {

        var lstQuotes = response.lstQuotes;
        if (lstQuotes.length > 0) {
            this.buildUrl(component, event, helper, lstQuotes[0].Id);
            this.fetchProducts(component, helper, oppValues, response);
        } else {
            if (!($A.util.isEmpty(oppValues.Producto__c))) {
                this.addProductInbound(component, helper, oppValues, oppValues.Producto__c);
            }
        }
    },
    validQuotes : function(component, event, helper) {
        var oppValues = component.get('v.genericRecord');
        if (oppValues.StageName === 'Prospecting' || oppValues.StageName === $A.get("{!$Label.c.MX_SB_VTS_COTIZACION_LBL}")) {
            this.findQuotes(component, event, helper,oppValues);
        } else {
            this.manageErrors(component, true, $A.get("{!$Label.c.MX_SB_VTS_OportunidadCerradaCotiza}"));
        }
    },
    addProductInbound : function(component, helper, oppValues, producto) {
        var action = component.get("c.addProductInbound");
        action.setParams( { 'idOpporWanted': component.get( 'v.recordId' ),
                           'strProdName': producto } );
        action.setCallback( this, function(response) {
            var state = response.getState();
            if(state === 'ERROR') {
                var errors = response.getError();
                if ( errors[0] && errors[0].message ) {
                    this.manageErrors(component, true, errors[0].message);
                }
            }
            else if( state === 'SUCCESS' ) {
                if (response.getReturnValue() === false) {
                    component.set( 'v.blShowError', true);
                } else {
                    $A.get('e.force:refreshView').fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    buildUrlbyNumber : function(component, event, helper) {
        var action = component.get("c.crearURLCotNum");
        component.set( 'v.blShowUrl', false);
        action.setParams( { 'quoteNumber': event.getParam("FolioCotizacion")});
        action.setCallback( this, function(response) {
            var state = response.getState();
            if ( state === "SUCCESS" ) {
                component.set( 'v.urlCoti', response.getReturnValue() )
                component.set( 'v.blShowProdLst', false);
                component.set( 'v.blShowUrl', true);
                component.set( 'v.blShowError', false);
            } else if ( state === "ERROR" ) {
                component.set( 'v.blShowError', true);
                component.set( 'v.msjError', $A.get("{!$Label.c.MX_WB_CL_CotizadorError}"));
            }
        });
        $A.enqueueAction( action );
    },
    validOrigin : function(component, helper, oppValues, responseOpss, responseListProds) {
        var originOpp = oppValues.LeadSource;
        switch(originOpp){
            default: break;
            case 'Inbound':
                if( responseListProds.lstAllProd.length > 0 ) {
                    component.set( 'v.lstProd', responseListProds.lstAllProd);
                    component.set( 'v.blShowProdLst', true);
                } else {
                    this.manageErrors(component, true, $A.get("{!$Label.c.MX_SB_VTS_ProductosNoActivos}"));
                }
            break;
            case 'Call me Back':
            case 'Tracking Web':
                if(responseOpss.lstcontract.length > 0) {
                    if( responseListProds.lstAllProd.length > 0 ) {
                        component.set( 'v.lstProd', responseListProds.lstAllProd);
                        component.set( 'v.blShowProdLst', true);
                    } else {
                        this.manageErrors(component, true, $A.get("{!$Label.c.MX_SB_VTS_ProductosNoActivos}"));
                    }
                } else {
                    if( responseListProds.lstAllProdFam.length > 0 ) {
                        component.set( 'v.lstProd', responseListProds.lstAllProdFam);
                        component.set( 'v.blShowProdLst', true);
                    } else {
                        this.manageErrors(component, true, $A.get("{!$Label.c.MX_SB_VTS_ProductosNoActivos}"));
                    }
                }
            break;
        }
    }
})
