/**Proyecto : Shield Platform Encryption
 * Autor	: Cristian Espinosa
 * Fecha	: 26/Enero/2018
 * Descripción : Clase de prueba para la clase CheckContactField_cls
 * ___________________________________________________________________________________________
 * Version		Fecha			Autor					Descripción
 * 1.1			26/01/2018		Cristian Espinosa		Release
 * 1.2          20/02/2018      Ricardo Hernandez       Se agregan los metodos de test de Niveles de Resposabilidad. Y un metodo para crear contactos.
 * */
@isTest
public class CheckContactField_tst {
	/** variable u*/
    static User u = new User();
    /** variable  p*/
    static Profile p = new Profile();
    /** variable pDiv*/
    static Profile pDiv = new Profile();
    /** Mapa mapRecordTypes*/
    static map<String, RecordType> mapRecordTypes = new map<String, RecordType>();
    /** static VariablesGlobales__c var = new VariablesGlobales__c();*/
    static Account acc  = new Account ();

    /** variable conFName*/
    final static String conFName = 'Clint';
    /** variable conLName*/
    final static String conLName = 'Eastwood';
    /** variable conEmail */
    final static String conEmail = 'IHate@TestMethods.com';
    /** variable conPhone*/
    final static String conPhone = '1234567890';


    static void init() {
        //PROFILES
        p = [SELECT Id FROM Profile WHERE Name= 'BPyP Estandar'];

        //RTypes
        for(RecordType RT : [Select Id, DeveloperName from RecordType where SObjectType = 'Account']) {
        	mapRecordTypes.put(RT.DeveloperName, RT);
        }

        u.UserName='standarduserasdas@testorg.com';
        u.Alias = 'staus';
        u.Email='standarduser@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='TestingCF2';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.VP_ls_Banca__c = 'Red BEyG';
        u.TimeZoneSidKey  = 'America/Mexico_City';
        insert u;

        //Varibles
        /*
        var.Name ='Usr_Tecom_Var_Glb';
        var.Num_Max_Cnt_Tecom_ERRORmsg__c = 'No se puede agregar mas contactos a esta Cuenta máximo 3 Contactos TECOM';
        var.Num_Max_Cnt_Tecom__c = 3;
        insert var;*/

        //ACCOUNT
        acc.RecordTypeId = mapRecordTypes.get('Grupo').Id;
        acc.Name = 'Grupo de Pruebas';
        acc.OwnerId = u.Id;
        insert acc;

    }
    /**Metodo crearContactoO */
    public static Contact crearContactoO(String Firsname,String LastName, String Tipo, String Idcuenta, String Nivel) {
        Contact contact = new Contact();
            contact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contacto').getRecordTypeId();
            contact.FirstName = Firsname;
            contact.LastName = LastName;
            contact.Tipo_de_contacto__c = Tipo;
            contact.AccountId = Idcuenta;
            contact.Cargo__c = 'ACCIONISTA';
            contact.Phone = '58954125';
            contact.Email = 'xmy9866@gmail.com';
            contact.ENGMX_lm_Nivel_de_Responsabilidad__c = Nivel;

        insert contact;

        return contact;
    }

	static testmethod void checkContactFieldsTrue() {
        init();
        Test.startTest();
        Contact con = new Contact();
        con.FirstName = conFName;
        con.LastName = conLName;
        con.Email = conEmail;
        con.Phone = conPhone;
        con.AccountId = acc.id;
        insert con;
        con.FirstName = 'Pete';
        update con;
        Contact cRes = [select id, ca_tieneEmail__c,ca_tieneNombre__c,ca_tieneTelefono__c from Contact where id = :con.id];
       	System.assertEquals(cRes.ca_tieneEmail__c, true);
        Test.stopTest();
    }

	static testmethod void checkContactFieldsNoPhone() {
        init();
        Test.startTest();
        Contact con = new Contact();
        con.FirstName = conFName;
        con.LastName = conLName;
        con.Email = conEmail;
        con.AccountId = acc.id;
        insert con;
        System.assertEquals(con.ca_tieneTelefono__c, false);
        Test.stopTest();
    }

	static testmethod void checkContactFieldsNoEmail() {
        init();
        Test.startTest();
        Contact con = new Contact();
        con.FirstName = conFName;
        con.LastName = conLName;
        con.Phone = conPhone;
        con.AccountId = acc.id;
        insert con;
        System.assertEquals(con.ca_tieneEmail__c, false);
		Test.stopTest();
    }
}