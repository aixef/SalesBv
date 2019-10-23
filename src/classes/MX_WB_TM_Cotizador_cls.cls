/**-------------------------------------------------------------------------
* Nombre: MX_WB_TM_Cotizador_cls
* Autor Ing. Daniel Goncalves
* Proyecto: MW WB TM - BBVA Bancomer
* Descripción : Clase Controladora del componente de Cotizador de Telemarketing

* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Desripción
* --------------------------------------------------------------------------
* 1.0           14/01/2019      Ing. Daniel Goncalves   Creación
* 1.1           15/01/2019      Ing. Daniel Goncalves   Refactorización
* 1.2           25/01/2019      Ing. Daniel Goncalves   Cambio a OpportunityLineItem
* 1.3           28/01/2019      Ing. Daniel Goncalves   Se agrega elección del Producto
* 1.4           31/01/2019      Ing. Daniel Goncalves   Borrado de OpportunityLineItem sin folio
* 1.5           11/02/2019      Ing. Daniel Goncalves   Refactorización Sonar
* 1.6           20/02/2019      Ing. Daniel Goncalves   Cambio de Origen__c a LeadSource
* 1.7           27/05/2019      Eduardo Hernández       Corrección CodeSmells
* 1.8           19/07/2019      Jaime Terrats           Se actualiza clase para construccion de URLS de vida y hogar
* --------------------------------------------------------------------------
**/
public without sharing class MX_WB_TM_Cotizador_cls {

    /*Construtor para Singleton*/
    private MX_WB_TM_Cotizador_cls() {} //NOSONAR
    /**
    * Retorna la URL necesaria para mostrar el cotizador
    * @param Id idOpporWanted ID Oportunidad de la que se requiere cotizar
    * @return String con la URL
    **/
    @AuraEnabled
    public static String crearURL ( String quoteId ) {
        String strMasterLabel;
        String finalURL;
        try {
            final Quote quoteData = [Select Id,Email, TotalPrice, Phone,BillingPostalCode,QuoteToName, Opportunity.Origen__c,
            Opportunity.LeadSource, Status, BillingAddress, ShippingStreet, ShippingPostalCode, MX_SB_VTS_Folio_Cotizacion__c,
            MX_SB_VTS_Familia_Productos__c, MX_SB_VTS_Familia_Productos__r.Name, QuoteToAddress, AccountId,
            OpportunityId, MX_SB_VTS_Movil_txt__c, MX_SB_VTS_Email_txt__c, MX_SB_VTS_Numero_Exterior__c,
            MX_SB_VTS_Numero_Interior__c, MX_SB_VTS_Colonia__c from Quote where Id =:quoteId];
            final Account accountData = [ SELECT Id, FirstName,BillingPostalCode, LastName, ApellidoMaterno__c, RFC__c, PersonMailingPostalCode,ShippingPostalCode,
            PersonMobilePhone, PersonEmail, Genero__c, PersonBirthdate FROM Account WHERE ID =: quoteData.AccountId];
            final QuoteLineItem quoliData = [Select Product2Id, MX_WB_Folio_Cotizacion__c, MX_WB_nombreAsegurado__c,
                MX_WB_emailAsegurado__c, MX_SB_VTS_Cancer_Tumores_Leucemia_Lupus__c, MX_SB_VTS_Aneurisma_Trombosis_Embolia__c,
                MX_SB_VTS_Insuficiencias_Cirrosis_Hepati__c, MX_SB_VTS_Frecuencia_de_Pago__c, MX_SB_VTS_Casa_o_Departamento__c,
                MX_SB_VTS_No_Pisos_Inmueble__c, MX_SB_VTS_Piso_Habitado__c, MX_SB_VTS_Proteccion_Sismo__c,
                MX_SB_VTS_Cercania_Mantos_Aquiferos__c, MX_SB_VTS_Muros_Tabique_Ladrillo_Block__c,
                MX_SB_VTS_Techo_Tabique_Ladrillo_Block__c, MX_SB_VTS_Plan__c, MX_SB_VTS_EmficemaBronquitisTuberculosis__c
                from QuoteLineItem where QuoteId =: quoteData.Id];
            if (quoteData.MX_SB_VTS_Familia_Productos__r.Name == System.Label.MX_SB_VTS_FamiliaASD) {
                strMasterLabel = MX_SB_VTS_Cotizador_ext.getMasterLabelValidation(quoliData.Product2Id);
                if ( String.isNotBlank( strMasterLabel ) ) {
                    finalURL = MX_WB_TM_Cotizador_cls.crearURLSeguro (accountData, quoteData, MX_SB_VTS_Cotizador_ext.createUrlPrefix(), strMasterLabel );
                }
            } else {
                strMasterLabel = MX_SB_VTS_Cotizador_ext.getMasterLabelHoVi(quoliData);
                if(String.isNotBlank(strMasterLabel)) {
                    finalURL = MX_SB_VTS_Cotizador_ext.crearURLSeguroHoVi(accountData, quoteData, MX_SB_VTS_Cotizador_ext.createUrlPrefix(), quoliData, strMasterLabel);
                }
            }
        } catch ( QueryException quEx ) {
            throw new AuraHandledException(System.Label.MX_WB_ERROR+quEx);
        }
        return finalURL;
    }

    /**
    * Retorna la URL necesaria para mostrar el cotizador, basado en datos de cotización y el producto
    * @param OpportunityLineItem objOpLi Objeto de OpportunityLineItem con información necesaria para URL
    * @param string strUrlBegin Contiene cadena de inicio de la URL
    * @param string strMasterLabel Etiqueta del producto deseado
    * @return String con la URL
    **/
    private static String crearURLSeguro( Account accountData, Quote quoteData, String strUrlBegin, String strMasterLabel ) {
        System.debug('crearURLSeguro::::: ');
        String urlSeg;
        final String postalCode = MX_SB_VTS_Cotizador_ext.validPostalCode(String.valueOf(quoteData.BillingPostalCode), String.valueOf(accountData.BillingPostalCode));
        final boolean blFolio = String.isBlank(quoteData.MX_SB_VTS_Folio_Cotizacion__c) ? false : true;
        final URL_Auto_Seguro_Bancomer__mdt objMSB = [ SELECT DeveloperName, URL__c, tipoUsoVehiculoCot__c FROM URL_Auto_Seguro_Bancomer__mdt
         WHERE MasterLabel =: strMasterLabel];
        if ( blFolio ) {
            System.debug('blFolio::::: '+blFolio);
            urlSeg = objMSB.URL__c + strUrlBegin + '&folioSalto='+ quoteData.MX_SB_VTS_Folio_Cotizacion__c;
        } else {
            final String strTelfAseg = String.isNotBlank(quoteData.Phone) ? quoteData.Phone :'';
            final String strOrigen = MX_SB_VTS_Cotizador_ext.validOrigin(quoteData.Opportunity.LeadSource, quoteData.Opportunity.Origen__c);
            urlSeg = objMSB.URL__c + strUrlBegin + '&nombreCot=' + quoteData.QuoteToName +
                '&emailCot=' + quoteData.Email + '&telefonoCot=' + strTelfAseg + '&sexoCot=' + accountData.Genero__c +
                '&codigoPostalCot=' + postalCode + '&fechaDeNacimientoCot=' + accountData.PersonBirthdate + '&idClienteCot=' + accountData.Id +
                '&idOportunidadComercialCot=' + quoteData.OpportunityId + '&origenOportunidadCot=' + strOrigen + '&tipoUsoVehiculoCot=' + objMSB.tipoUsoVehiculoCot__c;
        }
        System.debug('urlSeg::::: '+urlSeg);
        return urlSeg;
    }

    /**
    * Retorna la lista de productos disponibles para cotizar
    * @param ID idOppor Oportunidad a traer productos
    * @return List<String> con los productos disponibles
    **/
    @AuraEnabled
    public static Map<String, Object> fetchProductsLst ( ID idOppor ) {
        final Map<String, Object> response = new Map<String, Object>();
        try {
            final List<Product2> lstAllProd = [Select Id, IsActive, Name, MX_WB_FamiliaProductos__c from Product2 where IsActive = true ORDER BY NAME ASC];
            final List<Product2> lstAllProdIn = [Select Id, IsActive, Name, MX_WB_FamiliaProductos__c from Product2 where IsActive = true AND MX_WB_FamiliaProductos__r.Name =: System.Label.MX_SB_VTS_FamiliaASD ORDER BY NAME ASC];
            final List<Product2> lstAllProdFam = new List<Product2>();
            List<Product2> lstAllProdOut = new List<Product2>();
            final Opportunity oppData = [ SELECT CampaignId, Campaign.MX_SB_VTS_Familia_Producto__c, Campaign.MX_SB_VTS_FamiliaProducto_Proveedor__r.MX_SB_VTS_Familia_de_productos__c, MX_SB_VTS_OppCase__c, MX_SB_VTS_OppCase__r.ProductId, MX_SB_VTS_OppCase__r.Product.MX_WB_FamiliaProductos__c, Origen__c, Producto__c FROM Opportunity WHERE Id =: idOppor ];
            if(String.isNotBlank(oppData.Producto__c)) {
                final String correctName = MX_SB_VTS_Cotizador_ext.correctName(oppData.Producto__c);
                Product2 product = MX_WB_TelemarketingController.findCorrectProd(correctName, '');
                final Id productEq = product.MX_WB_FamiliaProductos__c;
                lstAllProdFam.addAll([Select Id, IsActive, Name, MX_WB_FamiliaProductos__c from Product2 where IsActive = true
                AND MX_WB_FamiliaProductos__c =: productEq ORDER BY NAME ASC]);
            }
            if ( String.isBlank( oppData.MX_SB_VTS_OppCase__c ) && String.isNotBlank( oppData.CampaignId ) && String.isNotBlank( oppData.Campaign.MX_SB_VTS_FamiliaProducto_Proveedor__r.MX_SB_VTS_Familia_de_productos__c)) {
                lstAllProdOut = [Select Id, IsActive, Name, MX_WB_FamiliaProductos__c from Product2 where IsActive = true AND MX_WB_FamiliaProductos__c =: oppData.Campaign.MX_SB_VTS_Familia_Producto__c ORDER BY NAME ASC];
            } else if(String.isNotBlank( oppData.MX_SB_VTS_OppCase__c ) && String.isNotBlank( oppData.MX_SB_VTS_OppCase__r.ProductId) && oppData.Origen__c == System.Label.MX_SB_VTS_SAC_LBL) {
                lstAllProdOut = [Select Id, IsActive, Name, MX_WB_FamiliaProductos__c from Product2 where IsActive = true AND MX_WB_FamiliaProductos__c =: oppData.MX_SB_VTS_OppCase__r.Product.MX_WB_FamiliaProductos__c ORDER BY NAME ASC];
            }
            response.put('lstProdOut', lstAllProdOut);
            response.put('lstProdIn', lstAllProdIn);
            response.put('lstAllProd', lstAllProd);
            response.put('lstAllProdFam', lstAllProdFam);
        } catch ( QueryException quEx ) {
            throw new AuraHandledException(System.Label.MX_WB_ERROR+quEx);
        }
        return response;
    }

    /**
    * Asigna producto a la oportunidad
    * @param ID idOpporWanted Oportunidad a asignar producto
    * @param String strProdName Nombre Producto a agregar
    * @return boolean si pudo hacer el cambio o no
    **/
    @AuraEnabled
    public static boolean addProduct ( ID idOpporWanted, String strProdName ) {
        try {
            final Product2 prodVal = [SELECT Id,MX_WB_FamiliaProductos__c,Name FROM Product2 WHERE Id =: strProdName];
            if ( String.isNotBlank( prodVal.Id ) && String.isNotBlank( prodVal.MX_WB_FamiliaProductos__c )) {
                final Quote presupuesto = new Quote();
                final QuoteLineItem quoli = new QuoteLineItem();
                Boolean hasPriceBook = true;
                presupuesto.OpportunityId = idOpporWanted;
                presupuesto.MX_SB_VTS_Familia_Productos__c = prodVal.MX_WB_FamiliaProductos__c;
                presupuesto.Status = 'Creada';
                for ( PricebookEntry pbe : [select Id,Pricebook2Id FROM PricebookEntry where Product2Id =: strProdName ] ) {
                    quoli.PricebookEntryId = pbe.Id;
                    presupuesto.Pricebook2Id = pbe.Pricebook2Id;
                    hasPriceBook = false;
                }
                if (hasPriceBook) {
                    final PricebookEntry pbe = MX_WB_OppoLineItemUtil_cls.crearPricebookEntry(strProdName, 1.00);
                    insert pbe;
                    presupuesto.Pricebook2Id = pbe.Pricebook2Id;
                    quoli.PriceBookEntryId = pbe.Id;
                }
                final Opportunity oppData = [Select Id, Account.PersonEmail, Account.FirstName,Account.LastName, Account.ApellidoMaterno__c, Account.BillingPostalCode,Account.PersonMobilePhone from Opportunity where Id =: idOpporWanted];
                presupuesto.Name = prodVal.Name;
                presupuesto.MX_SB_VTS_Nombre_Contrante__c = oppData.Account.FirstName;
                presupuesto.Email = oppData.Account.PersonEmail;
                presupuesto.MX_SB_VTS_Email_txt__c = oppData.Account.PersonEmail;
                presupuesto.Phone = oppData.Account.PersonMobilePhone;
                presupuesto.MX_SB_VTS_Movil_txt__c = oppData.Account.PersonMobilePhone;
                presupuesto.QuoteToName = oppData.Account.FirstName+ ' '+ oppData.Account.LastName + (String.isNotBlank(oppData.Account.ApellidoMaterno__c) ? (' '+oppData.Account.ApellidoMaterno__c) :'');
                presupuesto.BillingPostalCode = oppData.Account.BillingPostalCode;
                insert presupuesto;

                quoli.QuoteId = presupuesto.Id;
                quoli.UnitPrice = 1.00;
                quoli.Quantity = 1;

                insert quoli;
                oppData.MX_WB_Producto__c=prodVal.Id;
                oppData.Producto__c=prodVal.Name;
                update oppData;

            }
        } catch ( QueryException quEx ) {
            throw new AuraHandledException ( System.Label.MX_WB_LG_ErrorBack + ' - Actualizando Cuenta ' + quEx);
        }
        return true;
    }

    /**
     * addProductInbound Agregar productos Inbound
     * @param  idOpporWanted Oportunidad buscada
     * @param  strProdName   Nombre del producto a buscar
     * @return               Boolean si se encuentran resultados
     */
    @AuraEnabled
    public static boolean addProductInbound ( Id idOpporWanted, String strProdName ) {
        Boolean responseBool = false;
        try {
            String correctName = MX_SB_VTS_Cotizador_ext.correctName(strProdName);
            final Product2 prodVal = MX_WB_TelemarketingController.findCorrectProd(correctName, '');
            responseBool = addProduct(idOpporWanted, prodVal.Id);
        } catch(QueryException quex) {
            throw new AuraHandledException(Label.MX_WB_LG_ErrorBack + ' ' + quex);//NOSONAR
        }
        return responseBool;
    }

    /**
     * initDataQuotes Inicializa componente de cotizaciones
     * @param  oppVals valores de oportunidades
     * @return         valores de inicio
     */
    @AuraEnabled
    public static Map<String, Object> initDataQuotes(String oppVals) {
        final Map<String, Object> response = new Map<String, Object>();
        try {
            final Type oppType = Type.forName('Opportunity');
            final Opportunity oppData = (Opportunity)JSON.deserialize(oppVals, oppType);
            final Account accData = [Select Id, Name from Account where Id =: oppData.AccountId];
            final List<Contract> lstcontract = [Select Id, Name, MX_WB_Producto__c from Contract where AccountId =: oppData.AccountId];
            final List<Quote> lstQuotes = [Select Id,OpportunityId,MX_SB_VTS_Familia_Productos__c from Quote where OpportunityId =: oppData.Id ORDER BY CreatedDate DESC];
            final List<Case> lstCase = [Select Id,EstadoSistema__c,Status, ProductId, Product.Name, Product.MX_WB_FamiliaProductos__c from Case where Id =: oppData.MX_SB_VTS_OppCase__c];
            final String recordOutBound = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Outbound').getRecordTypeId();
            final String recordInBound = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ASD').getRecordTypeId();
            final RecordType recordTy = [Select Id, IsActive, Name, DeveloperName from RecordType where Id =: oppData.RecordTypeId];
            response.put('accData', accData);
            response.put('lstcontract', lstcontract);
            response.put('lstCase', lstCase);
            response.put('lstQuotes', lstQuotes);
            response.put('recordOutBound', recordOutBound);
            response.put('recordInBound', recordInBound);
            response.put('recordObject', recordTy);
        } catch (QueryException qEx) {
            throw new AuraHandledException ( System.Label.MX_WB_LG_ErrorBack + qEx +qEx.getLineNumber());
        }
        return response;
    }

    /**
     * crearURLCotNum RecuperaUrl por Numero de Folio
     * @param  quoteNumber Numero de folio
     * @return             Url de cotizador
     */
    @AuraEnabled
    public static String crearURLCotNum(String quoteNumber) {
        String finalUrl = '';
        try {
            final Id idQuoteData = [Select Id from Quote where MX_SB_VTS_Folio_Cotizacion__c =: quoteNumber].Id;
            finalUrl = crearURL(idQuoteData);
        } catch (QueryException quex) {
            throw new AuraHandledException ( System.Label.MX_WB_LG_ErrorBack + quex);
        }
        return finalUrl;
    }
}
