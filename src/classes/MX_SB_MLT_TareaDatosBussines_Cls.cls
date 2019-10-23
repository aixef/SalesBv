/**--------------------------------------------------------------------------------
* Nombre: MX_SB_MLT_TareaDatosBussines_Cls
* Autor Oscar Martínez / Saúl Gonzáles
* Proyecto: Siniestros - BBVA Bancomer
* Descripción : Lógica de negocio para parsear los objetos json de Claim Center
* --------------------------------------------------------------------------------
* Versión       Fecha          Autor                                    Descripción
* --------------------------------------------------------------------------------
* 1.0           15/04/2019     Oscar Martínez / Saúl Gonzáles           Creación
* 1.1           26/04/2019     Oscar Martínez                           Se inserta el caso y se asigna a una cola
* 1.2           07/05/2019     Oscar Martínez                           Se refactoriza la clase para obtener los parámetros del Json mediante un mapa
* 1.3           29/08/2019     Daniel Goncalves Vivas                   Se agrega campo LegacySystem
* 1.4           20/09/2019     Daniel Goncalves Vivas                   Se corrigen typos
* 1.5           24/09/2019     Daniel Goncalves Vivas                  	Se elimina variable en desuso, se cambia condición de Costo Cristal
* 1.6			27/08/2019	   Angel Nava                               mapeo de idservicio ARCA
* 1.7			30/09/2019	   Angel Nava								NOSONAR para método con complejidad alta
* 1.8           30/09/2019     Daniel Goncalves Vivas                   Se cambian nombre de variables largos
* 1.9           08/10/2019     Daniel Goncalves Vivas                   Se agrega mapeo de campos de auto
* 1.10          10/10/2019     Daniel Goncalves Vivas                   Se eliminan llamadas a GetDateGlass
* 1.11		    14/10/2019     Juan Carlos Benitez Herrera	        	Se agrega mapeo de campos de auto
* --------------------------------------------------------------------------------
**/

