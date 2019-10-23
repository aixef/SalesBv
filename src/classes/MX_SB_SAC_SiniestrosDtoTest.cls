/**-------------------------------------------------------------------------
* Nombre: MX_SB_SAC_SiniestrosDtoTest
* @author Ing. Karen Belem Sanchez Ruiz
* Proyecto: MX SB SAC - BBVA Bancomer
* Descripción : Clase test
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* -------------------------------------------------------------------
* 1.0           11/07/2019   Karen Belem Sanchez Ruiz    Creación
* 1.1           21/07/2019   Karen Belem Sanchez Ruiz    Corrección issues sonar
* --------------------------------------------------------------------------
*/

@isTest
public class MX_SB_SAC_SiniestrosDtoTest {
    /**
    * 
    * @description Contiene la URL del endpoint
    * @author Karen Sanchez
    */
    public static final String URL = 'https://qa.wibe.com.mx/cotizadores/api/token/serviciosExpuestos/';
    /**
    * 
    * @description Contiene el token para obtener siniestro
    * @author Karen Sanchez
    */
    public static final String TOKEN = '1c849e19a0b54110aba4bd8e5f7d551c'; 
    /**
    * 
    * @description Contiene el jSon para obtener siniestros
    * @author Karen Sanchez
    */       
    public static final String BODY = ' {"ramo":"1","poliza":"866W0A00BB","certificado":"00001"}';
    

    /**
     * Insertar contratos para pruebas
     */
    @TestSetup 
    static void insertarRegistros() {
        
        final User testUser = MX_WB_TestData_cls.crearUsuario('TestLastName', label.MX_SB_VTS_ProfileAdmin);
        insert testUser;

        final Account accountRecord = MX_SB_SAC_UtileriasTestCls.crearCuenta('LastName', 'PersonAccount');
        accountRecord.OwnerId = testUser.Id;
        insert accountRecord;
        
        final Contract cont = MX_SB_SAC_UtileriasTestCls.crearContrato(accountRecord.Id, Date.today());
        cont.MX_WB_noPoliza__c = '8B7621066E';
        insert cont;
    }
    
    /**
     Servicio responde de manera correcta
     */
    @isTest    
    public static void  getSiniestrosOK() {
        
        final MX_SB_SAC_SiniestrosDtoCls.datosConsultaSiniestro objDatos= new MX_SB_SAC_SiniestrosDtoCls.datosConsultaSiniestro();
        objDatos.ramo = '1'; 
        objDatos.poliza = '827W12003A';
        objDatos.certificado = '00001';
        
        

        final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', BODY ,new Map<String,String>()); 

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        final MX_SB_SAC_SiniestrosDtoCls.respRestGetSiniestro objRespGetSin = MX_SB_SAC_SiniestrosDtoCls.getSiniestro(objDatos, URL, TOKEN);
        final String sDetalle = String.valueOf(objRespGetSin.Detalle);
        System.assertEquals(BODY,sDetalle,'Paso correctamente');
        Test.stopTest();            
    } 

    /**
     No se encuentra el folio en multiasistenci
    */
    @isTest    
    public static void  noGetSiniestrosSFDC() {
        final MX_SB_SAC_SiniestrosDtoCls.respRestGetSiniestro objRespGetSin = new MX_SB_SAC_SiniestrosDtoCls.respRestGetSiniestro();
        objRespGetSin.nombreMetodo = 'obtenerSiniestrosPoliza';
        objRespGetSin.error = false;
        objRespGetSin.detalle = '';
        objRespGetSin.JsonRes = '{"siniestrosPoliza": {"informacionSiniestros": null},"operacionResultado": "OK","operacionMensaje": [],"browserUrl": null,"opMsjExtra": ""}';
       
        final List<MX_SB_SAC_SiniestrosDtoCls.SiniestrosDto> lstSinDto = MX_SB_SAC_SiniestrosDtoCls.jsonParserGetSiniestro(objRespGetSin.JsonRes);
        final Contract objContract = [Select MX_WB_noPoliza__c  FROM Contract Where MX_WB_noPoliza__c = '8B7621066E'];
        Test.startTest();
        final MX_SB_SAC_SiniestrosDtoCls.respSiniestroDto objRespSiDto = MX_SB_SAC_SiniestrosDtoCls.getSiniestrosSFDC(lstSinDto, objContract.MX_WB_noPoliza__c);
        System.assertEquals('0', objRespSiDto.respuestaEstatus,'No hay tipo o folio del siniestro. Consulta en Clipert');       
        Test.stopTest();
    }  

