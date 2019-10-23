/**
* Indra
* @author           Javier Ortiz Flores
* Project:          Telemarketing
* Description:      Clase test MX_WB_LeadCampaign_cls.
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     2018-12-18      Javier Ortiz F.		    Creación de la Clase
* @version  1.1     2019-02-14      Eduardo Hernández		Cobertura de clase MX_WB_LeadCampaign_cls
********************************************************************************************************************************************/
@isTest
public class MX_WB_LeadCampaign_tst {
	@isTest
    /** 
    *Method creaLeadMark
    */
    public static void creaLeadMark() {
        final Campaign camp = new Campaign();
        final MX_WB_FamiliaProducto__c testFamilia = MX_WB_TestData_cls.createProductsFamily('Test Familia');
        insert testFamilia;
        camp.Name = 'TestCampaign';
        camp.IsActive = true;
        camp.MX_WB_FamiliaProductos__c = testFamilia.Id;
        camp.StartDate = system.date.Today();
        camp.EndDate = system.date.Today();
        insert camp;
        final Lead prospecto1 = MX_WB_TestData_cls.createLead('Ortiz');
        prospecto1.LeadSource = 'Outbound';
        insert prospecto1;
        final CampaignMember testMember = MX_WB_TestData_cls.createCampaignMember(prospecto1.Id, camp.Id);
        database.insert (testMember, false);
        System.assert(!String.isBlank(testMember.Id), 'Id de registro');
    }

    @isTest
    /** 
    *Method creaLeadMarkDisabled
    */
    public static void creaLeadMarkDisabled() {
        final Campaign camp = new Campaign();
        final MX_WB_FamiliaProducto__c testFamilia = MX_WB_TestData_cls.createProductsFamily('Test Familia');
        insert testFamilia;
        camp.Name = 'TestCampaign';
        camp.IsActive = false;
        camp.MX_WB_FamiliaProductos__c = testFamilia.Id;
        camp.StartDate = system.date.Today();
        camp.EndDate = system.date.Today();
        insert camp;
        final Lead prospecto1 = MX_WB_TestData_cls.createLead('Ortiz');
        prospecto1.LeadSource = 'Outbound';
        insert prospecto1;
        final CampaignMember testMember = MX_WB_TestData_cls.createCampaignMember(prospecto1.Id, camp.Id);
        database.insert (testMember, false);
        System.assert(!String.isBlank(testMember.Id), 'Id de Registro');
    }
}