public without sharing class MX_SB_MLT_TareaDatosBussines_Cls {
    
    /*
    * @description parsea el objeto json y almacena los datos en objetos custom Salesforce.
    * @param String json
    * @return String strResponse
    */
    public Map<String,String> creaObjetoTareaDatos (String strJson) {//NOSONAR
        final Map<String, Object> mapJson = (Map<String, Object>) JSON.deserializeUntyped(strJson);
        final Case casoTareaDatos = new Case();
        casoTareaDatos.MX_SB_MLT_Area__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('area'));
        casoTareaDatos.MX_SB_MLT_BranchName__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('branchName'));     
        casoTareaDatos.MX_SB_MLT_InsuranceCompany__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('company')).toUpperCase();
        casoTareaDatos.MX_SB_MLT_Email__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('email'));
        casoTareaDatos.MX_SB_MLT_Glass__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('glass'));        
        casoTareaDatos.MX_SB_MLT_IsVIP__c =  (Boolean) (mapJson.get('isVIP') == null ? false : true);       
        casoTareaDatos.MX_SB_MLT_Phone__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('phone'));           
        casoTareaDatos.MX_SB_MLT_UrlLocation__c =  String.isEmpty((String)mapJson.get('urlLocation')) ? Label.MX_SB_MLT_LATLONG : (String)mapJson.get('urlLocation');
        casoTareaDatos.RecordTypeId = recuperaTipoRegistro('MX_SB_MLT_TomaReporte');
        casoTareaDatos.MX_SB_MLT_Subtype__c = MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('subtype'));
        casoTareaDatos.Origin ='Web';
        casoTareaDatos.MX_SB_MLT_LegacySystem__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('legacySystem'));
        casoTareaDatos.MX_SB_MLT_SegmentClient__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('segmentClient'));
        casoTareaDatos.MX_SB_MLT_NumeroSerie__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('numeroSerie'));
        casoTareaDatos.MX_SB_MLT_Motor__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('numeroMotor'));
        casoTareaDatos.MX_SB_MLT_PolizaTD__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('policyNumber'));
        casoTareaDatos.MX_SB_MLT_TipoAuto__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('vehicleDescription'));
        casoTareaDatos.MX_SB_MLT_ColorVehiculo__c =   MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('vehicleColor'));
        casoTareaDatos.MX_SB_MLT_ClauseNumber__c =  (Integer)mapJson.get('clauseNumber');
        casoTareaDatos.MX_SB_MLT_DescripcionVehiculo__c =   MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('vehicleDescription'));
        casoTareaDatos.MX_SB_MLT_Marca__c =   MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('make'));
        casoTareaDatos.MX_SB_MLT_Modelo__c =   MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('model'));
        casoTareaDatos.MX_SB_MLT_Placas__c =   MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('licensePlate'));

        final Integer idServicio = mapJson.get('idServicio')== null ? 0: (Integer)mapJson.get('idServicio');
        casoTareaDatos.MX_SB_MLT_Event__c = MX_SB_MLT_TareaDatosUtils_Cls.validaEvent(casoTareaDatos.MX_SB_MLT_LegacySystem__c,MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)mapJson.get('event')),idServicio);
        final String [] latLong =  casoTareaDatos.MX_SB_MLT_UrlLocation__c.split(',');
        if (!latLong.isEmpty() && !Test.isRunningTest()) {
            casoTareaDatos.MX_SB_MLT_Address__c = obtieneDireccionMapa(MX_SB_MLT_GoogleGeolocation_Cls.getReverseGeocode(latLong[0],latLong[1]));
        }
        final Map<String,String> mapResponse =  new  Map<String,String>();
        AssignmentRule assignRule = new AssignmentRule(); 
        assignRule = [select id from AssignmentRule where SobjectType = 'Case' and Name ='Siniestros' and Active = true limit 1];           
        final Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= assignRule.id;
        casoTareaDatos.setOptions(dmlOpts);     
        
        insert casoTareaDatos ;
        final Case casoTareaDatosUp = creaObjetoTareaDatos(mapJson);
        casoTareaDatosUp.Id = casoTareaDatos.Id;
        upsert casoTareaDatosUp;        
        
        mapResponse.put('respuesta', Label.MX_SB_MLT_ExitoTDT);
        mapResponse.put('error','');
        mapResponse.put('idSalesforce',casoTareaDatos.Id);
        return mapResponse;
    }

    /*
    * @description parsea el objeto json y almacena los datos en objetos custom Salesforce.
    * @param String jsonMapReq
    * @param String casoReq
    * @return String strResponse
    */
    public static Case creaObjetoTareaDatos (Map<String,Object> jsonMapReq) {
        final Case caseResp = new Case();
        caseResp.MX_SB_MLT_AMaternoConductor__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('aMaternoConductor'));
        caseResp.MX_SB_MLT_APaternoConductor__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('aPaternoConductor'));
        caseResp.MX_SB_MLT_BranchKey__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('branchKey'));
        caseResp.MX_SB_MLT_ComentariosSiniestro__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('comentariosSiniestro'));
        caseResp.MX_SB_MLT_DeclaracionSiniestro__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('declaracionSiniestro'));
        caseResp.MX_SB_MLT_EstadoCivilConductor__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('estadoCivilConductor'));
        caseResp.MX_SB_MLT_FechaNacimientoConductor__c =  MX_SB_MLT_TareaDatosUtils_Cls.getDate((String)jsonMapReq.get('fechaNacimientoConductor'));
        caseResp.MX_SB_MLT_FechaVencimientoLicencia__c =  MX_SB_MLT_TareaDatosUtils_Cls.getDate((String)jsonMapReq.get('fechaVencimientoLicencia'));
        caseResp.MX_SB_MLT_GlassInicidentTime__c =  MX_SB_MLT_TareaDatosUtils_Cls.getTimeGlass((String)jsonMapReq.get('glassIncidentTime'),(String)jsonMapReq.get('glassInicidentDate'));
        caseResp.MX_SB_MLT_GlassInicidentDate__c =  MX_SB_MLT_TareaDatosUtils_Cls.getDate((String)jsonMapReq.get('glassInicidentDate'));
        caseResp.MX_SB_MLT_GlassInicidentService__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('glassIncidentService'));
        caseResp.MX_SB_MLT_GlasswareKey__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('glasswareKey'));
        caseResp.MX_SB_MLT_GlasswareName__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('glasswareName'));
        caseResp.MX_SB_MLT_External_Id__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('id'));
        caseResp.MX_SB_MLT_InsuredLastName__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('insuredLastName'));
        caseResp.MX_SB_MLT_InsuredLastName2__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('insuredLastName2'));
        caseResp.MX_SB_MLT_InsuredName__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('insuredName'));
        caseResp.MX_SB_MLT_NombreConductor__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('nombreConductor'));
        caseResp.MX_SB_MLT_NumeroLicencia__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('numeroLicencia'));
        caseResp.MX_SB_MLT_NumeroOcupantes__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('numeroOcupantes'));
        caseResp.MX_SB_MLT_OcupacionConductor__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('ocupacionConductor'));
        caseResp.MX_SB_MLT_RelacionAsegurado__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('relacionAsegurado'));
        caseResp.MX_SB_MLT_SexoConductor__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('sexoConductor'));
        caseResp.MX_SB_MLT_TelefonoCristalera__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('telefonoCristalera'));
        caseResp.MX_SB_MLT_IdUsuario__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('idUsuario'));
        caseResp.MX_SB_MLT_CostoCristal__c =  jsonMapReq.get('costoCristal')== null ? 0.00 : MX_SB_MLT_TareaDatosUtils_Cls.validaDatoDecimalVacio((String)jsonMapReq.get('costoCristal'));
        caseResp.MX_SB_MLT_MarcaCristal__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('marcaCristal'));
        caseResp.MX_SB_MLT_ProcedenciaCristal__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('procedenciaCristal'));
        caseResp.MX_SB_MLT_TipoCristal__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('tipoCristal '));
        caseResp.MX_SB_MLT_FolioCC__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('folioCC'));
        final Integer servicioInt = jsonMapReq.get('idServicio')== null ? 0 : (Integer)jsonMapReq.get('idServicio');
        final String servicioStr = String.valueOf(servicioInt);
        caseResp.MX_SB_MLT_IdService__c =  servicioStr;
        caseResp.MX_SB_MLT_EstatusSolicitud__c =  (Integer)jsonMapReq.get('estatusSolicitud');
        caseResp.MX_SB_MLT_FechaRegistro__c =  MX_SB_MLT_TareaDatosUtils_Cls.getDate((String)jsonMapReq.get('fechaRegistro'));
        caseResp.MX_SB_MLT_Mensaje__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('mensaje'));
        caseResp.MX_SB_MLT_Mensaje2__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('mensaje2'));
        caseResp.MX_SB_MLT_MensajePDA__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('mensajePDA'));
        caseResp.MX_SB_MLT_MensajePDA2__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('mensajePDA2'));
        caseResp.MX_SB_MLT_Observaciones__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('observaciones'));
        caseResp.MX_SB_MLT_ObservacionesPDA__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('observacionesPDA'));
        caseResp.MX_SB_MLT_ClaimNumber__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('claimNumber'));
        caseResp.MX_SB_MLT_NombreTercero__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('nombreTercero'));
        caseResp.MX_SB_MLT_Origen__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('origen'));
        caseResp.MX_SB_MLT_Telefono__c =  MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio((String)jsonMapReq.get('telefono'));
        return caseResp;
    }

    /*
    * @description Method privado que recupera el tipo de registro adecuado para la tarea de datos
    * @param String strDevName
    * @return String strTipoRegistro
    */
    private static String recuperaTipoRegistro(String strDevName) {
        String strTipoRegistro = '';
        final RecordType recordT =[SELECT Id FROM RecordType WHERE SobjectType = 'Case' And DeveloperName =:strDevName];
        strTipoRegistro = recordT.Id;
        return strTipoRegistro;
    }

    /*
    * @description Method privado que recupera la dirección del mapa de google.
    * @param HttpResponse res
    * @return String strDireccion
    */
    private static String obtieneDireccionMapa(HttpResponse res) {
        String strDireccion = '';
        final Map<String,Object> mapGr = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
        final List<Object> results = (List<Object>)mapGr.get('results');
        if(!results.isEmpty()) {
            final Map<String,Object> firstResult = (Map<String,Object>)results[0];
            strDireccion = (string)firstResult.get('formatted_address');
        }
        return strDireccion ;
    }
}