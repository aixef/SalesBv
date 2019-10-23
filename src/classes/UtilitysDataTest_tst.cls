/*----------------------------------Desarrollado por INDRA--------------------------------
*Autor:         Trabajo en Equipo
*Proyecto:      MAX - BBVA Bancomer
*Descripción:   Clase para crear los Datos de prueba generales de utilería para ser usados
                en las demas clases de prueba
*_______________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        22/MAR/2018     Sergio Ortiz                        Creación.
*1.1        15/JUN/2018     Cristian Espinosa                   Se agrega Product2, OLI,
                                                                OppBanca.
*1.2        25/JUN/2018     Daniel García                       Se agrega método crearPriceBook
*1.3        08/JUL/2018     Ricardo Almanza                     Se asignación de registro en crearReporteVisita
*1.4        14/AGO/2018     Jhovanny De La Cruz Cruz            Se agrega método de creación de registros tipo GBL_CommercialAction__c
*1.5	    23/08/2018	    Francisco J Licona			        Se agrega método que retorna objeto de reunión individual.
*1.6        23/AGO/2018	    Sergio Ortiz 			            Se agrega método crearLead, crearReportVisiPrincipalHI, crearContacto
                                                                Se corrigen Parametros de entrada en algunos metodos.
*1.7        23/AGO/2018     Luis Ruben Quinto Muñoz             Se agrega método de creación de registros tipo Plan_de_Choque__c crearPlandeChoqueTipo
*1.8		30/08/2018		Pedro Alan Sierra					Se agregan los métodos: generateMenuConfiguration & generateComponentConfiguration
*																Para la obtención de Objetos (CustomSettings) de la funcionalidad de los menus de la RI.
*1.9        23/AGO/2018     Luis Ruben Quinto Muñoz             Se agrega método de creación de registros tipo Plan_de_Choque__c crearPlandeChoqueTipo
*1.10       11/SEP/2018     Luis Ruben Quinto Muñoz             Se agrega método de creación de registros tipo ctrk__Tracking__c creaTracking
*2.0        12/SEP/2018     Ricardo Almanza Angeles             Se modificó metodo de crear contacto para no relacionarlo a cuenta
*2.1        19/09/2018      Angel Fuertes Gomez          	    Cambio del contacto principal
*2.2        19-09-2018      Francisco J Licona                  Se agregan métodos que devuelven los objetos
                                                                ExpUni_Tablero_Grupal__c y EU_001_Compromiso__c.
*2.3       28/09/2018      Angel Fuertes Gomez                  Cambio del contacto decisor de BPyP
*2.4        24/SEP/2018     Cristian Espinosa                   Se elimina dependencia a campo Producto_BEyG__c del objeto Opportunity
*																*Se elimina método crearProducto, ya que ya no es necesario
*2.5        06/NOV/2018     Ricardo Almanza                     Se agrego metodo de crear visita Hipotecaria
*2.6        01/NOV/2018     Francisco Bueno                     Se agregan método que retorna un Objeto de Tarif_rio__c
*2.7        25/ENE/2019     Ricardo Almanza                     Se agrega método para Acc Camp de Pyme y sus clases de prueba
*2.8        11/FEB/2019     Daniel García                     	Se agregan método para creación de registros MX_PyME_Balance_Productos__c
*2.9        22/FEB/2019     Luis Fernando Romero                Se agrega método para indicadores de logro
*2.10       07/Jul/2019     Hugo Carrillo                       Se agrega el método crearAccCampaign.
*2.10       02/SEP/2019     Jair Ignacio Gonzalez               Se modifica el metodo crearOportunidad() para la reingenieria de Oportunidades
*																	y se crea metodo para crear Producto
-----------------------------------------------------------------------------------------*/
@isTest
public class UtilitysDataTest_tst {

    /** */
    static Map<String, Profile> perfilMapa = new Map<String, Profile>();
    /** */
    static Map<String, UserRole> rolMapa   = new Map<String, UserRole>();

