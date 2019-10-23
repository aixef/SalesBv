/**-------------------------------------------------------------------------
 * Nombre: MX_SB_SAC_WS_ActSiniestros
 * Autor Ing. Eduardo Hernandez
 * Proyecto: MW WB LG - BBVA Bancomer
 * Descripción : Clase controler Actualizar Siniestro
 * Notas ::::   *Oportunidad Equivalente a Póliza
 * --------------------------------------------------------------------------
 * Versión      Fecha           Autor                   Descripción
 * -------------------------------------------------------------------
 * 1.0          18/12/2018      Ing. Eduardo Hernandez  Creación
 * 2.0          09/06/2019      Ing. Karen Sanchez      Modificación: Se cambia el objeto de Opp por Contratos
 * 3.0          19/08/2019      Ing. José Luis Vargas	Modificación: Se agrega constante para validar el resultado del WS
 * --------------------------------------------------------------------------
 */
public without sharing class MX_SB_SAC_WS_ActSiniestros {//NOSONAR

    /**
    * @description valor que se recibe de la operación del WS
    * @author Jose Luis Vargas
    */
    public static final String OPERRESULT = 'OK';
    
    /**
     * newToken recuperar token
     * @param  indica si se necesita generar un nuevo token
     * @return strToken token recuperado
     */
    @AuraEnabled
    public static String newToken(Boolean newToken) {

        String validToken = '';
        try{
            final DataLogin dataLog = assignLoginData();
            validToken = loginWibe(dataLog, newToken);
            if (String.isBlank(validToken)) {
                throw new QueryCustomException(System.Label.MX_SB_SAC_TokenInvalido,System.Label.MX_SB_SAC_TokenInvalido,System.Label.MX_SB_SAC_TokenInvalido,21);
            }
        } catch (QueryCustomException qEx) {
            throw new AuraHandledException(System.Label.MX_SB_SAC_TokenInvalido + qEx);
        }
        return validToken;
    }

    /* Hacer petición al WS
    * @return Mapa de Strings y objetos con la información de respuesta
    */
    @AuraEnabled
    public static Map<String, Object> responseActPol(String jsonOpp, String strToken) {

        String strTokenCopy = '';
        Map<String, Object> response = new Map<String, Object>();
        try {
            final Type oppType = Type.forName('Contract');
            final Contract oppInstance = (Contract)JSON.deserialize(jsonOpp, oppType);
            final DataLogin dataLog = assignLoginData();
            if(strToken.equalsIgnoreCase('false')) {
                strTokenCopy = newToken(true);
                }
            final String sToken = String.isNotBlank(strTokenCopy) ? strTokenCopy : strToken; 
            final String responseWS = executeRequestWS(dataLog.obtainUrlSiniestros(), oppInstance, sToken);
            response.put('responseWS', responseWS);
        } catch(JSONException jex) {
            throw new AuraHandledException(System.Label.MX_SB_SAC_ErrorBack + jex);
        }
        return response;
    }

    /**
     * assignLoginData Recupera información para el login y consumo del WS
     * @return   return DataLogin
     */
    private static DataLogin assignLoginData() {
        final MX_SB_SAC_LoginToken__c customSttngURL =  MX_SB_SAC_LoginToken__c.getInstance('Login Siniestros');  
        final MX_SB_SAC_LoginToken__c customSttngURLWS =  MX_SB_SAC_LoginToken__c.getInstance('Obtener Siniestros');
        final DataLogin dataLogin = new DataLogin(customSttngURL.Url__c, customSttngURL.Usr__c, customSttngURL.Pwd__c, customSttngURLWS.Url__c);
       return dataLogin;
    }

    /**
     * loginWibe genera un nuevo token
     * @param  dataLogin Datos de login
     * @param  newToken  especifica si se debe generar un nuevo token
     * @return           retorna el nuevo token
     */
    private static String loginWibe(DataLogin dataLogin, Boolean newToken) {
        String strTokenSession = '';
        if (newToken) {
           strTokenSession = generateWsToken(dataLogin);
        } else {
           final MX_SB_SAC_LoginToken__c loginSines =  MX_SB_SAC_LoginToken__c.getInstance('Login Siniestros');
           strTokenSession = generateToken(dataLogin, loginSines);
        }
        return strTokenSession;
    }

    /**
     * generateToken Se recupera el token guardado en la custom
     * @param  dataLogin  Datos de login
     * @param  loginSines Recuperar la custom Setting de MX_SB_SAC_LoginToken__c
     * @return            return regresa un token válido
     */
    private static String generateToken(DataLogin dataLogin, MX_SB_SAC_LoginToken__c loginSines) {
        String tokenCustom = ''; 
        if (String.isBlank(loginSines.Token__c)) {
            tokenCustom = generateWsToken(dataLogin);
        } else {
            tokenCustom = loginSines.Token__c;
        }
        return tokenCustom;
    }

    /**
     * generateWsToken Genera un token nuevo por petición a un WS
     * @param  dataLogin datos de login
     * @return           return nuevo token generado desde un WS
     */
    private static String generateWsToken(DataLogin dataLogin) {//NOSONAR
        String strTokenSessionWS = '';
        final MX_SB_SAC_GeneraToken_Cls.RespRestGetToken objResGetTokn = MX_SB_SAC_GeneraToken_Cls.getLoginToken('Login Siniestros');
        
        if (objResGetTokn.operacionResultado == OPERRESULT) {
            strTokenSessionWS = objResGetTokn.token;
        } else {
          throw new QueryCustomException(objResGetTokn.operacionResultado, objResGetTokn.operacionMensajeExtra, System.Label.MX_SB_SAC_ErrorWS, 66);
        }
        return strTokenSessionWS;
    }
    
    /**
     * executeRequestWS Realiza la petición del WS de siniestros
     * @param  urlEndPoint  url del WS de siniestros
     * @param  oppData      Objeto instanciado de la Oportunidad que se trabaja
     * @param  tokenSession token válido para petición del WS
     * @return              return Respuesta del consumo del servicio
     */
    public static String executeRequestWS(String urlEndPoint, Contract oppData, String tokenSession) {
        String responseSinisters = '';
        final MX_SB_SAC_SiniestrosDtoCls.datosConsultaSiniestro objCponsultaSini = new MX_SB_SAC_SiniestrosDtoCls.datosConsultaSiniestro();
        objCponsultaSini.ramo = '1';
        objCponsultaSini.poliza = oppData.MX_WB_noPoliza__c;
        objCponsultaSini.certificado = System.Label.MX_WB_LG_OppCertif;
        final MX_SB_SAC_SiniestrosDtoCls.respRestGetSiniestro objGetSini = MX_SB_SAC_SiniestrosDtoCls.getSiniestro(objCponsultaSini, urlEndPoint, tokenSession);
        
        final String sDetalle = String.valueOf(objGetSini.Detalle);
        if (sDetalle.contains('Operativa temporalmente no disponible') || sDetalle.contains('Token inválido') || sDetalle.contains('ERROR')) {
            throw new QueryCustomException(objGetSini.Detalle, objGetSini.NombreMetodo, System.Label.MX_WB_LG_TokenInvalido,84);
        } else {
            MX_SB_SAC_Utils_Cls.updateCustoSetting(tokenSession);
            MX_SB_SAC_Utils_Cls.matchSinisters(objGetSini, oppData.MX_WB_noPoliza__c);              
            responseSinisters = 'Correct';          
        }
        return responseSinisters;
    }
  
     /**
     * DAO para almacenar la información de login
     */
    public class DataLogin {
        /**variable endPoint */
        private final String endPoint {get;set;}
        /** variable userName*/
        private final String userName {get;set;}
        /**variable userPass */
        private final String userPass {get;set;}
        /** variable strPolicesEndPoint*/
        private final String sEndPoint {get;set;}

        /**
         * DataLogin Constructor del DAO
         * @param  endPoint           url del WS
         * @param  userName           usuario de login
         * @param  userPass           password de login
         * @param  sessionToken       token válido de session
         * @param  sEndPoint url recuperada del custom setting
         * @return                    instancia DAO
         */
        public DataLogin(String endPoint, String userName, String userPass, String sEndPoint) {
            this.endPoint = endPoint;
            this.userName = userName;
            this.userPass = userPass;
            this.sEndPoint = sEndPoint;
        }

        /**
         * obtainEndpoit encapsulamiento para el Endpoint
         * @return   endpoint
         */
        public String obtainEndpoit() {
            return this.endPoint;
        }

        /**
         * obtainUserName encapsulamiento para el Usuario de login
         * @return   usuario login
         */
        public String obtainUserName() {
            return this.userName;
        }

        /**
         * obtainUserName encapsulamiento para el userPass de login
         * @return   userPass login
         */
        public String obtainUserPass() {
            return this.userPass;
        }

        /**
         * obtainSessionToken encapsulamiento para el token de login
         * @return   sEndPoint
         */
        public String obtainUrlSiniestros() {
            return this.sEndPoint;
        }        
    }
}