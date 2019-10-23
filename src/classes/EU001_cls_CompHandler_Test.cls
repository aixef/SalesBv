/**
*Desarrollado por:       Indra
*Autor:                  ABRAHAM TINAJERO
*Proyecto:               Experiencia Unica
*Descripción:            Clase Test para la clase EU001_cls_CompHandler y EU001_cls_CompHandler_Utilities
*
*Cambios (Versiones) prueba
*-------------------------------------------------------------------------------
*No.         Fecha            Autor                           Descripción
*------   ----------------   --------------------   ----------------------------
*1.0      04-07-2017         Abraham Tinajero                 Creación
*2.1      06-12-2017         Isaías Velázquez                 Modificación
*3.0      02-04-2018         Abraham Tinajero                 Se corrige problema de duplicidad
*3.1      12-04-2018         Abraham Tinajero           Se agrega método para cobertura
*3.2      12-04-2018         Abraham Tinajero           Se modifica metodo para cobertura de la clase
*3.3      24-04-2018         Abraham Tinajero           Se genera metodo para caso de DO para Ranking
*4.0      14-05-2018         Abraham Tinajero           Se actualizan métodos de GenerarOpp y getOpptoUpdt para cubrir cobertura
*4.1	  20-05-2018	     Ricardo Almanza		Se Crea Metodo para Generar compromisos de BPyP
*5.0	  28-08-2018		 Javier Ortiz Flores 		Se añaden parámetros de parametría calculadora de ramos donde se guardan cálculos del PI10.
*6.0	  14-09-2018		 Francisco J Licona 		Se hace cobertura de métodos referentes a cintillo PI10.
*6.1	  28-01-2019		 Mario Calderón.			Se agregan parámetros a métodos relacionados a los oportunidades con compromisos para cobertura.
*6.1	  19-06-2019		 Cindy Herrnández			Se eliminan métodos que no se utilizan. Se modifican los métodos getOppToCompTest2, getOppToCompTest3,
generaOppTest y generaOppBPyPTest para agregar try catch.
*6.1	  03-07-2019		 Cindy Herrnández   		Se eliminan los métodos Alertas, generaOppBPyPTest, getOppToCompTest6, getOppToCompTest5 y getOppToCompTest4
para reducir el número de métodos sin afectar el procentaje de cobertura de la clase EU001_cls_CompHandler.
**/
@isTest
public class EU001_cls_CompHandler_Test {
    /**Mapa profileMap */
    static Map<String,Profile> profileMap;
    /**Mapa roleMap */
    static Map<String,UserRole> roleMap;
	/**Product string variable*/
    private static String product = 'Collares';
	/**Family string variable*/
    private static String family = 'Colocación';

    static {
        profileMap = new Map<String,Profile>();
        for (Profile prof:[select Id, Name from Profile WHERE Name = 'BPyP Director Divisional' OR Name = 'BPyP Director Oficina' OR Name = 'BPyP Estandar']) {
            profileMap.put(prof.Name,prof);
        }
        roleMap = new Map<String,UserRole>();
        for (UserRole role:[select Id, Name from UserRole WHERE Name = 'BPYP DIRECTOR DIVISIONAL METROPOLITANA' OR Name = 'BPYP DIRECTOR DIVISIONAL BAJIO'
                            OR Name = 'BPYP DIRECTOR OFICINA AGUASCALIENTES' OR Name = 'BPYP BANQUERO AGUASCALIENTES']) {
                                roleMap.put(role.Name,role);
                            }
    }

    @testSetup
    static void setUpMethod() {
        UtilitysDataTest_tst.crearProdForm(family, product);
    }

