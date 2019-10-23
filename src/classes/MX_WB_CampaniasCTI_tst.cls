/**-------------------------------------------------------------------------
* Nombre: WB_ProcNotif_cls
* @author Karen Sanchez (KB)
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Clase test que sirve para la cobertura de la clase MX_WB_CTI_cls

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           14/01/2019      Karen Sanchez            Creación
* @version 1.1           02/05/2019       ARsenio Perez         Modificacion por cambio de modelo de datos.
* @version 1.2           19/06/2019      Vincent Juárez           Corrección de métodos
* --------------------------------------------------------------------------*/
@isTest
public class MX_WB_CampaniasCTI_tst { 

    /**Numero prueba 1 */
    final static String PHONENUMBER = '5555555555';
    /**Numero pruebas 2 */
    final static String PHONENUMBER1 = '5512345678';
    /**Numero tel3 */
    final static String PHONENUMBER2 = '5512345555';
    /**Numero phone 4 */
    final static String PHONENUMBER3 = '5512345680';
    /**Objecto Sobject */
    final static String LEADSOBJECT = 'Lead';
    /**Origen Telemarketing */
    final static String OUTBOUNDTLMK = 'Outbound TLMK';
    /**Origen nombre campaña */
    final static String CAMPAIGN = 'CampaignTLKM';
    /**Producto Credenciales */
    final static String ASDPRODUCT = 'ASD';
    /**Nombre proveedor */
    final static String VCIPROVE = 'VCIP';
    /**Telefono XML */
    final static String PHONEXML = '5888512345678';
    /** valor false para pruebas */
    final static String FALSEVAL = 'false';
    /** valor VERDADERO para pruebas */
    final static String TRUEVAL = 'true';
    
    

    @TestSetup
    static void  sendCTI() {

        final MX_SB_VTS_Generica__c temp_Generica = MX_WB_TestData_cls.GeneraGenerica('Prueba','CP2');
        temp_Generica.MX_SB_VTS_FiltroCampanaLabel__c ='Segmento Bancario';
        temp_Generica.MX_SB_VTS_FiltroCampana__c='MX_SB_VTS_Segmento_Bancario__c';
        insert temp_Generica;

        final MX_SB_VTS_Generica__c temp_GenericaLim = MX_WB_TestData_cls.GeneraGenerica('Prueba2','CP2');
        temp_GenericaLim.MX_SB_VTS_FiltroCampanaLabel__c ='limite';
        temp_GenericaLim.MX_SB_VTS_FiltroCampana__c='limite__c';
        insert temp_GenericaLim;

        final MX_WB_CredencialesCTI__c credenciales = new MX_WB_CredencialesCTI__c();
        credenciales.MX_WB_Usuario__c ='TestUsuario2';
        credenciales.MX_WB_Contrasenia__c ='TestPass2';
        credenciales.Name =ASDPRODUCT;
        insert credenciales;

        final MX_WB_CredencialesCTI__c credenciales2 = new MX_WB_CredencialesCTI__c();
        credenciales2.MX_WB_Usuario__c ='TestUsuario3';
        credenciales2.MX_WB_Contrasenia__c ='TestPass3';
        credenciales2.Name =ASDPRODUCT+0;
        insert credenciales2;

        final MX_WB_CredencialesCTI__c credenciales3 = new MX_WB_CredencialesCTI__c();
        credenciales3.MX_WB_Usuario__c ='TestUsuario4';
        credenciales3.MX_WB_Contrasenia__c ='TestPass4';
        credenciales3.Name =ASDPRODUCT+3;
        insert credenciales3;

        final MX_WB_camposFiltrados__c campoFiltrado = new MX_WB_camposFiltrados__c();
        campoFiltrado.Name = 'Limite';
        campoFiltrado.Limite__c = '';
        campoFiltrado.MX_WB_ph_Telefono1__c = '';
        insert campoFiltrado;
        
        final MX_WB_FamiliaProducto__c testfamilia =  MX_WB_TestData_cls.createProductsFamily('Test Familia');
        insert testFamilia;
        final MX_SB_VTS_ProveedoresCTI__c ProvedorCTI = MX_WB_TestData_cls.ProvedorCTI(VCIPROVE);
        ProvedorCTI.MX_SB_VTS_Identificador_Proveedor__c=VCIPROVE;
        Insert ProvedorCTI;
        final MX_SB_VTS_FamliaProveedores__c familiaProvedor = MX_WB_TestData_cls.FamiliaProvedores(testFamilia.Id, ProvedorCTI.Id);
        Insert familiaProvedor;
        final Campaign objCampaign = MX_WB_TestData_cls.createCampania(CAMPAIGN);
        objCampaign.MX_SB_VTS_FamiliaProducto_Proveedor__c=familiaProvedor.id;
        insert objCampaign;

        final Lead objLeads = MX_WB_TestData_cls.createLead('Sanchez1');
        objLeads.MX_WB_TM_Congelado__c = false;
        objLeads.MX_WB_Convertido__c = false;
        objLeads.FirstName = 'Karen1';
        objLeads.LeadSource = OUTBOUNDTLMK;
        insert objLeads;

        final CampaignMember objCampaignMember = MX_WB_TestData_cls.createCampaignMember(objLeads.Id, objCampaign.Id);
        database.insert (objCampaignMember, false);
    }