    /**
     Se encuentra el folio en multiasistenci
    */
    @isTest    
    public static void  getSiniestrosSFDC() {
        final MX_SB_SAC_SiniestrosDtoCls.InformacionSiniestros objInfSin = new MX_SB_SAC_SiniestrosDtoCls.InformacionSiniestros(); 
        final List<MX_SB_SAC_SiniestrosDtoCls.cobertura> lstCobertura = new List<MX_SB_SAC_SiniestrosDtoCls.cobertura>();
        final List<MX_SB_SAC_SiniestrosDtoCls.InformacionSiniestros> lstInfSin = new List<MX_SB_SAC_SiniestrosDtoCls.InformacionSiniestros>();
        final MX_SB_SAC_SiniestrosDtoCls.SiniestrosPoliza objSinPol = new MX_SB_SAC_SiniestrosDtoCls.SiniestrosPoliza(); 
        final List<MX_SB_SAC_SiniestrosDtoCls.SiniestrosPoliza> lstSiPol = new List<MX_SB_SAC_SiniestrosDtoCls.SiniestrosPoliza>();
        final MX_SB_SAC_SiniestrosDtoCls.SiniestrosDto objSinDto = new MX_SB_SAC_SiniestrosDtoCls.SiniestrosDto(); 
        final List<MX_SB_SAC_SiniestrosDtoCls.SiniestrosDto> lstSinDto = new List<MX_SB_SAC_SiniestrosDtoCls.SiniestrosDto>();
        final List<String> sOperacionMensaje = new List<String>();
        final List<Integer> fecha = new List<Integer> {2016, 12, 9};
        final Contract objContract = [Select MX_WB_noPoliza__c  FROM Contract Where MX_WB_noPoliza__c = '8B7621066E'];
        
        objInfSin.tipo = 'COLISION';
        objInfSin.folio  = 'B30128353';
        objInfSin.estatus = 'PROCEDENTE DE PAGO';
        objInfSin.culpabilidad  = 'ASEGURADO';
        objInfSin.fecha  = fecha;
        objInfSin.coberturas  = lstCobertura;
        lstInfSin.add(objInfSin);

        objSinPol.informacionSiniestros = lstInfSin;        
        lstSiPol.add(objSinPol);

        objSinDto.operacionMensaje = sOperacionMensaje;
        objSinDto.browseUrl = null;
        objSinDto.operacionResultado = 'OK';
        objSinDto.opMsjExtra = null;
        objSinDto.siniestrosPoliza = objSinPol;
        lstSinDto.add(objSinDto);
        
        Test.startTest();
        final MX_SB_SAC_SiniestrosDtoCls.respSiniestroDto objRespSiDto = MX_SB_SAC_SiniestrosDtoCls.getSiniestrosSFDC(lstSinDto, objContract.MX_WB_noPoliza__c);
        System.assertEquals('1', objRespSiDto.respuestaEstatus,'Folios encontrados');       
        Test.stopTest();
    }

