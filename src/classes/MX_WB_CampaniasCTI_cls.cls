/**-------------------------------------------------------------------------
* Nombre: WB_ProcNotif_cls
* @author Karen Sanchez (KB)
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Clase que se ocupa para enviar datos a CTI y regresar una consulta al componente MX_WB_CampaniasCTI_cmp

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           13/01/2019      Karen Sanchez            Creación
*          1.1           17/01/2019      Arsenio Perez            Modificacion de busqueda Ln 30-38
*          1.2           18/06/2019      Arsenio PErez            Modificacion de envios lead para smart center
*          1.2.1         21/06/2019      Jaime Terrats            Se soluciona code smell
* --------------------------------------------------------------------------*/
public without sharing class MX_WB_CampaniasCTI_cls {

    /**Lista AllApiName */
    static final List<String> AllApiName = new List<String>();
    /** Lista searchFilter */
    static final List<String> searchFilter = new List<String>();
    /** variable searchKey, cadena1 */
    static String searchKey, cadena1;
    /** variable tipo objeto*/
    final static String SOBJECTO = 'Lead';
    /** Lista Generica*/
    static final List<MX_SB_VTS_Generica__c> Generica = new List<MX_SB_VTS_Generica__c>();
    /**Mapa mapGenerica */
    static final Map<String,String> mapGenerica = new Map<String, String>();
    static {
        searchKey = '';
        cadena1 = '';
        for(MX_SB_VTS_Generica__c gentemp: MX_SB_VTS_Generica__c.getall().values()) {
            if('CP2'.equals(gentemp.MX_SB_VTS_Type__c)) {
                Generica.add(gentemp);
                mapGenerica.put(gentemp.MX_SB_VTS_FiltroCampanaLabel__c,gentemp.MX_SB_VTS_FiltroCampana__c);
            }
        }
    }

    /*13-01-2019 Función: Regresa la consulta de los miembros de campañas de la campaña activa
    *Karen Belem Sanchez Ruiz*/
    @AuraEnabled
    public static List < CampaignMember > lstCampaignMember(String searchKeyWord, String cadena) {
        try {
        searchKey = searchKeyWord;
        final List<CampaignMember> lstOfCampaign = new List<CampaignMember>();
            final String USerID =UserInfo.getUserId();
            final String tempProvedor= [Select MX_SB_VTS_ProveedorCTI__c from user where id =:USerID].MX_SB_VTS_ProveedorCTI__c;
        String sQuery = 'SELECT LeadId, Lead.MX_WB_EnvioCTI__c, Lead.FirstName, Lead.LastName, Lead.Apellido_Materno__c, Lead.Fecha_Nacimiento__c,';
               sQuery +=' Lead.MX_WB_txt_Prefijo_1__c, Lead.MX_WB_ph_Telefono1__c, Lead.MX_WB_ph_Telefono2__c, Lead.MX_WB_ph_Telefono3__c, Lead.Folio_Cotizacion__c,';
               sQuery +=' Lead.Producto_Interes__c, Lead.OwnerId, Lead.EnviarCTI__c, Lead.MX_WB_TM_Congelado__c, campaign.MX_SB_VTS_Segmentada__c  FROM CampaignMember WHERE campaign.ID =: searchKey';
               sQuery +=' AND lead.MX_WB_Convertido__c = false AND lead.MX_WB_TM_Congelado__c = false AND LeadId != null AND campaign.IsActive = true';
               sQuery +=' AND Campaign.MX_SB_VTS_FamiliaProducto_Proveedor__r.MX_SB_VTS_Identificador_Proveedor__c=: tempProvedor';
        if(String.isNotBlank(cadena)) {
            sQuery = sQuery + cadena;
        }
        List < CampaignMember > lstOfRecords = Database.query(sQuery);//NOSONAR
        for (CampaignMember obj: lstOfRecords) {
            lstOfCampaign.add(obj);
        }
        return lstOfCampaign;
        } catch(QueryException err) {
            throw new AuraHandledException(Label.MX_WB_ERROR + '\nMensaje: ' + err.getMessage() + '\nLinea: ' + err.getLineNumber() + err);
        }
    }

    /*13-01-2019 Función: Regresa la consulta de las etiquetas de un customsetting que sirve para el filtrado de los miembros de campañas
    *Karen Belem Sanchez Ruiz*/
    @AuraEnabled
    public static  List<String> getListSettings(String Segmentado) {
    try {
        final Boolean Segmentado_tem = Boolean.valueOf(Segmentado);
        final List<String> AllLabels = new List<String>();
        if(Segmentado_tem) {
            for(MX_SB_VTS_Generica__c gemtemp: Generica) {
                 AllLabels.add(gemtemp.MX_SB_VTS_FiltroCampanaLabel__c);
            }
        } else {
            final String type = Label.MX_WB_camposFiltrados;
            final Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            final Schema.SObjectType leadSchema = schemaMap.get(type);
            final Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            for (String fieldName: fieldMap.keySet()) {
                if(fieldMap.get(fieldName).getDescribe().isCustom()) {
                    AllLabels.add(fieldMap.get(fieldName).getDescribe().getLabel());
                }
            }
        }
        return AllLabels;
        } catch(QueryException qError) {
            throw new AuraHandledException(Label.MX_WB_ERROR + '\nMensaje: ' + qError.getMessage() + '\nLinea: ' + qError.getLineNumber() + qError);
        }
    }

    /*13-01-2019 Función: Regresa la cadena que se selecciona para filtrar los miembros que se enviarán a CTI
    *Karen Belem Sanchez Ruiz*/
    @AuraEnabled
    public static String getListFilter(String field, String selectedOperator, String addValue, String Segmentado) {
    try {
        final Boolean Segmentadotem = Boolean.valueOf(Segmentado);
        Boolean limitado = false;
        if(Segmentadotem) {
           limitado=Segmentadotemtrue(selectedOperator,  addValue,field);
        } else {
          limitado= Segmentadotemfalse(selectedOperator,  addValue,field);
        }
        if(limitado == true) {
            cadena1 = cadena1 + ' LIMIT '+ addValue;
        }
        return cadena1;
        } catch(QueryException qError) {
            throw new AuraHandledException(Label.MX_WB_ERROR + '\nMensaje: ' + qError.getMessage() + '\nLinea: ' + qError.getLineNumber() + qError);
        }
    }

    /*Función: Regresa la query consultada.*/
    public static String cadenresp(String cadena1, String selectedOperator, String sKeyApiValue, String addValue) {
         String cadena1temp;
         switch on selectedOperator {
                    when 'CONTAINS' {
                        cadena1temp = cadena1 + ' AND Lead.'+sKeyApiValue+' LIKE \'%'+addValue+'%\'';
                    }
                    when 'NOT(CONTAINS)' {
                        cadena1temp = cadena1 + ' AND (NOT Lead.'+sKeyApiValue+' LIKE \'%'+addValue+'%\')';
                    }
                    when else {
                        cadena1temp = cadena1 + ' AND Lead.'+sKeyApiValue+' '+selectedOperator+' \''+addValue+'\'';
                    }
                }
                searchFilter.add(cadena1temp);
                return cadena1temp;
    }
    /**
    *
    */
    public static Boolean Segmentadotemtrue(String selectedOperator, String addValue,string field) {
        String sKeyApiValue;
        Boolean limitado = false;
         for(String fieldName: mapGenerica.keySet()) {
                if(field==fieldName) {
                    sKeyApiValue=mapGenerica.get(field);
                    if('limite__c'.equals(sKeyApiValue)) {
                        limitado = true;
                        break;
                    }
                    cadena1= cadenresp(cadena1,selectedOperator,sKeyApiValue,addValue);
                }
            }
            return limitado;
    }
    /**
    *
    */
    public static Boolean Segmentadotemfalse(String selectedOperator, String addValue, String field) {
        String sKeyApiValue;
        Set<String> setKeyApi = new Set<String>();
        Boolean limitado = false;
        final Map<String, String> mapApiLabel= new Map<String, String>();
        final String type = String.valueOf(label.MX_WB_CamposFiltrados);
        final Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        final Schema.SObjectType leadSchema = schemaMap.get(type);
        final Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
         for(String fieldName: fieldMap.keySet()) {
                if(field == fieldMap.get(fieldName).getDescribe().getLabel() ) {
                    mapApiLabel.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
                    setKeyApi = mapApiLabel.keySet();
                    for(String sKeyApi:setKeyApi) {
                        sKeyApiValue = sKeyApi;
                    }
                    if('limite__c'.equals(sKeyApiValue)) {
                        limitado = true;
                        break;
                    }
                cadena1= cadenresp(cadena1,selectedOperator,sKeyApiValue,addValue);
                }
            }
            return limitado;
    }
    @AuraEnabled
    /* funcion lstLeadEnviarCTI */
    public static Boolean lstLeadEnviarCTI(List<CampaignMember> searchResult,Boolean Segmentado, String fechaHora, String bandeja) {
        Boolean ret = true;
        try {
        if(Segmentado) {
            lstLeadEnviarSmart(searchResult, fechaHora, bandeja);
        } else {
            lstLeadEnviarCTIe(searchResult);
        }
        } catch(DmlException e) {
            ret = false;
            throw new AuraHandledException(Label.MX_WB_ERROR + '\nMensaje: ' + e.getMessage() + '\nLinea: ' + e.getLineNumber() + e);
        }
        return ret;
    }

    /*13-01-2019 Función: función que sirve para hacer el envio a la funcion futura ftProcesaSol
    *Karen Belem Sanchez Ruiz*/
    public static Boolean lstLeadEnviarCTIe(List<CampaignMember> searchResult) {
        try {
        final Lead objLead = new Lead();
        final Date fechaEnvio = Date.today();
        final List<Sobject> ListUpdate = new List<Sobject>();
        for(CampaignMember camp : searchResult ) {

            objLead.Id = camp.LeadId;
            objLead.Folio_Cotizacion__c = String.ISBLANK(camp.Lead.Folio_Cotizacion__c) ? '' : camp.Lead.Folio_Cotizacion__c;
            objLead.Producto_Interes__c = camp.Lead.Producto_Interes__c == null ? '' : camp.Lead.Producto_Interes__c;
            objLead.OwnerId = camp.Lead.OwnerId;
            objLead.FirstName = camp.Lead.FirstName;
            objLead.MX_WB_ph_Telefono1__c = camp.Lead.MX_WB_ph_Telefono1__c;
            objLead.MX_WB_ph_Telefono2__c = camp.Lead.MX_WB_ph_Telefono2__c;
            objLead.MX_WB_ph_Telefono3__c = camp.Lead.MX_WB_ph_Telefono3__c;

            MX_WB_CTI_cls.ftProcesaSol(String.valueOf(objLead.Id),
                                          String.valueOf(objLead.Folio_Cotizacion__c),
                                          'ASD',
                                          String.valueOf(objLead.OwnerId),
                                          String.valueOf(objLead.FirstName),
                                          String.valueOf(objLead.MX_WB_ph_Telefono1__c), SOBJECTO, 3,
                                          String.valueOf(objLead.MX_WB_ph_Telefono2__c),String.valueOf(objLead.MX_WB_ph_Telefono3__c));
            objLead.MX_WB_EnvioCTI__c = fechaEnvio;
            objLead.MX_WB_TM_Congelado__c = true;
            if(ListUpdate.contains(objLead)==false) {
            	ListUpdate.add(objLead);
            }
        }
            update ListUpdate;
        return true;
        } catch(QueryException qError) {
            throw new AuraHandledException(Label.MX_WB_ERROR + '\nMensaje: ' + qError.getMessage() + '\nLinea: ' + qError.getLineNumber() + qError);
        }
    }
     @AuraEnabled
     /* Funcion fetchLookUpValues */
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        final String searchKeyForm = searchKeyWord + '%';
        final List < sObject > returnList = new List < sObject > ();
        final String USerID =UserInfo.getUserId();
        final String tempProvedor= [Select MX_SB_VTS_ProveedorCTI__c from user where id =:USerID].MX_SB_VTS_ProveedorCTI__c;
        String sQuery = 'SELECT name,campaign.Id, campaign.Name FROM CampaignMember WHERE campaign.Name LIKE: searchKeyForm';
               sQuery +=' AND lead.MX_WB_Convertido__c = false AND lead.MX_WB_TM_Congelado__c = false AND LeadId != null AND campaign.IsActive = true';
               sQuery +=' AND Campaign.MX_SB_VTS_FamiliaProducto_Proveedor__r.MX_SB_VTS_Identificador_Proveedor__c=: tempProvedor order by createdDate DESC limit 5';
        final List < CampaignMember > lstOfRecords = Database.query(sQuery);
        for (CampaignMember obj: lstOfRecords) {
            final Campaign temcamp = new Campaign(Name=obj.campaign.Name,Id=obj.campaign.Id);
            returnList.add(temcamp);
        }
        return returnList;
    }
    /* Función  lstLeadEnviarSmart */
    public static Boolean lstLeadEnviarSmart(List<CampaignMember> searchResult, String fechaHora, String bandeja) {
        final List<Lead> Litstsend = new List<lead>();
        final Date fechaEnvio = Date.today();
        boolean ret = false;
        for(CampaignMember camp : searchResult ) {
            final Lead lobjLead  =new Lead();
            lobjLead.Id = camp.LeadId;
            lobjLead.Folio_Cotizacion__c = String.ISBLANK(camp.Lead.Folio_Cotizacion__c) ? '' : camp.Lead.Folio_Cotizacion__c;
            lobjLead.Producto_Interes__c = camp.Lead.Producto_Interes__c == null ? '' : camp.Lead.Producto_Interes__c;
            lobjLead.OwnerId = camp.Lead.OwnerId;
            lobjLead.FirstName = camp.Lead.FirstName;
            lobjLead.MX_WB_ph_Telefono1__c = camp.Lead.MX_WB_ph_Telefono1__c;
            lobjLead.MX_WB_ph_Telefono2__c = camp.Lead.MX_WB_ph_Telefono2__c;
            lobjLead.MX_WB_ph_Telefono3__c = camp.Lead.MX_WB_ph_Telefono3__c;
            lobjLead.MX_WB_EnvioCTI__c = fechaEnvio;
            lobjLead.MX_WB_TM_Congelado__c = true;
            Litstsend.add(lobjLead);
        }
        try {
            String strFecha = fechaHora.replace('T', ' ');
            strFecha = strFecha.replace('Z', ' ');
	        final datetime dateFormat = Datetime.valueOf(strFecha);
            final String strConvertedDate = dateFormat.format('dd/MM/yyyy HH:mm:ss','America/New_York');
            final Map<Id, String> dateData = new Map<Id, String>();
            for(Lead tempLead: Litstsend) {
                dateData.put(tempLead.Id, strConvertedDate);
            }
            MX_SB_VTS_SendLead_helper_cls.EntRegistroGestion_invoke(System.label.MX_SB_VTS_Envio_Lead, Litstsend, '', '2', bandeja, dateData);
            update Litstsend;
            ret= true;
        } catch(Exception e) {
            ret= false;
        }
        return ret;
    }
}
