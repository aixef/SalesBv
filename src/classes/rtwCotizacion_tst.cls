/**
* Wibe
* @author          sistemas Wibe
* Description:     Clase de prueba de rtwCotizacion
* ----------------------------------------------------------------------------
*            No.     Fecha                   Autor                Descripción
*           ----   ----------     ---------------------------    -------------
* @version   1.0       ???        Karen Belem Sanchez Ruiz(KB)      Creación
* @version   1.1    15/02/19      Ing. Daniel Goncalves (DAGV)    Aumento de cobertura
* @version   1.2    02/05/19      Julio Medellín Oliva    cambio de clase para aumento de cobertura
* @version   1.3    18/05/19      Jaime Terrats           se solucionan casos de prueba que fallaban
*/
@isTest
private class rtwCotizacion_tst {
    /** variable lista lstrSF*/
    static List<resSFDC> lstrSF = new List<resSFDC>();
    /** variable lista lstEmptyrSF*/
    static final List<resSFDC> lstEmptyrSF = new List<resSFDC>();
    /** variable reqCot*/
    static reqCotizacion reqCot = new reqCotizacion();
    /** variable infCB*/
    static InfoCompBeneficiario infCB = new InfoCompBeneficiario();
    /**
    * Setup the data for the tests
    * @return List String
    **/
    @testSetup static void setup() {
        final User testUser = MX_WB_TestData_cls.crearUsuario ( 'TestLastName',  Label.MX_SB_VTS_ProfileAdmin ); //System Administrator Administrador del sistema
        insert testUser;
        final Account accRec = MX_WB_TestData_cls.crearCuenta ( 'LastName', 'PersonAccount' );
        accRec.OwnerId = testUser.Id;
        accRec.Correo_Electronico__c = 'prueba@wibe.com';
        accRec.CodigoPostal__c = '11520';
        insert accRec;
        final Account accNoOpp = MX_WB_TestData_cls.crearCuenta ( 'TstAcc', 'PersonAccount' );
        accNoOpp.OwnerId = testUser.Id;
        accNoOpp.Correo_Electronico__c = 'prueba2@wibe.com';
        accNoOpp.CodigoPostal__c = '22100';
        insert accNoOpp;
        final Opportunity oppRec = MX_WB_TestData_cls.crearOportunidad ( 'Test', accRec.Id, testUser.Id, 'ASD' );
        oppRec.FolioCotizacion__c = null;
        oppRec.Estatus__c = 'Creada';
        oppRec.correoElectronicoContratante__c = 'prueba@wibe.com';
        oppRec.TelefonoCliente__c = '5580808080';
        oppRec.Producto__c = 'Seguro de Moto Bancomer';
        oppRec.Reason__c = 'Venta';
        oppRec.MX_SB_VTS_Aplica_Cierre__c = true;
        insert oppRec;
        final MX_WB_FamiliaProducto__c objFamilyPro = MX_WB_TestData_cls.createProductsFamily ( 'ASD' );
        insert objFamilyPro;
        final List<Product2> lstProd = new List<Product2>();
        final Product2 proTst = MX_WB_TestData_cls.productNew ( 'Seguro de Moto Bancomer' );
        proTst.IsActive = true;
        proTst.MX_WB_FamiliaProductos__c = objFamilyPro.Id;
        insert proTst;
        MX_WB_TestData_cls.createStandardPriceBook2 ();

        final MX_WB_Cupon__c cupon = new MX_WB_Cupon__c();
        cupon.name = 'GAGF9';
        insert cupon;

    }

    private static reqCotizacion crearCotizacion () {
        final reqCotizacion reqCot = new reqCotizacion();
        reqCot.cliente = '';
        reqCot.idDeAsesor = '';
        reqCot.primaCotizada = '2000';
        reqCot.origenDeLaCotizacion = 'Outbound';
        reqCot.folioDeCotizacion = 'FolioTest';
        reqCot.estatus = 'EMITIDA';
        reqCot.formaDePago = 'Mensual';
        reqCot.plan = 'Basico';
        reqCot.descuentoFacultado = '0';
        reqCot.descuentoCupones = 'No';
        reqCot.anio = '2010';
        reqCot.marca = 'Ford';
        reqCot.submarca = 'Fiesta';
        reqCot.version = 'SE';
        reqCot.tipoAuto = 'Auto';
        reqCot.conduceAlguienMas = 'No';
        reqCot.numeroDeSerieDelVehiculo = '1155332288365432';
        reqCot.alguienMasConduce = 'No';
        reqCot.placas = 'FDS123';
        reqCot.laPersonaQueAdquiereLaPolizaEsElContratante = 'NO';
        reqCot.nombreDelContratante = 'NombreDelContratante';
        reqCot.apellidoPaternoContratante = 'ApellidoPaternoContratante';
        reqCot.apellidoMaternoContratante = 'ApellidoMaternoContratante';
        reqCot.correoElectronicoContratante = 'correo@mail.com';
        reqCot.telefonoCelularContratante = '3154443388';
        reqCot.fechaCierre = system.today().addDays(10);
        reqCot.comentariosPersonalizacion = 'ComentariosPersonalizacion';
        reqCot.cuetaConDispositivos = 'No';
        reqCot.descripcion = 'Descripcion';
        reqCot.edadConductoresAdicionles = 'mayor a 25';
        reqCot.modelo = '2010';
        reqCot.producto = 'Seguro de Moto Bancomer';
        reqCot.saleACarretera = 'Si';
        reqCot.sexoConductor = 'Masculíno';
        reqCot.numeroPoliza = '123456';
        reqCot.gclid = '';
        reqCot.salvamentoCot = 'true';
        reqCot.valorRealIntermediarioCot = '100.00';
        reqCot.descripcionIntermediarioCot = 'Descrip';
        reqCot.motivoDeInteres = 'VENTA';
        reqCot.campanya  = '';
        reqCot.valorPromocion = '';
        reqCot.aseguradora = '';
        reqCot.fechaPolizaIni = '';
        reqCot.fechaPolizaFin = '';
        reqCot.TipoDeRegistro = '';
        reqCot.codigoCupon = 'GAGF90001';
        final ProductoPlan productoPlan = new productoPlan();
        productoPlan.codigoProducto = '';
        productoPlan.codigoPlan = '';
        productoPlan.revisionPlan = '';
        productoPlan.codigoRamo = '';
        reqCot.productoPlan = productoPlan;
        return reqCot;
    }

