/**
* Wibe
* @author          sistemas Wibe
* Description:     Este cotrolador se utiliza para realizar upserts sobre cotizaciones que vienen de tracking web
* -------------------------------------
*           No.    Fecha          Autor                          Descripción
*           ----   ----------     ---------------------------    -------------
* @version   1.0                  Karen Belem Sanchez Ruiz(KB)   Se utiliza para realizar upserts sobre cotizaciones que vienen de tracking web
* @version   1.1    06/04/2018    Sistemas Wibe  (MGGT)          Se agrega campo GCLID
* @version   1.2                  Karen Belem Sanchez Ruiz(KB)   Se agregan las variables de valorPromocion y campanya (skyp payment)
* @version   1.3    03/10/2018    Karen Belem Sanchez Ruiz(KB)   Se agregan las variables de Fecha inicio/fin y nombre de la aseguradora (wiberizate)
* @version   1.4    15/01/2019    Ing. Daniel Goncalves(DAGV)    Ajuste para cotizador de TLMK se agrega method fnUpsertOpoLineItem
* @version   1.5    30/01/2019    Ing. Daniel Goncalves(DAGV)    Se agregan campos al OpportunityLineItem para fnUpsertOpoLineItem
* @version   1.6    12/02/2019    Ing. Daniel Goncalves(DAGV)    Corrección campo producto para fnUpsertOpoLineItem
* @version   1.7    13/02/2019    Ing. Daniel Goncalves(DAGV)    Se agrega validación de RecordType para Outbound
* @version   1.8    18/02/2019    Ing. Daniel Goncalves(DAGV)    Se elimina method fnConvertirCandidato
* @version   1.9    19/02/2019    Ing. Daniel Goncalves(DAGV)    Se corrige upsert para Wibe
* @version   1.10   20/02/2019    Ing. Daniel Goncalves(DAGV)
* @version   1.11   27/02/2019    Francisco Javier García G(FJ)  Mapeo de campo fraude y cupón
* @version   1.12   10/04/2019    Julio Medellin Oliva           Se agrega un nuevo registro en el objeto cotizador(Quote) a.
* @version   1.13   27/05/2019    Julio Medellin Oliva           create dyamic apex for queries and  DML operations
* @version   1.14   11/06/2019    Eduardo Hernández Cuamatzi     Correcciones Sonar
             1.14.1 17/07/2019    Eduardo Hernández Cuamatzi   Cambio de tipo de dato para telefonos de cliente y asegurado

***********************************************************************************************************************/
@RestResource(urlMapping='/Cotizacion/*' )
global without sharing class rtwCotizacion extends  MX_SB_VTS_rtwCotizacion_ext { //NOSONAR
    /*Variabale para nulos*/ 
    private static final id idnull  = null;
    /*Variabale para retener datos del cliente*/
    global final static String idRecTypOutBound = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(System.Label.MX_SB_VTS_OUTBOUND_RT_LBL).getRecordTypeId();
    /*Variabale para retener datos del cliente*/
    private static Quote presupuesto = new Quote();
    /*Variabale para retener datos del cliente*/
    private static QuoteLineItem quoli = new QuoteLineItem();
    /*Variabale para retener datos del cliente*/
    private static PricebookEntry pbe = new  PricebookEntry();
    private rtwCotizacion() {}//NOSONAR

    /**
    * Función de Web Services
    * @param reqCotizacion cotizacion Cotizacion a actualizar o crear
    * @return List<resSFDC>
    **/
    @HttpPost
    global static List<resSFDC> upsertCotizacion ( reqCotizacion cotizacion ) {

        List<resSFDC> lrSFDC = new List<resSFDC>();
        lrSFDC =   upsertCotiza(cotizacion);
        return lrSFDC;
    }


    private static   Map<string,String>  configurationField(string criteria) {
        Map<string,String> fieldConf = new Map<string,String>();
        MX_SB_VTS_Generica__c[] config  = [SELECT MX_SB_VTS_quOli_Item__c,MX_SB_VTS_Oli_Item__c  FROM MX_SB_VTS_Generica__c WHERE MX_SB_VTS_Type__c=:criteria];
        for(MX_SB_VTS_Generica__c conf :config) {
            fieldConf.put(conf.MX_SB_VTS_Oli_Item__c,conf.MX_SB_VTS_quOli_Item__c);
        }
        return fieldConf;
    }

    /***
    * Method para crear un presupuesto Apartir de la actualización y/o creación de una Cotizacíon(Opportunity/oportunidad)
    **/
    private static void fillDataQuote(Quote presupuesto,PriceBookEntry pbe,Opportunity objCot,reqCotizacion cotizacion,Product2 objPro) {
        Map<string,String> fieldConf = new Map<string,String>();
        Map<string,String> fieldConf2 = new Map<string,String>();
        Map<string,String> fieldConf3 = new Map<string,String>();
        fieldConf  = configurationField('CA1');
        fieldConf2 = configurationField('CA2');
        fieldConf3 = configurationField('CA3');
        MX_SB_VTS_rtwCotizacion_ext.fillPresuQuote(presupuesto, cotizacion, fieldConf);
        MX_SB_VTS_rtwCotizacion_ext.fillPresuOpp(presupuesto, objCot, fieldConf2);
        MX_SB_VTS_rtwCotizacion_ext.fillPresuAccount(presupuesto, objCot, fieldConf3);
        presupuesto.Pricebook2Id = pbe.Pricebook2Id;
        presupuesto.MX_SB_VTS_Familia_productos__c = objPro.MX_WB_Familiaproductos__c;
        presupuesto.Name = objPro.Name;
        presupuesto.MX_SB_VTS_RFC__c = MX_SB_VTS_rtwCotizacion_ext.contratante.RFC__c;
        presupuesto.MX_SB_VTS_Sexo_Conductor__c	= cotizacion.sexoConductor.toUpperCase().equals(System.Label.MX_SB_VTS_MASCULINO_LBL) ?System.Label.MX_SB_VTS_H_LBL : System.Label.MX_SB_VTS_M_LBL;
        presupuesto.QuoteToName =   cotizacion.nombreDelContratante+' '+cotizacion.apellidoPaternoContratante+' '+cotizacion.apellidoMaternoContratante;
        presupuesto.Phone =  MX_SB_VTS_rtwCotFillData.validEmptyStr(cotizacion.telefonoCelularContratante);
        presupuesto.MX_SB_VTS_Movil_txt__c = MX_SB_VTS_rtwCotFillData.validEmptyStr(cotizacion.telefonoCelularContratante);
        presupuesto.MX_SB_VTS_Email_txt__c = MX_SB_VTS_rtwCotFillData.validEmptyStr(cotizacion.correoElectronicoContratante);
        presupuesto.MX_SB_VTS_Cupon__c = MX_SB_VTS_rtwCotFillData.validEmptyStr(cotizacion.codigoCupon);
        if(Cotizacion.estatus.Equals(System.Label.MX_SB_VTS_STATUSEMITIDA_LBL)) {
        presupuesto.MX_SB_VTS_FechaInicio__c = cotizacion.fechaPolizaIni;
        presupuesto.MX_SB_VTS_FechaFin__c = cotizacion.fechaPolizaFin;
        }
        MX_SB_VTS_utilityQuote.prepareQuoteSync(presupuesto);
        upsert presupuesto;
    }

    /***
    * Method para rellanar QuoteLineItem
    **/
    private static void fillDataQuoli(QuoteLineItem quoli,PriceBookEntry pbe,reqCotizacion cotizacion) {
        quoli.Quantity=1;
        quoli.UnitPrice = Double.valueOf(cotizacion.primaCotizada)>0?Double.valueOf(cotizacion.primaCotizada):pbe.UnitPrice;
        quoli.MX_WB_comentariosPersonalizados__c = cotizacion.comentariosPersonalizacion;
        quoli.MX_WB_cuenta_con_dispositivo_satelital__c = cotizacion.cuetaConDispositivos;
        quoli.MX_WB_Descuento_con_cupones__c = cotizacion.descuentoCupones;
        quoli.MX_WB_EstatusCotizacion__c = cotizacion.estatus;
        quoli.MX_WB_existen_conductores_adicionales__c = cotizacion.alguienMasConduce;
        quoli.MX_WB_Marca__c = cotizacion.marca;
        quoli.MX_WB_Modelo__c =  cotizacion.modelo;
        quoli.MX_WB_noPoliza__c = cotizacion.numeroPoliza;
        quoli.MX_WB_numeroSerie__c = cotizacion.numeroDeSerieDelVehiculo;
        quoli.MX_WB_placas__c = cotizacion.placas;
        quoli.MX_WB_SaleACarretera__c = cotizacion.saleACarretera;
        quoli.MX_WB_subMarca__c  = cotizacion.SubMarca;
        quoli.MX_WB_Tipo_de_auto__c  = cotizacion.tipoAuto;
        quoli.MX_WB_Folio_Cotizacion__c = cotizacion.folioDeCotizacion;
        quoli.MX_WB_Alguien_mas_conduce__c = cotizacion.alguienMasConduce;
        quoli.MX_SB_VTS_Anio__c = cotizacion.anio;
        quoli.MX_WB_comentariosPersonalizados__c = cotizacion.comentariosPersonalizacion;
        quoli.Description = cotizacion.descripcion;
        quoli.MX_SB_VTS_Descuento_Facultado__c = cotizacion.descuentoFacultado;
        quoli.MX_WB_edad_de_conductor_adicional__c	 = cotizacion.edadConductoresAdicionles;
        quoli.MX_SB_VTS_Descuento_Facultado__c = cotizacion.formaDePago;
        quoli.MX_SB_VTS_PersonaPolizaAsegurado__c = cotizacion.laPersonaQueAdquiereLaPolizaEsElContratante.Equals(System.Label.MX_SB_VTS_SI_LBL)?true:false;
        quoli.MX_SB_VTS_Plan__c = cotizacion.plan;
        quoli.MX_SB_VTS_Version__c = cotizacion.version;
        quoli.MX_WB_apellidoPaternoAsegurado__c=cotizacion.apellidoPaternoContratante;
        quoli.MX_WB_apellidoMaternoAsegurado__c=cotizacion.apellidoMaternoContratante;
        quoli.MX_WB_celularAsegurado__c =cotizacion.telefonoCelularContratante;
        quoli.MX_WB_telefonoAsegurado__c = cotizacion.telefonoCelularContratante;
        quoli.MX_SB_VTS_FormaPAgo__c=cotizacion.formaDePago;
        quoli.MX_WB_origen__c = cotizacion.origenDeLaCotizacion;
        quoli.MX_WB_emailAsegurado__c = cotizacion.correoElectronicoContratante;
        quoli.MX_WB_fechaEmision__c =System.today();
        try {
            upsert quoli;
        } catch (DmlException e) {
            throw new AuraException(e);
        }
    }

    /***
    * Method para crear un presupuesto
    **/
    private static void createQuote(Opportunity objCot, reqCotizacion cotizacion) {
        Product2 objPro;
        try {
            final String prodName = MX_SB_VTS_ValidCorrectNamesASD.validASD(cotizacion.producto);
            objPro = [ SELECT Id,MX_WB_Familiaproductos__c,Name FROM Product2 WHERE Name =: prodName AND IsActive=TRUE and MX_SB_SAC_Proceso__c = 'VTS'];
        } catch(Exception e) {
            WB_CrearLog_cls.fnCrearLog(System.Label.MX_SB_VTS_ErrorMsgProd_LBL, System.Label.MX_SB_VTS_COTIZADORAUTO_LBL, false);
        }
        if ( String.isNotBlank( objPro.Id ) && String.isNotBlank( objPro.MX_WB_Familiaproductos__c )) {

            Boolean  quoliexist = false;

            pbe=CreatePricebookEntry(pbe,objPro,cotizacion);
            getPresupuesto(cotizacion,objPro);
            try {
                fillDataQuote(presupuesto,pbe,objCot,Cotizacion,objPro);
                findQuotePol(Cotizacion);

            } catch(Exception e) {
                WB_CrearLog_cls.fnCrearLog(System.Label.MX_SB_VTS_ERRORMSGQUOTE_LBL +e.getMessage() + e, System.Label.MX_SB_VTS_COTIZADORAUTO_LBL, false);
            }
            for( QuoteLineItem quol : [SELECT Id, OpportunityLineItemId, Product2Id FROM QuoteLineItem WHERE  QuoteId =: presupuesto.Id  AND Product2Id =: objPro.Id ]) {
                quoli = quol;
                quoliexist = true;
            }
            if(!quoliexist) {
                quoli.QuoteId=  presupuesto.Id;
                quoli.Product2Id=  objPro.Id;
                quoli.PricebookEntryId = pbe.Id;
            }
            fillDataQuoli(quoli,pbe,Cotizacion);
        }

    }
    /** funcion de apoyo para WS **/
    private static PricebookEntry CreatePricebookEntry(PricebookEntry pbe2,Product2 objPro,reqCotizacion cotizacion) {
        PricebookEntry pbe = pbe2;
        Boolean pricebookexist = false;
        for(PricebookEntry  p  :[SELECT ID,UnitPrice,PriceBook2Id,Product2ID FROM priceBookEntry WHERE Product2Id  =: objPro.ID]) {
            pbe =p;
            pricebookexist = true;
        }
        if (pricebookexist == false) {
            pbe = MX_WB_OppoLineItemUtil_cls.crearPricebookEntry(objPro.Id, Decimal.valueOf(cotizacion.primaCotizada)>0?integer.valueOf(cotizacion.primaCotizada):1);
            insert pbe;
        }
        return pbe;
    }

    /**
     * findQuotePol busca Quote por Número de póliza
     * @param  cotizacion Objeto Póliza encontrado
     */
    public static void findQuotePol(reqCotizacion cotizacion) {
        if (String.isNotBlank(cotizacion.numeroPoliza)) {
            for(Quote quot : [SELECT ID FROM QUOTE WHERE MX_SB_VTS_Numero_de_Poliza__c =: cotizacion.numeroPoliza]) {
                presupuesto.Id = quot.Id;
            }
        }
    }

    /** funcion de apoyo para WS **/
    private static void getPresupuesto(reqCotizacion cotizacion, Product2 objPro) {
        for(Quote quot : [SELECT ID FROM QUOTE WHERE MX_SB_VTS_Folio_Cotizacion__c =: cotizacion.folioDeCotizacion]) {
            presupuesto = quot;
        }
        if(String.isBlank(Presupuesto.ID) && String.isNotBlank(Cotizacion.idOportunidadComercial)) {
            for(QuoteLineItem quoliSerch : [SELECT ID,QuoteId FROM QuoteLineItem WHERE Quote.OpportunityId =: Cotizacion.idOportunidadComercial AND Product2id =: ObjPro.Id AND Quote.Status =: System.Label.MX_SB_VTS_CREADA_LBL ORDER BY CreatedDate ASC]) {
                presupuesto.Id = quoliSerch.QuoteId;
            }
        }

    }

    /**
    * Crea o actualiza Oportunidad
    * @param reqCotizacion cotizacion Cotizacion a convertir crear Oportunidad
    * @param String idOpp ID Oportunidad
    * @param String idCliente ID Cliente
    * @param infoCompbeneficiario objinfoCompbeneficiario Info Beneficiario
    * @return List<resSFDC>
    **/
    public static String fnUpsertOportunidad (reqCotizacion cotizacion, String idOpp, String idCliente, infoCompbeneficiario objinfoCompbeneficiario,String nameAccount ) {//NOSONAR
        String sIdOpp = '';
		final String STRINGNULL = null;
        Opportunity objCot = new Opportunity();
        Opportunity oppAct = new Opportunity();
        boolean blIsTlmkCoti = false;
        try {
            List<Quote> lstOppId = [Select OpportunityId from Quote where MX_SB_VTS_Folio_Cotizacion__c =: cotizacion.folioDeCotizacion];
            sIdOpp = lstOppId.size() > 0 ? lstOppId[0].OpportunityId : STRINGNULL;
            if(String.isBlank(sIdOpp)) {
                oppAct=CosultaQuote(cotizacion);
                if (String.isBlank( oppAct.LeadSource )) {
                    objCot.LeadSource = cotizacion.origenDeLaCotizacion.equalsIgnoreCase(System.Label.MX_SB_VTS_OUTBOUND_LBL)? System.Label.MX_SB_VTS_TRACKINGWEB_LBL: cotizacion.origenDeLaCotizacion;
                } else {
                    blIsTlmkCoti =  oppAct.LeadSource.Equals(System.Label.MX_SB_VTS_OUTBOUNDTLMK_LBL)?true:false;
                }
                objCot=getOpportunity2(cotizacion,objCot,blIsTlmkCoti);
                objCot.VieneDeLaInterface__c = cotizacion.laPersonaQueAdquiereLaPolizaEsElContratante.Equals(System.Label.MX_SB_VTS_NO_LBL)?true:false;
                final Date d = System.today();
                objCot.Name = String.isBlank(cotizacion.folioDeCotizacion) ? (String.valueOf(d.day()) + '/' + String.valueOf(d.month()) + '/' + String.valueOf(d.year())) : cotizacion.folioDeCotizacion + ' - ' + cotizacion.nombreDelContratante + (String.isBlank(cotizacion.apellidoPaternoContratante) ? '' : (' '+cotizacion.apellidoPaternoContratante));
                objCot.Reason__c=System.label.MX_SB_VTS_VENTA_LBL;
                objCot.producto__c = validacionproducto(cotizacion.producto);
                objCot.EnviarPolizaporemail__c = false;
            }
            objCot=getOpportunity3(cotizacion, objCot, idCliente, idOpp);
            sIdOpp = String.isNotBlank( objCot.Id ) ? objCot.Id:System.Label.MX_SB_VTS_1STR_LBL;

        } catch ( Exception e ) {
            sIdOpp = objCot.Id + '-' + e.getMessage() + System.Label.MX_SB_VTS_COTIZACION_LBL + objCot + System.Label.MX_SB_VTS_USUARIO_LBL + UserInfo.getName() + System.Label.MX_SB_VTS_CAUSA_LBL + e.getCause() + System.Label.MX_SB_VTS_LINEA_LBL + e.getLineNumber();
        }

        return sIdOpp;
    }

    /**
     * CosultaQuote busca Quote por Folio cotización
     * @param  cotizacion request cotización
     * @return            objeto Opportunity encontrado
     */
    private static Opportunity CosultaQuote(reqCotizacion cotizacion) {
        Opportunity oppAct = new Opportunity();
        if (String.isNotBlank(cotizacion.folioDeCotizacion)) {
            for(Quote quot : [SELECT Id, OpportunityId, Opportunity.LeadSource, Opportunity.Account.Name FROM QUOTE WHERE MX_SB_VTS_Folio_Cotizacion__c =: cotizacion.folioDeCotizacion]) {
                oppAct = quot.Opportunity;
            }
        }
        return oppAct;
    }

    /**
     * getOpportunity2 Recupera Oportunidad
     * @param  cotizacion   request cotización
     * @param  objCotret    Oportunidad encontrada
     * @param  blIsTlmkCoti si viene de cotizador telemarketing
     * @return              Objeto Oportunidad encontrada
     */
    private static Opportunity getOpportunity2(reqCotizacion cotizacion, Opportunity objCotret, boolean blIsTlmkCoti) {//NOSONAR
        final Opportunity objCot=objCotret;
        final String vartPolEmit = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get( 'ASD' ).getRecordTypeId();
        if ( cotizacion.estatus.equalsIgnoreCase( System.Label.MX_SB_VTS_STATUSEMITIDA_LBL ) || cotizacion.estatus.equalsIgnoreCase( System.Label.MX_SB_VTS_COBRADA_LBL ) || cotizacion.motivoDeInteres.equalsIgnoreCase( System.Label.MX_SB_VTS_VENTA_LBL ) ) {
            if ( !blIsTlmkCoti ) {
                objCot.ForecastCategoryName = System.Label.MX_SB_VTS_CLOSED_LBL;
                objCot.ActualizaClipert__c = true;
            }
            if ( cotizacion.estatus.equalsIgnoreCase(System.Label.MX_SB_VTS_STATUSEMITIDA_LBL ) ) {
                for ( Opportunity cliente : [ SELECT Account.Name FROM Opportunity WHERE FolioCotizacion__c =: cotizacion.folioDeCotizacion ] ) {
                    objCot.Name = cotizacion.folioDeCotizacion + '-' + cliente.Account.Name;
                    if ( !blIsTlmkCoti ) {
                        objCot.RecordTypeId = vartPolEmit;
                    }
                    objCot.Fechaventa__c = System.today();
                }
            }
        }
        objCot.StageName = System.Label.MX_SB_VTS_COTIZACION_LBL;
        return objCot;
    }

    /**
     * getOpportunity3 extension de clase getOpportunity
     * @param  cotizacion request Cotización
     * @param  objCotret  Oportunidad encontrada
     * @param  idCliente  Cliente existente
     * @param  idOpp      Oportunidad existente
     * @return            Oportunidad encontrada
     */
    private static Opportunity getOpportunity3(reqCotizacion cotizacion, Opportunity objCotret,String idCliente, String idOpp) {//NOSONAR
        Opportunity objCot=objCotret;
        Boolean oppQuoteExist=false;
        objCot.AccountId = String.isNotBlank(cotizacion.cliente) ? cotizacion.cliente : idnull;
        objCot.Id =  String.isNotBlank( idOpp ) ? idOpp : idnull ;
        objCot.CloseDate = ( String.isNotBlank( String.valueOf( cotizacion.fechaCierre ) ) ? cotizacion.fechaCierre : system.today() );
		objCot.TelefonoCliente__c = MX_SB_VTS_rtwCotFillData.validEmptyStr(cotizacion.telefonoCelularContratante);
        objCot.CorreoCliente__c = MX_SB_VTS_rtwCotFillData.validEmptyStr(cotizacion.correoElectronicoContratante);
        objCot.FolioCotizacion__c = cotizacion.folioDeCotizacion;
        if(String.isBlank(objCot.Id)) {
            for(Quote quot : [SELECT Id, OpportunityId FROM QUOTE WHERE MX_SB_VTS_Folio_Cotizacion__c =: cotizacion.folioDeCotizacion]) {
                oppQuoteExist=true;
                Idopp = quot.OpportunityId;
            }
            if(oppQuoteExist) {
                objCot=[SELECT  LeadSource, Account.Name,Account.BillingStreet,account.BillingCity,Account.BillingState,account.BillingCountry,account.BillingPostalCode,Account.Telefono_Celular2__c FROM Opportunity WHERE Id =: Idopp];
                objCot.Name = cotizacion.folioDeCotizacion + ' - ' + objCot.Account.Name;
            }
        }
        if(String.isNotBlank(cotizacion.codigoCupon)) {
            objCot.MX_WB_EnvioCTICupon__c = validarCupon(cotizacion.codigoCupon);
            objCot.MX_WB_Cupon__c = cotizacion.codigoCupon;
        }

        upsert objCot;
        Opportunity oppAcc = objCot=[SELECT LeadSource, Account.Name,Account.BillingStreet,Account.BillingCity,Account.BillingState,Account.BillingCountry,Account.BillingPostalCode FROM Opportunity WHERE Id =: objCot.Id AND AccountId =: objCot.AccountId];
        createQuote(oppAcc, cotizacion);
        return objCot;
    }

    /**
    * Obtiene el objeto del JSON
    * @param String sJsonResp JSON Respuesta
    * @return reqCotizacion
    **/
    public static reqCotizacion JSONParserreqCotizacion ( String sJsonResp ) {
        reqCotizacion objAPPResp = new reqCotizacion();
        try {
            final JSONParser parser = JSON.createParser(sJsonResp);
            while ( parser.nextToken() != null ) {
                if ( parser.getCurrentToken() == JSONToken.START_OBJECT ) {
                    objAPPResp = ( reqCotizacion ) parser.readValueAs ( reqCotizacion.class );
                }
            }
        } catch ( Exception ex ) {
            System.debug ( System.Label.MX_SB_VTS_JSONError_LBL + ex.getMessage() + System.Label.MX_SB_VTS_LINEA_LBL + ex.getLineNumber() );
        }
        return objAPPResp;
    }

    /**
    * Obtiene un Nombre correcto para producto
    * @param String producto Respuesta String
    */
    private static  String  validacionproducto(String producto) { //NOSONAR
        String correctName = producto;
        correctName = MX_SB_VTS_ValidCorrectNamesASD.validProASD(producto);
        final String vartem1 = correctName;
        correctName = MX_SB_VTS_ValidCorrectNamesASD.validProMoto(vartem1);
        final String vartem2 = correctName;
        correctName = MX_SB_VTS_ValidCorrectNamesASD.validProFront(vartem2);
        final String vartem3 = correctName;
        correctName = MX_SB_VTS_ValidCorrectNamesASD.validProLegal(vartem3);
        return correctName;
    }

    /**
    * Valida si un cupón es valida
    * @param String Cupón Respuesta String
    */
    private static Boolean validarCupon(String cupon) {
        final String prefijoCupon = cupon.left(5);
        Boolean cuponValido = false;
        final List<MX_WB_Cupon__c> cupones = [Select Id, Name from MX_WB_Cupon__c where Name =: prefijoCupon];
        cuponValido = cupones.isEmpty()?((cupon.contains(System.Label.MX_SB_VTS_MB_LBL))?true:false):true;
        return cuponValido;

    }
}
