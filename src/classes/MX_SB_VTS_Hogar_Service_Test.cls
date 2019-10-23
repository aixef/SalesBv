/**-------------------------------------------------------------------------
* Nombre: MX_SB_VTS_Hogar_Service_Test
* @author Jaime (JT)
* Proyecto: MX_Ventas - BBVA Bancomer
* Descripción : Clase test que sirve para la cobertura de la clase MX_SB_VTS_Hogar_Service_cls
*
* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* --------------------------------------------------------------------------
* @version 1.0           30/04/2019      Jaime T                   Creación
* @version 1.1           09/05/2019      Jaime T                   Refactor
* @version 1.2           17/10/2019      Jaime T                 Se agrega actualiza clase de prueba
* --------------------------------------------------------------------------*/
@isTest
private class MX_SB_VTS_Hogar_Service_Test {
    /*
    * Variable empleada para Folio de Cotizacion
    */
    static final String FOLIO_COT = '99999';
    /*
    * Variable Empleada para el Email
    */
    static final String PERSON_EMAIL = 'john.doe@test.hogar.com';

    @TestSetup
    static void makeData() {
        final User admin = MX_WB_TestData_cls.crearUsuario('test hogar', system.label.MX_SB_VTS_ProfileAdmin);
        Insert admin;

        System.runAs(admin) {
            MX_WB_TestData_cls.createStandardPriceBook2();

            final Product2 producto = MX_WB_TestData_cls.productNew('Hogar');
            producto.isActive = true;
            Insert producto;

            final PricebookEntry pbe = MX_WB_TestData_cls.priceBookEntryNew(producto.Id);
            Insert pbe;

            final Account acc = MX_WB_TestData_cls.crearCuenta('Doe', 'PersonAccount');
            acc.PersonEmail = PERSON_EMAIL;
            acc.FirstName = 'John';
            Insert acc;

            final Opportunity opp = MX_WB_TestData_cls.crearOportunidad('OppTest Hogar', acc.Id, admin.Id, 'ASD');
            opp.Reason__c = 'Venta';
            opp.Producto__c = 'Hogar';
            opp.MX_SB_VTS_Aplica_Cierre__c = true;
            Insert opp;

            final OpportunityLineItem oli = MX_WB_TestData_cls.oppLineItmNew(opp.Id, pbe.Id, producto.Id, 1, 1);
            Insert oli;

            final Quote quo = MX_WB_TestData_cls.crearQuote(opp.Id, '99999 1 OppTest Hogar', FOLIO_COT);
            Insert quo;
        }
    }


    static MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion prepareJSON(String[] data) {
        final MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion = new MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion();
        final MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosIniciales datosIniciales = new MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosIniciales();
        final MX_SB_VTS_HogarWrapper.MX_SB_VTS_TipoDeSeguro tipoDeSeguro = new MX_SB_VTS_HogarWrapper.MX_SB_VTS_TipoDeSeguro();
        final MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosAdicionales datosAdicionales = new MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosAdicionales();
        final MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCliente datosCliente = new MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCliente();


        datosIniciales.codigoPostal = '43800';
        datosIniciales.folioCotizacion = data[0];
        datosIniciales.valorHogar = '10000';
        datosIniciales.statusCotizacion = data[1];
        datosIniciales.origen = data[2];
        datosIniciales.producto = 'Hogar';
        datosIniciales.numeroPoliza = data[7];
        datosIniciales.folioTracking = '';

        datosCotizacion.datosIniciales = datosIniciales;

        tipoDeSeguro.conOSinSismo = 'con';
        tipoDeSeguro.danosInmueble = '';
        tipoDeSeguro.danosAContenidos = '';
        tipoDeSeguro.porRobo = '';
        tipoDeSeguro.roturaDeCristales = '';
        tipoDeSeguro.responsabilidadPrivadaFamiliar = '';
        tipoDeSeguro.danosEquipoElectrico = '';
        tipoDeSeguro.precioAnual = '';
        tipoDeSeguro.frequenciaPago = data[6];
        tipoDeSeguro.cantidadDePagos = data[5];

        datosCotizacion.tipoDeSeguro = tipoDeSeguro;

        datosCotizacion.datosPrecio = constructordatosPrecio();

        datosAdicionales.cercaniaMantosAquiferos = false;
        datosAdicionales.murosTabiqueLadrilloBlock = true;
        datosAdicionales.techoTabiqueLadrilloBlock = true;
        datosAdicionales.casaODepartamento = 'casa';
        datosAdicionales.noPisosInmueble = '2';
        datosAdicionales.pisoHabitado = '';

        datosCotizacion.datosAdicionales = datosAdicionales;

        datosCliente.nombre = 'John';
        datosCliente.apPaterno = data[4];
        datosCliente.apMaterno = 'C.';
        datosCliente.email = data[3];
        datosCliente.fechaNacimiento = '09/03/1991';
        datosCliente.telefonoCasa = '571095432';
        datosCliente.celular = '5571095432';
        datosCliente.sexo = 'm';
        datosCliente.rfc = 'bafl890410';

        datosCotizacion.datosCliente = datosCliente;
        datosCotizacion.datosDomicilio = constructorDatosDomicilio();
        datosCotizacion.datosDomAsegurado = constructorDatosDomicilio();

        return datosCotizacion;
    }
    private static MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosDomicilio constructorDatosDomicilio() {
        final MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosDomicilio datosDomicilio = new MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosDomicilio();
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
        return datosDomicilio;
    }
    private static MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosPrecio constructordatosPrecio() {
        final MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosPrecio datosPrecio = new MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosPrecio();
        datosPrecio.precioParcialidades = '612.09';
        datosPrecio.precioTotal = '10000';
        datosPrecio.msiBancomer = '';
        datosPrecio.cupon = 'No';
        return datosPrecio;
    }

