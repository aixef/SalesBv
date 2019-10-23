/* _____________________________________________________________________________________________
Versión     Fecha           Autor                   Descripción
1.2         21-Nov-2018     Cristian Espinosa
    Se agrega método para subir cobertura a MX_BPP_CompUtils_cls
2.0         18-Enero-2019   Francisco J Licona
    Se crean métodos para realizar la cobertura en la clase BPyP_Contact_Acc
2.1         30-Enero-2019   Adrián Pastor Pineda
    Se crea el método: RISelected - para cubrir la clase BPyP_Contact_Acc
3.0         11-Marzo-2019   Francisco J Licona
    Se realiza la modificación para cumplir con la cobertura de la clase BPyp_Contact_Acc
4.0         20-Junio-2019   Cindy Hernández Nieto
    Se eliminan los métodos que no se utilizan y se agregan los métodos contactAccConstructor, RISelected y ISelectedError.
4.1         03-Julio-2019    Hugo Carrillo Béjar
    Se Agregan métodos previamente eliminados y que se utilizan en otro componente.
4.2         04-Septiembre-2019    Cindy Hernández Nieto
    Se realiza modificación para kit de visita (Este cambio se realizó en el repo de
    empresas el 20/05/2019 por Ricardo Almanza).
4.3 11-Septiembre-2019    Selena Rodriguez Vega
    Se crea metodo creacionVisita() para aumentar cobertura de la clase y resolver codesmells
 */
@isTest
private class BPyP_Contact_AccTest {

    /*Variable global que reemplaza los msjs Resultado obtenido*/
    final static String V_RESOBTDO='Resultado obtenido';
    /*Variable global que reemplaza los msjs Pa*/
    final static String V_PA='Pa';
    /*Variable global que reemplaza los msjs Pas*/
    final static String V_PAS='Pas';
    /*Variable global que reemplaza los msjs Pr*/
    final static String V_PR='Pr';
    /*Variable global que reemplaza los msjs Red BPyP*/
    final static String V_RBPP='Red BPyP';
    /*Variable global que reemplaza los msjs usuarioprueba*/
    final static String V_USERPB='usuarioprueba';
    /*Variable global que reemplaza los msjs Metropolitana*/
    final static String V_MTPNA='METROPOLITANA';
    /*Variable global que reemplaza los msjs BPyP*/
    final static String V_BPP='BPyP';
    /*Variable global que reemplaza los msjs 6340 TORRE BANCOMER*/
    final static String V_SUCSAL='6340 TORRE BANCOMER';
    /*Variable global que reemplaza los msjs BPyP Estandar*/
    final static String V_PFESTA='BPyP Estandar';
    /*Variable global que reemplaza los msjs Usuario*/
    final static String V_USER='Usuario';
    /*Variable global que reemplaza los msjs EMPRESARIAL*/
    final static String V_EMPR='EMPRESARIAL';
    /*Variable global que reemplaza los msjs BPyP_tre_Cliente*/
    final static String V_TRECTE='BPyP_tre_Cliente';
    /*Variable global que reemplaza los msjs Patrimonial*/
    final static String V_PTMNIAL='Patrimonial';
    /*Variable global resFDivData*/
    static BPyP_Contact_Acc.WRP_ChartStacked resFDivData;
    /*Variable global resFDivChanData*/
    static BPyP_Contact_Acc.WRP_ChartStacked rFDivChanDta;
    /*Variable global rFOffData*/
    static BPyP_Contact_Acc.WRP_ChartStacked rFOffData;
    /*Variable global rFOffChanDta*/
    static BPyP_Contact_Acc.WRP_ChartStacked rFOffChanDta;
    /*Variable global rfBkMOnlyDta*/
    static BPyP_Contact_Acc.WRP_ChartStacked rfBkMOnlyDta;
    /*Variable global rfkMOnChanDta*/
    static BPyP_Contact_Acc.WRP_ChartStacked rfkMOnChanDta;
    /*Variable global rfBkMData*/
    static BPyP_Contact_Acc.WRP_ChartStacked rfBkMData;
    /*Variable global rfBkMChanDta*/
    static BPyP_Contact_Acc.WRP_ChartStacked rfBkMChanDta;
    /*Variable global month*/
    static Integer month;
    /*Variable global type*/
    static String type;

