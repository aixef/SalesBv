/**-------------------------------------------------------------------------
* Nombre: MX_SB_VTS_GetListCampa_cls
* @author Arsenio Perez (xemo)
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Clase que se ocupa para enviar datos a CTI y regresar una consulta al componente MX_SB_VTS_GetListCampa_cmp

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           11/06/2019      Arsenio Perez            Creación
* @version 1.0           27/08/2019      Arsenio Perez            Code smell
* @version 1.1           02/10/2019      Arsenio Perez            Campo servicio
* --------------------------------------------------------------------------*/
public without sharing class MX_SB_VTS_GetListCampa_cls { //NOSONAR
	/*variable zone*/
	static string txtmsj='\nMensaje: ',txtlinea= '\nLinea: ';

    @AuraEnabled
    public static string Carga_invoke(String servicio, String dESCRIPCION, String nam, String idCampa, String idProducto, String descrip) {
        String ret2 = '';
        try {
            final Map<String,Object> ret = MX_SB_VTS_SendLead_helper_cls.Crear_Carga_invoke(servicio, dESCRIPCION);
            ret2  =String.valueOf(ret.get('LOADID'));  
            final MX_SB_VTS_Lead_tray__c LeadTrail = new MX_SB_VTS_Lead_tray__c();
            LeadTrail.Name=nam;
            LeadTrail.MX_SB_VTS_Campa_a_relacionada__c=idCampa;
            LeadTrail.MX_SB_VTS_Description__c=descrip;
            LeadTrail.MX_SB_VTS_ID_Bandeja__c=ret2;
			LeadTrail.MX_SB_VTS_ServicioID__c=servicio;
            insert LeadTrail;
        } catch(DmlException dml) {
            throw new AuraHandledException(Label.MX_WB_ERROR + txtmsj + dml.getMessage() + txtlinea + dml.getLineNumber() + dml);
        }
        return ret2;
    }
    /* 
@description: Invoca un llamado para consltar las campañas activas.
*/
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String objectName) {
        try {
            return MX_WB_CampaniasCTI_cls.fetchLookUpValues(searchKeyWord, objectName);
        } catch (DmlException e) {
            throw new AuraHandledException(Label.MX_WB_ERROR + txtmsj + e.getMessage() + txtlinea + e.getLineNumber() + e);
        }
        
    }
    /* */
    @AuraEnabled
    public static List<Object> searchBandejas(String searchKeyWord) {
        final List<Object> ret = new List<Object>();
        try {        
            if(String.isNotBlank(searchKeyWord)) {
                final List<MX_SB_VTS_Lead_tray__c> temp = [SELECT ID, MX_SB_VTS_Description__c,MX_SB_VTS_ID_Bandeja__c, Name FROM MX_SB_VTS_Lead_tray__c WHERE MX_SB_VTS_Campa_a_relacionada__c =:searchKeyWord];
                for(MX_SB_VTS_Lead_tray__c x: temp) {
                    ret.add(x);
                }
            }
        } catch (DmlException e) {
            throw new AuraHandledException(Label.MX_WB_ERROR + txtmsj + e.getMessage() + txtlinea + e.getLineNumber() + e);
        }
        return ret;
    }
    /* */
    @AuraEnabled
    public static List<Object> searchServicios () {
        List<Object> ret = new List<Object>();
        try {        
            final List<MX_SB_VTS_Generica__c> gen = MX_SB_VTS_Generica__c.getall().values();
            for(MX_SB_VTS_Generica__c gente: gen) {
                if('CP3'.equals(gente.MX_SB_VTS_Type__c)) {
                    ret.add(gente);   
                }
            }
        } catch (DmlException e) {
            throw new AuraHandledException(Label.MX_WB_ERROR + txtmsj + e.getMessage() + txtlinea + e.getLineNumber() + e);
        }
        return ret;
    }
}