    @isTest static void busquedaCampaign() {
        final String nombre = CAMPAIGN;
        final String sQuery = 'SELECT id, Name FROM Campaign WHERE Name =\''+nombre+'\'';
        final List<Campaign> lstCampanias = Database.query(sQuery);
        final User usuarios = MX_WB_TestData_cls.crearUsuario('Usuarioadmin2', Label.MX_SB_VTS_ProfileAdmin);
        usuarios.MX_SB_VTS_ProveedorCTI__c = VCIPROVE;
        insert usuarios;
        system.runAs(usuarios) {
            Test.startTest();
            if(lstCampanias.size() > 0) {
                final List < CampaignMember > miembrosCampanias = MX_WB_CampaniasCTI_cls.lstCampaignMember(lstCampanias[0].Id, '');
                System.assertNotEquals(miembrosCampanias.isEmpty(),true,'No se encontraron registros');
            }
            Test.stopTest();
        }
    }

    @isTest static void busquedafetchLookUpValues() {
        final String nombre = CAMPAIGN;
        final String sQuery = 'SELECT id, Name FROM Campaign WHERE Name =\''+nombre+'\'';
        final List<Campaign> lstCampanias = Database.query(sQuery);
        final User usuarios= MX_WB_TestData_cls.crearUsuario('Usuarioadmin', Label.MX_SB_VTS_ProfileAdmin);
        usuarios.MX_SB_VTS_ProveedorCTI__c=VCIPROVE;
        insert usuarios;
        system.runAs(usuarios) {
            Test.startTest();
            if(lstCampanias.size() > 0) {
                final List < Campaign > miembrosCampanias = MX_WB_CampaniasCTI_cls.fetchLookUpValues(lstCampanias[0].Name, '');
                System.assertNotEquals(miembrosCampanias.isEmpty(),true,'No se encontraron registros');
            }
            Test.stopTest();
        }
    }

    @isTest static void busquedaCampaignNull() {
        Boolean hayError = false;
        final String nombre = 'Llevanulo';
        final String sQuery = 'SELECT Name FROM Campaign WHERE Name =\''+nombre+'\'';
        final List<Campaign> lstCampanias = Database.query(sQuery);
        System.debug('lstCampanias:'+lstCampanias);
       try {
        Test.startTest();
        final List < CampaignMember > miembrosCampanias = MX_WB_CampaniasCTI_cls.lstCampaignMember('teast', '');
        System.assertNotEquals(miembrosCampanias, null, 'No se encontraron registros');
        Test.stopTest();
        } catch(System.AuraHandledException ex) {
            hayError = true;
            System.assert(hayError, 'Error');
            ex.setMessage(Label.MX_WB_ERROR);
            System.assertEquals(Label.MX_WB_ERROR, ex.getMessage(), 'Error esperado');
        }
    }

