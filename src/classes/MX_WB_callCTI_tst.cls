/****************************************************************************************************
author: Eduardo Hernández Cuamatzi
company: Indra
Description: Clase test de MX_WB_callCTI_sch

Information about changes (versions)
-------------------------------------
Number    Dates           Author                       Description
------    --------        --------------------------   -----------
1.0       12-Feb-2019     Eduardo Hernández Cuamatzi   Creación de la Clase
1.0       20-Jun-2019     Eduardo Hernández Cuamatzi   Se modifican metodos de test
****************************************************************************************************/
@isTest
public class MX_WB_callCTI_tst {
    /**
    *Field
    */
    public static final Id pricebookId = Test.getStandardPricebookId();

    @testSetup static void setup() {
       	final User testUser = MX_WB_TestData_cls.crearUsuario('TestLastName', System.Label.MX_SB_VTS_ProfileAdmin);
        insert testUser;
        final Account accRec = MX_WB_TestData_cls.crearCuenta('LastName', 'PersonAccount');
        accRec.OwnerId = testUser.Id;
        insert accRec;
        final product2 producto = MX_WB_TestData_cls.productNew('seguro test');
        insert producto;
        final priceBookEntry preciosOppRelated = MX_WB_TestData_cls.priceBookEntryNew(producto.Id);
        insert preciosOppRelated;
		final Opportunity oppRec = MX_WB_TestData_cls.crearOportunidad('Test 1', accRec.Id, testUser.Id, 'MX_WB_RT_Telemarketing');
        oppRec.Pricebook2Id = pricebookId;
        oppRec.Producto__c = producto.Id;
        oppRec.Estatus__c = '';
        oppRec.NumerodePoliza__c = '';
        oppRec.MX_WB_Tipo_de_venta__c = 'Venta Cobrada';
        oppRec.Reason__c = 'Venta';
        oppRec.MX_SB_VTS_Aplica_Cierre__c = true;
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
    *Method generaContrato
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
        oppRec.StageName = 'Closed Won';
        update oppRec;
        Test.startTest();
        	final String CRON_EXP = '0 0 0 3 9 ? 2022';
			final String jobId = System.schedule('testBasicScheduledApex',CRON_EXP, new MX_WB_callCTI_sch());
          	final CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
          	System.assertEquals(CRON_EXP, ct.CronExpression);
        Test.stopTest();
    }

