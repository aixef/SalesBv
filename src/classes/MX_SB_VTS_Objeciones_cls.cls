/**
 * @File Name          : MX_SB_VTS_Objeciones_cls.cls
 * @Description        : 
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              : 
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 24/9/2019 11:35:02
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/9/2019   Eduardo Hernández Cuamatzi     Initial Version
**/
public without sharing class MX_SB_VTS_Objeciones_cls { //NOSONAR
    
    /** getObjetions : Recupera las objeciones correspondientes al producto y tipo de objeto */
    @AuraEnabled
    public static Map<String, Object> getObjetions(String recordId, String product, Boolean isLead) {
        final Map<String, Object> response = new Map<String, Object>();
        final String productName = MX_SB_VTS_Cotizador_ext.correctName(product);
        try {
            final String activeCall = getActiveCall(recordId, isLead);
            final Id productId = [Select Id from Product2 where IsActive = true AND Name =: productName].Id;
            final String tipoObjecion = isLead ? 'Objeciones' : 'Objeciones Reales';
            final List<WrapperObjects> lstObjeciones = new List<WrapperObjects>();
            final Map<Id,MX_SB_VTS_CatalogoObjeciones__c> mapObject = new Map<Id, MX_SB_VTS_CatalogoObjeciones__c>([Select Id, MX_SB_VTS_DetOjecion__c,MX_SB_VTS_NombreObjecion__c, 
                MX_SB_VTS_NoUsoObjecion__c, MX_SB_VTS_ObjecionActiva__c, MX_SB_VTS_ProductoObjecion__c, MX_SB_VTS_UsoObjecion__c,MX_SB_VTS_TipoObjecion__c
                from MX_SB_VTS_CatalogoObjeciones__c WHERE MX_SB_VTS_ProductoObjecion__c=: productId AND MX_SB_VTS_TipoObjecion__c=: tipoObjecion 
                AND MX_SB_VTS_ObjecionActiva__c=: true ORDER BY MX_SB_VTS_Relevancia__c ASC]);
            final Map<String,MX_SB_VTS_RegistroObjeciones__c> mapRegistro = new Map<String,MX_SB_VTS_RegistroObjeciones__c>();
            for(MX_SB_VTS_RegistroObjeciones__c recObject : [Select Id,MX_SB_VTS_NoUsoObjecion__c, MX_SB_VTS_CatObjecion__r.MX_SB_VTS_NombreObjecion__c, MX_SB_VTS_CatObjecion__c, MX_SB_VTS_ObjecionUtil__c 
                from MX_SB_VTS_RegistroObjeciones__c WHERE MX_SB_VTS_TipoObjecion__c =: tipoObjecion AND (MX_SB_VTS_LeadLook__c =: recordId OR MX_SB_VTS_ObjecionOpp__c=: recordId) AND MX_SB_VTS_LookActivity__c =: activeCall]) {
                    mapRegistro.put(recObject.MX_SB_VTS_CatObjecion__r.MX_SB_VTS_NombreObjecion__c, recObject);
                }
            for(MX_SB_VTS_CatalogoObjeciones__c catObjec : mapObject.values()) {
                final WrapperObjects objecion = new WrapperObjects();
                objecion.CatObject = catObjec.Id;
                objecion.detObjecion = catObjec.MX_SB_VTS_DetOjecion__c;
                objecion.nomObjecion = catObjec.MX_SB_VTS_NombreObjecion__c;
                objecion.usoObjecion = false;
                objecion.noUsoCatObject = false;
                if(mapRegistro.containsKey(objecion.nomObjecion)) {
                    objecion.noUsoCatObject = mapRegistro.get(objecion.nomObjecion).MX_SB_VTS_NoUsoObjecion__c;
                    objecion.usoObjecion = mapRegistro.get(objecion.nomObjecion).MX_SB_VTS_ObjecionUtil__c;
                    objecion.regObjec = mapRegistro.get(objecion.nomObjecion).Id;
                }
                lstObjeciones.add(objecion);
            }
            response.put('lstObjects', lstObjeciones);
            response.put('activeCall', activeCall);
        } catch(QueryException dEx) {
            throw new AuraHandledException(System.Label.MX_WB_lg_TlmktError + dEx);
        }
        return response;
    }

    /** getActiveCall: Recupera la llamada activa por la que se inicio el flujo*/
    public static String getActiveCall(String recordId, Boolean isLead) {
        String activeCall = '';
        if(isLead) {
           activeCall = [Select Id, MX_SB_VTS_LookActivity__c from Lead where Id =: recordId].MX_SB_VTS_LookActivity__c;
         } else {
             activeCall = [Select Id, MX_SB_VTS_LookActivity__c from Opportunity where Id =: recordId].MX_SB_VTS_LookActivity__c;
         }
         return activeCall;
    }

    /** saveObjectionscls: Genera los registros de las objeciones marcadas*/
    @AuraEnabled
    public static void saveObjectionscls(List<MX_SB_VTS_RegistroObjeciones__c> objeciones) {
        try {
            upsert objeciones;
        } catch (DmlException dEx) {            
            throw new AuraHandledException(System.Label.MX_WB_LG_ErrorBack+dEx);
        }
    }

    /** updateLeadsTray: Actualiza el Id de bandeja de HotLeads*/
    @AuraEnabled
    public static Map<String, Object> updateLeadsTray(String recordId) {
        final Map<String, Object> responseUpdate = new Map<String, Object>();
        try {
            final MX_SB_VTS_Lead_tray__c leadTray = [Select Id, MX_SB_VTS_ID_Bandeja__c, MX_SB_VTS_Producto__c, MX_SB_VTS_ProveedorCTI__c, 
            MX_SB_VTS_ServicioID__c, MX_SB_VTS_Tipo_bandeja__c, MX_SB_VTS_ProveedorCTI__r.MX_SB_VTS_Identificador_Proveedor__c 
            from MX_SB_VTS_Lead_tray__c where Id =:recordId];
            if(leadTray.MX_SB_VTS_Tipo_bandeja__c.equals(System.Label.MX_SB_VTS_HotLeads)) {
                String bandejaId = '';
                switch on leadTray.MX_SB_VTS_ProveedorCTI__r.MX_SB_VTS_Identificador_Proveedor__c {
                   when 'SMART CENTER' {
                       bandejaId = findLeadTraySmart();
                   }
                }
                leadTray.MX_SB_VTS_ID_Bandeja__c = bandejaId;
                update leadTray;
                responseUpdate.put('isOk',true);
            } else {
                responseUpdate.put('isOk',false);
            }
            return responseUpdate;
        } catch (DmlException dEx) {            
            throw new AuraHandledException(System.Label.MX_WB_LG_ErrorBack+dEx);
        }
    }

    /**
     * findLeadTraySmart recupera el Id de bandeja
     * @param  bandeja registro a recuperar
     * @return         Id de bandeja
     */
    public static String findLeadTraySmart() {
        final Map<String,Object> ret = MX_SB_VTS_SendLead_helper_cls.Crear_Carga_invoke(System.Label.MX_SB_VTS_SmartServiceHogar, 'HotLeads');
        return String.valueOf(ret.get('LOADID'));  
    }

    /**Clase wrapper de objeciones */
    public class WrapperObjects {
        /** Registro de catalogo*/
        @AuraEnabled
        public Id catObject {get;set;}
        /** Detalle Objecion*/
        @AuraEnabled
        public String detObjecion {get;set;}
        /** Nombre Tooltip*/
        @AuraEnabled
        public String nomObjecion {get;set;}
        /** Si se uso */
        @AuraEnabled
        public Boolean usoObjecion {get;set;}
        /** Si no se uso */
        @AuraEnabled
        public Boolean noUsoCatObject {get;set;}
        /** Id si ya existe registro */
        @AuraEnabled
        public Id regObjec {get;set;}
    }
}