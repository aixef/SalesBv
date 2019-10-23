/**-------------------------------------------------------------------------
* Nombre: MX_SB_VTS_rtwCotizacion_ext
* @author Julio Medellin
* Proyecto: MW SB VTS - BBVA
* Descripción : Clase extensión  de rtwCotizacion
* --------------------------------------------------------------------------
*                         Fecha           Autor                   Descripción
* -------------------------------------------------------------------
* @version 1.0           02/05/2019      Julio Medellin           Divide funciones y propíedades de la clase rtwCotizacion
* --------------------------------------------------------------------------*/ 
public virtual with sharing class MX_SB_VTS_rtwCotizacion_ext {//NOSONAR
    /*Variabale cuentapara nulos*/
    public static final account accountnull  = null;
    /*Variabale para nulos*/
    public static final id idnull  = null;
    /*Variabale para vacios*/
    public static final string stringEmpty  = '';
    /*Variabale para retener datos del cliente*/
    public static Account contratante = new Account();//NOSONAR
    /*Variabale para retener id global*/
    public  static String Idglobalcontratante= '';//NOSONAR

    /**
     * upsertCotiza description
     * @param  cotizacion cotizacion description
     * @return            return description
     */
    public static List<resSFDC> upsertCotiza( reqCotizacion cotizacion) {
        final List<resSFDC> lrSFDC = new List<resSFDC>(); 
        final resSFDC rSFDC = new resSFDC();
        rSFDC.error = System.Label.MX_SB_VTS_ERRORUpsert_LBL;
        String idOpp = null;
        String sMsn = '';
        Boolean blRta = true;
        Boolean bActDatosCte = true;
        String sIdContratante;
        final Account cteContratante = new Account();
        final Account asegurado = new Account();
        final Account aseguradoOriginal = new Account();
        infoCompbeneficiario objinfoCompbeneficiario = new infoCompbeneficiario();
        try {
            sMsn = System.Label.MX_SB_VTS_MSG1rtwCotizacion_LBL + cotizacion + '. ';
            orderIf(cotizacion,sIdContratante,cteContratante,aseguradoOriginal,objinfoCompbeneficiario,bActDatosCte,asegurado);
            sIdContratante=Idglobalcontratante;
            final List<Opportunity> lstOpp = [ SELECT Id, AccountId,Account.Name,Account.billingState, LeadSource FROM Opportunity WHERE FolioCotizacion__c =: cotizacion.folioDeCotizacion OR id =: cotizacion.idOportunidadComercial ];
            idOpp = rtwCotizacion.fnUpsertOportunidad ( cotizacion, lstOpp.isEmpty() == false ? lstOpp[0].Id : idnull, sIdContratante, objinfoCompbeneficiario,cotizacion.producto);          
            if ( idOpp.contains( '-' ) ) {
                rSFDC.message = System.Label.MX_SB_VTS_ErrorCotizacion_LBL + idOpp.substring( idOpp.indexOf( '-' ) + 1, idOpp.length() );
                sMsn += rSFDC.message + ' : ' + idOpp.substring( idOpp.indexOf( '-' )+1, idOpp.length() );
                rSFDC.id = idOpp.substring( 0, idOpp.indexOf( '-' ) );
            } else {
                rSFDC.message = System.Label.MX_SB_VTS_CotizadorExito_LBL+idOpp;
                sMsn += rSFDC.message;
                rSFDC.id = idOpp;
            }
            lrSFDC.add( rSFDC );
        } catch( Exception ex ) {
            rSFDC.message = System.Label.MX_SB_VTS_MSGERROR2_LBL + ex.getMessage() + System.Label.MX_SB_VTS_CAUSA_LBL + ex.getCause() + System.Label.MX_SB_VTS_LINEA_LBL + ex.getLineNumber();
            sMsn += rSFDC.message;
            blRta = false;
            rSFDC.id = idnull;
            lrSFDC.add( rSFDC );
        }
        WB_CrearLog_cls.fnCrearLog ( sMsn, System.Label.MX_SB_VTS_RTWCotizacion_LBL, blRta );
        return lrSFDC;
    }

    /**
     * orderIf description
     * @param  cotizacion              cotizacion request
     * @param  sIdContratante          sIdContratante Id contratante
     * @param  cteContratante          cteContratante cuenta Contratante
     * @param  aseguradoOriginal       aseguradoOriginal datos Asegurado
     * @param  objinfoCompbeneficiario objinfoCompbeneficiario datos beneficiario
     * @param  bActDatosCte            bActDatosCte Si tiene datos Cliente 
     * @param  asegurado               asegurado Datos asegurado request
     */
    private static void orderIf(reqCotizacion cotizacion,String sIdContratante, Account cteContratante, Account aseguradoOriginal, infoCompbeneficiario objinfoCompbeneficiario,Boolean bActDatosCte,Account asegurado) {
        if ( System.label.MX_SB_VTS_NO_LBL.equals(cotizacion.laPersonaQueAdquiereLaPolizaEsElContratante) ) { 
            cotizaContratante(cotizacion,sIdContratante,cteContratante,aseguradoOriginal,objinfoCompbeneficiario,bActDatosCte, asegurado);  
        } else if ( cotizacion.laPersonaQueAdquiereLaPolizaEsElContratante.Equals(System.Label.MX_SB_VTS_SI_LBL)) {       
            upsertCotiza3(cotizacion,sIdContratante,cteContratante,aseguradoOriginal,objinfoCompbeneficiario);
        }
    }

    /**
     * getcteContratante recupera datos contratante
     * @param  gcteContratante gcteContratante Cuenta Contratante
     * @param  cotizacion      cotizacion request
     * @param  bActDatosCte    bActDatosCte si se tienen datos Contratante
     * @return                 return Datos del contratante
     */
    private static account getcteContratante(account gcteContratante,reqCotizacion cotizacion, boolean bActDatosCte) {
        final account cteContratante= gcteContratante;
        if (bActDatosCte || Test.isRunningTest()) {
            cteContratante.FirstName = cotizacion.nombreDelContratante.length() > 40? cotizacion.nombreDelContratante.subString(0, 40) : cotizacion.nombreDelContratante;
            cteContratante.LastName = cotizacion.apellidoPaternoContratante + ' ' + cotizacion.apellidoMaternoContratante;
            cteContratante.PersonEmail = cotizacion.correoElectronicoContratante;
            cteContratante.Correo_Electronico__c = cotizacion.correoElectronicoContratante;
        }
        return cteContratante;
    }

    /**
     * upsertCotiza3 función auxiliar para upsertCot
     * @param  cotizacionret           request Cotizacion
     * @param  sIdContratanteret       Id del contratante
     * @param  cteContratanteret       cuenta contratante
     * @param  aseguradoOriginalret    Aseguro Original
     * @param  objinfoCompbeneficiario objinfoCompbeneficiario description
     */
    private static void upsertCotiza3( reqCotizacion cotizacionret,String sIdContratanteret, Account cteContratanteret, Account aseguradoOriginalret, infoCompbeneficiario objinfoCompbeneficiario) {
        Account aseguradoOriginal = aseguradoOriginalret;
        final reqCotizacion cotizacion = cotizacionret;
        String sIdContratante=sIdContratanteret;
        Account cteContratante=cteContratanteret; //NOSONAR
        final String sEmailCliente;
        if ( cotizacion.estatus.Equals(System.Label.MX_SB_VTS_FORMALIZADA_LBL) ) {
            for (Account cliente : [SELECT id, Correo_Electronico__c FROM Account WHERE id =: cotizacion.cliente ] ) {
                sEmailCliente = cliente.Correo_Electronico__c;
            }
        }
        if ( String.isBlank( sEmailCliente ) ) {
            sIdContratante = cotizacion.cliente;
            for ( Account cliente : [ SELECT id, Name, Correo_Electronico__c, isPersonAccount, PersonBirthdate, FirstName, LastName, PHONE,
                edad__c, Genero__c, RFC__c, Nacionalidad__c, Profesion__c, Colonia__c, BillingPostalCode,
                Numero_Exterior__c, Numero_Interior__c, AccountSource, BillingCity, BillingState, BillingCountry,
                BillingStreet, Delegacion__c FROM Account WHERE id =: cotizacion.cliente ] ) {
                    sIdContratante = cliente.id;
                    cteContratante = new Account( id = cliente.id );
                    aseguradoOriginal = cliente;
                }
        } else {
            for ( Account cliente : [ SELECT id, Name, Correo_Electronico__c, isPersonAccount, PersonBirthdate, FirstName, LastName, PHONE,
                edad__c, Genero__c, RFC__c, Nacionalidad__c, Profesion__c, Colonia__c, BillingPostalCode,
                Numero_Exterior__c, Numero_Interior__c, AccountSource, BillingCity, BillingState, BillingCountry,
                BillingStreet, Delegacion__c FROM Account WHERE Correo_Electronico__c =: sEmailCliente ] ) {
                    sIdContratante = cliente.id;
                    cteContratante = new Account( id = cliente.id );
                    aseguradoOriginal = cliente;
                    contratante = cliente;
                }
        }
        cotizacion.nombreDelContratante = aseguradoOriginal.FirstName;
        cotizacion.apellidoPaternoContratante = aseguradoOriginal.LastName;
        cotizacion.apellidoMaternoContratante = stringEmpty;
        cotizacion.correoElectronicoContratante = MX_SB_VTS_rtwCotFillData.validEmptyStr(aseguradoOriginal.Correo_Electronico__c);
        MX_SB_VTS_rtwCotFillData.fillBeneficiarioRTC(objinfoCompbeneficiario, aseguradoOriginal);
        Idglobalcontratante=sIdContratante;
    }

    /**
     * cotizaContratante función auxiliar para upsertCot
     * @param  cotizacionret           request Cotizacion
     * @param  sIdContratanteret       Id del contratante
     * @param  cteContratanteret       cuenta contratante
     */
    private static void cotizaContratante( reqCotizacion cotizacionret,String sIdContratanteret, Account cteContratanteret, Account aseguradoOriginalret, infoCompbeneficiario objinfoCompbeneficiario,Boolean bActDatosCteret,Account Aseguradoret) {
        Account aseguradoOriginal= aseguradoOriginalret;
        final reqCotizacion cotizacion = cotizacionret;
        String sIdContratante=sIdContratanteret;
        Account cteContratante=cteContratanteret;        
        Boolean bActDatosCte=bActDatosCteret;
        final Account asegurado= Aseguradoret;
        
        for (Account cliente : [ SELECT id, Name, Correo_Electronico__c, isPersonAccount, PersonBirthdate, FirstName, LastName, PHONE, edad__c, Genero__c, 
        RFC__c, Nacionalidad__c, Profesion__c, Colonia__c, BillingPostalCode, Numero_Exterior__c, Numero_Interior__c, AccountSource,
        BillingCity, BillingState, BillingCountry, BillingStreet, Delegacion__c, ( SELECT apellidoMaternoContratante__c, apellidoPaternoContratante__c, nombreDelContratante__c, telefonoCelularContratante__c, correoElectronicoContratante__c, Estatus__c
        FROM Opportunities WHERE Estatus__c = : System.Label.MX_SB_VTS_STATUSEMITIDA_LBL ) FROM Account WHERE Correo_Electronico__c =: cotizacion.correoElectronicoContratante ]) {
            sIdContratante = cliente.id;
            contratante = cliente;
            cteContratante = new Account( id = cliente.id );
            asegurado.id = cliente.id;
            bActDatosCte = cliente.Opportunities.isEmpty()==false?false:true;  
        }
        if ( String.isNotBlank( sIdContratante ) ) {
            cteContratante= getcteContratante(cteContratante,cotizacion,bActDatosCte);
            cteContratante.Phone = cotizacion.telefonoCelularContratante;
            Account delBene;
            for ( Account cliente : [ SELECT id, Name, Correo_Electronico__c, isPersonAccount, PersonBirthdate, FirstName, LastName, PHONE,
                edad__c, Genero__c, RFC__c, Nacionalidad__c, Profesion__c, Colonia__c, BillingPostalCode, 
                Numero_Exterior__c, Numero_Interior__c, AccountSource, BillingCity, BillingState, BillingCountry,
                BillingStreet, Delegacion__c, (SELECT ID FROM Opportunities)  FROM Account
                WHERE id =: cotizacion.cliente ] ) {
                    aseguradoOriginal = cliente;
                    contratante = cliente;
                    delBene = MX_SB_VTS_rtwCotFillData.validOppsAccount(cliente, accountnull, cotizacion);
                                    }
            cotizacion.nombreDelContratante = aseguradoOriginal.FirstName;
            cotizacion.apellidoPaternoContratante = aseguradoOriginal.LastName;
            cotizacion.apellidoMaternoContratante = stringEmpty;
            cotizacion.correoElectronicoContratante = MX_SB_VTS_rtwCotFillData.validEmptyStr(aseguradoOriginal.Correo_Electronico__c);
            cotizacion.telefonoCelularContratante = aseguradoOriginal.Phone;
            MX_SB_VTS_rtwCotFillData.fillBeneficiarioRTC(objinfoCompbeneficiario, aseguradoOriginal);
            update cteContratante;
            if ( String.isNotBlank(delBene.Id) ) {
                delete delBene;
            }
        }
        Idglobalcontratante=sIdContratante;
        upsertCotizaA(cotizacion,sIdContratante,cteContratante,aseguradoOriginal,objinfoCompbeneficiario);
    }

    /**
     * cotizaContratante función auxiliar para upsertCot
     * @param  cotizacionret           request Cotizacion
     * @param  sIdContratanteret       Id del contratante
     * @param  cteContratanteret       cuenta contratante
     * @param  aseguradoOriginalret    Aseguro Original
     * @param  objinfoCompbeneficiario objinfoCompbeneficiario
     */
    private static void upsertCotizaA( reqCotizacion cotizacionret,String sIdContratanteret, Account cteContratanteret, Account aseguradoOriginalret, infoCompbeneficiario objinfoCompbeneficiario) {
        Account aseguradoOriginal= aseguradoOriginalret;
        final reqCotizacion cotizacion = cotizacionret;
        String sIdContratante=sIdContratanteret;
        Account cteContratante=cteContratanteret; 
        
        if ( String.isBlank( sIdContratante ) ) {
            for ( Account cliente : [SELECT id, Name, Correo_Electronico__c, isPersonAccount, PersonBirthdate, FirstName, LastName, PHONE,
                edad__c, Genero__c, RFC__c, Nacionalidad__c, Profesion__c, Colonia__c, BillingPostalCode,
                Numero_Exterior__c, Numero_Interior__c, AccountSource, BillingCity, BillingState, BillingCountry,
                BillingStreet, Delegacion__c FROM Account WHERE id =: cotizacion.cliente ] ) {
                    sIdContratante = cliente.id;
                    cteContratante = new Account( id = cliente.id );
                    aseguradoOriginal = cliente;
                    contratante = cliente;
                }
            cteContratante.FirstName = cotizacion.nombreDelContratante.length() > 40 ? cotizacion.nombreDelContratante.subString(0, 40) : cotizacion.nombreDelContratante;
            cteContratante.LastName = cotizacion.apellidoPaternoContratante + ' ' + cotizacion.apellidoMaternoContratante;
            cteContratante.PersonEmail = cotizacion.correoElectronicoContratante;
            cteContratante.Correo_Electronico__c = cotizacion.correoElectronicoContratante;
            cteContratante.Phone = cotizacion.telefonoCelularContratante;
            cotizacion.nombreDelContratante = aseguradoOriginal.FirstName;
            cotizacion.apellidoPaternoContratante = aseguradoOriginal.LastName;
            cotizacion.apellidoMaternoContratante = stringEmpty;
            cotizacion.correoElectronicoContratante = MX_SB_VTS_rtwCotFillData.validEmptyStr(aseguradoOriginal.Correo_Electronico__c);
            cotizacion.telefonoCelularContratante = aseguradoOriginal.Phone;
            MX_SB_VTS_rtwCotFillData.fillBeneficiarioRTC(objinfoCompbeneficiario,aseguradoOriginal);
            update cteContratante;
            Idglobalcontratante = sIdContratante;
        }  
    }

    /**
     * fillPresuQuote Asigna valores dinámicos
     * @param  presupuesto objeto presupuesto
     * @param  cotizacion  request cotización
     * @param  fieldConf   mapa de campos dinámicos
     */
    public static void fillPresuQuote(Quote presupuesto, reqCotizacion cotizacion, Map<string,String> fieldConf) {
        String json_cotizacion = Json.serialize(cotizacion);
        Map<String, Object> fieldMap= (Map<String, Object>)JSON.deserializeUntyped(json_cotizacion);
        for(string value :fieldMap.keyset()) {           
            if(fieldConf.get(value)!=null) {
                presupuesto.put(fieldConf.get(value),fieldMap.get(value));
            }
        }
    }

    /**
     * fillPresuOpp Asigna valores dinámicos
     * @param  presupuesto objeto presupuesto
     * @param  cotizacion  objeto cotización
     * @param  fieldConf2  mapa de campos dinámicos
     */
    public static void fillPresuOpp(Quote presupuesto, Opportunity objCot, Map<string,String> fieldConf2) {
        String json_objCot = Json.serialize(objCot);
        Map<String, Object> fieldMap2= (Map<String, Object>)JSON.deserializeUntyped(json_objCot);
        for(string value :fieldMap2.keyset()) {
            if(fieldConf2.get(value)!=null) {
                presupuesto.put(fieldConf2.get(value),fieldMap2.get(value));
            }            
        }
    }

    /**
     * fillPresuAccount Asigna valores dinámicos
     * @param  presupuesto objeto presupuesto
     * @param  objCot      objeto cotización
     * @param  fieldConf3  mapa de campos dinámicos
     */
    public static void fillPresuAccount(Quote presupuesto, Opportunity objCot, Map<string,String> fieldConf3) {
        Account obAcc = objCot.Account;
        String json_objCotAccount = Json.serialize(obAcc);
        Map<String, Object> fieldMap3= (Map<String, Object>)JSON.deserializeUntyped(json_objCotAccount);
        for(string value :fieldMap3.keyset()) {
            if(fieldConf3.get(value)!=null) {
                presupuesto.put(fieldConf3.get(value),fieldMap3.get(value));
            }
        }
    }
}