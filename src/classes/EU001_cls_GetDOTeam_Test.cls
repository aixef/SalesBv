/**
* ------------------------------------------------------------------------------------------------
* @Name     EU001_cls_GetDOTeam_Test
* @Author   Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* @Date     Created: 2019-06-19
* @Group    Digital Workplace Retail
* @Description Test class for the class EU001_cls_GetDOTeam
* @Changes	Se agrega el método getDOTeamForDDWithParentRoles para subir porcentaje de cobertura.
			Se agregan System.assert al método getTeamD y el método se divide en getTeamD, getTeamFor DD,
            getTeamForDR para resolver code smells detectados por sonar.
			Se agregan los tipos de registro a las cuentas que se insertan.
**/

@isTest
public class EU001_cls_GetDOTeam_Test {
    /**Mapa profileMap */
    static Map<String,Profile> profileMap;
    /**Mapa roleMap */
    static Map<String,UserRole> roleMap;
    /**Mapa solicitudesRT */
    static Map<String,Schema.Recordtypeinfo> solicitudesRT,oportunidadRT, clienteRT, compromisoRT;

    static {

        profileMap = new Map<String,Profile>();
        for (Profile prof:[select Id, Name from Profile WHERE Name = 'BPyP Estandar' OR Name = 'BPyP STAFF' OR Name = 'BPyP Director Oficina' OR Name = 'BPyP Director Divisional']) {
            profileMap.put(prof.Name,prof);
        }

        roleMap = new Map<String,UserRole>();
        for (UserRole role:[select Id, Name from UserRole WHERE Name = 'BPYP BANQUERO AGUASCALIENTES' OR Name = 'BPYP STAFF DIRECCIÓN BANCA' OR Name = 'BPYP DIRECTOR DIVISIONAL BAJIO'
                           OR Name = 'BPYP BANQUERO PACHUCA' OR Name = 'BPYP DIRECTOR OFICINA AGUASCALIENTES' OR Name = 'BPYP BANQUERO PRIVADO y UHN LOMAS' OR Name = 'BPYP DIRECTOR OFICINA LOMAS' OR Name = 'BPYP DIRECTOR DIVISIONAL']) {
            roleMap.put(role.Name,role);
        }
    }

    @isTest static void getTeamD() {
       	final User TstBankerUsr = new User();
        TstBankerUsr.Username ='userNameTstBkr@gmail.com';
        TstBankerUsr.FirstName = 'UserTst Bkr';
        TstBankerUsr.LastName= 'Test Bkr';
        TstBankerUsr.Email= 'userNameTstBkr@gmail.com';
        TstBankerUsr.Alias= 'Bkr1';
        TstBankerUsr.TimeZoneSidKey= 'America/Mexico_City';
        TstBankerUsr.LocaleSidKey= 'en_US';
        TstBankerUsr.EmailEncodingKey= 'ISO-8859-1';
        TstBankerUsr.ProfileId= profileMap.get('BPyP Director Divisional').Id;
        TstBankerUsr.UserRoleId = roleMap.get('BPYP DIRECTOR DIVISIONAL').Id;
        TstBankerUsr.LanguageLocaleKey ='es';
        TstBankerUsr.VP_ls_Banca__c = 'Red BPyP';
        TstBankerUsr.UG__c = '037903';
        TstBankerUsr.Segmento_Ejecutivo__c = 'CORPORATIVO';
        insert TstBankerUsr;
        final User usrTst4 = new User();
        usrTst4.Username ='userNameTstDD@gmail.com';
        usrTst4.FirstName = 'UserTst';
        usrTst4.LastName= 'Test';
        usrTst4.Email= 'userNameTst@gmail.com';
        usrTst4.Alias= 'tst1';
        usrTst4.TimeZoneSidKey= 'America/Mexico_City';
        usrTst4.LocaleSidKey= 'en_US';
        usrTst4.EmailEncodingKey= 'ISO-8859-1';
        usrTst4.ProfileId= profileMap.get('BPyP STAFF').Id;
        usrTst4.UserRoleId = roleMap.get('BPYP STAFF DIRECCIÓN BANCA').Id;
        usrTst4.LanguageLocaleKey ='es';
        usrTst4.VP_ls_Banca__c = 'Red BPyP';
        usrTst4.UG__c = '037900';
        usrTst4.Segmento_Ejecutivo__c = 'CORPORATIVO';
        insert usrTst4;
        System.runAs(usrTst4) {
            test.startTest();
        final Account cuenta = new Account();
        cuenta.Name = 'Tst client';
        cuenta.No_de_cliente__c = '282828282';
        cuenta.RecordTypeId = RecordTypeMemory_cls.getRecType('Account','BPyP_tre_Cliente');
        insert cuenta;
            List<String> equipo = EU001_cls_CompHandler.getDOteamPromPonderados(usrTst4.Id, true, 'DO');
            System.assert(!equipo.isEmpty());

            equipo = EU001_cls_CompHandler.getDOteamPromPonderados(usrTst4.Id, false, 'DO');
            System.assert(!equipo.isEmpty());

            equipo = EU001_cls_CompHandler.getDOteamPromPonderados(TstBankerUsr.Id, false, 'DO');
            System.assert(equipo.isEmpty());

            equipo = EU001_cls_CompHandler.getDOteamPromPonderados(TstBankerUsr.Id, true, 'DO');
            System.assert(equipo.isEmpty());

            test.stopTest();
        }
    }

