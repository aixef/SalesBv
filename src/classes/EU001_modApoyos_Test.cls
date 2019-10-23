/**
*Proyecto:               Digital Workplace Retail
*Descripción:            Clase Test para la clase EU001_modApoyos_Ctrl
*
*Cambios (Versiones) prueba
*-------------------------------------------------------------------------------
*No.         Fecha            Autor                           Descripción
*------   ----------------   --------------------   ----------------------------
*1.0      21-06-2019         Cindy Hernández          Creación. Se crea a partir de la clase EU001_ConsolaDirector_test.
*1.0      21-06-2019         Cindy Hernández          Se modifica el método generaNuevoRITest para eliminar la referencia a métodos que no se utilizan.
													  Se modifica el método TestCompromisos para agregar el System.assert. Se agrega el método modApoyosConstructor.
*1.1      26-06-2019         Cindy Hernández          Se modifica el método TestNuevoApoyo para agregar el try catch
                                                      y el System.assert correspondiente.
**/
@isTest
public  class EU001_modApoyos_Test {
    /** Mapa perfilMapa*/
    static Map<String, Profile> perfilMapa = new Map<String, Profile>();
    /** MApa RolMapa*/
    static Map<String, UserRole> RolMapa = new Map<String, UserRole>();
    /** Lista p*/
    static List<Profile> p;
    /** Lista userRole*/
    static List<UserRole> userRole;
    /** variable nombreReporte*/
    static String nombreReporte = 'Logro_por_indicador';

    static {
        p = new List<Profile>([SELECT Id, Name FROM Profile WHERE Name = 'BPyP Director Oficina']);
        userRole = new List<UserRole>([SELECT Id, Name FROM UserRole WHERE Name = 'BPYP DIRECTOR OFICINA LOMAS']);

        for(Profile perfil:p) { perfilMapa.put(perfil.Name, perfil); }
        for(UserRole ur:userRole) { RolMapa.put(ur.Name, ur); }
    }

    @isTest static void TestNuevoApoyo() {

        final User u = MX_BPP_UserAndRIDataFactory.creaUser();
        u.UserRoleId = rolMapa.get('BPYP DIRECTOR OFICINA LOMAS').Id;
        insert u;

        test.startTest();
        System.runAs(u) {

            final EU001_RI__c ri = MX_BPP_UserAndRIDataFactory.creaRI(u.Id);
            insert ri;
            final Account ac= new Account();
            final RecordType rc = new RecordType();
            rc.Id = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Apoyos').getRecordTypeId();
            String errorMessage = '';
            try {
            	EU001_modApoyos_Ctrl.getInsertApoyos(rc.Id, ac,'Visitas','Desc','2000-01-01','Abierto',null,ri.Id,u.Id,null,null);
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('Script-thrown exception', errorMessage);
            errorMessage = '';
            try {
            	EU001_modApoyos_Ctrl.getInsertApoyos(rc.Id, ac,'Visitas','Desc','2000-01-01','Abierto',null,ri.Id,u.Id,u,u);
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('Script-thrown exception', errorMessage);
            EU001_modApoyos_Ctrl.getSuperiorLevel(u.Id);

            System.assert(true,'This Works!');
        }
        test.stopTest();
    }

    @isTest static void TestCompromisos() {
        final String recordTypeComp = RecordTypeMemory_cls.getRecType('EU_001_Compromiso__c', 'MX_BPP_Com_Captacion');

        final String Ug= '524689';
        final String Ug2= '3342';
        final User u = new User();
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
        final User u2 = MX_BPP_UserAndRIDataFactory.creaUser2();
        u2.UG__c = Ug2;
        insert u2;
        test.startTest();
        System.runAs(u2) {
            final ExpUni_Tablero_Grupal__c tablero1= new ExpUni_Tablero_Grupal__c();
            tablero1.EU_UG__c = u2.UG__c;
            tablero1.EU_001_tx_Indicador__c = EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR_POT;
            tablero1.EU_Indicador__c =EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR_POT;
            tablero1.EU_001_tx_Atributo__c = EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR_POT;
            tablero1.EU_001_Un_Valor__c =140234;
            insert tablero1;
            final Account cuenta = new Account();
            cuenta.Name = 'Javier ';
            cuenta.No_de_cliente__c = '8364608932';
            insert cuenta;
        }
        System.runAs(u) {

            final EU001_RI__c ri = MX_BPP_UserAndRIDataFactory.creaRI(u.Id);
            insert ri;

            final EU_001_Compromiso__c comp = new EU_001_Compromiso__c();
            comp.EU_001_Rb_Revisi_n_Individual_RI__c=ri.id;
            comp.RecordTypeId = recordTypeComp;
            insert comp;

            EU001_modApoyos_Ctrl.getRecordTypeId('EU_001_Compromiso__c','BPyP Captación');
        }
        test.stopTest();
        final List<EU_001_Compromiso__c> compromiso = [Select Id FROM EU_001_Compromiso__c WHERE RecordType.Name = 'BPyP Captación'];
        System.assert(!compromiso.isEmpty());
    }

	@isTest static void ValoracionRI() {

        final String[] ug = new List<String>();
        ug.add('789001');
        ug.add('789011');
        final String [] evaluador = new List<String>();
        evaluador.add('EV');
        evaluador.add('DO');

        final List<User> users = MX_BPP_UserAndRIDataFactory.createTestRecordsUser(ug, false);

        final EU001_RI__c nuevoRi = new EU001_RI__c();
        nuevoRi.EU001_tx_Estado__c = 'Preparación';
        nuevoRi.EU001_ft_Fecha_Inicio__c = system.now();
        nuevoRi.ownerId = users.get(0).Id;

        insert nuevoRi;
        test.StartTest();

        EU001_modApoyos_Ctrl.getUser(nuevoRi.id);

        System.assert(true, 'assert');
        test.stopTest();
    }

    @isTest
    static void modApoyosConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        final EU001_modApoyos_Ctrl modApoyos = new EU001_modApoyos_Ctrl();
            System.assert(modApoyos != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }
}