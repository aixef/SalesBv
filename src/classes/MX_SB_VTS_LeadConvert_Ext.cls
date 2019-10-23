/**
* BBVA - Mexico
* @Author: Jaime Terrats
* @Description: Controller extension for MX_WB_ConvertirLeadController
* @version 1.0
**/
public virtual without sharing class MX_SB_VTS_LeadConvert_Ext {//NOSONAR
    /**
    * validateNewFlow valida tipificaciones para saber si el lead se puede convertir
    * @param leadData datos del lead
    * @return Boolean para saber si hubo error o no
    *
    **/
    public static Boolean validateNewFlow(Lead leadData) {
        final Boolean isValid = true;
        final Id usr = UserInfo.getUserId();
        if(System.Label.MX_SB_VTS_Interesado.equals(leadData.MX_SB_VTS_Tipificacion_LV3__c) == false) {
            throw new AuraHandledException(System.Label.MX_SB_VTS_EstatusEfectivo);
        } else if(usr.equals(leadData.OwnerId) == false) {
            throw new AuraHandledException(System.Label.MX_SB_VTS_OwnerLead);
        } else if(System.Label.MX_SB_VTS_ResultadoLlamada.equals(leadData.Resultadollamada__c) == false) {
            throw new AuraHandledException(System.Label.MX_SB_VTS_ErrorTipificaciones);
        } else if(!System.Label.MX_SB_VTS_ContactoEfectivo.equals(leadData.MX_SB_VTS_Tipificacion_LV2__c)) {
            throw new  AuraHandledException(System.Label.MX_SB_VTS_ErrorTipificaciones);
        }
        return isValid;
    }

    /**
    * @Description: creates opp for new business process
    * @params: leadToConvert
    **/
    public static Opportunity createOppExt(Lead leadToConvert, Id accId) {
        final Id oppRtId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_Telemarketing_LBL).getRecordTypeId();
        final Opportunity newOpp = new Opportunity();
        newOpp.AccountId = accId;
        newOpp.Name = leadToConvert.Name;
        newOpp.RecordTypeId = oppRtId;
        final String validProductName = MX_SB_VTS_CierreOpp.validacionproducto(leadToConvert.Producto_Interes__c);
        newOpp.Producto__c = validProductName;
        newOpp.StageName = System.Label.MX_SB_VTS_COTIZACION_LBL;
        newOpp.TelefonoCliente__c = leadToConvert.MobilePhone;
        newOpp.MX_WB_txt_Clave_Texto__c = leadToConvert.MX_WB_txt_Clave_Texto__c;
        newOpp.LeadSource = leadToConvert.LeadSource;
        newOpp.MX_SB_VTS_ContadorLlamadasTotales__c = leadToConvert.MX_SB_VTS_ContadorLlamadasTotales__c;
        newOpp.MX_SB_VTS_ContadorRemarcado__c = leadToConvert.MX_SB_VTS_ContadorRemarcado__c;
        newOpp.MX_SB_VTS_Llamadas_Efectivas__c = leadToConvert.MX_SB_VTS_Llamadas_Efectivas__c;
        newOpp.MX_SB_VTS_Llamadas_No_Efectivas__c = leadToConvert.MX_SB_VTS_Llamadas_No_Efectivas__c;
        newOpp.CloseDate = System.today();
        newOpp.MX_SB_VTS_Tipificacion_LV1__c =  leadToConvert.Resultadollamada__c;
        newOpp.MX_SB_VTS_Tipificacion_LV2__c =  leadToConvert.MX_SB_VTS_Tipificacion_LV2__c;
        newOpp.MX_SB_VTS_Tipificacion_LV3__c =  leadToConvert.MX_SB_VTS_Tipificacion_LV3__c;
        newOpp.Description=leadToConvert.Description;
        return newOpp;
    }
    /** Crea un email dummy si el lead no cuenta con email */
    public static String createDummyEmail(Lead leadToConvert) {
        return leadToConvert.MX_SB_VTS_Contador_Email__c + '@dummy.com';
    }
}