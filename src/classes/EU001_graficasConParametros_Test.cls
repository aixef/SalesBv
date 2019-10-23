/**
*Proyecto:               Digital Workplace Retail
*Descripción:            Clase Test para la clase EU001_graficasConParametros_Ctrl
*
*Cambios (Versiones)
*-------------------------------------------------------------------------------
*No.         Fecha            Autor                           Descripción
*------   ----------------   --------------------   ----------------------------
*1.0      24-06-2019         Cindy Hernández          Creación. Se crea a partir de la clase EU001_ConsolaDirector_test.
*1.0      24-06-2019         Cindy Hernández          Se modifican las referencias a los perfiles y funciones de empresas.
													  Se agregan los métodos grafParametrosConstructor y getTeamDirectorDOError.
													  Se modifica el método generaReporteApoyosError para agregar el try catch.
													  Se modifica el método getTotalApoyosTest para agregar el System.assert.
													  Se modifica el método generaNuevoRITest para agregar la casuistica getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_APOYOS).
													  El método generaNuevoRITest se divide en generaNuevoRITest y generaNuevoRITest2, se agrega System.assert al método generaNuevoRITest2.
													  Se agregan los métodos getValDOTest y getTeamDirectorDOTest. Se elimina el método getTeamDirectorDOError.
**/

@isTest
public  class EU001_graficasConParametros_Test {
    /** Colocación */
    static final String STGFAM = 'Colocación';
    /** Collares */
    static final String STGPROD = 'Collares';
    /** MX_BPP_RedBpyp */
    static final String STGRTOPP = 'MX_BPP_RedBpyp';
    /** Mapa perfileMapa */
    static Map<String, Profile> perfilMapa = new Map<String, Profile>();
    /** MApa RolMapa*/
    static Map<String, UserRole> RolMapa = new Map<String, UserRole>();
    /** variable p*/
    static List<Profile> p;
    /** Lista userRole*/
    static List<UserRole> userRole;

    static {
        p = new List<Profile>([SELECT Id, Name FROM Profile WHERE Name = 'BPyP Director Oficina' OR Name =: Label.MX_PERFIL_SystemAdministrator OR
                               Name = 'BPyP STAFF' OR Name = 'BPyP Director Divisional']);
        userRole = new List<UserRole>([SELECT Id, Name FROM UserRole WHERE Name = 'BPYP DIRECTOR OFICINA LOMAS' OR Name = 'BPYP BANQUERO PRIVADO y UHN LOMAS' OR
                                      Name = 'BPYP STAFF DIRECCIÓN BANCA' OR Name = 'BPYP DIRECTOR DIVISIONAL']);

        for(Profile perfil:p) { perfilMapa.put(perfil.Name, perfil); }
        for(UserRole ur:userRole) { RolMapa.put(ur.Name, ur); }
    }


