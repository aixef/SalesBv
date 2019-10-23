/**-------------------------------------------------------------------------
 * @File Name          : rtwCliente_tst.cls
 * @Description        : 
 * @Author             : Julio Medellin
 * @Group              : BBVA
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 28/5/2019 17:56:59
 * @Modification Log   : 
* Proyecto: MW SB VTS - BBVA 
* Descripción : Clase test para componente rtwCliente

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Descripción
* -------------------------------------------------------------------
* @version 1.0           02/05/2019      Julio Medellin            Encabezado
* @version 1.1           09/05/2019      Eduardo Hernández         BugFix para petición del servicio ASD Org Retail
* @version 1.2           19/06/2019      Vincent Juárez            Aumento de cobertura de código
* --------------------------------------------------------------------------*/
@isTest
private class rtwCliente_tst {
    /**variable nombre para pruebas*/
    public static final String NAMEPRUEBA = 'Prueba';
    /**variable apellido pruebas*/
    public static final String APELLIDOPRUEBA = 'test';
    /**variable correo pruebas*/
    public static final String CORREOPRUEBA = 'correo@prueba.com';
    /**variable correo blacklist pruebas*/
    public static final String CORREOPRUEBABLACK = 'm@m.com';
    /**variable telefono pruebas*/
    public static final String TELPRUEBA = '3332226655';
    /**variable sexo conductor pruebas*/
    public static final String SEXOCONDUC = 'Masculino';
    /**variable nacionalidad pruebas*/
    public static final String NACION = 'Mexicana';
    /**variable profesion pruebas*/
    public static final String PROFES = 'Ing. Conducción';
    /**variable colonia pruebas*/
    public static final String COL = 'ColoniaTest';
    /**variable calle pruebas*/
    public static final String CALLE = 'CalleTest';
    /**variable codigo postal pruebas*/
    public static final String CODPOS = '11001';
    /**variable numero interior o exterior pruebas*/
    public static final String NUMINEX = '1122334455';
    /**variable origen pruebas*/
    public static final String ORIGEN = 'OrigenTest';
    /**variable ciudad pruebas*/
    public static final String CIUDAD = 'CiudadTest';
    /**variable estado pruebas*/
    public static final String ESTADO = 'EstadoTest';
    /**variable pais pruebas*/
    public static final String PAIS = 'Mexico';
    /**variable descripcion pruebas*/
    public static final String DESCR = 'Descripcion';

    @isTest static void testMethodOne() {
        Test.startTest();
        final MX_SB_VTS_RtwCliente_Ext.reqCliente reqCliente = new MX_SB_VTS_RtwCliente_Ext.reqCliente();
        MX_SB_VTS_RtwCliente_Ext.resSFDC resSF = new MX_SB_VTS_RtwCliente_Ext.resSFDC();

        reqCliente.folioCliente = '';
        reqCliente.nombre = '';
        reqCliente.apellidoPaterno = '';
        reqCliente.apellidoMaterno = '';
        reqCliente.correoElectronico = '';
        reqCliente.fechaNacimiento = null;
        reqCliente.telefono = '';
        reqCliente.telefonoCelular = '';
        reqCliente.edad = '';
        reqCliente.sexoDelConductor = '';
        reqCliente.rfc = '';
        reqCliente.nacionalidad = '';
        reqCliente.profesion = '';
        reqCliente.colonia = '';
        reqCliente.calleOAvenida = '';
        reqCliente.codigoPostal = '';
        reqCliente.numeroExterior = '';
        reqCliente.numeroInterior = '';
        reqCliente.origen = '';
        reqCliente.ciudad = '';
        reqCliente.estado = '';
        reqCliente.pais = '';
        reqCliente.descripcion = '';
        reqCliente.motivoNoInteres = '';
        reqCliente.delegacion = '';
        reqCliente.motivoNoElegibilidad  = '';
        reqCliente.estatusCotizacion = '';
        reqCliente.folioDeCotizacion = '';
        reqCliente.valorRealIntermediarioCot = '';
        reqCliente.descripcionIntermediarioCot = '';
        reqCliente.TipoDeRegistro = '';
        final ProductoPlan productoPlan = new ProductoPlan();
        productoPlan.codigoProducto = '';
        productoPlan.codigoPlan = '';
        productoPlan.revisionPlan = '';
        productoPlan.codigoRamo = '';
        reqCliente.productoPlan = productoPlan;

        resSF = rtwCliente.upsertCliente( reqCliente );
        system.assertNotEquals(resSF,null);
        Test.stopTest();
    }