    @isTest
    static void wrongJSONData	() {
        Test.startTest();
        final String jsonBody = '{"datosCotizacion":{"DatosIniciales":{"codigoPostal": "22000",'+
                                '"folioCotizacion": "99999","valorHogar": "2000000","statusCotizacion": "Creada",'+
                                '"origen": "outbound","producto": "Hogar","numeroPoliza": ""},';

        MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion response = MX_SB_VTS_Hogar_Service.datosCotizacion(jsonBody);
        System.assertNotEquals(response, null, 'deberia fallar');
        Test.stopTest();
    }

    @isTest
    static void validJSON() {
        Test.startTest();
        String jsonBody = '{"datosCotizacion":{"DatosIniciales":{"codigoPostal": "22000",'+
                          '"folioCotizacion": "99999","valorHogar": "2000000","statusCotizacion": "Creada",'+
                           '"origen": "outbound","producto": "Hogar","numeroPoliza": "", "folioTracking": ""},';
        jsonBody += '"TipoDeSeguro":{"conOSinSismo":"con","danosInmueble":"","danosAContenidos":"","porRobo":"",'+
                    '"roturaDeCristales":"","responsabilidadPrivadaFamiliar":"","danosEquipoElectrico":"","precioAnual":"",'+
                    '"frequenciaPago":"","cantidadDePagos":""},';
        jsonBody += '"DatosPrecio":{"precioParcialidades":"612.09","precioTotal":"13432.30","msiBancomer":"",'+
                    '"cupon": "false"},';
        jsonBody += '"DatosAdicionales":{"cercaniaMantosAquiferos":"false","murosTabiqueLadrilloBlock":"true",'+
                    '"techoTabiqueLadrilloBlock":"true","casaODepartamento":"casa","noPisosInmueble":"2",'+
                    '"pisoHabitado":""},';
        jsonBody += '"DatosCliente":{"nombre": "John","apPaterno":"Doe","apMaterno":"C.","email":"john.doe@test.com",'+
                    '"fechaNacimiento":"09/03/1991","telefonoCasa":"5571095432","celular":"5571095432","sexo":"m",'+
                    '"rfc":"bafl890410"},';
        jsonBody += '"DatosDomicilio":{"calleCliente":"pensamiento","cpCliente":"43800","coloniaCliente":"NuevoTizayuca",'+
                    '"codColoniaCliente":"","ciudadCliente":"Tizayuca","codCiudad":"","numExtCliente":"67","numIntCliente":"",'+
                    '"estadoCliente":"Hidalgo","codEstadoCliente":"","paisCliente":"","codPaisCliente":""},';
        jsonBody += '"DatosDomAsegurado": {"calleCliente":"pensamiento","cpCliente":"43800","coloniaCliente":"NuevoTizayuca",'+
                    '"codColoniaCliente":"","ciudadCliente":"Tizayuca","codCiudad":"","numExtCliente":"67","numIntCliente":"","estadoCliente":"Hidalgo","codEstadoCliente":"","paisCliente":"","codPaisCliente":""}}}';

        MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion response = MX_SB_VTS_Hogar_Service.datosCotizacion(jsonBody);
        Test.stopTest();
        System.assertNotEquals(response, null, 'No account Id found');
    }

