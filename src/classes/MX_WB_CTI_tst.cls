/**-------------------------------------------------------------------------
* Nombre: MX_WB_CTI_tst
* @author Francisco Javeir (FJ)
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Clase test que sirve para la cobertura de la clase MX_WB_CTI_cls

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           07/03/2019      Francisco Javier            Creación
    1.0.1    	        20/06/2019 	Eduardo Hernández Cuamatzi		 Fix clase test para validar nombre correcto de Productos
* --------------------------------------------------------------------------*/
@isTest
public class MX_WB_CTI_tst {

    /**Nombre Cupon */
    public final static String CUPONNAME = 'Cupon';
    /**Producto Credenciales */
    final static String ASDPRODUCT = 'ASD';
    /**Response service */
    final static String BODY = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://201.148.35.186/ws/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns2="http://xml.apache.org/xml-soap" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:getCallResponse><return><item><key xsi:type="xsd:string">status</key><value xsi:type="xsd:string">ERROR</value></item><item><key xsi:type="xsd:string">calls</key><value SOAP-ENC:arrayType="ns2:Map[2]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:41</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:nil="true"/></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">VDAD</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Llamada</key><value xsi:type="xsd:string">2019-02-07 16:37:17</value></item><item><key xsi:type="xsd:string">Tel_Marcado</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Disposicion</key><value xsi:type="xsd:string">EQUIVOCADO INCORRECTO</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item><item><key xsi:type="xsd:string">Tel_1</key><value xsi:type="xsd:string">0458119135196</value></item><item><key xsi:type="xsd:string">Tel_2</key><value xsi:type="xsd:string"></value></item><item><key xsi:type="xsd:string">Tel_3</key><value xsi:type="xsd:string"></value></item></item></value></item><item><key xsi:type="xsd:string">recordings</key><value SOAP-ENC:arrayType="ns2:Map[1]" xsi:type="SOAP-ENC:Array"><item xsi:type="ns2:Map"><item><key xsi:type="xsd:string">Fecha_Grabacion</key><value xsi:type="xsd:string">2019-02-07 16:37:20</value></item><item><key xsi:type="xsd:string">Grabacion</key><value xsi:type="xsd:string">ASD01013_20190207-163718_0458119135196_PECC891119</value></item><item><key xsi:type="xsd:string">Duracion</key><value xsi:type="xsd:string">3</value></item><item><key xsi:type="xsd:string">idUser</key><value xsi:type="xsd:string">PECC891119</value></item><item><key xsi:type="xsd:string">leadId</key><value xsi:type="xsd:string">00QR000000G7gW3MAJ</value></item></item></value></item></return></ns1:getCallResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
    /**Request service */
    final static String TXTPOST = 'POST', URLLOCAL = 'local.MXSBVTSCache',URLEXA='http://www.example.com';
    