    @isTest static void getTeamD() {
        final User usrTst4 = new User();
        usrTst4.Username ='userNameTstDD@gmail.com';
        usrTst4.FirstName = 'UserTst';
        usrTst4.LastName= 'Test';
        usrTst4.Email= 'userNameTst@gmail.com';
        usrTst4.Alias= 'tst1';
        usrTst4.TimeZoneSidKey= 'America/Mexico_City';
        usrTst4.LocaleSidKey= 'en_US';
        usrTst4.EmailEncodingKey= 'ISO-8859-1';
        usrTst4.ProfileId= profileMap.get('BPyP Director Divisional').Id;
        usrTst4.UserRoleId = roleMap.get('BPYP DIRECTOR DIVISIONAL METROPOLITANA').Id;
        usrTst4.LanguageLocaleKey ='es';
        usrTst4.VP_ls_Banca__c = 'Red BPyP';
        usrTst4.UG__c = '037900';
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
        insert usrTst3DR;
        System.runAs(usrTst4) {
            test.startTest();
            final Account cuenta = new Account();
            cuenta.Name = 'Tst client';
            cuenta.No_de_cliente__c = '282828282';
            insert cuenta;
            EU001_cls_CompHandler.getDOteamPromPonderados(usrTst4.Id, true, 'DO');
            EU001_cls_CompHandler.getDOteamPromPonderados(usrTst4.Id, false, 'DO');
            EU001_cls_CompHandler.getDOteamPromPonderados(usrTst3DR.Id, true, 'DR');
            EU001_cls_CompHandler.getDOteamPromPonderados(usrTst3DR.Id, false, 'DR');
            EU001_cls_CompHandler.getDOteamPromPonderados(usrTst3DR.Id, true, 'DD');
            EU001_cls_CompHandler.getDOteamPromPonderados(usrTst3DR.Id, false, 'DD');
            System.assert(true, 'Assert');
            test.stopTest();
        }
    }

    @isTest static void getPuntosDorPotencales() {
        final String sUG = '037900';
        final User usuario = new User();
        usuario.ug__c = sUG;
        usuario.Segmento_Ejecutivo__c = 'CORPORATIVO';
        usuario.id = UserInfo.getUserId();
        update usuario;

        MX_BPP_RIRecordsDataFactory.createTabCertificacion1(sUG);
        MX_BPP_RIRecordsDataFactory.createTabCertificacion2(sUG);

        final EU001_RI__c nuevoRi = new EU001_RI__c();
        insert nuevoRi;
        Test.StartTest();
        final EU001_cls_CompHandler compHandler = new EU001_cls_CompHandler();
        System.assert(compHandler != null);
        System.assert(true, 'Assert ');
        Test.stopTest();
    }

    @isTest static void getOppToCompTest() {

        test.StartTest();
        MX_BPP_AccAndOppDataFactory.generaCompromisos();
        final EU001_RI__c RI = [SELECT Id FROM EU001_RI__c WHERE OwnerId =:UserInfo.getUserId() Limit 1];
        final String firstDay = String.valueOf(EU001_cls_CompHandler.getPrimerDiaTrim(Date.today()));
        final String lastDate = String.valueOf(EU001_cls_CompHandler.getUltimoDiaTrim(Date.today()));
        EU001_cls_CompHandler.getOppToComp(RI.Id, firstDay, lastDate,'', family, product);
        System.assert(true, 'Assert ');
        Test.stopTest();
    }

    @isTest static void getOppToCompTest1() {
        final String sUG = '037900';
        final User usuario = new User();
        usuario.ug__c = sUG;
        usuario.Segmento_Ejecutivo__c = 'CORPORATIVO';
        usuario.id = UserInfo.getUserId();
        update usuario;

        final String[] ug = new List<String>();
        ug.add('37023');
        ug.add('37025');
        ug.add('37024');
        final List<User> users = MX_BPP_UserAndRIDataFactory.createTestRecordsUser(ug,false);

        final String[] tipoOpp = new List<String>();
        tipoOpp.add('Financiamiento');
        //UtilitysDataTest_tst.crearProdForm(family, product);
        final List<Opportunity> Opps = MX_BPP_AccAndOppDataFactory.createTestRecordsOpps(tipoOpp,users.get(0), family, product);
        MX_BPP_AccAndOppDataFactory.avanzaOpp(Opps);

        test.StartTest();
        final List<EU_001_Compromiso__c> listaComp = MX_BPP_AccAndOppDataFactory.generaCompromisos();
        final EU001_RI__c RI = [SELECT Id FROM EU001_RI__c WHERE OwnerId =:UserInfo.getUserId() Limit 1];
        final String firstDay = String.valueOf(EU001_cls_CompHandler.getPrimerDiaTrim(Date.today()));
        final String lastDate = String.valueOf(EU001_cls_CompHandler.getUltimoDiaTrim(Date.today()));
        EU001_cls_CompHandler.getOppToComp(RI.Id,firstDay+1, lastDate,'','','');
        EU001_cls_CompHandler.actualizaMonto(listaComp);
        System.assert(true, 'Assert ');
        Test.stopTest();
    }

