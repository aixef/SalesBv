/**
 * @File Name          : MX_SB_VTS_rtwCotFillData.cls
 * @Description        : 
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              : 
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 31/5/2019 9:05:30
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    30/5/2019 11:08:34   Eduardo Hernández Cuamatzi     Initial Version
**/
public with sharing class MX_SB_VTS_rtwCotFillData {
    
    /**
     * MX_SB_VTS_rtwCotFillData Constructor
     * @return   Corrección Singleton
     */
    private MX_SB_VTS_rtwCotFillData() {} //NOSONAR

    /**
     * fillBeneficiarioRTC description
     * @param  aseguradoOriginal aseguradoOriginal description
     * @return                   return description
     */
    public static infoCompbeneficiario fillBeneficiarioRTC(infoCompbeneficiario objinfoCompbeneficiario, Account aseguradoOriginal) {
        objinfoCompbeneficiario.fechaNacimiento =  validHappyDate(aseguradoOriginal.PersonBirthdate);
        objinfoCompbeneficiario.edad = validAge(Integer.valueOf(aseguradoOriginal.edad__c));
        objinfoCompbeneficiario.sexoDelConductor = aseguradoOriginal.Genero__c;
        objinfoCompbeneficiario.rfc = aseguradoOriginal.RFC__c;                   
        objinfoCompbeneficiario.origen = aseguradoOriginal.AccountSource;
        objinfoCompbeneficiario.ciudad = aseguradoOriginal.BillingCity;
        objinfoCompbeneficiario.estado = aseguradoOriginal.BillingState;
        objinfoCompbeneficiario.pais = aseguradoOriginal.BillingCountry;
        objinfoCompbeneficiario.delegacion = aseguradoOriginal.Delegacion__c;
        objinfoCompbeneficiario.nacionalidad = aseguradoOriginal.Nacionalidad__c;
        objinfoCompbeneficiario.profesion = aseguradoOriginal.Profesion__c;
        objinfoCompbeneficiario.colonia = aseguradoOriginal.Colonia__c;
        objinfoCompbeneficiario.calleOAvenida = aseguradoOriginal.BillingStreet;
        objinfoCompbeneficiario.codigoPostal = aseguradoOriginal.BillingPostalCode;
        objinfoCompbeneficiario.numeroExterior = aseguradoOriginal.Numero_Exterior__c;
        objinfoCompbeneficiario.numeroInterior = aseguradoOriginal.Numero_Interior__c;
        return objinfoCompbeneficiario;
    }

    /**
     * validHappyDate description
     * @param  dateStr dateStr description
     * @return         return description
     */
    public static String validHappyDate (Date dateStr) {
        String valdate = '';
        if(String.isNotBlank(String.valueOf(dateStr))) {
            valdate =String.valueOf(dateStr);
        }
        return valdate;
    }

    /**
     * validAge description
     * @param  ageDate ageDate description
     * @return         return description
     */
    public static String validAge(Integer ageDate) {
        String finalAge = '';
        if(String.isNotBlank(String.valueOf(ageDate))) {
            finalAge = String.valueOf(ageDate);
        }
        return finalAge;
    }

    /**
     * validEmptyStr description
     * @param  textVal textVal description
     * @return         return description
     */
    public static String validEmptyStr (String textVal) {
        String finalStr = '';
        if(String.isNotBlank(textVal)) {
            finalStr = textVal;
        }
        return finalStr;
    }

    /**
     * validOppsAccount description
     * @param  accountFor     accountFor description
     * @param  finalNuAccount finalNuAccount description
     * @param  reqCot         reqCot description
     * @return                return description
     */
    public static Account validOppsAccount (Account accountFor, Account finalNuAccount, reqCotizacion reqCot) {
        Account finalAccount = new Account();
        if(accountFor.Opportunities.isEmpty()) {
            finalAccount.Id = reqCot.cliente;
        } else {
            finalAccount = finalNuAccount;
        }
        return finalAccount;
    }
}