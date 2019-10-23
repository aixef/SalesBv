/**
* @File Name          : MX_SB_SAC_Poliza_Cls.cls
* @Description        :
* @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
* @Group              :
* @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
* @Last Modified On   : 19/8/2019 17:43:14
* @Modification Log   :
*==============================================================================
* Ver         Date                     Author               Modification
*==============================================================================
* 1.0    19/8/2019 13:55:56   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
* 2.0    29/08/2019           José Luis Vargas Lara           Se reestructura la clase y se hacen ajustes marcados por sonnar
*                                                             Se agrega guardado de asegurado y conductor
* 3.0    26/09/2019           Michelle Valderrama Yapor       Se agregan tods los campos de Clipert a campos en Salesforce.
**/
public with sharing class MX_SB_SAC_Poliza_Cls {//NOSONAR

  /**
  * @description Constante con el genero masculino
  * @author José Luis Vargas Lara
  */
  public static final string MASCULINO = 'MASCULINO';
 /**
  * @description Constante con el tipo de persona
  * @author José Luis Vargas Lara
  */
  public static final string MORAL = 'MORAL';
 /**
  * @description Constante con el nombre de asegurado
  * @author José Luis Vargas Lara
  */
  public static final string ASEGURADO = 'nombreAsegurado';
  /**
  * @description Clase usada para el response de la consulta de poliza
  * @author José Luis Vargas Lara
  */
  public class RespRestGetPolizaPorNumeroDePoliza {
    /**
    * @description String nombreMetod
    * @author José Luis Vargas Lara
    */
    public String nombreMetodo {get; set;}
    /**
    * @description String error
    * @author José Luis Vargas Lara
    */
    public Boolean error {get; set;}
    /**
    * @description String detalle
    * @author José Luis Vargas Lara
    */
    public String detalle {get; Set;}
    /**
    * @description String json
    * @author José Luis Vargas Lara
    */
    public String jsonRes {get; set;}
  }
  /**
  * @description: Realiza la consulta de una poliza en Clipert
  * @author José Luis Vargas Lara
  * @param String jsonParams, parametros de busqueda
  * @param String sUrl, url del servicio Clippert
  * @param String sToken, Token generado para autorizacion de consulta
  * @param String sMetAction, Tipo de consulta a realizar
  * @return RespRestGetPolizaPorNumeroDePoliza con el resutado del proceso de consulta
  */
  public static RespRestGetPolizaPorNumeroDePoliza getPoliza(String jsonParams, String sUrl, String sToken, String sMetAction) {//NOSONAR
    final RespRestGetPolizaPorNumeroDePoliza objRespRestLoc = new RespRestGetPolizaPorNumeroDePoliza();
    String jsonBody = '';
    try {
      jsonBody = jsonParams;
      final String endpoint = sUrl + '' + sMetAction;
      HttpRequest request = new HttpRequest();
      request.setEndpoint(endpoint);
      request.setMethod('POST');
      request.setHeader('Accept', 'application/json, text/plain, */*');
      request.setHeader('Content-Type', 'application/json;charset=UTF-8');
      request.setTimeout(120000);
      request.setBody(jsonBody);
      request.setHeader('acces-token', sToken);
      final HTTPResponse res = new Http().send(request);
      final String sJasonRes = res.getBody();
      objRespRestLoc.nombreMetodo = sMetAction;
      objRespRestLoc.detalle = sJasonRes;
      objRespRestLoc.jsonRes = sJasonRes;
      objRespRestLoc.error = String.valueOf(res).contains('200') ? false :  true;
    } catch(Exception ex) {
      objRespRestLoc.Error = true;
      objRespRestLoc.Detalle = ex.getMessage();
    }
    return objRespRestLoc;
  }
  /**
  * @description: Crea la informacion del contrato y poliza en salesforce
  * @author José Luis Vargas Lara
  * @param String objPolizaDto, Objeto PolizaDto con el detalle de la poliza obtenido en clipert
  * @param String numeroPoliza, Numero de poliza consultado
  * @return Map<string, object> con el resutado del proceso
  */
  public static Map<String, Object> getPolizasSFDC(string objPolizaDto, string numeroPoliza) {
    Map<String, Object> processResp = new Map<String, Object>();
    final Map<String, Object> mapJson = (Map<String, Object>) JSON.deserializeUntyped(objPolizaDto);
    final String emailContrato =  MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('correoElectronicoContratante'));
    if (String.isNotBlank(emailContrato)) {
      final List<Account> oAccountPoliza = [SELECT Id, Name, PersonEmail FROM Account WHERE PersonEmail =: emailContrato];
      final String tipoPersona = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('tipoPersonaContratante'));
      Account cteUpsNvo = new Account();
      cteUpsNvo.Genero__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('generoContratante'));
      if(oAccountPoliza != null && !oAccountPoliza.isEmpty()) {
        cteUpsNvo.Id = oAccountPoliza[0].Id;
      }
      if(tipoPersona.equalsIgnoreCase(MORAL)) {
        cteUpsNvo.Name = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('nombreContratante'));
        cteUpsNvo.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Empresarial').getRecordTypeId();
      } else {
        cteUpsNvo.FirstName = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('nombreContratante'));
        cteUpsNvo.LastName = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('apellidoPaternoContratante'));
        cteUpsNvo.ApellidoMaterno__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('apellidoMaternoContratante'));
        cteUpsNvo.PersonBirthdate = MX_SB_SAC_Utils_Cls.fechaDDMMYYYYTOYYYYMMDD((String)mapJson.get('fechaNacimientoContratante'));
        cteUpsNvo.PersonHomePhone = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('telefonoCasaContratante'));
      }
      cteUpsNvo.Profesion__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('profesionAsegurado'));
      cteUpsNvo.Nacionalidad__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('nacionalidadContratante'));
      cteUpsNvo.Telefono_Oficina__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('telefonoOficinaContratante'));
      cteUpsNvo.Phone = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('telefonoCelularContratante'));
      cteUpsNvo.PersonEmail = emailContrato;
      cteUpsNvo.RFC__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('rfcContratante'));
      cteUpsNvo.Tipo_Persona__c = tipoPersona;
      cteUpsNvo.BillingStreet = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('direccionContratante'));
      cteUpsNvo.Colonia__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('coloniaContratante'));
      cteUpsNvo.Delegacion__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('poblacionContratante'));
      cteUpsNvo.BillingState = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('estadoContratante'));
      cteUpsNvo.BillingPostalCode = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('cpContratante'));
      cteUpsNvo.MX_SB_SAC_Homoclave__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('homoclaveContratante'));
      upsert cteUpsNvo;
      processResp = arrContract(cteUpsNvo, mapJson, numeroPoliza);
    }
    return processResp;
  }

  /**
  * @description: Crea la informacion del contrato en salesforce
  * @author José Luis Vargas Lara
  * @param Account cuentaContrato, Cuenta asociada al  contrato
  * @param Map<String, Object> mapJson, Mapa con el detalle de la poliza
  * @param string numeroPoliza, Numero de poliza
  * @return Map<string, object> con el resutado del proceso
  */
  public static Map<String, Object> arrContract(Account cuentaContrato, Map<String, Object> mapJson, string numeroPoliza) {
    final Map<String, Object> arrAccCont = new Map<String, Object>();
    string generoContratante = '';
    final List<Contract> contExt = [SELECT Id, Name, MX_WB_noPoliza__c FROM Contract WHERE MX_WB_noPoliza__c =: numeroPoliza];
    Contract contratoNew = new Contract();
    contratoNew.MX_WB_nombreAsegurado__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get(ASEGURADO));
    if(contExt != null && !contExt.isEmpty()) {
      contratoNew.Id=contExt[0].Id;
    }
    generoContratante = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('generoAsegurado'));
    if(generoContratante.toUpperCase() == MASCULINO) {
      generoContratante = 'H';
    } else {
      generoContratante = 'M';
    }
    contratoNew.MX_WB_nombreAsegurado__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get(ASEGURADO));
    contratoNew.MX_WB_apellidoMaternoAsegurado__c =MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('apellidoMaternoAsegurado'));
    contratoNew.MX_WB_apellidoPaternoAsegurado__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('apellidoPaternoAsegurado'));
    contratoNew.MX_WB_Sexo__c = generoContratante;
    contratoNew.MX_WB_emailAsegurado__c = cuentaContrato.PersonEmail;
    contratoNew.MX_WB_celularAsegurado__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('telefonoCelularAsegurado'));
    contratoNew.MX_WB_telefonoAsegurado__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('telefonoCelularAsegurado'));
    contratoNew.AccountId = cuentaContrato.Id;
    contratoNew.MX_WB_noPoliza__c = numeroPoliza;
    contratoNew.StartDate = MX_SB_SAC_Utils_Cls.fechaYYYYMMDDHHMMSS(MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('fechaInicioVigencia')));
    final Product2 prod = MX_SB_SAC_Business_Cls.getProductSAC(MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('producto')));
    if(prod != null) {
      contratoNew.MX_WB_Producto__c = prod.Id;
    }
    camposContrato(contratoNew,mapJson);
    upsert contratoNew;
    GuardarAsegurado(mapJson, contratoNew.Id);
    GuardarConductor(mapJson, contratoNew.Id);
    arrAccCont.put('status','OK');
    arrAccCont.put('msjResponse','Póliza creada y/o actualizada correctamente');
    arrAccCont.put('arrAcctCont',contratoNew);
    return arrAccCont;
  }
  /**
  * @description: Crea la informacion del contrato parte 2 en salesforce (modificación para Sonar)
  * @author Michelle Valderrama Yapor
  * @param Contract contratoNew, contrato a actualizar
  * @param Map<String, Object> mapJson, Mapa con el detalle de la poliza
  */
  public static void camposContrato(Contract contratoNew, Map<String, Object> mapJson) {
    contratoNew.status = 'Draft';
    contratoNew.MX_WB_numeroSerie__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('numeroSerie'));
    contratoNew.MX_WB_noMotor__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('numeroMotor'));
    contratoNew.MX_WB_placas__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('placas'));
    contratoNew.MX_WB_subMarca__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('submarca'));
    contratoNew.MX_WB_Marca__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('marca'));
    contratoNew.MX_WB_Tipo_de_auto__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('tipoVehiculo'));
    contratoNew.MX_SB_SAC_ClaveSB__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('clavesb'));
    contratoNew.MX_SB_SAC_Anio__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('anio'));
    contratoNew.MX_SB_SAC_Version__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('version'));
    contratoNew.MX_SB_MLT_DescripcionVehiculo__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('descripcion'));
    contratoNew.MX_SB_SAC_Servicio__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('servicio'));
    contratoNew.MX_SB_SAC_Agencia__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('agencia'));
    contratoNew.MX_SB_SAC_Capacidad__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('capacidad'));
    contratoNew.MX_SB_SAC_FechaVenta__c = MX_SB_SAC_Utils_Cls.fechaYYYYMMDDHHMMSS(MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('fechaVenta')));
    contratoNew.MX_SB_SAC_FechaAltaPoliza__c = MX_SB_SAC_Utils_Cls.fechaYYYYMMDDHHMMSS(MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('fechaAltaPoliza')));
    contratoNew.MX_SB_SAC_Plan__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('plan'));
    contratoNew.MX_SB_SAC_EstatusPoliza__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('estatusPoliza'));
    contratoNew.MX_SB_SAC_NumeroFolio__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('noFolio'));
    contratoNew.MX_SB_VTS_Nombre_Intermediario__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('intermediario'));
    contratoNew.MX_SB_SAC_Subproducto__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('subProducto'));
    contratoNew.MX_SB_SAC_Renovacion__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('renovacion'));
    contratoNew.MX_SB_SAC_BeneficiarioPreferente__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('beneficiarioPreferente'));
    contratoNew.MX_SB_SAC_ZonaCirculacion__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('zonaCirculacion'));
    contratoNew.MX_SB_SAC_Operador__c =MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('operador'));
    contratoNew.MX_SB_SAC_Canal__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('canal'));
    contratoNew.MX_SB_SAC_Subcanal__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('subcanal'));
    contratoNew.MX_SB_SAC_NoCuenta__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('numeroCuenta'));
    contratoNew.MX_SB_SAC_SolicitudFactura__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('solicitudFactura'));
    contratoNew.MX_SB_SAC_TipoPago__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('tipoPago'));
    contratoNew.MX_SB_SAC_Promocion__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('promocion'));
    contratoNew.MX_SB_SAC_DescuentoFacultado__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('descuentoFacultado'));
    contratoNew.MX_SB_SAC_FormaPago__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('formaPago'));
    contratoNew.MX_SB_VTS_Precio_Anual__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('importe'));
    contratoNew.MX_SB_SAC_FechaFinContrato__c = MX_SB_SAC_Utils_Cls.fechaYYYYMMDDHHMMSS(MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('fechaFinVigencia')));
  }
  /**
  * @description: Guarda el asegurado de la poliza
  * @author José Luis Vargas Lara
  * @param Map<String, Object> mapJson, Mapa con la informacion de la poliza
  * @param Id contractId, Id de contrato
  * @return Void
  */
  public static void guardarAsegurado(Map<String, Object> mapJson, Id contractId) {
    final Id rTypeAsegurado = MX_SB_VTS_Beneficiario__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Asegurado').getRecordTypeId();
    final List<MX_SB_VTS_Beneficiario__c> lstAsegurado = [SELECT Id FROM MX_SB_VTS_Beneficiario__c WHERE MX_SB_VTS_Contracts__c =: contractId AND RecordTypeId =: rTypeAsegurado];
    MX_SB_VTS_Beneficiario__c oAseguradoNew = new MX_SB_VTS_Beneficiario__c();
    oAseguradoNew.Name = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get(ASEGURADO));
    if(lstAsegurado != null && !lstAsegurado.isEmpty()) {
      oAseguradoNew.Id = lstAsegurado[0].Id;
    }
    oAseguradoNew.Name = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get(ASEGURADO));
    oAseguradoNew.MX_SB_VTS_APaterno_Beneficiario__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('apellidoPaternoAsegurado'));
    oAseguradoNew.MX_SB_VTS_AMaterno_Beneficiario__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('apellidoMaternoAsegurado'));
    oAseguradoNew.MX_SB_SAC_FechaNacimiento__c = MX_SB_SAC_Utils_Cls.fechaDDMMYYYYTOYYYYMMDD((String)mapJson.get('fechaNacimientoAsegurado'));
    oAseguradoNew.MX_SB_SAC_Genero__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('generoAsegurado'));
    oAseguradoNew.MX_SB_SAC_Profesion__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('profesionAsegurado'));
    oAseguradoNew.MX_SB_SAC_Nacionalidad__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('nacionalidadAsegurado'));
    oAseguradoNew.MX_SB_SAC_TelefonoOficina__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('telefonoOficinaAsegurado'));
    oAseguradoNew.MX_SB_SAC_TelefonoCelular__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('telefonoCelularAsegurado'));
    oAseguradoNew.MX_SB_SAC_Email__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('correoElectronicoAsegurado'));
    oAseguradoNew.MX_SB_SAC_RFC__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('rfcAsegurado'));
    oAseguradoNew.MX_SB_SAC_Direccion__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('direccionAsegurado'));
    oAseguradoNew.MX_SB_SAC_Colonia__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('coloniaAsegurado'));
    oAseguradoNew.MX_SB_SAC_Poblacion__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('poblacionAsegurado'));
    oAseguradoNew.MX_SB_SAC_EstadoRepublica__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('estadoAsegurado'));
    oAseguradoNew.MX_SB_SAC_CodigoPostal__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('cpAsegurado'));
    oAseguradoNew.MX_SB_SAC_Homoclave__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('homoclaveAsegurado'));
    oAseguradoNew.RecordTypeId = rTypeAsegurado;
    oAseguradoNew.MX_SB_VTS_Contracts__c = contractId;
    Upsert oAseguradoNew;
  }
  /**
  * @description: Guarda el conductor de la poliza
  * @author José Luis Vargas Lara
  * @param Map<String, Object> mapJson, Mapa con la informacion de la poliza
  * @param Id contractId, Id de contrato
  * @return Void
  */
  public static void guardarConductor(Map<String, Object> mapJson, Id contractId) {
    Id rTypeConductor;
    List<MX_SB_VTS_Beneficiario__c> lstAsegurado;
    if(string.isNotBlank((String)mapJson.get('nombreConductorAsignado'))) {
      MX_SB_VTS_Beneficiario__c oConductorNew = new MX_SB_VTS_Beneficiario__c();
      oConductorNew.Name = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('nombreConductorAsignado'));
      rTypeConductor = MX_SB_VTS_Beneficiario__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Conductor').getRecordTypeId();
      lstAsegurado = [SELECT Id FROM MX_SB_VTS_Beneficiario__c WHERE MX_SB_VTS_Contracts__c =: contractId AND RecordTypeId =: rTypeConductor];
      if(lstAsegurado != null && !lstAsegurado.isEmpty()) {
        oConductorNew.Id = lstAsegurado[0].Id;
      }
      oConductorNew.Name = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('nombreConductorAsignado'));
      oConductorNew.MX_SB_VTS_APaterno_Beneficiario__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('apellidoPaternoConductorAsignado'));
      oConductorNew.MX_SB_VTS_AMaterno_Beneficiario__c = MX_SB_SAC_Utils_Cls.validaDatoVacio((String)mapJson.get('apellidoMaternoConductorAsignado'));
      oConductorNew.MX_SB_SAC_FechaNacimiento__c = MX_SB_SAC_Utils_Cls.fechaDDMMYYYYTOYYYYMMDD((String)mapJson.get('fecNacConductorAsignado'));
      oConductorNew.RecordTypeId = rTypeConductor;
      oConductornEW.MX_SB_VTS_Contracts__c = contractId;
      Upsert oConductorNew;
    }
  }
}