    @isTest 
    static void enviarCTI() {
        final String body = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://201.148.35.186/ws/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns2="http://xml.apache.org/xml-soap" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:getCallResponse><return><item><key xsi:type="xsd:string">status</key><value xsi:type="xsd:string">OK</value></item><item><key xsi:type="xsd:string">calls</key><value SOAP-ENC:arrayType="ns2:Map[2]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:41</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:nil="true"/></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">VDAD</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:17</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:type="xsd:string">EQUIVOCADO INCORRECTO</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item></value></item><item><key xsi:type="xsd:string">recordings</key><value SOAP-ENC:arrayType="ns2:Map[1]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Grabacion</key><value xsi:type="xsd:string">2019-02-07 16:37:20</value></item><item><key xsi:type="xsd:string">Grabacion</key><value xsi:type="xsd:string">ASD01013_20190207-163718_0458119135196_PECC891119</value></item><item><key xsi:type="xsd:string">Duracion</key><value xsi:type="xsd:string">3</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item></item></value></item></return></ns1:getCallResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        final Date fechaEnvio = Date.today();

        final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', body,new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);
        final User testUser = MX_WB_TestData_cls.crearUsuario('TestLastName',  Label.MX_SB_VTS_ProfileAdmin);
        insert testUser;
        final Campaign objCampaign = MX_WB_TestData_cls.createCampania('Campania Test5000');
        objCampaign.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('MX_WB_Cam_RTG_Tlmktg').getRecordTypeId();
        insert objCampaign;
        final Lead objLeads = MX_WB_TestData_cls.createLead('Sanchez');
        objLeads.MX_WB_TM_Congelado__c = false;
        objLeads.MX_WB_Convertido__c = false;
        objLeads.FirstName = 'Karen';
        objLeads.MX_WB_ph_Telefono1__c = PHONENUMBER1;
        objLeads.MX_WB_ph_Telefono2__c = PHONENUMBER2;
        objLeads.MX_WB_ph_Telefono3__c = PHONENUMBER3;
        objLeads.LeadSource = OUTBOUNDTLMK;
        insert objLeads;
        final CampaignMember objCampaignMember = MX_WB_TestData_cls.createCampaignMember(objLeads.Id, objCampaign.Id);
        database.insert (objCampaignMember, false);
        String sQuery = 'SELECT LeadId, Lead.MX_WB_EnvioCTI__c,Lead.FirstName, Lead.MX_WB_ph_Telefono1__c, Lead.MX_WB_ph_Telefono2__c, Lead.MX_WB_ph_Telefono3__c, Lead.Folio_Cotizacion__c, Lead.Producto_Interes__c,Lead.OwnerId, Lead.EnviarCTI__c, lead.MX_WB_TM_Congelado__c ';
               sQuery += 'From CampaignMember WHERE Campaign.Name = \''+objCampaign.Name +'\''+' AND LeadId =\''+objLeads.Id +'\''+'AND Lead.MX_WB_Convertido__c = false AND Lead.MX_WB_TM_Congelado__c = false AND LeadId != null AND Lead.FirstName != null AND CAMPAIGN.IsActive = true ';
        final List<SObject> listObject = Database.query(sQuery);
        MX_WB_CampaniasCTI_cls.lstLeadEnviarCTIe(listObject);
        test.startTest();
        final String sXMl = MX_WB_CTI_cls.generarXML(objLeads.MX_WB_ph_Telefono1__c,objLeads.LastName,ASDPRODUCT, objLeads.Id, testUser.Id,'',0,objLeads.MX_WB_ph_Telefono2__c,objLeads.MX_WB_ph_Telefono3__c);
        MX_WB_CTI_cls.reqSolicitud(sXMl, objLeads.Id,LEADSOBJECT);
        MX_WB_CTI_cls.ftProcesaSol(String.valueOf(objLeads.Id), '', ASDPRODUCT, testUser.Id, 'Prueba', PHONEXML, LEADSOBJECT, 0,PHONENUMBER,PHONENUMBER);
        objLeads.MX_WB_EnvioCTI__c = fechaEnvio;
        objLeads.MX_WB_TM_Congelado__c = true;
        objLeads.EnviarCTI__c = true;
        update objLeads;
        System.assert(objLeads.EnviarCTI__c, 'Se envio correctamente el registro');
        test.stopTest();
    }

