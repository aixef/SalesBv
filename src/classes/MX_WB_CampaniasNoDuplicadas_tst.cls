/**-------------------------------------------------------------------------
 * Nombre: MX_WB_CampaniasNoDuplicadas_tst
 * Autor Ing. Eduardo Hernandez
 * Proyecto: MW WB Telemarketing - BBVA Bancomer
 * Descripción : Clase Test para el trigger de Campaign
 * --------------------------------------------------------------------------
 * Versión 		Fecha			Autor					Descripción
 * -------------------------------------------------------------------
 * 1.0			13/02/2019		Ing. Eduardo Hernandez	Creación
 * 1.0			13/02/2019		Ing. Eduardo Hernandez	Se cambia el métod0 de assertEquals() ah assert()
 * 1.0			15/02/2018		Eduardo Hernández	 	Downgrade version a 44
 * 1.1          17/04/2019      Arsenio Perez Lopez     Se agrega el metod0 TestTrigger1 para el nuevo modelo de datos.
 * --------------------------------------------------------------------------
 */
@isTest
private class  MX_WB_CampaniasNoDuplicadas_tst {

    
    @TestSetup
    static void makeData() {
        final MX_WB_FamiliaProducto__c testfamilia =  MX_WB_TestData_cls.createProductsFamily('Test Familia');
        insert testFamilia;
        Final MX_SB_VTS_ProveedoresCTI__c provedorCTI = MX_WB_TestData_cls.ProvedorCTI('Provedor');
        Insert ProvedorCTI;
        final MX_SB_VTS_FamliaProveedores__c familiaProvedor = MX_WB_TestData_cls.FamiliaProvedores(testFamilia.Id, provedorCTI.Id);
        Insert familiaProvedor;
    }

    @isTest
    private static void newCampaign() {
        final Campaign testCampaign = MX_WB_TestData_cls.createCampania('Test Camp');
        testCampaign.MX_WB_FamiliaProductos__c =[Select id from MX_WB_FamiliaProducto__c where name = 'Test Familia' limit 1].Id;
        insert testCampaign;
     	final Lead testLead = MX_WB_TestData_cls.createLead('Test Data');
        testLead.LeadSource = 'Outbound TLMK';
     	insert testLead;
        Test.startTest();
        	final CampaignMember testMember = MX_WB_TestData_cls.createCampaignMember(testLead.Id, testCampaign.Id);
            database.insert (testMember, false);
        	System.assert(!String.isBlank(testMember.Id));
        Test.stopTest();
    }
        
    @isTest
    private static void secondNewUpdate() {
        Test.startTest();
        	final Campaign camp = new Campaign();
            Id campId = [Select id from MX_WB_FamiliaProducto__c where name = 'Test Familia' limit 1].Id;
        	camp.Name = 'TestCampaign';
        	camp.IsActive = true;
        	camp.MX_WB_FamiliaProductos__c = campId;
        	camp.StartDate = system.date.Today();
        	camp.EndDate = system.date.Today();
        	insert camp;
            final Campaign testCampaign = MX_WB_TestData_cls.createCampania('Test Camp');
            testCampaign.MX_WB_FamiliaProductos__c = campId;
        	testCampaign.IsActive = true;
            insert testCampaign;
            final Lead testLead = MX_WB_TestData_cls.createLead('Test Data');
            testLead.LeadSource = 'Outbound TLMK';
            insert testLead;
        	MX_WB_TestData_cls.createCampaignMember(testLead.Id, testCampaign.Id);
        	final Campaign testCampaign2 = MX_WB_TestData_cls.createCampania('Test Camp 2');
            testCampaign.MX_WB_FamiliaProductos__c = campId;
            insert testCampaign2;
        	camp.IsActive = true;
        	update camp;
        	System.assert(!String.isBlank(camp.Id));
        Test.stopTest();
    }
    /**
        Test para validar EL funcionamiento del triger de campaing bajo creacion modificacion
        con leads creados activando y desactivando. para el nuevo paradigma del modelo de datos.
     */
    @istest private static void testTrigger1() {
        Test.startTest();
            final Campaign camp = new Campaign();
            Id fampId = [Select id from MX_WB_FamiliaProducto__c where name = 'Test Familia' limit 1].Id;
            Id famProv = [Select id from MX_SB_VTS_FamliaProveedores__c where MX_SB_VTS_Familia_de_productos__c =:fampId limit 1].Id;
        	camp.Name = 'TestCampaign';
        	camp.IsActive = true;
        	camp.MX_WB_FamiliaProductos__c = fampId;
            camp.MX_SB_VTS_FamiliaProducto_Proveedor__c= famProv;
        	camp.StartDate = system.date.Today();
        	camp.EndDate = system.date.Today();
        	insert camp;
            final Campaign testCampaign = MX_WB_TestData_cls.createCampania('Test Camp');
            testCampaign.MX_WB_FamiliaProductos__c = fampId;
            testCampaign.MX_SB_VTS_FamiliaProducto_Proveedor__c= famProv;
        	testCampaign.IsActive = true;
            insert testCampaign;
            final Lead testLead = MX_WB_TestData_cls.createLead('Test Data');
            testLead.LeadSource = 'Outbound TLMK';
            insert testLead;
        	final CampaignMember campmem =MX_WB_TestData_cls.createCampaignMember(testLead.Id, testCampaign.Id);
            insert campmem;
        	final Campaign testCampaign2 = MX_WB_TestData_cls.createCampania('Test Camp 2');
            testCampaign2.MX_WB_FamiliaProductos__c = fampId;
            testCampaign2.MX_SB_VTS_FamiliaProducto_Proveedor__c= famProv;
            insert testCampaign2;
        	camp.IsActive = true;
        	update camp;
            System.assert(camp.IsActive);
        Test.stopTest();
    }
}