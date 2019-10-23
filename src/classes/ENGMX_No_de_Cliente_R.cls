/**
*Desarrollado por:       BBVA
*Autor:                  Francisco Javier Bueno
*Proyecto:               Salesforce Engineering
*Descripción:            Clase que reduce a los dos primeros digitos el No_de_cliente__c para la generacion de reportes.
*Clase de Test:          ENGMX_No_de_Cliente_R_tst
*Cambios (Versiones)
*-------------------------------------------------------------------------------
*No.         Fecha           Autor                           Descripción
*1.0        21/08/2018    Francisco Bueno                      Creacion
*1.1        31/12/2018    Francisco Bueno       No_de_Cliente__c Conversión a Mayúsculas
**/

public without sharing class ENGMX_No_de_Cliente_R {
    private ENGMX_No_de_Cliente_R() {
    }

    /**method was previously named 'ENGMX_No_de_Cliente_R' */
	public static void fixClientNumber(List<Account> newAccounts) {
        for(Account NCR : newAccounts) {
            if(String.isNotBlank(NCR.No_de_cliente__c) && NCR.No_de_cliente__c.length() > 1) {
                NCR.No_de_cliente__C = NCR.No_de_cliente__c.toUppercase('es_MX');
                //NCR.ENGMX_txt_No_de_Cliente_R__c = NCR.No_de_cliente__c.substring(0,2);
            } else {
                //NCR.ENGMX_txt_No_de_Cliente_R__c = null;
            }
		}
	}
}