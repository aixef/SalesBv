/**-------------------------------------------------------------------------
* Nombre: MX_SB_SAC_SiniestrosDtoCls
* @author Ing. Karen Belem Sanchez Ruiz
* Proyecto: MX SB SAC - BBVA Bancomer
* Descripción : Clase que contiene siniestro
* Notas ::::	*Contrato Equivalente a Póliza
* --------------------------------------------------------------------------
* Versión 		Fecha			Autor					Descripción
* -------------------------------------------------------------------
* 1.0           30/05/2019   Karen Belem Sanchez Ruiz    Creación
* 1.1           03/06/2019   Alexis Perez                Reducción de incidencias
* 1.1           04/06/2019   Alexis Perez                Reducción de incidencias
* 1.2           21/07/2019   Ing. Karen Belem Sanchez    Reducción de incidencias
* --------------------------------------------------------------------------
*/

public without sharing class MX_SB_SAC_SiniestrosDtoCls {
    
    /**
     * Variable: Almacena un siniestro
     */
    public siniestrosPoliza siniestro {get;set;}
    
    /**
     * Función: Constructor para SFDC/MX_SB_SAC_SiniestrosDtoCls
     * Fecha: 2019-05-30
     * @author: Karen Belem Sanchez Ruiz
     */
    public MX_SB_SAC_SiniestrosDtoCls(siniestrosPoliza siniestro) { 
        this.siniestro = siniestro;
    }
    
    /**
     * Función: Constructor para SFDC/MX_SB_SAC_SiniestrosDtoCls
     * Fecha: 2019-05-30
     * @author: Karen Belem Sanchez Ruiz
     */
    public MX_SB_SAC_SiniestrosDtoCls() { 
        this.siniestro = siniestro;
    }
    
    /**
     * Función: Clase que contiene los siniestros o los mensajes con los resultados de este
     * Fecha: 2019-05-30
     * @author: Karen Belem Sanchez Ruiz
     */
    public class SiniestrosDto {
        /**
         * Operación mensaje.
         */
        public List<String> operacionMensaje {get;set;}
        
        /**
         * Url
         */
        public String browseUrl {get;set;}
        
        /**
         * Resultado de la operación
         */
        public String operacionResultado {get;set;} //NOSONAR
        
        /**
         * Operación mensaje extra
         */
        public String opMsjExtra {get;set;}
        
        /**
         * Siniestros póliza
         */
        public SiniestrosPoliza siniestrosPoliza {get;set;}
    }
    
    /**
     * Función: Clase contiene el detalle de los campos del siniestro
     * Fecha: 2019-05-30
     * @author: Karen Belem Sanchez Ruiz
     */
    public class SiniestrosPoliza {
        /**
         * Detalles del siniestro.
         */
        public List<InformacionSiniestros> informacionSiniestros {get;set;} //NOSONAR
    }
    
    /**
     * Función: Clase que contiene la información del siniestro
     * Fecha: 2019-05-30
     * @author: Karen Belem Sanchez Ruiz
     */
    public class InformacionSiniestros {
        /**
         * Tipo de siniestro
         */
        public String tipo {get;set;}
        
        /**
         * Folio del siniestro
         */
        public String folio {get;set;}
        
        /**
         * estatus del siniestro
         */
        public String estatus {get;set;}
        
        /**
         * Culpabilidad del siniestro
         */
        public String culpabilidad {get;set;}
        
        /**
         * Fecha del siniestro fragmentada
         */
        public List<Integer> fecha {get;set;}
        
        /**
         * Coberturas
         */
        public List<cobertura> coberturas {get;set;}
    }
    
    /**
     * Función: Clase que contiene el objeto de las coberturas 
     * Fecha: 2019-05-30
     * @author: Karen Belem Sanchez Ruiz
     */
    public class cobertura {
        /**
         * Nombre
         */
        public String nombre {get;set;}
        
        /**
         * Clave
         */
        public String clave {get;set;}
        
        /**
         * Estatus
         */
        public String estatus {get;set;}
        
        /**
         * Saldo
         */
        public String saldo {get;set;}
    }
    
    
    /**
     * Función: Clase que contiene la respuesta del servicio 
     * Fecha: 2019-05-30
     * @author: Karen Belem Sanchez Ruiz
     */
    public class respRestGetSiniestro {
        /**
        * Nombre del method
        */
        public String nombreMetodo {get;set;}
        
        /**
        * Error
        */
        public Boolean error {get;set;}
        
        /**
         * Detalles de la respuesta
         */
        public String detalle {get;Set;}
        
        /**
         * Body de la respuesta
         */
        public String jsonRes {get;set;}
    }
    
    /**
     * Función: Clase que contiene los parámetros de entrada para consultar el siniestro
     * Fecha: 2019-05-30
     * @author: Karen Belem Sanchez Ruiz
     */
    public class datosConsultaSiniestro {
        
        /**
         * Ramo
         */
        public String ramo {get;set;}
        
        /**
         * Póliza
         */
        public String poliza {get;set;}
        
        /**
         * Certificado
         */
        public String certificado {get;set;}        
    }
    
    /**
     * Función: Clase que contiene el error en caso de que el WS falle 
     * Fecha: 2019-05-30
     * @author: Karen Belem Sanchez Ruiz
     */
    public class ErrorFormaDto {
        
        /**
         * Error en la solicitud en caso de falla del WS
         */
        public ErrorFormDto errorFormDto {get;set;}        
    }
    
    /**
     * Función: Clase que contiene el error en caso de que el WS falle
     * Fecha: 2019-05-30
     * @author: Karen Belem Sanchez Ruiz
     */
    public class ErrorFormDto {
        
        /**
         * Mensaje de la operación
         */
        public List<String> operacionMensaje {get;set;}
        
        /**
         * URL del navegador
         */
        public String browserUrl {get;set;}
        
        /**
         * Resultado de la operación.
         */
        public String operacionResultado {get;Set;}//NOSONAR
        
        /**
         * Mensaje extra de la operación.
         */
        public String opMsjExtra {get;set;}        
    }
    
    /**
     * Función: Clase que contiene la lista de los siniestros de una póliza
     * Fecha: 2019-05-30
     * @author: Karen Belem Sanchez Ruiz
     */
    public class respSiniestroDto {
        /**
         * Respuesta de los siniestros
         */
        public String respuestaEstatus {get;set;}
        
        /**
         * Mensaje del siniestro
         */
        public String mensaje {get;set;}
        
        /**
         * Lista de siniestros
         */
        public List<Siniestro__c> lSiniestros {get;set;}
        
        /**
         * Constructor de la clase respSiniestroDto: Asigna las propiedades.
         * Fecha: 2019-05-30
         * @author: Karen Belem Sanchez Ruiz
         */
        public respSiniestroDto(String respuestaEstatus, String mensaje, List<Siniestro__c> lSiniestros) {
            this.respuestaEstatus = respuestaEstatus;
            this.mensaje = mensaje;
            this.lSiniestros = lSiniestros;
        }
    }
    
    /**
     * Función: Clase encargada de regresar el resultado de la petición del siniestro
     * Fecha: 2019-05-30
     * @author: Karen Belem Sanchez Ruiz
     */
    public static respRestGetSiniestro getSiniestro(datosConsultaSiniestro objDtConSin, String sUrl, String strTokenSession) {   

        final respRestGetSiniestro objRespRestLoc = new respRestGetSiniestro();
        String sMetodo = '';
        String jsonBody = '';
        String endpoint = '';
        
        try {
            if (objDtConSin != null) {
                sMetodo = 'obtenerSiniestrosPoliza';
            }
            jsonBody = JSON.serialize(objDtConSin);
            endpoint = sUrl + '' + sMetodo;
            final HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Accept', 'application/json, text/plain, */*');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('acces-token', strTokenSession);
            request.setTimeout(120000);
            request.setBody(jsonBody);
            HTTPResponse res;
            String sJasonRes;
            res = new Http().send(request);
            sJasonRes = res.getBody();
            objRespRestLoc.NombreMetodo = sMetodo;
            objRespRestLoc.Detalle = sJasonRes;
            objRespRestLoc.JsonRes = sJasonRes;  
            objRespRestLoc.Error = String.valueOf(res).contains('200') ? false : true;          
            
        } catch(SerializationException ex) {                        
            objRespRestLoc.Error = true;
            objRespRestLoc.Detalle = ex.getMessage();
        }
        return objRespRestLoc;
    }
    
    /**
     * Función: Clase encargada de regresar el siniestro o el error de la petición del siniestro
     * Fecha: 2019-05-30
     * @author: Karen Belem Sanchez Ruiz
     */
    public static List<SiniestrosDto> jsonParserGetSiniestro(String sJsonResp) {
        final List<SiniestrosDto> lObjBancosResp = new List<SiniestrosDto>();
        try {
            final SiniestrosDto sin = (SiniestrosDto)JSON.deserialize(sJsonResp, SiniestrosDto.class);
            lObjBancosResp.add(sin);
        } catch(JSONException ex) {
            lObjBancosResp[0].operacionMensaje.add(ex.getMessage());
        }
        return lObjBancosResp;
    }
    
    /**
     * Función: Clase encargada de regresar el siniestro y las coberturas
     * Fecha: 2019-05-30
     * @author: Karen Belem Sanchez Ruiz
     * @param sNoPoliza Contiene el Id del contrato
     * @param lSiniestroDto contiene la lista de siniestros y coberturas del contrato
     * @return objRrespSiniestroDto  
     */
    public static respSiniestroDto getSiniestrosSFDC(List<SiniestrosDto> lSiniestroDto, String sNoPoliza) {        
        respSiniestroDto obRespSiniDto;
        final Contract contratoQuery = [SELECT id, MX_WB_noPoliza__c From Contract Where MX_WB_noPoliza__c = :sNoPoliza];//NOSONAR
        for (SiniestrosDto objSiniestroDto : lSiniestroDto) {
            if (objSiniestroDto.operacionResultado == 'OK' &&  objSiniestroDto.siniestrosPoliza.informacionSiniestros != null) {
                obRespSiniDto = objInfSiniestro(objSiniestroDto, contratoQuery.id); 
            }else {       
                final List<Siniestro__c> lSiniUpsrt = new List<Siniestro__c>();
                obRespSiniDto = new respSiniestroDto('0', 'No hay tipo o folio del siniestro. Consulta en Clipert',lSiniUpsrt );
            } 
        }
        return obRespSiniDto;
    }
    
    /**
     * Función: Clase encargada de crear el registro de los siniestros y coberturas
     * Fecha: 2019-05-30
     * @param sIdPoliza Contiene el Id del contrato
     * @param objSiniestroDto contiene la lista de siniestros y coberturas del contrato    
     * @author: Karen Belem Sanchez Ruiz
     */
    public static respSiniestroDto objInfSiniestro(SiniestrosDto objSiniestroDto, String sIdPoliza) {
        respSiniestroDto objRespSiniDto;        
        final List<Siniestro__c> lSiniUpsrt = new List<Siniestro__c>();
        
        
        for (InformacionSiniestros objInfoSiniestro : objSiniestroDto.siniestrosPoliza.informacionSiniestros) {
            
            if (String.isNotBlank(objInfoSiniestro.tipo) && String.isNotBlank(objInfoSiniestro.folio)) {
                Date dFechaSiniesto = null;
                Set<String> sIdSinUps = new Set<String>();

                if (!objInfoSiniestro.fecha.isEmpty()) {
                    dFechaSiniesto = Date.newInstance(objInfoSiniestro.fecha.get(0), objInfoSiniestro.fecha.get(1), objInfoSiniestro.fecha.get(2));
                }
                final Siniestro__c objSiniUpsrt = new Siniestro__c(
                    Folio__c = objInfoSiniestro.folio,
                    TipoSiniestro__c = objInfoSiniestro.tipo,
                    Fechasiniestro__c = dFechaSiniesto,
                    Culpabilidad__c = objInfoSiniestro.culpabilidad,
                    MX_SB_SAC_Contrato__c = sIdPoliza,
                    Estatus__c = objInfoSiniestro.estatus,
                    Siniestroactivo__c = true
                );
                lSiniUpsrt.add(objSiniUpsrt);
                sIdSinUps = insertSini(lSiniUpsrt); 
                objRespSiniDto = objCoberturas(objInfoSiniestro, sIdSinUps);
                objRespSiniDto = new respSiniestroDto('1', 'OK', lSiniUpsrt);
            }            
        }
        return objRespSiniDto;
    }
    
    /**
     * Función: Clase encargada de crear el registro de los siniestros y coberturas
     * Fecha: 2019-05-30
     * @param lSiniUpsrt contiene la lista de siniestros a insertar
     * @author: Karen Belem Sanchez Ruiz
     */
    public static Set<String> insertSini(List<Siniestro__c> lSiniUpsrt) {
        final Set<String> sIdSinUps = new Set<String>();   
        if(lSiniUpsrt.isEmpty() == false) {
            final List<Database.UpsertResult> result = Database.upsert(lSiniUpsrt, Siniestro__c.Folio__c, false);            
            for(Database.UpsertResult responseRes : result) {
                sIdSinUps.add(responseRes.getId());
            }
        }    
        return sIdSinUps;
    }
    
    
    
    /**
     * Función: Clase encargada de crear el registro de las coberturas 
     * Fecha: 2019-05-30
     * @param objInfoSiniestro contiene la lista de siniestros
     * @param sIdSinUps contiene la lista de los Ids de los siniestros
     * @author: Karen Belem Sanchez Ruiz
     */
    public static respSiniestroDto objCoberturas(InformacionSiniestros objInfoSiniestro, Set<String> sIdSinUps) {
        
        final Map<String, String> mapFolIdSin = new  Map<String, String>();
        final Map<String, List<cobertura>> mapCoberturas = new Map<String, List<cobertura>>();
        respSiniestroDto objRespSiniDto;
        final List<Siniestro__c> objSinis = [Select id, Folio__c  From Siniestro__c Where id IN : sIdSinUps];
        final Boolean coberturasExis = objInfoSiniestro.coberturas.isEmpty();
        for(Siniestro__c objSiniestro : objSinis) {
            if(objInfoSiniestro.folio.equals(objSiniestro.Folio__c) && coberturasExis == false) {
                mapFolIdSin.put(objSiniestro.Folio__c, objSiniestro.id);
                mapCoberturas.put(objSiniestro.Folio__c, new List<cobertura>(objInfoSiniestro.coberturas));
            }
            if (mapFolIdSin.isEmpty() == false && mapCoberturas.get(objSiniestro.Folio__c).isEmpty() == false) {
            asocCoberSini(mapFolIdSin, mapCoberturas);
            }
        }
        return objRespSiniDto;
    }
    
    /**
     * Función: Clase encargada de crear el registro de las coberturas
     * Fecha: 2019-05-30
     * @param mapFolIdSin contiene los folios del siniestro junto con su Id
     * @param mapCoberturas contiene los folios del siniestro junto con la lista de las coberturas
     * @author: Karen Belem Sanchez Ruiz
     */
    public static respSiniestroDto asocCoberSini(Map<String, String> mapFolIdSin, Map<String, List<cobertura>> mapCoberturas) {        
        respSiniestroDto objRespSiniDto;
        if(mapCoberturas.KeySet() == mapFolIdSin.KeySet()) {            
            final List<Cobertura__c> lSinCobertUpd = new List<Cobertura__c>();            
            final String sTypeRecord = Schema.SObjectType.Cobertura__c.getRecordTypeInfosByDeveloperName().get('MX_SB_SAC_RamoAutoRT').getRecordTypeId();
            for(Id setSiniestroId : mapFolIdSin.values()) { 
                for(List<cobertura> lstCoberturas : mapCoberturas.values()) {                    
                    for(Integer i= 0; i<lstCoberturas.size();i++ ) {       
                        lSinCobertUpd.add(new Cobertura__c(
                            MX_SB_SAC_Siniestro__c = setSiniestroId,
                            Name = lstCoberturas[i].nombre,
                            Clave__c = lstCoberturas[i].clave,
                            Costo__c = lstCoberturas[i].saldo,
                            MX_SB_SAC_Estatus__c = lstCoberturas[i].estatus,
                            RecordTypeId = sTypeRecord));
                    } 
                }                               
            }
            upsert lSinCobertUpd;            
        }        
        return objRespSiniDto;
    }
}