    @isTest static void enviarCTICongelado() {
        final String body = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://201.148.35.186/ws/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns2="http://xml.apache.org/xml-soap" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:getCallResponse><return><item><key xsi:type="xsd:string">status</key><value xsi:type="xsd:string">OK</value></item><item><key xsi:type="xsd:string">calls</key><value SOAP-ENC:arrayType="ns2:Map[2]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:41</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:nil="true"/></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">VDAD</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:17</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:type="xsd:string">EQUIVOCADO INCORRECTO</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item></value></item><item><key xsi:type="xsd:string">recordings</key><value SOAP-ENC:arrayType="ns2:Map[1]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Grabacion</key><value xsi:type="xsd:string">2019-02-07 16:37:20</value></item><item><key xsi:type="xsd:string">Grabacion</key><value xsi:type="xsd:string">ASD01013_20190207-163718_0458119135196_PECC891119</value></item><item><key xsi:type="xsd:string">Duracion</key><value xsi:type="xsd:string">3</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item></item></value></item></return></ns1:getCallResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        final Date fechaEnvio = Date.today();
        final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', body,new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);
        final User testUser = MX_WB_TestData_cls.crearUsuario('TestLastName',  Label.MX_SB_VTS_ProfileAdmin);
        insert testUser;
        final Campaign objCampaign = MX_WB_TestData_cls.createCampania('Campania Preuba500');
        objCampaign.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('MX_WB_Cam_RTG_Tlmktg').getRecordTypeId();
        insert objCampaign;
        final Lead objLeads = MX_WB_TestData_cls.createLead('Sanchez2');
        objLeads.MX_WB_TM_Congelado__c = false;
        objLeads.MX_WB_Convertido__c = false;
        objLeads.FirstName = 'Karen';
        objLeads.MX_WB_ph_Telefono1__c = PHONENUMBER1;
        objLeads.MX_WB_ph_Telefono2__c = PHONENUMBER2;
        objLeads.MX_WB_ph_Telefono3__c = PHONENUMBER3;
        objLeads.LeadSource = OUTBOUNDTLMK;
        insert objLeads;
        final CampaignMember objCampaignMember = MX_WB_TestData_cls.createCampaignMember(objLeads.Id, objCampaign.Id);
        database.insert (objCampaignMember, false);
        String sQuery = 'SELECT LeadId, Lead.MX_WB_EnvioCTI__c,Lead.FirstName, Lead.MX_WB_ph_Telefono1__c, Lead.MX_WB_ph_Telefono2__c, Lead.MX_WB_ph_Telefono3__c, Lead.Folio_Cotizacion__c, Lead.Producto_Interes__c,Lead.OwnerId, Lead.EnviarCTI__c, lead.MX_WB_TM_Congelado__c ';
               sQuery += 'From CampaignMember WHERE Campaign.Name = \''+objCampaign.Name +'\''+' AND LeadId =\''+objLeads.Id +'\''+'AND Lead.MX_WB_Convertido__c = false AND Lead.MX_WB_TM_Congelado__c = false AND LeadId != null AND Lead.FirstName != null AND CAMPAIGN.IsActive = true ';
        final List<SObject> listObject = Database.query(sQuery);
        MX_WB_CampaniasCTI_cls.lstLeadEnviarCTI(listObject, true, '', '');
        test.startTest();
        final String sXMl = MX_WB_CTI_cls.generarXML(objLeads.MX_WB_ph_Telefono1__c,objLeads.LastName,ASDPRODUCT, objLeads.Id, testUser.Id,'',0,objLeads.MX_WB_ph_Telefono2__c,objLeads.MX_WB_ph_Telefono3__c);
        MX_WB_CTI_cls.reqSolicitud(sXMl, objLeads.Id,LEADSOBJECT);
        MX_WB_CTI_cls.ftProcesaSol(String.valueOf(objLeads.id), '', ASDPRODUCT, testUser.Id, 'Prueba', PHONEXML, LEADSOBJECT, 0,PHONENUMBER,PHONENUMBER);
        objLeads.MX_WB_EnvioCTI__c = fechaEnvio;
        objLeads.MX_WB_TM_Congelado__c = true;
        objLeads.EnviarCTI__c = true;
        update objLeads;
        System.assert(objLeads.MX_WB_TM_Congelado__c,'Se bloqueo correctamente el registro');
        test.stopTest();
    }

