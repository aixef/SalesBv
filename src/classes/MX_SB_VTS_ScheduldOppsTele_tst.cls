/**
 * @File Name          : MX_SB_VTS_ScheduldOppsTele_tst.cls
 * @Description        : 
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              : 
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 7/10/2019 22:38:46
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    7/10/2019   Eduardo Hernández Cuamatzi     Initial Version
**/
@isTest
private class MX_SB_VTS_ScheduldOppsTele_tst { //NOSONAR

    /**Request service */
    final static String TXTPOST = 'POST', URLLOCAL = 'local.MXSBVTSCache',URLEXA='http://www.example.com';
    
    @TestSetup
    static void makeData(){
        final Id idAgente = UserInfo.getUserId();
        final Account accRec = MX_WB_TestData_cls.crearCuenta('LastName', 'PersonAccount');
        accRec.Phone = '5512345678';
        insert accRec;

        final MX_WB_FamiliaProducto__c objFamilyPro2 = MX_WB_TestData_cls.createProductsFamily ( 'Daños' );
        insert objFamilyPro2;

        final Product2 proHogar = MX_WB_TestData_cls.productNew ( System.Label.MX_SB_VTS_Hogar );
        proHogar.IsActive = true;
        proHogar.MX_WB_FamiliaProductos__c = objFamilyPro2.Id;
        insert proHogar;

        final Opportunity opp = MX_WB_TestData_cls.crearOportunidad('LastName', accRec.Id, idAgente, System.Label.MX_SB_VTS_Telemarketing_LBL);
        opp.Producto__c = 'Hogar';
        opp.TelefonoCliente__c = '5512341231';
        insert opp;

        final MX_SB_VTS_ProveedoresCTI__c smartProv = new MX_SB_VTS_ProveedoresCTI__c();
        smartProv.Name = 'Smart Center';
        smartProv.MX_SB_VTS_Identificador_Proveedor__c = 'SMART CENTER';
        smartProv.MX_SB_VTS_TieneSegmento__c = true;
        smartProv.MX_SB_VTS_IsReadyCTI__c = true;
        insert smartProv;
        
        final MX_SB_VTS_FamliaProveedores__c famProSmart = new MX_SB_VTS_FamliaProveedores__c();
        famProSmart.MX_SB_VTS_Familia_de_productos__c = objFamilyPro2.Id;
        famProSmart.Name = 'Daños SmartCenter';
        famProSmart.MX_SB_VTS_ProveedorCTI__c = smartProv.Id;
        insert famProSmart;

        final MX_SB_VTS_Lead_tray__c hotLeadsSmart = new MX_SB_VTS_Lead_tray__c();
        hotLeadsSmart.Name = 'HotLeads VCIP';
        hotLeadsSmart.MX_SB_VTS_Description__c = 'Bandeja para Tracking';
        hotLeadsSmart.MX_SB_VTS_ID_Bandeja__c = '1152';
        hotLeadsSmart.MX_SB_VTS_Producto__c = proHogar.Id;
        hotLeadsSmart.MX_SB_VTS_ProveedorCTI__c = smartProv.Id;
        hotLeadsSmart.MX_SB_VTS_Tipo_bandeja__c = 'HotLeads';
        insert hotLeadsSmart;

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenters_Crear_Carga', iaso__Url__c = URLEXA, iaso__Cache_Partition__c = URLLOCAL);
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'Authentication', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = URLLOCAL);
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'bbvaMexSmartCenter', iaso__Url__c = 'https://bbvacifrado.smartcenterservicios.com/ws_salesforce_desarrollo/api/login/authenticate', iaso__Cache_Partition__c = URLLOCAL);

        final ProcNotiOppNoAten__c objProNotOppNoAten = MX_WB_TestData_cls.createProcNotiOppNoAten(null, '30', 'Matutino', false);
        objProNotOppNoAten.Proceso__c = System.Label.MX_SB_VTS_SchdProces;
		insert objProNotOppNoAten;
        
        final Quote quo2 = MX_WB_TestData_cls.crearQuote(opp.Id, '993 1 OppTest Hogar', '1234');
        quo2.MX_SB_VTS_Familia_Productos__c = objFamilyPro2.Id;
        Insert quo2;
        
    }

    @isTest
    private static void sendOppsSmart() {
        Test.setMock(HttpCalloutMock.class, new MX_SB_VTS_Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new MX_SB_VTS_Integration_MockGenerator());
        String sQuery = 'Select Opportunity.Id, Opportunity.AccountId, Status, Opportunity.EnviarCTI__c, Opportunity.LastModifiedDate, MX_SB_VTS_Familia_Productos__c,';
        sQuery += ' MX_SB_VTS_Folio_Cotizacion__c, Opportunity.OwnerId,Opportunity.Producto__c, Opportunity.Account.PersonEmail, MX_SB_VTS_Movil_txt__c From Quote ';
        sQuery += ' Where Opportunity.LeadSource = \'Tracking Web\'';
        sQuery += ' And Opportunity.AccountId != null';
        sQuery += ' And MX_SB_VTS_Folio_Cotizacion__c != null';
        sQuery += ' And CreatedDate >= ' + System.label.MX_SB_VTS_SCHEDULE_DATE_LBL;
        sQuery += ' And Opportunity.Caso_Relacionado__c = null';
        sQuery += ' And Opportunity.MX_SB_VTS_OppCase__c = null';
        sQuery += ' And MX_SB_VTS_Familia_Productos__r.Name = \'' + System.label.MX_SB_VTS_HogarFam + '\'';
        MX_SB_VTS_SendTrackingTelemarketing_cls sh1 = new MX_SB_VTS_SendTrackingTelemarketing_cls(sQuery, 1);
        Database.BatchableContext batchContext; 
        final List<Quote> scopeQuotes = [Select Id,Opportunity.Account.PersonEmail,Opportunity.TelefonoCliente__c, MX_SB_VTS_Familia_Productos__c from Quote where MX_SB_VTS_Familia_Productos__c NOT IN('')];
        Test.startTest();
        sh1.execute(batchContext, scopeQuotes);
        System.assert(scopeQuotes.isEmpty() == false, 'Execute correcto');
        Test.stopTest(); 
    }
    
    @isTest 
    private static void sendOppsSmartBch() {
        final ProcNotiOppNoAten__c programSch = [Select Id, Activo__c from ProcNotiOppNoAten__c where Proceso__c =: System.Label.MX_SB_VTS_SchdProces];
        Test.startTest();
			programSch.Activo__c = true;
			update programSch;	
			System.assert(programSch.Activo__c, 'Se hizo el cambio correctamente');
		Test.stopTest();
    }
}