    /*@isTest
    public static void MX_WB_callBatch_bch() {
        Account acc = [Select Id from Account where FirstName = 'LastName'];
        Lead leadTest = MX_WB_TestData_cls.createLead('TestProspect');
        leadTest.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('MX_WB_rt_Telemarketing').getRecordTypeId();
        leadTest.MX_WB_RCuenta__c = acc.Id;
        Date myDate = Date.today();
        leadTest.MX_WB_EnvioCTI__c = myDate;
        insert leadTest;
        Task tarea = new Task();
        User user = [Select Id from User where LastName = 'TestLastName'];
        DateTime dateTimeContact = Datetime.newInstance(2019, 2, 7, 16, 37, 41);
        tarea.MX_WB_fechaUltimoContacto__c = dateTimeContact;
        tarea.OwnerId = user.Id;
        tarea.WhoId = leadTest.Id;
        tarea.MX_WB_EstatusCTI__c = 'GRABADORA CONTESTADORA';
        tarea.MX_WB_telefonoUltimoContactoCTI__c = '0445515987271';
        tarea.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('MX_WB_llamadaCandidato').getRecordTypeId();
        insert tarea; Integer code = 200; String status = 'OK';
        String body= '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:ns1="http://201.148.35.186/ws/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns2="http://xml.apache.org/xml-soap"
        xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:getCallResponse><return xsi:type="ns2:Map">
        <item><key xsi:type="xsd:string">status</key><value xsi:type="xsd:string">OK</value></item><item><key xsi:type="xsd:string">calls</key><value SOAP-ENC:arrayType="ns2:Map[2]" xsi:type="SOAP-ENC:Array">
        <item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:41</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value>
        </item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:nil="true"/></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">VDAD</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">
        '+leadTest.Id+'</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key>
        <value xsi:type="xsd:string"></value></item></item><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:17</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key>
        <value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:type="xsd:string">EQUIVOCADO INCORRECTO</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value>
        </item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">'+leadTest.Id+'</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string">
        </value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item></value></item><item><key xsi:type="xsd:string">recordings</key><value SOAP-ENC:arrayType="ns2:Map[1]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map">
        <item><key xsi:type="xsd:string">Fecha_Grabacion</key><value xsi:type="xsd:string">2019-02-07 16:37:20</value></item><item><key xsi:type="xsd:string">Grabacion</key><value xsi:type="xsd:string">ASD01013_20190207-163718_0458119135196_PECC891119</value></item><item>
        <key xsi:type="xsd:string">Duracion</key><value xsi:type="xsd:string">3</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">'+leadTest.Id+'</value>
        </item></item></value></item></return></ns1:getCallResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        MX_WB_Mock mock = new MX_WB_Mock(code,status, body,new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);
        oppRec.StageName = 'Closed Won';
        update oppRec;
        Test.startTest();
            String manana = String.valueOf(system.today()+1);
            String ayer = String.valueOf(system.today()-1);
            string servicio = 'SELECT Id FROM Lead WHERE MX_WB_EnvioCTI__c < '+manana+' AND MX_WB_EnvioCTI__c > '+ayer;
            MX_WB_callBatch_bch objExecuteBatch = new MX_WB_callBatch_bch(String.escapeSingleQuotes(servicio));
        	Id batchInstanceId = Database.executeBatch(objExecuteBatch, 200);
        	System.assert(String.isNotBlank(batchInstanceId));
        Test.stopTest();
    }

    @isTest
    public static void MX_WB_callBatch_bchOpp() {
        Opportunity oppRec = [Select Id, StageName from Opportunity where Name = 'Test 1'];
        Account acc = [Select Id from Account where FirstName = 'LastName'];
        Lead leadTest = MX_WB_TestData_cls.createLead('TestProspect');
        leadTest.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('MX_WB_rt_Telemarketing').getRecordTypeId();
        leadTest.MX_WB_RCuenta__c = acc.Id;
        Date myDate = Date.today();
        leadTest.MX_WB_EnvioCTI__c = myDate;
        insert leadTest;
        Task tarea = new Task();
        User user = [Select Id from User where LastName = 'TestLastName'];
        DateTime dateTimeContact = Datetime.newInstance(2019, 2, 7, 16, 37, 41);
        tarea.MX_WB_fechaUltimoContacto__c = dateTimeContact;
        tarea.OwnerId = user.Id;
        tarea.WhatId = oppRec.Id;
        tarea.MX_WB_EstatusCTI__c = 'GRABADORA CONTESTADORA';
        tarea.MX_WB_telefonoUltimoContactoCTI__c = '0445515987271';
        tarea.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('MX_WB_llamadaCandidato').getRecordTypeId();
        insert tarea;
        Integer code = 200;
        String status = 'OK';
        String body= '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:ns1="http://201.148.35.186/ws/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:ns2="http://xml.apache.org/xml-soap" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
        <SOAP-ENV:Body><ns1:getCallResponse><return xsi:type="ns2:Map"><item><key xsi:type="xsd:string">status</key><value xsi:type="xsd:string">OK</value></item><item>
        <key xsi:type="xsd:string">calls</key><value SOAP-ENC:arrayType="ns2:Map[2]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item>
        <key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:41</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key>
        <value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:nil="true"/></item><item><key xsi:type="xsd:string">idUser</key>
        <value xsi:type="xsd:string">VDAD</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">'+leadTest.Id+'</value></item><item><key xsi:type="xsd:string">Tel_1</key>
        <value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key>
        <value xsi:type="xsd:string"></value></item></item><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:17</value></item>
        <item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:type="xsd:string">EQUIVOCADO INCORRECTO</value>
        </item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">'+leadTest.Id+'</value></item><item>
        <key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key>
        <value xsi:type="xsd:string"></value></item></item></value></item><item><key xsi:type="xsd:string">recordings</key><value SOAP-ENC:arrayType="ns2:Map[1]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item>
        <key xsi:type="xsd:string">Fecha_Grabacion</key><value xsi:type="xsd:string">2019-02-07 16:37:20</value></item><item><key xsi:type="xsd:string">Grabacion</key><value xsi:type="xsd:string">ASD01013_20190207-163718_0458119135196_PECC891119</value>
        </item><item><key xsi:type="xsd:string">Duracion</key><value xsi:type="xsd:string">3</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key>
        <value xsi:type="xsd:string">'+leadTest.Id+'</value></item></item></value></item></return></ns1:getCallResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        MX_WB_Mock mock = new MX_WB_Mock(code,status, body,new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);
        oppRec.StageName = 'Closed Won';
        update oppRec;
        Test.startTest();
            String manana = String.valueOf(system.today()+1);
            String ayer = String.valueOf(system.today()-1);
            string servicio = 'SELECT Id FROM Lead WHERE MX_WB_EnvioCTI__c < '+manana+' AND MX_WB_EnvioCTI__c > '+ayer;
            MX_WB_callBatch_bch objExecuteBatch = new MX_WB_callBatch_bch(String.escapeSingleQuotes(servicio));
        	Id batchInstanceId = Database.executeBatch(objExecuteBatch, 200);
        	System.assert(String.isNotBlank(batchInstanceId));
        Test.stopTest();

    }*/
}