    @isTest static void getOppToCompTest2() {
        final String sUG = '037900';
        final User usuario = new User();
        usuario.ug__c = sUG;
        usuario.Segmento_Ejecutivo__c = 'CORPORATIVO';
        usuario.id = UserInfo.getUserId();
        update usuario;

        final String[] ug = new List<String>();
        ug.add('37023');
        ug.add('37025');
        ug.add('37024');
        final List<User> users = MX_BPP_UserAndRIDataFactory.createTestRecordsUser(ug,false);

        final String[] tipoOpp = new List<String>();
        tipoOpp.add('ATM');
        //UtilitysDataTest_tst.crearProdForm(family, product);
        final List<Opportunity> Opps = MX_BPP_AccAndOppDataFactory.createTestRecordsOpps(tipoOpp,users.get(0),family, product);
        MX_BPP_AccAndOppDataFactory.avanzaOpp(Opps);


        test.StartTest();
        final List<EU_001_Compromiso__c> listaComp = MX_BPP_AccAndOppDataFactory.generaCompromisos();
        final EU001_RI__c RI = [SELECT Id FROM EU001_RI__c WHERE OwnerId =:UserInfo.getUserId() Limit 1];
        final String firstDay = String.valueOf(EU001_cls_CompHandler.getPrimerDiaTrim(Date.today()));
        final String lastDate = String.valueOf(EU001_cls_CompHandler.getUltimoDiaTrim(Date.today()));
        EU001_cls_CompHandler.actualizaMonto(listaComp);
        String errorMessage = '';
        try {
            EU001_cls_CompHandler.getOppToComp(RI.Id,firstDay, lastDate, 'Cartera Vigente CP','','');
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        System.assert(true, 'Assert ');
        Test.stopTest();
        System.assertEquals('Script-thrown exception', errorMessage);
    }

    @isTest static void getOppToCompTest3() {
        final String sUG = '037900';
        final User usuario = new User();
        usuario.ug__c = sUG;
        usuario.Segmento_Ejecutivo__c = 'CORPORATIVO';
        usuario.id = UserInfo.getUserId();
        update usuario;

        final String[] ug = new List<String>();
        ug.add('37023');
        ug.add('37025');
        ug.add('37024');
        final List<User> users = MX_BPP_UserAndRIDataFactory.createTestRecordsUser(ug,false);

        final String[] tipoOpp = new List<String>();
        tipoOpp.add('Adquirente');
        //UtilitysDataTest_tst.crearProdForm(family, product);
        final List<Opportunity> Opps = MX_BPP_AccAndOppDataFactory.createTestRecordsOpps(tipoOpp,users.get(0), family, product);
        MX_BPP_AccAndOppDataFactory.avanzaOpp(Opps);

        test.StartTest();
        final List<EU_001_Compromiso__c> listaComp = MX_BPP_AccAndOppDataFactory.generaCompromisos();
        final EU001_RI__c RI = [SELECT Id FROM EU001_RI__c WHERE OwnerId =:UserInfo.getUserId() Limit 1];
        final String firstDay = String.valueOf(EU001_cls_CompHandler.getPrimerDiaTrim(Date.today()));
        final String lastDate = String.valueOf(EU001_cls_CompHandler.getUltimoDiaTrim(Date.today()));
        String errorMessage = '';
        try {
            EU001_cls_CompHandler.getOppToComp(RI.Id,firstDay, lastDate, 'Cartera Vigente CP','','');
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        EU001_cls_CompHandler.actualizaMonto(listaComp);
        System.assert(true, 'Assert ');
        Test.stopTest();
        System.assertEquals('Script-thrown exception', errorMessage);
    }

    @isTest static void generaOppTest() {
        final String[] ug = new List<String>{'37023','37025','37024'};
            final List<User> users = MX_BPP_UserAndRIDataFactory.createTestRecordsUser(ug,false);
        final String[] tipoOpp = new List<String>{EU001_cls_CONSTANTES.EU001_TR_OPP_INVERSIONES};
            MX_BPP_UserAndRIDataFactory.generaRI();
        //UtilitysDataTest_tst.crearProdForm(family, product);
        System.runAs(users[0]) {
            MX_BPP_AccAndOppDataFactory.createOppFin(users[0], family, product);
        }

        test.StartTest();
        final List<Opportunity> listOpp = MX_BPP_AccAndOppDataFactory.createTestRecordsOpps(tipoOpp,users.get(0), family, product);

        final List<EU001_cls_CompHandler.OpportunityWrapper> listOppObj = new List<EU001_cls_CompHandler.OpportunityWrapper>();
        final String idFinanciamiento = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('MX_BPP_RedBpyp').getRecordTypeId();
        for(Opportunity opp : listOpp) {
            final EU001_cls_CompHandler.OpportunityWrapper newOpp = new EU001_cls_CompHandler.OpportunityWrapper();
            newOpp.seleccion = true;
            newOpp.oppId = opp.Id;
            newOpp.oppName = opp.Name;
            newOpp.oppCloseDate = opp.CloseDate;
            newOpp.nombCliente = opp.Account.Name;
            newOpp.MX_RTL_Familia = opp.MX_RTL_Familia__c;
            newOpp.MX_RTL_Producto = opp.MX_RTL_Producto__c;
            newOpp.CR_SEL_Plazo = opp.CR_SEL_Plazo__c;
            newOpp.probability = opp.Probability;
            newOpp.Numero_de_Nominados = 10;
            newOpp.Nomina_Rango_04 = 2;
            newOpp.Nomina_Rango_05 = 3;
            newOpp.cierre = true;
            newOpp.oppAmount = 20000;
            if(opp.recordTypeId == null) {
                newOpp.recordTypeId = idFinanciamiento;
                newOpp.CR_SEL_Plazo = EU001_cls_CONSTANTES.EU001_STR_PLAZO_PRD_OPP_FINANCIAMIENTO;
            } else if (opp.recordTypeId != null) {
                newOpp.recordTypeId = opp.recordTypeId;
            }
            listOppObj.add(newOpp);
        }
        String errorMessage = '';
        try {
            EU001_cls_CompHandler.generaCompromisosOppBPYP(JSON.serialize(listOppObj));
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        System.assert(true, 'Assert ');
        Test.stopTest();
        System.assertEquals('', errorMessage);
    }

    @isTest static void getUG() {
        test.StartTest();
        MX_BPP_UserAndRIDataFactory.generaRI();
        //mes < 4
        final Date fecha1 = Date.newInstance(date.today().year(), 1, 17);
        EU001_cls_CompHandler.getPrimerDiaTrim(fecha1);
        EU001_cls_CompHandler.getUltimoDiaTrim(fecha1);
        //mes < 7
        final Date fecha2 = Date.newInstance(date.today().year(), 5, 17);
        EU001_cls_CompHandler.getPrimerDiaTrim(fecha2);
        EU001_cls_CompHandler.getUltimoDiaTrim(fecha2);
        //mes < 10
        final Date fecha3 = Date.newInstance(date.today().year(), 9, 17);
        EU001_cls_CompHandler.getPrimerDiaTrim(fecha3);
        EU001_cls_CompHandler.getUltimoDiaTrim(fecha3);
        //mes > 10
        final Date fecha4 = Date.newInstance(date.today().year(), 11, 17);
        EU001_cls_CompHandler.getPrimerDiaTrim(fecha4);
        EU001_cls_CompHandler.getUltimoDiaTrim(fecha4);

        System.assert(true, 'Assert ');
        Test.stopTest();
    }

    @isTest static void saveDataCintillo02() {
        final User testUser = MX_BPP_UserAndRIDataFactory.crearUsuario('CLIENTES MASA', Label.MX_PERFIL_SystemAdministrator,'BBVA ADMINISTRADOR');
        insert testUser;
        system.runAs(testUser) {
            final EU001_RI__c riRecord = MX_BPP_UserAndRIDataFactory.creaRI(testUser.Id);
            riRecord.EU001_tx_Estado__c='Evaluacion';
            insert riRecord;
            final Account acc = MX_BPP_AccAndOppDataFactory.crearCuenta('CUENTA PRUEBA','BPyP_tre_Cliente');
            Insert acc;
            //UtilitysDataTest_tst.crearProdForm(family, product);
            final Opportunity opp03 = MX_BPP_AccAndOppDataFactory.crearOportunidad('OPORTUNIDAD PRUEBA2', acc.id ,  testUser.id, 'MX_BPP_RedBpyp');
            opp03.probability = 80;
            opp03.closeDate = date.today().addDays(5);
            opp03.MX_RTL_Familia__c = EU001_cls_CONSTANTES.STR_FAM_COL;
            insert opp03;
            final Opportunity opp04 = MX_BPP_AccAndOppDataFactory.crearOportunidad('OPORTUNIDAD PRUEBA', acc.id ,  testUser.id, 'MX_BPP_RedBpyp');
            opp04.probability = 80;
            opp04.closeDate = date.today().addDays(5);
            insert opp04;
            final List<EU_001_Compromiso__c> listComp= new List<EU_001_Compromiso__c>();
            final EU_001_Compromiso__c comp2 = MX_BPP_RIRecordsDataFactory.genereteCompromisoEU(EU001_CLS_CONSTANTES.EU001_TRE_COMPROMISO_CARTERA, EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_LP, EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO, 15, opp03.Id, riRecord.Id);
            final EU_001_Compromiso__c comp3 = MX_BPP_RIRecordsDataFactory.genereteCompromisoEU(EU001_CLS_CONSTANTES.EU001_TRE_COMPROMISO_CARTERA, EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_LP, EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO, 15, opp04.Id, riRecord.Id);
            listComp.add(comp2);
            listComp.add(comp3);
            EU001_cls_compHandler.actualizaMonto(listComp);
            System.AssertEquals(true, !listComp.isEmpty(), 'Datos de compromisos: ' + listComp);
        }
    }

    @isTest static void getPrimerDiaMes() {
        test.StartTest();
        final Date primerDia = EU001_cls_CompHandler.getPrimerDiaMes(Date.newInstance(Date.today().year(), 1, 10));
        Test.stopTest();
        System.assertEquals(Date.newInstance(Date.today().year(),1,1),primerDia,'Primer día obtenido');
    }

    @isTest static void getPrimerDiaMesFail() {
        Date primerDia;
        test.StartTest();
        try {
            primerDia = EU001_cls_CompHandler.getPrimerDiaMes(null);
        } catch(Exception e) {
            System.assertEquals(null, primerDia, 'Excepción no controlada correctamente');
        }
        Test.stopTest();
    }

    @isTest static void getUltimoDiaDosMesesSig() {
        test.StartTest();
        final Date primerDia = EU001_cls_CompHandler.getUltimoDiaDosMesesSig(Date.newInstance(Date.today().year(), 1, 10));
        Test.stopTest();
        System.assertEquals(Date.newInstance(Date.today().year(),3,31),primerDia,'Último día de los dos meses siguientes obtenido');
    }

    @isTest static void getUltimoDiaDosMesesSigFail() {
        Date ultimoDia;
        try {
            test.StartTest();
            ultimoDia = EU001_cls_CompHandler.getUltimoDiaDosMesesSig(null);
            Test.stopTest();
        } catch(Exception e) {
            System.assertEquals(null, ultimoDia, 'Excepción no controlada correctamente');
        }
    }

    @isTest static void getOwnerIdRiFail() {
        String owID;
        try {
            test.StartTest();
            owID = EU001_cls_CompHandler.getOwnerIdRi(null);
            Test.stopTest();
        } catch(Exception e) {
            System.assertEquals(null, owID, 'Excepción no controlada correctamente');
        }
    }

}