    @isTest
    static void findQuote() {
        List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC> resSF = new List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC>();
        final String[] mockData = new String[]{FOLIO_COT, 'Creada', 'inbound', PERSON_EMAIL, 'Doe', '', 'Semestral', ''};
        final MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion = prepareJSON(mockData);
        Test.startTest();
        	resSF = MX_SB_VTS_Hogar_Service.cotizarSeguroHogar(datosCotizacion);
        	System.assertNotEquals(resSF, null, 'Invalid response from service');
        Test.stopTest();
    }

    @isTest
    static void createNewQuote() {
        Test.startTest();
        List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC> resSF = new List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC>();
        final String[] mockData = new String[]{'99991', 'Cotizada', 'outbound', 'john.doe@test.hogar.com', 'D', '4', '', ''};
        final MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion = prepareJSON(mockData);
        resSF = MX_SB_VTS_Hogar_Service.cotizarSeguroHogar(datosCotizacion);
        System.assertNotEquals(resSF, null, 'Success new quote created');
        Test.stopTest();
    }
    @isTest
    static void findQuoteAccountfalse() {
        Test.startTest();
        List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC> resSF = new List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC>();
        final String[] mockData = new String[]{'1999', 'Cobrada', 'inbound', 'j.d@test.hogar.com', 'Do', '', 'Trimestral', ''};
        final MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion = prepareJSON(mockData);
        resSF = MX_SB_VTS_Hogar_Service.cotizarSeguroHogar(datosCotizacion);
        System.assertNotEquals(resSF, null, 'Created new Account');
        Test.stopTest();
    }

    @isTest
    static void updateExistingQuote() {
        Test.startTest();
        List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC> resSF = new List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC>();
        final String[] mockData = new String[]{FOLIO_COT, 'Cotizada', 'inbound', PERSON_EMAIL, 'De', '12', '', ''};
        final MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion = prepareJSON(mockData);
        resSF = MX_SB_VTS_Hogar_Service.cotizarSeguroHogar(datosCotizacion);
        System.assertNotEquals(resSF, null, 'Update Quote Status');
        Test.stopTest();
    }

    @isTest
    static void updateExistingQuote2() {
        Test.startTest();
        List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC> resSF = new List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC>();
        final String[] mockData = new String[]{FOLIO_COT, 'Tarificada', 'inbound', PERSON_EMAIL, 'LN', '', 'Anual', ''};
        final MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion = prepareJSON(mockData);
        resSF = MX_SB_VTS_Hogar_Service.cotizarSeguroHogar(datosCotizacion);
        System.assertNotEquals(resSF, null, 'Updated Quote Status');
        Test.stopTest();
    }

    @isTest
    static void updateExistingQuote3() {
        Test.startTest();
        List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC> resSF = new List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC>();
        final String[] mockData = new String[]{FOLIO_COT, 'Cobrada', 'inbound', PERSON_EMAIL, 'L', '1', '', ''};
        final MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion = prepareJSON(mockData);
        resSF = MX_SB_VTS_Hogar_Service.cotizarSeguroHogar(datosCotizacion);
        System.assertNotEquals(resSF, null, 'Updated Quote Status');
        Test.stopTest();
    }

   @isTest
    static void updateExistingQuote4() {
        Test.startTest();
        List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC> resSF = new List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC>();
        final String[] mockData = new String[]{FOLIO_COT, 'Emitida', 'inbound', PERSON_EMAIL, 'L', '2', '', '123456789'};
        final MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion = prepareJSON(mockData);
        resSF = MX_SB_VTS_Hogar_Service.cotizarSeguroHogar(datosCotizacion);
        System.assertNotEquals(resSF, null, 'Updated Quote Status');
        Test.stopTest();
    }
}
