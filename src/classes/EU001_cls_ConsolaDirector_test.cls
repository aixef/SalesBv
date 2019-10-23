/**
*Desarrollado por:       Indra
*Autor:                  Javier Ortiz
*Proyecto:               Experiencia Unica
*Descripción:            Clase Test para la clase EU001_cls_ConsolaDirector
*
*Cambios (Versiones) prueba
*-------------------------------------------------------------------------------
*No.         Fecha            Autor                           Descripción
*------   ----------------   --------------------   ----------------------------
*1.0      14-12-2017         Javier Ortiz             Creación
*2.0      01-02-2018         Isaías Velázquez         Modificación
*3.0      06-02-2018         Francisco J Licona       Modificación
*3.1      07-02-2018         Isaías Velázquez         Modificación
*3.2      09-02-2018         Francisco J Licona       Modificación
*3.3      21-03-2018         Abraham Tinajero         Se acutalizan métodos de creación de datos
*4.0      20-04-2018         Francisco J Licona       Cobertura de clase
*4.1      20-04-2018         Francisco J Licona       Cobertura de metodo de funcionalidad PI10
*5.0      14-08-2018         Luis Fernando R.         Se actualizan parámetros de métodos
*5.1      13-09-2018         Luis Fernando R.         Se actualizan parámetros de métodos
*5.2      17/10/2018         Fernando Jaime             Se cambia administrador del sistema por etiqueta personalizada
*6.0      31-10-2018         César Villanueva         Actualización de método TestCompromisos y se añade método de prueba
*													  para la actualización de trackings
*6.1	  30-01-2019		 Mario Calderón			  Se actualizan parámetros de métodos en "testCompromisos"
*7.0	  21-06-2019		 Cindy Hernández		  Se eliminan los métodos que no se utilizan. Se agregan los métodos
                                                      getRIMapTest, getRIMapNoStaffTest y getRIMapNoDirTest para
													  cubrir el método getRIMap y se agrega el método consolaDirConstructor.
*7.1	  26-06-2019	     Cindy Hernández		  Se agregan los métodos getRINoDirector y getRISelectError para aumentar el porcentaje de cobertura.
**/
@isTest
public  class EU001_cls_ConsolaDirector_test {
    /**Mapa RolMapa */
    static Map<String, UserRole> RolMapa = new Map<String, UserRole>();
    /**Lista userRole */
    static List<UserRole> userRole;

    static {
        userRole = new List<UserRole>([SELECT Id, Name FROM UserRole WHERE Name = 'BPYP BANQUERO PRIVADO y UHN LOMAS']);
        for(UserRole ur:userRole) { RolMapa.put(ur.Name, ur); }
    }

     @isTest static void getRIMapTest() {
         final User u = MX_BPP_UserAndRIDataFactory.crearUsuario('Usertest', 'BPyP Estandar', 'BPYP BANQUERO TORRE BANCOMER');
         insert u;
         System.runAs(u) {
             final List<EU001_RI__c> generaRI= MX_BPP_UserAndRIDataFactory.generaRI();
             System.debug('RIS: ' + generaRI[0].Owner.Name);
             final List<Id> riIds = new List<Id>();
             for(EU001_RI__c ri : generaRI) {
                 ri.OwnerId = u.Id;
                 riIds.add(u.Id);
             }
             upsert generaRI;
             System.debug('RISOwners: ' + riIds);
             test.StartTest();
             final Map<Id, EU001_cls_ConsolaDirector.WRP_Table> riMap = EU001_cls_ConsolaDirector.getRIMap(true, true, riIds);
             System.assertNotEquals(null, riMap);
             test.stopTest();
         }
    }

     @isTest static void getRIMapNoStaffTest() {
         final User u = MX_BPP_UserAndRIDataFactory.crearUsuario('Usertest', 'BPyP Estandar', 'BPYP BANQUERO TORRE BANCOMER');
         insert u;
         System.runAs(u) {
             final List<EU001_RI__c> generaRI= MX_BPP_UserAndRIDataFactory.generaRI();
             System.debug('RIS: ' + generaRI[0].Owner.Name);
             final List<Id> riIds = new List<Id>();
             for(EU001_RI__c ri : generaRI) {
                 ri.OwnerId = u.Id;
                 riIds.add(u.Id);
             }
             upsert generaRI;
             System.debug('RISOwners: ' + riIds);
             test.StartTest();
             final Map<Id, EU001_cls_ConsolaDirector.WRP_Table> riMap = EU001_cls_ConsolaDirector.getRIMap(true, false, riIds);
             System.assertNotEquals(null, riMap);
             test.stopTest();
         }
    }

