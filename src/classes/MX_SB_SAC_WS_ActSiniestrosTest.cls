/**-------------------------------------------------------------------------
 * Nombre: MX_SB_SAC_WS_ActSiniestrosTest
 * Autor Ing. Karen Sanchez
 * Proyecto: MW WB LG - BBVA Bancomer
 * Descripción : Clase test
 * --------------------------------------------------------------------------
 * Versión      Fecha           Autor                   Descripción
 * -------------------------------------------------------------------
 * 1.0          11/07/2019      Ing. Karen Sanchez      Creación
 * --------------------------------------------------------------------------
 */

 @isTest
public class MX_SB_SAC_WS_ActSiniestrosTest {
    
   /**
    * @description Contiene la url del servicio
    * @author Jose Luis Vargas Lara
    */ 
    public static final string URL_TOKEN = 'https://qa.wibe.com.mx/cotizadores/api/token/serviciosExpuestos/generarToken';
   
    /**
    * @description: Prepara los datos para la ejecucion de la clase test
    * @author José Luis Vargas Lara
    * @return Void
    */
    @TestSetup
    static void makeData() {
        MX_SB_SAC_LoginToken__c customSin = new MX_SB_SAC_LoginToken__c();
        customSin.Name = 'Login Siniestros';
        customSin.Url__c = URL_TOKEN;
        customSin.Usr__c = 'SALESFORCE01';
        customSin.Pwd__c = 'Salesforce2018';
        customSin.Token__c = '551as113fgak';
        customSin.Duracion__c = '180';
        insert customSin;

        MX_SB_SAC_LoginToken__c customLoginToken = new MX_SB_SAC_LoginToken__c();
        customLoginToken.Name = 'Login Wibe';
        customLoginToken.Url__c = URL_TOKEN;
        customLoginToken.Usr__c = 'SALESFORCE01';
        customLoginToken.Pwd__c = 'Salesforce2018';
        customLoginToken.Token__c = '551as113fgak';
        customLoginToken.Duracion__c = '180';
        insert customLoginToken;

        MX_SB_SAC_LoginToken__c customObtSin = new MX_SB_SAC_LoginToken__c();
        customObtSin.Name = 'Obtener Siniestros';
        customObtSin.Url__c = URL_TOKEN;
        customObtSin.Usr__c = 'SALESFORCE01';
        customObtSin.Pwd__c = 'Salesforce2018';
        customObtSin.Token__c = '551as113fgak';
        customObtSin.Duracion__c = '180';
        insert customObtSin;

        URLsWebServices__c customSttngURLWS = new URLsWebServices__c();
        customSttngURLWS.Name = 'Siniestros';
        customSttngURLWS.Url__c = 'https://qa.wibe.com.mx/cotizadores/api/autos/commons/siniestros/obtenerSiniestrosPoliza';
        insert customSttngURLWS;
    }
 
   /**
    * @description: Test para validar la generación del token
    * @author José Luis Vargas Lara
    * @return Void
    */
    @isTest
    public static void createToken() {
        MX_SB_SAC_LoginToken__c customSttngURL =  MX_SB_SAC_LoginToken__c.getInstance('Login Siniestros');
        Test.startTest();
            String newToken = MX_SB_SAC_WS_ActSiniestros.newToken(false);
            System.assertEquals(customSttngURL.Token__c , newToken, 'Token Recuperado de custom setting');
        Test.stopTest();
    }

   /**
    * @description: Test para validar la generacion del token desde el WS
    * @author José Luis Vargas Lara
    * @return Void
    */
    @isTest
    public static void creatTokenWS() {
        MX_SB_SAC_LoginToken__c customSttngURL =  MX_SB_SAC_LoginToken__c.getInstance('Login Siniestros');
        Test.setMock(HttpCalloutMock.class, new MX_SB_SAC_LoginSiniSucc_Mock());
        Test.startTest();
            String newToken = MX_SB_SAC_WS_ActSiniestros.newToken(true);
            System.assertEquals(true , newToken != customSttngURL.Token__c, 'Token desde WS');
        Test.stopTest(); 
    }
    
   /**
    * @description: Test para validar el update de siniestros
    * @author José Luis Vargas Lara
    * @return Void
    */
    @isTest
    public static void actSiniestroSuccess() {
        final User testUser = MX_WB_TestData_cls.crearUsuario('TestLastName', System.Label.MX_SB_VTS_ProfileAdmin);
  		insert testUser;
  		Account accountRecord = MX_WB_TestData_cls.crearCuenta('LastName', 'PersonAccount');
  		accountRecord.OwnerId = testUser.Id;
  		insert accountRecord;
  		Contract cont = MX_SB_SAC_UtileriasTestCls.crearContrato(accountRecord.Id, Date.today());
        cont.MX_WB_noPoliza__c = '819W0A001K';
        insert cont;
        MX_SB_SAC_LoginToken__c customSttngURL =  MX_SB_SAC_LoginToken__c.getInstance('Login Siniestros');  
        Test.setMock(HttpCalloutMock.class, new MX_SB_SAC_ActSiniestro_Succ_Mock());
        Test.startTest();
            Map<String, Object> responseActPol = MX_SB_SAC_WS_ActSiniestros.responseActPol(JSON.serialize(cont),customSttngURL.Token__c);
            System.assertEquals('Correct',String.valueOf(responseActPol.get('responseWS')) , 'actSiniestroSuccess Correcto');
        Test.stopTest();
    }
    
   /**
    * @description: Test para validar la consulta de end point
    * @author José Luis Vargas Lara
    * @return Void
    */
    @isTest
    public static void obtainEndpoitTest() {
        final MX_SB_SAC_WS_ActSiniestros.DataLogin oSiniestros = new MX_SB_SAC_WS_ActSiniestros.DataLogin(URL_TOKEN, '','', '');
        Test.startTest();
        final string endPoint = oSiniestros.obtainEndpoit();
        System.assert(!string.isBlank(endPoint), 'EndPoint consultado');
        Test.stopTest();
    }
    
   /**
    * @description: Test para validar la consulta de usuario
    * @author José Luis Vargas Lara
    * @return Void
    */
    @isTest
    public static void obtainUserNameTest() {
        final MX_SB_SAC_WS_ActSiniestros.DataLogin oSiniestros = new MX_SB_SAC_WS_ActSiniestros.DataLogin('', 'user','', '');
        Test.startTest();
        final string user = oSiniestros.obtainUserName();
        System.assert(!string.isBlank(user), 'Usuario consultado');
        Test.stopTest();
    }
    
   /**
    * @description: Test para validar la consulta de password
    * @author José Luis Vargas Lara
    * @return Void
    */
    @isTest
    public static void obtainUserPassTest() {
        final MX_SB_SAC_WS_ActSiniestros.DataLogin oSiniestros = new MX_SB_SAC_WS_ActSiniestros.DataLogin('', '','pass', '');
        Test.startTest();
        final string userPass = oSiniestros.obtainUserPass();
        System.assert(!string.isBlank(userPass), 'Password consultado');
        Test.stopTest();
    }
}