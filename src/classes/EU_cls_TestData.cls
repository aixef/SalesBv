/**
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
*3.0      17-04-2018         Abraham Tnajero                Se agregan campos a creación de opp para cobertura
*4.0      14-05-2018         Abraham Tnajero                Se agrega un random a la creación de account
*5.0	  20-06-2018		 Javier Ortiz Flores 			Se agrega compromiso con fecha anterior al día de hoy
*6.0      22-08-2018         Luis Fernando Romero           Se agrega campo a método que genera registros de parametría.
*6.1	  28-08-2018	     Javier Ortiz Flores			Se agregan parametros en la creación del objeto parametría
                                                            calculadora de ramos para almacenar calculos PI10.
*6.2      14-09-2018         César Villanueva               Se agrega tablero grupal de certificación EU.
*6.3      30-08-2019         Cindy Hernández                Sólo se mantiene el método GeneraContactoB y el tipo de
                                                            registro del contacto se cambia por BPyP Contacto.
*6.4      05-09-2019         Cindy Hernández                Se realizan modificaciones para resolver code smells
                                                            detectados por sonar.
*6.5      10-09-2019         Cindy Hernández                Se agregan los métodos insertASCVisit, insertBIEVisit,
                                                            insertTeam, insertCtmSetting e insertUser.
**/
@isTest
public with sharing class EU_cls_TestData {

/*Create contact*/
    public static Contact generaContactoB(List<String> contactData) {
        final Contact contact = new Contact();
        contact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BPyP Contacto').getRecordTypeId();
        contact.FirstName = contactData[0];
        contact.LastName = contactData[1];
        contact.ENGMX_lm_Nivel_de_Responsabilidad__c = contactData[2];
        contact.Tipo_de_contacto__c = contactData[3];
        contact.AccountId = contactData[4];
        contact.Cargo__c = 'ACCIONISTA';
        contact.Phone = '58954125';
        contact.Email = 'xmy9866@gmail.com';

        return contact;
    }

    /*Create data for MX_EU_Minuta_Test class.*/
    public static dwp_kitv__Visit__c insertASCVisit(Id newAccId, Id recordTypeId) {
        //Crea un registro del tipo visita ASC
        final dwp_kitv__Visit__c visit = new dwp_kitv__Visit__c(
            Name='Visita Prueba',
            dwp_kitv__visit_start_date__c= datetime.newInstance(2018, 12, 15, 13, 30, 0),
            dwp_kitv__visit_duration_number__c='30',
            dwp_kitv__visit_purpose_type__c='02',
            Fecha_cierre__c = datetime.newInstance(2018, 12, 15, 13, 30, 0),
            Check_In_Geolocation__Latitude__s = 1.254,
            Check_In_Geolocation__Longitude__s = 1.654,
            dwp_kitv__account_id__c = newAccId,
            dwp_kitv__visit_location_desc__c = 'torre bancomer',
            OwnerId=UserInfo.getUserId(),
            RecordTypeId=recordTypeId
        );
        insert visit;
        return visit;
    }

    /*Create data for MX_EU_Minuta_Test class.*/
    public static dwp_kitv__Visit__c insertBIEVisit(Id newAccId) {
        //Obtiene recordType BIE
        final RecordType bieRecorType=[SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName LIKE 'MX_BPP%' LIMIT 1];

        //Crea un registro del tipo visita BIE
        final dwp_kitv__Visit__c visitBIE = new dwp_kitv__Visit__c(
            Name='Visita Prueba BIE',
            dwp_kitv__visit_start_date__c= datetime.newInstance(2019, 12, 15, 13, 30, 0),
            dwp_kitv__visit_duration_number__c='30',
            dwp_kitv__visit_purpose_type__c='02',
            Fecha_cierre__c = datetime.newInstance(2019, 12, 15, 13, 30, 0),
            Check_In_Geolocation__Latitude__s = 1.254,
            Check_In_Geolocation__Longitude__s = 1.654,
            dwp_kitv__account_id__c=newAccId,
            dwp_kitv__visit_location_desc__c='torre bancomer BIE',
            OwnerId=UserInfo.getUserId(),
            RecordTypeId = bieRecorType.id
        );
        insert visitBIE;
        return visitBIE;
    }

    /*Create data for MX_EU_Minuta_Test class.*/
    public static void insertTeam(Id visitId, Id testUserId) {
        //Inserta los objetos Team relacionados a la visita
        final dwp_kitv__Visit_Management_Team__c newVisitTeam1 = new dwp_kitv__Visit_Management_Team__c(
            dwp_kitv__visit_id__c=visitId,
            dwp_kitv__user_id__c=testUserId,
            dwp_kitv__Send_minutes__c='CC'
        );
		insert newVisitTeam1;
    }

    /*Create data for MX_EU_Minuta_Test class.*/
    public static void insertCtmSetting(String ltsRecordType) {
        //Inserta Custom Setting
        final dwp_kitv__Template_for_type_of_visit_cs__c myCS1 = new dwp_kitv__Template_for_type_of_visit_cs__c();
        myCS1.Name=ltsRecordType;
        myCS1.dwp_kitv__Subject__c='PruebaVF';
        myCS1.dwp_kitv__Visualforce_Name__c='minutaa';
        myCS1.dwp_kitv__Attach_file__c=true;
        myCS1.dwp_kitv__Minimum_Number_of_Agreement__c=1;
        myCS1.dwp_kitv__Minimum_members_BBVA_team__c=1;
        insert myCS1;
    }

    /*Create data for MX_EU_Minuta_Test class.*/
    public static User insertUser() {
        //Crea un usuario para asociarlo a la visita
        final User testUser = new User(
            ProfileId = [SELECT Id FROM Profile LIMIT 1].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FederationIdentifier = 'm101010'
        );
        insert testUser;
        return testUser;
    }

}