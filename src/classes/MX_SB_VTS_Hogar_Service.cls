/*
*
* @author Jaime Terrats
* @description This class will be used to upsert data coming from Hogar tracking web
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    04/10/2019     Jaime Terrats     Create data structure to get incoming data from web tracking
* @version  1.1    05/10/2019     Jaime Terrats     Remove code smells
* @version  1.2    05/22/2019     Jaime Terrats     Fix Quoli update and remove code smells
* @version  1.3    05/23/2019     Jaime Terrats     Fix Quoli Update
* @version  1.4    05/24/2019     Jaime Terrats     Fix null values for checkbox fields
* @version  1.5    06/06/2019     Jaime Terrats     Fix null value cupon
* @version  1.6    06/19/2019     Jaime Terrats     Fix opp close won
*/
@RestResource(urlMapping='/Hogar/*')
global without sharing class MX_SB_VTS_Hogar_Service {
    /*
    * Define opp status
    */
    private static final String EMITIDA='Emitida',
                                CREADA='Creada';
    private MX_SB_VTS_Hogar_Service() {} //NOSONAR

    /**
     * cotizarSeguroHogar Cotiza seguro de hogar
     * @param	datosCotizacion Datos e la cotización
     * @return	resSFDC	Valor de salesforce
     */
    @HttpPost
    global static List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC> cotizarSeguroHogar(MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion) {
        // validate if folioCotizacion exists Quote
        final List<Quote> validaFolioCot = [Select Id, Name from  Quote where MX_SB_VTS_Folio_Cotizacion__c =: datosCotizacion.datosIniciales.folioCotizacion];
        List<Account> lstAcc = new List<Account>();
        final List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC> resSFDC = new List<MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC>();
        MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC res = new MX_SB_VTS_HogarWrapper.MX_SB_VTS_ResponseSFDC();
        res.error = '';
        res.message = '';
        res.id = '';
        if(validaFolioCot.isEmpty() == false) {
            // get Account, Opportunity and Quoute Line item
            // validate if account exists by searching by email or mobile phone
            lstAcc = [Select Id from Account where PersonEmail =: datosCotizacion.datosCliente.Email];
            if(lstAcc.isEmpty() == false) {
                upsertAccount(datosCotizacion);
                res.message += ' Cuenta localizada: ' + lstAcc[0].id;
                resSFDC.add(res);
            } else {
                res.message = 'Generando nuevo folio para el cliente';
                res.id += 'id de la cuenta: ' + upsertAccount(datosCotizacion);
                resSFDC.add(res);
            }
        } else {
            res.message = 'Generando nuevo folio para el cliente';
            res.id += 'id de la cuenta: ' + upsertAccount(datosCotizacion);
            resSFDC.add(res);
        }
        return resSFDC;
    }

    /**
     * upsertAccount Upsert a la cuenta
     * @param	datosCotizacion Datos e la cotización
     * @return	accsToUpsert	Regresa una lista
     */
    private static Id upsertAccount(MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion) {
        final Id accRT = Schema.SobjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        final List<Account> lstAccount = [Select Id, FirstName, LastName, ApellidoMaterno__c, PersonBirthdate,
                                    PersonEmail, PersonHomePhone, PersonMobilePhone, BillingStreet,
                                    BillingCity, BillingPostalCode, BillingState, BillingCountry,
                                    Numero_Exterior__c, Numero_Interior__c
                                    from Account where PersonEmail =: datosCotizacion.datosCliente.email];

        final List<Account> accsToUpsert = new List<Account>();
        if(lstAccount.isEmpty() == false) {
            // Will update account information if needed
            for(Account a : lstAccount) {
                // Customer basic information: fname, lname, email, phone
                a = accountInit(a,datosCotizacion);
                a.PersonMailingCity = a.BillingCity;
                a.PersonMailingState = a.BillingState;
                a.PersonMailingStreet = a.BillingStreet;
                a.PersonMailingPostalCode = a.BillingPostalCode;
                a.PersonMailingCountry = a.BillingCountry;
                accsToUpsert.add(a);
            }
        } else {
            Account asegurado = new Account();
                asegurado = accountInit(asegurado,datosCotizacion);
                asegurado.RecordTypeId = accRT;
            accsToUpsert.add(asegurado);
        }
        if(!accsToUpsert.isEmpty()) {
            try {
                Database.upsert(accsToUpsert);
                upsertOpportunity(accsToUpsert[0], datosCotizacion);
            } catch(DmlException dmlEx) {
                throw new DmlException('Err ' + dmlEx);
            }
        }
        return accsToUpsert[0].Id;
    }

    /**
     * accountInit Init de la cuenta
     * @param	retorig Datos de la cuenta
     * @param	datosCotizacion	Datos de la cotización
     * @return	ret	Regresa datos de la cuenta
     */
    private static Account accountInit(Account retorig, MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion) {
        final Account ret = retorig;
            ret.FirstName = datosCotizacion.datosCliente.nombre;
            ret.PersonEmail = datosCotizacion.datosCliente.email;
            ret.LastName = datosCotizacion.datosCliente.apPaterno;
            ret.PersonBirthdate = date.parse(datosCotizacion.datosCliente.fechaNacimiento);
            ret.PersonHomePhone = datosCotizacion.datosCliente.telefonoCasa;
            ret.PersonMobilePhone = datosCotizacion.datosCliente.celular;
            ret.Genero__c = datosCotizacion.datosCliente.sexo;
            ret.RFC__c = datosCotizacion.datosCliente.rfc;
            ret.BillingStreet = datosCotizacion.datosDomicilio.calleCliente;
            ret.BillingCity = datosCotizacion.datosDomicilio.ciudadCliente;
            ret.BillingPostalCode = datosCotizacion.datosDomicilio.cpCliente;
            ret.BillingState = datosCotizacion.datosDomicilio.estadoCliente;
            ret.ApellidoMaterno__c = datosCotizacion.datosCliente.apMaterno;
            ret.BillingCountry = datosCotizacion.datosDomicilio.paisCliente;
            ret.Numero_Exterior__c = datosCotizacion.datosDomicilio.numExtCliente;
            ret.Numero_Interior__c = datosCotizacion.datosDomicilio.numIntCliente;
            ret.Colonia__c = datosCotizacion.datosDomicilio.coloniaCliente;

        return ret;
    }

    /**
     * upsertOpportunity upsert a la oportunidad
     * @param	acc Id de la cuenta
     * @param	datosCotizacion	Datos de la cotización
     */
    private static void upsertOpportunity(Account acc, MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion) {
        // Upsert opportunity data
        final Id inboundRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_Telemarketing_LBL).getRecordTypeId();
        final Id outboundRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_Telemarketing_LBL).getRecordTypeId();
        final List<Opportunity> lstOpps = [Select Id, Name, StageName, FolioCotizacion__c,
                                    Reason__c, Producto__c, MX_SB_VTS_Aplica_Cierre__c
                                    from Opportunity where AccountId =: acc.Id
                                    and Producto__c =: datosCotizacion.datosIniciales.producto
                                    and Probability > 1 and Probability < 100 order by CreatedDate desc];
        final List<Opportunity> oppsToUpsert = new List<Opportunity>();
        if(lstOpps.isEmpty()) {
            // create new Opportunity
            final Opportunity cotizacion = new Opportunity();
            cotizacion.Name = lstOpps.size() + 1  + ' ' + acc.FirstName + ' ' + acc.LastName;
            cotizacion.CloseDate = System.today();
            cotizacion.AccountId = acc.Id;
            cotizacion.FolioCotizacion__c = datosCotizacion.datosIniciales.folioCotizacion;
            cotizacion.Reason__c = 'Venta';
            cotizacion.Producto__c = datosCotizacion.datosIniciales.producto;
            if(EMITIDA.equalsIgnoreCase(datosCotizacion.datosIniciales.statusCotizacion)) {
                cotizacion.StageName = 'Closed Won';
                cotizacion.MX_SB_VTS_Aplica_Cierre__c = true;
            } else {
                cotizacion.StageName = 'Cotización';
            }
            switch on datosCotizacion.datosIniciales.origen {
                when 'inbound' {
                        cotizacion.RecordTypeId = inboundRT;
                        cotizacion.LeadSource = 'Tracking web';
                }
                when 'outbound' {
                    cotizacion.RecordTypeId = outboundRT;
                    cotizacion.LeadSource = 'Outbound TLMK';
                }
            }
            oppsToUpsert.add(cotizacion);
        } else {
            if(EMITIDA.contains(datosCotizacion.datosIniciales.statusCotizacion) &&
            String.isNotBlank(datosCotizacion.datosIniciales.numeroPoliza)) {
                lstOpps[0].MX_SB_VTS_Aplica_Cierre__c = true;
            }
            upsertQuote(lstOpps[0], datosCotizacion);
        }

        if(!oppsToUpsert.isEmpty()) {
            try {
                Database.Upsert(oppsToUpsert);
                upsertQuote(oppsToUpsert[0], datosCotizacion);
            } catch(DmlException dmlEx) {
                throw new DmlException('DML:'+dmlEx);
            }
        }
    }

    /**
     * upsertQuote upsert al Quote
     * @param	opp Id de la oportunidad
     * @param	datosCotizacion	Datos de la cotización
     */
    private static void upsertQuote(Opportunity opp, MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion) {
        // Upsert Quote data
        final List<Quote> lstQuote = [Select Id, Name, Status, MX_SB_VTS_Folio_Cotizacion__c, MX_SB_VTS_Numero_de_Poliza__c,
                                ShippingStreet, ShippingPostalCode, ShippingCity, ShippingState, OpportunityId,
                                ShippingCountry, MX_SB_VTS_Numero_Exterior__c, MX_SB_VTS_Numero_Interior__c
                                from Quote where MX_SB_VTS_Folio_Cotizacion__c =: datosCotizacion.datosIniciales.folioCotizacion];
        final List<Quote> quotesToUpsert = new List<Quote>();
        final Id famProductId = [Select MX_WB_FamiliaProductos__c from Product2 where Name =: datosCotizacion.datosIniciales.producto].MX_WB_FamiliaProductos__c;
        if(lstQuote.isEmpty() == false) {
            // check if should update Quote Data
            for(Quote presupuesto : lstQuote) {
                // if Folio Cotizacion is empety
                presupuesto.Name = presupuesto.MX_SB_VTS_Folio_Cotizacion__c + ' ' + opp.Name;
                presupuesto.ShippingStreet = datosCotizacion.datosDomAsegurado.calleCliente;
                presupuesto.MX_SB_VTS_Colonia__c = datosCotizacion.datosDomAsegurado.coloniaCliente;
                presupuesto.MX_SB_VTS_Numero_Exterior__c = datosCotizacion.datosDomAsegurado.numExtCliente;
                presupuesto.MX_SB_VTS_Numero_Interior__c = datosCotizacion.datosDomAsegurado.numIntCliente;
                presupuesto.ShippingPostalCode = datosCotizacion.datosDomAsegurado.cpCliente;
                presupuesto.ShippingState = datosCotizacion.datosDomAsegurado.estadoCliente;
                presupuesto.ShippingCity = datosCotizacion.datosDomAsegurado.ciudadCliente;
                presupuesto.ShippingCountry = datosCotizacion.datosDomAsegurado.paisCliente;
                presupuesto.MX_SB_VTS_Numero_de_Poliza__c =  datosCotizacion.datosIniciales.numeroPoliza;
                presupuesto.MX_SB_VTS_Movil_txt__c = datosCotizacion.datosCliente.celular;
                presupuesto.MX_SB_VTS_Email_txt__c = datosCotizacion.datosCliente.email;
                quotesToUpsert.add(quoteValidation(presupuesto,datosCotizacion,opp));
            }
        } else {
            final Quote presupuesto = new Quote();
            presupuesto.MX_SB_VTS_Folio_Cotizacion__c = datosCotizacion.datosIniciales.folioCotizacion;
            presupuesto.Name = presupuesto.MX_SB_VTS_Folio_Cotizacion__c + ' ' + opp.Name;
            presupuesto.OpportunityId = opp.Id;
            presupuesto.ShippingStreet = datosCotizacion.datosDomAsegurado.calleCliente;
            presupuesto.MX_SB_VTS_Colonia__c = datosCotizacion.datosDomAsegurado.coloniaCliente;
            presupuesto.MX_SB_VTS_Numero_Exterior__c = datosCotizacion.datosDomAsegurado.numExtCliente;
            presupuesto.MX_SB_VTS_Numero_Interior__c = datosCotizacion.datosDomAsegurado.numIntCliente;
            presupuesto.ShippingPostalCode = datosCotizacion.datosDomAsegurado.cpCliente;
            presupuesto.ShippingState = datosCotizacion.datosDomAsegurado.estadoCliente;
            presupuesto.ShippingCity = datosCotizacion.datosDomAsegurado.ciudadCliente;
            presupuesto.ShippingCountry = datosCotizacion.datosDomAsegurado.paisCliente;
            presupuesto.MX_SB_VTS_Familia_Productos__c = famProductId;
            presupuesto.MX_SB_VTS_Movil_txt__c = datosCotizacion.datosCliente.celular;
            presupuesto.MX_SB_VTS_Email_txt__c = datosCotizacion.datosCliente.email;
            quotesToUpsert.add(quoteValidation(presupuesto,datosCotizacion,opp));
        }
        if(!quotesToUpsert.isEmpty()) {
            try {
                Database.upsert(quotesToUpsert);
                upsertQuoteLineItem(quotesToUpsert[0], datosCotizacion);
            } catch(DmlException dmlEx) {
                throw new DmlException('Error! '+dmlEx);
            }
        }
    }

    /**
     * QuoteValidation Validación de Quote
     * @param	Completar Presupuesto
     * @param	datosCotizacion	Datos de la cotización
     * @param	opp	Id de la oportunidad
     * @return	tempPresupuesto	Status del presupuesto
     */
    private static Quote quoteValidation(Quote completar, MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion, Opportunity opp) {
        Quote tempPresupuesto = completar;
        switch on datosCotizacion.datosIniciales.statusCotizacion {
            when 'Creada' {
                if(String.isEmpty(tempPresupuesto.MX_SB_VTS_Folio_Cotizacion__c) && CREADA.contains(tempPresupuesto.Status)) {
                        tempPresupuesto.MX_SB_VTS_Folio_Cotizacion__c = datosCotizacion.datosIniciales.folioCotizacion;
                        tempPresupuesto.Status = datosCotizacion.datosIniciales.statusCotizacion;
                } else {
                        final Quote clonePresupuesto = tempPresupuesto.clone(false, false, false, false);
                        clonePresupuesto.MX_SB_VTS_Folio_Cotizacion__c = datosCotizacion.datosIniciales.folioCotizacion;
                        clonePresupuesto.OpportunityId = opp.Id;
                        clonePresupuesto.Status = datosCotizacion.datosIniciales.statusCotizacion;
                        tempPresupuesto=clonePresupuesto;
                    }
                }
                when 'Cotizada' {
                    tempPresupuesto.Status = datosCotizacion.datosIniciales.statusCotizacion;
                }
                when 'Tarificada' {
                    tempPresupuesto.Status = datosCotizacion.datosIniciales.statusCotizacion;
                }
                when 'Cobrada' {
                    tempPresupuesto.Status = 'Formalizada';
                }
                when 'Emitida' {
                    if(String.isNotBlank(tempPresupuesto.MX_SB_VTS_Numero_de_Poliza__c)) {
                        tempPresupuesto.Status = datosCotizacion.datosIniciales.statusCotizacion;
                        MX_SB_VTS_utilityQuote.prepareQuoteSync(tempPresupuesto);
                    }
                }
            }
        return tempPresupuesto;
    }

    /**
     * upsertQuoteLineItem Upsert a QuoteLineItem
     * @param	presupuesto Id presupuesto
     * @param	datosCotizacion	Datos de la cotización
     */
    private static void upsertQuoteLineItem(Quote presupuesto, MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion) {
        // Upsert Quote Line Item data
        final List<String> dataCot = new List<String>();
        dataCot.add([select Id from Product2 where Name =: datosCotizacion.datosIniciales.producto].Id);
        dataCot.add(datosCotizacion.datosPrecio.precioTotal);

        final List<QuoteLineItem> lstQuoli = [Select Id, PriceBookEntryId, UnitPrice, Quantity, MX_SB_VTS_Rotura_Cristales__c,
                                        MX_SB_VTS_Proteccion_Sismo__c, MX_WB_Descuento_con_cupones__c,
                                        MX_SB_VTS_Danos_Contenidos__c, MX_SB_VTS_Equipo_Electronico__c,
                                        MX_SB_VTS_Por_Robo__c, MX_SB_VTS_RespPrivada_Familiar__c,
                                        MX_SB_VTS_Precio_Anual__c, MX_SB_VTS_Frecuencia_de_Pago__c,
                                        MX_SB_VTS_Monto_Mensualidad__c, MX_SB_VTS_No_Pisos_Inmueble__c,
                                        MX_SB_VTS_Cercania_Mantos_Aquiferos__c, MX_SB_VTS_Piso_Habitado__c,
                                        MX_SB_VTS_Techo_Tabique_Ladrillo_Block__c, MX_SB_VTS_Muros_Tabique_Ladrillo_Block__c
                                        from QuoteLineItem where QuoteId =: presupuesto.Id];
        final List<QuoteLineItem> quoliToInsert = new List<QuoteLineItem>();
        if(lstQuoli.isEmpty() == false) {
            for(QuoteLineItem quoli : lstQuoli) {
                quoli=getQuoteInit(quoli, datosCotizacion);
                quoli.Quantity = lstQuoli[0].Quantity;
                quoliToInsert.add(quoli);
            }
        } else {
            QuoteLineItem quoli = new QuoteLineItem();
            quoli=getQuoteInit(quoli, datosCotizacion);
            quoli.QuoteId = presupuesto.Id;
            quoli.Quantity = 1;
            quoli.PriceBookEntryId = MX_SB_VTS_utilityQuote.getPricebookEntry(presupuesto, quoli, dataCot);
            quoliToInsert.add(quoli);
        }
        if(!quoliToInsert.isEmpty()) {
            try {
                Database.upsert(quoliToInsert);
            } catch(DmlException dmlEx) {
                throw new DmlException('Error: '+dmlEx);
            }
        }
    }

    /**
     * getQuoteInit Obtine el QuoteInit
     * @param	datosCotizacion	Datos de la cotización
     * @return	quoli	Datos de cotización
     */
    private static QuoteLineItem getQuoteInit(QuoteLineItem quoli, MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion) {
        quoli.MX_SB_VTS_Rotura_Cristales__c = datosCotizacion.tipoDeSeguro.roturaDeCristales;
        quoli.MX_SB_VTS_Proteccion_Sismo__c = datosCotizacion.tipoDeSeguro.conOSinSismo;
        quoli.MX_SB_VTS_Danos_Inmueble__c = datosCotizacion.tipoDeSeguro.danosInmueble;
        quoli.MX_SB_VTS_Danos_Contenidos__c = datosCotizacion.tipoDeSeguro.danosAContenidos;
        quoli.MX_SB_VTS_Equipo_Electronico__c = datosCotizacion.tipoDeSeguro.danosEquipoElectrico;
        quoli.MX_SB_VTS_Por_Robo__c = datosCotizacion.tipoDeSeguro.porRobo;
        quoli.MX_SB_VTS_RespPrivada_Familiar__c = datosCotizacion.tipoDeSeguro.responsabilidadPrivadaFamiliar;
        quoli.MX_SB_VTS_Precio_Anual__c = datosCotizacion.tipoDeSeguro.precioAnual;
        quoli.MX_SB_VTS_Frecuencia_de_Pago__c = getPaymentFreq(datosCotizacion);
        quoli.MX_SB_VTS_Monto_Mensualidad__c = datosCotizacion.datosPrecio.precioParcialidades;
        quoli.MX_SB_VTS_Casa_o_Departamento__c = datosCotizacion.datosAdicionales.casaODepartamento;
        quoli.MX_SB_VTS_No_Pisos_Inmueble__c = datosCotizacion.datosAdicionales.noPisosInmueble;
        quoli.MX_SB_VTS_Piso_Habitado__c = datosCotizacion.datosAdicionales.pisoHabitado;
        quoli.UnitPrice = Decimal.valueOf(datosCotizacion.datosPrecio.precioTotal);
        quoli.MX_WB_Descuento_con_cupones__c = String.isNotBlank(datosCotizacion.datosPrecio.cupon) ? 'Si': 'No';
        quoli.MX_SB_VTS_Cercania_Mantos_Aquiferos__c = MX_SB_VTS_utilityQuote.checkBooleanValues(datosCotizacion.datosAdicionales.cercaniaMantosAquiferos);
        quoli.MX_SB_VTS_Techo_Tabique_Ladrillo_Block__c = MX_SB_VTS_utilityQuote.checkBooleanValues(datosCotizacion.datosAdicionales.techoTabiqueLadrilloBlock);
        quoli.MX_SB_VTS_Muros_Tabique_Ladrillo_Block__c = MX_SB_VTS_utilityQuote.checkBooleanValues(datosCotizacion.datosAdicionales.murosTabiqueLadrilloBlock);
        return quoli;
    }

    /**
     * getPaymentFreq Obtine el pago
     * @param	datosCotizacion	Datos de la cotización
     * @return	selOption	Opción de tipo de pago
     */
    private static String getPaymentFreq(MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion) {
        String selOption;
        if(String.isNotBlank(datosCotizacion.tipoDeSeguro.frequenciaPago)) {
            selOption = datosCotizacion.tipoDeseguro.frequenciaPago;
        } else {
            switch on datosCotizacion.tipoDeSeguro.cantidadDePagos {
                when '1' {
                    selOption = 'Anual';
                }
                when '2' {
                    selOption = 'Semestral';
                }
                when '4' {
                    selOption = 'Trimestral';
                }
                when '12' {
                    selOption = 'Mensual';
                }
            }
        }
        return selOption;
    }

    /**
     * datosCotizacion Datos de la cotización
     * @param	response	Obtiene un response
     * @return	jsonBody	Regresa un json
     */
    public static MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion(String response) {
        MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion returnedData = MX_SB_VTS_JSONParser.datosCotizacion(response);
        return returnedData;
    }
}