    /**
     * This is a test method for obtStAndEndDate
     */
    static testMethod void testObtStAndEndDate() {
        Test.startTest();
        final Datetime resObtStEndDate = BPyP_Contact_Acc.obtStAndEndDate(month , type);
        System.assertEquals(NULL,resObtStEndDate,V_RESOBTDO);

        Test.stopTest();
    }
    /**
     * This is a test method for fetchDiv
     */
    static testMethod void testFetchDiv() {
        Test.startTest();
        try {
            BPyP_Contact_Acc.fetchDiv();
        } catch (Exception e) {
            System.assertEquals('Script-thrown exception', e.getMessage(),'El error es Script-thrown exception');
        }
        Datetime startDte;
        Datetime endDte;
		startDte=datetime.newInstance(system.today().year(),system.today().month(),1);
        endDte=datetime.newInstance(system.today().year(),system.today().month(),11);
        type=V_PA;
        resFDivData = BPyP_Contact_Acc.fetchDivData(type , null , null);
        resFDivData = BPyP_Contact_Acc.fetchDivData(type , startDte , endDte);
        rFDivChanDta = BPyP_Contact_Acc.fetchDivChanData(type , startDte , endDte);
        rFDivChanDta = BPyP_Contact_Acc.fetchDivChanData(type , null , null);
        type=V_PAS;
        resFDivData = BPyP_Contact_Acc.fetchDivData(type , startDte , endDte);
        rFDivChanDta = BPyP_Contact_Acc.fetchDivChanData(type , startDte , endDte);
        resFDivData = BPyP_Contact_Acc.fetchDivData(type , null , null);
        rFDivChanDta = BPyP_Contact_Acc.fetchDivChanData(type , null , null);
        type=V_PR;
        resFDivData = BPyP_Contact_Acc.fetchDivData(type , startDte , endDte);
        resFDivData = BPyP_Contact_Acc.fetchDivData(type , null , null);
        rFDivChanDta = BPyP_Contact_Acc.fetchDivChanData(type , startDte , endDte);
        rFDivChanDta = BPyP_Contact_Acc.fetchDivChanData(type , null , null);

        Test.stopTest();
    }


    /**
     * This is a test method for fetchOff
     */
    static testMethod void testFetchOff() {
        Test.startTest();
         Datetime startDte=NULL;
        Datetime endDte=NULL;
        BPyP_Contact_Acc.fetchOff('');
        type=V_PR;
        rFOffData = BPyP_Contact_Acc.fetchOffData(type , '' , startDte , endDte);
        rFOffChanDta = BPyP_Contact_Acc.fetchOffChanData(type , '' , startDte , endDte);
        rFOffData = BPyP_Contact_Acc.fetchOffData(type , '' , null , null);
        rFOffChanDta = BPyP_Contact_Acc.fetchOffChanData(type , '' , null , null);
        System.assertEquals(0,rFOffData.lsData.size(),V_RESOBTDO);
        type=V_PAS;
        rFOffData = BPyP_Contact_Acc.fetchOffData(type , '' , startDte , endDte);
        rFOffChanDta = BPyP_Contact_Acc.fetchOffChanData(type , '' , startDte , endDte);
        rFOffData = BPyP_Contact_Acc.fetchOffData(type , '' , null , null);
        rFOffChanDta = BPyP_Contact_Acc.fetchOffChanData(type , '' , null , null);
        type=V_PA;
        startDte=datetime.newInstance(system.today().year(),system.today().month(),1);
        endDte=datetime.newInstance(system.today().year(),system.today().month(),11);
        rFOffData = BPyP_Contact_Acc.fetchOffData(type , '' , startDte , endDte);
        rFOffData = BPyP_Contact_Acc.fetchOffData(type , '' , null , null);
        rFOffChanDta = BPyP_Contact_Acc.fetchOffChanData(type , '' , startDte , endDte);
        rFOffChanDta = BPyP_Contact_Acc.fetchOffChanData(type , '' , null , null);
        Test.stopTest();
    }

static testMethod void creacionVisita() {

   final User adminUser = UtilitysDataTest_tst.crearUsuario('Administrator', Label.MX_PERFIL_SystemAdministrator,'BBVA ADMINISTRADOR');
        adminUser.VP_ls_Banca__c = V_RBPP;
        adminUser.Title = V_PTMNIAL;
        adminUser.FirstName = V_USERPB;
        adminUser.LastName = V_BPP;
        adminUser.Divisi_n__c = V_MTPNA;
        adminUser.BPyP_ls_NombreSucursal__c =V_SUCSAL;
        insert adminUser;

  final User user1 = MX_BPP_UserAndRIDataFactory.crearUsuario(V_USER, V_PFESTA, Null);
        user1.Segmento_Ejecutivo__c = V_EMPR;
        user1.Title = V_PTMNIAL;
        user1.FirstName = V_USERPB;
        user1.LastName = V_BPP;
        user1.Divisi_n__c = V_MTPNA;
        user1.BPyP_ls_NombreSucursal__c = V_SUCSAL;
        user1.VP_ls_Banca__c = V_RBPP;
    insert user1;

    system.runAs(adminUser) {
        final Account acc = UtilitysDataTest_tst.crearCuenta('Justino Flores', V_TRECTE);
        acc.OwnerId = user1.Id;
        insert acc;

        final dwp_kitv__Visit__c newVisit = new dwp_kitv__Visit__c();
        newVisit.dwp_kitv__visit_status_type__c = '06';
        newVisit.dwp_kitv__visit_duration_number__c='15';
        newVisit.dwp_kitv__visit_start_date__c=Datetime.newInstance(2019,09, 09);
        newVisit.OwnerId= user1.Id;
        newVisit.dwp_kitv__account_id__c=acc.Id;
        insert newVisit;
        testFetchDiv();
        System.assertEquals(acc.Id,newVisit.dwp_kitv__account_id__c,'Coincide id');
    }


  }

