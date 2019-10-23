/**
* ------------------------------------------------------------------------------------------------
* @Name     MX_BPP_UserAndRIDataFactory
* @Author   Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* @Date     Created: 2019-07-02
* @Group    Digital Workplace Retail
* @Description Create the data for the test classes for RI(BPyP) functionality.
* @Comments Created from the clipped code from the UtilitysDataTest_tst and EU_cls_TestData classes.
            Se dejan los comentarios de las clases origen relacionados a métodos contenidos en esta clase.
* @Changes
**/

/*----------------------------------Desarrollado por INDRA--------------------------------
UtilitysDataTest_tst
*Autor:         Trabajo en Equipo
*Proyecto:      MAX - BBVA Bancomer
*Descripción:   Clase para crear los Datos de prueba generales de utilería para ser usados
                en las demas clases de prueba
*_______________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        22/MAR/2018     Sergio Ortiz                        Creación.
*1.5	    23/08/2018	    Francisco J Licona			        Se agrega método que retorna objeto de reunión individual.
                                                                Se corrigen Parametros de entrada en algunos metodos.
-----------------------------------------------------------------------------------------*/

/**
EU_cls_TestData
*Desarrollado por:       Indra
*Autor:                  Abraham Alfonso Tinajero Sánchez
*Proyecto:               Experiencia Única
*Descripción:            ClaseTest para generar información de prueba
*
*Cambios (Versiones)
*-------------------------------------------------------------------------------
*No.         Fecha           Autor                          Descripción
*------   ----------------   --------------------          ---------------
*1.0      07-08-2017         Abraham Tnajero                Creación
*2.0      15-03-2018         Abraham Tnajero                Se optimizan métodos
**/
@isTest
public class MX_BPP_UserAndRIDataFactory {
    /**Mapa perfilMapa */
    static Map<String, Profile> perfilMapa = new Map<String, Profile>();
    /** rolMapa*/
    static Map<String, UserRole> rolMapa   = new Map<String, UserRole>();
    /** Lista lstProfile*/
    static List<Profile> lstProfile;
    /** Lista userRole*/
    static List<UserRole> userRole;

    static {
        lstProfile = new List<Profile>([SELECT Id, Name FROM Profile WHERE NOT(Name = null)]);
        userRole   = new List<UserRole>([SELECT Id, Name FROM UserRole WHERE NOT(Name = null)]);
        for(Profile perfil:lstProfile) { perfilMapa.put(perfil.Name, perfil); }
        for(UserRole ur:userRole) { rolMapa.put(ur.Name, ur); }
    }
    /** Lista*/
    public  static List<User> createTestRecordsUser(String[] ug, Boolean bandera) {
        final List<User> usuarios = new List<User>();

        final Profile perfil = [SELECT ID FROM PROFILE WHERE NAME = : System.Label.MX_PERFIL_SystemAdministrator Limit 1];
        final UserRole rolPerfil = [SELECT ID, NAME FROM USERROLE WHERE NAME LIKE '%DIRECTOR OFICINA%' Limit 1];
        final UserRole rolPerfilEC = [SELECT ID, NAME FROM USERROLE WHERE parentroleid= :rolPerfil.Id Limit 1];

        for(Integer i=0;i<ug.size();i++) {
            final User usrTst = new User();
            usrTst.Username =EU001_CLS_CONSTANTES.EU001_STR_USERNAME+i+EU001_CLS_CONSTANTES.EU001_STR_CORREO_GMAL;
            usrTst.isActive = true;
            usrTst.FirstName = EU001_CLS_CONSTANTES.EU001_STR_USER_NAME+i;
            usrTst.LastName= EU001_CLS_CONSTANTES.EU001_STR_USER_LASTNAME+i;
            usrTst.Email= EU001_CLS_CONSTANTES.EU001_STR_USERNAME+i+EU001_CLS_CONSTANTES.EU001_STR_CORREO_GMAL;
            usrTst.Alias= EU001_CLS_CONSTANTES.EU001_STR_ALIAS+i;
            usrTst.TimeZoneSidKey= EU001_CLS_CONSTANTES.EU001_STR_ZONA_HORARIA;
            usrTst.LocaleSidKey= EU001_CLS_CONSTANTES.EU001_STR_IDIOMA;
            usrTst.EmailEncodingKey= EU001_CLS_CONSTANTES.EU001_STR_ENCODING;
            usrTst.ProfileId= perfil.Id;
            usrTst.LanguageLocaleKey =EU001_CLS_CONSTANTES.EU001_STR_CLAVE_IDIOMA;
            usrTst.VP_ls_Banca__c = EU001_CLS_CONSTANTES.EU001_STR_BANCA;
            usrTst.UG__c = ug[i];
            usrTst.EU001_un_Meta_Reuni_n_Individual__c = 12;
            usrTst.Director_de_oficina__c=UserInfo.getUserId();
            usrTst.EG001_ls_Certificacion_EU__c = EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION;
            usrTst.No_de_nomina__c =EU001_CLS_CONSTANTES.EU001_STR_EMPIEZA_NOMINA+i;
            usrTst.Segmento_Ejecutivo__c = EU001_CLS_CONSTANTES.EU001_STR_LIGA_EJECUTIVO;
			usrTst.EmployeeNumber = '16736' + i;
            usuarios.add(usrTst);
        }

        insert usuarios;

        usuarios.get(0).Director_de_oficina__c = usuarios.get(1).Id;
        if(bandera) {
            usuarios.get(0).UserRoleId = rolPerfilEC.Id;
            usuarios.get(1).UserRoleId = rolPerfil.Id;
        }

        update usuarios;
        return usuarios;
    }
    /** Lista generaRI*/
    public  static List<EU001_RI__c> generaRI() {
        date myDate = date.today();
        final EU001_RI__c ri1 = new EU001_RI__c();
        ri1.CreatedDate =  myDate;
        ri1.EU001_tx_Estado__c  = EU001_CLS_CONSTANTES.EU001_STR_RI_FINALIZACION;
        ri1.EG_001_ls_Valoracion_de_RI__c ='4';
        ri1.EG001_Valoracion_de_RI_DO__c ='4';

        myDate = date.today();
        final EU001_RI__c ri2 = new EU001_RI__c();
        ri2.CreatedDate =  myDate;
        ri2.EU001_tx_Estado__c  = EU001_CLS_CONSTANTES.EU001_STR_RI_FINALIZACION;
        ri2.EG_001_ls_Valoracion_de_RI__c ='4';
        ri2.EG001_Valoracion_de_RI_DO__c ='4';

        final EU001_RI__c ri3 = new EU001_RI__c();
        ri3.CreatedDate =  myDate;
        ri3.EU001_tx_Estado__c  = EU001_CLS_CONSTANTES.EU001_STR_RI_FINALIZACION;
        ri3.EG_001_ls_Valoracion_de_RI__c ='4';
        ri3.EG001_Valoracion_de_RI_DO__c ='4';

        final EU001_RI__c ri4 = new EU001_RI__c();
        ri4.CreatedDate =  myDate;
        ri4.EU001_tx_Estado__c  = EU001_CLS_CONSTANTES.EU001_STR_RI_PREPARACION;

        final List<EU001_RI__c> listRI = new List<EU001_RI__c>();

        listRI.add(ri1);
        listRI.add(ri2);
        listRI.add(ri3);
        listRI.add(ri4);

        insert listRI;

        return listRI;
    }

/**
* @Method:      creaRI
* @param:       String OwnerId
* @Description: Método que retorna un objeto tipo Reunión individual
**/
    public static EU001_RI__c creaRI(String OwnerId) {
        final EU001_RI__c ri = new EU001_RI__c();
        ri.EU001_tx_Estado__c = 'Preparación';
        ri.EU001_ft_Fecha_Inicio__c = System.now();
        ri.OwnerId = OwnerId;
        return ri;
    }


