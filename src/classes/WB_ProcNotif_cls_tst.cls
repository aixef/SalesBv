/**-------------------------------------------------------------------------
* Nombre: WB_ProcNotif_cls
* @author Karen Sanchez (KB)
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Clase test que sirve para la cobertura de la clase WB_ProcNotif_cls

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 2.0           28/01/2019      Karen Sanchez            Creación
* @version 3.0			 22/03/2019      Francisco Javier         Cupones
* --------------------------------------------------------------------------*/
@isTest
private class WB_ProcNotif_cls_tst {
    
    @TestSetup
    static void insertarOpps() {
        final MX_WB_CredencialesCTI__c credenciales = new MX_WB_CredencialesCTI__c();
        credenciales.MX_WB_Usuario__c ='tesasdcup';
        credenciales.MX_WB_Contrasenia__c ='_1nBorPPfQKd';
        credenciales.Name ='Seguro de Auto1';
        insert credenciales;
        
        final Id IdAgente = UserInfo.getUserId();
        
        final Account accRec = MX_WB_TestData_cls.crearCuenta('LastName', 'PersonAccount');
        accRec.Phone = '5512345678'; 
        insert accRec;
        
        final Opportunity opp = MX_WB_TestData_cls.crearOportunidad('LastName', accRec.Id, IdAgente, 'ASD');
        opp.Producto__c = 'Seguro de Auto';
        insert opp;
    } 
	
	@isTest static void activarScheduleProceso() {
		final ProcNotiOppNoAten__c objProNotOppNoAten = MX_WB_TestData_cls.createProcNotiOppNoAten(null, '30', 'Matutino', false);
		insert objProNotOppNoAten;
		final Campaign objCampaign = MX_WB_TestData_cls.createCampania('Campania Preuba500');		
		insert objCampaign;
		final Lead objLeads = MX_WB_TestData_cls.createLead('Sanchez');
		objLeads.LeadSource = System.Label.MX_WB_leadSource;
		insert objLeads;
		final CampaignMember objCampaignMember = MX_WB_TestData_cls.createCampaignMember(objLeads.Id, objCampaign.Id);
		database.insert (objCampaignMember, false);		
        final String body = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://201.148.35.186/ws/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns2="http://xml.apache.org/xml-soap" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:getCallResponse><return><item><key xsi:type="xsd:string">status</key><value xsi:type="xsd:string">OK</value></item><item><key xsi:type="xsd:string">calls</key><value SOAP-ENC:arrayType="ns2:Map[2]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:41</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:nil="true"/></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">VDAD</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:17</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:type="xsd:string">EQUIVOCADO INCORRECTO</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item></value></item><item><key xsi:type="xsd:string">recordings</key><value SOAP-ENC:arrayType="ns2:Map[1]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Grabacion</key><value xsi:type="xsd:string">2019-02-07 16:37:20</value></item><item><key xsi:type="xsd:string">Grabacion</key><value xsi:type="xsd:string">ASD01013_20190207-163718_0458119135196_PECC891119</value></item><item><key xsi:type="xsd:string">Duracion</key><value xsi:type="xsd:string">3</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item></item></value></item></return></ns1:getCallResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';       
        final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', body,new Map<String,String>()); 
        Test.setMock(HttpCalloutMock.class, mock);

		Test.startTest();
			objProNotOppNoAten.Activo__c = true;
			update objProNotOppNoAten;	
			System.assertEquals(objProNotOppNoAten.Activo__c, true, 'Se hizo el cambio correctamente');
		Test.stopTest();

	}

	@isTest static void activarScheduleSinProceso() {
		final ProcNotiOppNoAten__c objProNotOppNoAtenSinProceso = MX_WB_TestData_cls.createProcNotiOppNoAten('Outbound', '30', 'Matutino', false);
		insert objProNotOppNoAtenSinProceso;
		final Campaign objCampaign = MX_WB_TestData_cls.createCampania('Campania Preuba500');		
		insert objCampaign;
		final Lead objLeads = MX_WB_TestData_cls.createLead('Sanchez');
		objLeads.LeadSource = System.Label.MX_WB_leadSource;
		insert objLeads;
		final CampaignMember objCampaignMember = MX_WB_TestData_cls.createCampaignMember(objLeads.Id, objCampaign.Id);
		database.insert (objCampaignMember, false);

		Test.startTest();
			objProNotOppNoAtenSinProceso.Activo__c = true;
			update objProNotOppNoAtenSinProceso;
			System.assertEquals(objProNotOppNoAtenSinProceso.Activo__c, true, 'Se hizo el cambio correctamente');
		Test.stopTest();	
	}	

	@isTest static void activarScheduleProcesoDiferente() {
		final ProcNotiOppNoAten__c objProcesoDiferente = MX_WB_TestData_cls.createProcNotiOppNoAten('algo', '30', 'Matutino', false);
		insert objProcesoDiferente;
		final Campaign objCampaign = MX_WB_TestData_cls.createCampania('Campania Preuba500');		
		insert objCampaign;
		final Lead objLeads = MX_WB_TestData_cls.createLead('Sanchez');
		objLeads.LeadSource = System.Label.MX_WB_leadSource;
		insert objLeads;
		final CampaignMember objCampaignMember = MX_WB_TestData_cls.createCampaignMember(objLeads.Id, objCampaign.Id);
		database.insert (objCampaignMember, false);

		Test.startTest();
			objProcesoDiferente.Activo__c = true;
			update objProcesoDiferente;
			System.assertEquals(objProcesoDiferente.Activo__c, true, 'Se hizo el cambio correctamente');
		Test.stopTest();	
	}
	
	@isTest static void activarScheduleCupon() {
		final ProcNotiOppNoAten__c objProNotOppNoAtenSinProceso = MX_WB_TestData_cls.createProcNotiOppNoAten('Cupon', '0', 'testing', false);
		insert objProNotOppNoAtenSinProceso;
		final Lead objLeads = MX_WB_TestData_cls.createLead('Sanchez');
		objLeads.LeadSource = System.Label.MX_WB_leadSource;
		insert objLeads;

		Test.startTest();
			objProNotOppNoAtenSinProceso.Activo__c = true;
			update objProNotOppNoAtenSinProceso;
			System.assertEquals(objProNotOppNoAtenSinProceso.Activo__c, true, 'Se hizo el cambio correctamente');
		Test.stopTest();	
	}
}