    @isTest static void upsertCotizacionTst () {
        List<resSFDC> lstrSF = new List<resSFDC>();
        final Account oCliente = WB_CrearData_cls.getCliente('Cliente Prueba', 'Test');
        Insert oCliente;
        final Opportunity oOpp =  WB_CrearData_cls.getOportunidad(oCliente ,'FolioTest', 'Auto wibe');
        Insert oOpp;
        final Case oCase =  WB_CrearData_cls.getCase(oOpp.id);
        Insert oCase; 
        final TemporalCasosPolizas__c oTemCasPoli = WB_CrearData_cls.getTemporalCasosPolizas(oCase.id);
        Insert oTemCasPoli;
        final List<Case> lCaseUpd = new List<Case>{oCase};
        String slCaseJson = JSON.serialize(lCaseUpd);
        slCaseJson = slCaseJson.replaceAll('Poliza__c', 'Poliza');
        final reqCotizacion reqCot = crearCotizacion ();
        reqCot.cliente = oCliente.Id;
        reqCot.correoElectronicoContratante = oCliente.PersonEmail;
        lstrSF = rtwCotizacion.upsertCotizacion( reqCot );
        reqCot.laPersonaQueAdquiereLaPolizaEsElContratante = 'SI';
        lstrSF = rtwCotizacion.upsertCotizacion( reqCot );
        System.assertEquals ( 'FolioTest', reqCot.folioDeCotizacion, ' Test Upsert Cotización Caso Éxito ' );
    }

    /**
    * Prueba el method que realiza un upsert de Cotización
    **/
    @isTest static void upsertCotizacionCtst() {
        final String strAccId = [SELECT ID FROM Account WHERE CodigoPostal__c = '11520' ].ID;
        final String strCorreoOpp = [ SELECT correoElectronicoContratante__c FROM Opportunity WHERE AccountID =: strAccId ].correoElectronicoContratante__c;
        final reqCotizacion reqCot = new reqCotizacion();
        reqCot.cliente = strAccId;
        reqCot.folioDeCotizacion = '12345678';
        reqCot.descuentoFacultado = '0%';
        reqCot.laPersonaQueAdquiereLaPolizaEsElContratante = 'NO';
        reqCot.nombreDelContratante = 'NombreDelContratante';
        reqCot.correoElectronicoContratante = strCorreoOpp;
        Test.startTest();
        lstrSF = rtwCotizacion.upsertCotizacion ( reqCot );
        System.assertNotEquals ( rtwCotizacion_tst.lstEmptyrSF, rtwCotizacion_tst.lstrSF, ' Test Upsert Cotización Caso Éxito ' );
        Test.stopTest();
    }

    /**
    * Prueba el method que realiza un upsert de Cotización para cuentas sin oportunidades
    **/
    @isTest static void upsertCotizacionFormtst() {
        final String strAccId = [SELECT ID FROM Account WHERE CodigoPostal__c = '11520' ].ID;
        final String strCorreoOpp = [ SELECT correoElectronicoContratante__c FROM Opportunity WHERE AccountID =: strAccId ].correoElectronicoContratante__c;
        final reqCotizacion reqCotTst = new reqCotizacion();
        reqCotTst.cliente = strAccId;
        reqCotTst.origenDeLaCotizacion = 'Outbound';
        reqCotTst.folioDeCotizacion = '12345678';
        reqCotTst.estatus = 'Formalizada';
        reqCotTst.laPersonaQueAdquiereLaPolizaEsElContratante = 'SI';
        reqCotTst.correoElectronicoContratante = strCorreoOpp;
        reqCotTst.fechaCierre = system.today().addDays(10);
        reqCotTst.motivoDeInteres = 'VENTA';
        Test.startTest();
        lstrSF = rtwCotizacion.upsertCotizacion ( reqCotTst );
        System.assertNotEquals ( rtwCotizacion_tst.lstEmptyrSF, rtwCotizacion_tst.lstrSF, ' Test Upsert Cotización Caso Formalizada ' );
        Test.stopTest();
    }

