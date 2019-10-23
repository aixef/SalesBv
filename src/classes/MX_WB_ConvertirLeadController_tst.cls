/**-------------------------------------------------------------------------
* Nombre: MX_WB_ConverLeadController
* Autor Alexis Pérez
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Test class to ConvertirLeadController

* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Desripción
* --------------------------------------------------------------------------
* 1.0           15/01/2019      Alexis Pérez		   	Creación
* --------------------------------------------------------------------------
* 1.1          20/02/2019      Alexis Pérez		   	Modificación al método testError se atrapa la excepción de System.AuraHandledException
* 1.2          21/02/2019      Oscar Martínez		Modificación al método testIf se agrega el campo Status con valor de Cotizada
* 1.3			05/03/2019	   Alexis Pérez			Se modifica la clase de prueba para ajustarla a conversión estandar de Cuenta personal
* 1.3.1		24/06/2019	Eduardo Hernández		Corección proceso para productos
* 1.3.2		31/07/2019	Eduardo Hernández		Mejora credenciales
* --------------------------------------------------------------------------
*/

@IsTest
public class MX_WB_ConvertirLeadController_tst {

    /**Response Mock CTI */
    final static String BODY = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://201.148.35.186/ws/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns2="http://xml.apache.org/xml-soap" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:getCallResponse><return><item><key xsi:type="xsd:string">status</key><value xsi:type="xsd:string">OK</value></item><item><key xsi:type="xsd:string">calls</key><value SOAP-ENC:arrayType="ns2:Map[2]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:41</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:nil="true"/></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">VDAD</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:17</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:type="xsd:string">EQUIVOCADO INCORRECTO</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item></value></item><item><key xsi:type="xsd:string">recordings</key><value SOAP-ENC:arrayType="ns2:Map[1]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Grabacion</key><value xsi:type="xsd:string">2019-02-07 16:37:20</value></item><item><key xsi:type="xsd:string">Grabacion</key><value xsi:type="xsd:string">ASD01013_20190207-163718_0458119135196_PECC891119</value></item><item><key xsi:type="xsd:string">Duracion</key><value xsi:type="xsd:string">3</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item></item></value></item></return></ns1:getCallResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';

    @TestSetup
    static void makeData() {
        final User uTelemarketing = MX_WB_TestData_cls.crearUsuario('Telemarketing1', System.Label.MX_SB_VTS_ProfileAdmin);
        insert uTelemarketing;

        final MX_WB_FamiliaProducto__c objFamProd = new MX_WB_FamiliaProducto__c();
        objFamProd.Name = 'ASD';
        insert objFamProd;

        final MX_WB_FamiliaProducto__c objFamProd2 = new MX_WB_FamiliaProducto__c();
        objFamProd2.Name = 'Hogar';
        insert objFamProd2;

        final Product2 objProducto = new Product2();
        objProducto.Name = System.label.MX_SB_VTS_AutoSeguroCorrecto;
        objProducto.IsActive = true;
        objProducto.MX_WB_FamiliaProductos__c = objFamProd.Id;
        objProducto.MX_SB_SAC_Proceso__c = 'VTS';
        insert objProducto;

        final Product2 objProducto2 = new Product2();
        objProducto2.Name = System.label.MX_SB_VTS_Hogar;
        objProducto2.IsActive = true;
        objProducto2.MX_WB_FamiliaProductos__c = objFamProd2.Id;
        objProducto2.MX_SB_SAC_Proceso__c = 'VTS';
        insert objProducto2;

        final Scripts_Stage_Product__c objScript = new Scripts_Stage_Product__c();
        objScript.MX_WB_Etapa__c = 'Contacto Efectivo';
        objScript.MX_WB_FamiliaProductos__c = objFamProd.Id;
        objScript.MX_WB_Script__c = 'MinionTestScript001';
        insert objScript;
        final Date objDTHoy = Date.today();
        final Campaign objCampana = new Campaign();
        objCampana.Name = 'TestMinion001';
        objCampana.IsActive = true;
        objCampana.StartDate = objDThoy;
        objCampana.EndDate = objDTHoy.addDays(30);
        objCampana.Type = 'Outbound';
        objCampana.MX_WB_FamiliaProductos__c = objFamProd.Id;
        insert objCampana;
        final MX_WB_CredencialesCTI__c autoDinamico = new MX_WB_CredencialesCTI__c();
		autoDinamico.Name = 'ASD'+0;
		autoDinamico.MX_WB_Usuario__c = 'usuarioTest';
		autoDinamico.MX_WB_Contrasenia__c = 'passwordTest';
		insert autoDinamico;

        final Lead tLead = MX_WB_TestData_cls.createLead('test new convert');
        tLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_Telemarketing_LBL).getRecordTypeId();
        tLead.LeadSource = System.Label.MX_SB_VTS_OrigenCallMeBack;
        tLead.Producto_Interes__c = System.Label.MX_SB_VTS_Hogar;
        tLead.MobilePhone = '5531234567';
        tLead.Email = 'tLead@test.hogar.com';
        insert tLead;