    @isTest static void testMethodTwo() {
        Test.startTest();
        final MX_SB_VTS_RtwCliente_Ext.reqCliente reqCliente = new MX_SB_VTS_RtwCliente_Ext.reqCliente();
        MX_SB_VTS_RtwCliente_Ext.resSFDC resSF = new MX_SB_VTS_RtwCliente_Ext.resSFDC();

        reqCliente.folioCliente = null;
        reqCliente.nombre = NAMEPRUEBA;
        reqCliente.apellidoPaterno = APELLIDOPRUEBA;
        reqCliente.apellidoMaterno = APELLIDOPRUEBA;
        reqCliente.correoElectronico = CORREOPRUEBA;
        reqCliente.fechaNacimiento = system.today().addYears(-35);
        reqCliente.telefono = TELPRUEBA;
        reqCliente.telefonoCelular = TELPRUEBA;
        reqCliente.edad = '35';
        reqCliente.sexoDelConductor = SEXOCONDUC;
        reqCliente.rfc = '';
        reqCliente.nacionalidad = NACION;
        reqCliente.profesion = PROFES;
        reqCliente.colonia = COL;
        reqCliente.calleOAvenida = CALLE;
        reqCliente.codigoPostal = CODPOS;
        reqCliente.numeroExterior = NUMINEX;
        reqCliente.numeroInterior = NUMINEX;
        reqCliente.origen = ORIGEN;
        reqCliente.ciudad = CIUDAD;
        reqCliente.estado = ESTADO;
        reqCliente.pais = PAIS;
        reqCliente.descripcion = DESCR;
        reqCliente.motivoNoInteres = '';
        reqCliente.delegacion = '';
        reqCliente.motivoNoElegibilidad  = '';
        rtwCliente.fnCrearCandidato(reqCliente);
        resSF = rtwCliente.upsertCliente( reqCliente );
        system.assertNotEquals(resSF,null);
        Test.stopTest();
    }

    @isTest static void testMethodThree() {
        Test.startTest();
        final Account oCliente = WB_CrearData_cls.getCliente('Cliente Prueba', 'Test');
        Insert oCliente;

        final MX_SB_VTS_RtwCliente_Ext.reqCliente reqCliente = new MX_SB_VTS_RtwCliente_Ext.reqCliente();
        MX_SB_VTS_RtwCliente_Ext.resSFDC resSF = new MX_SB_VTS_RtwCliente_Ext.resSFDC();

        reqCliente.folioCliente = oCliente.Id;
        reqCliente.nombre = NAMEPRUEBA;
        reqCliente.apellidoPaterno = APELLIDOPRUEBA;
        reqCliente.apellidoMaterno = APELLIDOPRUEBA;
        reqCliente.correoElectronico = CORREOPRUEBA;
        reqCliente.fechaNacimiento = system.today().addYears(-35);
        reqCliente.telefono = TELPRUEBA;
        reqCliente.telefonoCelular = TELPRUEBA;
        reqCliente.edad = '35';
        reqCliente.sexoDelConductor = SEXOCONDUC;
        reqCliente.rfc = '';
        reqCliente.nacionalidad = NACION;
        reqCliente.profesion = PROFES;
        reqCliente.colonia = COL;
        reqCliente.calleOAvenida = CALLE;
        reqCliente.codigoPostal = CODPOS;
        reqCliente.numeroExterior = NUMINEX;
        reqCliente.numeroInterior = NUMINEX;
        reqCliente.origen = ORIGEN;
        reqCliente.ciudad = CIUDAD;
        reqCliente.estado = ESTADO;
        reqCliente.pais = PAIS;
        reqCliente.descripcion = DESCR;
        reqCliente.motivoNoInteres = '';
        reqCliente.delegacion = '';
        reqCliente.motivoNoElegibilidad  = '';

        resSF = rtwCliente.upsertCliente( reqCliente );

        system.assertNotEquals(resSF,null);
        Test.stopTest();
    }

