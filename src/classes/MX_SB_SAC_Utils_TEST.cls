/*
----------------------------------------------------------
* Nombre: MX_SB_SAC_Utils_TEST
* Autor Saúl González
* Proyecto: SB SAC - BBVA Bancomer
* Descripción : Clase con metódos reutilizables para la consulta de polizas
* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                               Descripción
* --------------------------------------------------------------------------------
* 1.0           04/04/2019     Saúl González                        Creación
* 2.0           12/07/2019     Karen Sanchez                        Agregar asserts
* --------------------------------------------------------------------------------
*/
@isTest
private class MX_SB_SAC_Utils_TEST { //NOSONAR
     
    /**
* Fecha: Año, mes y día
*/
    @isTest 
    static void fechaYYYYMMDD() {
        final String dateYMDHMS = '2019-01-01 12:00:00';
        final Date dFecha = Date.valueOf(dateYMDHMS);
        Test.startTest();        
        MX_SB_SAC_Utils_Cls.fechaYYYYMMDDHHMMSS(dateYMDHMS);
        System.assertEquals(dFecha,Date.newInstance(2019, 01, 01),'Fecha nueva año, mes día');
        Test.stopTest();
    }
    
    /**
* Fecha: Día, mes y año
*/
    @isTest 
    static void fechaDDMMYYYY() {
        final String dateDDMMYYYY = '01-01-2019';        
        final String sDia = dateDDMMYYYY.substring(0, 2);
        final String sMes = dateDDMMYYYY.substring(3, 5);
        final String sAnio = dateDDMMYYYY.substring(6, 10);
        final Date dFecha = Date.newInstance(Integer.valueOf(sAnio), Integer.valueOf(sMes), Integer.valueOf(sDia));
        Test.startTest();        
        MX_SB_SAC_Utils_Cls.fechaDDMMYYYYTOYYYYMMDD(dateDDMMYYYY);
        System.assertEquals(dFecha,Date.newInstance(2019, 01, 01),'Fecha nueva año, mes día');
        Test.stopTest();
    }
    
    /**
* Fecha: Mes, día y año
*/
    @isTest
    static void fechaMMDDYYYY() {
        final String dateMMDDYYYY = '01-01-2019';
        final String sDia = dateMMDDYYYY.substring(3, 5);
        final String sMes = dateMMDDYYYY.substring(0, 2);
        final String sAnio = dateMMDDYYYY.substring(6, 10);        
        final Date  dFecha = Date.newInstance(Integer.valueOf(sAnio), Integer.valueOf(sMes), Integer.valueOf(sDia));
        Test.startTest();        
        MX_SB_SAC_Utils_Cls.fechaMMDDYYYYTOYYYYMMDD(dateMMDDYYYY);
        System.assertEquals(dFecha,Date.newInstance(2019, 01, 01),'Fecha nueva año, mes día');
        Test.stopTest();
    }
    
    /**
* Valida fechas vacias
*/
    @isTest
    static void validaDatoVacio() {
        final String strBlank = '01-01-2019';
        Test.startTest();
        MX_SB_SAC_Utils_Cls.validaDatoVacio(strBlank);
        System.assertEquals(strBlank,strBlank,'El campo no esta vacío');
        Test.stopTest();
    }
    
    /**
* Generar cuenta
*/
    @isTest
    static void getMapAccount() {
        final List<Account> arrAccount = new List<Account>();
        Test.startTest();       
        MX_SB_SAC_Utils_Cls.getMapAccount(arrAccount);
        Account acct = MX_SB_SAC_UtileriasTestCls.crearCuenta('accountTest', 'PersonAccount');
        acct.PersonEmail='test@test.com';
        insert acct;
        arrAccount.add(acct);
        MX_SB_SAC_Utils_Cls.getMapAccount(arrAccount);
        System.assertEquals('test@test.com',acct.PersonEmail,'Correo electrónico correcto');
        Test.stopTest();
    }
    
    /**
* Generar contrato
*/
    @isTest
    static void getMapContract() {
        final List<Contract> arrContract = new List<Contract>();
        Test.startTest();        
        MX_SB_SAC_Utils_Cls.getMapContract(arrContract);
        Account acct = MX_SB_SAC_UtileriasTestCls.crearCuenta('accountTest', 'PersonAccount');
        acct.PersonEmail='test@test.com';
        insert acct;
        Contract cont = MX_SB_SAC_UtileriasTestCls.crearContrato(acct.Id, null);
        cont.MX_WB_noPoliza__c='819W0A001K';
        insert cont;
        arrContract.add(cont);
        MX_SB_SAC_Utils_Cls.getMapContract(arrContract);
        System.assertEquals('819W0A001K',cont.MX_WB_noPoliza__c,'Número de póliza correcto');
        Test.stopTest();
    }
    
    /**
* Generar token
*/
    @isTest
    static void updateCustoSetting() {
        final MX_SB_SAC_LoginToken__c logToken = MX_SB_SAC_UtileriasTestCls.creaCredencial();
        Test.startTest();        
        logToken.Name = 'Login Siniestros';
        insert logToken;
        final String tokenTest='TOKENPARACLASETEST';
        MX_SB_SAC_Utils_Cls.updateCustoSetting(tokenTest);
        System.assertEquals('TOKENPARACLASETEST',tokenTest,'token correcto');
        Test.stopTest();
    }
    
    /**
* genera siniestros en el número de póliza indicada
*/
    @isTest
    static void matchSinisters() {
        
        Account acct = MX_SB_SAC_UtileriasTestCls.crearCuenta('accountTest', 'PersonAccount');
        acct.PersonEmail='test@test.com';
        insert acct;
        Contract cont = MX_SB_SAC_UtileriasTestCls.crearContrato(acct.Id, null);
        cont.MX_WB_noPoliza__c='819W0A001K';
        insert cont;
        MX_SB_SAC_SiniestrosDtoCls.respRestGetSiniestro objRespGetSiniestro = new MX_SB_SAC_SiniestrosDtoCls.respRestGetSiniestro();
        objRespGetSiniestro.nombreMetodo = 'obtenerSiniestrosPoliza';
        objRespGetSiniestro.error = false;
        objRespGetSiniestro.detalle = '';
        objRespGetSiniestro.JsonRes = '{"siniestrosPoliza": {"informacionSiniestros": [ {"coberturas": [ {"clave": "A","nombre": "DAÑOS MATERIALES","saldo": "0.00","estatus": "CERRADA"}],"tipo": "COLISION","folio": "B37957363","estatus": "PROCEDENTE DE PAGO","culpabilidad": "ASEGURADO","fecha": [2016, 6, 19]}]},"operacionResultado": "OK","operacionMensaje": [],"browserUrl": null,"opMsjExtra": ""}';
        
        Test.startTest();
        MX_SB_SAC_Utils_Cls.matchSinisters(objRespGetSiniestro, cont.MX_WB_noPoliza__c);
        System.assertEquals('819W0A001K',cont.MX_WB_noPoliza__c,'Se genera correctamente el siniestro');
        Test.stopTest();
    }
}