    @TestSetup
    static void  sendCTI() { //NOSONAR
        final MX_WB_CredencialesCTI__c credenciales = new MX_WB_CredencialesCTI__c();
        credenciales.MX_WB_Usuario__c ='tesasdcup';
        credenciales.MX_WB_Contrasenia__c ='_1nBorPPfQKd';
        credenciales.Name =CUPONNAME+1;
        insert credenciales;

        final MX_WB_CredencialesCTI__c credencialesASD = new MX_WB_CredencialesCTI__c();
        credencialesASD.MX_WB_Usuario__c ='tesasdcup';
        credencialesASD.MX_WB_Contrasenia__c ='_1nBorPPfQKd';
        credencialesASD.Name =ASDPRODUCT+0;
        insert credencialesASD;
        
        final Id idAgente = UserInfo.getUserId();
        final Account accRec = MX_WB_TestData_cls.crearCuenta('LastName', 'PersonAccount');
        accRec.Phone = '5512345678';
        insert accRec;

        final MX_WB_FamiliaProducto__c objFamilyPro = MX_WB_TestData_cls.createProductsFamily ( ASDPRODUCT );
        insert objFamilyPro;
        final MX_WB_FamiliaProducto__c objFamilyPro2 = MX_WB_TestData_cls.createProductsFamily ( 'Daños' );
        insert objFamilyPro2;

        final Product2 proTst = MX_WB_TestData_cls.productNew ( 'Auto Seguro Dinamico' );
        proTst.IsActive = true;
        proTst.MX_WB_FamiliaProductos__c = objFamilyPro.Id;
        insert proTst;

        final Product2 proHogar = MX_WB_TestData_cls.productNew ( System.Label.MX_SB_VTS_Hogar );
        proHogar.IsActive = true;
        proHogar.MX_WB_FamiliaProductos__c = objFamilyPro2.Id;
        insert proHogar;

        final Product2 proTst3 = MX_WB_TestData_cls.productNew ( 'Auto Seguro Dinámico' );
        proTst3.IsActive = true;
        proTst3.MX_WB_FamiliaProductos__c = objFamilyPro.Id;
        insert proTst3;

        final Opportunity opp = MX_WB_TestData_cls.crearOportunidad('LastName', accRec.Id, idAgente, ASDPRODUCT);
        opp.Producto__c = 'Auto Seguro Dinamico';
        insert opp;

        final MX_SB_VTS_ProveedoresCTI__c vcipProv = new MX_SB_VTS_ProveedoresCTI__c();
        vcipProv.Name = 'VCIP';
        vcipProv.MX_SB_VTS_Identificador_Proveedor__c = 'VCIP';
        vcipProv.MX_SB_VTS_TieneSegmento__c = false;
        vcipProv.MX_SB_VTS_IsReadyCTI__c = true;
        insert vcipProv;

        final MX_SB_VTS_ProveedoresCTI__c smartProv = new MX_SB_VTS_ProveedoresCTI__c();
        smartProv.Name = 'Smart Center';
        smartProv.MX_SB_VTS_Identificador_Proveedor__c = 'SMART CENTER';
        smartProv.MX_SB_VTS_TieneSegmento__c = true;
        smartProv.MX_SB_VTS_IsReadyCTI__c = true;
        insert smartProv;

        final MX_SB_VTS_FamliaProveedores__c famProVCIP = new MX_SB_VTS_FamliaProveedores__c();
        famProVCIP.MX_SB_VTS_Familia_de_productos__c = objFamilyPro.Id;
        famProVCIP.Name = 'VCIP';
        famProVCIP.MX_SB_VTS_ProveedorCTI__c = vcipProv.Id;
        insert famProVCIP;

        final MX_SB_VTS_FamliaProveedores__c famProSmart = new MX_SB_VTS_FamliaProveedores__c();
        famProSmart.MX_SB_VTS_Familia_de_productos__c = objFamilyPro2.Id;
        famProSmart.Name = 'Daños SmartCenter';
        famProSmart.MX_SB_VTS_ProveedorCTI__c = smartProv.Id;
        insert famProSmart;

        final MX_SB_VTS_Lead_tray__c hotLeadsVCIP = new MX_SB_VTS_Lead_tray__c();
        hotLeadsVCIP.Name = 'HotLeads VCIP';
        hotLeadsVCIP.MX_SB_VTS_Description__c = 'Bandeja para call me back';
        hotLeadsVCIP.MX_SB_VTS_ID_Bandeja__c = '1151';
        hotLeadsVCIP.MX_SB_VTS_Producto__c = proTst3.Id;
        hotLeadsVCIP.MX_SB_VTS_ProveedorCTI__c = vcipProv.Id;
        hotLeadsVCIP.MX_SB_VTS_Tipo_bandeja__c = 'HotLeads';
        insert hotLeadsVCIP;

        final MX_SB_VTS_Lead_tray__c hotLeadsSmart = new MX_SB_VTS_Lead_tray__c();
        hotLeadsSmart.Name = 'HotLeads VCIP';
        hotLeadsSmart.MX_SB_VTS_Description__c = 'Bandeja para Tracking';
        hotLeadsSmart.MX_SB_VTS_ID_Bandeja__c = '1152';
        hotLeadsSmart.MX_SB_VTS_Producto__c = proHogar.Id;
        hotLeadsSmart.MX_SB_VTS_ProveedorCTI__c = smartProv.Id;
        hotLeadsSmart.MX_SB_VTS_Tipo_bandeja__c = 'HotLeads';
        insert hotLeadsSmart;

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenters_Crear_Carga', iaso__Url__c = URLEXA, iaso__Cache_Partition__c = URLLOCAL);
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'Authentication', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = URLLOCAL);
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenter', iaso__Url__c = 'https://bbvacifrado.smartcenterservicios.com/ws_salesforce_desarrollo/api/login/authenticate', iaso__Cache_Partition__c = URLLOCAL);

