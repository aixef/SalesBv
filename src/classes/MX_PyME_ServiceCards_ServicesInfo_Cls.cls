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
public with sharing class MX_PyME_ServiceCards_ServicesInfo_Cls {
    private MX_PyME_ServiceCards_ServicesInfo_Cls() {}
 /*------------------------------------------------------------------------------------------------------
    *@Description Method to call getServiceInformation service with serviceId=CRTC
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
    public static void getServiceInfoCRTC(String callService,Id clientId,string numCliente) {
        List<MX_PyME_Balance_Productos__c> deleteCRTC = [Select MX_PyME_Descripcion_servicio__c,MX_PyME_Saldo_del_servicio__c From MX_PyME_Balance_Productos__c Where MX_PyME_Cliente__c= : clientId And MX_PyME_Identificador_servicio__c='CRTC']; 
        HttpResponse responseCRTC;
        Map<String, Object> JSONreturnCRTC;
        responseCRTC = iaso.GBL_Integration_GenericService.invoke(callService, '{"customerId" : "'+numCliente+'","serviceId" : "CRTC"}');
        if (responseCRTC.getStatusCode() == 200) {
            JSONreturnCRTC = (Map<String, Object>)JSON.deserializeUntyped(responseCRTC.getBody()); 
        }
        if(!deleteCRTC.isEmpty()) {
            delete deleteCRTC;
        }
        MX_PyME_ServiceCards_Cls.updateDataServices(JSONreturnCRTC, 'CRTC', clientId);
    }
    /*
    *@Description Method to call getServiceInformation service with serviceId=TPVS
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
    public static void getServiceInfoTPVS(String callService, id clientId, String numCliente) {
        List<MX_PyME_Balance_Productos__c> deleteTPVS=[Select MX_PyME_Descripcion_servicio__c,MX_PyME_Saldo_del_servicio__c From MX_PyME_Balance_Productos__c Where MX_PyME_Cliente__c= : clientId And MX_PyME_Identificador_servicio__c='TPVS']; 
        HttpResponse responseTPV;
        Map<String, Object> JSONreturnTPV;

        responseTPV = iaso.GBL_Integration_GenericService.invoke(callService, '{"customerId" : "'+numCliente+'","serviceId" : "TPVS"}');
        if (responseTPV.getStatusCode() == 200) {
        JSONreturnTPV = (Map<String, Object>)JSON.deserializeUntyped(responseTPV.getBody());
        }
        if(!deleteTPVS.isEmpty()) {
            delete deleteTPVS;
        }
        MX_PyME_ServiceCards_Cls.updateDataServices(JSONreturnTPV,'TPVS',clientId);
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to call getServiceInformation service with serviceId=SEGR
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
    public static void getServiceInfoSeguros(String callService, Id clientId, String numCliente) {
        List<MX_PyME_Balance_Productos__c> deleteServices = [Select MX_PyME_Descripcion_servicio__c,MX_PyME_Fecha_activacion__c From MX_PyME_Balance_Productos__c Where MX_PyME_Cliente__c= : clientId And MX_PyME_Identificador_servicio__c='SEGR'];        
        HttpResponse response;
        Map<String, Object> JSONreturn;
        response = iaso.GBL_Integration_GenericService.invoke(callService, '{"customerId" : "'+numCliente+'","serviceId" : "SEGR"}');
        if (response.getStatusCode() == 200) {
        JSONreturn = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        }
        List<Object> listSeg = (List<Object>)JSONreturn.get('listService');
        List<MX_PyME_Balance_Productos__c> sguros = new List<MX_PyME_Balance_Productos__c>();
        String longDescrp, fecha;
        for(Integer i = 0; i<listSeg.size(); i+=2) {
            MX_PyME_Balance_Productos__c seguro = new MX_PyME_Balance_Productos__c();
            longDescrp = (String)((Map<String,Object>)listSeg.get(i)).get('longDescription');
            fecha = (String)((Map<String,Object>)listSeg.get(i+1)).get('longDescription');
            seguro.MX_PyME_Cliente__c = clientId;
            seguro.MX_PyME_Identificador_servicio__c = 'SEGR';
            seguro.MX_PyME_Descripcion_servicio__c = longDescrp;
            seguro.MX_PyME_Fecha_activacion__c = fecha;
            sguros.add(seguro);
        }
        if(!deleteServices.isEmpty()) {
            delete deleteServices;
        }
        if(!sguros.isEmpty()) {
            insert sguros;
        }
    }
}