  	@isTest
    static void getTeamForDD() {
        final User usrTst4 = new User();
        usrTst4.Username ='userNameTstDD@gmail.com';
        usrTst4.FirstName = 'UserTst';
        usrTst4.LastName= 'Test';
        usrTst4.Email= 'userNameTst@gmail.com';
        usrTst4.Alias= 'tst1';
        usrTst4.TimeZoneSidKey= 'America/Mexico_City';
        usrTst4.LocaleSidKey= 'en_US';
        usrTst4.EmailEncodingKey= 'ISO-8859-1';
        usrTst4.ProfileId= profileMap.get('BPyP STAFF').Id;
        usrTst4.UserRoleId = roleMap.get('BPYP STAFF DIRECCIÓN BANCA').Id;
        usrTst4.LanguageLocaleKey ='es';
        usrTst4.VP_ls_Banca__c = 'Red BPyP';
        usrTst4.UG__c = '037900';
        usrTst4.Segmento_Ejecutivo__c = 'CORPORATIVO';
        insert usrTst4;
        final User usrTst3DD = new User();
        usrTst3DD.Username ='userNameTstDO@gmail.com';
        usrTst3DD.FirstName = 'UserTstDO';
        usrTst3DD.LastName= 'TestDO';
        usrTst3DD.Email= 'userNameTstDO@gmail.com';
        usrTst3DD.Alias= 'tst2';
        usrTst3DD.TimeZoneSidKey= 'America/Mexico_City';
        usrTst3DD.LocaleSidKey= 'en_US';
        usrTst3DD.EmailEncodingKey= 'ISO-8859-1';
        usrTst3DD.ProfileId= profileMap.get('BPyP Director Oficina').Id;
        usrTst3DD.UserRoleId = roleMap.get('BPYP DIRECTOR OFICINA AGUASCALIENTES').Id;
        usrTst3DD.LanguageLocaleKey ='es';
        usrTst3DD.VP_ls_Banca__c = 'Red BPyP';
        usrTst3DD.UG__c = '037902';
        usrTst3DD.Segmento_Ejecutivo__c = 'CORPORATIVO';
        insert usrTst3DD;
        System.runAs(usrTst4) {
            test.startTest();
        final Account cuenta = new Account();
        cuenta.Name = 'Tst client';
        cuenta.No_de_cliente__c = '282828282';
        cuenta.RecordTypeId = RecordTypeMemory_cls.getRecType('Account','BPyP_tre_Cliente');
        insert cuenta;
            List<String> equipo = EU001_cls_CompHandler.getDOteamPromPonderados(usrTst3DD.Id, true, 'DD');
            System.assert(equipo.isEmpty());
            equipo = EU001_cls_CompHandler.getDOteamPromPonderados(usrTst3DD.Id, false, 'DD');
            System.assert(equipo.isEmpty());
            test.stopTest();
        }
    }

