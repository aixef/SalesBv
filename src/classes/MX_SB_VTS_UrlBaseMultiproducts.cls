/**
 * @File Name          : MX_SB_VTS_UrlBaseMultiproducts.cls
 * @Description        :
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              :
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 4/6/2019 10:22:28
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    3/6/2019 18:58:56   Eduardo Hernández Cuamatzi     Initial Version
 * 1.1    19/7/2019           Jaime Terrats             Se agrega construccion de URLS
**/
public without sharing class MX_SB_VTS_UrlBaseMultiproducts {

    /**
     * urlBaseHogar description
     * @param  quoteData     Datos de cotización
     * @param  accountData   Datos de cuenta
     * @param  inmutableVals valores fijos para url
     * @param  quoliData     Datos partida de cotización
     * @return               url con parámetros
     */
    public static String urlBaseHogar(Quote quoteData, Account accountData, Map<String, String> inmutableVals, QuoteLineItem quoliData) {
        String fianlUrl = '';
        fianlUrl = '&folioCot='+ MX_SB_VTS_rtwCotFillData.validEmptyStr(quoteData.MX_SB_VTS_Folio_Cotizacion__c);
        fianlUrl += '&nombreCot=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(accountData.FirstName);
        fianlUrl += '&apCot=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(accountData.LastName);
        fianlUrl += '&amCot=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(accountData.ApellidoMaterno__c);
        fianlUrl += '&curp=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(accountData.RFC__c);
        fianlUrl += '&telCot=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(quoteData.MX_SB_VTS_Movil_txt__c);
        fianlUrl += '&fechaNCot=' + formatDate(accountData.PersonBirthdate);
        fianlUrl += '&totalAse=' + quoteData.TotalPrice;
        fianlUrl += '&plan=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(quoliData.MX_SB_VTS_Plan__c);
        fianlUrl += '&tipoPago=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(quoliData.MX_SB_VTS_Frecuencia_de_Pago__c);
        fianlUrl += '&tipoEd=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(quoliData.MX_SB_VTS_Casa_o_Departamento__c);
        fianlUrl += '&totalP=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(quoliData.MX_SB_VTS_No_Pisos_Inmueble__c);
        fianlUrl += '&pHabitado=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(quoliData.MX_SB_VTS_Piso_Habitado__c);
        fianlUrl += '&cSismo=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(quoliData.MX_SB_VTS_Proteccion_Sismo__c);
        fianlUrl += '&mantosA=' + quoliData.MX_SB_VTS_Cercania_Mantos_Aquiferos__c;
        fianlUrl += '&murosC=' + quoliData.MX_SB_VTS_Muros_Tabique_Ladrillo_Block__c;
        fianlUrl += '&concretoA=' + quoliData.MX_SB_VTS_Techo_Tabique_Ladrillo_Block__c;
        fianlUrl += '&generoCot=' + validateGender(accountData.Genero__c);
        fianlUrl += '&email=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(quoteData.MX_SB_VTS_Email_txt__c);
        fianlUrl += '&postalCot=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(quoteData.ShippingPostalCode);
        fianlUrl += '&dirCot=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(quoteData.MX_SB_VTS_Colonia__c);
        fianlUrl += '&noExt=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(quoteData.MX_SB_VTS_Numero_Exterior__c);
        fianlUrl += '&noInt=' + MX_SB_VTS_rtwCotFillData.validEmptyStr(quoteData.MX_SB_VTS_Numero_Interior__c);
        return fianlUrl;
    }

    /**
     * urlBaseHogar description
     * @param  quoteData     Datos de cotización
     * @param  accountData   Datos de cuenta
     * @param  inmutableVals valores fijos para url
     * @param  quoliData     Datos partida de cotización
     * @return               url con parámetros
     */
    public static String urlBaseVida(Quote quoteData, Account accountData, Map<String, String> inmutableVals, QuoteLineItem quoliData, List<MX_SB_VTS_Beneficiario__c> beneficiarios) {
        String fianlUrl = '';
        Integer i = 0;
        fianlUrl = '&folioCot=' + quoteData.MX_SB_VTS_Folio_Cotizacion__c;
        fianlUrl += '&nombreCot=' + accountData.FirstName;
        fianlUrl += '&apCot=' + accountData.LastName;
        fianlUrl += '&amCot=' + accountData.ApellidoMaterno__c;
        fianlUrl += '&curp=' + accountData.RFC__c;
        fianlUrl += '&telCot=' + quoteData.MX_SB_VTS_Movil_txt__c;
        fianlUrl += '&fechaNCot=' + formatDate(accountData.PersonBirthdate);
        fianlUrl += '&totalAse=' + quoteData.TotalPrice;
        fianlUrl += '&plan=' + quoliData.MX_SB_VTS_Plan__c;
        fianlUrl += '&Cancerigenas=' + quoliData.MX_SB_VTS_Cancer_Tumores_Leucemia_Lupus__c;
        fianlUrl += '&cardioVascular=' + quoliData.MX_SB_VTS_Aneurisma_Trombosis_Embolia__c;
        fianlUrl += '&respiratorias=' + quoliData.MX_SB_VTS_EmficemaBronquitisTuberculosis__c;
        fianlUrl += '&hepaticas=' + quoliData.MX_SB_VTS_Insuficiencias_Cirrosis_Hepati__c;
        fianlUrl += '&generoCot=' + validateGender(accountData.Genero__c);
        fianlUrl += '&tipoPago=' + quoliData.MX_SB_VTS_Frecuencia_de_Pago__c;
        fianlUrl += '&email=' + quoteData.MX_SB_VTS_Email_txt__c;
        fianlUrl += '&postalCot=' + quoteData.ShippingPostalCode;
        fianlUrl += '&dirCot=' + quoteData.ShippingStreet;
        fianlUrl += '&noExt=' + quoteData.MX_SB_VTS_Numero_Exterior__c;
        fianlUrl += '&noInt=' + quoteData.MX_SB_VTS_Numero_Interior__c;
        if(beneficiarios.size() > 0) {
            for(MX_SB_VTS_Beneficiario__c beneficiario: beneficiarios) {
                fianlUrl += '&numBene=' + i + 1;
                fianlUrl += '&nomBen' + i + '=' + beneficiario.Name;
                fianlUrl += '&apBen' + i +'='+ beneficiario.MX_SB_VTS_APaterno_Beneficiario__c;
                fianlUrl += '&amBen' + i  + '=' + beneficiario.MX_SB_VTS_AMaterno_Beneficiario__c;
                fianlUrl += '&parent' + i  + '=' + beneficiario.MX_SB_VTS_Parentesco__c;
                fianlUrl += '&porcen' + i  + '=' + beneficiario.MX_SB_VTS_Porcentaje__c;
                i++;
            }
        }
        return fianlUrl;
    }

    private static String validateGender(String gender) {
        String fixedValue = '';
        switch on gender {
            when 'Masculino' {
                fixedValue = 'M';
            }
            when 'Femenino' {
                fixedValue = 'F';
            }
        }

        return fixedValue;
    }

    /*
    * @param birthdate date time data type
    * returns dd/mm/yyyy date format as string
    */
    private static String formatDate(Datetime birthdate) {
        String formattedDate = '';
        if(String.isNotBlank(String.valueOf(birthDate))) {
            formattedDate = birthdate.formatGmt('dd/MM/yyyy');
        }
        return formattedDate;
    }
}