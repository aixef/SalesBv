/****************************************************************************************************
*   @Desarrollado por:      Indra                                                                   *
*   @Autor:                 Arsenio Perez Lopez                                                     *
*   @Proyecto:              Bancomer                                                                *
*   @Descripción:           Test de Account                                                         *
*                                                                                                   *
*   Cambios (Versiones)                                                                             *
*   --------------------------------------------------------------------------                      *
*   No.     Fecha               Autor                   Descripción                                 *
*   ------  ----------  ----------------------      ---------------------------                     *
*   1.0     21/01/2018  Arsenio perez lopez             Creación Test                               *
*   1.01    06/03/2018  Ricardo Almanza Angeles         agregar cambio grupo opps                   *
*   1.02    06/03/2018  Ricardo Almanza Angeles         agregado cambios para ContUsrTrigger        *
*   1.03    26/03/2018  Ricardo Almanza Angeles         amejora para cobertura                      *
*   1.04    02/05/2018  Carlos Ricardo Hernandez        Agrega RV para carterizar                   *
*   1.05    11/09/2018  Jhovanny De La Cruz Cruz        Agregamos Acción Comercial a Carterizar     *
*   1.1     04/10/2018  Cristian Espinosa               Se elimina dependencia a Producto__c        *
*   1.2     03/12/2018  Cristian Espinosa               Se re estructura la clase para que cumpla   *
*                                                       los estándares actuales.                    *
*   1.3     04/12/2018  Jhovanny De La Cruz Cruz        Agregamos Tarifario a Carterizar            *
*   1.4     16/01/2019  Mario A. Calderón Muñoz         Se agrega cambio de propietario para BPyP   *
*   1-5     17/01/2019  Hugo I. Carrillo Béjar          Se agrega la etiqueta                       *
*                                                       Label.MX_BPP_Profile_SystemAdministrator    *
*                                                       para la creación del admin user.            *
*   1-6     27/08/2019  Gabriel García                  Solución de codesmell
*   1-7     02/09/2019  Jair Ignacio Fonzalez Gayosso   Se ajusta creacion de Oportunidad           *
*****************************************************************************************************/
@isTest
private class Account_tgr_test {
    /** variable thisUser */
    static User thisUser;
    /** variable adminUser*/
    static User adminUser;
    /** variable bpypUser*/
    static User bpypUser;
    /** variable cont*/
    static Contact cont;

    @testSetup static void makeData() {
        final Trigger_Oportunidad__c config = new Trigger_Oportunidad__c(SetupOwnerId = UserInfo.getOrganizationId(), BPyP_ClienteImportar_cls__c = true);
        insert config;
        final gcal__GBL_Google_Calendar_Sync_Environment__c calEnviro = new gcal__GBL_Google_Calendar_Sync_Environment__c(Name = 'DEV');
        insert calEnviro;
    }