    @isTest
    static void getTeamForDR() {
        final User usrTst4 = new User();
        usrTst4.Username ='userNameTstDD@gmail.com';
        usrTst4.FirstName = 'UserTst';
        usrTst4.LastName= 'Test';
        usrTst4.Email= 'userNameTst@gmail.com';
        usrTst4.Alias= 'tst1';
        usrTst4.TimeZoneSidKey= 'America/Mexico_City';
        usrTst4.LocaleSidKey= 'en_US';
        usrTst4.EmailEncodingKey= 'ISO-8859-1';
        usrTst4.ProfileId= profileMap.get('BPyP Estandar').Id;
        usrTst4.UserRoleId = roleMap.get('BPYP BANQUERO PACHUCA').Id;
        usrTst4.LanguageLocaleKey ='es';
        usrTst4.VP_ls_Banca__c = 'Red BPyP';
        usrTst4.UG__c = '037900';
        usrTst4.Segmento_Ejecutivo__c = 'CORPORATIVO';
        insert usrTst4;
        final User usrTst3DR = new User();
        usrTst3DR.Username ='userNameTstDR@gmail.com';
        usrTst3DR.FirstName = 'UserTstDR';
        usrTst3DR.LastName= 'TestDR';
        usrTst3DR.Email= 'userNameTstDR@gmail.com';
        usrTst3DR.Alias= 'tst2';
        usrTst3DR.TimeZoneSidKey= 'America/Mexico_City';
        usrTst3DR.LocaleSidKey= 'en_US';
        usrTst3DR.EmailEncodingKey= 'ISO-8859-1';
        usrTst3DR.ProfileId= profileMap.get('BPyP Director Divisional').Id;
        usrTst3DR.UserRoleId = roleMap.get('BPYP DIRECTOR DIVISIONAL BAJIO').Id;
        usrTst3DR.LanguageLocaleKey ='es';
        usrTst3DR.VP_ls_Banca__c = 'Red BEyG';
        usrTst3DR.UG__c = '037901';
        usrTst3DR.Segmento_Ejecutivo__c = 'CORPORATIVO';
        insert usrTst3DR;
        System.runAs(usrTst4) {
            test.startTest();
            final Account cuenta = new Account();
            cuenta.Name = 'Tst client';
            cuenta.No_de_cliente__c = '282828282';
            cuenta.RecordTypeId = RecordTypeMemory_cls.getRecType('Account','BPyP_tre_Cliente');
            insert cuenta;
            final List<String> equipo = EU001_cls_CompHandler.getDOteamPromPonderados(usrTst3DR.Id, true, 'DR');
            System.assert(!equipo.isEmpty(), 'El método regresa usuarios');
            final List<String> equipoDR = EU001_cls_CompHandler.getDOteamPromPonderados(usrTst3DR.Id, false, 'DR');
            System.assert(!equipoDR.isEmpty(), 'El método regresa usuarios');
            test.stopTest();
        }
    }

    @isTest
    static void getDOTeamForDDWithParentRoles() {
        final String sUGBkr = '037903';
        final String sUG = '037900';
       	final User TstBankerUsr = new User();
        TstBankerUsr.Username ='userNameTstBkr@gmail.com';
        TstBankerUsr.FirstName = 'UserTst Bkr';
        TstBankerUsr.LastName= 'Test Bkr';
        TstBankerUsr.Email= 'userNameTstBkr@gmail.com';
        TstBankerUsr.Alias= 'Bkr1';
        TstBankerUsr.TimeZoneSidKey= 'America/Mexico_City';
        TstBankerUsr.LocaleSidKey= 'en_US';
        TstBankerUsr.EmailEncodingKey= 'ISO-8859-1';
        TstBankerUsr.ProfileId= profileMap.get('BPyP Estandar').Id;
        TstBankerUsr.UserRoleId = roleMap.get('BPYP BANQUERO PRIVADO y UHN LOMAS').Id;
        TstBankerUsr.LanguageLocaleKey ='es';
        TstBankerUsr.VP_ls_Banca__c = 'Red BPyP';
        TstBankerUsr.UG__c = sUGBkr;
        TstBankerUsr.Segmento_Ejecutivo__c = 'CORPORATIVO';
        insert TstBankerUsr;

        final User usrTst3DD = new User();
        usrTst3DD.Username ='userNameTstDO@gmail.com';
        usrTst3DD.FirstName = 'UserTstDO';
        usrTst3DD.LastName= 'TestDO';
        usrTst3DD.Email= 'userNameTstDO@gmail.com';
        usrTst3DD.Alias= 'tst2';
        usrTst3DD.TimeZoneSidKey= 'America/Mexico_City';
        usrTst3DD.LocaleSidKey= 'en_US';
        usrTst3DD.EmailEncodingKey= 'ISO-8859-1';
        usrTst3DD.ProfileId= profileMap.get('BPyP Director Oficina').Id;
        usrTst3DD.UserRoleId = roleMap.get('BPYP DIRECTOR OFICINA LOMAS').Id;
        usrTst3DD.LanguageLocaleKey ='es';
        usrTst3DD.VP_ls_Banca__c = 'Red BPyP';
        usrTst3DD.UG__c = sUG;
        usrTst3DD.Segmento_Ejecutivo__c = 'CORPORATIVO';
        insert usrTst3DD;

        final String rolId = [SELECT Id FROM UserRole WHERE Name = 'BPYP DIRECTOR OFICINA LOMAS'][0].Id;
        final List<String> rolesIds = new List<String>{rolId};

        String errorMessage = '';
        test.startTest();
        try {
	        final List<String> equipoDO = EU001_cls_GetDOTeam.getDOTeamForDD(rolesIds, true);
            System.assert(!equipoDO.isEmpty());
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }

    @isTest
    static void getTeamConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        final EU001_cls_GetDOTeam getTeam = new EU001_cls_GetDOTeam();
            System.assert(getTeam != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }
}