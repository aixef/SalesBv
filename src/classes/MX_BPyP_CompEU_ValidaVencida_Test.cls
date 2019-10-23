/**
* _________________________________________________________________________________
* @Name     MX_BPyP_CompEU_ValidaVencida_Test
* @Author   Edmundo Zacarias edmundo.zacarias.contractor@bbva.com
* @Date     2019-07-11
* @Group    BPyP
* @Description Clase de pruebas de la clase MX_BPyP_CompEU_ValidaVencida_Batch.
* @Changes
*
* _________________________________________________________________________________
*/
@isTest
private class MX_BPyP_CompEU_ValidaVencida_Test {
    /*Variable entera MAX_OPS*/
    static final Integer MAX_OPS = 2;
    /*Lista thisUser que almacena los Id´s de los usuarios*/
    static List<User> thisUser = [ SELECT Id FROM User WHERE Id = :UserInfo.getUserId() ];
    /*Variable String que almacena los msjes Assert*/
    static String assertMsg;
    /**
    * _____________________________________________________________________________
    * @Description   Método que inserta registros de prueba para toda la clase.
    * _____________________________________________________________________________
    * @Author Edmundo Zacarias edmundo.zacarias.contractor@bbva.com
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

            final List<Opportunity> oportunidades = new List<Opportunity>();
            String strNombre;
            Opportunity oportunidad;
            UtilitysDataTest_tst.crearProdForm('Colocación', 'Collares');
            for (Integer i = 0; i < MAX_OPS; i++) {
                strNombre = 'Oportunidad Test ' + (i + 1);
                oportunidad = UtilitysDataTest_tst.crearOportunidad(strNombre, prospecto.Id, usrBanquero.Id, 'Colocación', 'Collares', null, 'MX_BPP_RedBpyp');
                oportunidad.CloseDate = Date.today();
                oportunidad.StageName = 'Abierta';
                oportunidad.OrigenOportunidad__c = 'Identificación propia';
                oportunidades.add(oportunidad);
            }
            insert oportunidades;

            final EU001_RI__c reunionIndividual = MX_BPP_UserAndRIDataFactory.creaRI(usrBanquero.Id);
            insert reunionIndividual;

            final List<EU_001_Compromiso__c> compromisosEU = new List<EU_001_Compromiso__c>();
             EU_001_Compromiso__c compromiso;
            for (Opportunity op:oportunidades) {
                compromiso = MX_BPP_RIRecordsDataFactory.genereteCompromisoEU('MX_BPP_CompColocacion', 'Colocación', 'Abierto', 0, op.Id, reunionIndividual.Id);
                compromiso.EU_fm_Fecha_Cierre__c = Date.today().addDays(-15);
                compromisosEU.add(compromiso);
            }
            insert compromisosEU;
        }
    }

	@isTest
    static void schedulerTest() {
        assertMsg = 'No se ejectuó';

        Test.startTest();
        final MX_BPyP_CompEU_ValidaVencida_Bs scheduledClass = new MX_BPyP_CompEU_ValidaVencida_Bs();
        final String cronExpr = Label.MX_BPyP_CronExpr_Batch;
        final String jobId = System.schedule('myJobTes', cronExpr, scheduledClass);
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM CronTrigger WHERE id = :jobId], assertMsg);
    }

    @isTest
    static void batchTest() {
        assertMsg = 'Problema con el insert de registros';
        Test.startTest();
        final MX_BPyP_CompEU_ValidaVencida_Batch vvBatch = new MX_BPyP_CompEU_ValidaVencida_Batch();
        Database.executeBatch(vvBatch);
        Test.stopTest();

        System.assertEquals(MAX_OPS, [SELECT COUNT() from EU_001_Compromiso__c where EU_001_ls_Estatus__c = 'Vencido'], assertMsg);
    }
}