    @isTest static void test_method_two() {
        Integer MAX_QUERY = Limits.getLimitQueries();
        Integer NUM_QUERY = MAX_QUERY - 1;
        System.assert(Limits.getQueries() < NUM_QUERY, 'numero de querys dentro del rango  permitido');
    }
    /**
    * @Method:      crearUsuario
    * @param:       String strLastName, String strProfileName, String strRol
    * @Description: Método que retorna un objeto User
    */
    public static User crearUsuario(String strLastName, String strProfileName, String strRol) {
        String email                  = 'tstBBVA'+(Math.random()*10000)+'@bbva.test.com';
        User usuario                  = new User();
        usuario.LastName              = strLastName;
        usuario.Alias                 = String.valueOf((Math.random()*10000).round());
        usuario.Email                 = email;
        usuario.UserName              = email;
        usuario.EmailEncodingKey      = 'UTF-8';
        usuario.LanguageLocaleKey     = 'en_US';
        usuario.TimeZoneSidKey        = 'America/Mexico_City';
        usuario.LocaleSidKey          = 'en_US';
        usuario.IsActive              = true;
        usuario.ProfileId             = getProfileId(strProfileName);
        if(String.isNotBlank(strRol)) {
            usuario.UserRoleId = getRoleId(strRol);
        }
        usuario.CompanyName           = 'SulAmérica';
        usuario.CR__c                 = '0001';
        usuario.UG__c                 = String.valueOf((Math.random()*10000000).round());
        usuario.Segmento_Ejecutivo__c = 'EMPRESARIAL';
        usuario.VP_ls_Banca__c        = 'Red BEyG';
        return usuario;
    }

    /**
    * @Method:      getRoleId
    * @param:       String roleName
    * @Description: Método que retorna un id de role a partir de su nombre
    */
    private static Id getRoleId(String roleName) {
        Id roleId;
        if(rolMapa.containsKey(roleName)) {
            roleId = rolMapa.get(roleName).Id;
        } else if(String.isNotBlank(roleName)) {
            List<UserRole> newRoles = [Select Id, Name from UserRole where Name =: roleName];
            if(!newRoles.isEmpty()) {
                UserRole roleToAdd = newRoles.get(0);
                rolMapa.put(roleToAdd.Name, roleToAdd);
                roleId = roleToAdd.Id;
            }
        }
        return roleId;
    }

    /**
    * @Method:      getProfileId
    * @param:       String profileName
    * @Description: Método que retorna un id de perfil a partir de su nombre
    */
    private static Id getProfileId(String profileName) {
        Id profileId;
        if(perfilMapa.containsKey(profileName)) {
            profileId = perfilMapa.get(profileName).Id;
        } else if(String.isNotBlank(profileName)) {
            List<Profile> newProfiles = [Select Id, Name from Profile where Name =: profileName];
            if(!newProfiles.isEmpty()) {
                Profile profileToAdd = newProfiles.get(0);
                perfilMapa.put(profileToAdd.Name, profileToAdd);
                profileId = profileToAdd.Id;
            }
        }
        return profileId;
    }

    /**
    * @Method:      crearCuenta
    * @param:       String strName, String dvNmeTpoReg
    * @Description: Método que retorna un objeto cliente
    */
	public static Account crearCuenta(String strName, String dvNmeTpoReg) {
		Account cliente          = new Account();
		cliente.Name             = strName;
		cliente.No_de_cliente__c = String.valueOf((Math.random()*10000000).round());
		cliente.RecordTypeId     = RecordTypeMemory_cls.getRecType('Account', dvNmeTpoReg);
		return cliente;
    }

    /**
    * @Method:      crearContacto
    * @param:       Id idCuenta, String strFirstName, String strLastName,  String dvNmeTpoReg
    * @Description: Método que retorna un objeto contacto
    */

	public static Contact crearContacto(Id idCuenta, String strFirstName, String strLastName,  String dvNmeTpoReg) {
		Contact contacto   = new Contact();
		contacto.FirstName = strFirstName;
		contacto.LastName  = strLastName;
		contacto.Phone     = '(234) 567-8987';
		contacto.Email     = 'tstBBVA'+((Math.random()*10000).round())+'@bbva.test.com';
		if(idCuenta!=null) {
            contacto.AccountId = idCuenta;
        }
		if(String.isNotBlank(dvNmeTpoReg)) {
            contacto.RecordTypeId = RecordTypeMemory_cls.getRecType('Contact', dvNmeTpoReg);
        }
		return contacto;
    }

