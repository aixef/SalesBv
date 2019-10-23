/**
 * @File Name          : MX_SB_SAC_Business_TEST.cls
 * @Description        : 
 * @Author             : Saul
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 16/8/2019 11:57:15
 * @Modification Log   : 
 *============================================================================================
 * Ver         Date                     Author      		                    Modification
 *============================================================================================
 * 1.0    16/8/2019 11:49:58            Saul                                    Initial Version
 * 2.0    16/8/2019 11:49:58      Ing. Karen Belem Sanchez Ruiz (KB)            Modified
 * 3.0    29/08/2019              José Luis Vargas Lara                         Correccion issues sonar
 **/
@isTest
private class MX_SB_SAC_Business_TEST {
	
    /**
    * @description: Obtiene las credenciales para logeo
    * @author Saul | 16/8/2019
    * @return @isTest
    */
    @isTest 
    static void getLoginToken() {
        Test.startTest();
        final MX_SB_SAC_LoginToken__c logTok = MX_SB_SAC_UtileriasTestCls.creaCredencial();
        logTok.Name = 'Actualiza Polizas';
        insert logTok;
        final MX_SB_SAC_LoginToken__c login = MX_SB_SAC_Business_Cls.getLoginToken(logTok.Name);
        System.assert(login != null, 'Login generado correctamente');
        Test.stopTest();
    }
    
    /**
    * @description: Obtiene el parámetro de entrada de la póliza
    * @author Saul | 16/8/2019
    * @return @isTest
    */
    @isTest 
    static void getParamsPoliza() {
        Test.startTest();
        final MX_SB_SAC_ParametrosPoliza__c paramPol = MX_SB_SAC_UtileriasTestCls.creaCSParametros();
        insert paramPol;
        final MX_SB_SAC_ParametrosPoliza__c poliza = MX_SB_SAC_Business_Cls.getParamsPoliza(paramPol.Name);
        System.assert(poliza != null, 'Parametros de poliza obtenidos correctamente');
        Test.stopTest();
    }
    
    /**
    * @description: Obtiene el producto de la póliza
    * @author Saul | 16/8/2019
    * @return @isTest
    */
    @isTest 
    static void getProductSAC() {
        Test.startTest();
        final Product2 produc = MX_SB_SAC_UtileriasTestCls.creaProducto();
        insert produc;
        final Product2 producto = MX_SB_SAC_Business_Cls.getProductSAC(produc.Name);
        System.assert(producto != null, 'Consulta de producto exitosa');
        Test.stopTest();
    }
}