        final Lead tLead2 = MX_WB_TestData_cls.createLead('test no email');
        tLead2.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_Telemarketing_LBL).getRecordTypeId();
        tLead2.LeadSource = System.Label.MX_SB_VTS_OrigenCallMeBack;
        tLead2.Producto_Interes__c = System.Label.MX_SB_VTS_Hogar;
        tLead.MobilePhone = '5531234569';
        insert tLead2;
    }

     /**
     * Ideal test.
     */
    @IsTest
	public static void convertirLeadASDExcep() {
        final Boolean bExistKey = true;
        final Map<String,String> mpEstado = null;
        final Lead objLead = creaLead();
        objLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_RecordTypeASD).getRecordTypeId();
        objLead.LeadSource = System.Label.MX_WB_leadSource;
        objLead.MobilePhone = '5561839455';
        objLead.Producto_Interes__c = System.label.MX_SB_VTS_AutoSeguroInCorrecto;
        final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', BODY,new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        insert objLead;
        final Campaign objCampana = [Select Id from Campaign];
        final CampaignMember objCamMem = new CampaignMember();
        objCamMem.CampaignId = objCampana.Id;
        objCamMem.LeadId = objLead.Id;
        insert objCamMem;
        objLead.MX_WB_lst_EstatusPrimerContacto__c = 'Contacto Efectivo';
        objLead.Status = 'Cotizada';
        update objLead;
        try {
            MX_WB_ConvertirLeadController.convertirLead(objLead.Id);
        } catch (AuraHandledException aEx) {
            aEx.setMessage('error');
            System.assertEquals(aEx.getMessage(),'error', 'Error al convertir');
        }
        Test.stopTest();

    }

    /**
     * Ideal test.
     */
    @IsTest
	public static void convertirLeadOutBound() {
        final Boolean bExistKey = true;
        Map<String,String> mpEstado = null;
        final Lead objLead = creaLead();
        objLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_RecordTypeOut).getRecordTypeId();
        objLead.LeadSource = System.Label.MX_WB_leadSource;
        objLead.MobilePhone = '5561539485';
        objLead.Producto_Interes__c = System.label.MX_SB_VTS_AutoSeguroInCorrecto;
        final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', BODY,new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        insert objLead;
        final Campaign objCampana = [Select Id from Campaign];
        final CampaignMember objCamMem = new CampaignMember();
        objCamMem.CampaignId = objCampana.Id;
        objCamMem.LeadId = objLead.Id;
        insert objCamMem;
        objLead.MX_WB_lst_EstatusPrimerContacto__c = 'Contacto Efectivo';
        objLead.Status = 'Cotizada';
        update objLead;

        mpEstado = MX_WB_ConvertirLeadController.convertirLead(objLead.Id);
        Test.stopTest();
        System.assertEquals(bExistKey, mpEstado.containsKey('OK'), 'Id de la oportunidad esperado.');
    }

    /**
     * Else test.
     */
    @IsTest
	public static void testElse() {
        final Boolean bExistKey = true;
        Map<String,String> mpEstado = null;
        final Lead objLead = creaLead();
        objLead.MX_WB_lst_EstatusPrimerContacto__c = 'Contacto Efectivo';
        objLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_RecordTypeASD).getRecordTypeId();
        objLead.LeadSource = System.Label.MX_WB_leadSource;
        objLead.MobilePhone = '5561835485';
        objLead.Producto_Interes__c = System.label.MX_SB_VTS_AutoSeguroInCorrecto;
        final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', BODY,new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        insert objLead;
        final Campaign objCampana = [Select Id from Campaign];
        final CampaignMember objCamMem = new CampaignMember();
        objCamMem.CampaignId = objCampana.Id;
        objCamMem.LeadId = objLead.Id;
        insert objCamMem;
        mpEstado = MX_WB_ConvertirLeadController.convertirLead(objLead.Id);
        Test.stopTest();
        System.assertEquals(bExistKey, mpEstado.containsKey('ERROR'), 'Error esperado.');
    }

     /**
     * Else test.
     */
    @IsTest
	public static void callmeBack() {
        final Lead objLead = creaLead();
        objLead.MX_WB_lst_EstatusPrimerContacto__c = 'Contacto Efectivo';
        objLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_RecordTypeASD).getRecordTypeId();
        objLead.LeadSource = System.Label.MX_SB_VTS_OrigenCallMeBack;
        objLead.MobilePhone = '5561835485';
        objLead.Producto_Interes__c = System.label.MX_SB_VTS_AutoSeguroInCorrecto;
        final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', BODY,new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        insert objLead;
        Test.stopTest();
        System.assertEquals(objLead.Producto_Interes__c, System.label.MX_SB_VTS_AutoSeguroInCorrecto,  'Call me back.');
    }

    /**
     * Alternative Case test.
     */
    @IsTest
	public static void testAlternativeCase() {
        String strError = null;
        try {
            Test.startTest();
            MX_WB_ConvertirLeadController.convertirLead(null);
            Test.stopTest();
        } catch(System.AuraHandledException ex) {
            strError = 'Script-thrown exception';
            System.assertEquals(strError, ex.getMessage(), 'Error atrapado en la excepción');
        }
    }


    /**
     * Create a Lead object.
     */
    public static Lead creaLead() {
        final Lead objLead = new Lead();
        objLead.Email = 'minion001@gmail.com';
        objLead.LastName = '001';
        objLead.FirstName = 'Minion';
        objLead.Apellido_Materno__c = 'Sanchez';
        objLead.Phone = '5598745630';
        objLead.MX_WB_ph_Telefono1__c = '5598745631';
        objLead.MX_WB_ph_Telefono2__c = '5598745632';
        objLead.MX_WB_ph_Telefono3__c = '5598745633';
        objLead.MX_WB_TipoTelefono1__c = 'F';
        objLead.MX_WB_TipoTelefono2__c = 'F';
        objLead.MX_WB_TipoTelefono3__c = 'F';
        objLead.MX_WB_txt_Extension1__c = '5591';
        objLead.MX_WB_txt_Extension2__c = '5592';
        objLead.MX_WB_txt_Extension3_del__c = '5593';
        objLead.MX_WB_int_TerminacionTarjeta__c = '8796';
        objLead.MX_WB_txt_NumClienteEnmascarado__c = '12345678';
        objLead.MX_WB_Cliente_Unico_BBVA__c = 'qwedrftgyhujiklopzxcvbnm123456789741021645987';
        objLead.MX_WB_Cliente_Unico_Seguros__c = 'qwedrftgyhujiklopzxcvbnm123456789741021645987';
        objLead.MX_WB_No_envios_CTI__c = 0;
        objLead.MX_WB_txt_BCOM__c = 'BCO';
        objLead.MX_WB_txt_BMOV__c = 'CMO';
        objLead.MX_WB_txt_Clave_Texto__c = 'poiquefgd';
        objLead.MX_WB_txt_Prefijo_1__c = 'qwe';
        objLead.MX_WB_txt_Prefijo_2__c = 'qwe';
        objLead.MX_WB_txt_Prefijo_3__c = 'wer';
        objLead.Producto_Interes__c = System.label.MX_SB_VTS_AutoSeguroInCorrecto;
        return objLead;
    }