    /**
    * @Method:      crearEvento
    * @param:       DateTime dtStarEvent, Id idWhatId, String dvNmeTpoReg
    * @Description: Método que retorna un objeto Evento, si no se especifica el tipo de registro asigna
    *               el default según el perfil quien ejecuta el método de prueba
    */

    public static Event crearEvento(DateTime dtStarEvent, Id idWhatId, String dvNmeTpoReg) {
		Event evento              = new Event();
		evento.StartDateTime      = dtStarEvent;
		evento.Subject            = 'PruebaEvento';
		evento.WhatId             = idWhatId;
		evento.IsRecurrence       = false;
		//if(String.isNotBlank(dvNmeTpoReg)) evento.RecordTypeId = RecordTypeMemory_cls.getRecType('Event', dvNmeTpoReg);
    	return evento;
    }

    /**
    * @Method:      crearTarea
    * @param:       String strName, Id idOwner, Id idWhatId
    * @Description: Método que retorna un objeto Evento, si no se especifica el tipo de registro asigna
    *               el default según el perfil quien ejecuta el método de prueba
    */

    public static Task crearTarea(String strName, Id idOwner, Id idWhatId) {
        Task tarea     = new Task();
        tarea.OwnerId  = idOwner;
        tarea.Subject  = strName;
        tarea.Status   = 'Open';
        tarea.Priority = 'Normal';
        tarea.WhatId   = idWhatId;
        return tarea;
    }

    /**
    * @Method:      crearOportunidad
    * @param:       String strName, Id idAccount,  Id idOwner, String strFam String strTipoProd, Id idPC, String devNameTR, Id idProdBEyG
    * @Description: Método que retorna un objeto Oportunidad
    */

    public static Opportunity crearOportunidad(String strName, Id idAccount,  Id idOwner, String strFam, String strTipoProd, Id idPC, String devNameTR) {
        Opportunity objOpp       = new Opportunity();
        objOpp.Name              = strName;
        objOpp.StageName         = 'Abierta';
        objOpp.AccountId         = idAccount;
        objOpp.MX_RTL_Familia__c = strFam;
        objOpp.MX_RTL_Producto__c = strTipoProd;
        objOpp.CloseDate         = Date.today().addDays(15);
        objOpp.OwnerId           = idOwner;
        objOpp.op_amountPivote_dv__c = 100;
        if(String.isNotBlank(devNameTR)) {
            objOpp.RecordTypeId = RecordTypeMemory_cls.getRecType('Opportunity', devNameTR);
        }
        return objOpp;
    }

    /*------------------------------------------------------------------------------------------------------
    *@Description Method to create records of type MX_PyME_Balance_Productos__c
    * -----------------------------------------------------------------------------------------------------
    * @Author   Dnaiel García
    * @Date     2019-02-10
    * @param    conceptoCredito Description of credit
    * @param    indicadorImpago Indicates if the credit has non-payments
    * @param    noCredito Number of credit id
    * @param    tipoProducto Indicates if a product is type 'A' or 'B'
    * @param	idCliente Client ID
    * @param	indServicio Specifies if a service is of type CRTC,TPVS,SEGR or FISICA
    * @param 	descripcionServicio Description of the service
    * @param 	saldoServicio Amount available of the service
    * @return   Record of type MX_PyME_Balance_Productos__c
    * @example  MX_PyME_Balance_Productos__c product=UtilitysDataTest_tst.crearProductoPyME('TDC NEGOCIOS','N','007627367236','A',cliente8.id,'','','');
    * */
    public static MX_PyME_Balance_Productos__c crearProductoPyME(String conceptoCredito, String indicadorImpago, String noCredito, String tipoProducto, id idCliente, String indServicio, String descripcionServicio, Double saldoServicio) {
        MX_PyME_Balance_Productos__c prodPyme = new MX_PyME_Balance_Productos__c();
        prodPyme.MX_PyME_Concepto_Credito__c = conceptoCredito;
        prodPyme.MX_PyME_Saldo_deudor__c = (Math.random()*1000000);
        prodPyme.MX_PyME_Indicador_impago__c = indicadorImpago;
        prodPyme.MX_PyME_prodNumero_credito__c = noCredito;
        prodPyme.MX_PyME_Tipo_producto__c = tipoProducto;
        prodPyme.MX_PyME_Cliente__c = idCliente;
        prodPyme.MX_PyME_Identificador_servicio__c = indServicio;
        prodPyme.MX_PyME_Descripcion_servicio__c = descripcionServicio;
        prodPyme.MX_PyME_Saldo_del_servicio__c = saldoServicio;
        return prodPyme;
    }

