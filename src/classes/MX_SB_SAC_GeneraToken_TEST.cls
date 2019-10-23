/*
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
@isTest
private class MX_SB_SAC_GeneraToken_TEST {
    /**
    * @description Contiene la URL del endpoint
    * @author Karen Sanchez
    */
    public static final String URL = 'urlHttp';
    /**
    * @description Contiene el token para obtener token
    * @author Karen Sanchez
    */
    public static final String BODY = '{"token":"11aafdc20ebf418e2bba978b45eafa9f","operacionResultado":"OK","operacionMensaje":[],"browserUrl":null,"operacionMensajeExtra":""}';

    /**
     * Obtener token
     */
    @isTest
    static void getToken() {
        final MX_SB_SAC_GeneraToken_Cls.errorFormDto errFtDto = new MX_SB_SAC_GeneraToken_Cls.errorFormDto();
        final MX_SB_SAC_GeneraToken_Cls.ErrorFormaDto errorFDTO = new MX_SB_SAC_GeneraToken_Cls.ErrorFormaDto();
        final MX_SB_SAC_GeneraToken_Cls.RespRestGetTokenSFDC objResp = new MX_SB_SAC_GeneraToken_Cls.RespRestGetTokenSFDC();
        final List<String> sOperacionMensaje = new List<String>();
        objResp.Error = false;

        Test.startTest();

        	errFtDto.operacionMensaje = sOperacionMensaje;
            errFtDto.browserUrl = '';
            errFtDto.operacionResultado = '';
            errFtDto.operacionMensajeExtra = '';
        	errorFDTO.errorFormDto = errFtDto;
        	final MX_SB_SAC_GeneraToken_Cls.TokenDto tokenDTO = new MX_SB_SAC_GeneraToken_Cls.TokenDto();
        	tokenDTO.usuario='user';
        	tokenDTO.password='pwd';
        	MX_SB_SAC_GeneraToken_Cls.getToken(tokenDTO, URL);
            System.assertEquals(false,objResp.Error,'No hubo error en recuperar token');
        Test.stopTest();
    }
    /**
     * Obtener login para token
     */
    @isTest
    static void getLoginToken() {

        final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', BODY ,new Map<String,String>());
        final MX_SB_SAC_GeneraToken_Cls.RespRestGetToken rspToken = new MX_SB_SAC_GeneraToken_Cls.RespRestGetToken();
        final List<String> sOperacionMensaje = new List<String>();
        rspToken.operacionMensajeExtra='';
        rspToken.operacionMensaje=sOperacionMensaje;
        rspToken.browseUrl='';
        final MX_SB_SAC_LoginToken__c logToken = MX_SB_SAC_UtileriasTestCls.creaCredencial();
        logToken.Name = 'Actualiza Polizas';
        insert logToken;
        Test.setMock(HttpCalloutMock.class, mock);
            Test.startTest();
        	MX_SB_SAC_GeneraToken_Cls.getLoginToken(logToken.Name);
            System.assertEquals('https://www.wibe.com/cotizadores/api/commons/controller/polizas/',logToken.Url__c,'La url es correcta');
        Test.stopTest();
    }


}