    static void setupUsers() {
        if(thisUser == null) {
            thisUser = [SELECT id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        }
        final User officeDirector = MX_BPP_AccountDataFactory.getDirectorOfficeUser();
        insert officeDirector;
        if(adminUser == null) {
            adminUser = UtilitysDataTest_tst.crearUsuario('Administrator', Label.MX_PERFIL_SystemAdministrator,'BBVA ADMINISTRADOR');
            adminUser.VP_ls_Banca__c = 'Red BPyP';
            adminUser.Director_de_oficina__c = officeDirector.Id;
            insert adminUser;
            System.debug('created admin user');
        }
        if(bpypUser == null) {
            bpypUser = MX_BPP_AccountDataFactory.getBPYPStandardUser();
            bpypUser.Director_de_oficina__c =  officeDirector.Id;
            insert bpypUser;
            final PermissionSet permSet = [SELECT Id FROM PermissionSet WHERE Name = 'BPyP_Accesos'];
            insert new PermissionSetAssignment(AssigneeId = bpypUser.id, PermissionSetId = permSet.Id);
        }
    }

    static void crearContacto(Account acc) {
        if(null == cont) {
            cont = UtilitysDatatest_tst.crearContacto(acc.Id, 'xyzFirst', 'XyZLast', null);
            cont.Email = 'xyzmail@mail.com';
            insert cont;
        }
    }

    @isTest static void constructor() {
        setupUsers();
        System.runAs(adminUser) {
            final Id personAccountRTId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get('MX_BPP_PersonAcc_NoClient').getRecordTypeId();
            //Account acc = UtilitysDataTest_tst.crearCuenta('Justino Flores', 'BPyP_tre_noCliente');
            Account acc = new Account();
            acc.FirstName = 'Justino';
            acc.LastName = 'Flores';
            final Double ramdomNoCliente = Math.random()*10000000;
            acc.No_de_cliente__c = String.valueOf(ramdomNoCliente.round());
            acc.PersonBirthdate = System.today();
            acc.MX_Occupation__pc = 'ABARROTES';
            acc.MX_OccupationCode__pc = 'ABT';
            acc.RecordTypeId = personAccountRTId;
            insert acc;

            UtilitysDataTest_tst.crearProdForm('Colocación', 'Collares');

            final Opportunity opp = UtilitysDataTest_tst.crearOportunidad('Test 001', acc.Id, UserInfo.getUserId(), 'Colocación', 'Collares', null, 'MX_BPP_RedBpyp');
            opp.StageName ='Propuesta';
            insert opp;

            Test.startTest();
            acc.LastName = 'Flores H.';
            update acc;

            acc.OwnerId = bpypUser.Id;
            update acc;
            Test.stopTest();
            acc = [Select OwnerId from Account where Id =: acc.Id];
            System.assertEquals(bpypUser.Id, acc.OwnerId , 'El owner de la cuenta no se actualizó.');
        }
    }

    @isTest
    static void relatedRecordAssignment() {
        setupUsers();
        System.runAs(adminUser) {
            final Account acc = UtilitysDataTest_tst.crearCuenta('Justino Flores', 'BPyP_tre_Cliente');
            insert acc;
            final Contact con = UtilitysDataTest_tst.crearContacto(acc.Id, 'Test', 'Test', '');
            insert con;
            Ficha_de_conocimiento__c ficha = MX_BPP_AccountDataFactory.creaPlanDCuenta(acc.Id, con.Id);
            final Task tarea = MX_BPP_AccountDataFactory.crearVisitaComercial(acc.Id,con.Id);
            tarea.Status = 'No iniciado';
            insert tarea;
            final Event evento = MX_BPP_AccountDataFactory.CrearEventoConTiempos(acc.Id,con.Id);
            insert evento;
            final BPyP0023_CPC__c cono = MX_BPP_AccountDataFactory.crearConocimiento(acc.Id, 'BPyP0023_tre_CPC');
            System.debug('cono rt: ' + cono.RecordTypeId);
            insert cono;
            System.debug('cono ' + cono.OwnerId + ' vs ' + bpypUser.Id);

            Test.startTest();
            acc.OwnerId = bpypUser.Id;
            update acc;
            Test.stopTest();

            ficha = [Select OwnerId from Ficha_de_conocimiento__c where Id =: ficha.Id];
            System.assertEquals(bpypUser.Id, ficha.OwnerId, 'El plan de cuenta no fue reasignado correctamente.');
        }
    }

    @isTest
    static void changeAccountParent() {
        setupUsers();
        Test.startTest();
        System.runAs(adminUser) {
            final Account parent = UtilitysDataTest_tst.crearCuenta('Parent Account', 'BPyP_tre_familyGroup');
            final Account parent2 = UtilitysDataTest_tst.crearCuenta('Parent Account 2', 'BPyP_tre_familyGroup');
            final List<Account> parents = new List<Account>();
            parents.add(parent);
            parents.add(parent2);
            insert parents;

            Account acc = UtilitysDataTest_tst.crearCuenta('Justino Flores', 'BPyP_tre_Cliente');
            insert acc;
            acc.MX_GroupItBelongs__c = parent2.Id;
            update acc;
            Test.stopTest();

            acc = [Select BPyP_Rb_Family_Group_al_que_pertenece__c from Account where Id =: acc.Id];
            System.assertEquals(parent2.Id, acc.BPyP_Rb_Family_Group_al_que_pertenece__c, 'No se actualizó el grupo de familia correctamente.');
        }
    }

    @isTest
    static void deleteAccountParent() {
        setupUsers();
        Test.startTest();
        System.runAs(bpypUser) {
            final Account parent = UtilitysDataTest_tst.crearCuenta('Parent Account', 'BPyP_tre_familyGroup');
            insert parent;

            Account acc = UtilitysDataTest_tst.crearCuenta('Justino Flores', 'BPyP_tre_Cliente');
            acc.BPyP_ca_FamilyGaCliente__c = false;
            acc.MX_GroupItBelongs__c = parent.Id;
            acc.OwnerId = bpypUser.Id;
            insert acc;
            acc.put('MX_GroupItBelongs__c','');
            update acc;
            Test.stopTest();

            acc = [Select BPyP_Rb_Family_Group_Candidato__c, MX_GroupItBelongs__c, BPyP_ca_FamilyGaCliente__c, BPyP_Rb_Family_Group_al_que_pertenece__c
                   from Account where Id =: acc.Id];
            System.assertEquals(parent.Id, acc.BPyP_Rb_Family_Group_Candidato__c, 'No se copió la cuenta padre previa al Family Group Candidato');
            //System.assertEquals(null, acc.MX_GroupItBelongs__c, 'No se eliminó la cuenta padre correctamente.');
            //System.assertEquals(false, acc.BPyP_ca_FamilyGaCliente__c, 'No se desactivó el campo Family Group a Cliente');
            //System.assertEquals(null, acc.BPyP_Rb_Family_Group_al_que_pertenece__c, 'No se eliminó el valor en el Family Group.');
        }
    }
}