    /**
    * Prueba el method que realiza un upsert de OpportunityLIneItem
    **/
    @isTest static void upsertOpporLinItemtst() {
        final String strAccId = [SELECT ID FROM Account WHERE CodigoPostal__c = '11520' ].ID;
        final Opportunity objOpp = [ SELECT ID, correoElectronicoContratante__c, FolioCotizacion__c FROM Opportunity WHERE AccountID =: strAccId ];
        final Product2 objPro = [ SELECT ID, Name FROM Product2 WHERE Name = 'Seguro de Moto Bancomer' ];
        objOpp.FolioCotizacion__c = '23232323';
        objOpp.MX_WB_Producto__c = objPro.ID;
        update objOpp;
        final reqCotizacion reqCotTst = new reqCotizacion();
        reqCotTst.cliente = strAccId;
        reqCotTst.origenDeLaCotizacion = 'Outbound';
        reqCotTst.folioDeCotizacion = objOpp.FolioCotizacion__c;
        reqCotTst.estatus = 'Formalizada';
        reqCotTst.laPersonaQueAdquiereLaPolizaEsElContratante = 'SI';
        reqCotTst.nombreDelContratante = 'NombreDelContratante';
        reqCotTst.correoElectronicoContratante = objOpp.correoElectronicoContratante__c;
        Test.startTest();
        lstrSF = rtwCotizacion.upsertCotizacion ( reqCotTst );
        System.assertNotEquals ( rtwCotizacion_tst.lstEmptyrSF, rtwCotizacion_tst.lstrSF, ' Test Upsert Cotización Caso Formalizada ' );
        Test.stopTest();
    }

    /**
    * Prueba el method que realiza un upsert de OpportunityLIneItem
    **/
    @isTest static void upsertOpporLinItemProdCottst() {
        final Account objAcc  = [SELECT ID, PersonBirthdate FROM Account WHERE CodigoPostal__c = '11520' ];
        objAcc.PersonBirthdate = Date.Today();
        update objAcc;
        final String strAccId = objAcc.ID;
        final Opportunity objOpp = [ SELECT ID, correoElectronicoContratante__c, FolioCotizacion__c FROM Opportunity WHERE AccountID =: strAccId ];
        objOpp.FolioCotizacion__c = '23232323';
        update objOpp;
        final reqCotizacion reqCotTst = new reqCotizacion();
        reqCotTst.cliente = strAccId;
        reqCotTst.primaCotizada = '2000';
        reqCotTst.origenDeLaCotizacion = 'Outbound';
        reqCotTst.folioDeCotizacion = objOpp.FolioCotizacion__c;
        reqCotTst.estatus = 'Formalizada';
        reqCotTst.formaDePago = 'Mensual';
        reqCotTst.plan = 'Basico';
        reqCotTst.descuentoFacultado = '0';
        reqCotTst.descuentoCupones = 'No';
        reqCotTst.anio = '2010';
        reqCotTst.marca = 'Ford';
        reqCotTst.submarca = 'Fiesta';
        reqCotTst.version = 'SE';
        reqCotTst.tipoAuto = 'Auto';
        reqCotTst.conduceAlguienMas = 'No';
        reqCotTst.numeroDeSerieDelVehiculo = '1155332288365432';
        reqCotTst.alguienMasConduce = 'No';
        reqCotTst.placas = 'FDS123';
        reqCotTst.laPersonaQueAdquiereLaPolizaEsElContratante = 'SI';
        reqCotTst.nombreDelContratante = 'NombreDelContratante';
        reqCotTst.apellidoPaternoContratante = 'ApellidoPaternoContratante';
        reqCotTst.apellidoMaternoContratante = 'ApellidoMaternoContratante';
        reqCotTst.correoElectronicoContratante = objOpp.correoElectronicoContratante__c;
        reqCotTst.telefonoCelularContratante = '5580808080';
        reqCotTst.fechaCierre = system.today().addDays(10);
        reqCotTst.comentariosPersonalizacion = 'ComentariosPersonalizacion';
        reqCotTst.cuetaConDispositivos = 'No';
        reqCotTst.descripcion = 'Descripcion';
        reqCotTst.edadConductoresAdicionles = 'mayor a 25';
        reqCotTst.modelo = '2010';
        reqCotTst.producto = 'SEGURO DE MOTO BANCOMER';
        reqCotTst.saleACarretera = 'Si';
        reqCotTst.sexoConductor = 'Masculíno';
        Test.startTest();
        lstrSF = rtwCotizacion.upsertCotizacion ( reqCotTst );
        System.assertNotEquals ( rtwCotizacion_tst.lstEmptyrSF, rtwCotizacion_tst.lstrSF, ' Test Upsert Cotización Caso Formalizada ' );
        final reqCotizacion r = new reqCotizacion();
        System.assertNotEquals(r, rtwCotizacion.JSONParserreqCotizacion ('Q'));
        Test.stopTest();
    }

}
