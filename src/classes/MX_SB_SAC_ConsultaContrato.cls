/**
* @File Name          : MX_SB_SAC_ConsultaContrato.cls
* @Description        :
* @Author             : Saul
* @Group              :
* @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
* @Last Modified On   : 27/8/2019 19:30:36
* @Modification Log   :
*==============================================================================
* Ver         Date                     Author               Modification
*==============================================================================
* 1.0    14/8/2019 18:18:44         Saul                  Initial Version
* 2.0    14/8/2019 18:18:44         Karen B. Sanchez Ruiz  (KB)   Corrección issues
* 3.0    28/08/2019                    Jose Luis Vargas Lara		  Reestructuracion de la clase
**/
public without sharing class MX_SB_SAC_ConsultaContrato {//NOSONAR
  
 /**
  * @description Constante con el mensaje de error
  * @author Jose Luis Vargas Lara
  */
  public static final String ERROR = 'error';
    
  /**
  * @description: Realiza la consulta de poliza en clipert
  * @author José Luis Vargas Lara
  * @param String camposConsulta, Parametros de busqueda que seran enviados a clipert
  * @param string tipoConsulta, tipo de consulta a realizar en clipert
  * @return Map<String, Object> con el detalle de la poliza consultada
  */
  @AuraEnabled
  public static Map<String, Object> consultaPoliza(String camposConsulta, String tipoConsulta) {
    final Map<String, Object> processResponse = new Map<String, Object>();
    final Map<String, String> metaP = (Map<String, String>) JSON.deserialize(camposConsulta, Map<String,String>.class);
    final Map<String, String> paramConsulta = new Map<String, String>();
    string token = '';
    MX_SB_SAC_LoginToken__c logTokPoliza = new MX_SB_SAC_LoginToken__c();
    MX_SB_SAC_ParametrosPoliza__c paramsPoliza = new MX_SB_SAC_ParametrosPoliza__c();
    String[] cmps = null;
    try {
      if(!Test.isRunningTest()) {
        token = getToken();
      }
      logTokPoliza = MX_SB_SAC_Business_Cls.getLoginToken('Actualiza Polizas');
      paramsPoliza = MX_SB_SAC_Business_Cls.getParamsPoliza(tipoConsulta);
      cmps = paramsPoliza.DescripcionCampos__c.split(',');
      for(String cPCS : cmps) {
        final String cPs = (String)metaP.get(cPCS);
        paramConsulta.put(cPCS,cPs);
      }
      paramConsulta.put('usuario',logTokPoliza.Usr__c);
      paramConsulta.put('password',logTokPoliza.Pwd__c);
      final String jsonMap=JSON.serialize(paramConsulta);
      final MX_SB_SAC_Poliza_Cls.respRestGetPolizaPorNumeroDePoliza reponsePoliza = MX_SB_SAC_Poliza_Cls.GetPoliza(jsonMap, logTokPoliza.Url__c, token, paramsPoliza.Metodo__c);
      if(reponsePoliza.Error) {
        processResponse.put(Error,true);
        processResponse.put('msgError',reponsePoliza.Detalle);
      } else {
        processResponse.put(Error,false);
        processResponse.put('jsonResp',reponsePoliza.JsonRes);
      }
    } catch(CustomException e) {
      throw new AuraHandledException(System.Label.MX_SB_SAC_ErrorConsultaContrato + e);
    }
    return processResponse;
  }
  /**
  * @description: Consulta el token de autenticacion para la consulta de poliza en clipert
  * @author José Luis Vargas Lara
  * @return String con el token obtenido
  */
  public static String  getToken() {//NOSONAR
    MX_SB_SAC_GeneraToken_Cls.RespRestGetToken tokenResponse = new MX_SB_SAC_GeneraToken_Cls.RespRestGetToken();
    tokenResponse = MX_SB_SAC_GeneraToken_Cls.getLoginToken('Login Wibe');
    return String.valueOf(tokenResponse.token);
  }
  /**
  * @description: Crea o modifica la informacion de un contrato, cuenta y poliza
  * @author José Luis Vargas Lara
  * @param String numeroPoliza, numero de poliza
  * @param Map<string, object> mpPoliza, mapa con la informacion de la poliza
  * @return Map<String, Object> con el resultado del proceso
  */
  @AuraEnabled
  public static Map<String, Object> creaModificaPoliza(string numeroPoliza, Map<string, object> mpPoliza) {
    Map<String, Object> processResponse = new Map<String, Object>();
    try {
      if((Boolean)mpPoliza.get(Error)) {
        processResponse = mpPoliza;
      } else {
        Map<String, Object> mapJson = new Map<String, Object>();
        mapJson = (Map<String, Object>) JSON.deserializeUntyped((String)mpPoliza.get('jsonResp'));
        processResponse = MX_SB_SAC_Poliza_Cls.getPolizasSFDC(JSON.serialize(mapJson), numeroPoliza);
        processResponse.put(Error,false);
        processResponse.put('msjResponse',processResponse.get('msjResponse'));
      }
    } catch(CustomException e) {
      throw new AuraHandledException(System.Label.MX_SB_SAC_ErrorConsultaContrato + e);
    }
    return processResponse;
  }
  /**
  * @description: Consulta los parametros de configuracion para la consulta a clipert
  * @author José Luis Vargas Lara
  * @return Map<String, String> con la informacion de los parametros
  */
  @AuraEnabled
  public static Map<String, String> getParams() {//NOSONAR
    final Map<String, String> mapParams = new Map<String, String>();
    List<MX_SB_SAC_ParametrosPoliza__c> paramPoliza = new List<MX_SB_SAC_ParametrosPoliza__c>();
    try {
      paramPoliza = MX_SB_SAC_ParametrosPoliza__c.getall().values();
      for(MX_SB_SAC_ParametrosPoliza__c pP :  paramPoliza) {
        mapParams.put(pP.Name,pP.Name);
      }
    } catch(CustomException e) {
      throw new AuraHandledException(System.Label.MX_SB_SAC_ErrorConsultaContrato + e);
    }
    return mapParams;
  }
}