/**-------------------------------------------------------------------------
* Nombre: MX_SB_VTS_Vida_Service_Test
* @author Jaime (JT)
* Proyecto: MX_Ventas - BBVA Bancomer
* Descripción : Clase test que sirve para la cobertura de la clase MX_SB_VTS_Vida_Service
*
* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* --------------------------------------------------------------------------
* @version 1.0           30/04/2019      Jaime T                   Creación
* @version 1.0           28/08/2019      Arsenio                   Code smell
* --------------------------------------------------------------------------*/
@isTest
private class MX_SB_VTS_Vida_Service_Test {// NOSONAR

    /*
    * Variable Empleada para el Email
    */
    static final String PERSON_EMAIL = 'john.doe@test.vida.com';
    /*
    * Variable empleada para Folio de Cotizacion
    */
    static final String FOLIO_COT = '9999';

    @TestSetup
    static void makeData() {
        final User admin = MX_WB_TestData_cls.crearUsuario('test hogar', system.label.MX_SB_VTS_ProfileAdmin);
        Insert admin;
        System.runAs(admin) {
            MX_WB_TestData_cls.createStandardPriceBook2();
            final Product2 producto = MX_WB_TestData_cls.productNew('Vida');
            producto.isActive = true;
            Insert producto;
            final Account acc = MX_WB_TestData_cls.crearCuenta('Doe', 'PersonAccount');
            acc.PersonEmail = PERSON_EMAIL;
            acc.FirstName = 'John';
            Insert acc;

            final PricebookEntry pbe = MX_WB_TestData_cls.priceBookEntryNew(producto.Id);
            Insert pbe;

            final Opportunity opp = MX_WB_TestData_cls.crearOportunidad('OppTest Vida', acc.Id, admin.Id, System.label.MX_SB_VTS_Telemarketing_LBL);
            opp.Producto__c = 'Vida';
            opp.Reason__c = 'Venta';
            opp.MX_SB_VTS_Aplica_Cierre__c = true;
            Insert opp;
			final Quote quo = MX_WB_TestData_cls.crearQuote(opp.Id, '99999 1 OppTest Hogar', FOLIO_COT);
            Insert quo;
            final OpportunityLineItem oli = MX_WB_TestData_cls.oppLineItmNew(opp.Id, pbe.Id, producto.Id, 1, 1);
            Insert oli;

        }
    }

