/**
* ------------------------------------------------------------------------------------------------
* @Name     MX_BPP_AccAndOppDataFactory
* @Author   Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* @Date     Created: 2019-07-02
* @Group    Digital Workplace Retail
* @Description Create the data for the test classes for RI(BPyP) functionality.
* @Comments Created from the clipped code from the UtilitysDataTest_tst and EU_cls_TestData classes.
            Se dejan los comentarios de las clases origen relacionados a métodos contenidos en esta clase.
* @Changes
**/

/*----------------------------------Desarrollado por INDRA--------------------------------
UtilitysDataTest_tst
*Autor:         Trabajo en Equipo
*Proyecto:      MAX - BBVA Bancomer
*Descripción:   Clase para crear los Datos de prueba generales de utilería para ser usados
                en las demas clases de prueba
*_______________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        22/MAR/2018     Sergio Ortiz                        Creación.
                                                                Se corrigen Parametros de entrada en algunos metodos.
*2.2        19-09-2018      Francisco J Licona                  Se agregan métodos que devuelven los objetos
                                                                ExpUni_Tablero_Grupal__c y EU_001_Compromiso__c.
*2.3       28/09/2018      Angel Fuertes Gomez                  Cambio del contacto decisor de BPyP
*2.4        24/SEP/2018     Cristian Espinosa                   Se elimina dependencia a campo Producto_BEyG__c del objeto Opportunity
*2.10       26/JUN/2019     Cindy Hernández		                Se modifica el método createData para que los campos lookup de los
                                                                registros se llenen correctamente.
-----------------------------------------------------------------------------------------*/

/**
EU_cls_TestData
*Desarrollado por:       Indra
*Autor:                  Abraham Alfonso Tinajero Sánchez
*Proyecto:               Experiencia Única
*Descripción:            ClaseTest para generar información de prueba
*
*Cambios (Versiones)
*-------------------------------------------------------------------------------
*No.         Fecha           Autor                          Descripción
*------   ----------------   --------------------          ---------------
*1.0      07-08-2017         Abraham Tnajero                Creación
*2.0      15-03-2018         Abraham Tnajero                Se optimizan métodos
*3.0      17-04-2018         Abraham Tnajero                Se agregan campos a creación de opp para cobertura
*4.0      14-05-2018         Abraham Tnajero                Se agrega un random a la creación de account
*5.0	  20-06-2018		 Javier Ortiz Flores 			Se agrega compromiso con fecha anterior al día de hoy
**/
/**
*Cambios (Versiones)
*-------------------------------------------------------------------------------
*No.         Fecha           Autor                          Descripción
*------   ----------------   --------------------          ---------------
*1.1      02-07-2019         Cindy Hernández               Se reducen las oportunidades creadas en el método createOppFin.
														   Se crean los métodos insertCompromisosDO y getRecordsOtherOppTypes.
**/
@isTest
public class MX_BPP_AccAndOppDataFactory {
    /**Mapa perfilMapa */
    static Map<String, Profile> perfilMapa = new Map<String, Profile>();
    /**Mapa rolMapa */
    static Map<String, UserRole> rolMapa   = new Map<String, UserRole>();
    /**Lista lstProfile */
    static List<Profile> lstProfile;
    /** Lista userRole*/
    static List<UserRole> userRole;
    /** Colocación */
	static final String STGCOLOCACION = 'Colocación';
	/** Collares */
	static final String STGCOLLARES = 'Collares';
	/** MX_BPP_RedBpyp */
	static final String STGRTOPP = 'MX_BPP_RedBpyp';
    /** VP_tre_Financiamiento_PyME */
    static final String STGRTOPPPYME = 'VP_tre_Financiamiento_PyME';

