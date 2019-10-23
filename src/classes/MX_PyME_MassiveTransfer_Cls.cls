/*
* ------------------------------------------------------------------------------------------------
* @Name         MX_PyME_MassiveTransfer_Cls
* @Author       BBVA
* @Date         Created :  2019-05-14
* @Group        PYME
* @Description  Class that makes massive account transfers
* @Changes      (most recent first)
*  |2019-05-14  First version
*  |2019-05-22
*  |2019-05-22 | Daniel García     | Correcciones sonar
*  |2019-07-23 | Cindy Hernández   | Resolución de code smells detectados por sonar. Se modifica el método createCase para tener un sólo return.
                                     Se crea el método insertCases.
   |2019-07-29 | Cindy Hernández   | Se crea el método getDivCli.
   |2019-07-31 | Cindy Hernández   | En el método createCase, se cambia el nombre de la variable clientesCasosAbiertos por cltsOpenCases.
                                     Se utliza la etiqueta NOSONAR para falsos positivos con "Potentially unused variable" en variables que si se utilizan.
   |2019-08-02 | Cindy Hernández   | Se crean los métodos getAmongDivisionsBoolean, validateDirDivision y getNoClientes.
* ------------------------------------------------------------------------------------------------
*/
public with sharing class MX_PyME_MassiveTransfer_Cls {

	//Constructor with no arguments
	@TestVisible
    private MX_PyME_MassiveTransfer_Cls() {
    }
/**
* String with value 'MASA'
*/
    static final String MASA_STRING = 'MASA';
/**
* String with value 'Account'
*/
    static final String ACCOUNT_STRING = 'Account';
/**
* String with value 'User'
*/
    static final String USER_STRING = 'User';
/**
* String with value 'divCl'
*/
    static final String DIVCL_STRING = 'divCl';
/**
* String with value 'OCCIDENTE'
*/
    static final String OCCIDENTE_STR = 'OCCIDENTE';
/**
* String with value 'NOROESTE'
*/
    static final String NOROESTE_STR = 'NOROESTE';

    /*------------------------------------------------------------------------------------------------------
    *@Description Method to get data from Account
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-05-14
    * @param    objectName (Name of the object to search in)
    * @param    fldAPIText (Refers to field Name)
    * @param    fldAPIVal (Refers to field Id)
    * @param    fldAPINoCl (Refers to field No_de_cliente__c)
    * @param    fieldAPIUg (Refers to field UG__c)
    * @param    fieldAPIDiv (Refers to field Divisi_n__c)
    * @param    field_API_mbUsuario (Refers to field FederationIdentifier)
    * @param    fieldAPIBanca (Refers to field Banca__c)
    * @param    fieldAPIDivCl (Refers to field Division1__c)
    * @param    lim (Number of records)
    * @param    fldAPISearch (API name of field that will be searched)
    * @param    searchText (String that will be searched)
    * @return   String with object information
    * @example  String result = searchDB('Account','Name', 'Id','No_de_cliente__c','','', 'Division1__c', '' ,4,'Name', 'SLSFRC' );
    * */
    @AuraEnabled(cacheable = true)
    public static String searchDB(String objectName, String fldAPIText, String fldAPIVal, String fldAPINoCl, String fieldAPIUg, String fieldAPIDiv, String fieldAPIDivCl, String fieldAPIBanca , Integer lim, String fldAPISearch, String searchText ) {
        List<SObject> lstObj = new List<SObject>(); //NOSONAR
        String textToLook = searchText;
        textToLook = String.escapeSingleQuotes(searchText.trim());
        Boolean isAccount = false,isUser = false; //NOSONAR

        String listRecords = 'FIND \''+String.escapeSingleQuotes(textToLook)+'\' IN ALL FIELDS RETURNING '+String.escapeSingleQuotes(objectName)+'('+String.escapeSingleQuotes(fldAPIText)+','+String.escapeSingleQuotes(fldAPIVal);
        if(objectName == ACCOUNT_STRING) {
            isAccount = true; //NOSONAR
            listRecords += ',' + String.escapeSingleQuotes(fldAPINoCl) + ',' + String.escapeSingleQuotes(fieldAPIDivCl) +' LIMIT ' + String.escapeSingleQuotes(String.valueof(lim)) + ')';
        } else if(objectName == USER_STRING) {
            isUser = true; //NOSONAR
            listRecords +=',' + String.escapeSingleQuotes(fieldAPIDiv) + ',' + String.escapeSingleQuotes(fieldAPIUg) + ',' + String.escapeSingleQuotes(fieldAPIBanca) + ' LIMIT ' + String.escapeSingleQuotes(String.valueof(lim)) + ')';
        }
        List<List<SObject>> searchList = new List<List<SObject>>();
        try {
            searchList = search.query(listRecords); //NOSONAR
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        lstObj = ((List<SObject>)searchList[0]);
        final List<ResultWrapper> lstRet = new List<ResultWrapper>();
        ResultWrapper obj;
        for(SObject s : lstObj) {
            obj = new ResultWrapper();
            obj.objName = objectName;
            obj.text = String.valueOf(s.get(fldAPIText)) ;
            obj.val = String.valueOf(s.get(fldAPIVal)) ;
            obj.clientNumber = '';
            obj.divCl = '';
            obj.unidadG = '';
            obj.div = '';
            obj.banca = '';
            if(isAccount) {
                obj.clientNumber = String.valueOf(s.get(fldAPINoCl));
                obj.divCl = String.valueOf(s.get(fieldAPIDivCl));
            }
            if(isUser) {
                obj.unidadG = String.valueOf(s.get(fieldAPIUg));
                obj.div = String.valueOf(s.get(fieldAPIDiv));
                obj.banca = String.valueOf(s.get(fieldAPIBanca));
            }
            lstRet.add(obj);
        }
        return JSON.serialize(lstRet) ;
    }

/*------------------------------------------------------------------------------------------------------
*@Description Method to wrapping the search result.
* -----------------------------------------------------------------------------------------------------
* */
    public class ResultWrapper {
/**
* Name of the object to search in.
*/
        public String objName {get;set;}
/**
* Refers to the field name.
*/
        public String text {get;set;}
/**
* Refers to field Id.
*/
        public String val {get;set;}
/**
* Refers to field No_de_cliente__c.
*/
        public String clientNumber {get;set;}
/**
* Refers to field UG__c.
*/
        public String unidadG {get;set;}
/**
* Refers to field Divisi_n__c.
*/
        public String div {get;set;}
/**
* Refers to field Banca__c.
*/
        public String banca {get;set;}
/**
* Refers to field Division1__c.
*/
        public String divCl {get;set;}
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to get data from Account
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-05-14
    * @param    allData List of Objects received from lightning component
    * @param    accountSelected String with information of the most recent account selected
    * @return   List with one or more objects.
    * @example  List <Object> Objects = checkDuplicatedRecords(lstOfObjects, accountSelected);
    * */
    @AuraEnabled(cacheable=true)
    public static List<Object> checkDuplicatedRecords(List<Object> allData, Object accountSelected ) {
        final set<Object> accounts = new set<Object>(allData);
        try {
            accounts.add(accountSelected);
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return new List<Object>(accounts);
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to get data from Account
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-05-14
    * @param    allData List of Objects received from lightning component
    * @param    userSelected String with information of the Executive selected
    * @param    isObject Indicates if the parameter received is an object
    * @return   String with final status when creating a case record
    * @example  createCase(allData,userSelected,isObject);
    * */
    @AuraEnabled
    public static String createCase(List<Object> allData, String userSelected, boolean isObject) {
        final List<Object> listObj = (List<Object>) allData; //NOSONAR
        String aprovalSend;
        Boolean carryOn = true; //NOSONAR
        if(allData.isEmpty()) {
            aprovalSend = Label.MX_PyME_Error_8_Referencia_a_cliente_faltante;
        } else {
            //Mapa que contiene divisiones con sus respectivos clientes (No. clientes)
            Map<Object,Object> mapObject;
            Map<String, Object> results;
            final Map<String,List<String>> divClientes = new Map<String,List<String>>();
            String noCl,divCli;
            final Set<String> ncls = new Set<String>();

            for(Object o : listObj) {
                Object objDeserialized;
                if(isObject) {
                    objDeserialized = JSON.deserializeUntyped((string)o);
                    results = (Map<String, Object>) objDeserialized;
                    //mapObject = new Map <Object, Object>();
                    noCl = (string)results.get('clientNumber');
                } else {
                    //objDeserialized = null;
                    mapObject = (Map<Object,Object>) o;
                    noCl = String.valueOf(mapObject.get('clientNumber'));
                }
                divCli = getDivCli(results, mapObject, isObject);

                final List<String> noClientes = getNoClientes(divClientes, divCli);

                noClientes.add(noCl);
                divClientes.put(divCli,noClientes);
                ncls.add(noCl);
            }
            List<Case> casosAbiertos = new List<Case>();
            Set<String> nclts = new Set<String>();
            Set<String> cltsOpenCases = new set<String>();
            List<Account> accOwner = new List<Account>();
            try {
                casosAbiertos = [SELECT id, AccountId, CS_tx_numeroCliente__c, Detalle_de_soluci_n__c, CaseNumber FROM Case WHERE status = 'Solicitada'];
                nclts = getNclts(casosAbiertos); //NOSONAR
                cltsOpenCases = new set<String>(); //NOSONAR
                accOwner = [Select name, ownerId, Propietario_del_cliente__c From Account Where No_de_cliente__c IN : ncls]; //NOSONAR
            } catch (QueryException e) {
                throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
            }
            for(String ncAcc : ncls) {
                if(String.isBlank(ncAcc)) {
                    aprovalSend = Label.MX_PyME_Error_7_UG_Faltante;
                    carryOn = false;
                    break;
                } else {
                    if(nclts.contains(ncAcc)) {
                        //Open cases exist
                        cltsOpenCases.add(ncAcc);
                    }
                }
            }
            if(carryOn) {
                aprovalSend = insertCases(userSelected, casosAbiertos, cltsOpenCases, divClientes, accOwner);
            }
        }
        return aprovalSend;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          29-07-2019
* @Description  Insert the cases.
* @Comments     Created from the clipped code block of method createCase.
* @param        String userSelected, List<Case> casosAbiertos, Set<String> cltsOpenCases,
                Map<String,List<String>> divClientes, List<Account> accOwner
* @return       String In case it exists, it contains the error message.
* @example      getNclts(casosAbiertos)
**/
    public static String insertCases(String userSelected, List<Case> casosAbiertos, Set<String> cltsOpenCases, Map<String,List<String>> divClientes, List<Account> accOwner) {
        String aprovalSend;

        if(casosAbiertos.isEmpty()) {
            Case caso;
            String noClientes;
            final List<Case> casesCreated = new List<Case>();

            //Información de Ejecutivo destino
            final Map<String, Object> datosUsuario = (Map<String, Object>)JSON.deserializeUntyped(String.valueof(userSelected));
            final String nombreEjecDestino = (String) datosUsuario.get('text'); //NOSONAR
            final String unidadG = (String) datosUsuario.get('unidadG'); //NOSONAR
            final Id idUsDestino = (String) datosUsuario.get('val'); //NOSONAR
            final String divisionDestino = (String) datosUsuario.get('div');

            for(String div : divClientes.keySet()) {
                caso = new Case(); //NOSONAR
                noClientes = String.valueOf(divClientes.get(div));
                //Se valida que el campo con los No. de Clientes no esté vacio
                if(String.isNotBlank(noClientes)) {
                    caso.RecordTypeId =RecordTypeMemory_cls.getRecType('Case','MX_PyME_Case_CarterizacionPyME');
                    caso.Status = 'Solicitada';
                    caso.Detalle_de_soluci_n__c = noClientes;
                }
                caso.MX_PyME_Division__c = divisionDestino;
                if(!String.isNotBlank(divisionDestino)) {
                    aprovalSend = Label.MX_PyME_Error_2_Division_Faltante;
                    break;
                }

                //Se valida si la división del Dir CN es distinta a la del propietario de los clientes
                aprovalSend = validateDirDivision(div);
                if (!String.isBlank(aprovalSend)) {
                    break;
                }

                caso.MX_PyME_UG__c = unidadG;
                caso.MX_PyME_Nombre_del_ejecutivo_origen__c=accOwner[0].Propietario_del_cliente__c;
                caso.CS_rb_nombreEjecutivo__c = idUsDestino;
                caso.AP_tx_NombreEjecutivo__c = nombreEjecDestino;
                caso.MX_PyME_Division_origen__c = div;

                caso.MX_PyME_Traspaso_entre_divisiones__c = getAmongDivisionsBoolean(div, divisionDestino);

                caso.Alerta_Generada__c = true;
                casesCreated.add(caso);
            }
            if(!casesCreated.isEmpty()) {
            insert casesCreated;
            }
        } else {
            aprovalSend = Label.MX_PyME_Error_5_Folio_Existente + String.valueOf(cltsOpenCases).remove('{').remove('}');
        }
        return aprovalSend;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          29-07-2019
* @Description  Obtain the divCli string.
* @Comments     Created from the clipped code block of method createCase.
* @param        Map<String,Object> results, Map<Object,Object> mapObject, Boolean isObject
* @return       String The divCli string.
* @example      getDivCli(results, mapObject, isObject);
**/
    public static String getDivCli(Map<String,Object> results, Map<Object,Object> mapObject, Boolean isObject) {
        String divCli;
        if(isObject) {
            if(String.isBlank((string) results.get(DIVCL_STRING))) {
                divCli = MASA_STRING;
            } else {
                divCli = (string) results.get(DIVCL_STRING);
            }
        } else {
            if(string.isBlank(String.valueOf(mapObject.get(DIVCL_STRING)))) {
                divCli = MASA_STRING;
            } else {
                divCli = String.valueOf(mapObject.get(DIVCL_STRING));
            }
        }
        return divCli;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          30-07-2019
* @Description  Obtain the nclts set.
* @Comments     Created from the clipped code block of method createCase.
* @param        List<Case> casosAbiertos
* @return       Set<String> The nclts set.
* @example      getNclts(casosAbiertos);
**/
    public static Set<String> getNclts(List<Case> casosAbiertos) {
        final Set<String> nclts = new Set<String>();
        for(Case casoAbierto : casosAbiertos) {
            for(String noclientes : casoAbierto.Detalle_de_soluci_n__c.remove('(').remove(')').split(',')) {
                nclts.add(noclientes.trim());
            }
        }
        return nclts;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          02-08-2019
* @Description  Obtain the MX_PyME_Traspaso_entre_divisiones__c boolean.
* @Comments     Created from the clipped code block of method insertCases.
* @param        String div, String divisionDestino
* @return       Boolean The boolean to define if there is a transfer among divisions or not.
* @example      getAmongDivisionsBoolean(div, divisionDestino);
**/
    public static Boolean getAmongDivisionsBoolean(String div, String divisionDestino) {
        Boolean isAmongDivs = true; //Boolean to define if there is a transfer among divisions.
        if(div == divisionDestino) {
            isAmongDivs = false;
        }
        if((divisionDestino.contains(OCCIDENTE_STR) && div.contains(OCCIDENTE_STR))  || (divisionDestino.contains(NOROESTE_STR) && div.contains(NOROESTE_STR))) {
            isAmongDivs = false;
        }
        return isAmongDivs;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          02-08-2019
* @Description  Se valida si la división del Dir CN es distinta a la del propietario de los clientes
* @Comments     Created from the clipped code block of method insertCases.
* @param        String div
* @return       String The error message.
* @example      validateDirDivision(div);
**/
    public static String validateDirDivision(String div) {
        final List<User> dirCN = [SELECT id,Name,UG__c,CR__c,Divisi_n__c  FROM User WHERE id =: UserInfo.getUserId()];
        String aprovalSend;
        if(dirCN[0].Divisi_n__c != div && !MASA_STRING.equals(div) && !(dirCN[0].Divisi_n__c.contains(OCCIDENTE_STR) && div.contains(OCCIDENTE_STR)) && !(dirCN[0].Divisi_n__c.contains(NOROESTE_STR) && div.contains(NOROESTE_STR))) {
            aprovalSend = Label.MX_PyME_Error_6_UG_Erronea_Divsion;
        }
        return aprovalSend;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          02-08-2019
* @Description  Get client numbers list.
* @Comments     Created from the clipped code block of method createCase.
* @param        Map<String,List<String>> divClientes, String divCli
* @return       List<String> The client number list.
* @example      getNoClientes(divClientes, divCli);
**/
    public static List<String> getNoClientes(Map<String,List<String>> divClientes, String divCli) {
        List<String> noClientes = new List<String>();
        if(divClientes.containsKey(divCli)) {
            noClientes = divClientes.get(divCli);
        }
        return noClientes;
    }
}