/**
*
* @crear cuenta
*/
    public static Account createAccount() {
        final Long noCliente = (Math.random()*10000000).round();
        final Account objAcc = new Account();
        objAcc.FirstName = 'Minion';
        objAcc.LastName = '001';
        objAcc.ApellidoMaterno__c = 'BancomerTest';
        objAcc.AccountNumber = String.valueOf(noCliente);
        objAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('MX_WB_rt_PAcc_Telemarketing').getRecordTypeId();
        objAcc.Correo_Electronico__c = 'minion001@gmail.com';
        insert objAcc;
        return objAcc;
    }

    /** nueva conversion */
    @isTest
    static void testNewBuConvert() {
        final Lead leadToConvert = [Select Id, Resultadollamada__c, MX_SB_VTS_Tipificacion_LV2__c,
                             MX_SB_VTS_Tipificacion_LV3__c, Status from Lead where Name = 'test new convert'];
        leadToConvert.MX_SB_VTS_Tipificacion_LV3__c = System.Label.MX_SB_VTS_Interesado;
        leadToConvert.Resultadollamada__c = System.Label.MX_SB_VTS_ResultadoLlamada;
        leadToConvert.MX_SB_VTS_Tipificacion_LV2__c = System.Label.MX_SB_VTS_ContactoEfectivo;
        leadToConvert.Status = System.Label.MX_SB_VTS_AperturaCuenta;
        Database.update(leadToConvert);
        Test.startTest();
        final Map<String, String> testConvert = MX_WB_ConvertirLeadController.convertirLead(leadToConvert.Id);
        System.assertNotEquals(testConvert.get('OK'), null, 'Exito al convertir');
        Test.stopTest();
    }
    /** */
    @isTest
    static void testDummyEmail() {
        final Lead leadToConvert = [Select Id, Resultadollamada__c, MX_SB_VTS_Tipificacion_LV2__c,
                             MX_SB_VTS_Tipificacion_LV3__c, Status from Lead where Name = 'test no email'];
        leadToConvert.MX_SB_VTS_Tipificacion_LV3__c = System.Label.MX_SB_VTS_Interesado;
        leadToConvert.Resultadollamada__c = System.Label.MX_SB_VTS_ResultadoLlamada;
        leadToConvert.MX_SB_VTS_Tipificacion_LV2__c = System.Label.MX_SB_VTS_ContactoEfectivo;
        leadToConvert.Status = System.Label.MX_SB_VTS_AperturaCuenta;
        Database.update(leadToConvert);
        Test.startTest();
        final Map<String, String> testConvert = MX_WB_ConvertirLeadController.convertirLead(leadToConvert.Id);
        System.assertNotEquals(testConvert.get('OK'), null, 'Exito al convertir');
        Test.stopTest();
    }
}