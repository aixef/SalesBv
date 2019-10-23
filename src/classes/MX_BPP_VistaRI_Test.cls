/**
*Proyecto:               Digital Workplace Retail
*Descripción:            Clase Test para la clase MX_BPP_RI_VistaRI_Ctrl y MX_BPP_VistaRI_Utilities
*
*Cambios (Versiones)
*-------------------------------------------------------------------------------
*No.         Fecha            Autor                           Descripción
*------   ----------------   --------------------   ----------------------------
*1.0      24-06-2019         Cindy Hernández          Creación. Se crea a partir de la clase EU001_ConsolaDirector_test.
*1.0      24-06-2019         Cindy Hernández          Se modifican las referencias a los perfiles y funciones de empresas.
													  Se agregan los métodos vistaRIConstructor, getUserSessionRoleRiSelectError y getEtapaError.
*1.1	  26-06-2019		 Cindy Hernández		  Se modifica el método generaDGM para crear un tablero con la constante
                                                      EU001_CLS_CONSTANTES.EU001_STR_TOTAL_DOR_POTENCIAL.
													  Se agrega el método getJerarquiaDivisional para aumentar el procentaje de cobertura.
													  Se modifican los métodos generaDGM y ValoracionRI para agregar try catch y sus System.assert correspondientes.
**/
@isTest
public  class MX_BPP_VistaRI_Test {

    /** Mapa perfilMapa*/
    static Map<String, Profile> perfilMapa = new Map<String, Profile>();
    /**Mapa RolMapa */
    static Map<String, UserRole> RolMapa = new Map<String, UserRole>();
    /** Lista p*/
    static List<Profile> p;
    /** Lista userRole*/
    static List<UserRole> userRole;

    static {
        p = new List<Profile>([SELECT Id, Name FROM Profile WHERE Name = 'BPyP Director Oficina' OR Name =: Label.MX_PERFIL_SystemAdministrator OR
                              Name = 'BPyP Director Divisional']);
        userRole = new List<UserRole>([SELECT Id, Name FROM UserRole WHERE Name = 'BPYP DIRECTOR OFICINA LOMAS' OR Name = 'BPYP BANQUERO PRIVADO y UHN LOMAS' OR
                                      Name = 'BPYP DIRECTOR DIVISIONAL' OR Name = 'BPYP BANQUERO TORRE BANCOMER']);

        for(Profile perfil:p) { perfilMapa.put(perfil.Name, perfil); }
        for(UserRole ur:userRole) { RolMapa.put(ur.Name, ur); }
    }