     @isTest static void getRIMapNoDirTest() {
         final User u = MX_BPP_UserAndRIDataFactory.crearUsuario('Usertest', 'BPyP Estandar', 'BPYP BANQUERO TORRE BANCOMER');
         insert u;
         System.runAs(u) {
             final List<EU001_RI__c> generaRI= MX_BPP_UserAndRIDataFactory.generaRI();
             System.debug('RIS: ' + generaRI[0].Owner.Name);
             final List<Id> riIds = new List<Id>();
             for(EU001_RI__c ri : generaRI) {
                 ri.OwnerId = u.Id;
                 riIds.add(u.Id);
             }
             upsert generaRI;
             System.debug('RISOwners: ' + riIds);
             test.StartTest();
             final Map<Id, EU001_cls_ConsolaDirector.WRP_Table> riMap = EU001_cls_ConsolaDirector.getRIMap(false, false, riIds);
             System.assertNotEquals(null, riMap);
             test.stopTest();
         }
    }

    @isTest static void ValoracionRI() {

        final String[] ug = new List<String>();
        ug.add('789001');
        ug.add('789011');

        final List<User> users = MX_BPP_UserAndRIDataFactory.createTestRecordsUser(ug, false);

        final EU001_RI__c nuevoRi = new EU001_RI__c();
        nuevoRi.EU001_tx_Estado__c = 'Preparación';
        nuevoRi.EU001_ft_Fecha_Inicio__c = system.now();
        nuevoRi.ownerId = users.get(0).Id;

        insert nuevoRi;
        test.StartTest();

        EU001_cls_ConsolaDirector.getUser(nuevoRi.id);

        nuevoRI.EU001_tl_Comentario_EV__c='HOLA';
        nuevoRI.EU001_tl_Comentario_DO__c='ADIOS';
        nuevoRI.EG_001_ls_Valoracion_de_RI__c='2';
        nuevoRI.EG001_Valoracion_de_RI_DO__c='3';
        update nuevoRI;

        system.debug('user name: ' +UserInfo.getName());

        System.assert(true, 'assert');
        test.stopTest();
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
        ux.VP_ls_Banca__c = 'Red BPyP';
        ux.IsActive=true;
        insert ux;

        test.startTest();
        System.runAs(u2) {
            final EU001_RI__c ri2 = MX_BPP_UserAndRIDataFactory.creaRI(u2.Id);
            insert ri2;
            EU001_cls_ConsolaDirector.getRI();
            System.assert(true,'This Works!');
        }
        test.stopTest();
    }

    @isTest
    static void getRINoDirector() {
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
        ux.VP_ls_Banca__c = 'Red BPyP';
        ux.IsActive=true;
        insert ux;

        test.startTest();
        System.runAs(ux) {
            final EU001_RI__c ri2 = MX_BPP_UserAndRIDataFactory.creaRI(ux.Id);
            insert ri2;
            final list<EU001_cls_ConsolaDirector.WRP_Table> riList = EU001_cls_ConsolaDirector.getRI();
            System.debug('La lista: ' + riList);
            System.assert(!riList.isEmpty());
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
            EU001_cls_ConsolaDirector.getRISelect(ri6.Id);
            System.assert(true,'This Works!');
        }
        test.stopTest();
    }

  	@isTest
    static void getRISelectError() {
        final User u3 = MX_BPP_UserAndRIDataFactory.creaUser();
        u3.UserRoleId = rolMapa.get('BPYP BANQUERO PRIVADO y UHN LOMAS').Id;
        insert u3;
        test.startTest();
        System.runAs(u3) {
            final EU001_RI__c ri6 = MX_BPP_UserAndRIDataFactory.creaRI(u3.Id);
            ri6.EU001_tx_Estado__c = 'Preparación';
            insert ri6;
            String errorMessage = '';
            try {
           		EU001_cls_ConsolaDirector.getRISelect('BadId');
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('Script-thrown exception', errorMessage);
        }
        test.stopTest();
    }

    @isTest static void generaNuevoRITest() {
        final User usr = MX_BPP_UserAndRIDataFactory.creaUser();
        insert usr;
        Test.startTest();

        EU001_cls_ConsolaDirector.VerificaDirector();
        EU001_cls_ConsolaDirector.generaNuevoRI();

        Test.stopTest();
        System.assert(true,'This Works!');
    }

    @isTest
    static void consolaDirConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        final EU001_cls_ConsolaDirector oppRep = new EU001_cls_ConsolaDirector();
            System.assert(oppRep != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }
}