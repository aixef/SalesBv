/**
* -------------------------------------------------------------------------------
* Nombre: MX_SB_MLT_FederationId
* Autor: Marco Antonio Cruz Barboza
* Proyecto: Siniestros - BBVA
* Descripción : Retorna información del usuario
* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                   	Descripción
* --------------------------------------------------------------------------------
* 1.0         26/08/2019     Marco Antonio Cruz Barboza		Creación
* 1.1         23/09/2019     Daniel Goncalves Vivas			Comentario de clase
* 1.2         24/09/2019     Daniel Goncalves Vivas			Manejo de AuraHandleException
* 1.3         30/09/2019     Daniel Goncalves Vivas         Se comenta method y se agrega espacio antes de llave
* --------------------------------------------------------------------------------
*/
public with sharing class MX_SB_MLT_FederationId {//NOSONAR
    /*
    * Method que retorna FederationID del Usuario
    */
    @AuraEnabled 
    public static String usuarioId() {
        String usrFedId;
		try {
			usrFedId = [SELECT id, FederationIdentifier FROM User WHERE id =: userInfo.getUserId()].FederationIdentifier;
            if (String.isBlank(usrFedId)) {
                throw new CustomException ( System.Label.MX_WB_LG_ErrorBack + ' No se encontró usuario');
            }
		} catch ( CustomException ce ) {
			throw new AuraHandledException ( System.Label.MX_WB_LG_ErrorBack + ce);
		}
        return usrFedId;
    }
}