/*
**************************************************************************************************************
*   @Desarrollado por:      Accenture                                                                          *
*   @Autor:                 Eulises Aguilar Rodriguez                                                          *
*   @Proyecto:              Bancomer                                                                           *
*   @Descripción:           Clase de prueba para la clase GBL_DataTable_Ctrl                                   *
*                           y sus metodos.                                                                     *
*                                                                                                              *
*   Cambios (Versiones)                                                                                        *
*   --------------------------------------------------------------------------                                 *
*   No.     Fecha               Autor                   Descripción                                            *
*   ------  ----------  ----------------------      ---------------------------                                *
*   1.0     27-08-2018  Eulises Aguilar Rodriguez    Creación de clase                                         *
*   1.1     04/09/2018  Eulises Aguilar Rodriguez    Añadio método sinergia                                    *
*   1.2     04/09/2018  Luis Ruben Quinto Muñoz      Añadio método VISITAS y                                   *
*                                                    GRUPOS ECCONOMICOS                                        *
*   1.3     11/09/2018  Eulises Aguilar Rodriguez    Añadio método COBRANZA Y DISPERSIÓN                       *
*   1.4     11/09/2018  Luis Ruben Quinto Muñoz      Añadio método VISITAS TRIMESTRE                           *
*   1.5     19/09/2018  Luis Ruben Quinto Muñoz      Se corrige métodos de prueba ,                            *
*                                                    se hacen publicos los métodos                             *
*                                                    Se cambia diviosion del usuario para pruebas              *
*                                                    y se asignan permisos necesarios                          *
*   1.6     24/09/2018  Eulises Aguilar Rodriguez    Se corrige titulo de tabla                                *
*   1.7     03/10/2018  Fernando Jaime               Se cambia Administrador del sistema por etiqueta          *
*   1.8     24/09/2018  Luis Ruben Quinto Muñoz      Se cambia test Reciprocidad                               *
*   1.9     12/10/2018  Cristian Espinosa            Se elimina dependencia a campo Producto_BEyG__c           *
*                                                    del objeto Opportunity                                    *
*   2.0     23/10/2018  Daniel García                Añadio método Visitas fuera de rango                      *
*   2.1     24/10/2018  Jhovanny De La Cruz Cruz     Se agregan metodos de prueba para TAMS y Tarifario        *
*   2.2     09/10/2018  Jhovanny De La Cruz Cruz     Corrección para el llamado de metodos                     *
*   2.3     22/11/2018  Jhovanny De La Cruz Cruz     Corrección para el llamado de metodos                     *
*                                                    se agregan niveles de agrupación                          *
*   2.4     23/11/2018  Jhovanny De La Cruz Cruz     Cambio asignación grupo                                   *
*   2.5     23/11/2018  Luis Ruben Quinto Muñoz      Se cambia test Reciprocidad                               *
*   2.6     10/01/2019  Luis Ruben Quinto Muñoz      Se agrega test de Visitas Clientes pertenecientes al Grupo *
*   2.7     11/02/2019  Daniel García                Método de prueba para tablas en ficha cliente PyME        *
*   2.8     19/02/2019  Jhovanny De La Cruz Cruz     Análisis y depuración de clase test para resolución de incidencia 00048668 *
*   2.9     04/02/2019  Selena Rodriguez             Se crearon metodos testUserRoleValidation y testUserLogin()*
*                       Gabriel Rojas                para ampliar cobertura en la clase GBL_DataTable_Ctrl      *
*   3.0     05/07/2019  Selena Rodriguez             Se agrego  metodo setupMethod para dividir y reducir      *
*                       Gabriel Rojas                complejidad en en el metodo testTablasClientePyME()      *
*                                                                                                              *
*************************************************************************************************************** */
@isTest
private class GBL_DataTable_Test {
    /*
    * USERROLE Variable utilizada en el metodo testUserRoleValidation indicando el rol que será evaluado en el test */
    static final String USERROLE='BBVAADMINISTRADOR';
    @testSetup static void setupMethod() {
        final Account cliente7=UtilitysDataTest_tst.crearCuenta('Cliente PyME 1','VP_tre_Cliente_PyME');
        cliente7.OwnerId=UserInfo.getUserId();
        final List<GBL_DataTable_Ctrl.dataTableWrapper> lstdtTblWpr = new List<GBL_DataTable_Ctrl.dataTableWrapper>();

        final GBL_DataTable_Ctrl.dataTableWrapper wrapperPLEmpty = GBL_DataTable_Ctrl.valuesHandler('PLAZO',cliente7.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperFNEmpty = GBL_DataTable_Ctrl.valuesHandler('FONDOS',cliente7.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperVSEmpty = GBL_DataTable_Ctrl.valuesHandler('VISTA',cliente7.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperTNEmpty = GBL_DataTable_Ctrl.valuesHandler('TN',cliente7.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperTPVEmpty = GBL_DataTable_Ctrl.valuesHandler('SERVICIOS TPVS',cliente7.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperSEGREmpty = GBL_DataTable_Ctrl.valuesHandler('SERVICIOS SEGR',cliente7.id,'');
        lstdtTblWpr.add(wrapperPLEmpty);
        lstdtTblWpr.add(wrapperFNEmpty);
        lstdtTblWpr.add(wrapperVSEmpty);
        lstdtTblWpr.add(wrapperTNEmpty);
        lstdtTblWpr.add(wrapperTPVEmpty);
        lstdtTblWpr.add(wrapperSEGREmpty);
        insertDetalles();
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method insertDetalles insert  required registers  for test
    * -----------------------------------------------------------------------------------------------------
    * @Author   Selena Rodriguez
    * @Date     2019-07-26
    * @return   Void*/
    public static void insertDetalles() {
        final Account cliente8=UtilitysDataTest_tst.crearCuenta('Cliente PyME','VP_tre_Cliente_PyME');
        cliente8.OwnerId=UserInfo.getUserId();
        cliente8.MX_PyME_Vista_Saldo_diario__c = 3000.00;
        cliente8.MX_PyME_Vista_Saldo_mAnterior__c = 4000.00;
        cliente8.MX_PyME_Vista_Saldo_variacion__c = 5000.00;
        cliente8.MX_PyME_Plazo_Saldo_diario__c = 2000.00;
        cliente8.MX_PyME_Plazo_Saldo_mes_anterior__c = 6000.00;
        cliente8.MX_PyME_Plazo_Saldo_variacion__c = 8000.00;
        cliente8.MX_PyME_Fondos_Saldo_diario__c = 1000.00;
        cliente8.MX_PyME_Fondos_Saldo_mes_anterior__c = 5000.00;
        cliente8.MX_PyME_Fondos_Saldo_variacion__c = 7000.00;
        cliente8.No_de_cliente__c = '98120745';
        insert cliente8;

        final List<MX_PyME_Balance_Productos__c> lstProductosPyme = new List<MX_PyME_Balance_Productos__c>();
        final MX_PyME_Balance_Productos__c prTDCN = UtilitysDataTest_tst.crearProductoPyME('TDC NEGOCIOS','N','007627367236','A',cliente8.id,null,null,null);
        prTDCN.MX_PyME_prodNumero_credito__c = '123';
        lstProductosPyme.add(prTDCN);
        System.debug('prTDCN ' + prTDCN);
        final MX_PyME_Balance_Productos__c prTDMN = UtilitysDataTest_tst.crearProductoPyME('TDC MICRONEGOCIOS','S','007458880501418235','A',cliente8.id,null,null,null);
        lstProductosPyme.add(prTDMN);
        final MX_PyME_Balance_Productos__c prCSIM = UtilitysDataTest_tst.crearProductoPyME('CREDITO SIMPLE','N','007726352617','B',cliente8.id,null,null,null);
        lstProductosPyme.add(prCSIM);
        final MX_PyME_Balance_Productos__c servCRTC = UtilitysDataTest_tst.crearProductoPyME('','','','',cliente8.id,'CRTC','TEST CRTC',250000);
        lstProductosPyme.add(servCRTC);
        final MX_PyME_Balance_Productos__c servTPV = UtilitysDataTest_tst.crearProductoPyME('','','','',cliente8.id,'TPVS','TEST TPV',350000);
        lstProductosPyme.add(servTPV);
        final MX_PyME_Balance_Productos__c servOC = UtilitysDataTest_tst.crearProductoPyME('','','','',cliente8.id,'FISICA','TEST Otros creditos',500000);
        lstProductosPyme.add(servOC);
        final MX_PyME_Balance_Productos__c seguros = UtilitysDataTest_tst.crearProductoPyME('','','','',cliente8.id,'SEGR','TEST seguros',null);
        seguros.MX_PyME_Fecha_activacion__c = '01/05/2018    ACTIVO';
        lstProductosPyme.add(seguros);
        insert lstProductosPyme;
        System.debug('prTDCN ' + prTDCN);

        final MX_PyME_Detalle_productos__c detalle = new MX_PyME_Detalle_productos__c();
        detalle.MX_PyME_No_credito_tarjeta__c = '1';
        detalle.MX_PyME_Saldo_otorgado__c = 30000;
        detalle.MX_PyME_Porcentaje_uso__c = 23;
        detalle.MX_PyME_No_impagos__c = 0;
        detalle.MX_PyME_Amortizaciones__c = 2;
        detalle.MX_PyME_Compras_Disposiciones__c = 40000;
        detalle.MX_PyME_No_credito_bp__c = prTDCN.MX_PyME_prodNumero_credito__c;
        insert detalle;

        final MX_PyME_Detalle_productos__c detalle2 = new MX_PyME_Detalle_productos__c();
        detalle2.MX_PyME_No_credito_tarjeta__c = '2';
        detalle2.MX_PyME_Saldo_otorgado__c = 30000;
        detalle2.MX_PyME_No_impagos__c = 0;
        detalle2.MX_PyME_Amortizaciones__c = 2;
        detalle2.MX_PyME_Compras_Disposiciones__c = 40000;
        detalle2.MX_PyME_No_credito_bp__c = prCSIM.MX_PyME_prodNumero_credito__c;
        insert detalle2;
    }
      /*------------------------------------------------------------------------------------------------------
    *@Description Method testTablasClientePyME which generate a Table with client information  and call the service
    * -----------------------------------------------------------------------------------------------------
    * @Author   Selena Rodriguez
    * @Author   Gabriel Rojas
    * @Date     05/07/2019
    * @return   Void*/
    @isTest public static void testTablasClientePyME() {
        Boolean allOk=false;
        final Account cliente8=[SELECT id from Account where Name='Cliente PyME'];
        final MX_PyME_Balance_Productos__c prTDMN=[Select MX_PyME_prodNumero_credito__c from MX_PyME_Balance_Productos__c where MX_PyME_Concepto_Credito__c = 'TDC MICRONEGOCIOS'];
        Test.startTest();

        final GBL_DataTable_Ctrl.dataTableWrapper wrapperVS = GBL_DataTable_Ctrl.valuesHandler('VISTA',cliente8.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperPL = GBL_DataTable_Ctrl.valuesHandler('PLAZO',cliente8.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperFN = GBL_DataTable_Ctrl.valuesHandler('FONDOS',cliente8.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperTN = GBL_DataTable_Ctrl.valuesHandler('TN',cliente8.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperTMN = GBL_DataTable_Ctrl.valuesHandler('TDMN',cliente8.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperCS = GBL_DataTable_Ctrl.valuesHandler('CREDITO SIMPLE',cliente8.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperCRTC = GBL_DataTable_Ctrl.valuesHandler('SERVICIOS CRTC',cliente8.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperTPV = GBL_DataTable_Ctrl.valuesHandler('SERVICIOS TPVS',cliente8.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperOCR = GBL_DataTable_Ctrl.valuesHandler('OTROS CREDITOS',cliente8.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperSEGR = GBL_DataTable_Ctrl.valuesHandler('SERVICIOS SEGR',cliente8.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperDETALLE = GBL_DataTable_Ctrl.valuesHandler('DETALLE PRODUCTO',cliente8.id,'123');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperDETALLE2 = GBL_DataTable_Ctrl.valuesHandler('DETALLE PRODUCTO',cliente8.id,'');
        final GBL_DataTable_Ctrl.dataTableWrapper wrapperEmpty = GBL_DataTable_Ctrl.valuesHandler('EMPTY',cliente8.id,'');
        final iaso__GBL_Rest_Services_Url__c customSettingDT = new iaso__GBL_Rest_Services_Url__c();
        final List<GBL_DataTable_Ctrl.dataTableWrapper> lisdtWrapper = new List<GBL_DataTable_Ctrl.dataTableWrapper>();
        lisdtWrapper.add(wrapperPL);
        lisdtWrapper.add(wrapperFN);
        lisdtWrapper.add(wrapperTMN);
        lisdtWrapper.add(wrapperTPV);
        lisdtWrapper.add(wrapperSEGR);
        lisdtWrapper.add(wrapperDETALLE2);
        lisdtWrapper.add(wrapperEmpty);

        customSettingDT.Name = 'getDataServicesPyME';
        customSettingDT.iaso__Url__c = 'https://maxwebsealdesa.prev.bancomer.mx:6443/SRVS_A02/pymesCredit/';
        customSettingDT.iaso__Cache_Partition__c = 'iaso.ServicesPartition';
        customSettingDT.iaso__Timeout__c = 20000;
        customSettingDT.iaso__cacheTTLInSecs__c = 300;
        customSettingDT.iaso__isCacheInOrg__c = true;
        insert customSettingDT;
        GBL_DataTable_Ctrl.callBalanceService(cliente8.id,prTDMN.MX_PyME_prodNumero_credito__c);
        allOk = wrapperVS.gblResultResponse && wrapperTN.gblResultResponse && wrapperCS.gblResultResponse && wrapperCRTC.gblResultResponse && wrapperOCR.gblResultResponse && wrapperDETALLE.gblResultResponse ? true : false;
        System.assertEquals(true,allOk,'Tablas desplegadas correctamente');
        Test.stopTest();
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method  which validate  user´s role who are log in
    * -----------------------------------------------------------------------------------------------------
    * @Author   Selena Rodriguez
    * @Author   Gabriel Rojas
    * @Date     04/02/2019
    * */
    @isTest public static void testUserRoleValidation() {

        String roleprefix;
        final UserRole userRoleDN = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName =: USERROLE];
        final String uniqueUserName = 'testuser' + DateTime.now().getTime() + '@test.com';
        final Profile profLoged = [SELECT Id FROM Profile WHERE Name=:Label.MX_PERFIL_SystemAdministrator];
        final User usrLog = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = profLoged.Id, UserRoleId = userRoleDN.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        System.runAs(usrLog) {
            // The following code runs as user usrLog
            roleprefix = GBL_DataTable_Ctrl.userRoleValidation();
        }
        System.assertEquals('BEYG', roleprefix,'BEYG Prefijo del Rol con el que se ingresa');
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method  which validate  user who are log in
    * -----------------------------------------------------------------------------------------------------
    * @Author   Selena Rodriguez
    * @Author   Gabriel Rojas
    * @Date     04/02/2019
    * */
    @isTest public static void testUserLogin() {
        final String uniqueUserName = 'testuser' + DateTime.now().getTime() + '@test.com';
        final Profile profLoged = [SELECT Id FROM Profile WHERE Name=:Label.MX_PERFIL_SystemAdministrator];
        final User usrLog = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = profLoged.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        User userExpected;
        System.runAs(usrLog) {
            // The following code runs as user usrLog
            userExpected = GBL_DataTable_Ctrl.userLoggedIn();
            System.debug('userExpected ' + userExpected);
        }
        System.assertEquals(usrLog.LastName, userExpected.Name,'Nombre y Apellido de Usuario Ingresado');
    }
}