    @isTest static void filtrarContiene() {
        Test.startTest();
            final String contiene  = MX_WB_CampaniasCTI_cls.getListFilter('Teléfono 1','CONTAINS',PHONENUMBER,FALSEVAL);
            System.assertEquals(false,String.isBlank(contiene), 'Filtro correctamente');
        Test.stopTest();
    }

    @isTest static void filtrarContiene_segmentado() {
        Test.startTest();
            final String contiene  = MX_WB_CampaniasCTI_cls.getListFilter('Segmento Bancario','CONTAINS',PHONENUMBER,TRUEVAL);
            System.assertEquals(false,String.isBlank(contiene), 'Filtro correctamente');
        Test.stopTest();
    }

    @isTest static void filtrarContieneError() {
        Boolean hayError = false;
        try {
        Test.startTest();
        final String contiene  = MX_WB_CampaniasCTI_cls.getListFilter('Teléfono','NOT(CONTAINS)','55555n55555',FALSEVAL);
        System.assertEquals(true, String.isBlank(contiene), 'No filtro');
        Test.stopTest();
        } catch(System.AuraHandledException ex) {
            hayError = true;
            System.assert(hayError, 'Error');
            ex.setMessage(Label.MX_WB_ERROR);
            System.assertEquals(Label.MX_WB_ERROR, ex.getMessage(), 'Error esperado');
        }
    }

    @isTest static void filtrarLimite() {
        Test.startTest();
            final String limite  = MX_WB_CampaniasCTI_cls.getListFilter('Limite','=','5',FALSEVAL);
            System.assertEquals(false,String.isBlank(limite), 'Filtro');
        Test.stopTest();
    }
    @isTest static void filtrarLimite_segmentado() {
        Test.startTest();
            final String limite  = MX_WB_CampaniasCTI_cls.getListFilter('Limite','=','5',TRUEVAL);
            System.assertEquals(false,String.isBlank(limite), 'Filtro');
        Test.stopTest();
    }

    @isTest static void filtrarLimiteError() {
        Boolean hayError = false;
        try {
            Test.startTest();
            final String limite  = MX_WB_CampaniasCTI_cls.getListFilter('Folio','=','5',FALSEVAL);
            System.assertEquals(true, String.isBlank(limite), 'Filtro');
            Test.stopTest();
         } catch(System.AuraHandledException ex) {
            hayError = true;
            System.assert(hayError, 'Error al filtrar');
            ex.setMessage(Label.MX_WB_ERROR);
            System.assertEquals(Label.MX_WB_ERROR, ex.getMessage(), 'Error esperado');
        }
    }

    @isTest static void getListSetting() {
        Test.startTest();
        final String getCustom = String.valueOf(MX_WB_CampaniasCTI_cls.getListSettings(FALSEVAL));
        System.assert(String.isNotBlank(getCustom),'No esta vacio');
        Test.stopTest();
    }
     @isTest static void getListSetting_segmentado() {
        Test.startTest();
        final String getCustom = String.valueOf(MX_WB_CampaniasCTI_cls.getListSettings(TRUEVAL));
        System.assert(String.isNotBlank(getCustom),'No esta vacio');
        Test.stopTest();
    }
}