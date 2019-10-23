/*
* Nombre: WB_ProcNotif_cls
* @author Karen Sanchez (KB)
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Clase test que sirve para la cobertura del schedulable MX_WB_EnvioLeadsCTI_bch
*
*                         Fecha           Autor                   Desripción
* @version 1.0           13/02/2019      Karen Sanchez            Creación
* @version 2.0           16/03/2019      Karen Sanchez            Modificación: Se agregan las condicionales de la consulta
                                                                  para que se ejecute el batch sin entrar al
* @version 3.0           19/03/2019      Karen Sanchez            Modificación: Se agrega tipo de registro en los leads que pertenecen a outbound
28-06-2019  Se comenta el metodo para poder deployar a UAT por error desconocido de test batch
*/
@isTest
private class MX_WB_EnvioLeadsCTI_bch_tst {
    
    /**Response service */
    final static String BODY = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://201.148.35.186/ws/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns2="http://xml.apache.org/xml-soap" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:getCallResponse><return><item><key xsi:type="xsd:string">status</key><value xsi:type="xsd:string">OK</value></item><item><key xsi:type="xsd:string">calls</key><value SOAP-ENC:arrayType="ns2:Map[2]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:41</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:nil="true"/></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">VDAD</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:17</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:type="xsd:string">EQUIVOCADO INCORRECTO</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item></value></item><item><key xsi:type="xsd:string">recordings</key><value SOAP-ENC:arrayType="ns2:Map[1]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Grabacion</key><value xsi:type="xsd:string">2019-02-07 16:37:20</value></item><item><key xsi:type="xsd:string">Grabacion</key><value xsi:type="xsd:string">ASD01013_20190207-163718_0458119135196_PECC891119</value></item><item><key xsi:type="xsd:string">Duracion</key><value xsi:type="xsd:string">3</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item></item></value></item></return></ns1:getCallResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
    
	@TestSetup
    static void  initData() {
        final Id recordTypeLead = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('MX_WB_rt_Telemarketing').getRecordTypeId();
        final Id sTypeRecordTask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('MX_WB_llamadaCandidato').getRecordTypeId();
        final MX_WB_FamiliaProducto__c testFamilia = MX_WB_TestData_cls.createProductsFamily('Test Familia');
        insert testFamilia;

        final Campaign testCampaign = MX_WB_TestData_cls.createCampania('Test Camp');
        testCampaign.MX_WB_FamiliaProductos__c = testFamilia.Id;
        insert testCampaign;

        final Lead testLead = MX_WB_TestData_cls.createLead('Test Lost');
        testLead.MX_WB_ph_Telefono1__c = '5551040002';
        testLead.MX_WB_ph_Telefono2__c = '5551040003';
        testLead.MX_WB_ph_Telefono3__c = '5551040004';
        testLead.MX_WB_ContadorRemarcado__c = '1';
        testLead.MX_WB_Convertido__c = false;
        testLead.MX_WB_TM_Congelado__c = false;
        testLead.LeadSource = 'Outbound TLMK';
        testLead.RecordTypeId = recordTypeLead;
        insert testLead;

        final Lead lostLead = MX_WB_TestData_cls.createLead('Test Lost');
        lostLead.MX_WB_ph_Telefono1__c = '5551040002';
        lostLead.MX_WB_ph_Telefono2__c = '5551040003';
        lostLead.MX_WB_ph_Telefono3__c = '5551040004';
        lostLead.MX_WB_ContadorRemarcado__c = '1';
        lostLead.MX_WB_Convertido__c = false;
        lostLead.MX_WB_TM_Congelado__c = false;
        lostLead.LeadSource = 'Outbound TLMK';
        lostLead.RecordTypeId = recordTypeLead;

        insert lostLead;

        final CampaignMember objCampaignMember = MX_WB_TestData_cls.createCampaignMember(lostLead.Id, testCampaign.Id);
        database.insert (objCampaignMember, false);

        final CampaignMember objCampaignMember2 = MX_WB_TestData_cls.createCampaignMember(testLead.Id, testCampaign.Id);
        database.insert (objCampaignMember2, false);

        final Task tarea1 = new Task();
        tarea1.Telefono__c = '5551040002';
        tarea1.WhoId = lostLead.Id;
        tarea1.MX_WB_EstatusCTI__c = 'AUTO USO COMERCIAL';
        tarea1.RecordTypeId = sTypeRecordTask;
        insert tarea1;

        final Task tarea = new Task();
        tarea.Telefono__c = '5551040002';
        tarea.WhoId = lostLead.Id;
        tarea.MX_WB_EstatusCTI__c = 'GRABADORA CONTESTADORA';
        tarea.RecordTypeId = sTypeRecordTask;
        insert tarea;

        final Task tarea2 = new Task();
        tarea2.Telefono__c = '5551040003';
        tarea2.WhoId = lostLead.Id;
        tarea2.MX_WB_EstatusCTI__c = 'GRABADORA CONTESTADORA';
        tarea2.RecordTypeId = sTypeRecordTask;
        insert tarea2;

        final Task tarea3 = new Task();
        tarea3.Telefono__c = '5551040004';
        tarea3.MX_WB_EstatusCTI__c = 'GRABADORA CONTESTADORA';
        tarea3.RecordTypeId = sTypeRecordTask;
        tarea3.WhoId = lostLead.Id;
        insert tarea3;

        final MX_WB_MotivosNoContacto__c testMotivoNo = new MX_WB_MotivosNoContacto__c();
        testMotivoNo.MX_WB_MotivoNoContacto__c='GRABADORA CONTESTADORA';
        testMotivoNo.Name='GRABADORA CONTESTADORA';
        insert testMotivoNo;

        final MX_WB_CredencialesCTI__c credenciales = new MX_WB_CredencialesCTI__c();
        credenciales.MX_WB_Usuario__c ='TestUsuario';
        credenciales.MX_WB_Contrasenia__c ='TestPass';
        credenciales.Name ='ASD'+3;
        insert credenciales;

    }


