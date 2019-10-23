/**
 * @File Name          : MX_SB_VTS_Vida_Service.cls
 * @Description        :
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              :
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 6/6/2019 19:58:18
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    20/5/2019 10:42:28   Eduardo Hernández Cuamatzi     Initial Version
 * 1..1   29/5/2019            Jaime Terrats                Add account validation
 * 1.2    19/06/2019           Jaime Terrats                Add validation for opp closed win
**/
@RestResource(urlMapping='/Vida/*')
global without sharing class MX_SB_VTS_Vida_Service extends MX_SB_VTS_WrapperVida { // NOSONAR

    private MX_SB_VTS_Vida_Service() { // NOSONAR
    }

    /*
    * Variable para status de cotizacion
    */
    private static final String EMITIDA='Emitida', CREADA='Creada';
    /**
     * cotizarSeguroVida description
     * @param  datosCotizacion datosCotizacion description
     * @return                 return description
     */
    @HttpPost
    global static List<MX_SB_VTS_ResponseSFDC> cotizarSeguroVida(MX_SB_VTS_DatosCotizacion datosCotizacion) {
        final List<MX_SB_VTS_ResponseSFDC> resSFDC = new List<MX_SB_VTS_ResponseSFDC>();
        MX_SB_VTS_ResponseSFDC res = new MX_SB_VTS_ResponseSFDC();

        final List<Quote> validaFolioCot = [Select Id, Name from  Quote where MX_SB_VTS_Folio_Cotizacion__c =: datosCotizacion.datosIniciales.folioCotizacion];
        res.error = '';
        res.message = '';
        res.recordId = '';
        if(validaFolioCot.isEmpty() == false) {
            List<Account> lstAcc = [Select Id from Account where PersonEmail =: datosCotizacion.datosCliente.Email];
            if(lstAcc.isEmpty() == false) {
                upsertAccount(datosCotizacion);
                res.message += ' Cuenta localizada: ' + lstAcc[0].id;
                resSFDC.add(res);
            } else {
                res.message = 'Generando nuevo folio para el cliente';
                res.recordId += 'id de la cuenta: ' + upsertAccount(datosCotizacion);
                resSFDC.add(res);
            }
        } else {
            res.message = 'Generando nuevo folio para el cliente';
            res.recordId += 'id de la cuenta: ' + upsertAccount(datosCotizacion);
            resSFDC.add(res);
        }
        return resSFDC;
    }

     /**
     * upsertAccount Upsert a la cuenta
     * @param	datosCotizacion Datos e la cotización
     * @return	accsToUpsert	Regresa una lista
     */
    private static Id upsertAccount(MX_SB_VTS_DatosCotizacion datosCotizacion) {
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
            final Id accRT = Schema.SobjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
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
    private static Account accountInit(Account retorig, MX_SB_VTS_DatosCotizacion datosCotizacion) {
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

    /*
    * Method to upsert opportunity
    * @param account and datosCotizacion
    */
    private static void upsertOpportunity(Account acc, MX_SB_VTS_DatosCotizacion datosCotizacion) {
        // Upsert opportunity data
        final List<Opportunity> lstOpps = [Select Id, Name, StageName, FolioCotizacion__c,
                                    Reason__c, Producto__c, MX_SB_VTS_Aplica_Cierre__c
                                    from Opportunity where AccountId =: acc.Id
                                    and Producto__c =: datosCotizacion.datosIniciales.producto
                                    and Probability > 1 and Probability < 100 order by CreatedDate desc];
        final List<Opportunity> oppsToUpsert = new List<Opportunity>();

        if(lstOpps.isEmpty()) {
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
                    final Id inboundRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(System.label.MX_SB_VTS_Telemarketing_LBL).getRecordTypeId();
                    cotizacion.RecordTypeId = inboundRT;
                    cotizacion.LeadSource = 'Tracking web';
                }
                when 'outbound' {
                    final Id outboundRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('MX_WB_RT_Telemarketing').getRecordTypeId();
                    cotizacion.RecordTypeId = outboundRT;
                    cotizacion.LeadSource = 'Outbound TLMK';
                }
            }
            oppsToUpsert.add(cotizacion);
        } else {
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
    private static void upsertQuote(Opportunity opp, MX_SB_VTS_DatosCotizacion datosCotizacion) {
        // Upsert Quote data
        final List<Quote> lstQuote = [Select Id, Name, Status, MX_SB_VTS_Folio_Cotizacion__c, MX_SB_VTS_Numero_de_Poliza__c,
                                ShippingStreet, ShippingPostalCode, ShippingCity, ShippingState, OpportunityId,
                                ShippingCountry, MX_SB_VTS_Numero_Exterior__c, MX_SB_VTS_Numero_Interior__c
                                from Quote where MX_SB_VTS_Folio_Cotizacion__c =: datosCotizacion.datosIniciales.folioCotizacion];
        final List<Quote> quotesToUpsert = new List<Quote>();
        if(lstQuote.isEmpty() == false) {
            // check if should update Quote Data
            for(Quote presupuesto : lstQuote) {
                // if Folio Cotizacion is empety
                presupuesto.Name = presupuesto.MX_SB_VTS_Folio_Cotizacion__c + ' ' + opp.Name;
                presupuesto.MX_SB_VTS_Numero_de_Poliza__c =  datosCotizacion.datosIniciales.numeroPoliza;
                presupuesto.MX_SB_VTS_Movil_txt__c = datosCotizacion.datosCliente.celular;
                presupuesto.MX_SB_VTS_Email_txt__c = datosCotizacion.datosCliente.email;
                quotesToUpsert.add(quoteValidation(presupuesto, datosCotizacion, opp));
            }
        } else {
            final Quote presupuesto = new Quote();
            final Id famProductId = [Select MX_WB_FamiliaProductos__c from Product2 where Name =: datosCotizacion.datosIniciales.producto].MX_WB_FamiliaProductos__c;
            presupuesto.MX_SB_VTS_Folio_Cotizacion__c = datosCotizacion.datosIniciales.folioCotizacion;
            presupuesto.Name = presupuesto.MX_SB_VTS_Folio_Cotizacion__c + ' ' + opp.Name;
            presupuesto.OpportunityId = opp.Id;
            presupuesto.MX_SB_VTS_Familia_Productos__c = famProductId;
            presupuesto.MX_SB_VTS_Movil_txt__c = datosCotizacion.datosCliente.celular;
            presupuesto.MX_SB_VTS_Email_txt__c = datosCotizacion.datosCliente.email;
            quotesToUpsert.add(quoteValidation(presupuesto, datosCotizacion, opp));
        }

        if(!quotesToUpsert.isEmpty()) {
            try {
                Database.upsert(quotesToUpsert);
                upsertQuoteLineItem(quotesToUpsert[0], datosCotizacion);
                upsertBeneficiario(quotesToUpsert[0], datosCotizacion);
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
    private static Quote quoteValidation(Quote completar, MX_SB_VTS_DatosCotizacion datosCotizacion, Opportunity opp) {
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

    /*
    * upsertBeneficiario
    * @param presupuesto Id presupuesto
    * @param datosCotizacion
    */
    private static void upsertBeneficiario(Quote presupuesto, MX_SB_VTS_DatosCotizacion datosCotizacion) {
        final List<MX_SB_VTS_Beneficiario__c> lstBenef =  [Select Name From MX_SB_VTS_Beneficiario__c
                                                    where MX_SB_VTS_Quote__c =: presupuesto.Id];
        final List<MX_SB_VTS_Beneficiario__c> benefToUpsert = new List<MX_SB_VTS_Beneficiario__c>();
        if(lstBenef.isEmpty() == false) {
            for(MX_SB_VTS_Beneficiario__c beneficiario : lstBenef) {
                beneficiario = getBeneficiarioInit(beneficiario, datosCotizacion);
                benefToUpsert.add(beneficiario);
            }
        } else {
            MX_SB_VTS_Beneficiario__c beneficiario = new MX_SB_VTS_Beneficiario__c();
            beneficiario = getBeneficiarioInit(beneficiario, datosCotizacion);
            beneficiario.MX_SB_VTS_Quote__c = presupuesto.Id;
            benefToUpsert.add(beneficiario);
        }

        if(benefToUpsert.isEmpty() == false) {
            try {
                Database.upsert(benefToUpsert);
            } catch(DmlException dmlEx) {
                throw new DmlException('Fallo ' + dmlEx);
            }
        }
    }

    /**
    *  getBeneficiarioInit upsert a beneficiario
    */
    private static MX_SB_VTS_Beneficiario__c getBeneficiarioInit(MX_SB_VTS_Beneficiario__c beneficiario, MX_SB_VTS_DatosCotizacion datosCotizacion) {
        for(MX_SB_VTS_Beneficiarios benef: datosCotizacion.beneficiarios) {
            beneficiario.Name = benef.nombre;
            beneficiario.MX_SB_VTS_APaterno_Beneficiario__c = benef.apellidoPaterno;
            beneficiario.MX_SB_VTS_AMaterno_Beneficiario__c = benef.apellidoMaterno;
            beneficiario.MX_SB_VTS_Porcentaje__c = Decimal.valueOf(benef.procentaje);
            beneficiario.MX_SB_VTS_Parentesco__c = benef.parentesco;
        }
        return beneficiario;
    }

    /**
     * upsertQuoteLineItem Upsert a QuoteLineItem
     * @param	presupuesto Id presupuesto
     * @param	datosCotizacion	Datos de la cotización
     */
    private static void upsertQuoteLineItem(Quote presupuesto, MX_SB_VTS_DatosCotizacion datosCotizacion) {
        // Upsert Quote Line Item data
        final List<String> dataCot = new List<String>();
        dataCot.add([select Id from Product2 where Name =: datosCotizacion.datosIniciales.producto].Id);
        dataCot.add(datosCotizacion.datosPrecio.precioTotal);
        final List<QuoteLineItem> lstQuoli = [Select Id, PriceBookEntryId, UnitPrice, Quantity
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
    private static QuoteLineItem getQuoteInit(QuoteLineItem quoli, MX_SB_VTS_DatosCotizacion datosCotizacion) {
        quoli.MX_SB_VTS_Precio_Anual__c = datosCotizacion.tipoDeSeguroVida.precioAnual;
        quoli.MX_SB_VTS_Frecuencia_de_Pago__c = getPaymentFreq(datosCotizacion);
        quoli.MX_SB_VTS_Monto_Mensualidad__c = datosCotizacion.datosPrecio.precioParcialidades;
        quoli.UnitPrice = Decimal.valueOf(datosCotizacion.datosPrecio.precioTotal);
        quoli.MX_SB_VTS_Cancer_Tumores_Leucemia_Lupus__c = Boolean.valueOf(datosCotizacion.datosAdicionalesVida.cancerTumoresLeucemiaLupus);
        quoli.MX_SB_VTS_Aneurisma_Trombosis_Embolia__c = Boolean.valueOf(datosCotizacion.datosAdicionalesVida.aneurismaTrombosisEmbolia);
        quoli.MX_SB_VTS_EmficemaBronquitisTuberculosis__c = Boolean.valueOf(datosCotizacion.datosAdicionalesVida.emficemaBronquitisTuberculosis);
        quoli.MX_SB_VTS_Insuficiencias_Cirrosis_Hepati__c = Boolean.valueOf(datosCotizacion.datosAdicionalesVida.insuficienciasCirrosisHepatitis);
        quoli.MX_SB_VTS_Total_Fallecimiento__c = Decimal.valueOf(datosCotizacion.tipoDeSeguroVida.totalFallecimiento);
        quoli.MX_SB_VTS_Total_Gastos_Funerarios__c = Decimal.valueOf(datosCotizacion.tipoDeSeguroVida.totalGastosFunerarios);
        quoli.MX_SB_VTS_Total_Muerte_Accidental__c = Decimal.valueOf(datosCotizacion.tipoDeSeguroVida.totalMuerteAccidental);
        quoli.MX_SB_VTS_Plan__c = datosCotizacion.tipoDeSeguroVida.tipoPlan;
        return quoli;
    }

    /**
     * getPaymentFreq Obtine el pago
     * @param	datosCotizacion	Datos de la cotización
     * @return	selOption	Opción de tipo de pago
     */
    private static String getPaymentFreq(MX_SB_VTS_DatosCotizacion datosCotizacion) {
        String selOption;
        if(String.isNotBlank(datosCotizacion.tipoDeSeguroVida.frequenciaPago)) {
            selOption = datosCotizacion.tipoDeseguroVida.frequenciaPago;
        } else {
            switch on datosCotizacion.tipoDeSeguroVida.cantidadDePagos {
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
}
