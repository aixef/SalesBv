/**
* ------------------------------------------------------------------------------
* @Nombre: MX_SB_SAC_ConsultaContrato_TEST
* @Autor: José Luis Vargas Lara
* @Proyecto: SB SAC - BBVA Bancomer
* @Descripción : File de prueba para MX_SB_SAC_ConsultaContrato
* ------------------------------------------------------------------------------
* @Versión       Fecha           Autor                         Descripción
* ------------------------------------------------------------------------------
* 1.0           29/08/2019     José Luis Vargas Lara	         File test
* ------------------------------------------------------------------------------
*/
@isTest
private class MX_SB_SAC_ConsultaContrato_TEST {
  /**
  * @description Contiene el JSON de la respuesta
  * @author Karen Sanchez
  */
  public static final String BODY = 'RespRestGetPolizaPorNumeroDePoliza:[Detalle={"nombreContratante":"ATE@TE","apellidoPaternoContratante":"AS","apellidoMaternoContratante":"ATE@T","fechaNacimientoContratante":"17/01/1981","generoContratante":"H","profesionContratante":"EMPLEADO DE OFICINA","nacionalidadContratante":"EXTRANJERO","telefonoCasaContratante":null,"telefonoOficinaContratante":null,"telefonoCelularContratante":"5552123123","correoElectronicoContratante":"rodrigo.rios@development.adesis.com","rfcContratante":"AAAA810117","homoclaveContratante":null,"tipoPersonaContratante":"FISICA","direccionContratante":"MARIANO ESCOBEDO","coloniaContratante":"ADAN CASTELAN","poblacionContratante":"PÁNUCO","estadoContratante":"VERACRUZ","cpContratante":"11320","nombreAsegurado":"ATE@TE","apellidoPaternoAsegurado":"AS","apellidoMaternoAsegurado":"ATE@T","fechaNacimientoAsegurado":"17/01/1981","generoAsegurado":"MASCULINO","profesionAsegurado":"EMPLEADO DE OFICINA","nacionalidadAsegurado":"EXTRANJERO","telefonoOficinaAsegurado":null,"telefonoCelularAsegurado":"5552123123","correoElectronicoAsegurado":"rodrigo.rios@development.adesis.com","rfcAsegurado":"AAAA810117","homoclaveAsegurado":null,"direccionAsegurado":"MARIANO ESCOBEDO","coloniaAsegurado":"ADAN CASTELAN","poblacionAsegurado":"PÁNUCO","estadoAsegurado":"VERACRUZ","cpAsegurado":"11320","nombreConductorAsignado":"Angel","apellidoPaternoConductorAsignado":"Garcia","apellidoMaternoConductorAsignado":null,"fecNacConductorAsignado":null,"numeroPoliza":null,"fechaVenta":"2015-09-22 00:00:00.0","fechaAltaPoliza":"2015-09-22 00:00:00.0","fechaInicioVigencia":"2015-09-22 00:00:00.0","fechaFinVigencia":"2016-09-22 00:00:00.0","producto":"WIBE","plan":null,"tipoVehiculo":"SUV","formaPago":"MENSUAL","beneficiarioPreferente":null,"solicitudFactura":"OK","tipoPago":"DEBITO A TARJETAS DE CREDITO","promocion":null,"descuentoFacultado":null,"importe":"801.17","estatusPoliza":"ACTIVA","anio":"2010","marca":"FORD","submarca":"ECOSPORT","version":"4X2 MP3 USB","descripcion":"FORD ECOSPORT 4X2 MP3 USB AA EE CD BA ESTANDAR SUV 4 CIL 5 P 5 OCUP","servicio":"PARTICULAR","agencia":null,"numeroMotor":null,"numeroSerie":"D12D12D12","placas":null,"clavesb":"304GBV","capacidad":"5","zonaCirculacion":"VERACRUZ","operador":"WIBE","canal":"INTERNET","subcanal":"WEB","numeroCuenta":"************6456","noFolio":"1728747","intermediario":"NEGOCIO DIRECTO","subProducto":"AUTO WIBE","renovacion":"0"}, Error=false, JsonRes={"nombreContratante":"ATE@TE","apellidoPaternoContratante":"AS","apellidoMaternoContratante":"ATE@T","fechaNacimientoContratante":"17/01/1981","generoContratante":"H","profesionContratante":"EMPLEADO DE OFICINA","nacionalidadContratante":"EXTRANJERO","telefonoCasaContratante":null,"telefonoOficinaContratante":null,"telefonoCelularContratante":"5552123123","correoElectronicoContratante":"rodrigo.rios@development.adesis.com","rfcContratante":"AAAA810117","homoclaveContratante":null,"tipoPersonaContratante":"FISICA","direccionContratante":"MARIANO ESCOBEDO","coloniaContratante":"ADAN CASTELAN","poblacionContratante":"PÁNUCO","estadoContratante":"VERACRUZ","cpContratante":"11320","nombreAsegurado":"ATE@TE","apellidoPaternoAsegurado":"AS","apellidoMaternoAsegurado":"ATE@T","fechaNacimientoAsegurado":"17/01/1981","generoAsegurado":"MASCULINO","profesionAsegurado":"EMPLEADO DE OFICINA","nacionalidadAsegurado":"EXTRANJERO","telefonoOficinaAsegurado":null,"telefonoCelularAsegurado":"5552123123","correoElectronicoAsegurado":"rodrigo.rios@development.adesis.com","rfcAsegurado":"AAAA810117","homoclaveAsegurado":null,"direccionAsegurado":"MARIANO ESCOBEDO","coloniaAsegurado":"ADAN CASTELAN","poblacionAsegurado":"PÁNUCO","estadoAsegurado":"VERACRUZ","cpAsegurado":"11320","nombreConductorAsignado":null,"apellidoPaternoConductorAsignado":null,"apellidoMaternoConductorAsignado":null,"fecNacConductorAsignado":null,"numeroPoliza":null,"fechaVenta":"2015-09-22 00:00:00.0","fechaAltaPoliza":"2015-09-22 00:00:00.0","fechaInicioVigencia":"2015-09-22 00:00:00.0","fechaFinVigencia":"2016-09-22 00:00:00.0","producto":"WIBE","plan":null,"tipoVehiculo":"SUV","formaPago":"MENSUAL","beneficiarioPreferente":null,"solicitudFactura":"OK","tipoPago":"DEBITO A TARJETAS DE CREDITO","promocion":null,"descuentoFacultado":null,"importe":"801.17","estatusPoliza":"ACTIVA","anio":"2010","marca":"FORD","submarca":"ECOSPORT","version":"4X2 MP3 USB","descripcion":"FORD ECOSPORT 4X2 MP3 USB AA EE CD BA ESTANDAR SUV 4 CIL 5 P 5 OCUP","servicio":"PARTICULAR","agencia":null,"numeroMotor":null,"numeroSerie":"D12D12D12","placas":null,"clavesb":"304GBV","capacidad":"5","zonaCirculacion":"VERACRUZ","operador":"WIBE","canal":"INTERNET","subcanal":"WEB","numeroCuenta":"************6456","noFolio":"1728747","intermediario":"NEGOCIO DIRECTO","subProducto":"AUTO WIBE","renovacion":"0"}, NombreMetodo=obtenerPolizaPorNumeroDePoliza]';
  /**
  * @description Contiene el JSON con el detalle de la poliza
  * @author Jose Luis Vargas
  */
  public static final string BODY_POLIZA = '{"nombreContratante":"J@WJFS","apellidoPaternoContratante":"REZFT","apellidoMaternoContratante":"CVFW@T","fechaNacimientoContratante":"01/01/1997","generoContratante":"H","profesionContratante":"EMPLEADO DE OFICINA","nacionalidadContratante":"EXTRANJERO","telefonoCasaContratante":null,"telefonoOficinaContratante":null,"telefonoCelularContratante":"4535435344","correoElectronicoContratante":"javier.reyes.3.contractor@bbva.com","rfcContratante":"RECJ970101545","homoclaveContratante":"545","tipoPersonaContratante":"FISICA","direccionContratante":"MARIANO ESCOBEDO","coloniaContratante":"ARTURO GAMI","poblacionContratante":"ÁLVARO OBREGÓN","estadoContratante":"CIUDAD DE MEXICO","cpContratante":"11320","nombreAsegurado":"J@WJFS","apellidoPaternoAsegurado":"REZFT","apellidoMaternoAsegurado":"CVFW@T","fechaNacimientoAsegurado":"01/01/1997","generoAsegurado":"MASCULINO","profesionAsegurado":"EMPLEADO DE OFICINA","nacionalidadAsegurado":"EXTRANJERO","telefonoOficinaAsegurado":null,"telefonoCelularAsegurado":"4535435344","correoElectronicoAsegurado":"javier.reyes.3.contractor@bbva.com","rfcAsegurado":"RECJ970101545","homoclaveAsegurado":"545","direccionAsegurado":"MARIANO ESCOBEDO","coloniaAsegurado":"ARTURO GAMI","poblacionAsegurado":"ÁLVARO OBREGÓN","estadoAsegurado":"CIUDAD DE MEXICO","cpAsegurado":"11320","nombreConductorAsignado":"Angel","apellidoPaternoConductorAsignado":"Garcia","apellidoMaternoConductorAsignado":null,"fecNacConductorAsignado":null,"numeroPoliza":null,"fechaVenta":"2015-10-27 00:00:00.0","fechaAltaPoliza":"2015-10-27 00:00:00.0","fechaInicioVigencia":"2015-10-27 00:00:00.0","fechaFinVigencia":"2016-10-27 00:00:00.0","producto":"WIBE","plan":null,"tipoVehiculo":"COUPE","formaPago":"MENSUAL","beneficiarioPreferente":null,"solicitudFactura":"OK","tipoPago":"DEBITO A TARJETAS DE CREDITO","promocion":null,"descuentoFacultado":null,"importe":"2724.8","estatusPoliza":"ACTIVA","anio":"2015","marca":"NISSAN","submarca":"370Z","version":"3.7L TOURING","descripcion":"NISSAN 370Z 3.7L TOURING AA EE CD BA VP AUTOMATICO COUPE 6 CIL 3 P 2 OCUP","servicio":"PARTICULAR","agencia":null,"numeroMotor":null,"numeroSerie":"SADASDSD32424","placas":"SDADS32","clavesb":"204HBP","capacidad":"2","zonaCirculacion":"DISTRITO FEDERAL","operador":"WIBE","canal":"INTERNET","subcanal":"WEB","numeroCuenta":"************4324","noFolio":"1729475","intermediario":"NEGOCIO DIRECTO","subProducto":"AUTO WIBE","renovacion":"0"}';
  /**
  * @description Contiene JSON para obtener token
  * @author Karen Sanchez
  */
  public static final String BODYTOKEN = '{"token":"94044d223c4ca3acf131222d4772b927","operacionResultado":"OK","operacionMensaje":[],"browserUrl":null,"operacionMensajeExtra":""}';
  /**
  * @description Contiene el token
  * @author Karen Sanchez
  */
  public static final String TOKEN = '94044d223c4ca3acf131222d4772b927';
  /**
  * @description Contiene el criterio de entrada
  * @author Karen Sanchez
  */
  public static final String CRITERIO_ENTRADA = 'Número Póliza';
  /**
  * @description Contiene campos para la consulta
  * @author Karen Sanchez
  */
  public static final String CAMPOS_CONSULTA = '{"numeroPoliza":"895W0A0017"}';
  /**
  * @description Constante con el mensaje de error
  * @author Jose Luis Vargas Lara
  */
  public static final String ERROR = 'error';
  /**
  * @description: test para el getParams
  * @author José Luis Vargas Lara
  * @return Void
  */
  @isTest
  static void getParamsTest() {
    Map<string, string> mpParametros = new Map<string, string>();
    Test.startTest();
    final MX_SB_SAC_ParametrosPoliza__c paramPol = MX_SB_SAC_UtileriasTestCls.creaCSParametros();
    insert paramPol;
    mpParametros = MX_SB_SAC_ConsultaContrato.getParams();
    System.assertEquals(mpParametros.get('Número Póliza'), 'Número Póliza', 'Parametros Correctos');
    Test.stopTest();
  }
  /**
  * @description: test para el ConsultaPoliza
  * @author José Luis Vargas Lara
  * @return Void
  */
  @isTest
  static void consultaPolizaTest() {
    Map<String, Object> mpPoliza = new Map<String, Object>();
    final MX_SB_SAC_LoginToken__c logTok = MX_SB_SAC_UtileriasTestCls.creaCredencial();
    logTok.Name = 'Actualiza Polizas';
    insert logTok;
    FINAL MX_SB_SAC_ParametrosPoliza__c paramPol = MX_SB_SAC_UtileriasTestCls.creaCSParametros();
    insert paramPol;
    final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', BODY,new Map<String,String>());
    final MX_WB_Mock mockError = new MX_WB_Mock(500,'ERROR', BODY,new Map<String,String>());
    Test.startTest();      
    Test.setMock(HttpCalloutMock.class, mock);
    mpPoliza = MX_SB_SAC_ConsultaContrato.consultaPoliza(CAMPOS_CONSULTA, CRITERIO_ENTRADA);
    Test.setMock(HttpCalloutMock.class, mockError);
    MX_SB_SAC_ConsultaContrato.consultaPoliza(CAMPOS_CONSULTA, CRITERIO_ENTRADA);
    System.assertEquals(string.valueOf(mpPoliza.get('jsonResp')), BODY, 'Consulta correcta');
    Test.stopTest();
  }
  /**
  * @description: test para el getToken
  * @author José Luis Vargas Lara
  * @return Void
  */
  @isTest
  static void getTokenTest() {
    final MX_SB_SAC_LoginToken__c logTok = MX_SB_SAC_UtileriasTestCls.creaCredencial();
    logTok.Name = 'Login Wibe';
    insert logTok;
    final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', BODYTOKEN,new Map<String,String>());
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, mock);
    final string tokenServicio = MX_SB_SAC_ConsultaContrato.getToken();
    System.assertEquals(TOKEN, tokenServicio, 'Token correcto');
    Test.stopTest();
  }
  /**
  * @description: test para el creaModificaPoliza
  * @author José Luis Vargas Lara
  * @return Void
  */
  @isTest
  static void creaModificaPolizaTest() {
    Map<String, Object> mpResponse = new Map<String, Object>();
    final Map<string, object> mpPoliza = new Map<string, object>();
    mpPoliza.put(ERROR, false);
    mpPoliza.put('jsonResp', BODY_POLIZA);
    Test.startTest();
    mpResponse = MX_SB_SAC_ConsultaContrato.creaModificaPoliza('819W0A001K', mpPoliza);
    mpPoliza.remove(ERROR);
    mpPoliza.put(ERROR, true);
    mpResponse = MX_SB_SAC_ConsultaContrato.creaModificaPoliza('819W0A001K', mpPoliza);
    System.assert((boolean)mpResponse.get(ERROR), 'Poliza creada/actualizada correctamente');
    Test.stopTest();
  }
}