    static MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosCotizacion prepareJSON(String[] data) {
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosCotizacion datosCotizacion = new MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosCotizacion();
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosIniciales datosIniciales = new MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosIniciales();
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_TipoSeguroVida tipoDeSeguroVida = new MX_SB_VTS_WrapperVida.MX_SB_VTS_TipoSeguroVida();
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_CoberturaInicial datosAdicionales = new MX_SB_VTS_WrapperVida.MX_SB_VTS_CoberturaInicial();
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosCliente datosCliente = new MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosCliente();
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_Beneficiarios beneficiario = new MX_SB_VTS_WrapperVida.MX_SB_VTS_Beneficiarios();
        final List<MX_SB_VTS_WrapperVida.MX_SB_VTS_Beneficiarios> lstBeneficiarios = new List<MX_SB_VTS_WrapperVida.MX_SB_VTS_Beneficiarios>();
        datosIniciales.folioCotizacion = data[0];
        datosIniciales.statusCotizacion = data[1];
        datosIniciales.origen = data[2];
        datosIniciales.producto = 'Vida';
        datosIniciales.numeroPoliza = '';
        datosIniciales.numeroPoliza = '';
        datosIniciales.folioTracking = '';
        datosCotizacion.datosIniciales = datosIniciales;
        tipoDeSeguroVida.tipoPlan = '';
        tipoDeSeguroVida.precioAnual = '';
        tipoDeSeguroVida.totalFallecimiento = '2000000';
        tipoDeSeguroVida.totalGastosFunerarios = '20000000';
        tipoDeSeguroVida.totalMuerteAccidental = '100000';
        tipoDeSeguroVida.frequenciaPago = data[6];
        tipoDeSeguroVida.cantidadDePagos = data[5];
        datosCotizacion.tipoDeSeguroVida = tipoDeSeguroVida;
        datosCotizacion.datosPrecio = constructordatosPrecio();
        datosAdicionales.cancerTumoresLeucemiaLupus = 'false';
        datosAdicionales.aneurismaTrombosisEmbolia = 'false';
        datosAdicionales.emficemaBronquitisTuberculosis = 'false';
        datosAdicionales.insuficienciasCirrosisHepatitis = 'false';
        datosCotizacion.datosAdicionalesVida = datosAdicionales;
        datosCliente.nombre = 'John';
        datosCliente.apPaterno = data[4];
        datosCliente.apMaterno = 'C.';
        datosCliente.email = data[3];
        datosCliente.fechaNacimiento = '09/03/1991';
        datosCliente.telefonoCasa = '571095432';
        datosCliente.celular = '5571095432';
        datosCliente.sexo = 'm';
        datosCliente.rfc = 'bafl890410';
        beneficiario.nombre = 'Clark';
        beneficiario.apellidoPaterno = 'Kent';
        beneficiario.apellidoMaterno = 'Cage';
        beneficiario.parentesco = 'OTRO';
        beneficiario.procentaje = '50';
        lstBeneficiarios.add(beneficiario);
        datosCotizacion.beneficiarios = lstBeneficiarios;
        datosCotizacion.datosCliente = datosCliente;
        datosCotizacion.datosDomicilio = constructorDatosDomicilio();
        return datosCotizacion;
    }

    private static MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosDomicilio constructorDatosDomicilio() {
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosDomicilio datosDomicilio = new MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosDomicilio();
        datosDomicilio.calleCliente = 'pensamiento';
        datosDomicilio.cpCliente = '43800';
        datosDomicilio.coloniaCliente = 'NuevoTizayuca';
        datosDomicilio.codColoniaCliente = '';
        datosDomicilio.ciudadCliente = '';
        datosDomicilio.codCiudad = '';
        datosDomicilio.numExtCliente = '67';
        datosDomicilio.numIntCliente = '';
        datosDomicilio.estadoCliente = 'Hidalgo';
        datosDomicilio.codEstadoCliente = '';
        datosDomicilio.paisCliente = '';
        datosDomicilio.codPaisCliente = '';
        datosDomicilio.codigoPostal = '43800';
        return datosDomicilio;
    }
    private static MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosPrecio constructordatosPrecio() {
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosPrecio datosPrecio = new MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosPrecio();
        datosPrecio.precioParcialidades = '612.09';
        datosPrecio.precioTotal = '10000';
        datosPrecio.msiBancomer = '';
        datosPrecio.cupon = 'No';
        return datosPrecio;
    }

    @isTest
    static void findQuote() {
        List<MX_SB_VTS_WrapperVida.MX_SB_VTS_ResponseSFDC> resSF = new List<MX_SB_VTS_WrapperVida.MX_SB_VTS_ResponseSFDC>();
        final String[] mockData = new String[]{FOLIO_COT, 'Creada', 'inbound', PERSON_EMAIL, 'Doe', '', 'Semestral'};
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosCotizacion datosCotizacion = prepareJSON(mockData);
        Test.startTest();
        	resSF = MX_SB_VTS_Vida_Service.cotizarSeguroVida(datosCotizacion);
        	System.assertNotEquals(resSF, null, 'Invalid response from service');
        Test.stopTest();
    }

    @isTest
    static void createNewQuote() {
        Test.startTest();
        List<MX_SB_VTS_WrapperVida.MX_SB_VTS_ResponseSFDC> resSF = new List<MX_SB_VTS_WrapperVida.MX_SB_VTS_ResponseSFDC>();
        final String[] mockData = new String[]{'99991', 'Cotizada', 'outbound', 'john.doe@test.vida.com', 'D', '4', ''};
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosCotizacion datosCotizacion = prepareJSON(mockData);
        resSF = MX_SB_VTS_Vida_Service.cotizarSeguroVida(datosCotizacion);
        System.assertNotEquals(resSF, null, 'Success new quote created');
        Test.stopTest();
    }

