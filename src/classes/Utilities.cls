/**
* Using without sharing as need to run query on Organization table
*/
public without sharing class Utilities {

    private Utilities() {

    }

    /**
    * Metodo que obtiene el tipo de la orgazanición y el nombre de la instancia.
    *
    * @param
    * @return
    */
    public Static String getInstance() {
        String instance = '';
        final Organization org = [SELECT OrganizationType, InstanceName FROM Organization limit 1];
        final String orgType = org.OrganizationType;
        final String insName = org.InstanceName;
        if(orgType == 'Developer Edition' || insName.startsWithIgnoreCase('cs')) {
            final List<String> parts = ApexPages.currentPage().getHeaders().get('Host').split('\\.');
            instance = parts[parts.size() - 4] + '.';
        }
        return instance;
    }

    /**
    * Metodo que obtiene el prefijo del dominio
    *
    * @param
    * @return
    */
    public static String getSubdomainPrefix() {
        final Organization org = [SELECT OrganizationType, InstanceName FROM Organization limit 1];
        final String insName = org.InstanceName;
        if(insName.startsWithIgnoreCase('cs')) {
            return UserInfo.getUserName().substringAfterLast('.')+ '-';
        }
        return '';
    }

    /**
    * Metodo que calcula las horas de diferencia.
    *
    * @param
    * @return
    */
    public static Decimal calculaHoras(String sIdConfFechaLaboral, DateTime dtFechaCrea, DateTime dtFechaCierre) {
        System.debug('EN Utils.CalculaHoras: ' + sIdConfFechaLaboral);

        Decimal dHorasDif = 0;

        final Long daysBetween = BusinessHours.diff(sIdConfFechaLaboral, dtFechaCrea, dtFechaCierre);
        System.debug('*** daysBetween: ' + daysBetween);
        final Double dHorasDifFin2 = ((Double)daysBetween/3600000);
        System.debug('*** dHorasDifFin2: ' + dHorasDifFin2);
        dHorasDif = Decimal.valueOf(dHorasDifFin2);
        final Decimal dHorasDifFin = dHorasDif.setScale(2);

        System.debug('*** dHorasDifFin: ' + dHorasDifFin);

        //Regresa la diferencia
        return dHorasDifFin;
    }

    /**
    * metodo que obtiene el role del usuario
    *
    * @param  strAPINameOfTrigger
    * @return
    */
    public static UserRole getUserRole(String name) {
        final UserRole uRole = [SELECT Id, Name FROM UserRole WHERE Name = :name];
        return uRole;
    }

    /**
    * Metodo que obtiene el perfil del usuario.
    *
    * @param
    * @return
    */
    public static Profile getUserProfile(String name) {
        final Profile profile = [SELECT Id, Name FROM Profile WHERE Name = :name];
        return profile;
    }

    /**
    * metodo que crea una lista de usuarios
    *
    * @param
    * @return
    */
    public static List<User> createUsers() {
        final List<User> users = new List<User>();
        final Profile profile = getUserProfile('Coordinador de Atencion a Clientes');
        for(integer i = 0; i<20; i++) {
            final User user = new User();
            user.FirstName = 'TestFirstName '+i;
            user.LastName = 'TestLastName '+i;
            user.Alias = 'Alias '+i;
            user.Email = 'email'+i+'@salesforce.com';
            user.Username = user.Email;
            user.CommunityNickname = 'nickname '+i;
            user.TimeZoneSidKey = 'America/Mexico_City';
            user.LocaleSidKey = 'en_US';
            user.EmailEncodingKey = 'UTF-8';
            user.ProfileId = profile.Id;
            user.LanguageLocaleKey = 'en_US';
            users.add(user);
        }
        return users;
    }

    /**
    * metodo que obtiene grupos con el typo queue
    *
    * @param
    * @return
    */
    public static List<Group> getQueues() {
        final List<Group> queues = [SELECT Id, Name FROM Group WHERE Type = 'Queue'];
        return queues;
    }

    /**
    * Metodo que genera formato de fecha
    *
    * @param
    * @return
    */
    public static String fnGeneradorFechaMilis() {
        String fechaFormato = String.valueOf( System.today() ).replace('-', '/');
        fechaFormato = fechaFormato.replace(' ', 'T');
        fechaFormato = fechaFormato.substring(8,10) + '/' +
            fechaFormato.substring(5,7) + '/' +
            fechaFormato.substring(0,4) + fechaFormato.substring( 10, fechaFormato.length() );
        return fechaFormato;
    }
    /**
    *metodo generador de md5
    *
    * @param
    * @return
    */
    public static String fnGeneradorMD5(String fecha,String usuario,String canal, String subCanal,String agencia,String servicio) {
        final String strUsuarioTemp=usuario.replace('%20',' ');
        final String strAgenciaTemp=agencia.replace('%20',' ');
        final String strServicioTemp=servicio.replace('%20',' ');
        final String cadenaBase = String.valueOf( fecha + strUsuarioTemp + strServicioTemp + strAgenciaTemp + canal + subCanal );
        final Blob   stringToBlob = Blob.valueOf( cadenaBase );
        final Blob   encriptado = Crypto.generateDigest( 'MD5', stringToBlob );
        final String base64 = EncodingUtil.convertToHex( encriptado );
        return base64;
    }

    /**
    * metodo que verifica lista negra
    *
    * @param
    * @return
    */
    public static Map<String,String> verificarListaNegra(List<String> lstDatosListaNegra) {
        final Map<String,String> mapListNegCorr = new Map<String,String>();

        for(Lista_Negra__c lstListaNegra:[SELECT Correo_Electronico__c,Telefono__c,Id,Name FROM Lista_Negra__c WHERE Correo_Electronico__c IN:lstDatosListaNegra OR Telefono__c IN:lstDatosListaNegra LIMIT 10]) {

            if(lstListaNegra.Correo_Electronico__c != null) {
                mapListNegCorr.put(lstListaNegra.Correo_Electronico__c,lstListaNegra.Correo_Electronico__c);
            }

            if(lstListaNegra.Telefono__c != null) {
                mapListNegCorr.put(lstListaNegra.Telefono__c,lstListaNegra.Telefono__c);
            }

        }
        return mapListNegCorr;
    }

    /**
    * metodo que crae registro de un lead
    *
    * @param
    * @return
    */
    public static Lead creaOportunidadComercial(String productoInteres) {
        final Lead testLead = new Lead();
        testLead.Lastname = 'John';
        testLead.Firstname = 'Doe';
        testLead.Producto_Interes__c = productoInteres;
        testLead.LeadSource = 'Inbound';
        testLead.TelefonoCelular__c = '1122334455';
        testLead.Email = 'email@bbva.com';
        testLead.Status = 'Abierta';
        testLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('ASD').getRecordTypeId();
        insert testLead;
        return testLead;
    }
}