    /**
    * @Method:      creaAccCampaign
    * @param:       String OwnerId Owner SFId
    * @param:       String dvNmeTpoReg devName of AccCamp to create
    * @param:       String campLoad Campaign related to AccCamp
    * @param:       String accLoad extId of Acc to load
    * @Description: Método que retorna un objeto tipo Campaign
    **/
    public static cond__Account_Campaign__c crearAccCampaign(String OwnerId,String dvNmeTpoReg,String campLoad,String accLoad) {
        cond__Account_Campaign__c camp = new cond__Account_Campaign__c();
        camp.Name = 'camp ' + OwnerId + campLoad;
        if(String.isNotBlank(dvNmeTpoReg)) {
		camp.RecordTypeId=RecordTypeMemory_cls.getRecType('cond__Account_Campaign__c', dvNmeTpoReg);
	}
        camp.cond__campaign_start_date__c = Date.today().addDays(2);
        camp.cond__campaign_end_date__c = Date.today().addDays(6);
        camp.cond__campaign_desc__c = 'Campaña de prueba';
        camp.OwnerId = OwnerId;
        camp.cond__campaign_load_id__c = campLoad;
        camp.cond__data_source_name__c = 'Archivo';
        camp.cond__solution_category_type__c = 'Py';
        camp.cond__solution_category_name__c = 'Py27';
        camp.cond__participant_load_id__c = accLoad;
        return camp;
    }
    /**
    * @Method:      crearProdForm
    * @param:       String family  product´s family
    * @param:       String prod   product
    * @Description: Método que crea al producto ingresado en Product2,ProductVersion, ProductConfiguration y PricebookEntry
    **/
    public static void crearProdForm(String family, String prod) {
        final Product2 objProd = new Product2();
        objProd.Banca__c = 'Red BPyP';
        objProd.CurrencyIsoCode = 'MXN';
        objProd.Family = family;
        objProd.IsActive = true;
        objProd.Name = prod;
        objProd.ProductCode = prod;
        Insert objProd;

        final fprd__GBL_Product_version__c objProdVer = new fprd__GBL_Product_version__c();
        objProdVer.fprd__Active__c = true;
        objProdVer.fprd__Product__c = objProd.Id;
        objProdVer.fprd__Version_number__c = 1;
        Insert objProdVer;

        final fprd__GBL_Product_Configuration__c objPrdCnf = new fprd__GBL_Product_Configuration__c();
        objPrdCnf.CurrencyIsoCode = 'MXN';
        objPrdCnf.fprd__DeveloperName__c = 'productTest';
        objPrdCnf.fprd__Important__c = false;
        objPrdCnf.fprd__Label__c = 'Test Product';
        objPrdCnf.fprd__Type__c = 'text';
        objPrdCnf.fprd__Product__c = objProd.Id;
        objPrdCnf.fprd__Map_field__c = 'Name';
        Insert objPrdCnf;

        final Id pricebookId = Test.getStandardPricebookId();

        final PricebookEntry objPribkEntry = new PricebookEntry();
        objPribkEntry.CurrencyIsoCode = 'MXN';
        objPribkEntry.IsActive = true;
        objPribkEntry.Pricebook2Id = pricebookId;
        objPribkEntry.Product2Id = objProd.Id;
        objPribkEntry.UseStandardPrice = false;
        objPribkEntry.UnitPrice = 0;
        Insert objPribkEntry;
    }

    /**
    * @Method:      crearCaso
    * @param:       Account idAccount, String strStatus, String strComentario, Id idPlantilla, String dvNmeTpoReg
    * @Description: Método que retorna un objeto Caso
    */
    public static Case crearCaso(Account idAccount, String strStatus, String strComentario, String dvNmeTpoReg) {
        final Case objCaso                        = new Case();
        objCaso.Account                     = idAccount;
        objCaso.Status                      = strStatus;
        objCaso.RecordTypeId                = RecordTypeMemory_cls.getRecType('Case', dvNmeTpoReg);
        return objCaso;
    }
}