    /**
     Se encuentra el folio con coberturas en multiasistenci
    */
    @isTest    
    public static void  objCoberturas() {
        final MX_SB_SAC_SiniestrosDtoCls.cobertura objCobertura = new MX_SB_SAC_SiniestrosDtoCls.cobertura(); 
        final List<MX_SB_SAC_SiniestrosDtoCls.cobertura> lstCobertura = new List<MX_SB_SAC_SiniestrosDtoCls.cobertura>();        
        final MX_SB_SAC_SiniestrosDtoCls.InformacionSiniestros objInfSin = new MX_SB_SAC_SiniestrosDtoCls.InformacionSiniestros();         
        final Map<String, String> mapFolIdSin = new  Map<String, String>();
        final Map<String, List<MX_SB_SAC_SiniestrosDtoCls.cobertura>> mapCoberturas = new Map<String, List<MX_SB_SAC_SiniestrosDtoCls.cobertura>>();
        final Set<String> setIdSini = new Set<String>();
        final Contract objContract = [Select Id,MX_WB_noPoliza__c  FROM Contract Where MX_WB_noPoliza__c = '8B7621066E'];
        final List<Integer> fecha = new List<Integer> {2016, 12, 9};

        objCobertura.nombre = 'DAÑOS MATERIALES';
        objCobertura.clave  = 'A';
        objCobertura.estatus = 'CERRADA';
        objCobertura.saldo  = '0.00';
        lstCobertura.add(objCobertura);
        objInfSin.tipo = 'COLISION';
        objInfSin.folio  = 'B30128353';
        objInfSin.estatus = 'PROCEDENTE DE PAGO';
        objInfSin.culpabilidad  = 'ASEGURADO';
        objInfSin.fecha  = fecha;
        objInfSin.coberturas  = lstCobertura;
        

        final Siniestro__c objSiniUpsrt = new Siniestro__c(
                    Folio__c = objInfSin.folio,
                    TipoSiniestro__c = objInfSin.tipo,
                    Fechasiniestro__c = Date.newInstance(2019, 11, 01),
                    Culpabilidad__c = objInfSin.culpabilidad,
                    MX_SB_SAC_Contrato__c = objContract.Id,
                    Estatus__c = objInfSin.estatus,
                    Siniestroactivo__c = true
        );
        insert objSiniUpsrt;
        setIdSini.add(objSiniUpsrt.Id);
        mapFolIdSin.put(objInfSin.folio, objSiniUpsrt.id);
        mapCoberturas.put(objInfSin.folio, new List<MX_SB_SAC_SiniestrosDtoCls.cobertura>(objInfSin.coberturas)); 
        
        Test.startTest();
        final MX_SB_SAC_SiniestrosDtoCls.respSiniestroDto objRespSinDto = MX_SB_SAC_SiniestrosDtoCls.objCoberturas(objInfSin, setIdSini);
        System.assertEquals(null,objRespSinDto,'No hay siniestros con coberturas');
        Test.stopTest();
    }

    /**
    * Obtener error cuando se solicita un siniestro
    */
    @isTest    
    public static void errorFormDto() {       
        final MX_SB_SAC_SiniestrosDtoCls.errorFormDto objErrorFormDto = new MX_SB_SAC_SiniestrosDtoCls.errorFormDto();  
        final MX_SB_SAC_SiniestrosDtoCls.ErrorFormaDto objErrorFormaDto = new MX_SB_SAC_SiniestrosDtoCls.ErrorFormaDto();  
        final List<String> sOperacionMensaje = new List<String>();
        Test.startTest();
        sOperacionMensaje.add('Token no valido'); 
        objErrorFormDto.operacionMensaje     = sOperacionMensaje;
        objErrorFormDto.browserUrl           = null;     
        objErrorFormDto.operacionResultado   = 'ERROR_SERVICIO';
        objErrorFormDto.opMsjExtra = null;         
        objErrorFormaDto.errorFormDto = objErrorFormDto;
        System.assertEquals('ERROR_SERVICIO',objErrorFormDto.operacionResultado,'ERROR_SERVICIO');
        Test.stopTest();
        
    }
}