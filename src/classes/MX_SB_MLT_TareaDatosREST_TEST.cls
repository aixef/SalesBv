/*
----------------------------------------------------------------------------------
* Nombre: MX_SB_MLT_TareaDatosREST_TEST
* Autor Oscar Martínez / Saúl Gonzáles
* Proyecto: Siniestros - BBVA Bancomer
* Descripción : Prueba los Methods de MX_SB_TareaDatosREST_Wsr
* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                                   Descripción
* --------------------------------------------------------------------------------
* 1.0           15/04/2019     Oscar Martínez / Saúl Gonzáles           Creación
* 1.1           15/04/2019     Daniel Goncalves Vivas                   Cambio en condición assert
* 1.2           15/04/2019     Oscar Martínez                           Profile a CustomLabel
* 1.3           12/08/2019     Daniel Goncalves Vivas                   Se elimina campo subtype, cobertura, observaciones, createDate
* 1.4           30/09/2019     Daniel Goncalves Vivas                   Se cambia nombre de variables para evitar duplicidad
* --------------------------------------------------------------------------------
*/

@isTest
public class MX_SB_MLT_TareaDatosREST_TEST {

    @testSetup static void setup() {
        final User testUser = MX_WB_TestData_cls.crearUsuario ( 'TestLastName', Label.MX_SB_VTS_ProfileAdmin  );
        insert testUser;
        final Account accRec = MX_WB_TestData_cls.crearCuenta ( 'LastName', 'MX_WB_rt_PAcc_Telemarketing' );
        accRec.OwnerId = testUser.Id;
        accRec.Correo_Electronico__c = 'prueba@wibe.com';
        insert accRec;
        final Opportunity oppRec = MX_WB_TestData_cls.crearOportunidad ( 'Test', accRec.Id, testUser.Id, 'MX_WB_RT_Telemarketing' );
        oppRec.FolioCotizacion__c = null;
        oppRec.TelefonoCliente__c = '1234567890';
        oppRec.NumerodePoliza__c='000101';
        insert oppRec;
        final Contract contrato = new Contract();
        contrato.MX_WB_noPoliza__c = oppRec.NumerodePoliza__c;
        contrato.MX_WB_Oportunidad__c = oppRec.Id;
        contrato.AccountId = accRec.Id;
        insert contrato;
    }

    static testMethod void guardaTareaDatos() {
        final String strJsonA = '{"address": "Calle 9 231, México, Yucatán","area": "asistencia", "clauseNumber": 1,"company": "Seguros Bancomer","email": "tstmail@mail.com","event": "Gasolina","glass": "","glassInicidentDate": "01/01/1961","glassInicidentService": "","glassInicidentTime": "","glasswareKey": "","glasswareName": "","id": "111303","insuredLastName": "PACHECO","insuredLastName2": "TACH","insuredName": "ALFONSO BENJAMIN","isVIP ": 0,"licensePlate": "ZBU957B","make": "GENERAL MOTORS","model": "SPARK","phone": "9992150730","policyNumber": "000101","urlLocation": "20.9073451,-89.5696843","segmentClient": "","vehicleColor": "","aMaternoConductor": "","aPaternoConductor": "","comentariosSiniestro": "","declaracionSiniestro": "","emisorAllianz": "","estadoCivilConductor": "","fechaNacimientoConductor": "","fechaVencimientoLicencia": "","nombreConductor": "","numeroLicencia": "","numeroMotor": "","numeroOcupantes": "","numeroSerie": "","ocupacionConductor": "","relacionAsegurado": "","telefonoCristalera": "","transmision": "","sexoConductor": "","idUsuario": "","costoCristal": "","marcaCristal": "","procedenciaCristal": "","tipoCristal": "","tipoVehiculo": "","ubicacionSucursalCristalera": "","folioCC": "","idServicio": 0,"estatusSolicitud": 0,"fechaRegistro": "","mensaje": "","mensaje2": "","mensajePDA": "","mensajePDA2": "","numIntentos": 0,"observaciones": "","observacionesPDA": "","catalogoDestino": "","catalogoOrigen": "","claimNumber": "","afectado": "","medio": "","nombreTercero": "","telefono": "","destino": "","legacySystem": "REPORTE MOVIL","origen": "","vehicleDescription": ""}'; 
        final RestRequest req = new RestRequest();
        final RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MX_SB_TareaDatosREST';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(strJsonA);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            final MX_SB_MLT_TareaDatosREST_Wsr.Response  resultado = MX_SB_MLT_TareaDatosREST_Wsr.guardaTareaDatos();
        Test.stopTest();
        System.assert(resultado.toString().contains(Label.MX_SB_MLT_ExitoTDT),'Valida Guardado Tarea Datos');        
    }

