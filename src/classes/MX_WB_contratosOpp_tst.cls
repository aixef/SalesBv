/****************************************************************************************************
author: Javier Ortiz Flores
company: Indra
Description: Clase test de MX_WB_contratosOpp

Information about changes (versions)
-------------------------------------
Number    Dates           Author                       Description
------    --------        --------------------------   -----------
1.0       01-Ene-2019     Javier Ortiz Flores          Creación de la Clase
1.2       12-Feb-2019     Eduardo Hernández Cuamatzi   Cobertura 100%
****************************************************************************************************/
@isTest
public class MX_WB_contratosOpp_tst {
    /** 
    */
    public static final Id pricebookId = Test.getStandardPricebookId();

    @testSetup static void setup() {
       	final User testUser = MX_WB_TestData_cls.crearUsuario('TestLastName', system.label.MX_SB_VTS_ProfileAdmin);
        insert testUser;
        final Account accRec = MX_WB_TestData_cls.crearCuenta('LastName', 'PersonAccount');
        accRec.OwnerId = testUser.Id;
        insert accRec;
        final MX_WB_FamiliaProducto__c asdCret =MX_WB_TestData_cls.createProductsFamily('ASD');
        insert asdCret;
        final product2 producto = MX_WB_TestData_cls.productNew('seguro test');
        producto.MX_WB_FamiliaProductos__c=asdCret.Id;
        insert producto;
        final priceBookEntry preciosOppRelated = MX_WB_TestData_cls.priceBookEntryNew(producto.Id);
        insert preciosOppRelated;
		final Opportunity oppRec = MX_WB_TestData_cls.crearOportunidad('Test 1', accRec.Id, testUser.Id, 'MX_WB_RT_Telemarketing');
        oppRec.Pricebook2Id = pricebookId;
        oppRec.Producto__c = producto.Id;
        oppRec.Estatus__c = '';
        oppRec.NumerodePoliza__c = '';
        oppRec.Reason__c = 'Venta';
        oppRec.MX_SB_VTS_Aplica_Cierre__c = true;
        oppRec.MX_WB_Tipo_de_venta__c = 'Venta Cobrada';
        oppRec.RecordTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('MX_WB_RT_Telemarketing').getRecordTypeId();
	    insert oppRec;
        final opportunityLineItem relOppProd = MX_WB_TestData_cls.oppLineItmNew(oppRec.Id, preciosOppRelated.Id, producto.Id, 1, 0);
        relOppProd.MX_WB_noPoliza__c = '15643';
        relOppProd.MX_WB_EstatusCotizacion__c = 'Emitida';
        insert relOppProd;
        final MX_WB_CredencialesCTI__c credenciales = new MX_WB_CredencialesCTI__c();
        credenciales.MX_WB_Contrasenia__c = 'TESTPASS';
        credenciales.MX_WB_Usuario__c = 'TESTUSER';
        credenciales.Name = 'ASD';
        insert credenciales;
    }
    @isTest
    /** 
    *Method
    */
    public static void generaContrato() {
        final Opportunity oppRec = [Select Id, StageName from Opportunity where Name = 'Test 1'];
        final Account acc = [Select Id from Account where FirstName = 'LastName'];
        final Lead leadTest = MX_WB_TestData_cls.createLead('TestProspect');
        leadTest.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('MX_WB_rt_Telemarketing').getRecordTypeId();
        leadTest.MX_WB_RCuenta__c = acc.Id;
        insert leadTest;
        final Task tarea = new Task();
        final User user = [Select Id from User where LastName = 'TestLastName'];
        final DateTime dateTimeContact = Datetime.newInstance(2019, 2, 7, 16, 37, 41);
        tarea.MX_WB_fechaUltimoContacto__c = dateTimeContact;
        tarea.OwnerId = user.Id;
        tarea.WhoId = leadTest.Id;
        tarea.MX_WB_EstatusCTI__c = 'GRABADORA CONTESTADORA';
        tarea.MX_WB_telefonoUltimoContactoCTI__c = '0445515987271';
        tarea.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('MX_WB_llamadaCandidato').getRecordTypeId();
        insert tarea;
        final Integer code = 200;
        final String status = 'OK';
        final String body= '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://201.148.35.186/ws/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns2="http://xml.apache.org/xml-soap" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:getCallResponse><return xsi:type="ns2:Map"><item><key xsi:type="xsd:string">status</key><value xsi:type="xsd:string">OK</value></item><item><key xsi:type="xsd:string">calls</key><value SOAP-ENC:arrayType="ns2:Map[2]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:41</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:nil="true"/></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">VDAD</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">'+leadTest.Id+'</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:17</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:type="xsd:string">EQUIVOCADO INCORRECTO</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">'+leadTest.Id+'</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item></value></item><item><key xsi:type="xsd:string">recordings</key><value SOAP-ENC:arrayType="ns2:Map[1]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Grabacion</key><value xsi:type="xsd:string">2019-02-07 16:37:20</value></item><item><key xsi:type="xsd:string">Grabacion</key><value xsi:type="xsd:string">ASD01013_20190207-163718_0458119135196_PECC891119</value></item><item><key xsi:type="xsd:string">Duracion</key><value xsi:type="xsd:string">3</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">'+leadTest.Id+'</value></item></item></value></item></return></ns1:getCallResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        final MX_WB_Mock mock = new MX_WB_Mock(code,status, body,new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
            oppRec.StageName = 'Closed Won';
            update oppRec;
        	System.assertEquals('Closed Won', oppRec.StageName);
        Test.stopTest();
    }