 /**
* @Method:      crearUsuario
* @param:       String strLastName, String strProfileName, String strRol
* @Description: Método que retorna un objeto User
*/
    public static User crearUsuario(String strLastName, String strProfileName, String strRol) {
        final String email                  = 'tstBBVA'+(Math.random()*10000)+'@bbva.test.com';
        final User usuario                  = new User();
        usuario.LastName              = strLastName;
        usuario.Alias                 = String.valueOf((Math.random()*10000).round());
        usuario.Email                 = email;
        usuario.UserName              = email;
        usuario.EmailEncodingKey      = 'UTF-8';
        usuario.LanguageLocaleKey     = 'en_US';
        usuario.TimeZoneSidKey        = 'America/Mexico_City';
        usuario.LocaleSidKey          = 'en_US';
        usuario.IsActive              = true;
        usuario.ProfileId             = perfilMapa.get(strProfileName).Id;
        if(String.isNotBlank(strRol)) {
            usuario.UserRoleId = rolMapa.get(strRol).Id;
        }
        usuario.CompanyName           = 'SulAmérica';
        usuario.CR__c                 = '0001';
        usuario.UG__c                 = String.valueOf((Math.random()*10000000).round());
        usuario.Segmento_Ejecutivo__c = 'EMPRESARIAL';
        usuario.VP_ls_Banca__c        = 'Red BEyG';
        return usuario;
    }
    /** metodo creaUser*/
    public static User creaUser() {
        final User u = MX_BPP_UserAndRIDataFactory.crearUsuario('UserUno', 'BPyP Director Oficina', 'BPYP DIRECTOR OFICINA LOMAS');
        u.Alias = 'UserUno';
        u.Email='do.empresas@bbva.tst.deploy.com';
        u.EmailEncodingKey='ISO-8859-1';
        u.LastName='Prueba';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.CR__c = '1110';
        u.UG__c = '0468134';
        u.Segmento_Ejecutivo__c = 'EMPRESARIAL';
        u.TimeZoneSidKey='America/Mexico_City';
        u.UserName='admin@bbva.tst.deploy.com';
        u.VP_ls_Banca__c = 'Red BPyP';
        u.IsActive=true;
        u.EmployeeNumber='00123';
        return u;
    }
    /** metodo creaUser2*/
    public static User creaUser2() {
        final User u = MX_BPP_UserAndRIDataFactory.crearUsuario('UserUno', Label.MX_PERFIL_SystemAdministrator, 'BPYP BANQUERO PRIVADO y UHN LOMAS');
        u.Alias = 'UserUno';
        u.Email='EV.empresas@bbva.tst.deploy.com';
        u.EmailEncodingKey='ISO-8859-1';
        u.LastName='Prueba';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.CR__c = '5665894941';
        u.UG__c = '87413654';
        u.Segmento_Ejecutivo__c = 'EMPRESARIAL';
        u.TimeZoneSidKey='America/Mexico_City';
        u.UserName='admin59845@bbva.tst.deploy.com';
        u.VP_ls_Banca__c = 'Red BPyP';
        u.IsActive=true;
        return u;
    }
}