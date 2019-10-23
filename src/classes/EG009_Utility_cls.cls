/**
*Desarrollado por BBVA Bancomer
*
*Autor :        Pedro Alan Hernandez Sierra
*Proyecto :     Pipeline de Financiamiento (PI 08)
*Descripción :  Utilerias para reutilización
*______________________________________________________________________________________
*Version    Fecha           Autor                   Descripción
*1.0        01/03/2018		Alan Sierra				Se crea el método
*1.2        09/08/2018		Alan Sierra				Se agrega el método isPermissionSetUser(set<String>) Para validar si el usuario tiene el conjunto de permisos.
*1.3        09/07/2019      Jair Ignacio Gonzalez   Se depuro clase con los metodos confirmados en la migracion de bpyp y pymes
**/
public with sharing class EG009_Utility_cls {

    /** Map con PermissionSet */
    private static Map<String, PermissionSetAssignment> mapPermissionSets = new Map<String, PermissionSetAssignment>();

    private EG009_Utility_cls() {
    }


	static {
        for (PermissionSetAssignment iteraPSA : [SELECT Id, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId()]) {
            mapPermissionSets.put(iteraPSA.PermissionSet.Name, iteraPSA);
        }
	}

    /** Obtiene los RecordType activos de un objeto */
    public static Map<String, RecordType> getActiveRecordTypes(String sobjectTypeStr) {
        final Map<String, RecordType> mapRecordTypes = new Map<String, RecordType>();
        for(RecordType iteraRT : [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType =: sobjectTypeStr AND IsActive = true]) {
            mapRecordTypes.put(iteraRT.DeveloperName, iteraRT);
        }
        return mapRecordTypes;
    }

    /** Regresa un mapa con el DeveloperName de los RecordTypes como llave */
    public static Map<String, RecordType> orderRecordTypesByMap(Map<Id, RecordType> mapRecordType) {
        final Map<String, RecordType> mapRecordTypes = new Map<String, RecordType>();
        for(RecordType iteraRT : mapRecordType.values()) {
            mapRecordTypes.put(iteraRT.DeveloperName, iteraRT);
        }
        return mapRecordTypes;
    }

    /** Regresa una lista de RecordTypes validos */
    public static String recordTypesValidos(String nombreDeLista) {
        String rtValidos = null;
        String rtCash1;
        String rtCash2;
        rtCash1 = 'RTCash1';
        rtCash2 = 'RTCash2';
        if(nombreDeLista == rtCash1) {
            //Tipos de Registro para validar si entra o no la funcionalidad de una clase en especifico (En CH_Asignar_Productos_Standar_tgr antes era formatos)
            rtValidos = 'Adquirente_v2, Adquirente_SSEE_Aplinet, Adquirente_SSEE_E_Commerce, Adquirente_SSEE_Intered, Adquirente_SSEE_Webtransfer ,CIE_V2, Bcom, Netcash, DEM_V2, SIT_V2 ,TIB_V2, Domiciliaci_n_V2, Multipagos, Host_to_Host_V2';
        }
        if(nombreDeLista == rtCash2) {
            //Tipos de Registro para validar si entra o no la funcionalidad de una clase en especifico (En CH_Asignar_Productos_Standar_tgr antes era formatos2)
            rtValidos = 'Adquirente_SSEE_Aplinet, Adquirente_SSEE_E_Commerce, Adquirente_SSEE_Intered, Adquirente_SSEE_Webtransfer, Host_to_Host_V2';
        }
        return rtValidos;
    }

}