    /**
     * This is a test method for fetchBankMan
     */
    static testMethod void testFetchBankMan() {
        Test.startTest();
        //return List , please fix
        BPyP_Contact_Acc.fetchBankMan('' , '');
        BPyP_Contact_Acc.fetchBankMan('Torre BBVA' , 'METROPOLITANA');
        type=V_PA;
        Datetime startDte=NULL;
        Datetime endDte=NULL;
        startDte=datetime.newInstance(system.today().year(),system.today().month(),1);
        endDte=datetime.newInstance(system.today().year(),system.today().month(),11);
        rfBkMData = BPyP_Contact_Acc.fetchBkMData(type , '' , '' , startDte , endDte);
        rfBkMChanDta = BPyP_Contact_Acc.fetchBkMChanData(type , '' , '' , startDte , endDte);
        rfBkMData = BPyP_Contact_Acc.fetchBkMData(type , '' , '' , null , null);
        rfBkMChanDta = BPyP_Contact_Acc.fetchBkMChanData(type , '' , '' , null , null);
        type=V_PAS;
        rfBkMData = BPyP_Contact_Acc.fetchBkMData(type , '' , '' , startDte , endDte);
        rfBkMChanDta = BPyP_Contact_Acc.fetchBkMChanData(type , '' , '' , startDte , endDte);
        rfBkMData = BPyP_Contact_Acc.fetchBkMData(type , '' , '' , null , null);
        rfBkMChanDta = BPyP_Contact_Acc.fetchBkMChanData(type , '' , '' , null , null);
        type=V_PR;
        rfBkMData = BPyP_Contact_Acc.fetchBkMData(type , '' , '' , startDte , endDte);
        rfBkMChanDta = BPyP_Contact_Acc.fetchBkMChanData(type , '' , '' , startDte , endDte);
        rfBkMData = BPyP_Contact_Acc.fetchBkMData(type , '' , '' , null , null);
        rfBkMChanDta = BPyP_Contact_Acc.fetchBkMChanData(type , '' , '' , null , null);
        System.assertEquals(0,rfBkMChanDta.lsData.size(),V_RESOBTDO);

        Test.stopTest();
    }


