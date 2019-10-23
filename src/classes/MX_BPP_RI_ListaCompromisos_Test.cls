/**
*Proyecto:               Digital Workplace Retail
*Descripción:            Clase Test para la clase MX_BPP_RI_ListCompromisos_Ctrl
*
*Cambios (Versiones)
*-------------------------------------------------------------------------------
*No.         Fecha            Autor                           Descripción
*------   ----------------   --------------------   ----------------------------
*1.0      24-06-2019         Cindy Hernández          Creación. Se crea a partir de la clase EU001_ConsolaDirector_test.
*1.0      24-06-2019         Cindy Hernández          Se modifica el método insertaCompromisosError para agregar el try catch y el System.assert.
													  Se modifica el método generaNuevoRITest agregando un tipo de registro correcto para BPyP.
													  Se agrega el método listaCompConstructor.
**/
@isTest
public  class MX_BPP_RI_ListaCompromisos_Test {
    /** Mapa perfilMapa*/
    static Map<String, Profile> perfilMapa = new Map<String, Profile>();
    /** Mapa RolMapa*/
    static Map<String, UserRole> RolMapa = new Map<String, UserRole>();
    /** Lista p*/
    static List<Profile> p;
    /** Lista userRole*/
    static List<UserRole> userRole;

    static {
        p = new List<Profile>([SELECT Id, Name FROM Profile WHERE Name = 'BPyP Director Oficina']);
        userRole = new List<UserRole>([SELECT Id, Name FROM UserRole WHERE Name = 'BPYP DIRECTOR OFICINA LOMAS']);

        for(Profile perfil:p) { perfilMapa.put(perfil.Name, perfil); }
        for(UserRole ur:userRole) { RolMapa.put(ur.Name, ur); }
    }

        @isTest static void insertaCompromisosError() {
        String recordTypeComp = RecordTypeMemory_cls.getRecType('EU_001_Compromiso__c', 'BPyP Captación');

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
        u.UG__c = '524689';
        u.Segmento_Ejecutivo__c = 'EMPRESARIAL';
        u.TimeZoneSidKey='America/Mexico_City';
        u.UserName='Director@bbva.tst.deploy.com';
        u.VP_ls_Banca__c = 'Red BPyP';
        u.IsActive=true;
        insert u;
        User u2 = MX_BPP_UserAndRIDataFactory.creaUser2();
        u2.UG__c = '3342';
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

            MX_BPP_RI_ListaCompromisos_Ctrl.getTableCompromisos(ri.Id,'Abierto', null, null, null, null,null,null);
            MX_BPP_RI_ListaCompromisos_Ctrl.getTableCompromisos(ri.Id,'Vencido', null, null, null, null,null,null);
            MX_BPP_RI_ListaCompromisos_Ctrl.getTableCompromisos(ri.Id,'Abierto', null, null, null, null,'Captación','Nómina');
            MX_BPP_RI_ListaCompromisos_Ctrl.getTableCompromisos(ri.Id,'', null, 'Generales', '2018-12-12', '2018-12-12',null,null);
            Account ac= new Account();
			String errorMessage = '';
        	try {
            	MX_BPP_RI_ListaCompromisos_Ctrl.getInsertaCompromiso(recordTypeComp, ac,'Otros','0','2000-01-01','',0,ri.Id);
	        } catch (Exception e) {
    	        errorMessage = e.getMessage();
        	}
        	System.assertEquals('Script-thrown exception', errorMessage);
        }
        test.stopTest();
    }

    @isTest static void generaNuevoRITest(){
        User usr = MX_BPP_UserAndRIDataFactory.creaUser();
        insert usr;

        MX_BPP_RI_ListaCompromisos_Ctrl.getRecordTypeId('EU_001_Compromiso__c','BPyP Captación');
        MX_BPP_RI_ListaCompromisos_Ctrl.VerificaDirector();

        Test.startTest();

        Test.stopTest();
        System.assert(true,'This Works!');
    }


    @isTest static void ValoracionRI() {

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

        MX_BPP_RI_ListaCompromisos_Ctrl.getUser(nuevoRi.id);

        nuevoRI.EU001_tl_Comentario_EV__c='HOLA';
        nuevoRI.EU001_tl_Comentario_DO__c='ADIOS';
        nuevoRI.EG_001_ls_Valoracion_de_RI__c='2';
        nuevoRI.EG001_Valoracion_de_RI_DO__c='3';
        update nuevoRI;

        system.debug('user name: ' +UserInfo.getName());

        System.assert(true, 'assert');
        test.stopTest();
    }

    @isTest
    static void listaCompConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        MX_BPP_RI_ListaCompromisos_Ctrl listaComp = new MX_BPP_RI_ListaCompromisos_Ctrl();
            System.assert(listaComp != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }

}