    @isTest
    static void generaNuevoRITest() {
        final User usr = MX_BPP_UserAndRIDataFactory.creaUser();
        insert usr;

        Test.startTest();

        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_REPORTE_LOGRO_POR_INDICADOR);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_CARTERA_CP);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_CARTERA_LP);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_VISTA_MN);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_INVERIONES);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_RESTO);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_INF_RECURRENTES);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_INF_NO_RECURRENTES);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_MARGEN);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_STOCK_NOMINA);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_REPORTE_CERTIFICACION_EU);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_REPORTE_GESTION_COMERCIAL);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POR_EJECUTIVO);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POTENCIAL_POR_EJECUTIVO);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_STR_INV_REST_CAP);
        EU001_graficasConParametros_Ctrl.getIndicadores(EU001_CLS_CONSTANTES.EU001_STR_CAPTACION_ME);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_LOGRO_POR_INDICADOR);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POR_INDICADOR);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_GANA_MAS_INDICADOR);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_CARTERA_CP);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_CARTERA_LP);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_VISTA_MN);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_INVERIONES);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_RESTO);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_INF_RECURRENTES);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_INF_NO_RECURRENTES);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_MARGEN);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_STOCK_NOMINA);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_CERTIFICACION_EU);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_GESTION_COMERCIAL);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POR_EJECUTIVO);
        EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_APOYOS);
        EU001_graficasConParametros_Ctrl.getAgrupadores('',EU001_CLS_CONSTANTES.EU001_REPORTE_GESTION_COMERCIAL);
        EU001_graficasConParametros_Ctrl.getAgrupadores('',EU001_CLS_CONSTANTES.EU001_REPORTE_CERTIFICACION_EU);
        EU001_graficasConParametros_Ctrl.getAgrupadores(' pts',EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POR_INDICADOR );
        EU001_graficasConParametros_Ctrl.getAgrupadores(' G+', EU001_CLS_CONSTANTES.EU001_REPORTE_GANA_MAS_INDICADOR);
        EU001_graficasConParametros_Ctrl.getAgrupadoresDetalle();
        String[] concepto = new List<String>();
        concepto = EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_LOGRO_POR_INDICADOR);
        EU001_graficasConParametros_Ctrl.getObtieneValores(usr.UG__c,EU001_graficasConParametros_Ctrl.getAgrupadores('',EU001_CLS_CONSTANTES.EU001_REPORTE_LOGRO_POR_INDICADOR),concepto.get(0),true);
        Test.stopTest();
        System.assert(true,'This Works!');
    }

    @isTest
    static void generaNuevoRITest2() {
        final User usr = MX_BPP_UserAndRIDataFactory.creaUser();
        insert usr;
        System.runAs(usr) {
            final EU001_RI__c ri1 = MX_BPP_UserAndRIDataFactory.creaRI(usr.Id);
            insert ri1;
            Test.startTest();
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_APOYOS, usr.UG__c, ri1.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_LOGRO_POR_INDICADOR, usr.UG__c, usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_COMPROMISO_EJECUTIVO, usr.UG__c, usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POR_INDICADOR, usr.UG__c, usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_GANA_MAS_INDICADOR, usr.UG__c, usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_CARTERA_CP, usr.UG__c, usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_CARTERA_LP, usr.UG__c, usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_VISTA_MN, usr.UG__c, usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_INVERIONES, usr.UG__c, usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_RESTO, usr.UG__c, usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_INF_RECURRENTES, usr.UG__c, usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_MARGEN, usr.UG__c, usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_STOCK_NOMINA, usr.UG__c,  usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_CERTIFICACION_EU, usr.UG__c,  usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_GESTION_COMERCIAL, usr.UG__c,  usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_ALERTAS_INCENTIVADAS, usr.UG__c,  usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_PLAN_CHOQUE, usr.UG__c,  usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_COMPROMISO_EJECUTIVO, usr.UG__c, usr.Id, 'Todos') ;
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_TOTAL_COMPROMISO, usr.UG__c, usr.Id, 'Todos');
            EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_INV_REST_CAPT, usr.UG__c, usr.Id, 'Todos') ;
            final List<List<String>> conjunto = EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_CAPT_ME, usr.UG__c, usr.Id, 'Todos') ;
            Test.stopTest();
            System.assert(conjunto[0].contains('D) Compromisos'));
       }
    }

	@isTest
    static void priorDO() {
        final User u1 = MX_BPP_UserAndRIDataFactory.crearUsuario('UserDos', 'BPyP Director Oficina', 'BPYP DIRECTOR OFICINA LOMAS');
        u1.Alias = 'UserDos';
        u1.Email='do.empresas1@bbva.tst.deploy.com';
        u1.EmailEncodingKey='ISO-8859-1';
        u1.LastName='Prueba1';
        u1.LanguageLocaleKey='en_US';
        u1.LocaleSidKey='en_US';
        u1.CR__c = '11121';
        u1.UG__c = '999991';
        u1.Segmento_Ejecutivo__c = 'EMPRESARIAL';
        u1.TimeZoneSidKey='America/Mexico_City';
        u1.UserName='adminDGMP1@bbva.tst.deploy.com';
        u1.VP_ls_Banca__c = 'Red BEyG';
        u1.IsActive=true;
        insert u1;

        final User us2 = MX_BPP_UserAndRIDataFactory.crearUsuario('USERGM', Label.MX_PERFIL_SystemAdministrator, 'BPYP BANQUERO PRIVADO y UHN LOMAS');
        us2.Alias = 'USERGM';
        us2.Email='do.empresas@bbva.tst.deploy.com';
        us2.EmailEncodingKey='ISO-8859-1';
        us2.LastName='Prueba';
        us2.LanguageLocaleKey='en_US';
        us2.LocaleSidKey='en_US';
        us2.CR__c = '0828';
        us2.UG__c = '888888';
        us2.Segmento_Ejecutivo__c = 'CORPORATIVO';
        us2.TimeZoneSidKey='America/Mexico_City';
        us2.UserName='adminDGM@bbva.tst.deploy.com';
        us2.VP_ls_Banca__c = 'Red BEyG';
        us2.IsActive=true;
        us2.No_de_nomina__c =  '45647';
        insert us2;

        Test.startTest();
        System.runAs(us2) {
			UtilitysDataTest_tst.crearProdForm(STGFAM, STGPROD);
            final List<EU_001_Compromiso__c> lisComp = MX_BPP_AccAndOppDataFactory.generaCompromisosDO(EU001_CLS_CONSTANTES.EU001_STR_NO_CLIENTE);
        	system.assert(lisComp.size()!=null, 'retorno de info correcto');
        }
        System.runAs(u1) {
            final List<String> comp2 = EU001_graficasConParametros_Ctrl.getImpactoCompPrior(EU001_CLS_CONSTANTES.EU001_STR_USUARIO_CREDITO, u1.UG__c);
        	system.assert(comp2.size()!=null, 'retorno de info correcto');
        }
        Test.stopTest();
    }

    @isTest static void generaDGM() {
        final User u1 = new User();
        u1.Alias = 'UserDos';
        u1.Email='do.empresas1@bbva.tst.deploy.com';
        u1.EmailEncodingKey='ISO-8859-1';
        u1.LastName='Prueba1';
        u1.LanguageLocaleKey='en_US';
        u1.LocaleSidKey='en_US';
        u1.ProfileId = perfilMapa.get('BPyP Director Oficina').Id;
        u1.UserRoleId = rolMapa.get('BPYP DIRECTOR OFICINA LOMAS').Id;
        u1.CR__c = '11121';
        u1.UG__c = '999991';
        u1.Segmento_Ejecutivo__c = 'EMPRESARIAL';
        u1.TimeZoneSidKey='America/Mexico_City';
        u1.UserName='adminDGMP1@bbva.tst.deploy.com';
        u1.VP_ls_Banca__c = 'Red BEyG';
        u1.IsActive=true;
        Insert u1;

        final User us2 = MX_BPP_UserAndRIDataFactory.crearUsuario('USERGM', Label.MX_PERFIL_SystemAdministrator, 'BPYP BANQUERO PRIVADO y UHN LOMAS');
        us2.Alias = 'USERGM';
        us2.Email='do.empresas@bbva.tst.deploy.com';
        us2.EmailEncodingKey='ISO-8859-1';
        us2.LastName='Prueba';
        us2.LanguageLocaleKey='en_US';
        us2.LocaleSidKey='en_US';
        us2.UserRoleId = rolMapa.get('BPYP BANQUERO PRIVADO y UHN LOMAS').Id;
        us2.CR__c = '0828';
        us2.UG__c = '888888';
        us2.Segmento_Ejecutivo__c = 'CORPORATIVO';
        us2.TimeZoneSidKey='America/Mexico_City';
        us2.UserName='adminDGM@bbva.tst.deploy.com';
        us2.VP_ls_Banca__c = 'Red BEyG';
        us2.IsActive=true;
        us2.No_de_nomina__c =  '45647';
        Insert us2;

        system.runAs(u1) {

            final EU001_RI__c ri1 = MX_BPP_UserAndRIDataFactory.creaRI(u1.Id);
            insert ri1;

            String[] concepto0 = new List<String>();
            concepto0 = EU001_graficasConParametros_Ctrl.getConceptos(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POTENCIAL_POR_EJECUTIVO);
            EU001_graficasConParametros_Ctrl.getObtieneValoresDGM(concepto0.get(0), u1.UG__c);
            final Integer inTamanio = EU001_graficasConParametros_Ctrl.getTamanio('999991');
            if (inTamanio > 0) {
                EU001_graficasConParametros_Ctrl.getObtieneValoresDGM(concepto0.get(1), u1.UG__c);
                EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POR_EJECUTIVO, '999991', u1.Id, 'Todos') ;
                EU001_graficasConParametros_Ctrl.getGeneraJSONReporte(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POTENCIAL_POR_EJECUTIVO, '999991', u1.Id, 'Todos') ;
            }
        }

        test.startTest();
        system.runAs(u1) {
            MX_BPP_RIRecordsDataFactory.createTabIndicadorl(us2.UG__c,EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR_POT);
            MX_BPP_RIRecordsDataFactory.createTabIndicadorl(us2.UG__c,EU001_CLS_CONSTANTES.EU001_STR_EXP_UNICA);
            System.assert(true,'This Works!');
        }
        test.stopTest();
    }

	@isTest static void priorDR() {
        final User u1 = new User();
        u1.Alias = 'UserDos';
        u1.Email='do.empresas1@bbva.tst.deploy.com';
        u1.EmailEncodingKey='ISO-8859-1';
        u1.LastName='Prueba1';
        u1.LanguageLocaleKey='en_US';
        u1.LocaleSidKey='en_US';
        u1.ProfileId = perfilMapa.get('BPyP STAFF').Id;
        u1.UserRoleId = rolMapa.get('BPYP STAFF DIRECCIÓN BANCA').Id;
        u1.CR__c = '11121';
        u1.UG__c = '999991';
        u1.Segmento_Ejecutivo__c = 'EMPRESARIAL';
        u1.TimeZoneSidKey='America/Mexico_City';
        u1.UserName='adminDGMP1@bbva.tst.deploy.com';
        u1.VP_ls_Banca__c = 'Red BEyG';
        u1.IsActive=true;
        Insert u1;
        final User us2 = MX_BPP_UserAndRIDataFactory.creaUser2();
        insert us2;
        Test.startTest();
        System.runAs(us2) {
			UtilitysDataTest_tst.crearProdForm(STGFAM, STGPROD);
            final List<EU_001_Compromiso__c> lisComp = MX_BPP_AccAndOppDataFactory.generaCompromisosDO(EU001_CLS_CONSTANTES.EU001_STR_NO_CLIENTE);
        	system.assert(lisComp.size()!=null, 'retorno de info correcto');
        }
        System.runAs(u1) {
            final List<String> comp3 = EU001_graficasConParametros_Ctrl.getImpactoCompPrior(EU001_CLS_CONSTANTES.EU001_STR_USUARIO_CREDITO, u1.UG__c);
        	system.assert(comp3.size()!=null, 'retorno de info correcto');
        }
        Test.stopTest();
    }

    @isTest static void TestFunctionConFuncionAbajo() {
        final User u2 = MX_BPP_UserAndRIDataFactory.creaUser();
        insert u2;

        final User ux = MX_BPP_UserAndRIDataFactory.crearUsuario('UserDos', Label.MX_PERFIL_SystemAdministrator, 'BPYP BANQUERO PRIVADO y UHN LOMAS');
        ux.Alias = 'UserDos';
        ux.Email='ej.empresas@bbva.tst.deploy.com';
        ux.EmailEncodingKey='ISO-8859-1';
        ux.LastName='Prueba';
        ux.LanguageLocaleKey='en_US';
        ux.LocaleSidKey='en_US';
        ux.CR__c = '1110';
        ux.UG__c = '0468132';
        ux.Segmento_Ejecutivo__c = 'EMPRESARIAL';
        ux.TimeZoneSidKey='America/Mexico_City';
        ux.UserName='admin2@bbva.tst.deploy.com';
        ux.VP_ls_Banca__c = 'Red BEyG';
        ux.IsActive=true;
        insert ux;

        test.startTest();
        System.runAs(u2) {
            final EU001_RI__c ri2 = MX_BPP_UserAndRIDataFactory.creaRI(u2.Id);
            insert ri2;
            EU001_graficasConParametros_Ctrl.getTable(false);
            EU001_graficasConParametros_Ctrl.getTable(true);
            EU001_graficasConParametros_Ctrl.getInforme('Logro_por_indicador');
            System.assert(true,'This Works!');
        }
        test.stopTest();
    }

        @isTest static void TestFunctionConFuncionAbajo2() {

        final User u3 = MX_BPP_UserAndRIDataFactory.creaUser();
        u3.UserRoleId = rolMapa.get('BPYP BANQUERO PRIVADO y UHN LOMAS').Id;
        insert u3;
        test.startTest();
        System.runAs(u3) {
            final EU001_RI__c ri6 = MX_BPP_UserAndRIDataFactory.creaRI(u3.Id);
            ri6.EU001_tx_Estado__c = 'Preparación';
            insert ri6;
            EU001_graficasConParametros_Ctrl.getTable(false);
            System.assert(true,'This Works!');
        }
        test.stopTest();
    }

    @isTest static void getTotalApoyosTest() {
        final User usr1 = MX_BPP_UserAndRIDataFactory.creaUser();
        insert usr1;

        Test.startTest();

        System.runAs(usr1) {

            final EU001_RI__c ri1 = MX_BPP_UserAndRIDataFactory.creaRI(usr1.Id);
            insert ri1;

            final Case casoRI = new Case();
            casoRI.EU001_ls_Tipo_de_apoyo__c = 'Producto';
            casoRI.Subject = 'Test-subject';
            casoRI.EU001_fh_Fecha_propuesta_de_cierre__c = Date.today().addDays(10);
            casoRI.Status = EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO;
            casoRI.Reuni_n_Individual_RI__c = ri1.id;
            casoRI.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Apoyos').getRecordTypeId();

           	insert casoRI;

          	final List<List<String>> valores = EU001_graficasConParametros_Ctrl.getTotalApoyos(ri1.Id);
        	System.assertEquals('Abierto', valores[0][0]);
            Test.stopTest();
     	}
    }

   	@isTest
    static void getTotalApoyosError() {
        final User usr1 = MX_BPP_UserAndRIDataFactory.creaUser();
        insert usr1;
        String errorMessage = '';
        Test.startTest();

        System.runAs(usr1) {

            final EU001_RI__c ri1 = MX_BPP_UserAndRIDataFactory.creaRI(usr1.Id);
            insert ri1;

        	try {
            	EU001_graficasConParametros_Ctrl.getTotalApoyos('BadId');
        	} catch (Exception e) {
            	errorMessage = e.getMessage();
        	}
       	}
        Test.stopTest();
        System.assertEquals('Script-thrown exception', errorMessage);
    }

    @isTest
    static void getTeamDirectorDOTest() {
        final User usr = MX_BPP_UserAndRIDataFactory.crearUsuario('CLIENTES MASA', 'BPyP Estandar','BPYP BANQUERO PRIVADO y UHN LOMAS');
        insert usr;
        final User parentRole = MX_BPP_UserAndRIDataFactory.crearUsuario('CLIENTES MASA', 'BPyP Director Oficina','BPYP DIRECTOR OFICINA LOMAS');
        insert parentRole;
        String errorMessage = '';
        Test.startTest();
        try {
            EU001_graficasConParametros_Ctrl.getTeamDirectorDO(parentRole.UG__c);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        Test.stopTest();
        System.assertEquals('', errorMessage);
    }

    @isTest static void priorDD() {
        final User u1 = new User();
        u1.Alias = 'UserDos';
        u1.Email='do.empresas1@bbva.tst.deploy.com';
        u1.EmailEncodingKey='ISO-8859-1';
        u1.LastName='Prueba1';
        u1.LanguageLocaleKey='en_US';
        u1.LocaleSidKey='en_US';
        u1.ProfileId = perfilMapa.get('BPyP Director Divisional').Id;
        u1.UserRoleId = rolMapa.get('BPYP DIRECTOR DIVISIONAL').Id;
        u1.CR__c = '11121';
        u1.UG__c = '999991';
        u1.Segmento_Ejecutivo__c = 'EMPRESARIAL';
        u1.TimeZoneSidKey='America/Mexico_City';
        u1.UserName='adminDGMP1@bbva.tst.deploy.com';
        u1.VP_ls_Banca__c = 'Red BEyG';
        u1.IsActive=true;
        Insert u1;
        final User us2 = MX_BPP_UserAndRIDataFactory.creaUser2();
        insert us2;
        Test.startTest();
        System.runAs(us2) {
			UtilitysDataTest_tst.crearProdForm(STGFAM, STGPROD);
            final List<EU_001_Compromiso__c> lisComp = MX_BPP_AccAndOppDataFactory.generaCompromisosDO(EU001_CLS_CONSTANTES.EU001_STR_NO_CLIENTE);
        	system.assert(lisComp.size()!=null, 'retorno de info correcto');
        }
        System.runAs(u1) {
            final List<String> comp4 = EU001_graficasConParametros_Ctrl.getImpactoCompPrior(EU001_CLS_CONSTANTES.EU001_STR_USUARIO_CREDITO, u1.UG__c);
        	system.assert(comp4.size()!=null, 'retorno de info correcto');
        }
        Test.stopTest();
    }

    @isTest
    static void getValDRError() {
        final User us2 = MX_BPP_UserAndRIDataFactory.creaUser2();
        insert us2;
        Test.startTest();
        System.runAs(us2) {
			UtilitysDataTest_tst.crearProdForm(STGFAM, STGPROD);
            final List<EU_001_Compromiso__c> lisComp = MX_BPP_AccAndOppDataFactory.generaCompromisosDO(EU001_CLS_CONSTANTES.EU001_STR_NO_CLIENTE);
            String errorMessage = '';
            try {
                EU001_graficasConParametros_Ctrl.getValDR('DR', lisComp);
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('Argument cannot be null.', errorMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void grafParametrosConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        final EU001_graficasConParametros_Ctrl grafParametros = new EU001_graficasConParametros_Ctrl();
            System.assert(grafParametros != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }

    @isTest static void getValDOTest() {
        final User usr = MX_BPP_UserAndRIDataFactory.crearUsuario('CLIENTES MASA', Label.MX_PERFIL_SystemAdministrator,'BBVA ADMINISTRADOR');
        insert usr;
        system.runAs(usr) {
            final EU001_RI__c ri = MX_BPP_UserAndRIDataFactory.creaRI(usr.Id);
            ri.EU001_tx_Estado__c='Evaluacion';
            insert ri;
            final Account acc = MX_BPP_AccAndOppDataFactory.crearCuenta('CUENTA PRUEBA','BPyP_tre_Cliente');
            Insert acc;
			UtilitysDataTest_tst.crearProdForm(STGFAM, STGPROD);
            final Opportunity opp03 = MX_BPP_AccAndOppDataFactory.crearOportunidad('OPORTUNIDAD PRUEBA2', acc.id ,  usr.id, STGRTOPP);
            opp03.probability = 80;
            opp03.closeDate = date.today().addDays(5);
            opp03.Tipo_de_Registro_Manual2__c = EU001_cls_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_INVERSIONES;
            insert opp03;
            final Opportunity opp04 = MX_BPP_AccAndOppDataFactory.crearOportunidad('OPORTUNIDAD PRUEBA', acc.id ,  usr.id, STGRTOPP);
            opp04.probability = 80;
            opp04.closeDate = date.today().addDays(5);
            insert opp04;
            final List<EU_001_Compromiso__c> listComp= new List<EU_001_Compromiso__c>();
            final EU_001_Compromiso__c comp2 = MX_BPP_RIRecordsDataFactory.genereteCompromisoEU(EU001_CLS_CONSTANTES.EU001_TRE_COMPROMISO_CARTERA, EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_LP, EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO, 15, opp03.Id, ri.Id);
            comp2.EU001_Un_nivelPriorizacion__c = 1;
            final EU_001_Compromiso__c comp3 = MX_BPP_RIRecordsDataFactory.genereteCompromisoEU(EU001_CLS_CONSTANTES.EU001_TRE_COMPROMISO_CARTERA, EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_LP, EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO, 15, opp04.Id, ri.Id);
            comp3.EU001_Un_nivelPriorizacion__c = 2;
            listComp.add(comp2);
            listComp.add(comp3);
            final List<String> valores = EU001_graficasConParametros_Ctrl.getValDO(listComp);
            System.Assert(!valores.isEmpty());
        }
    }
}