    static {
        lstProfile = new List<Profile>([SELECT Id, Name FROM Profile WHERE NOT(Name = null)]);
        userRole   = new List<UserRole>([SELECT Id, Name FROM UserRole WHERE NOT(Name = null)]);
        for(Profile perfil:lstProfile) { perfilMapa.put(perfil.Name, perfil); }
        for(UserRole ur:userRole) { rolMapa.put(ur.Name, ur); }
    }

   /**
    * @Method:      crearCuenta
    * @param:       String strName, String devNameTipoRegistro
    * @Description: Método que retorna un objeto cliente
    */
	public static Account crearCuenta(String strName, String devNameTipoRegistro) {
		final Account cliente          = new Account();
		cliente.Name             = strName;
		cliente.No_de_cliente__c = String.valueOf((Math.random()*10000000).round());
		cliente.RecordTypeId     = RecordTypeMemory_cls.getRecType('Account', devNameTipoRegistro);
		return cliente;
    }
    /** Creacion de Metodo*/
    public static void createData() {
        final User u = MX_BPP_UserAndRIDataFactory.crearUsuario('CLIENTES MASA', Label.MX_PERFIL_SystemAdministrator,'BBVA ADMINISTRADOR');
       	u.VP_ls_Banca__c = 'Red BPyP';
		u.Divisi_n__c = 'BAJIO';
		u.BPyP_ls_NombreSucursal__c = '6388 PACHUCA';
        insert u;
		final RecordType rec = [Select Id from RecordType where DeveloperName='BPyP_tre_Cliente'];
        final RecordType oppRec = [Select Id from RecordType where DeveloperName='MX_BPP_RedBpyp'];
		final Account a = new Account();
        System.runAs(u) {
            UtilitysDataTest_tst.crearProdForm(STGCOLOCACION, STGCOLLARES);
        	a.Name = 'a';
            a.RecordTypeId = rec.Id;
            a.OwnerId = u.Id;
            Insert a;
            final Opportunity o = new Opportunity();
            o.StageName = 'Abierta';
            o.Name = 'Test r.almanza';
            o.AccountId = a.Id;
            o.OwnerId = u.Id;
            o.CloseDate = System.Today();
            o.RecordTypeId = oppRec.Id;
            o.MX_RTL_Familia__c = STGCOLOCACION;
        	o.MX_RTL_Producto__c = STGCOLLARES;
            o.op_amountPivote_dv__c = 100;
            Insert o;
        }
	}

   /**
    * @Method:      crearOportunidad
    * @param:       String strName, Id idAccount,  Id idOwner, String strTipoProd, Id idPC, String devNameTipoRegistro, Id idProdBEyG
    * @Description: Método que retorna un objeto Oportunidad
    */
    public static Opportunity crearOportunidad(String strName, Id idAccount, Id idOwner, String devNameTipoRegistro) {
        final Opportunity objOpp       = new Opportunity();
        objOpp.Name              = strName;
        objOpp.StageName         = 'Abierta';
        objOpp.AccountId         = idAccount;
        objOpp.MX_RTL_Familia__c = STGCOLOCACION;
        objOpp.MX_RTL_Producto__c = STGCOLLARES;
        objOpp.CloseDate         = Date.today().addDays(15);
        objOpp.OwnerId           = idOwner;
        objOpp.op_amountPivote_dv__c = 100;
        if(String.isNotBlank(devNameTipoRegistro)) {
            objOpp.RecordTypeId = RecordTypeMemory_cls.getRecType('Opportunity', devNameTipoRegistro);
        }
        return objOpp;
    }

