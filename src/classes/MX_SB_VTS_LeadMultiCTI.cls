/**
 * @File Name          : MX_SB_VTS_LeadMultiCTI.cls
 * @Description        : Clase para Handler de Oportunidad
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              : BBVA
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 26/9/2019 19:13:09
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    16/6/2019 13:31:59   Eduardo Hernández Cuamatzi     Initial Version
 * 2.0    29/8/2019 15:25:04   Eduardo Hernández Cuamatzi     convivencia envios multi CTI
**/
public without sharing class MX_SB_VTS_LeadMultiCTI extends MX_SB_VTS_LeadMultiCTI_Util {
    /**
     * MX_SB_VTS_FamliaProveedores__c> description
     * @param  Id Id description
     * @return    return description
     */
    Map<Id, MX_SB_VTS_FamliaProveedores__c> mapProvers = new Map<Id, MX_SB_VTS_FamliaProveedores__c>([Select Id, Name,MX_SB_VTS_Familia_de_productos__c,MX_SB_VTS_ProveedorCTI__c from MX_SB_VTS_FamliaProveedores__c where MX_SB_VTS_ProveedorCTI__c NOT IN ('') AND MX_SB_VTS_ProveedorCTI__r.MX_SB_VTS_IsReadyCTI__c = true]);

    /**
     * validLeadCTI description
     * @param  newEntry mapa de nuevos registros del trigger Lead
     */
    public static void validLeadCTI(List<Lead> newEntryLead) {
        final Map<Id, String> leadProducts = new Map<Id, String>();
        final Set<String> valProds = new Set<String>();
        final Map<Id, Lead> newEntry = new Map<Id, Lead>();
        for(Lead leadVal : newEntryLead) {
            if(String.isNotBlank(leadVal.LeadSource) && leadVal.LeadSource.equalsIgnoreCase(System.Label.MX_SB_VTS_OrigenCallMeBack) && String.isNotBlank(leadVal.MobilePhone)) {
                final String prodCorrect = MX_SB_VTS_ValidCorrectNamesASD.validacionProducto(leadVal.Producto_Interes__c);
                leadProducts.put(leadVal.Id, prodCorrect);
                valProds.add(prodCorrect);
                newEntry.put(leadVal.Id, leadVal);
            }
        }
        if(valProds.isEmpty() == false) {
            validFamilysCTI(newEntry, leadProducts, valProds);
        }
    }

    /**
     * validFamilysCTI description
     * @param  newEntry     newEntry description
     * @param  leadProducts leadProducts description
     * @param  valProds     valProds description
     */ 
    public static void validFamilysCTI(Map<Id, Lead> newEntry, Map<Id, String> leadProducts, Set<String> valProds) {
        final Map<String, Product2> valsFam = new Map<String, Product2>();
        final Set<Id> familiaProds = new Set<Id>();
        for(Product2 product : [Select Id, Name, MX_WB_FamiliaProductos__c from Product2 where Name IN: valProds]) {
            valsFam.put(product.Name, product);
            familiaProds.add(product.MX_WB_FamiliaProductos__c);
        }
        final Map<Id, List<MX_SB_VTS_FamliaProveedores__c>> valsFamPro = new Map<Id, List<MX_SB_VTS_FamliaProveedores__c>>();
        for(MX_SB_VTS_FamliaProveedores__c famProvee : [Select Id, Name, MX_SB_VTS_ProveedorCTI__c, MX_SB_VTS_Familia_de_productos__c, 
                                                        MX_SB_VTS_Familia_de_productos__r.Name, MX_SB_VTS_ProveedorCTI__r.MX_SB_VTS_Identificador_Proveedor__c from MX_SB_VTS_FamliaProveedores__c 
                                                        where MX_SB_VTS_Familia_de_productos__c IN : familiaProds AND MX_SB_VTS_ProveedorCTI__r.MX_SB_VTS_IsReadyCTI__c = true]) {
            if(valsFamPro.containsKey(famProvee.MX_SB_VTS_Familia_de_productos__c)) {
                valsFamPro.get(famProvee.MX_SB_VTS_Familia_de_productos__c).add(famProvee);
            } else {
                final List<MX_SB_VTS_FamliaProveedores__c> lstFam = new List<MX_SB_VTS_FamliaProveedores__c>{famProvee};
                valsFamPro.put(famProvee.MX_SB_VTS_Familia_de_productos__c, lstFam);
            }
        }
        
        if(valsFamPro.keySet().isEmpty() == false) {
            createRequestCTI(newEntry, leadProducts, valsFamPro, valsFam);
        }
    }

    /**
     * createRequestCTI description
     * @param  newEntry     newEntry description
     * @param  leadProducts leadProducts description
     * @param  valsFamPro   valsFamPro description
     * @param  valsFam      valsFam description
     */
    public static void createRequestCTI(Map<Id, Lead> newEntry, Map<Id, String> leadProducts, Map<Id, List<MX_SB_VTS_FamliaProveedores__c>> valsFamPro, Map<String, Product2> valsFam) {
        final List<WrapperEnvioCTI> lstEnvioCTI = new List<WrapperEnvioCTI>();
        for(Id leadId : leadProducts.keySet()) {
            final WrapperEnvioCTI itemRequest = new WrapperEnvioCTI();
            final Lead leadRecord = newEntry.get(leadId);
            itemRequest.leadId = leadRecord;
            itemRequest.product = leadProducts.get(leadId);
            itemRequest.sNombre = fillFullName(leadRecord);
            if(leadRecord.MobilePhone.startsWith(Label.wsLadaCDMX)) {
                itemRequest.sTelefono = Label.wsLadaNacCel + leadRecord.MobilePhone;
            } else {
                itemRequest.sTelefono = Label.wsLadaProCel + leadRecord.MobilePhone;
            }
            itemRequest.typeSend = 'Lead';
            itemRequest.itipoVal = 0;
            itemRequest.proveedor = getRandomProvider(valsFamPro, valsFam, leadProducts, leadId);
            lstEnvioCTI.add(itemRequest);
        }
        if(lstEnvioCTI.isEmpty() == false) {
            sendToCTI(lstEnvioCTI);
        }
    }

    /**
     * sendToCTI description
     * @param  enviosCTI enviosCTI description
     */
    public static void sendToCTI(List<WrapperEnvioCTI> enviosCTI) {
        final List<MX_SB_VTS_Lead_tray__c> mapBandejas = [Select Id, MX_SB_VTS_Campa_a_relacionada__c,
            MX_SB_VTS_Campa_a_relacionada__r.MX_SB_VTS_FamiliaProducto_Proveedor__r.MX_SB_VTS_ProveedorCTI__r.MX_SB_VTS_Identificador_Proveedor__c ,
            MX_SB_VTS_Campa_a_relacionada__r.MX_SB_VTS_FamiliaProducto_Proveedor__c, MX_SB_VTS_ID_Bandeja__c,
            MX_SB_VTS_Producto__r.Name, MX_SB_VTS_Producto__c, MX_SB_VTS_ProveedorCTI__c from MX_SB_VTS_Lead_tray__c where 
            MX_SB_VTS_Tipo_bandeja__c =: System.Label.MX_SB_VTS_HotLeads];
        final List<WrapperEnvioCTI> vcip = new List<WrapperEnvioCTI>();
        final List<WrapperEnvioCTI> smartCenter = new List<WrapperEnvioCTI>();
        for(WrapperEnvioCTI envioCTI : enviosCTI) {
            switch on envioCTI.proveedor.MX_SB_VTS_ProveedorCTI__r.MX_SB_VTS_Identificador_Proveedor__c {
                when 'SMART CENTER' {
                    smartCenter.add(envioCTI);
                }
                when 'VCIP' {
                    vcip.add(envioCTI);
                }
            }
        }
        if(mapBandejas.isEmpty() == false && smartCenter.isEmpty() == false) {
            sendtoSmartCenter(smartCenter, mapBandejas);
        }
        sendtoVCIP(vcip);
    }

    /**
     * sendtoSmartCenter enviar leads a SmartCenter
     * @param  envioCTI    leads ah enviar
     * @param  lstBandejas bandjeas de HotLeads
     */
    public static void sendtoSmartCenter(List<WrapperEnvioCTI> envioCTI, List<MX_SB_VTS_Lead_tray__c> lstBandejas) {
        final String idBandeja = findBandeja(envioCTI[0], lstBandejas);
        if(String.isNotBlank(idBandeja)) {
            final Map<String,String> mapsent = new map<String,String>();
            final String serviceId = System.Label.MX_SB_VTS_SmartServiceHogar;
            final List<MX_SB_VTS_SendLead_helper_cls.RequestSendLead> lstSend = new List<MX_SB_VTS_SendLead_helper_cls.RequestSendLead>();
            final List<Id> lstLeadIds = new List<Id>();
            for(WrapperEnvioCTI wrapperItem : envioCTI) {
                final MX_SB_VTS_SendLead_helper_cls.RequestSendLead temprest = new MX_SB_VTS_SendLead_helper_cls.RequestSendLead();
                lstLeadIds.add(wrapperItem.leadId.Id);
                temprest.ID_LEAD=MX_SB_VTS_SendLead_helper_cls.returnEmpty(wrapperItem.leadId.Id);
                temprest.LOGIN=MX_SB_VTS_SendLead_helper_cls.returnEmpty('');
                temprest.SERVICEID= Integer.valueOf(MX_SB_VTS_SendLead_helper_cls.returnEmptyphone(serviceId));
                temprest.LOADID= Integer.valueOf(MX_SB_VTS_SendLead_helper_cls.returnEmptyphone(idBandeja));
                temprest.SCHEDULEDATE=MX_SB_VTS_SendLead_helper_cls.returnEmpty(checkDate(wrapperItem.leadId));   
                temprest.PHONE1=MX_SB_VTS_SendLead_helper_cls.returnEmpty(wrapperItem.leadId.MobilePhone);
                temprest.PHONE2=MX_SB_VTS_SendLead_helper_cls.returnEmpty(wrapperItem.leadId.MobilePhone);
                temprest.PHONE3=MX_SB_VTS_SendLead_helper_cls.returnEmpty(wrapperItem.leadId.MobilePhone);
                lstSend.add(temprest);
            }
            mapsent.put('ListLeads',JSON.serialize(lstSend));
            sendSmart('EntRegistroGestion', mapsent, lstLeadIds);
        }
    }
    /**
     * sendSmart petición post al servicio de Smart
     * @param  Id función ejecutar, mapa de valores, lista Id leads
     */
    @future(callout=true)
    public static void sendSmart(String methodId, Map<String,String> mapsent, List<Id> lstLeadIds) {
        final HttpResponse HttpRest = MX_SB_VTS_SendLead_helper_cls.invoke(methodId, mapsent);  
        final Map<String,Object> ret= (Map<String,Object>) JSON.deserializeUntyped(HttpRest.getBody());
        final List<Lead> lstLead = new List<Lead>();
        for (Id leadId : lstLeadIds) {
            final Integer codeResp = (Integer)ret.get('CARGA');
            Boolean sendOk = true;
            if (codeResp < 0) {
                sendOk = false;
            }
            final Lead leadupdate = new Lead(Id = leadId, EnviarCTI__c = sendOk, xmlRespuesta__c = String.valueOf(codeResp));
            lstLead.add(leadupdate);
        }
        update lstLead;
    }
}