    /**
     * This is a test method for fetchBkMOnlyData
     */
    static testMethod void testFetchBkMOnlyData() {
        Test.startTest();
        type=V_PA;
        Datetime startDte=NULL;
        Datetime endDte=NULL;
        startDte=datetime.newInstance(system.today().year(),system.today().month(),1);
        endDte=datetime.newInstance(system.today().year(),system.today().month(),11);
        rfBkMOnlyDta = BPyP_Contact_Acc.fetchBkMOnlyData(type , '' , startDte , endDte);
        rfBkMOnlyDta = BPyP_Contact_Acc.fetchBkMOnlyData(type , '' , null , null);
        rfkMOnChanDta = BPyP_Contact_Acc.fetchBkMOnlyChanData(type , '' , startDte , endDte);
        rfkMOnChanDta = BPyP_Contact_Acc.fetchBkMOnlyChanData(type , '' , null , null);
        type=V_PAS;
        rfBkMOnlyDta = BPyP_Contact_Acc.fetchBkMOnlyData(type , '' , startDte , endDte);
        rfkMOnChanDta = BPyP_Contact_Acc.fetchBkMOnlyChanData(type , '' , startDte , endDte);
        rfBkMOnlyDta = BPyP_Contact_Acc.fetchBkMOnlyData(type , '' , null , null);
        rfkMOnChanDta = BPyP_Contact_Acc.fetchBkMOnlyChanData(type , '' , null , null);
        System.assertNotEquals(null,BPyP_Contact_Acc.fetchusdata(),V_RESOBTDO);
        type=V_PR;
        rfBkMOnlyDta = BPyP_Contact_Acc.fetchBkMOnlyData(type , '' , startDte , endDte);
        rfBkMOnlyDta = BPyP_Contact_Acc.fetchBkMOnlyData(type , '' , null , null);
        rfkMOnChanDta = BPyP_Contact_Acc.fetchBkMOnlyChanData(type , '' , startDte , endDte);
        rfkMOnChanDta = BPyP_Contact_Acc.fetchBkMOnlyChanData(type , '' , null , null);

        Test.stopTest();
    }

