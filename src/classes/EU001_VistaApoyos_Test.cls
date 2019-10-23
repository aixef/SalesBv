/**
*Proyecto:               Digital Workplace Retail
*Descripción:            Clase Test para la clase EU001_VistaApoyos_Ctrl
*
*Cambios (Versiones) prueba
*-------------------------------------------------------------------------------
*No.         Fecha            Autor                           Descripción
*------   ----------------   --------------------   ----------------------------
*1.0      21-06-2019         Cindy Hernández          Creación. Se crea a partir de la clase EU001_ConsolaDirector_test.
*1.0      21-06-2019         Cindy Hernández		  Se modifica el método getTableApoyo para aumentar la cobertura y se agrega el System.assert.
                                                      Se copia el método getTableApoyo para crear getTableApoyoDescartado y getTableApoyoHecho para
                                                      cubrir otras casuisticas. Se agrega el método vistaApoyosConstructor.
**/

@isTest
public  class EU001_VistaApoyos_Test {
    /**Mapa perfilMapa */
    static Map<String, Profile> perfilMapa = new Map<String, Profile>();
    /**Mapa RolMapa */
    static Map<String, UserRole> RolMapa = new Map<String, UserRole>();
    /** variable p*/
    static List<Profile> p;
    /** variable userRole*/
    static List<UserRole> userRole;

    static {
        p = new List<Profile>([SELECT Id, Name FROM Profile WHERE Name = 'BPyP Director Oficina']);
        userRole = new List<UserRole>([SELECT Id, Name FROM UserRole WHERE Name = 'BPYP DIRECTOR OFICINA LOMAS']);

        for(Profile perfil:p) {
            perfilMapa.put(perfil.Name, perfil);
        }
        for(UserRole ur:userRole) {
            RolMapa.put(ur.Name, ur);
        }
    }

    @isTest static void getTableApoyo() {
        final String Ug= '524689';
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
        test.startTest();
        System.runAs(u) {

            final EU001_RI__c ri = MX_BPP_UserAndRIDataFactory.creaRI(u.Id);
            insert ri;
			String errorMessage = '';
            try {
            	EU001_VistaApoyos_Ctrl.getTableApoyos(ri.Id,'Apoyos','');
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('', errorMessage);
        }
        test.stopTest();
    }

    @isTest static void getTableApoyoDescartado() {
        final String Ug= '524689';
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
        test.startTest();
        System.runAs(u) {
            final EU001_RI__c ri = MX_BPP_UserAndRIDataFactory.creaRI(u.Id);
            insert ri;
            String errorMessage = '';
            try {
            	EU001_VistaApoyos_Ctrl.getTableApoyos(ri.Id,'Apoyos','Descartado');
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('Script-thrown exception', errorMessage);
        }
        test.stopTest();
    }

    @isTest static void getTableApoyoHecho() {
        final String Ug= '524689';
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
        test.startTest();
        System.runAs(u) {
            final EU001_RI__c ri = MX_BPP_UserAndRIDataFactory.creaRI(u.Id);
            insert ri;
            String errorMessage = '';
            try {
            	EU001_VistaApoyos_Ctrl.getTableApoyos(ri.Id,'Apoyos','Hecho');
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('Script-thrown exception', errorMessage);
        }
        test.stopTest();
    }

    @isTest
    static void vistaApoyosConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        final EU001_VistaApoyos_Ctrl vistaApoyos = new EU001_VistaApoyos_Ctrl();
            System.assert(vistaApoyos != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }

}