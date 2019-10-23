/**
* ------------------------------------------------------------------------------------------------
* @Name         MX_PyME_ServiceCards_Cls
* @Author       BBVA
* @Date         Created :  2019-02-11
* @Group        Controller class for MX_PyME_Credit_Section_Tables_Cmp lightning component
* @Description  Class that implements calls to services to fill the PyME Client Tab
* @Changes      (most recent first)
*  |2019-02-11  First version
*  |2019-02-18  Added equalsIgnoreCase to campare string    Daniel García
*  |2019-02-21  Modified query in getFinancialInfo          Ricardo Almanza
*  |2019-06-28  Extracted three methods for optimization    Selena Rodriguez, Gabriel Rojas
*               getServicesInfoCTRC, getServicesInfoTPVS
*               getServicesInfoSeguros all of them were
*               added in MX_PyME_ServiceCards_ServicesInfo_Cls
*  |2019-06-28  Modified method getServices                 Selena Rodriguez, Gabriel Rojas
* ------------------------------------------------------------------------------------------------
*/
public with sharing class MX_PyME_ServiceCards_Cls {
    private MX_PyME_ServiceCards_Cls() {}
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to get data from Account
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    clientId Id of the client(Account)
    * @return   Account record
    * @example  String clientNum = getAll(clientId).No_de_cliente__c;
    * */
    public static Account getAll(Id clientId) {
        return [Select Name,No_de_cliente__c,MX_PyME_Comisiones__c,MX_PYME_Flujo_de_Efectivo__c,MX_PyME_Indicador_Ivan__c,MX_PyME_Rentabilidad_cliente__c,MX_PyME_Dispersion_nomina__c,MX_PyME_Clave_Nomina__c,MX_PyME_Matriz_vinculacion__c,MX_PyME_Saneamiento__c,MX_PyME_Afiliados__c,MX_PyME_Gasto__c,MX_PyME_Total_TDC_Micro_Negocio__c,MX_PyME_Total_TDC_Negocios__c,MX_PyME_Total_Credito_Simple__c,MX_PyME_Total_Otros_Creditos__c,MX_PyME_prod_cartaCredito__c,MX_PyME_tiene_seguros__c,MX_PyME_prod_TPV__c,MX_PyME_Vista_Saldo_diario__c,MX_PyME_Vista_Saldo_mAnterior__c,MX_PyME_Vista_Saldo_variacion__c,MX_PyME_Plazo_Saldo_diario__c,MX_PyME_Plazo_Saldo_mes_anterior__c,MX_PyME_Plazo_Saldo_variacion__c,MX_PyME_Fondos_Saldo_diario__c,MX_PyME_Fondos_Saldo_mes_anterior__c,MX_PyME_Fondos_Saldo_variacion__c,MX_PyME_prod_nomina__c,MX_PyME_BAI_Cliente__c,MX_PyME_BAI_Segmento__c,MX_PyME_Margen_Financiero__c,MX_PyME_riesgoPot__c,MX_PyME_riesgoCom__c,MX_PyME_Porcentaje_de_credito__c,MX_PyME_Monto_total_creditos__c,MX_PyME_Porcentaje_Captacion__c,MX_PyME_Monto_total_Captacion__c,MX_PyME_tiene_BCOM__c,MX_PyME_Tiene_impagos__c From Account where Id= : clientId];
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to call services when Client Tab is reloaded
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    clientId Id of the client(Account)
    * @return   Void
    * @example  var action0 = component.get('c.getInfoFicha');
    * */
    @AuraEnabled
    public static void getInfoFicha(Id clientId) {
        try {
            String riskserv,fnserv,pfserv,svinfserv;
            final String clientNum = getAll(clientId).No_de_cliente__c;
            if (test.isRunningTest()) { riskserv='getRiskInformationMock';} else {riskserv='getRiskInformation';}
            MX_PyME_ServiceCards_InfoFicha_Cls.getRiskInfo(riskserv ,clientNum, clientId);
            if(test.isRunningTest()) {fnserv='getFinancialSituationMock';} else {fnserv='getFinancialSituation';}
            MX_PyME_ServiceCards_InfoFicha_Cls.getFinancialInfo(fnserv, clientNum, clientId);
            if(test.isRunningTest()) {pfserv='getProfitabilityMock';} else {pfserv='getProfitability';}
            MX_PyME_ServiceCards_InfoFicha_Cls.getProfitabilityInfo(pfserv, clientNum, clientId);
            if(test.isRunningTest()) {svinfserv='getServiceMockSEGR';} else {svinfserv='getServiceInformation';}
            MX_PyME_ServiceCards_InfoFicha_Cls.getServiceInfoFISICA(svinfserv, clientId, clientNum);
            } catch(Exception e) {
                throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
            }
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to call getBalanceDetail service
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    callService String that defines if method calls the service or the mock
    * @param    clientId Id of the client
    * @param    noContract Number of credit or card related to the client
    * @return   Void
    * @example  getBalanceInfo('serviceOrMock',clientId,numContract);
    * */
    public static void getBalanceInfo(String callService, Id clientId, String noContract) {
        final String numCliente = getAll(clientId).No_de_cliente__c;
        final String Prestamo='loan';
        HttpResponse response;
        Map<String, Object> jsonReturn;

        response = iaso.GBL_Integration_GenericService.invoke(callService, '{"customerId" : "'+numCliente+'","contractNum" : "'+noContract+'"}');
        if (response.getStatusCode() == 200) {
            jsonReturn = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        }
        final List<Object> listBalance = (List<Object>)jsonReturn.get('listBalance');
        final List<MX_PyME_Detalle_productos__c> detalleProd = new List<MX_PyME_Detalle_productos__c>();
        MX_PyME_Detalle_productos__c prod;
        Double saldoOtorgado, porcUso, compras;
        Integer noImpagos, amortizaciones;
        String noTarjeta;
        final MX_PyME_Balance_Productos__c[] parProd =  [Select Id,Name from MX_PyME_Balance_Productos__c where MX_PyME_prodNumero_credito__c= : noContract limit 1];
        for(Integer lb = 0; lb<listBalance.size(); lb++) {
            prod = new MX_PyME_Detalle_productos__c();
            saldoOtorgado = (Double)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)listBalance.get(lb)).get(Prestamo)).get('balanceGranted')).get('amount');
            porcUso = (Double)((Map<String, Object>)((Map<String, Object>)listBalance.get(lb)).get(Prestamo)).get('usePercentage');
            noImpagos = (Integer)((Map<String, Object>)((Map<String, Object>)listBalance.get(lb)).get(Prestamo)).get('impagesNumber');
            amortizaciones = (Integer)((Map<String, Object>)((Map<String, Object>)listBalance.get(lb)).get(Prestamo)).get('amortization');
            compras = (Double)((Map<String, Object>)((Map<String, Object>)listBalance.get(lb)).get(Prestamo)).get('purchases');
            noTarjeta = (String)((Map<String, Object>)listBalance.get(lb)).get('creditNumber');
            prod.MX_PyME_Cliente_detprod__c = clientId;
            prod.MX_PyME_No_credito_bp__c = noContract;
            prod.MX_PyME_No_credito_tarjeta__c = noTarjeta;
            prod.MX_PyME_Saldo_otorgado__c = saldoOtorgado;
            prod.MX_PyME_Porcentaje_uso__c = porcUso;
            prod.MX_PyME_No_impagos__c = noImpagos;
            prod.MX_PyME_Amortizaciones__c = amortizaciones;
            prod.MX_PyME_Compras_Disposiciones__c = compras;
            prod.MX_PYME_Balance_Productos__c = parProd[0].Id;
            detalleProd.add(prod);
        }
        if(!detalleProd.isEmpty()) {
            upsert detalleProd MX_PyME_No_credito_tarjeta__c;
        }
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method that gets and saves information of services of type CRTC,TPVS,FISICA
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    jsonReturn JSON returned by the service call
    * @param    indicadorServicio Indicates the type of service(CRTC,TPVS,FISICA)
    * @param    clientId Id of client(Account)
    * @return   Void
    * @example  updateDataServices(JSONreturnOC,'FISICA',clientId) */

    public static void updateDataServices(Map<String, Object> jsonReturn, String indicadorServicio, id clientId) {
        final List<Object> listServ = (List<Object>)jsonReturn.get('listService');
        final List<MX_PyME_Balance_Productos__c> servs = new List<MX_PyME_Balance_Productos__c>();
        MX_PyME_Balance_Productos__c servContratado;
        String longDescrp;
        Double monto;
        for(Integer i = 0; i<listServ.size(); i++) {
            servContratado = new MX_PyME_Balance_Productos__c();
            longDescrp = (String)((Map<String,Object>)listServ.get(i)).get('longDescription');
            monto = (Double)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)listServ.get(i)).get('balance')).get('serviceBalance')).get('amount');
            servContratado.MX_PyME_Cliente__c = clientId;
            servContratado.MX_PyME_Identificador_servicio__c = indicadorServicio;
            servContratado.MX_PyME_Descripcion_servicio__c = longDescrp;
            servContratado.MX_PyME_Saldo_del_servicio__c = monto;
            servs.add(servContratado);
        }
        if(!servs.isEmpty()) {
            insert servs;
        }
    }

    /*------------------------------------------------------------------------------------------------------
    *@Description Method that calls and gets information of PyME services owned by the client
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    clientId Id of client
    * @return   MX_PyME_WRP_Account
    * @example  getServices(clientId);
    * */
    @AuraEnabled
    public static MX_PyME_WRP_Account getServices(Id clientId) {
        final String getServInfo='getServiceInformation';
        try {
        final String numCliente = getAll(clientId).No_de_cliente__c;
        final String crtserv = test.isRunningTest() ? 'getServiceMockCRTC' : getServInfo;
        MX_PyME_ServiceCards_ServicesInfo_Cls.getServiceInfoCRTC(crtserv,clientId,numCliente);
        final String tpvserv = test.isRunningTest() ? 'getServiceMockCRTC' : getServInfo;
        MX_PyME_ServiceCards_ServicesInfo_Cls.getServiceInfoTPVS(tpvserv,clientId,numCliente);
        final String segserv = test.isRunningTest() ? 'getServiceMockSEGR' : getServInfo;
        MX_PyME_ServiceCards_ServicesInfo_Cls.getServiceInfoSeguros(segserv, clientId, numCliente);
        return validateVPF(clientId);
        } catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Wrapper of type MX_PyME_WRP_Account that is used to validate services data returned
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    clientId Id of client
    * @return   MX_PyME_WRP_Account
    * @example  MX_PyME_WRP_Account response=new MX_PyME_WRP_Account() */

    public class MX_PyME_WRP_Account {
    /*
    @Description Getter y Setter en cmp MX_PyME_SectionTables_Cmp
    */
        @AuraEnabled public Boolean vista {get; set;}
    /*
    @Description Getter y Setter en cmp MX_PyME_SectionTables_Cmp
    */
        @AuraEnabled public Boolean plazo {get; set;}
    /*
    @Description Getter y Setter en cmp MX_PyME_SectionTables_Cmp
    */
        @AuraEnabled public Boolean fondo {get; set;}
    /*
    @Description Getter y Setter en cmp MX_PyME_SectionTables_Cmp
    */
        @AuraEnabled public Boolean TPV {get; set;}
    /*
    @Description Getter y Setter en cmp MX_PyME_SectionTables_Cmp
    */
        @AuraEnabled public Boolean SGRO {get; set;}
    /*
    @Description Getter y Setter en cmp MX_PyME_SectionTables_Cmp
    */
        @AuraEnabled public Boolean CRTC {get; set;}
    /*
    @Description Getter y Setter en cmp MX_PyME_SectionTables_Cmp
    */
        @AuraEnabled public Boolean OCR {get; set;}
    /*
    @Description Getter y Setter en cmp MX_PyME_SectionTables_Cmp
    */
        @AuraEnabled public Boolean CSIM {get; set;}
    /*
    @Description Getter y Setter en cmp MX_PyME_SectionTables_Cmp
    */
        @AuraEnabled public Boolean TDCNEG {get; set;}
    /*
    @Description Getter y Setter en cmp MX_PyME_SectionTables_Cmp
    */
        @AuraEnabled public Boolean TDMNEG {get; set;}
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method that validates if tables are displayed in component,depending on information returned by services
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    clientId Id of client
    * @return   MX_PyME_WRP_Account
    * @example  return validateVPF(clientId);
    * */
    @AuraEnabled
        public static MX_PyME_WRP_Account validateVPF(id clientId) {
        try {
            final Account valPyS=[Select MX_PyME_Total_TDC_Micro_Negocio__c,MX_PyME_Total_TDC_Negocios__c,MX_PyME_Total_Credito_Simple__c,MX_PyME_prod_cartaCredito__c,MX_PyME_prod_TPV__c,MX_PyME_Total_Otros_Creditos__c,MX_PyME_tiene_seguros__c,MX_PyME_Vista_Saldo_diario__c,MX_PyME_Plazo_Saldo_diario__c ,MX_PyME_Fondos_Saldo_diario__c From Account where Id= : clientId ];

            final List<String> listFields = new List<String>{'MX_PyME_Total_TDC_Micro_Negocio__c','MX_PyME_Total_TDC_Negocios__c','MX_PyME_Total_Credito_Simple__c','MX_PyME_Total_Otros_Creditos__c','MX_PyME_Vista_Saldo_diario__c','MX_PyME_Plazo_Saldo_diario__c','MX_PyME_Fondos_Saldo_diario__c'};
            MX_PyME_WRP_Account res = new MX_PyME_WRP_Account();
            final List<Boolean> listRes = new List<Boolean>();
            for(Integer i = 0; i<listFields.size(); i++) {
                  if(valPyS.get(listFields[i]) == null || valPyS.get(listFields[i]) == 0) {
        listRes.add(false);
            } else {
                listRes.add(true);
    }
}
            res.TDMNEG = listRes[0];
            res.TDCNEG = listRes[1];
            res.CSIM = listRes[2];
            res.OCR = listRes[3];
            res.vista = listRes[4];
            res.plazo = listRes[5];
            res.fondo = listRes[6];
             res.CRTC = valPyS.MX_PyME_prod_cartaCredito__c;
            res.TPV = valPyS.MX_PyME_prod_TPV__c;
            res.SGRO = valPyS.MX_PyME_tiene_seguros__c;
            return res;
            } catch(Exception e) {
                throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    }
}