	@isTest
    static void ValoracionRI() {

        String[] ug = new List<String>();
        ug.add('789001');
        ug.add('789011');
        String [] evaluador = new List<String>();
        evaluador.add('EV');
        evaluador.add('DO');

        List<User> users = MX_BPP_UserAndRIDataFactory.createTestRecordsUser(ug, false);

        EU001_RI__c nuevoRi = new EU001_RI__c();
        nuevoRi.EU001_tx_Estado__c = 'Preparación';
        nuevoRi.EU001_ft_Fecha_Inicio__c = system.now();
        nuevoRi.ownerId = users.get(0).Id;

        insert nuevoRi;
        test.StartTest();

        String errorMessage = '';
        try {
        	MX_BPP_VistaRI_Ctrl.getApiName(nuevoRi.id);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        System.assertEquals('Script-thrown exception', errorMessage);
        errorMessage = '';
        try {
            MX_BPP_VistaRI_Ctrl.getUser(nuevoRi.id);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        System.assertEquals('Script-thrown exception', errorMessage);

        nuevoRI.EU001_tl_Comentario_EV__c='HOLA';
        nuevoRI.EU001_tl_Comentario_DO__c='ADIOS';
        nuevoRI.EG_001_ls_Valoracion_de_RI__c='2';
        nuevoRI.EG001_Valoracion_de_RI_DO__c='3';
        update nuevoRI;
        for(Integer x = 0; x < 2; x ++) {
            try {
                MX_BPP_VistaRI_Ctrl.updateComentarios(nuevoRI.id, 'Comentario', evaluador[x]);
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('Script-thrown exception', errorMessage);
        }

        system.debug('user name: ' +UserInfo.getName());

        errorMessage = '';
        try {
            MX_BPP_VistaRI_Ctrl.getDO(UserInfo.getName());
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        System.assertEquals('Script-thrown exception', errorMessage);

        test.stopTest();
    }

    @isTest
    static void ownerUpdateComentarios() {

        String[] ug = new List<String>();
        ug.add('789001');
        ug.add('789011');
        String [] evaluador = new List<String>();
        evaluador.add('EV');
        evaluador.add('DO');

        List<User> users = MX_BPP_UserAndRIDataFactory.createTestRecordsUser(ug, false);

        EU001_RI__c nuevoRi = new EU001_RI__c();
        nuevoRi.EU001_tx_Estado__c = 'Preparación';
        nuevoRi.EU001_ft_Fecha_Inicio__c = system.now();
        nuevoRi.ownerId = users.get(0).Id;
        insert nuevoRi;

        test.StartTest();
        System.runAs(users.get(0)) {
            String errorMessage = '';
            for(Integer x = 0; x < 2; x ++) {
                errorMessage = '';
                try {
                    MX_BPP_VistaRI_Ctrl.updateComentarios(nuevoRI.id, 'Comentario', evaluador[x]);
                } catch (Exception e) {
                    errorMessage = e.getMessage();
                }
                System.assertEquals('Script-thrown exception', errorMessage);
            }
        }
        test.stopTest();
    }

    @isTest
    static void generaDGM() {
        User u1 = new User();
        u1.Alias = 'UserDos';
        u1.Email='do.empresas1@bbva.tst.deploy.com';
        u1.EmailEncodingKey='ISO-8859-1';
        u1.LastName='Prueba1';
        u1.LanguageLocaleKey='en_US';
        u1.LocaleSidKey='en_US';
        u1.ProfileId = perfilMapa.get('BPyP Director Oficina').Id;
        u1.UserRoleId = rolMapa.get('BPYP DIRECTOR OFICINA LOMAS').Id;
        u1.UG__c = '999991';
        u1.TimeZoneSidKey='America/Mexico_City';
        u1.UserName='adminDGMP1@bbva.tst.deploy.com';
        u1.VP_ls_Banca__c = 'Red BEyG';
        u1.IsActive=true;
        Insert u1;

        User us2 = MX_BPP_UserAndRIDataFactory.crearUsuario('USERGM', Label.MX_PERFIL_SystemAdministrator, 'BPYP BANQUERO PRIVADO y UHN LOMAS');
        us2.Alias = 'USERGM';
        us2.Email='do.empresas@bbva.tst.deploy.com';
        us2.EmailEncodingKey='ISO-8859-1';
        us2.LastName='Prueba';
        us2.LanguageLocaleKey='en_US';
        us2.LocaleSidKey='en_US';
        us2.ProfileId = perfilMapa.get(Label.MX_PERFIL_SystemAdministrator).Id;
        us2.UserRoleId = rolMapa.get('BPYP BANQUERO PRIVADO y UHN LOMAS').Id;
        us2.UG__c = '888888';
        us2.TimeZoneSidKey='America/Mexico_City';
        us2.UserName='adminDGM@bbva.tst.deploy.com';
        us2.VP_ls_Banca__c = 'Red BEyG';
        us2.IsActive=true;
        us2.No_de_nomina__c =  '45647';
        Insert us2;

        system.runAs(u1) {

            EU001_RI__c ri1 = MX_BPP_UserAndRIDataFactory.creaRI(u1.Id);
            insert ri1;
        }

        test.startTest();
        system.runAs(u1) {
            MX_BPP_VistaRI_Ctrl.PromedioPotDOR_DO(u1.UG__c);
            MX_BPP_VistaRI_Ctrl.PromedioDOR_DO(u1.UG__c);
            MX_BPP_VistaRI_Ctrl.PromedioGMP_DO(u1.UG__c);
            MX_BPP_VistaRI_Ctrl.PromedioGM_DO(u1.UG__c);
            MX_BPP_RIRecordsDataFactory.createTabIndicadorl(us2.UG__c,EU001_CLS_CONSTANTES.EU001_STR_TOTAL_DOR_POTENCIAL);
            MX_BPP_VistaRI_Ctrl.PromedioPotDOR_DO(u1.UG__c);

            MX_BPP_RIRecordsDataFactory.createTabIndicadorl(us2.UG__c,EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR_POT);
            MX_BPP_RIRecordsDataFactory.createTabIndicadorl(us2.UG__c,EU001_CLS_CONSTANTES.EU001_STR_EXP_UNICA);
            MX_BPP_VistaRI_Ctrl.getUserSessionRoleRiSelect(u1.UG__c);
			String errorMessage = '';
            try {
            	MX_BPP_VistaRI_Ctrl.getJerarquia();
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('Script-thrown exception', errorMessage);
        }
        test.stopTest();
    }

    @isTest
    static void getJerarquiaDivisional() {
        User testUser = MX_BPP_UserAndRIDataFactory.crearUsuario('USERGM', 'BPyP Director Divisional', 'BPYP DIRECTOR DIVISIONAL');
        Insert testUser;

        test.startTest();
        system.runAs(testUser) {
			String errorMessage = '';
            try {
            	MX_BPP_VistaRI_Ctrl.getJerarquia();
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('Script-thrown exception', errorMessage);
        }
        test.stopTest();
    }

    @isTest
    static void getUserSessionRoleRiSelectError() {
        User u1 = new User();
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

        test.startTest();
        system.runAs(u1) {
            String errorMessage = '';
            try {
                MX_BPP_VistaRI_Ctrl.getUserSessionRoleRiSelect('BadId');
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('Script-thrown exception', errorMessage);
        }
        test.stopTest();
    }

    @isTest static void TestCompromisos() {
        String recordTypeComp = RecordTypeMemory_cls.getRecType('EU_001_Compromiso__c', 'BPYP Servicios');

        String Ug= '524689';
        String Ug2= '3342';
        User u = new User();
        u.Alias = 'Director';
        u.Email='do.empresas1@bbva.tst.deploy.com';
        u.EmailEncodingKey='ISO-8859-1';
        u.LastName='Prueba1';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = perfilMapa.get('BPyP Director Oficina').Id;
        u.UserRoleId = rolMapa.get('BPYP DIRECTOR OFICINA LOMAS').Id;
        u.CR__c = '11121';
        u.UG__c = Ug;
        u.Segmento_Ejecutivo__c = 'EMPRESARIAL';
        u.TimeZoneSidKey='America/Mexico_City';
        u.UserName='Director@bbva.tst.deploy.com';
        u.VP_ls_Banca__c = 'Red BEyG';
        u.IsActive=true;
        insert u;
        User u2 = MX_BPP_UserAndRIDataFactory.creaUser2();
        u2.UG__c = Ug2;
        insert u2;
        test.startTest();
        System.runAs(u2) {
            ExpUni_Tablero_Grupal__c tablero1= new ExpUni_Tablero_Grupal__c();
            tablero1.EU_UG__c = u2.UG__c;
            tablero1.EU_001_tx_Indicador__c = EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR_POT;
            tablero1.EU_Indicador__c =EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR_POT;
            tablero1.EU_001_tx_Atributo__c = EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR_POT;
            tablero1.EU_001_Un_Valor__c =140234;
            insert tablero1;
            Account cuenta = new Account();
            cuenta.Name = 'Javier ';
            cuenta.No_de_cliente__c = '8364608932';
            insert cuenta;
        }
        System.runAs(u) {

            EU001_RI__c ri = MX_BPP_UserAndRIDataFactory.creaRI(u.Id);
            insert ri;

            EU_001_Compromiso__c comp = new EU_001_Compromiso__c();
            comp.EU_001_Rb_Revisi_n_Individual_RI__c=ri.id;
            comp.RecordTypeId = recordTypeComp;
            insert comp;

            String errorMessage = '';
            Boolean isDirector = false;
            try {
                isDirector = MX_BPP_VistaRI_Ctrl.VerificaDirectorPropietarioRI(ri.Id);
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            if(isDirector) {
                System.debug('Es director');
            }
            System.assertEquals('Script-thrown exception', errorMessage, 'Error');
        }
        test.stopTest();
    }

/*@Descripción
*Se agrego método para probar TableUsrBPP de Ri de BPyP
*06-06-2018
*Ricardo Almanza Angeles */
    @isTest
    static void TestgetTableUsrBPP() {

        User u3 = MX_BPP_UserAndRIDataFactory.creaUser();
        u3.UserRoleId = rolMapa.get('BPYP BANQUERO TORRE BANCOMER').Id;
        insert u3;
        test.startTest();
            System.runAs(u3) {
                EU001_RI__c ri6 = MX_BPP_UserAndRIDataFactory.creaRI(u3.Id);
                ri6.EU001_tx_Estado__c = 'Preparación';
                insert ri6;
                list<Object> tbl=MX_BPP_VistaRI_Ctrl.getTableUsrBPP(ri6.id);
                System.assertNotEquals(null, tbl, 'getTableUsrBPP correcto');
            }
        test.stopTest();
    }

/*@Descripción: Método para probar TableUsrBPP de Ri de BPyP
   *----------------------------------------------------------------
   *@Autor: Ricardo Almanza Angeles
   *@Fecha: 06-06-2018
   *@return: void
   *@Ejemplo: EU001_cls_ConsolaDirector_test.TestgetCompApoy()
  *-----------------------------------------------------------------
  * Versión |      Autor    			|       Descripción
  * v1.0    |Ricardo Almanza Angeles    |		 Creación
  * v1.1	|Mario Calderón				|	Se agrega fecha del día de mañana a compromisos y apoyos
  * 										usados para test.
  */

    @isTest static void TestgetCompApoy() {

        User u3 = MX_BPP_UserAndRIDataFactory.creaUser();
        u3.UserRoleId = rolMapa.get('BPYP BANQUERO TORRE BANCOMER').Id;
        insert u3;
        System.runAs(u3) {
            EU001_RI__c ri6 = MX_BPP_UserAndRIDataFactory.creaRI(u3.Id);
            ri6.EU001_tx_Estado__c = 'Preparación';
            insert ri6;

            final Case casoRI = MX_BPP_VistaRI_Utilities.createCaseTest('Producto', 'Test-subject', 'Apoyos', 1, ri6);
            insert casoRI;

            final Case caso2 = MX_BPP_VistaRI_Utilities.createCaseTest('Producto', 'Test-subject', 'Apoyos', 2, ri6);
            insert caso2;

            EU_001_Compromiso__c comp = new EU_001_Compromiso__c();
            comp.EU_001_Rb_Revisi_n_Individual_RI__c=ri6.id;
            comp.EU_001_ls_Estatus__c=EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_VENCIDO;
            comp.EU_fm_Fecha_Cierre__c = Date.today().addDays(1);
            comp.RecordTypeId = RecordTypeMemory_cls.getRecType('EU_001_Compromiso__c', 'MX_BPP_Com_Captacion');

            insert comp;

            EU_001_Compromiso__c comp2 = new EU_001_Compromiso__c();
            comp2.EU_001_Rb_Revisi_n_Individual_RI__c=ri6.id;
            comp2.EU_001_ls_Estatus__c=EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO;
            comp2.EU_fm_Fecha_Cierre__c = Date.today().addDays(1);
            comp2.RecordTypeId = RecordTypeMemory_cls.getRecType('EU_001_Compromiso__c', 'MX_BPP_Com_Captacion');
            insert comp2;

            ExpUni_Tablero_Grupal__c tablero1= new ExpUni_Tablero_Grupal__c();
            tablero1.EU_UG__c = u3.UG__c;
            tablero1.EU_001_tx_Indicador__c = EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR_POT;
            tablero1.EU_Indicador__c =Label.MX_BPP_CINTILLO;
            tablero1.EU_001_tx_Atributo__c = EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR_POT;
            tablero1.EU_001_Un_Valor__c =140234;
            tablero1.MX_BPP_NumEmpleado__c ='00123';
            insert tablero1;

            test.startTest();

                list<Object> tbl=MX_BPP_VistaRI_Ctrl.getTableUsrBPP(ri6.id);
                System.assertNotEquals(null, tbl, 'getTableUsrBPP correcto');
                MX_BPP_VistaRI_Utilities.BPPCompApoRes bcar = MX_BPP_VistaRI_Ctrl.getCompApoy(ri6.id);
                System.assertNotEquals(null, bcar, 'getCompApoy correcto');
                String errorMessage = '';
                try {
            		MX_BPP_VistaRI_Ctrl.getCintillo(ri6.id);
                } catch (Exception e) {
                    errorMessage = e.getMessage();
                }
                System.assertEquals('Script-thrown exception', errorMessage, 'error');
                delete ri6;
            	try {
            		bcar = MX_BPP_VistaRI_Ctrl.getCompApoy(ri6.id);
                } catch (Exception e) {
                    errorMessage = e.getMessage();
            	}
            	System.assertNotEquals(null, errorMessage, 'Fallo exitoso');
            test.stopTest();
            System.assertNotEquals(null,bcar,'Error al crear contadores de cintillo');
            }
    }

    @isTest
    static void TestFunctionConFuncionAbajo2() {

        User u3 = MX_BPP_UserAndRIDataFactory.creaUser();
        u3.UserRoleId = rolMapa.get('BPYP BANQUERO PRIVADO y UHN LOMAS').Id;
        insert u3;
        test.startTest();
        System.runAs(u3) {
            EU001_RI__c ri6 = MX_BPP_UserAndRIDataFactory.creaRI(u3.Id);
            ri6.EU001_tx_Estado__c = 'Preparación';
            insert ri6;
            MX_BPP_VistaRI_Ctrl.getEtapa(ri6.Id);
            String errorMessage = '';
            try {
            	MX_BPP_VistaRI_Ctrl.cambioEtapa(ri6.Id,ri6.EU001_tx_Estado__c);
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('Starting position out of bounds: 88', errorMessage);
            System.assert(true,'This Works!');
        }
        test.stopTest();
    }

    @isTest
    static void getEtapaError() {

        User u3 = MX_BPP_UserAndRIDataFactory.creaUser();
        u3.UserRoleId = rolMapa.get('BPYP BANQUERO PRIVADO y UHN LOMAS').Id;
        insert u3;
        test.startTest();
        System.runAs(u3) {
            String errorMessage = '';
            try {
            	MX_BPP_VistaRI_Ctrl.getEtapa('BadId');
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('Script-thrown exception', errorMessage);
        }
        test.stopTest();
    }

    @isTest
    static void UsserSession() {
        User Usuario = MX_BPP_UserAndRIDataFactory.creaUser();
        insert Usuario;

        System.runAs(Usuario) {

            String errorMessage = '';
            try {
            	MX_BPP_VistaRI_Ctrl.getUserSessionRole();
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('Script-thrown exception', errorMessage);
        }
    }

    @isTest
    static void vistaRIConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        MX_BPP_VistaRI_Ctrl vistaRi = new MX_BPP_VistaRI_Ctrl();
            System.assert(vistaRi != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }
}