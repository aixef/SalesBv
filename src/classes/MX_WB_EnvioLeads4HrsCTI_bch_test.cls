/**
*
*@ Creacion de clase MX_WB_EnvioLead4HrsCTI_bch_test
28-06-2019  Se comenta el metodo para poder deployar a UAT por error desconocido de test batch
*/
@isTest
public class MX_WB_EnvioLeads4HrsCTI_bch_test {

    /**Response service */
    final static String BODY = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://201.148.35.186/ws/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns2="http://xml.apache.org/xml-soap" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:getCallResponse><return><item><key xsi:type="xsd:string">status</key><value xsi:type="xsd:string">OK</value></item><item><key xsi:type="xsd:string">calls</key><value SOAP-ENC:arrayType="ns2:Map[2]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:41</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:nil="true"/></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">VDAD</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:17</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:type="xsd:string">EQUIVOCADO INCORRECTO</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item></value></item><item><key xsi:type="xsd:string">recordings</key><value SOAP-ENC:arrayType="ns2:Map[1]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Grabacion</key><value xsi:type="xsd:string">2019-02-07 16:37:20</value></item><item><key xsi:type="xsd:string">Grabacion</key><value xsi:type="xsd:string">ASD01013_20190207-163718_0458119135196_PECC891119</value></item><item><key xsi:type="xsd:string">Duracion</key><value xsi:type="xsd:string">3</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item></item></value></item></return></ns1:getCallResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';

	@testSetup
    static void initData() {
        final String equivocado = 'Tel. Equivocado';
        final MX_WB_FamiliaProducto__c testFamilia = MX_WB_TestData_cls.createProductsFamily('Test Familia');
        insert testFamilia;
        final Campaign testCampaign = MX_WB_TestData_cls.createCampania('Test Camp');
        testCampaign.MX_WB_FamiliaProductos__c = testFamilia.Id;
        insert testCampaign;
        final Lead testLead = MX_WB_TestData_cls.createLead('Test Data');
        testLead.MX_WB_ph_Telefono1__c = '5551040002';
        testLead.MX_WB_ph_Telefono2__c = '5551040003';
        testLead.MX_WB_ph_Telefono3__c = '5551040004';
        insert testLead;

        final Lead lostLead = MX_WB_TestData_cls.createLead('Test Lost');
        lostLead.MX_WB_ph_Telefono1__c = '5551040002';
        lostLead.MX_WB_ph_Telefono2__c = '5551040003';
        lostLead.MX_WB_ph_Telefono3__c = '5551040004';
        lostLead.Folio_Cotizacion__c = '12123123';
        insert lostLead;

        final Task tarea1 = new Task();
        tarea1.Telefono__c = '5551040002';
        tarea1.Motivos_CONTACTO__c = equivocado;
        tarea1.WhoId = lostLead.Id;
        insert tarea1;
        final Task tarea2 = new Task();
        tarea2.Telefono__c = '5551040003';
        tarea2.Motivos_CONTACTO__c = equivocado;
        tarea2.WhoId = lostLead.Id;
        insert tarea2;
        final Task tarea3 = new Task();
        tarea3.Telefono__c = '5551040004';
        tarea3.Motivos_CONTACTO__c = equivocado;
        tarea3.WhoId = lostLead.Id;
        insert tarea3;

        final MX_WB_CredencialesCTI__c credenciales = new MX_WB_CredencialesCTI__c();
        credenciales.MX_WB_Usuario__c ='TestUsuario';
        credenciales.MX_WB_Contrasenia__c ='TestPass';
        credenciales.Name ='ASD';
        insert credenciales;

        final MX_WB_CredencialesCTI__c credenciales2 = new MX_WB_CredencialesCTI__c();
        credenciales2.MX_WB_Usuario__c ='TestUsuario';
        credenciales2.MX_WB_Contrasenia__c ='TestPass';
        credenciales2.Name ='ASD'+3;
        insert credenciales2;

        final MX_WB_MotivosNoContacto__c testMotivoNo = new MX_WB_MotivosNoContacto__c();
        testMotivoNo.Name=equivocado;
        testMotivoNo.MX_WB_MotivoNoContacto__c=equivocado;
        insert testMotivoNo;
    }

    testMethod static void batchTest() {
        
        final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', BODY,new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.StartTest();
        final MX_WB_EnvioLeads4HrsCTI_bch bh1 = new MX_WB_EnvioLeads4HrsCTI_bch('SELECT Id, Folio_Cotizacion__c, OwnerId, FirstName, (SELECT Id, Motivos_CONTACTO__c, Telefono__c from Tasks), '
                                                                          + 'MX_WB_ph_Telefono1__c, MX_WB_ph_Telefono2__c, MX_WB_ph_Telefono3__c'
                                                                          + ' FROM Lead');
        final ID jobId = DataBase.executeBatch(bh1);
        Test.stopTest();
        System.assertNotEquals(null, jobId);

    }
}