    static testMethod void guardaTareaDatosError() {
        final String strJsonB = '{"address": Calle 9 231, México, Yucatán","area": "asistencia", "clauseNumber": 1,"company": "Seguros Bancomer","email": "tstmail@mail.com","event": "Gasolina","glass": "","id": "111303","insuredLastName": "PACHECO","insuredLastName2": "TACH","insuredName": "ALFONSO BENJAMIN","isVIP ": 0,"licensePlate": "ZBU957B","make": "GENERAL MOTORS","model": "SPARK","phone": "9992150730","policyNumber": "898621072C","urlLocation": "20.9073451,-89.5696843","idServicio": 21,"legacySystem": "REPORTE MOVIL"}';
        final RestRequest req = new RestRequest();
        final RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MX_SB_TareaDatosREST';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(strJsonB);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            final MX_SB_MLT_TareaDatosREST_Wsr.Response  resultado = MX_SB_MLT_TareaDatosREST_Wsr.guardaTareaDatos();        
        Test.stopTest();
        System.assert(resultado.toString().contains(Label.MX_SB_MLT_ErrorTDT),'Error en el servicio');
    }

    static testMethod void guardaTareaDatosErrorDML() {
        final String strJsonC = '{"address": "Calle 9 231, México, Yucatán","area": "asistencia", clauseNumber": S,"company": "Seguros Bancomer","email": "tstmail@mail.com","event": "Gasolina","glass": "","id": "111303","insuredLastName": "PACHECO","insuredLastName2": "TACH","insuredName": "ALFONSO BENJAMIN","isVIP ": 0,"licensePlate": "ZBU957B","make": "GENERAL MOTORS","model": "SPARK","phone": "9992150730","policyNumber": "898621072C","urlLocation": "20.9073451,-89.5696843","idServicio": 21,"legacySystem": "REPORTE MOVIL"}';
        final RestRequest req = new RestRequest();
        final RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MX_SB_TareaDatosREST';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(strJsonC);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            final MX_SB_MLT_TareaDatosREST_Wsr.Response resultado = MX_SB_MLT_TareaDatosREST_Wsr.guardaTareaDatos();
        Test.stopTest(); 
        System.assert(resultado.toString().contains(Label.MX_SB_MLT_ErrorTDT),'Error DML en Guardado Tarea');      
    }
    static testMethod void guardaTareaDatosCatalogo() {
        final String strJsonD = '{"address": "Calle 9 231, México, Yucatán","area": "asistencia", "clauseNumber": 1,"company": "Seguros Bancomer","email": "tstmail@mail.com","event": "","glass": "","glassInicidentDate": "01/01/1961","glassInicidentService": "","glassInicidentTime": "","glasswareKey": "","glasswareName": "","id": "111303","insuredLastName": "PACHECO","insuredLastName2": "TACH","insuredName": "ALFONSO BENJAMIN","isVIP ": 0,"licensePlate": "ZBU957B","make": "GENERAL MOTORS","model": "SPARK","phone": "9992150730","policyNumber": "898621072C","urlLocation": "20.9073451,-89.5696843","segmentClient": "","vehicleColor": "","aMaternoConductor": "","aPaternoConductor": "","comentariosSiniestro": "","declaracionSiniestro": "","emisorAllianz": "","estadoCivilConductor": "","fechaNacimientoConductor": "","fechaVencimientoLicencia": "","nombreConductor": "","numeroLicencia": "","numeroMotor": "","numeroOcupantes": "","numeroSerie": "","ocupacionConductor": "","relacionAsegurado": "","telefonoCristalera": "","transmision": "","sexoConductor": "","idUsuario": "","costoCristal": "","marcaCristal": "","procedenciaCristal": "","tipoCristal": "","tipoVehiculo": "","ubicacionSucursalCristalera": "","folioCC": "","idServicio":1,"estatusSolicitud": 0,"fechaRegistro": "","mensaje": "","mensaje2": "","mensajePDA": "","mensajePDA2": "","numIntentos": 0,"observaciones": "","observacionesPDA": "","catalogoDestino": "","catalogoOrigen": "","claimNumber": "","afectado": "","medio": "","nombreTercero": "","telefono": "","destino": "","legacySystem":"ARCA","origen": "","vehicleDescription": ""}'; 
        final RestRequest req = new RestRequest();
        final RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MX_SB_TareaDatosREST';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(strJsonD);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            final MX_SB_MLT_TareaDatosREST_Wsr.Response  resultado = MX_SB_MLT_TareaDatosREST_Wsr.guardaTareaDatos();
        Test.stopTest();
        System.assert(resultado.toString().contains(Label.MX_SB_MLT_ExitoTDT),'Exito');        
    }
}