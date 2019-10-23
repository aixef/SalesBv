/**
 * @File Name          : MX_SB_VTS_Cotizador_ext.cls
 * @Description        : Extension para clase MX_WB_TM_Cotizador_cls
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              : BBVA
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 4/6/2019 16:35:08
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    27/5/2019 12:53:45   Eduardo Hernández Cuamatzi     Initial Version
 * 1.1    19/7/2019            Jaime Terrats                Se actualiza pase de parametros
**/
public without sharing class MX_SB_VTS_Cotizador_ext {

    /** Metadata Personalizada para URL Seguro Moto Bancomer **/
    static final String STR_ML_SMB = 'URLMSB';
    /** Metadata Personalizada para URL Seguro Fronterizo **/
    static final String STR_ML_SF = 'URLSFN';
    /** Metadata Personalizada para URL Auto Seguro Bancomer **/
    static final String STR_ML_ASD = 'URLASB';
    /** String para Datos de Usuario **/
    static String strDatosUsuario;
    /** String para Fecha **/
    static String strFechaMilisApex;
    /** String para Firma **/
    static String strFirmaMain;
    /** Inicialización **/
    static {
        strDatosUsuario = '';
        strFechaMilisApex = '';
        strFirmaMain = '';
    }

    /**
     * MX_SB_VTS_Cotizador_ext Constructor privado
     * @return   Evita singleton
     */
    private MX_SB_VTS_Cotizador_ext() { //NOSONAR

    }

    /**
    * Elabora el prefijo del URL con datos del Usuario y Firma Encriptada en MD5
    * @return String prefijo de URL generado
    **/
    public static String createUrlPrefix () {
        try {
            String strUsuario, strCanal, strSubCanal, strAgencia, strServicio, strUrlBegin;
            final User objUser = [ SELECT Id, Usuario__c, Canal__c, Sub_Canal__c, Agencia__c, Servicio__c FROM User WHERE Id =: UserInfo.getUserId() ];
            strFechaMilisApex = Utilities.fnGeneradorFechaMilis();
            strUsuario =validFieldUrl( objUser.Usuario__c );
            strCanal = validFieldUrl( objUser.Canal__c );
            strSubCanal = validFieldUrl( objUser.Sub_Canal__c );
            strAgencia = validFieldUrl( objUser.Agencia__c );
            strServicio = validFieldUrl( objUser.Servicio__c );
            strFirmaMain = Utilities.fnGeneradorMD5 ( strFechaMilisApex, strUsuario, strCanal, strSubCanal, strAgencia, strServicio );
            strDatosUsuario = '&usuario=' + strUsuario + '&servicio=' + strServicio + '&agencia=' + strAgencia + '&canal=' + strCanal + '&subcanal=' + strSubCanal;
            strUrlBegin = '?' + 'fechaMilis=' + strFechaMilisApex + strDatosUsuario + '&firma=' + strFirmaMain;
            return strUrlBegin;
        } catch ( QueryException quEx ) {
            throw new AuraHandledException(System.Label.MX_WB_ERROR+quEx);
        }
    }

    /**
    * Valida y crea el OpportunityLineItem y PricebookEntry
    * @param ID idOppor Oportunidad a asignar producto
    * @return boolean si pudo hacer el cambio o no
    **/
    public static String getMasterLabelValidation (ID idProd) {
        String strMasterLabel = '';
        String strProdName = [ SELECT Name FROM Product2 WHERE Id =: idProd ].Name;
        if ( String.isNotBlank( strProdName ) ) {
            strProdName = strProdName.touppercase( System.Label.MX_WB_CL_LocaleString );
            switch on strProdName {
                when 'SEGURO DE MOTO BANCOMER' {
                    strMasterLabel = STR_ML_SMB;
                }
                when 'SEGURO FRONTERIZO' {
                    strMasterLabel = STR_ML_SF;
                }
                when 'SEGURO DE AUTO FRONTERIZO BANCOMER' {
                    strMasterLabel = STR_ML_SF;
                }
                when 'SEGURO DE AUTO NACIONALIZADO' {
                    strMasterLabel = STR_ML_SF;
                }
                when 'AUTO SEGURO DINÁMICO' {
                    strMasterLabel = STR_ML_ASD;
                }
                when 'AUTO SEGURO DINAMICO' {
                    strMasterLabel = STR_ML_ASD;
                }
            }
        }
        return strMasterLabel;
    }

     /**
    * corretName description
    * @param  producto producto description
    * @return          return description
    */
    public static String correctName (String producto) {
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
     * validPostalCode Valida el código postal
     * @param  postalCode recibe el valor de un string
     * @return            Retorna un código postal
     */
    public static String validPostalCode (String postalCode, String postalCodeT) {
        String stringPostalCode = postalCode;
        stringPostalCode = String.isNotBlank(stringPostalCode) ? postalCode : postalCodeT;
        stringPostalCode = String.isNotBlank(stringPostalCode) ? stringPostalCode : '';
        return StringPostalCode;
    }

    /**
     * validFieldUrl Valida campos vacios
     * @param  valueEvalue valor a evaluar
     * @return            Retorna un valor String
     */
    public static String validFieldUrl (String valueEvalue) {
        String finalValue = '';
        if(String.isNotBlank(valueEvalue)) {
            finalValue = valueEvalue;
        }
        return finalValue;
    }

    /**
     * validOrigin valida origen
     * @param  origen  Origen LeadSource
     * @param  origenT Origen__c
     * @return         origen valido
     */
    public static String validOrigin (String origen, String origenT) {
        String finalOrigen = origen;
        finalOrigen = String.isNotBlank(finalOrigen) ? origen : origenT;
        finalOrigen = String.isNotBlank(finalOrigen) ? finalOrigen : '';
        return finalOrigen;
    }

    /**
     * crearURLSeguroHoVi description
     * @param  accountData Datos de cuenta
     * @param  quoteData   Datos de cotización
     * @param  strUrlBegin urlBase
     * @param  quoliData   Datos de partida de cotizacion
     * @return             retorna UrlCotizador
     */
    public static String crearURLSeguroHoVi (Account accountData, Quote quoteData, String strUrlBegin, QuoteLineItem quoliData, String strMasterLabel) {
        String urlSeg = '';
        final Map<String, String> valuesStr = new Map<String, String>();
        final String postalCode = MX_SB_VTS_Cotizador_ext.validPostalCode(String.valueOf(quoteData.BillingPostalCode), String.valueOf(accountData.BillingPostalCode));
        final boolean blFolio = String.isBlank(quoteData.MX_SB_VTS_Folio_Cotizacion__c) ? false : true;
        final URL_Auto_Seguro_Bancomer__mdt objMSB = [ SELECT DeveloperName, URL__c, tipoUsoVehiculoCot__c FROM URL_Auto_Seguro_Bancomer__mdt
         WHERE MasterLabel =: strMasterLabel];
        final String strTelfAseg = String.isNotBlank(quoteData.Phone) ? quoteData.Phone :'';
        final String strOrigen = MX_SB_VTS_Cotizador_ext.validOrigin(quoteData.Opportunity.LeadSource, quoteData.Opportunity.Origen__c);
        valuesStr.put('strOrigen', strOrigen);
        valuesStr.put('postalCode', postalCode);
        valuesStr.put('blFolio', String.valueOf(blFolio));
        valuesStr.put('strTelfAseg', strTelfAseg);
        switch on strMasterLabel {
            when 'URLHSB' {
                urlSeg = objMSB.URL__c + strUrlBegin +MX_SB_VTS_UrlBaseMultiproducts.urlBaseHogar(quoteData, accountData, valuesStr, quoliData)+ '#/paso1-datos-basicos';
            }
            when 'URLVSB' {
                final List<MX_SB_vTS_Beneficiario__c> beneficiarios = [select Name, MX_SB_VTS_APaterno_Beneficiario__c, MX_SB_VTS_AMaterno_Beneficiario__c, MX_SB_VTS_Parentesco__c, MX_SB_VTS_Porcentaje__c from MX_SB_vTS_Beneficiario__c where MX_SB_VTS_Quote__c =: quoteData.Id];
                urlSeg = objMSB.URL__c + strUrlBegin + MX_SB_VTS_UrlBaseMultiproducts.urlBaseVida(quoteData, accountData, valuesStr, quoliData, beneficiarios)+ objMSB.tipoUsoVehiculoCot__c + '#/paso1-datos-basicos';
            }
        }
        return urlSeg;
    }

    /**
    * Valida y crea el OpportunityLineItem y PricebookEntry
    * @param ID idOppor Oportunidad a asignar producto
    * @return boolean si pudo hacer el cambio o no
    **/
    public static String getMasterLabelHoVi (QuoteLineItem quoliData) {
        String strMasterLabel = '';
        String strProdName = [ SELECT Name FROM Product2 WHERE Id =: quoliData.Product2Id].Name;
        if ( String.isNotBlank( strProdName ) ) {
            strProdName = strProdName.touppercase( System.Label.MX_WB_CL_LocaleString );
            switch on strProdName {
                 when 'VIDA' {
                    strMasterLabel = System.Label.MX_SB_VTS_CustoMasterVida_LBL;
                }
                when 'HOGAR' {
                    strMasterLabel = System.Label.MX_SB_VTS_CustoMasterHogar_LBL;
                }
            }
        }
        return strMasterLabel;
    }
}