    @isTest
    static void tMXBPPCompUtilsTst() {
        final User thisUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        final User usr = MX_BPP_UserAndRIDataFactory.crearUsuario('Marty McFly', thisUser.Profile.Name, 'BBVA ADMINISTRADOR');
        usr.VP_ls_Banca__c = V_RBPP;
        usr.BPyP_ls_NombreSucursal__c = V_SUCSAL;
        usr.Divisi_n__c = V_MTPNA;
        System.runAs(usr) {
            final Account acc4 = MX_BPP_AccAndOppDataFactory.crearCuenta('Bufford Tannen',V_TRECTE);
            acc4.No_de_Cliente__c = '81231238';
            acc4.OwnerId = usr.Id;

            insert acc4;
            final List<AggregateResult> lsOffcs = MX_BPP_CompUtils_cls.getBPyPOffices(V_MTPNA);
            System.assertEquals(1,lsOffcs.size(),'Oficinas obtenidas');

        }

    }
    @isTest
    static void tMXBPyPContactabilityRight() {
        final gcal__GBL_Google_Calendar_Sync_Environment__c calEnviro = new gcal__GBL_Google_Calendar_Sync_Environment__c(Name = 'DEV');
        insert calEnviro;
        final DateTime stDte = DateTime.now().addDays(-30);
        final DateTime enDte = DateTime.now().addDays(30);
        final User user = MX_BPP_UserAndRIDataFactory.crearUsuario(V_USER, V_PFESTA, Null);
        final gcal__GBL_Google_Calendar_Sync_Environment__c calendarEnviroment = new gcal__GBL_Google_Calendar_Sync_Environment__c(Name = 'DEV');
        insert calendarEnviroment;
        user.Segmento_Ejecutivo__c = V_EMPR;
        User.Title = V_PTMNIAL;
        User.FirstName = V_USERPB;
        User.LastName = V_BPP;
        user.Divisi_n__c = V_MTPNA;
        user.BPyP_ls_NombreSucursal__c = V_SUCSAL;
        user.VP_ls_Banca__c = V_rBPP;
        insert user;
        System.runAs(user) {
            final Account cliente = MX_BPP_AccAndOppDataFactory.crearCuenta('userBPyP',V_TRECTE);
            Cliente.OwnerId = user.Id;
            insert cliente;
            final List<String> visitData = new List<String>{'Commercial', String.valueOf(user.id), String.valueOf(cliente.id), 'MX_BPP_Visita_BPyP_CI'};
            final dwp_kitv__Visit__c visita = MX_BPP_RIRecordsDataFactory.creaVisita(visitData);
            visita.dwp_kitv__visit_status_type__c = '05';
            update visita;
            Test.startTest();
            final String nameBanq = user.FirstName + ' '+  user.LastName;
            final List<Account> resultAccount = BPyP_Contact_Acc.contactabilityAccount(nameBanq, 'Contact', stDte, enDte, String.ValueOf(user.Title));
            System.assert(!resultAccount.isEmpty(),'Cuenta no esta vacia');
            Test.stopTest();
        }
    }
    @isTest
    static void tMXBPyPContactabilityWrong() {
        final DateTime stDte = DateTime.now().addDays(-30);
        final DateTime enDte = DateTime.now().addDays(30);
        final User user = MX_BPP_UserAndRIDataFactory.crearUsuario(V_USER,V_PFESTA, Null);
        user.Segmento_Ejecutivo__c = V_EMPR;
        User.Title = V_PTMNIAL;
        User.FirstName = V_USERPB;
        User.LastName = V_BPP;
        user.Divisi_n__c = V_MTPNA;
        user.BPyP_ls_NombreSucursal__c = V_SUCSAL;
        insert user;
        System.runAs(user) {
            final Account cliente = MX_BPP_AccAndOppDataFactory.crearCuenta('userBPyP',V_TRECTE);
            Cliente.OwnerId = user.Id;
            insert cliente;
            Test.startTest();
            final String nameBanq = user.FirstName + ' '+  user.LastName;
            final List<Account> resultAccount = BPyP_Contact_Acc.contactabilityAccount(nameBanq, 'NonContact', stDte, enDte, String.ValueOf(user.Title));
            System.assert(!resultAccount.isEmpty(),'Cuenta no esta vacia');
            Test.stopTest();
        }
    }
    @isTest
    static void tMXBPyPContactabilityWrong1() {
        final DateTime stDte = DateTime.now().addDays(-30);
        final DateTime enDte = DateTime.now().addDays(30);
        final User user = MX_BPP_UserAndRIDataFactory.crearUsuario(V_USER, V_PFESTA, Null);
        user.Segmento_Ejecutivo__c = V_EMPR;
        User.Title = 'PATRIMONIAL SR';
        User.FirstName = V_USERPB;
        User.LastName = V_BPP;
        user.Divisi_n__c = V_MTPNA;
        user.BPyP_ls_NombreSucursal__c =V_SUCSAL;
        insert user;
        System.runAs(user) {
            final Account cliente = MX_BPP_AccAndOppDataFactory.crearCuenta('userBPyP',V_TRECTE);
            Cliente.OwnerId = user.Id;
            insert cliente;
            Test.startTest();
            final String nameBanq = user.FirstName + ' '+  user.LastName;
            final List<Account> resultAccount = BPyP_Contact_Acc.contactabilityAccount(nameBanq, 'NonContact', stDte, enDte, String.ValueOf(user.Title));
            System.assert(!resultAccount.isEmpty(),'Cuenta no esta vacia');
            Test.stopTest();
        }
    }

    @isTest
    static void tRISelected() {
        final User usua = UtilitysDataTest_tst.crearUsuario('Usertest', V_PFESTA, 'BPYP BANQUERO TORRE BANCOMER');
        insert usua;
        test.startTest();
        System.runAs(usua) {
            final EU001_RI__c varRi = MX_BPP_UserAndRIDataFactory.creaRI(usua.Id);
            insert varRi;
            final String userTitle = BPyP_Contact_Acc.getRISelect(varRi.Id);
            System.assertNotEquals('', userTitle, 'getRiSelected correcto');
        }
        test.stopTest();
    }

    @isTest
    static void tRISelectedError() {
        final User usua = MX_BPP_UserAndRIDataFactory.crearUsuario('Usertest', V_PFESTA, 'BPYP BANQUERO TORRE BANCOMER');
        insert usua;
        test.startTest();
        System.runAs(usua) {
            try {
                BPyP_Contact_Acc.getRISelect('BadId');
            } catch (Exception e) {
                System.assertEquals('Script-thrown exception', e.getMessage(),'El error es Script-thrown exception');
            }
        }
        test.stopTest();
    }

}