    /**
    * @Method:      createOppFin
    * @param:       User usrTst, String family, String prod
    * @Description: Método que retorna oportunidades
    */
    public static List<Opportunity> createOppFin(User usrTst, String family, String prod) {
        final List<Opportunity> opps = new List<Opportunity>();
        System.runAs(usrTst) {
            final Account acc = new Account();
            acc.Name = EU001_CLS_CONSTANTES.EU001_STR_NOMBRE_CLIENTE;
            acc.No_de_cliente__c = EU001_CLS_CONSTANTES.EU001_STR_NO_CLIENTE;
            insert acc;
        	final String recordId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(STGRTOPP).getRecordTypeId();

            final Opportunity opp = new Opportunity(Name=EU001_CLS_CONSTANTES.EU001_STR_NOMBRE_TEST, Probability = 75, Amount = 180000, ownerId = usrTst.Id, AccountId = acc.ID);
            opp.Tipo_de_Registro_Manual2__c = EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_FINANCIAMIENTO;
            opp.Tipo_Producto__c = EU001_CLS_CONSTANTES.EU001_STR_PLAN_PISO;
            opp.StageName=EU001_CLS_CONSTANTES.EU001_STR_FORMALIZACION_CREDITO;
            opp.CR_SEL_Plazo__c = EU001_CLS_CONSTANTES.EU001_STR_PLAZO_PRD_OPP_FINANCIAMIENTO;
            opp.recordtypeId = recordId;
            opp.CloseDate = date.today().addDays(3);
            opp.MX_RTL_Familia__c = family;
        	opp.MX_RTL_Producto__c = prod;
            opp.op_amountPivote_dv__c = 100;

            final Opportunity opp1 = new Opportunity(Name=EU001_CLS_CONSTANTES.EU001_STR_NOMBRE_TEST, Probability = 75, Amount = 180000, ownerId = usrTst.Id, AccountId = acc.ID);
            opp1.Name=EU001_CLS_CONSTANTES.EU001_STR_NOMBRE_TEST;
            opp1.Tipo_de_Registro_Manual2__c = EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_FINANCIAMIENTO;
            opp1.Tipo_Producto__c = EU001_CLS_CONSTANTES.EU001_STR_PLAN_PISO;
            opp1.StageName=EU001_CLS_CONSTANTES.EU001_STR_FORMALIZACION_CREDITO;
            opp1.CR_SEL_Plazo__c = EU001_CLS_CONSTANTES.EU001_STR_LARGO_PLAZO;
            opp1.recordtypeId = recordId;
            opp1.CloseDate = date.today().addDays(3);
            opp1.MX_RTL_Familia__c = family;
        	opp1.MX_RTL_Producto__c = prod;
            opp1.op_amountPivote_dv__c = 100;

            final Opportunity opp2 = new Opportunity(Name=EU001_CLS_CONSTANTES.EU001_STR_NOMBRE_TEST, Probability = 75, Amount = 180000, ownerId = usrTst.Id, AccountId = acc.ID);
            opp2.Name=EU001_CLS_CONSTANTES.EU001_STR_NOMBRE_TEST;
            opp2.Tipo_de_Registro_Manual2__c = EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_FINANCIAMIENTO;
            opp2.Tipo_Producto__c = EU001_CLS_CONSTANTES.EU001_STR_PLAN_PISO;
            opp2.StageName=EU001_CLS_CONSTANTES.EU001_STR_FORMALIZACION_CREDITO;
            opp2.CR_SEL_Plazo__c = EU001_CLS_CONSTANTES.EU001_STR_LARGO_PLAZO_7;
            opp2.recordtypeId = recordId;
            opp2.CloseDate = date.today().addDays(3);
            opp2.MX_RTL_Familia__c = family;
        	opp2.MX_RTL_Producto__c = prod;
            opp2.op_amountPivote_dv__c = 100;

            opps.add(opp);
            opps.add(opp1);
            opps.add(opp2);

            insert opps;
        }
        return opps;
    }