    @isTest static void testMethodFour() {
        Test.startTest();

        final Account oCliente = WB_CrearData_cls.getCliente('Cliente Prueba', 'Test');
        Insert oCliente;
        
        final MX_SB_VTS_RtwCliente_Ext.reqCliente reqCliente = new MX_SB_VTS_RtwCliente_Ext.reqCliente();
        MX_SB_VTS_RtwCliente_Ext.resSFDC resSF = new MX_SB_VTS_RtwCliente_Ext.resSFDC();

        reqCliente.folioCliente = oCliente.Id;
        reqCliente.nombre = NAMEPRUEBA;
        reqCliente.apellidoPaterno = APELLIDOPRUEBA;
        reqCliente.apellidoMaterno = APELLIDOPRUEBA;
        reqCliente.correoElectronico = CORREOPRUEBA;
        reqCliente.fechaNacimiento = system.today().addYears(-35);
        reqCliente.telefono = TELPRUEBA;
        reqCliente.telefonoCelular = TELPRUEBA;
        reqCliente.edad = '35';
        reqCliente.sexoDelConductor = SEXOCONDUC;
        reqCliente.rfc = '';
        reqCliente.nacionalidad = NACION;
        reqCliente.profesion = PROFES;
        reqCliente.colonia = COL;
        reqCliente.calleOAvenida = CALLE;
        reqCliente.codigoPostal = CODPOS;
        reqCliente.numeroExterior = NUMINEX;
        reqCliente.numeroInterior = NUMINEX;
        reqCliente.origen = ORIGEN;
        reqCliente.ciudad = CIUDAD;
        reqCliente.estado = ESTADO;
        reqCliente.pais = PAIS;
        reqCliente.descripcion = DESCR;
        reqCliente.motivoNoInteres = '';
        reqCliente.delegacion = '';
        reqCliente.motivoNoElegibilidad  = '';

        resSF = rtwCliente.upsertCliente( reqCliente );
        system.assertNotEquals(resSF,null);
        Test.stopTest();
    }

    @isTest static void testMethodFive() {
        Test.startTest();
        final MX_SB_VTS_RtwCliente_Ext.reqCliente reqCliente = new MX_SB_VTS_RtwCliente_Ext.reqCliente();
        MX_SB_VTS_RtwCliente_Ext.resSFDC resSF = new MX_SB_VTS_RtwCliente_Ext.resSFDC();

        reqCliente.folioCliente = '12';
        reqCliente.nombre = NAMEPRUEBA;
        reqCliente.apellidoPaterno = APELLIDOPRUEBA;
        reqCliente.apellidoMaterno = APELLIDOPRUEBA;
        reqCliente.correoElectronico = CORREOPRUEBA;
        reqCliente.fechaNacimiento = system.today().addYears(-35);
        reqCliente.telefono = TELPRUEBA;
        reqCliente.telefonoCelular = TELPRUEBA;
        reqCliente.edad = '35';
        reqCliente.sexoDelConductor = SEXOCONDUC;
        reqCliente.rfc = '';
        reqCliente.nacionalidad = NACION;
        reqCliente.profesion = PROFES;
        reqCliente.colonia = COL;
        reqCliente.calleOAvenida = CALLE;
        reqCliente.codigoPostal = CODPOS;
        reqCliente.numeroExterior = NUMINEX;
        reqCliente.numeroInterior = NUMINEX;
        reqCliente.origen = ORIGEN;
        reqCliente.ciudad = CIUDAD;
        reqCliente.estado = ESTADO;
        reqCliente.pais = PAIS;
        reqCliente.descripcion = DESCR;
        reqCliente.motivoNoInteres = '';
        reqCliente.delegacion = '';
        reqCliente.motivoNoElegibilidad  = '';
        reqCliente.gclid = '';
        resSF = rtwCliente.upsertCliente( reqCliente );

        final String sJosn = '{"folioCliente":"","nombre":"Heriberto","apellidoPaterno":"Pendiente","apellidoMaterno":"Flores","correoElectronico":"heri@pacheco.com","fechaNacimiento":"1990-11-11","telefono":"4433221155","telefonoCelular":"","edad":"26","sexoDelConductor":"FEMENINO","rfc":"FOSO901121","nacionalidad":"Mexico","profesion":"Consultor","colonia":"POLANCO","calleOAvenida":"Hola","codigoPostal":"11000","numeroExterior":"1","numeroInterior":"","origen":"Outbound","ciudad":"DISTRITO FEDERAL","estado": "DISTRITO FEDERAL","pais":"MEXICO","descripcion":"","delegacion":"MIGUEL HIDALGO","gclid":"","estatusCotizacion","folioDeCotizacion","valorRealIntermediarioCot","descripcionIntermediarioCot"}';
        rtwCliente.jsonParserreqCliente(sJosn);
        system.assertNotEquals(resSF,null);
        Test.stopTest();
    }

