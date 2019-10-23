/**
* -----------------------------------------------------------------------------------------------------------------------------
* @Name         MX_PyME_ServiceCards_ServicesInfo_Cls
* @Author       Selena Yamili Rodriguez Vega  selenayamili.rodriguez.contractor@bbva.component
* @Author       Gabriel Eduardo Garcia Rojas  gabriel.e.garcia@accenture.com
* @Date         Created :  2019-06-28
* @Group        Complement of Controller class for MX_PyME_Credit_Section_Tables_Cmp lightning component
* @Description  Class that implements methods from Controller Class MX_PyME_ServiceCards_Cls to  to fill the PyME Client Tab
* -----------------------------------------------------------------------------------------------------------------------------
**/
public with sharing class MX_PyME_ServiceCards_InfoFicha_Cls {
    /** variable customer*/
    final static String customer='"customerId"';
    /** variable amount */
    final static String monto= 'amount';
    /** variable StatusCode*/
    final static Integer StatusCode=200;
    private MX_PyME_ServiceCards_InfoFicha_Cls() {}
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to call getRiskInformation service
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    callService String that defines if method calls the service or the mock
    * @param    clientNum Number of client
    * @return   Void
    * @example  getRiskInfo('serviceOrMock',clientNum);
    * */
    @future(callout = true)
    public static void getRiskInfo(String callService,String clientNum,id clientId) {
        HttpResponse response;
        final Map<String, Object> jsonReturn;
        response = iaso.GBL_Integration_GenericService.invoke(callService,'{ '+customer+' : "'+clientNum+'"}');
        if (response.getStatusCode() == StatusCode) {
            jsonReturn = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        }
        final Double riesgoPot = (Double)((Map<String, Object>)jsonReturn.get('totalPotential')).get(monto);
        final Double riesgoCom = (Double)((Map<String, Object>)jsonReturn.get('business')).get(monto);
        final Account infoCliente = MX_PyME_ServiceCards_Cls.getAll(clientId);
        infoCliente.MX_PyME_riesgoPot__c = riesgoPot;
        infoCliente.MX_PyME_riesgoCom__c = riesgoCom;
        if(infoCliente != null) {
            upsert infoCliente;
        }
    }

    /*------------------------------------------------------------------------------------------------------
    *@Description Method to call getFinancialSituation service
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    callService String that defines if method calls the service or the mock
    * @param    clientNum Number of client
    * @param    clientId Id of the client(Account)
    * @return   Void
    * @example  getFinancialInfo('serviceOrMock',clientNum,clientId);
    * */
    @future(callout=true)
    public static void getFinancialInfo(String callService, string clientNum, id clientId) {
        HttpResponse response;
        Map<String, Object> jsonReturn;

        response = iaso.GBL_Integration_GenericService.invoke(callService, '{'+customer+' : "'+ clientNum +'"}');
        if (response.getStatusCode() == StatusCode) {
            jsonReturn = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        }

        List<Object> lstServicios = (List<Object>)jsonReturn.get('lstService');
        List<String> serviciosCont = new List<String>();
        String descServicio, cuentaCServicio, servicio;
            for(Integer j = 0; j < lstServicios.size(); j ++) {
                descServicio = (String)((Map<String,Object>)lstServicios.get(j)).get('shortDescription');
                cuentaCServicio = (String)((Map<String,Object>)lstServicios.get(j)).get('indicator');
                servicio=(String)((Map<String,Object>)lstServicios.get(j)).get('id');
                if(cuentaCServicio == 'S' || (cuentaCServicio == 'R' && descServicio.equalsIgnoreCase('ACTIVO'))) {
                    serviciosCont.add(servicio);
                }
           /* if(cuentaCServicio == 'R' && descServicio.equalsIgnoreCase('ACTIVO')) {
                serviciosCont.add(servicio);
            }*/
        }
        getInfoFicha_Servicios(jsonReturn,clientId,serviciosCont);
    }

    /*
     ------------------------------------------------------------------------------------------------------
    *@Description Method  which complements to call getFinancialSituation service
    * -----------------------------------------------------------------------------------------------------
    * @Author   Selena Rodriguez
    * @Author   Gabriel Rojas
    * @Date     2019-07-03
    * @param    jsonReturn Map<String,Object> response of service
    * @param    clientId Id of client
    + @param    serviciosCont List<String> information of Services in method getFinancialSituation
    * @return   Void
    *****************************************************************/
    public static void getInfoFicha_Servicios(Map<String,Object> jsonReturn,id clientId, List<String> serviciosCont) {

        Account dp = MX_PyME_ServiceCards_Cls.getAll(clientId);

        dp = getInfoAccountByJSON(dp,jsonReturn,serviciosCont);

        List<Object> lstProductos = (List<Object>)jsonReturn.get('listfinancialSituation');
        List<String> valQuery= getpicklistIdentificadorServicio('MX_PyME_Balance_Productos__c','MX_PyME_Identificador_servicio__c');
        valQuery.remove(valQuery.indexOf('FISICA'));
        List<MX_PyME_Balance_Productos__c> pr = new List<MX_PyME_Balance_Productos__c>(),pract = [Select id from MX_PyME_Balance_Productos__c where MX_PyME_Cliente__c =:clientId and MX_PyME_Identificador_servicio__c=:valQuery],prdel = new List<MX_PyME_Balance_Productos__c>();
        MX_PyME_Balance_Productos__c prod;
        //String conceptoCredito, indImpago,noCredito, tipoProducto;
        String indImpago;
        //Double saldoDeudor;
        List<String> impagos = new List<String>();
        for(Integer i = 0; i<lstProductos.size(); i++) {
            prod = new MX_PyME_Balance_Productos__c();
            /*conceptoCredito = (String)((Map<String, Object>)((Map<String, Object>)
            ((Map<String, Object>)lstProductos.get(i)).get('loan')).get('loanBase')).get('productDescription');
            saldoDeudor = (Double)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)lstProductos.get(i)).
            get('balance')).get('debitBalance')).get(monto);
            noCredito = (String)((Map<String, Object>)((Map<String, Object>)lstProductos.get(i)).get('balance')).get('creditNumber');
            tipoProducto = (String)((Map<String, Object>)((Map<String, Object>)lstProductos.get(i)).get('fiscalPersonality')).get('type');*/
            indImpago = (String)((Map<String, Object>)((Map<String, Object>)lstProductos.get(i)).get('loan')).get('impactIndicator');
            impagos.add(indImpago);
            prod.MX_PyME_Cliente__c = clientId;
            prod.MX_PyME_Concepto_Credito__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)lstProductos.get(i)).get('loan')).get('loanBase')).get('productDescription');
            prod.MX_PyME_Saldo_deudor__c = (Double)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)lstProductos.get(i)).get('balance')).get('debitBalance')).get(monto);
            prod.MX_PyME_Indicador_impago__c =indImpago;
            prod.MX_PyME_prodNumero_credito__c =(String)((Map<String, Object>)((Map<String, Object>)lstProductos.get(i)).get('balance')).get('creditNumber');
            prod.MX_PyME_Tipo_producto__c = (String)((Map<String, Object>)((Map<String, Object>)lstProductos.get(i)).get('fiscalPersonality')).get('type');
            pr.add(prod);
        }
        /*for(MX_PyME_Balance_Productos__c balact : pract) {
            if(!pr.contains(balact)) {
                prdel.add(balact);
            }
        }
        dp.MX_PyME_Tiene_impagos__c = impagos.contains('S') ? true : false;
        if(dp != null) {
            Upsert dp;
        }
        if(!prdel.isEmpty()) {
            delete prdel;
        }
        if(!pr.isEmpty()) {
            Upsert pr MX_PyME_prodNumero_credito__c;
        }*/

        prdel.addAll(pract);
        dp.MX_PyME_Tiene_impagos__c = impagos.contains('S') ? true : false;
        Upsert dp;
        if(!prdel.isEmpty()) {
            delete prdel;
        }
        if(!pr.isEmpty()) {
            Upsert pr MX_PyME_prodNumero_credito__c;
        }
        TostadaCredito(clientId);
        sumOtrosCreditos(clientId);
}
/******************************************************
*/
public static Account getInfoAccountByJSON(Account acc, Map<String,Object> jsonReturn, List<String> serviciosCont) {
    Account dp = acc;
    List<Object> lstProd = (List<Object>)jsonReturn.get('lstProduct');
    Map<String, Object>  vista = (Map<String, Object>) lstProd.get(0);
    Map<String, Object>  plazo = (Map<String, Object>) lstProd.get(1);
    Map<String, Object>  fondos = (Map<String, Object>) lstProd.get(2);
    dp.MX_PyME_Porcentaje_de_credito__c = (Double)((Map<String, Object>)((Map<String, Object>)jsonReturn.get('financialSituation')).get('loan')).get('percentageCredit');
    dp.MX_PyME_Monto_total_creditos__c = (Double)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)jsonReturn.get('financialSituation')).get('loan')).get('totalCredit')).get(monto);
    dp.MX_PyME_Porcentaje_Captacion__c = (Double)((Map<String, Object>)((Map<String, Object>)jsonReturn.get('financialSituation')).get('balance')).get('percentageCaption');
    dp.MX_PyME_Monto_total_Captacion__c = (Double)((Map<String, Object>)((Map<String, Object>)((Map<String,Object>)jsonReturn.get('financialSituation')).get('balance')).get('totalBalance')).get(monto);
    dp.MX_PyME_Vista_Saldo_diario__c = (Double)((Map<String, Object>)((Map<String, Object>)vista.get('balance')).get('balanceDaily')).get(monto);
    dp.MX_PyME_Vista_Saldo_mAnterior__c = (Double)((Map<String, Object>)((Map<String, Object>)vista.get('balance')).get('balancePreviousMonth')).get(monto);
    dp.MX_PyME_Vista_Saldo_variacion__c = (Double)((Map<String, Object>)((Map<String, Object>)vista.get('balance')).get('balanceVariation')).get(monto);
    dp.MX_PyME_Plazo_Saldo_diario__c = (Double)((Map<String, Object>)((Map<String, Object>)plazo.get('balance')).get('balanceDaily')).get(monto);
    dp.MX_PyME_Plazo_Saldo_mes_anterior__c = (Double)((Map<String, Object>)((Map<String, Object>)plazo.get('balance')).get('balancePreviousMonth')).get(monto);
    dp.MX_PyME_Plazo_Saldo_variacion__c = (Double)((Map<String, Object>)((Map<String, Object>)plazo.get('balance')).get('balanceVariation')).get(monto);
    dp.MX_PyME_Fondos_Saldo_diario__c = (Double)((Map<String, Object>)((Map<String, Object>)fondos.get('balance')).get('balanceDaily')).get(monto);
    dp.MX_PyME_Fondos_Saldo_mes_anterior__c = (Double)((Map<String, Object>)((Map<String, Object>)fondos.get('balance')).get('balancePreviousMonth')).get(monto);
    dp.MX_PyME_Fondos_Saldo_variacion__c =(Double)((Map<String, Object>)((Map<String, Object>)fondos.get('balance')).get('balanceVariation')).get(monto);
    Map<String, String> mapServiciosCont = new Map<String, String>();
    mapServiciosCont.put('TPVS','MX_PyME_prod_TPV__c');
    mapServiciosCont.put('SEGR','MX_PyME_tiene_seguros__c');
    mapServiciosCont.put('BCOM','MX_PyME_tiene_BCOM__c');
    mapServiciosCont.put('CRTC','MX_PyME_prod_cartaCredito__c');    
    for(String fieldDp :  mapServiciosCont.keySet()) {
        if(serviciosCont.contains(fieldDp)) {
            dp.put(mapServiciosCont.get(fieldDp),true);
        }else {
            dp.put(mapServiciosCont.get(fieldDp),false);
        }
    }
    /*
    dp.MX_PyME_prod_TPV__c = serviciosCont.contains('TPVS') ? True : False;
    dp.MX_PyME_tiene_seguros__c = serviciosCont.contains('SEGR') ? True : False;
    dp.MX_PyME_tiene_BCOM__c = serviciosCont.contains('BCOM') ? True : False;
    dp.MX_PyME_prod_cartaCredito__c = serviciosCont.contains('CRTC') ? True : False;
	*/
    return dp;
}

    /*------------------------------------------------------------------------------------------------------
    *@Description Method to  get List String from Schema Describe
    * -----------------------------------------------------------------------------------------------------
    * @Author   Selena Rodriguez
    * @Author   Gabriel Rojas
    * @Date     2019-07-02
    * @param    sobject_Type catch the object we want to search
    * @param    sobject_Field catch the field we want to search in the object
    * @return   String
    * @example  getpicklistIdentificadorServicio(Account,Type);
    * */

    public static List<String> getpicklistIdentificadorServicio(String sobject_Type,String sobject_Field) {
        List<String> listValuePl = new List<String>();
        try {
            Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(sobject_Type).getDescribe().fields.getMap().get(sobject_Field).getDescribe();
            List<Schema.PicklistEntry> listPle = fieldResult.getPicklistValues();
            System.debug('descResult ' + listPle);
            for(Schema.PicklistEntry plv : listPle) {
                listValuePl.add(plv.getValue());
            }
            System.debug('listValuePl ' + listValuePl);
            return listValuePl;
        }catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to call getProfitability service
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    callService String that defines if method calls the service or the mock
    * @param    clientNum Number of client
    * @return   Void
    * @example  getProfitabilityInfo('serviceOrMock',clientNum);
    * */
    @future(callout=true)
    public static void getProfitabilityInfo(String callService, String clientNum, id clientId) {
        Map<String, Object> jsonReturn;
        HttpResponse response;

        response = iaso.GBL_Integration_GenericService.invoke(callService, '{'+customer+' : "'+clientNum+'"}');
        if (response.getStatusCode() == StatusCode) {
            jsonReturn = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        }
        Double BAI = (Double)((Map<String, Object>)((Map<String, Object>)jsonReturn.get('customerTotalAmount')).get('customerToBankProfitability')).get(monto);
        Double baiSegmento = Double.valueOf(jsonReturn.get('averageBai'));
        Double margenFinanciero = (Double)((Map<String, Object>)((Map<String, Object>)jsonReturn.get('customerTotalAmount')).get('customerFinancialMargin')).get(monto);
        Double comisiones = (Double)((Map<String, Object>)((Map<String, Object>)jsonReturn.get('customerTotalAmount')).get('customerCommissions')).get(monto);
        Double gastos = (Double)((Map<String, Object>)((Map<String, Object>)jsonReturn.get('customerTotalAmount')).get('customerExpenses')).get(monto);
        Double saneamiento = (Double)((Map<String, Object>)((Map<String, Object>)jsonReturn.get('customerTotalAmount')).get('customerSanity')).get(monto);
        //Integer indicadorIVAN = Integer.valueOf(jsonReturn.get('customerLinkToBankIndicator'));
        Integer noAfiliados = (Integer)jsonReturn.get('totalEmployeesPayrollDispersion');
        String matrizVinculacion = (String)((Map<String, Object>)jsonReturn.get('customerTotalAmount')).get('customerProfitabilitySegment');
        String desRentCliente = (String)jsonReturn.get('description');
        String claveNomina = (String)jsonReturn.get('payrollKey');
        Double dispNomina = Double.valueOf(jsonReturn.get('payrollDispersionRate'));
        Double impFlujoEfectivo = Double.valueOf(((Map<String, Object>)jsonReturn.get('customerTotalAmount')).get('totalCashDescription'));
        String tieneNomina = String.valueOf(jsonReturn.get('isPayrollCustomer'));
        Account pf=MX_PyME_ServiceCards_Cls.getAll(clientId);
        pf.MX_PyME_BAI_Cliente__c = BAI;
        pf.MX_PyME_BAI_Segmento__c = baiSegmento;
        pf.MX_PyME_Margen_Financiero__c = margenFinanciero;
        pf.MX_PyME_Comisiones__c = comisiones;
        pf.MX_PyME_Gasto__c = gastos;
        pf.MX_PyME_Saneamiento__c = saneamiento;
        //pf.MX_PyME_Indicador_Ivan__c = indicadorIVAN;
        pf.MX_PyME_Afiliados__c = noAfiliados;
        pf.MX_PyME_Matriz_vinculacion__c = matrizVinculacion;
        pf.MX_PyME_Rentabilidad_cliente__c = desRentCliente;
        pf.MX_PyME_Clave_Nomina__c = claveNomina;
        pf.MX_PyME_Dispersion_nomina__c = dispNomina;
        pf.MX_PYME_Flujo_de_Efectivo__c = impFlujoEfectivo;
        pf.MX_PyME_prod_nomina__c=tieneNomina == 'S' ? True : False;
        //if(pf != null) {
            upsert pf;
        //}
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to call getServiceInformation service with serviceId=FISICA
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    callService String that defines if method calls the service or the mock
    * @param    clientId Id of client
    * @param    numCliente Number of client
    * @return   Void
    * @example  getServiceInformation('serviceOrMock',clientId,clientNum);
    * */
    @future(callout = true)
    public static void getServiceInfoFISICA(String callService, Id clientId, string clientNum) {
        List<MX_PyME_Balance_Productos__c> deleteOC = [Select MX_PyME_Descripcion_servicio__c,MX_PyME_Saldo_del_servicio__c From MX_PyME_Balance_Productos__c Where MX_PyME_Cliente__c= : clientId And MX_PyME_Identificador_servicio__c='FISICA']; 
        HttpResponse responseOC;
        Map<String, Object> jsonReturnOC;

        responseOC = iaso.GBL_Integration_GenericService.invoke(callService, '{'+customer+' : "'+clientNum+'","serviceId" : "FISICA"}');
        if (responseOC.getStatusCode() == StatusCode) {
            jsonReturnOC = (Map<String, Object>)JSON.deserializeUntyped(responseOC.getBody());
        }
        if(!deleteOC.isEmpty()) {
            delete deleteOC;
        }
        MX_PyME_ServiceCards_Cls.updateDataServices(jsonReturnOC,'FISICA',clientId);
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method that updates the sum of credit amounts
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    credito String that defines the credit type (TN,TDMN,OTROS CREDITOS)
    * @param    clientId Id of client
    * @return   Void
    * @example  TostadaCredito('credit',clientId);
    * */
    public static void TostadaCredito(id idClient) {
        List<Double> resultado = new List<Double>{0.0,0.0,0.0};
        Account acc = MX_PyME_ServiceCards_Cls.getAll(idClient);

        /*sumTDCNegocio*/
        String query1 = 'SELECT MX_PyME_Saldo_deudor__c FROM MX_PyME_Balance_Productos__c WHERE MX_PyME_Tipo_producto__c=\'A\' AND MX_PyME_Concepto_Credito__c LIKE \'%TDC NEGOCIOS%\' AND MX_PyME_Cliente__c= : idClient';
        /*sumCreditoSimple*/
        String query2 = 'SELECT MX_PyME_Saldo_deudor__c FROM MX_PyME_Balance_Productos__c WHERE MX_PyME_Tipo_producto__c=\'B\' AND MX_PyME_Cliente__c= : idClient';
        /*sumTDCMicroNeg*/
        String query3 = 'SELECT MX_PyME_Saldo_deudor__c FROM MX_PyME_Balance_Productos__c WHERE MX_PyME_Tipo_producto__c=\'A\' AND MX_PyME_Concepto_Credito__c LIKE \'%TDC MICRO%\' AND MX_PyME_Cliente__c= : idClient';

        List<List<MX_PyME_Balance_Productos__c>> lstCreditos=new List<List<MX_PyME_Balance_Productos__c>>();
        List<MX_PyME_Balance_Productos__c> listBP1 = Database.query(query1);
        List<MX_PyME_Balance_Productos__c> listBP2 = Database.query(query2);
        List<MX_PyME_Balance_Productos__c> listBP3 = Database.query(query3);
        lstCreditos.add(listBP1);
        lstCreditos.add(listBP2);
        lstCreditos.add(listBP3);

        for(Integer i=0;i<resultado.size() ;i++) {
            for(MX_PyME_Balance_Productos__c cr : lstCreditos[i]) {
                resultado[i] = resultado[i]+cr.MX_PyME_Saldo_deudor__c;
            }
        }
        acc.MX_PyME_Total_TDC_Negocios__c = resultado[0];
        acc.MX_PyME_Total_Credito_Simple__c = resultado[1];
        acc.MX_PyME_Total_TDC_Micro_Negocio__c = resultado[2];

        upsert acc;
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method that updates the sum of OTROS CREDITOS
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    clientId Id of client
    * @return   Void
    * @example  sumOtrosCreditos(clientId);
    * */
    public static void sumOtrosCreditos(id idClient) {
        List<MX_PyME_Balance_Productos__c > otCred = [Select MX_PyME_Saldo_del_servicio__c from MX_PyME_Balance_Productos__c where MX_PyME_Cliente__c= : idClient and MX_PyME_Identificador_servicio__c='FISICA'];
        Double totalOtrosCreditos = 0;
        for(MX_PyME_Balance_Productos__c oc  : otCred) {
            totalOtrosCreditos = totalOtrosCreditos + oc.MX_PyME_Saldo_del_servicio__c;
        }
        Account otc = MX_PyME_ServiceCards_Cls.getAll(idClient);
        otc.MX_PyME_Total_Otros_Creditos__c = totalOtrosCreditos;
        //if(otc != null) {
            upsert otc;
        //}
    }
}