	@RemoteAction
    /** Lista createTestRecordsOpps*/
    public  static list<Opportunity> createTestRecordsOpps(String[] tipoOpp, User usrTst, String strFam, String strTipoProd) {
        final List<Opportunity> opps = new List<Opportunity>();
        final Integer rand = Math.round(Math.random()*1000);
        final Account acc = new Account();
        acc.Name = EU001_CLS_CONSTANTES.EU001_STR_NOMBRE_CLIENTE;
        acc.No_de_cliente__c = '910283' + rand;
        insert acc;

        final String recordId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(STGRTOPP).getRecordTypeId();
        for(Integer i=0;i<tipoOpp.size();i++) {
            Opportunity opp = new Opportunity();
            opp.Name=EU001_CLS_CONSTANTES.EU001_STR_NOMBRE_TEST;
            opp.Tipo_de_Registro_Manual2__c = tipoOpp[i];
            opp.StageName=EU001_CLS_CONSTANTES.EU001_STR_FORMALIZACION_CREDITO;
            opp.AccountId = acc.Id;
            opp.op_amountPivote_dv__c = 12000;
            opp.recordTypeId = recordId;
            if(tipoOpp[i] == EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_FINANCIAMIENTO && i<2) {
                opp.CR_SEL_Plazo__c = EU001_CLS_CONSTANTES.EU001_STR_PLAZO_PRD_OPP_FINANCIAMIENTO;
                opp.Tipo_Producto__c = EU001_CLS_CONSTANTES.EU001_STR_PLAN_PISO;
                opp.Amount = 25000.00;
            } else if(tipoOpp[i] == EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_FINANCIAMIENTO && i>1) {
                opp.CR_SEL_Plazo__c = EU001_CLS_CONSTANTES.EU001_STR_LARGO_PLAZO;
                opp.Tipo_Producto__c = EU001_CLS_CONSTANTES.EU001_STR_PLAN_PISO;
                opp.Amount = 25000.00;
            } else if(tipoOpp[i] == EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_VISTA) {
                opp.Tipo_Producto__c = EU001_CLS_CONSTANTES.EU001_STR_PRD_OPP_CUENTA_CHEQUES_MN;
                opp.Monto_de_la_oportunidad_Inv__c = 25000.00;
            } else if(tipoOpp[i] == EU001_CLS_CONSTANTES.EU001_STR_INVERSIONES) {
                opp.Tipo_Producto__c = EU001_CLS_CONSTANTES.EU001_STR_MONEDA_NACIONAL;
                opp.Monto_de_la_Oportunidad_Inv__c = 25000.00;
            } else {
                opp = getRecordsOtherOppTypes(opp, tipoOpp[i]);
            }
            opp.Numero_de_Nominados__c = 10;
            opp.Nomina_Rango_02__c = 100;
            opp.Nomina_Rango_01__c = 100;
            opp.Nomina_Rango_03__c = 100;
            opp.Nomina_Rango_04__c = 100;
            opp.Nomina_Rango_05__c = 100;
            opp.ownerId = usrTst.Id;
            opp.CloseDate = date.today().addDays(3);

            opp.MX_RTL_Familia__c = strFam;
        	opp.MX_RTL_Producto__c = strTipoProd;

            opps.add(opp);
        }
        insert opps;
        return opps;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          02-07-2019
* @Description  Build the opportunity.
* @Comments     Created from the clipped code block of method createTestRecordsOpps.
* @param        Opportunity opp, String tipoOpp
* @return       Opportunity
* @example      public static Opportunity getRecordsOtherOppTypes(Opportunity opp, String tipoOpp) {
**/
    public static Opportunity getRecordsOtherOppTypes(Opportunity opp, String tipoOpp) {
        if(tipoOpp == EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_ATM) {
            opp.Tipo_Producto__c = EU001_CLS_CONSTANTES.EU001_STR_CAJEROS_AUTOMATICOS;
            opp.Monto_de_la_oportunidad_Inv__c = 25000.00;
            opp.amount = 25000.00;
        } else if(tipoOpp == EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_COMERCIO_INTERNACIONAL) {
            opp.Tipo_Producto__c = EU001_CLS_CONSTANTES.EU001_STR_PAGO_IMPUESTOS_ADUANALES;
            opp.Monto_de_la_oportunidad_Inv__c = 25000.00;
            opp.op_amountPivote_dv__c=25000.00;
            opp.Amount = 25000.00;
        } else if(tipoOpp == EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_NOMINA) {
            opp.Tipo_Producto__c = EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_NOMINA;
            opp.Numero_de_Nominados__c = 10;
            opp.Nomina_Rango_02__c = 100;
            opp.Nomina_Rango_01__c = 100;
            opp.Nomina_Rango_03__c = 100;
        }
        return opp;
    }

    @RemoteAction
    /** metodo avanzaOpp*/
    public  static void avanzaOpp(List<Opportunity> listOpp) {

        for(Opportunity opp:listOpp) {
            opp.StageName =EU001_CLS_CONSTANTES.EU001_STR_FORMALIZACION_CREDITO;
            opp.Probability = 75;
        }

        update listOpp;

    }
    /** Lista*/
    public static List<EU_001_Compromiso__c> generaCompromisos() {
        final Integer rand = Math.round(Math.random()*1000);
        final Account acc = new Account();
        acc.Name = EU001_CLS_CONSTANTES.EU001_STR_NOMBRE_CLIENTE;
        acc.No_de_cliente__c = '8364' + String.valueOf(rand);

        insert acc;

        final String recordId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(STGRTOPPPYME).getRecordTypeId();

        final List<Opportunity> listOpp = new List<Opportunity>();

        final Opportunity opp = new Opportunity();
        opp.Name=EU001_CLS_CONSTANTES.EU001_STR_NOMBRE_TEST;
        opp.Tipo_de_Registro_Manual2__c = EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_FINANCIAMIENTO;
        opp.StageName=EU001_CLS_CONSTANTES.EU001_STR_PROMOCION;
        opp.CR_SEL_Plazo__c = '1 A 3 años';
        opp.Probability = 75;
        opp.amount = 180000;
        opp.AccountId = acc.ID;
        opp.CloseDate = date.today().addDays(3);
        opp.RecordTypeId = recordId;
        opp.MX_RTL_Familia__c = STGCOLOCACION;
        opp.MX_RTL_Producto__c = STGCOLLARES;

        listOpp.add(opp);

        final Opportunity opp_noComp = new Opportunity();
        opp_noComp.Name='Opp Test_NoComp';
        opp_noComp.Tipo_de_Registro_Manual2__c = EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_NOMINA;
        opp_noComp.StageName=EU001_CLS_CONSTANTES.EU001_STR_PROMOCION;
        opp_noComp.CR_SEL_Plazo__c = EU001_CLS_CONSTANTES.EU001_STR_PLAZO_PRD_OPP_FINANCIAMIENTO;
        opp_noComp.Probability = 75;
        opp_noComp.amount = 180000;
        opp_noComp.AccountId = acc.ID;
        opp_noComp.CloseDate = date.today().addDays(3);
        opp_noComp.RecordTypeId = recordId;
        opp_noComp.MX_RTL_Familia__c = STGCOLOCACION;
        opp_noComp.MX_RTL_Producto__c = STGCOLLARES;

        listOpp.add(opp_noComp);

        insert listOpp;

        avanzaOpp(listOpp);

        final List<EU001_RI__c> rI = MX_BPP_UserAndRIDataFactory.generaRI();
        final List<EU_001_Compromiso__c> lisComp = new List<EU_001_Compromiso__c>();

        final String idcCartera = Schema.SObjectType.EU_001_Compromiso__c.getRecordTypeInfosByName().get('BPyP Captación').getRecordTypeId();

        final EU_001_Compromiso__c comp1 = new EU_001_Compromiso__c();
        comp1.RecordTypeId = idcCartera;
        comp1.EU_001_Rb_Oportunidad__c = opp.Id;
        comp1.EU_001_Rb_Revisi_n_Individual_RI__c = rI[3].id;
        comp1.EU_001_dv_Compromiso__c = 135000;
        comp1.EU_fm_Fecha_Cierre__c = date.today().addDays(1);
        comp1.EU_001_ls_Estatus__c = EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO;
        lisComp.add(comp1);

        insert lisComp;

        comp1.EU_fm_Fecha_Cierre__c = date.today().addDays(10);
        update comp1;
        return lisComp;
    }
    /** Lista*/
	public static List<EU_001_Compromiso__c> generaCompromisosDO(String noCliente) {
        final Account acc = new Account(Name = EU001_CLS_CONSTANTES.EU001_STR_NOMBRE_CLIENTE, No_de_cliente__c = noCliente);
        insert acc;

        final EU001_RI__c rI = new EU001_RI__c();
        insert rI;

        final String idFinanciamiento = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(STGRTOPP).getRecordTypeId();

        final List<Opportunity> listOpp = new List<Opportunity>();

        final Opportunity Finaciamiento = new Opportunity(CR_SEL_Plazo__c = '1 A 3 años', Probability = 75, amount = 180000, op_amountPivote_dv__c = 180000);
        Finaciamiento.Name=EU001_CLS_CONSTANTES.EU001_STR_NOMBRE_TEST;
        Finaciamiento.Tipo_de_Oportunidad__c  = EU001_CLS_CONSTANTES.EU001_STR_NUEVA;
        Finaciamiento.Tipo_de_Registro_Manual2__c = EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_FINANCIAMIENTO;
        Finaciamiento.StageName=EU001_CLS_CONSTANTES.EU001_STR_PROMOCION;
        Finaciamiento.AccountId = acc.ID;
        Finaciamiento.CloseDate = date.today().addDays(3);
        Finaciamiento.RecordTypeId = idFinanciamiento;
        Finaciamiento.MX_RTL_Familia__c = STGCOLOCACION;
        Finaciamiento.MX_RTL_Producto__c = STGCOLLARES;

        listOpp.add(Finaciamiento);

        final Opportunity CPFin = new Opportunity();
        CPFin.Name=EU001_CLS_CONSTANTES.EU001_STR_NOMBRE_TEST;
        CPFin.Tipo_de_Oportunidad__c  = EU001_CLS_CONSTANTES.EU001_STR_NUEVA;
        CPFin.Tipo_de_Registro_Manual2__c = EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_FINANCIAMIENTO;
        CPFin.StageName=EU001_CLS_CONSTANTES.EU001_STR_PROMOCION;
        CPFin.CR_SEL_Plazo__c = EU001_CLS_CONSTANTES.EU001_STR_PLAZO_PRD_OPP_FINANCIAMIENTO;
        CPFin.Probability = 75;
        CPFin.amount = 180000;
        CPFin.op_amountPivote_dv__c = 180000;
        CPFin.AccountId = acc.ID;
        CPFin.CloseDate = date.today().addDays(3);
        CPFin.RecordTypeId = idFinanciamiento;
        CPFin.MX_RTL_Familia__c = STGCOLOCACION;
        CPFin.MX_RTL_Producto__c = STGCOLLARES;

        listOpp.add(CPFin);

        final Opportunity CPFin20 = new Opportunity();
        CPFin20.Name=EU001_CLS_CONSTANTES.EU001_STR_NOMBRE_TEST;
        CPFin20.Tipo_de_Oportunidad__c  = EU001_CLS_CONSTANTES.EU001_STR_NUEVA;
        CPFin20.Tipo_de_Registro_Manual2__c = EU001_CLS_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_COMERCIO_INTERNACIONAL;
        CPFin20.StageName=EU001_CLS_CONSTANTES.EU001_STR_PROMOCION;
        CPFin20.CR_SEL_Plazo__c = EU001_CLS_CONSTANTES.EU001_STR_PLAZO_PRD_OPP_FINANCIAMIENTO;
        CPFin20.Probability = 75;
        CPFin20.amount = 180000;
        CPFin20.op_amountPivote_dv__c = 180000;
        CPFin20.AccountId = acc.ID;
        CPFin20.CloseDate = date.today().addDays(3);
        CPFin20.RecordTypeId = idFinanciamiento;
        CPFin20.MX_RTL_Familia__c = STGCOLOCACION;
        CPFin20.MX_RTL_Producto__c = STGCOLLARES;

        listOpp.add(CPFin20);

        insert listOpp;
        avanzaOpp(listOpp);

        final List<EU_001_Compromiso__c> lisComp = insertCompromisosDO(Finaciamiento, CPFin, CPFin20, rI);

        return lisComp;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          02-07-2019
* @Description  Build and insert the EU_001_Compromiso__c records.
* @Comments     Created from the clipped code block of method generaCompromisosDO.
* @param        Opportunity Finaciamiento, Opportunity CPFin, Opportunity CPFin20, Opportunity FinLP, EU001_RI__c rI
* @return       List<EU_001_Compromiso__c>
* @example      public static List<EU_001_Compromiso__c> insertCompromisosDO(Opportunity Finaciamiento,
                Opportunity CPFin, Opportunity CPFin20, Opportunity FinLP, EU001_RI__c rI) {
**/
    public static List<EU_001_Compromiso__c> insertCompromisosDO(Opportunity Finaciamiento, Opportunity CPFin, Opportunity CPFin20, EU001_RI__c rI) {

        final List<EU_001_Compromiso__c> lisComp = new List<EU_001_Compromiso__c>();

        final EU_001_Compromiso__c comp1 = new EU_001_Compromiso__c();
        comp1.RecordTypeId = Schema.SObjectType.EU_001_Compromiso__c.getRecordTypeInfosByName().get('BPyP Captación').getRecordTypeId();
        comp1.EU_001_Rb_Oportunidad__c = Finaciamiento.Id;
        comp1.EU_001_Rb_Revisi_n_Individual_RI__c = rI.id;
        comp1.EU_001_dv_Compromiso__c = 135000;
        comp1.EU_fm_Fecha_Cierre__c = date.today().addDays(3);
        comp1.EU_001_ls_Estatus__c = EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO;
        comp1.EU001_ca_priorizado__c = false;
        lisComp.add(comp1);

        final EU_001_Compromiso__c comp2 = new EU_001_Compromiso__c();
        comp2.RecordTypeId = Schema.SObjectType.EU_001_Compromiso__c.getRecordTypeInfosByName().get('BPYP Servicios').getRecordTypeId();
        comp2.EU_001_ls_Estatus__c = EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO;
        comp2.EU_001_dv_Compromiso__c = 135000;
        comp2.EU_fm_Fecha_Cierre__c = date.today().addDays(3);
        comp2.EU_001_Rb_Oportunidad__c = CPFin.Id;
        comp2.EU_001_Rb_Revisi_n_Individual_RI__c = rI.id;
        comp2.EU001_ca_priorizado__c = false;
        lisComp.add(comp2);

        final EU_001_Compromiso__c compro = new EU_001_Compromiso__c();
        compro.RecordTypeId = Schema.SObjectType.EU_001_Compromiso__c.getRecordTypeInfosByName().get('BPYP Seguros').getRecordTypeId();
        compro.EU_001_ls_Estatus__c = EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO;
        compro.EU_001_dv_Compromiso__c = 135000;
        compro.EU_fm_Fecha_Cierre__c = date.today().addDays(3);
        compro.EU_001_Rb_Oportunidad__c = CPFin20.Id;
        compro.EU_001_Rb_Revisi_n_Individual_RI__c = rI.id;
        compro.EU001_ca_priorizado__c = false;
        lisComp.add(compro);

        insert lisComp;

        return lisComp;
    }
}