    @isTest
    /** 
    *Method generaContratoNoTask
    */
    public static void generaContratoNoTask() {
        final Opportunity oppRec = [Select Id, StageName from Opportunity where Name = 'Test 1'];
        final Account acc = [Select Id from Account where FirstName = 'LastName'];
        final Lead leadTest = MX_WB_TestData_cls.createLead('TestProspect');
        leadTest.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('MX_WB_rt_Telemarketing').getRecordTypeId();
        leadTest.MX_WB_RCuenta__c = acc.Id;
        insert leadTest;
        final Integer code = 200;
        final String status = 'OK';
        final String body= '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://201.148.35.186/ws/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns2="http://xml.apache.org/xml-soap" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:getCallResponse><return xsi:type="ns2:Map"><item><key xsi:type="xsd:string">status</key><value xsi:type="xsd:string">OK</value></item><item><key xsi:type="xsd:string">calls</key><value SOAP-ENC:arrayType="ns2:Map[2]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:41</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:nil="true"/></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">VDAD</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">'+leadTest.Id+'</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:17</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:type="xsd:string">EQUIVOCADO INCORRECTO</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">'+leadTest.Id+'</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item></value></item><item><key xsi:type="xsd:string">recordings</key><value SOAP-ENC:arrayType="ns2:Map[1]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Grabacion</key><value xsi:type="xsd:string">2019-02-07 16:37:20</value></item><item><key xsi:type="xsd:string">Grabacion</key><value xsi:type="xsd:string">ASD01013_20190207-163718_0458119135196_PECC891119</value></item><item><key xsi:type="xsd:string">Duracion</key><value xsi:type="xsd:string">3</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">'+leadTest.Id+'</value></item></item></value></item></return></ns1:getCallResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        final MX_WB_Mock mock = new MX_WB_Mock(code,status, body,new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
            oppRec.StageName = 'Closed Won';
            update oppRec;
        	System.assertEquals('Closed Won', oppRec.StageName);
        Test.stopTest();
    }

    @isTest
    /**
    *Method generaContratoNoPolicys 
    */
    public static void generaContratoNoPolicys() {
 		final User testUser1 = MX_WB_TestData_cls.crearUsuario('TestLastName', system.label.MX_SB_VTS_ProfileAdmin);
        insert testUser1;
        final Account accRec = MX_WB_TestData_cls.crearCuenta('LastName', 'PersonAccount');
        accRec.OwnerId = testUser1.Id;
        insert accRec;
        final MX_WB_FamiliaProducto__c asdCret =MX_WB_TestData_cls.createProductsFamily('ASD');
        insert asdCret;
        final product2 producto = MX_WB_TestData_cls.productNew('seguro test');
        producto.MX_WB_FamiliaProductos__c=asdCret.Id;
        insert producto;
        final priceBookEntry preciosOppRelated = MX_WB_TestData_cls.priceBookEntryNew(producto.Id);
        insert preciosOppRelated;
        final Opportunity oppRec = MX_WB_TestData_cls.crearOportunidad('Test 2', accRec.Id, testUser1.Id, 'MX_WB_RT_Telemarketing');
        oppRec.Producto__c = producto.Id;
        oppRec.Pricebook2Id = pricebookId;
        oppRec.Estatus__c = '';
        oppRec.MX_WB_Tipo_de_venta__c = 'Venta Cobrada';
        oppRec.NumerodePoliza__c = '';
        oppRec.RecordTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('MX_WB_RT_Telemarketing').getRecordTypeId();
        insert oppRec;
        Test.startTest();
            oppRec.StageName = 'Closed Won';
            try {
                update oppRec;
            }catch(DmlException dEx) {
                System.assertEquals(false, String.isBlank(dEx.getMessage()));
            }
        Test.stopTest();
    }

    @isTest
    /** 
    Method generaContratoExist
    */
    public static void generaContratoExist() {
        final Account acc = [Select Id from Account where FirstName = 'LastName'];
        final Opportunity oppRec = [Select Id, StageName from Opportunity where Name = 'Test 1'];
        final OpportunityLineItem oppLiItem = [Select Id, MX_WB_noPoliza__c from OpportunityLineItem where OpportunityId =: oppRec.Id];
        final Contract contrato = new Contract();
        contrato.MX_WB_noPoliza__c = oppLiItem.MX_WB_noPoliza__c;
        contrato.MX_WB_Oportunidad__c = oppRec.Id;
        contrato.AccountId = acc.Id;
        insert contrato;
        Test.startTest();
            oppRec.StageName = 'Closed Won';
            update oppRec;
        	System.assertEquals('Closed Won', oppRec.StageName);
        Test.stopTest();
    }
}