    @isTest static void testMethodSadPath() {
        Test.startTest();
        final MX_SB_VTS_RtwCliente_Ext.reqCliente reqCliente = new MX_SB_VTS_RtwCliente_Ext.reqCliente();
        MX_SB_VTS_RtwCliente_Ext.resSFDC resSF = new MX_SB_VTS_RtwCliente_Ext.resSFDC();

        reqCliente.folioCliente = '12';
        reqCliente.nombre = NAMEPRUEBA;
        reqCliente.apellidoPaterno = APELLIDOPRUEBA;
        reqCliente.apellidoMaterno = APELLIDOPRUEBA;
        reqCliente.correoElectronico = CORREOPRUEBABLACK;
        reqCliente.fechaNacimiento = system.today().addYears(-35);
        reqCliente.telefono = TELPRUEBA;
        reqCliente.telefonoCelular = TELPRUEBA;
        reqCliente.edad = '35';
        reqCliente.sexoDelConductor = SEXOCONDUC;
        reqCliente.rfc = '';
        reqCliente.nacionalidad = NACION;
        reqCliente.profesion = PROFES;
        reqCliente.colonia = COL;
        reqCliente.calleOAvenida = CALLE;
        reqCliente.codigoPostal = CODPOS;
        reqCliente.numeroExterior = NUMINEX;
        reqCliente.numeroInterior = NUMINEX;
        reqCliente.origen = ORIGEN;
        reqCliente.ciudad = CIUDAD;
        reqCliente.estado = ESTADO;
        reqCliente.pais = PAIS;
        reqCliente.descripcion = DESCR;
        reqCliente.motivoNoInteres = '';
        reqCliente.delegacion = '';
        reqCliente.motivoNoElegibilidad  = '';
        reqCliente.gclid = '';
        resSF = rtwCliente.upsertCliente( reqCliente );
        
        final MX_SB_VTS_RtwCliente_Ext.reqCliente reqClienteSad = new MX_SB_VTS_RtwCliente_Ext.reqCliente();

        resSF = rtwCliente.upsertCliente(reqClienteSad);

        final String sJosn = '{"folioCliente":"","nombre":"Heriberto","apellidoPaterno":"Pendiente","apellidoMaterno":"Flores","correoElectronico":"development@developmentadesis.com","fechaNacimiento":"1990-11-11","telefono":"4433221155","telefonoCelular":"","edad":"26","sexoDelConductor":"FEMENINO","rfc":"FOSO901121","nacionalidad":"Mexico","profesion":"Consultor","colonia":"POLANCO","calleOAvenida":"Hola","codigoPostal":"11000","numeroExterior":"1","numeroInterior":"","origen":"Outbound","ciudad":"DISTRITO FEDERAL","estado": "DISTRITO FEDERAL","pais":"MEXICO","descripcion":"","delegacion":"MIGUEL HIDALGO","gclid":"","estatusCotizacion","folioDeCotizacion","valorRealIntermediarioCot","descripcionIntermediarioCot"}';
        rtwCliente.jsonParserreqCliente(sJosn);
        system.assertNotEquals(resSF,null);
        Test.stopTest();
    }
}