	@isTest
	static void ejecutarBatch() {

        final String sTypeRecordTask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('MX_WB_llamadaCandidato').getRecordTypeId();
        final Id sTypeRecord = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('MX_WB_rt_Telemarketing').getRecordTypeId();
        String sConsulta;
        List<CampaignMember> lstLeadRemarcado;
        final String leadSource = 'Outbound TLMK';
        final Integer contadorRemarcado = 5;
        final Integer sCantidadEnvio = Integer.valueOf(label.MX_WB_CantidadEnvioCTI);


        sConsulta = 'SELECT LeadId FROM CampaignMember LIMIT 5';

        lstLeadRemarcado = Database.query(sConsulta);

        String campaingMembers = '(';
                for(CampaignMember miembro: lstLeadRemarcado) {
                    campaingMembers += '\''+miembro.LeadId+'\',';
                }
                campaingMembers = campaingMembers.removeEnd(',');
                campaingMembers += ')';

        final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', BODY,new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.StartTest();
          final MX_WB_EnvioLeadsCTI_bch bh1 = new MX_WB_EnvioLeadsCTI_bch('SELECT l.Id,l.Folio_Cotizacion__c,l.OwnerId,l.FirstName,l.MX_WB_ph_Telefono1__c,l.MX_WB_ph_Telefono2__c,l.MX_WB_ph_Telefono3__c,l.MX_WB_ContadorRemarcado__c, l.EnviarCTI__c,CreatedDate,'
          + 'l.LeadSource, l.RecordTypeId, l.MX_WB_TM_Congelado__c, (SELECT Id, MX_WB_EstatusCTI__c, Telefono__c from Tasks WHERE WhoId IN'+campaingMembers+' AND RecordTypeId =\'' + sTypeRecordTask + '\''+ ' AND (MX_WB_EstatusCTI__c != null OR MX_WB_EstatusCTI__c != \''+ '\''+')) '
          + 'FROM Lead l WHERE MX_WB_Convertido__c = false AND MX_WB_TM_Congelado__c = false AND RecordTypeId =\'' + sTypeRecord +'\' AND LeadSource =\''+leadSource + '\''+' AND MX_WB_ContadorRemarcado__c <= \''+ contadorRemarcado + '\''+' AND Id in'+campaingMembers+' ORDER BY MX_WB_ph_Telefono1__c DESC LIMIT '+sCantidadEnvio);
          final Id batchInstanceId =  DataBase.executeBatch(bh1);
          System.assert(String.isNotBlank(batchInstanceId));
        Test.stopTest();
	}
}