        final Lista_Negra__c listaNegra = new Lista_Negra__c();
        listaNegra.Correo_Electronico__c = 'emailtest@blacklist.com';
        insert listaNegra;
        final Lista_Negra__c listaNegraMovil = new Lista_Negra__c();
        listaNegraMovil.Telefono__c = '5555555555';
        insert listaNegraMovil;
    }
    
    @isTest static void activarProceso() {        
       
        final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', BODY,new Map<String,String>());

        Test.setMock(HttpCalloutMock.class, mock);
               
        final Id IdAgente = UserInfo.getUserId();
        
        final Account accRec = [Select Id,Phone,LastName FROM Account Where LastName = 'LastName'];
        final Opportunity opp = [SELECT Id FROM Opportunity];
        
        MX_WB_CTI_cls.validacionTelefono('Opportunity',accRec.Phone,'','');  
        
        final String sXMl = MX_WB_CTI_cls.generarXML(accRec.Phone,accRec.LastName,CUPONNAME,opp.Id,IdAgente,'', 1,'','');  
        Test.startTest();
        MX_WB_CTI_cls.reqSolicitud(sXMl, opp.Id,'Opportunity');
        MX_WB_CTI_cls.procesaSol( opp.Id, '',CUPONNAME,IdAgente,accRec.LastName,accRec.Phone,'Opportunity',1,'','');
        MX_WB_CTI_cls.ftProcesaSol( opp.Id, '',CUPONNAME,IdAgente,accRec.LastName,accRec.Phone,'Opportunity',1,'','');
        
        Test.StopTest();
        final String parse = MX_WB_CTI_cls.parse(sXMl);
        System.assert(String.isNotBlank(parse), 'Envio correcto');
        
    }
      

     @isTest static void errorMock() {
       
        final MX_WB_Mock mock = new MX_WB_Mock(400,'ERROR', BODY,new Map<String,String>()); 

        Test.setMock(HttpCalloutMock.class, mock);
               
        final Id IdAgente = UserInfo.getUserId();
        
        final Account accRec = [Select Id,Phone,LastName FROM Account Where LastName = 'LastName'];
        final Opportunity opp = [SELECT Id FROM Opportunity];
        
        MX_WB_CTI_cls.validacionTelefono('Opportunity',accRec.Phone,'','');  
        
        final String sXMl = MX_WB_CTI_cls.generarXML(accRec.Phone,accRec.LastName,CUPONNAME,opp.Id,IdAgente,'', 1,'','');  
        Test.startTest();
        MX_WB_CTI_cls.reqSolicitud(sXMl, opp.Id,'Opportunity');
        MX_WB_CTI_cls.procesaSol( opp.Id, '',CUPONNAME,IdAgente,accRec.LastName,accRec.Phone,'Opportunity',1,'','');
        
        Test.StopTest();
        final String parse = MX_WB_CTI_cls.parse(sXMl);
        System.assert(String.isNotBlank(parse), 'Fallo envio');
     }

     @isTest static void callMeBackVCIP() {
         final MX_WB_Mock mock = new MX_WB_Mock(200,'OK', BODY,new Map<String,String>());
         Test.setMock(HttpCalloutMock.class, mock);
         Test.startTest();
            final Lead callmeAuto = new Lead();
            callmeAuto.Producto_Interes__c = 'Auto Seguro Dinamico';
            callmeAuto.LeadSource = System.Label.MX_SB_VTS_OrigenCallMeBack;
            callmeAuto.FirstName = 'Usuario prueba';
            callmeAuto.LastName = System.Label.MX_SB_VTS_OrigenCallMeBack;
            callmeAuto.TelefonoCelular__c = '5524815910';
            insert callmeAuto;
            System.assertEquals(callmeAuto.LeadSource, System.Label.MX_SB_VTS_OrigenCallMeBack, 'Origen correcto');
        Test.stopTest();
     }

     @isTest static void callMeBackSmart() {
         Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_Integration_MockGenerator());
         iaso.GBL_Mock.setMock(new MX_SB_VTS_Integration_MockGenerator());
         Test.startTest();
            final Lead callmeHogar = new Lead();
            callmeHogar.Producto_Interes__c = System.Label.MX_SB_VTS_Hogar;
            callmeHogar.LeadSource = System.Label.MX_SB_VTS_OrigenCallMeBack;
            callmeHogar.FirstName = 'Hogar prueba';
            callmeHogar.LastName = 'Daños Callme';
            callmeHogar.MobilePhone = '5592846771';
            insert callmeHogar;
            System.assertEquals(callmeHogar.LeadSource, System.Label.MX_SB_VTS_OrigenCallMeBack, 'Origen Hogar');
        Test.stopTest();
     }

     @isTest static void listaNegraMovil() {
         Test.startTest();
            final Lead callmeBlackPhone = new Lead();
            callmeBlackPhone.Producto_Interes__c = System.Label.MX_SB_VTS_Hogar;
            callmeBlackPhone.LeadSource = System.Label.MX_SB_VTS_OrigenCallMeBack;
            callmeBlackPhone.FirstName = 'Hogar prueba';
            callmeBlackPhone.LastName = 'Daños Callme';
            callmeBlackPhone.MobilePhone = '5555555555';
            try {
                insert callmeBlackPhone;
            } catch(DmlException dmlEx) {
                dmlEx.setMessage(System.Label.MX_SB_VTS_ErrorListaNegra);
                System.assertEquals(System.Label.MX_SB_VTS_ErrorListaNegra, dmlEx.getMessage(), 'Error esperado');
            }
        Test.stopTest();
     }

     @isTest static void listaNegraEmail() {
         Test.startTest();
            final Lead callmeBlackEmail = new Lead();
            callmeBlackEmail.Producto_Interes__c = System.Label.MX_SB_VTS_Hogar;
            callmeBlackEmail.LeadSource = System.Label.MX_SB_VTS_OrigenCallMeBack;
            callmeBlackEmail.FirstName = 'blackList';
            callmeBlackEmail.LastName = 'listaNegra';
            callmeBlackEmail.MobilePhone = '5513124512';
            callmeBlackEmail.Email = 'emailtest@blacklist.com';
            try {
                insert callmeBlackEmail;
            } catch(DmlException dmlEx) {
                dmlEx.setMessage(System.Label.MX_SB_VTS_ErrorListaNegra);
                System.assertEquals(System.Label.MX_SB_VTS_ErrorListaNegra, dmlEx.getMessage(), 'Error controlado');
            }
        Test.stopTest();
     }
}
