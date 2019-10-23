/**
* ------------------------------------------------------------------------------------------------
* @Name     MX_BPP_VistaRI_Ctrl
* @Author   Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* @Date     Created: 2019-06-12
* @Group    Digital Workplace Retail
* @Description Get the cases owned by the banker
* @Comments Created from the clipped code from the EU001_cls_ConsolaDirector class
* @Changes
**/

public With Sharing class MX_BPP_RI_ListaCompromisos_Ctrl {

    //Constructor with no arguments
    @TestVisible
    private MX_BPP_RI_ListaCompromisos_Ctrl() {
    }

    @AuraEnabled
    /** Creacion de metodo*/
    public static void getInsertaCompromiso (String RType, Account Cliente,String TipoComp,String Compromiso,string sFechaCierre,String Estatus,Integer HCambios,String sIdRI) {
        String TipoRegistro='';
        date FechaCierre = Date.valueOf(sFechaCierre);
        EU001_RI__c RISeleccionada;

        RISeleccionada = ([SELECT Id, OwnerId FROM EU001_RI__c WHERE Id =: sIdRI LIMIT 1]);
        EU_001_Compromiso__c comp = new EU_001_Compromiso__c();
        if(Cliente!=null) {
            comp.Cliente__c=Cliente.Id;
        }
        comp.EU_001_Rb_Revisi_n_Individual_RI__c=RISeleccionada.Id;
        comp.EU_001_ls_Indicadores_de_cartera__c=TipoComp;

        if(TipoComp==EU001_CLS_CONSTANTES.EU001_STR_SANEAMIENTO) {
            TipoRegistro = getRecordTypeId('EU_001_Compromiso__c',TipoComp);
            comp.EU_001_dv_Compromiso__c=decimal.valueOf(Compromiso);
        } else if (TipoComp ==EU001_CLS_CONSTANTES.EU001_STR_USUARIO_CREDITO) {
            TipoRegistro = getRecordTypeId('EU_001_Compromiso__c',EU001_CLS_CONSTANTES.EU001_TRE_COMPROMISO_NVOS_USUARIOS);
            comp.EU_001_dv_Compromiso__c=decimal.valueOf(Compromiso);
        } else {
            comp.EU_001_tx_Compromiso__c=Compromiso;
            TipoRegistro=RType;
        }

        comp.RecordTypeId=TipoRegistro;
        comp.EU_fm_Fecha_Cierre__c=FechaCierre;
        comp.EU_001_ls_Estatus__c=Estatus;
        comp.EU001_Fm_Historico_Cambios_Fecha_Cierre__c=HCambios;
        comp.OwnerId=RISeleccionada.OwnerId;
        try {
            insert comp;
        } catch(DmlException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    }

    @AuraEnabled
    /** metodo VerificaDirector*/
    public static Boolean VerificaDirector() {
        Boolean temp = false;
        List<UserRole> NivelAbajoFuncion = new List<UserRole>();
        try {
            List<User> funcionDelUsuario = ([SELECT Id, Name, UserRoleId FROM User WHERE Id =: userInfo.getUserId() LIMIT 1]);
            NivelAbajoFuncion = [SELECT Name, Id, ParentRoleId FROM UserRole WHERE ParentRoleId =: funcionDelUsuario[0].UserRoleId];
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
         if(!NivelAbajoFuncion.isEmpty()) {
            temp = true;
        }
        return temp;
    }

/*@Descripción
10/09/2018       Luis Fernando Romero
Se agregan parametros a búsqueda de compromisos, convierte a query dinámica  */
    @AuraEnabled
    public static list<CompEU_Table> getTableCompromisos(String IdRI, String filtroEstatus, String filtroType, string indicador, string fechainicio, String fechafin, String campoPadre, String campoHijo) {
        map<Id, CompEU_Table> mapResult = new map<Id, CompEU_Table>();
        list<boolean> listType = new list<Boolean>{true, false};
        list<string> lInds = getPickListValues();
        if (!string.isBlank(filtroType)) {
            listType.clear();
            listType.add(Boolean.valueOf(filtroType));
        }
        if (!string.isBlank(indicador)) {
            lInds.clear();
            lInds.add(indicador);
        }
        if('Generales'.equals(indicador)) {
            lInds.addAll(new List<string>{'Análisis de crédito', 'IReNe', 'Saneamiento', 'Usuario Nvo de Credito', 'Plan de Cuenta', 'Visitas', 'Otros'});
        }
        List<EU_001_Compromiso__c> compromisosList = new List<EU_001_Compromiso__c>();
        try {
            compromisosList = getCompromisos(IdRI, filtroEstatus, fechainicio, fechafin, campoPadre, campoHijo, lInds, listType);
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        for(EU_001_Compromiso__c ls : compromisosList) {
           if(mapResult.containsKey(ls.OwnerId)) {
              mapResult.get(ls.OwnerId).lsOpp.add(ls);
            } else {
              mapResult.put(ls.OwnerId, new CompEU_Table(new list<EU_001_Compromiso__c>{ls}));
            }
        }

        return mapResult.values();
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          17-06-2019
* @Description  Get commitments.
* @Comments     Created from the clipped code block of method getTableCompromisos.
* @param        String IdRI, String filtroEstatus, String fechainicio, String fechafin,
                String campoPadre, String campoHijo, List<string> lInds, List<boolean> listType
* @return       List<EU_001_Compromiso__c>
* @example      public static List<EU_001_Compromiso__c> getCompromisos(String IdRI, String filtroEstatus,
                String fechainicio, String fechafin, String campoPadre, String campoHijo, List<string> lInds, 
                List<boolean> listType){
**/
    public static List<EU_001_Compromiso__c> getCompromisos(String IdRI, String filtroEstatus, String fechainicio, String fechafin, String campoPadre, String campoHijo, List<string> lInds, List<boolean> listType) {
        string query, conditions='';
        list<string> lsEstatus= new list<String>{'Abierto','Reprogramado'};
        if(string.isNotBlank(filtroEstatus)) {
            if('Vencido'.equals(filtroEstatus)||'Default'.equals(filtroEstatus)) {
                query='SELECT OwnerId, Owner.Name, EU_001_ls_Indicadores_de_cartera__c,Name,EU_001_dv_Compromiso__c,EU_fm_Fecha_Cierre__c,EU_001_ls_Estatus__c,EU_001_Rb_Oportunidad__r.Name,EU_001_Rb_Oportunidad__c,EU_001_Rb_Oportunidad__r.MX_RTL_Familia__c,EU_001_Rb_Oportunidad__r.MX_RTL_Producto__c, EU_001_Rb_Oportunidad__r.AccountId, EU_001_Rb_Oportunidad__r.Account.Name, EU_001_Rb_Oportunidad__r.StageName, EU_001_Fm_Cliente__c, Cliente__c, Cliente__r.Name,EU_001_tx_Compromiso__c, MX_EU_TipoPriorizacion__c FROM EU_001_Compromiso__c WHERE EU_001_Rb_Revisi_n_Individual_RI__c =: IdRI and EU_001_ls_Estatus__c=:lsEstatus and EU_001_ls_Indicadores_de_cartera__c=:lInds and MX_EU_Avance__c=:listType ';
            } else {
                query='SELECT OwnerId, Owner.Name, EU_001_ls_Indicadores_de_cartera__c,Name,EU_001_dv_Compromiso__c,EU_fm_Fecha_Cierre__c,EU_001_ls_Estatus__c,EU_001_Rb_Oportunidad__r.Name,EU_001_Rb_Oportunidad__c,EU_001_Rb_Oportunidad__r.MX_RTL_Familia__c,EU_001_Rb_Oportunidad__r.MX_RTL_Producto__c, EU_001_Rb_Oportunidad__r.AccountId, EU_001_Rb_Oportunidad__r.Account.Name, EU_001_Rb_Oportunidad__r.StageName, EU_001_Fm_Cliente__c, Cliente__c, Cliente__r.Name,EU_001_tx_Compromiso__c, MX_EU_TipoPriorizacion__c FROM EU_001_Compromiso__c WHERE EU_001_Rb_Revisi_n_Individual_RI__c =: IdRI and EU_001_ls_Estatus__c=:filtroEstatus and EU_001_ls_Indicadores_de_cartera__c=:lInds and MX_EU_Avance__c=:listType ';
            }
        } else {
				query='SELECT OwnerId, Owner.Name, EU_001_ls_Indicadores_de_cartera__c,Name,EU_001_dv_Compromiso__c,EU_fm_Fecha_Cierre__c,EU_001_ls_Estatus__c,EU_001_Rb_Oportunidad__r.Name,EU_001_Rb_Oportunidad__c,EU_001_Rb_Oportunidad__r.MX_RTL_Familia__c,EU_001_Rb_Oportunidad__r.MX_RTL_Producto__c, EU_001_Rb_Oportunidad__r.AccountId, EU_001_Rb_Oportunidad__r.Account.Name, EU_001_Rb_Oportunidad__r.StageName, EU_001_Fm_Cliente__c, Cliente__c, Cliente__r.Name,EU_001_tx_Compromiso__c, MX_EU_TipoPriorizacion__c FROM EU_001_Compromiso__c WHERE EU_001_Rb_Revisi_n_Individual_RI__c =: IdRI and EU_001_ls_Indicadores_de_cartera__c=:lInds and MX_EU_Avance__c=:listType ';
        }

        if('Vencido'.equals(filtroEstatus)) {
            Date today = Date.today(); //NOSONAR
            conditions+= ' AND EU_fm_Fecha_Cierre__c <: today ';
        }
        if(string.isNotblank(fechainicio)) {
            Date fInicio = Date.valueOf(fechainicio); //NOSONAR
            conditions+= ' AND EU_fm_Fecha_Cierre__c >=:fInicio ';
        }
        if(string.isNotblank(fechafin)) {
            Date fFin = Date.valueOf(fechafin); //NOSONAR
            conditions+= ' AND EU_fm_Fecha_Cierre__c <=:fFin ';
        }
		if(string.isNotblank(campoPadre)) {
            conditions+= ' AND EU_001_Rb_Oportunidad__r.MX_RTL_Familia__c =:campoPadre';
        }
        if(string.isNotblank(campoHijo)) {
            conditions+= ' AND EU_001_Rb_Oportunidad__r.MX_RTL_Producto__c =:campoHijo';
        }
        conditions += ' ORDER BY EU001_Un_nivelPriorizacion__c desc nulls last, EU_fm_Fecha_Cierre__c ASC';
        query += conditions;
        List<EU_001_Compromiso__c> compromisosList = Database.query(query);
        return compromisosList;
    }
    /**metodo CompEU_Table */
    public class CompEU_Table {

        @AuraEnabled
        /** */
        public list<EU_001_Compromiso__c> lsOpp {get; set;}
        /** */
        public CompEU_Table( list<EU_001_Compromiso__c> toOpp) {

            this.lsOpp = toOpp;

        }
    }
    /** Lista*/
    public static List<String> getPickListValues() {
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = EU_001_Compromiso__c.EU_001_ls_Indicadores_de_cartera__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple) {
            pickListValuesList.add(pickListVal.getValue());
        }
        return pickListValuesList;
    }

    @AuraEnabled
    /** Lista getUser*/
    public static List<EU001_RI__c> getUser(String recordId) {
        List<EU001_RI__c> lista = new List<EU001_RI__c>();
        try {
            lista = EU001_cls_ConsolaDirector.getUser(recordId);
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return lista;
    }

    @AuraEnabled
    /** Metodo getRecordTypeId*/
    public static String getRecordTypeId(String sObjType ,String Concepto) {
        Id IdRType;
        try {
            IdRType = EU001_modApoyos_Ctrl.getRecordTypeId(sObjType , Concepto);
        } catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return ''+IdRType;
    }

}