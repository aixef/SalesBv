/*
*
* @author Tania Vazquez
* @description This class will be used to upsert data coming from Hogar tracking web
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    10/10/2019     Tania Vazquez     Busca cuentas
*
*/
public Without Sharing  class MX_SB_BCT_UpdateAccountcla { //NOSONAR
   /*Realiza la recuperación del Nombre del Owner de la Cuenta */
    @AuraEnabled
    public static String updateAcc(String idAcc) {
        String acc ='';
        try {
			acc = [SELECT Owner.name FROM Account WHERE Id=: idAcc].Owner.name;
		} catch(System.QueryException e) {
			throw new AuraHandledException(System.Label.MX_SB_BCT_Error_ListException + e);
		}
        return acc;
     }
}