    @isTest
    static void findQuoteAccountfalse() {
        Test.startTest();
        List<MX_SB_VTS_WrapperVida.MX_SB_VTS_ResponseSFDC> resSF = new List<MX_SB_VTS_WrapperVida.MX_SB_VTS_ResponseSFDC>();
        final String[] mockData = new String[] {'1999', 'Cobrada', 'inbound', 'j.d@test.hogar.com', 'Do', '', 'Trimestral'};
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosCotizacion datosCotizacion = prepareJSON(mockData);
        resSF = MX_SB_VTS_Vida_Service.cotizarSeguroVida(datosCotizacion);
        System.assertNotEquals(resSF, null, 'Created new Account');
        Test.stopTest();
    }

    @isTest
    static void updateExistingQuote() {
        Test.startTest();
        List<MX_SB_VTS_WrapperVida.MX_SB_VTS_ResponseSFDC> resSF = new List<MX_SB_VTS_WrapperVida.MX_SB_VTS_ResponseSFDC>();
        final String[] mockData = new String[] {FOLIO_COT, 'Cotizada', 'inbound', PERSON_EMAIL, 'De', '12', ''};
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosCotizacion datosCotizacion = prepareJSON(mockData);
        resSF = MX_SB_VTS_Vida_Service.cotizarSeguroVida(datosCotizacion);
        System.assertNotEquals(resSF, null, 'Update Quote Status');
        Test.stopTest();
    }

    @isTest
    static void updateExistingQuote2() {
        Test.startTest();
        List<MX_SB_VTS_WrapperVida.MX_SB_VTS_ResponseSFDC> resSF = new List<MX_SB_VTS_WrapperVida.MX_SB_VTS_ResponseSFDC>();
        final String[] mockData = new String[] {FOLIO_COT, 'Tarificada', 'inbound', PERSON_EMAIL, 'LN', '', 'Anual'};
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosCotizacion datosCotizacion = prepareJSON(mockData);
        resSF = MX_SB_VTS_Vida_Service.cotizarSeguroVida(datosCotizacion);
        System.assertNotEquals(resSF, null, 'Updated Quote Status');
        Test.stopTest();
    }

    @isTest
    static void updateExistingQuote3() {
        Test.startTest();
        List<MX_SB_VTS_WrapperVida.MX_SB_VTS_ResponseSFDC> resSF = new List<MX_SB_VTS_WrapperVida.MX_SB_VTS_ResponseSFDC>();
        final String[] mockData = new String[] {FOLIO_COT, 'Cobrada', 'inbound', PERSON_EMAIL, 'L', '1', ''};
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosCotizacion datosCotizacion = prepareJSON(mockData);
        resSF = MX_SB_VTS_Vida_Service.cotizarSeguroVida(datosCotizacion);
        System.assertNotEquals(resSF, null, 'Updated Quote Status');
        Test.stopTest();
    }

   @isTest
    static void updateExistingQuote4() {
        Test.startTest();
        List<MX_SB_VTS_WrapperVida.MX_SB_VTS_ResponseSFDC> resSF = new List<MX_SB_VTS_WrapperVida.MX_SB_VTS_ResponseSFDC>();
        final String[] mockData = new String[] {FOLIO_COT, 'Emitida', 'inbound', PERSON_EMAIL, 'L', '2', ''};
        final MX_SB_VTS_WrapperVida.MX_SB_VTS_DatosCotizacion datosCotizacion = prepareJSON(mockData);
        resSF = MX_SB_VTS_Vida_Service.cotizarSeguroVida(datosCotizacion);
        System.assertNotEquals(resSF, null, 'Updated Quote Status');
        Test.stopTest();
    }
}