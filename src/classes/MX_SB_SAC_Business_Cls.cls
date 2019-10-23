/*
----------------------------------------------------------
* Nombre: MX_SB_SAC_Business_Cls
* Autor Saúl González
* Proyecto: SB SAC - BBVA Bancomer
* Descripción : Clase con metódos reutilizables para el a, b, c de polizas
* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                   			Desripción<p />
* --------------------------------------------------------------------------------
* 1.0           11/06/2019     Saúl González	           		   	Creación
* 1.0           16/08/2019     Ing. Karen B. Sanchez Ruiz (KB)	    Corrección issues sonar
* 2.0           29/08/2019     José Luis Vargas Lara				Correccion issues sonar
* --------------------------------------------------------------------------------
*/

public without sharing class MX_SB_SAC_Business_Cls {//NOSONAR
	
	/*
    * @description obtiene los valores para login de ws
    * @param String nameCusSett
	* @return MX_SB_SAC_LoginToken__c loginToken
    */
	public static MX_SB_SAC_LoginToken__c getLoginToken(String nameCusSett) {
		MX_SB_SAC_LoginToken__c loginToken = new MX_SB_SAC_LoginToken__c();
		loginToken = MX_SB_SAC_LoginToken__c.getValues(nameCusSett);
		return loginToken;
	}

	/*
    * @description obtiene los valores para consulta de la poliza
    * @param String nameCusSettP
	* @return MX_SB_SAC_ParametrosPoliza__c paramPoliza
    */
	public static MX_SB_SAC_ParametrosPoliza__c getParamsPoliza(String nameCusSettP) {
		MX_SB_SAC_ParametrosPoliza__c paramPoliza = new MX_SB_SAC_ParametrosPoliza__c();
		paramPoliza = MX_SB_SAC_ParametrosPoliza__c.getValues(nameCusSettP);
		return paramPoliza;
	}

	/*
    * @description obtiene los el producto que devuelve Clipert
    * @param String nameProd
	* @return Product2 product
    */
	public static Product2 getProductSAC(String nameProd) {
        
		Product2 product = null;
		if(String.isNotBlank(nameProd)) {
			final Product2[] arrProd = [SELECT Id, Name, MX_SB_SAC_Proceso__c FROM Product2 WHERE Name =: nameProd];
            if(!arrProd.isEmpty()) {
				product = arrProd[0];
            }
		}	
		return product;
    }
}