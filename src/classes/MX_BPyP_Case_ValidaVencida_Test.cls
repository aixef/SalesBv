/**
* _________________________________________________________________________________
* @Name     MX_BPyP_Case_ValidaVencida_Test
* @Author   Mario Calderón
* @Date     2019-07-11
* @Group    BPyP
* @Description Clase de pruebas de la clase MX_BPyP_Case_ValidaVencida_Batch.
*				*Basado en MX_BPyP_CompEU_ValidaVencida_Test
* @Changes
*
* _________________________________________________________________________________
*/
@isTest
private class MX_BPyP_Case_ValidaVencida_Test {
    /*Variable MAX_OPS  inicializada*/
    static final Integer MAX_OPS = 2;
    /*Lista thisUser almacena Id´s del objeto usuario */
    static List<User> thisUser = [ SELECT Id FROM User WHERE Id = :UserInfo.getUserId() ];
    /*Variable para msjes Assert*/
    static String assertMsg;
    /**
    * _____________________________________________________________________________
    * @Description   Método que inserta registros de prueba para toda la clase.
    * _____________________________________________________________________________
    * @Author Mario Calderón
    * @Date 2019-07-11
    * _____________________________________________________________________________
    **/
    @testSetup
    static void setup() {
        System.runAs(thisUser[0]) {
            final User usrBanquero = UtilitysDataTest_tst.crearUsuario('BPyPCompEu', 'BPyP Estandar', 'BPYP BANQUERO LOMAS');
            insert usrBanquero;

            final List<PermissionSet> pSets = [SELECT Id FROM PermissionSet WHERE Name IN ('BPyP_Accesos', 'MX_BPP_RI', 'MX_BPP_VisitaBPyP')];
            final List<PermissionSetAssignment> asignacionesPS = new List<PermissionSetAssignment>();
            for(PermissionSet ps : pSets) {
                asignacionesPS.add(new PermissionSetAssignment(AssigneeId = usrBanquero.id, PermissionSetId = ps.Id));
            }
            insert asignacionesPS;

            final Account prospecto = UtilitysDataTest_tst.crearCuenta('Cliente Test BPyP', 'BPyP_tre_noCliente');
            prospecto.No_de_cliente__c = '';
            prospecto.OwnerId = usrBanquero.Id;
            insert prospecto;

            final EU001_RI__c reunionIndividual = MX_BPP_UserAndRIDataFactory.creaRI(usrBanquero.Id);
            insert reunionIndividual;

            final List<Case> apoyosBPyP = new List<Case>();

            final Case apoyo1 = UtilitysDataTest_tst.crearCaso(prospecto,'Abierto','','Apoyos');
            apoyo1.EU001_fh_Fecha_propuesta_de_cierre__c = Date.today().addDays(-15);
            apoyosBPyP.add(apoyo1);

            final Case apoyo2 = UtilitysDataTest_tst.crearCaso(prospecto,'Abierto','','Apoyos');
            apoyo2.EU001_fh_Fecha_propuesta_de_cierre__c = Date.today().addDays(-15);
            apoyosBPyP.add(apoyo2);

            insert apoyosBPyP;
        }
    }

    @isTest
    static void schedulerTest() {
        assertMsg = 'No se ejecutó';

        Test.startTest();
            final MX_BPyP_Case_ValidaVencida_Bs scheduledClass = new MX_BPyP_Case_ValidaVencida_Bs();
            final String cronExpr = Label.MX_BPyP_CronExpr_Batch;
            final String jobId = System.schedule('myJobTes', cronExpr, scheduledClass);
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM CronTrigger WHERE id = :jobId], assertMsg);
    }

    @isTest
    static void batchTest() {
        assertMsg = 'Problema con el insert de registros';
        Test.startTest();
            final MX_BPyP_Case_ValidaVencida_Batch vvBatch = new MX_BPyP_Case_ValidaVencida_Batch();
            Database.executeBatch(vvBatch);
        Test.stopTest();

        System.assertEquals(MAX_OPS, [SELECT COUNT() FROM Case WHERE Status = 'Vencido'], assertMsg);
    }
}