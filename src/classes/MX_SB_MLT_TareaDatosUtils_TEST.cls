/**----------------------------------------------------------------------------------
* Nombre: MX_SB_MLT_TareaDatosUtils_TEST
* Autor Oscar Martínez
* Proyecto: Siniestros - BBVA Bancomer
* Descripción : Prueba los Methods de MX_SB_MLT_TareaDatosUtils_Cls
* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                               Descripción
* --------------------------------------------------------------------------------
* 1.0           08/05/2019     Oscar Martínez                       Creación
* 1.1           15/05/2019     Oscar Martínez                       Se corrijen issues de sonar.
* 1.2           15/05/2019     Oscar Martínez                       Cambio de Profile a CustomLabel
* 1.3           18/07/2019     Saúl González                        Se agrega validación de tipo datetime
* 1.4           24/09/2019     Daniel Goncalves Vivas               Se agregan methods de prueba de ValidaDatoDecimal y de GetDate
* 1.5           27/09/2019     Angel Nava                           Se agrega method de validación Arca y disminucion de metodos
* 1.6           11/10/2019     Daniel Goncalves Vivas               Se agrega method validaFechaGlass
* --------------------------------------------------------------------------------
**/
@isTest
public class MX_SB_MLT_TareaDatosUtils_TEST {
    /*Fecha Completa con Hora */
    static final String DATWTIM = '01/01/2012 07:08:16';
    /*Fecha sin Hora*/
    static final String DATONLY = '01/01/2012';
    /*Hora sin Fecha*/
    static final String HRONLY = '7:08:16';

    @testSetup static void setup() {
        final User testUser = MX_WB_TestData_cls.crearUsuario ( 'TestLastName', Label.MX_SB_VTS_ProfileAdmin );
        insert testUser;
        System.runAs(testUser) {
            final Account accRec = MX_WB_TestData_cls.crearCuenta ( 'LastName', 'MX_WB_rt_PAcc_Telemarketing' );
            accRec.OwnerId = testUser.Id;
            accRec.Correo_Electronico__c = 'prueba@wibe.com';
            insert accRec;
        }
    }

    static testMethod void queryObjects() {
        final Id accRecId = [SELECT ID FROM Account WHERE Correo_Electronico__c = 'prueba@wibe.com' LIMIT 1].ID;
        final Case objCasoTst = new Case(Status='new',Origin='phone',Priority='Medium',AccountId=accRecId,MX_SB_MLT_URLLocation__c='99.3123123,-19.45345');
        insert objCasoTst;
        Test.startTest();
            final List<Case> lstResponse = MX_SB_MLT_TareaDatosUtils_Cls.obtieneCase(objCasoTst.Id);
        Test.stopTest();
        System.assert(!lstResponse.isEmpty(), 'Retorna Listado con Caso');
    }

    static testMethod void queryObjectsDato() {
        final Id accRecId = [SELECT ID FROM Account WHERE Correo_Electronico__c = 'prueba@wibe.com' LIMIT 1].ID;
        final Case objCasoTst = new Case(Status='new',Origin='phone',Priority='Medium',AccountId=accRecId,MX_SB_MLT_URLLocation__c='99.3123123,-19.45345');
        insert objCasoTst;
        Test.startTest();
            final List<Case> lstResponse = MX_SB_MLT_TareaDatosUtils_Cls.obtieneCase(objCasoTst.Id);
        Test.stopTest();
        final Case casoResultado =  lstResponse.get(0);
        System.assertEquals('99.3123123,-19.45345', casoResultado.MX_SB_MLT_URLLocation__c, 'Dato Obtenido Correcto');
    }

    static testMethod void validaDatoNull() {
        Test.startTest();
            final String strRespuesta = MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio(null);
        Test.stopTest();
        System.assert(String.isEmpty(strRespuesta), 'Funciona dato nulo');
    }

    static testMethod void validaDatoVacio() {
        Test.startTest();
        final String strRespuesta = MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio('');
        final String decRespuesta = String.valueOf(MX_SB_MLT_TareaDatosUtils_Cls.validaDatoDecimalVacio('0.00'));
        MX_SB_MLT_TareaDatosUtils_Cls.getDate('');
        Test.stopTest();
        System.assert( String.isEmpty(strRespuesta) && '0.00'==decRespuesta, 'Funciona dato vacío');
    }

    static testMethod void validaDato() {
        Test.startTest();
        final String strRespuesta = MX_SB_MLT_TareaDatosUtils_Cls.validaDatoVacio('dato');
        final String decRespuesta = String.valueOf(MX_SB_MLT_TareaDatosUtils_Cls.validaDatoDecimalVacio('1.23'));
        final String fechaRes = String.valueOf(MX_SB_MLT_TareaDatosUtils_Cls.getDate('01/01/2019'));
        Test.stopTest();
        System.assertEquals('dato'+'2019-01-01'+'1.23', strRespuesta+fechaRes+decRespuesta, 'Funciona dato con valor');
    }
    
    static testMethod void validaDatoDecimalNulo() {
        Test.startTest();
            final Decimal decRespuesta = MX_SB_MLT_TareaDatosUtils_Cls.validaDatoDecimalVacio(null);
        Test.stopTest();
        System.assertEquals(0.00, decRespuesta, 'Funciona Decimal Nulo'); 
    }

    static testMethod void validaEventTest() {
        Test.startTest();
            final String evento =  MX_SB_MLT_TareaDatosUtils_Cls.validaEvent('ARCA','',1);
        Test.stopTest();
        system.assertEquals('Ambulancia', evento,'obtiene servicio');
    }

    static testMethod void validaFechaGlass() {
        Test.startTest();
        final Date fechaG = MX_SB_MLT_TareaDatosUtils_Cls.getDate(DATWTIM);
        final Date fechaG2 = MX_SB_MLT_TareaDatosUtils_Cls.getDate(DATONLY);
        final Date fechaG3 = MX_SB_MLT_TareaDatosUtils_Cls.getDate('');
        final String fechaH = MX_SB_MLT_TareaDatosUtils_Cls.getTimeGlass(HRONLY,DATONLY);
        final String fechaH2 = MX_SB_MLT_TareaDatosUtils_Cls.getTimeGlass('',DATWTIM);
        final String fechaH3 = MX_SB_MLT_TareaDatosUtils_Cls.getTimeGlass(HRONLY,'');
        Test.stopTest();
        final String resultado = fechaG+' '+fechaG2+' '+fechaG3+' '+fechaH+' '+fechaH2+' '+fechaH3;
        system.assertEquals('2012-01-01 00:00:00 2012-01-01 00:00:00 1961-01-01 00:00:00 7:08 07:0 7:08', resultado,'Validación Fecha y Hora Cristales');
    }
}