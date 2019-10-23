/**
* ------------------------------------------------------------------------------------------------
* @Name         MX_PyME_MassiveTransfer_Tst
* @Author       BBVA
* @Date         Created :  2019-05-14
* @Group        PYME
* @Description  Class that implements and tests methods from MX_PyME_MassiveTransfer_Cls
* @Changes      (most recent first)
*  |2019-05-14 |                   | First version
*  |2019-07-23 | Cindy Hernández   | Resolución de code smells detectados por sonar.
                                     Se utliza la etiqueta NOSONAR para falsos positivos con
                                     "Potentially unused variable" en variables que si se utilizan.
*  |2019-08-05 | Cindy Hernández   | Se crea el método createCaseWithAdmin.
* ------------------------------------------------------------------------------------------------
*/

@isTest
private class MX_PyME_MassiveTransfer_Test {
    /*------------------------------------------------------------------------------------------------------
    *@Description This method tests when a case is successfully created and when two accounts are in one request
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-05-14
    * @param    None
    * @return   Void
    * @example  createCase()
    * */

/**
* String with value 'Red PyME'
*/
    static final String PYME_STRING = 'Red PyME';
/**
* String with value 'METROPOLITANA NORTE PYME'
*/
    static final String NORTE_STRING = 'METROPOLITANA NORTE PYME';
/**
* String with value 'TEST'
*/
    static final String TEST_STRING = 'TEST';
/**
* String with value '12345'
*/
    static final String CLT_NO_STRING = '12345';
/**
* String with value 'EJEC PYME PLUS AGUASCALIENTES'
*/
    static final String ROL_STRING = 'EJEC PYME PLUS AGUASCALIENTES';
/**
* String with value 'Ejecutivo PyME Plus'
*/
    static final String PROFILE_STRING = 'Ejecutivo PyME Plus';
/**
* String with value 'Name'
*/
    static final String NAME_STRING = 'Name';

    @isTest static void createCaseWithAdmin() {
        final User dirDivisionalPyME = UtilitysDataTest_tst.crearUsuario('USUARIO DIV', 'D Divisional - D. PN PyME', 'D DIVISIONAL - D. PN BAJIO');
        dirDivisionalPyME.VP_ls_Banca__c = PYME_STRING;
        insert dirDivisionalPyME;

        final User adminUser = UtilitysDataTest_tst.crearUsuario('USUARIO ADMIN', Label.MX_PERFIL_SystemAdministrator, 'BBVA Bancomer');
        adminUser.VP_ls_Banca__c = PYME_STRING;
        adminUser.Divisi_n__c = NORTE_STRING;
        adminUser.Director_divisional__c = dirDivisionalPyME.id;
        insert adminUser;

        final User ejecPyMEOrigen = UtilitysDataTest_tst.crearUsuario('USUARIO EJEC', PROFILE_STRING, ROL_STRING);
        ejecPyMEOrigen.VP_ls_Banca__c = PYME_STRING;
        ejecPyMEOrigen.Divisi_n__c = NORTE_STRING;
        insert ejecPyMEOrigen;

        final User ejecPyMEDestino = UtilitysDataTest_tst.crearUsuario('USUARIO EJEC 2', PROFILE_STRING, ROL_STRING);
        ejecPyMEDestino.VP_ls_Banca__c = PYME_STRING;
        ejecPyMEDestino.Divisi_n__c = NORTE_STRING;
        insert ejecPyMEDestino;

        System.runAs(adminUser) {
            final List<String> idfixed = new List<String>();
            final Account acc = UtilitysDataTest_tst.crearCuenta(TEST_STRING,'VP_tre_Cliente_PyME');
            acc.No_de_cliente__c = CLT_NO_STRING;
            acc.OwnerId = ejecPyMEOrigen.id;
            insert acc;

            idfixed.add(acc.Id);
            Test.setFixedSearchResults(idfixed);

            final String accmap = MX_PyME_MassiveTransfer_Cls.searchDB('Account',NAME_STRING, 'Id','No_de_cliente__c','','', 'Division1__c', '' ,4,NAME_STRING, TEST_STRING );
            MX_PyME_MassiveTransfer_Cls.searchDB('User',NAME_STRING, 'Id','','UG__c','Divisi_n__c', '', 'VP_ls_Banca__c' ,4,NAME_STRING, TEST_STRING );

            final Object obj = (Object) accmap;
            system.debug(obj instanceof String);
            List<Object> lstObjCase = new List<Object>();
            final List<Object> lstobj = new List<Object>();
            lstObjCase = MX_PyME_MassiveTransfer_Cls.checkDuplicatedRecords(lstobj, obj);
            final String listaString = String.valueOf(lstObjCase).remove('([').remove('])');
            final List<Object> objs = new List<Object>();
            final Object cliente1 = (Object) listaString;
            final String obj2Str = String.valueOf(cliente1).replace(CLT_NO_STRING,'56789').replace(TEST_STRING,'TEST 2');
            final String obj3Str = String.valueOf(cliente1).replace(CLT_NO_STRING,'98234').replace(TEST_STRING,'TEST 3');
            final String obj4Str = String.valueOf(cliente1).replace(CLT_NO_STRING,'74635').replace(TEST_STRING,'TEST 4');
            final String obj5Str = String.valueOf(cliente1).replace(CLT_NO_STRING,'64532').replace(TEST_STRING,'TEST 5');
            final Object cliente2 = (Object) obj2Str;
            final Object cliente3 = (Object) obj3Str;
            final Object cliente4 = (Object) obj4Str;
            final Object cliente5 = (Object) obj5Str;
            objs.add(cliente1);
            objs.add(cliente2);
            objs.add(cliente3);
            objs.add(cliente4);
            objs.add(cliente5);
            final String userDestino = '{"val":"'+ ejecPyMEDestino.id +'","unidadG":"'+ ejecPyMEDestino.UG__c +'","text":"'+ ejecPyMEDestino.LastName +'","objName":"User","clientNumber":"","divCl":"","div":"'+ ejecPyMEDestino.Divisi_n__c +'","banca":"'+ PYME_STRING +'"}';
            MX_PyME_MassiveTransfer_Cls.createCase(objs,userDestino,true);
            final List<Case> casosCreados = [Select id from Case where status = 'Solicitada'];
            System.assertEquals(1, casosCreados.size(),'Caso creado y enviado para aprobación correctamente');
            MX_PyME_MassiveTransfer_Cls.createCase(objs,userDestino,true);
        }
    }

}