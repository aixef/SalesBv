/**
----------------------------------------------------------
* Nombre: MX_SB_SAC_GeneraToken_Cls
* Autor Saúl González
* Proyecto: SB SAC - BBVA Bancomer
* Descripción :
* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                               Descripción
* --------------------------------------------------------------------------------
* 1.0           04/04/2019     Saúl González                        Creación
* 2.0           15/07/2019   Karen Belem Sanchez Ruiz               Corrección issues de sonar
* --------------------------------------------------------------------------------
*/

public with sharing class MX_SB_SAC_GeneraToken_Cls {//NOSONAR

    /**
    * @description valor que se recibe de la operación del WS
    * @author Karen Sanchez
    */
    public static final String OPERRESULT = 'OK';

    /*
    * @description
    * @param
    */
    public class TokenDto {
        /**
        * Usuario
        */
        public String usuario {get;set;}
        /**
        * Contraseña
        */
        public String password {get;set;}
    }

    /*
    * @description
    * @param
    */
    public class RespRestGetToken {
        /**
        * Token
        */
        public String token {get;set;}
        /**
        * operacionMensaje
        */
        public List<String> operacionMensaje {get;set;}
        /**
        * browseUrl
        */
        public String browseUrl {get;set;}
        /**
        * operacionResultado
        */
        public String operacionResultado {get;set;} //NOSONAR
        /**
        * operacionMensajeExtra
        */
        public String operacionMensajeExtra {get;set;} //NOSONAR
    }

    /*
    * @description
    * @param
    */
    public class RespRestGetTokenSFDC {
        /**
        * Nombre
        */
        public String NombreMetodo {get;set;}//NOSONAR
        /**
        * Error
        */
        public Boolean Error {get;set;}//NOSONAR
        /**
        * Detalle
        */
        public String Detalle {get;Set;}//NOSONAR
        /**
        * JsonRes
        */
        public String JsonRes {get;set;}//NOSONAR
    }

    /*
    * @description
    * @param
    */
    public class ErrorFormaDto {
    /**
        * errorFormDto
        */
        public ErrorFormDto errorFormDto {get;set;}
    }

    /*
    * @description
    * @param
    */
    public class errorFormDto {
        /**
        * operacionMensaje
        */
        public List<String> operacionMensaje {get;set;}
        /**
        * browserUrl
        */
        public String browserUrl {get;set;}
        /**
        * operacionResultado
        */
        public String operacionResultado {get;Set;}//NOSONAR
        /**
        * operacionMensajeExtra
        */
        public String operacionMensajeExtra {get;set;}//NOSONAR
    }

    /*
    * @description
    * @param
    */
    public static RespRestGetTokenSFDC getToken(TokenDto objTokenDto, String sUrl) {
        final RespRestGetTokenSFDC objRespRestLoc = new RespRestGetTokenSFDC();
        String sMetAction = '';
        String jSONBody = '';
        HTTPResponse res;
        String sJasonRes;
        try {

            if (objTokenDto != null) {
                jSONBody = JSON.serialize(objTokenDto);
                sMetAction = 'generarToken';
            }
            final String endpoint = sUrl + '' + sMetAction;
            System.debug('Generartoken.endpoint::'+endpoint);
            final HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Accept', 'application/json, text/plain, */*');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setTimeout(120000);
            request.setBody(jSONBody);

            res = new Http().send(request);
                sJasonRes = res.getBody();
                objRespRestLoc.NombreMetodo = sMetAction;
                objRespRestLoc.Detalle = sJasonRes;
                objRespRestLoc.JsonRes = sJasonRes;
                objRespRestLoc.Error = String.valueOf(res).contains('200') ? true : false;

        } catch(Exception ex) {
            objRespRestLoc.Error = true;
            objRespRestLoc.Detalle = ex.getMessage();
        }
        return objRespRestLoc;
    }
    /*
    * @description
    * @param
    */
    public static RespRestGetToken jSONParserGetToken(String sJsonResp) {
        RespRestGetToken objSiniestroResp = new RespRestGetToken();
        try {
            final JSONParser parser = JSON.createParser(sJsonResp);
            objSiniestroResp = (RespRestGetToken)parser.readValueAs(RespRestGetToken.class);
        } catch(Exception ex) {
            objSiniestroResp.operacionMensaje.add(ex.getMessage());
            objSiniestroResp.operacionResultado = 'ERROR';
        }
        return objSiniestroResp;
    }
    /*
    * @description
    * @param
    */
    public static RespRestGetToken getLoginToken(String sCSlogin) {
        RespRestGetToken objRespRestGetToken = new RespRestGetToken();
        final MX_SB_SAC_LoginToken__c customSttngURL =  MX_SB_SAC_LoginToken__c.getInstance(sCSlogin);
        final TokenDto objTokenDto = new TokenDto();
        objTokenDto.usuario = customSttngURL.Usr__c;
        objTokenDto.password = customSttngURL.Pwd__c;
        final RespRestGetTokenSFDC objRespGetTkn = getToken(objTokenDto, customSttngURL.Url__c);
        objRespRestGetToken = jSONParserGetToken(objRespGetTkn.JsonRes);
        if (objRespRestGetToken.operacionResultado == OPERRESULT) {
            final DateTime dtHoraIni = DateTime.now();
            final DateTime dtHoraFin = dtHoraIni.addSeconds(Integer.valueof(customSttngURL.Duracion__c));
            customSttngURL.Token__c = objRespRestGetToken.token;
            customSttngURL.FechaIni__c = DateTime.now();
            customSttngURL.FechaFin__c = dtHoraFin;
        }
        return objRespRestGetToken;
    }
}