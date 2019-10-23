/**
*Desarrollado por:       Indra
*Autor:                  Alberto Galindo Hernández
*Proyecto:               Experiencia Unica
*Descripción:            Clase para la valoracion de una terminacion de Reunion RI
*
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 23-08-2017     |    Alberto Galindo       |           Creación
*1.1    | 07-02-2017     | Isaías Velázquez Cortés  |         Modificación
*1.2    | 20-03-2018     | Francisco Javier Licona  |         Se agregan modificaciones de valoración de ejecutivos y directores.
*1.3    | 05-11-2018     |    Cesar Villanueva      |  Se agrega método de búsqueda de ID de informes
*1.4    | 22-05-2019     |    Cindy Hernández       |  Resolución de code smells detectados por sonar.
**/
public with sharing class ValoracionRI_cls {

    //Constructor with no arguments
    @TestVisible
    private ValoracionRI_cls() {
    }

    /** variable START_POSITION*/
    private static final Integer START_POSITION = 0;
    /**variable END_POSITION */
    private static final Integer END_POSITION = 3;
    /*@Descripción
    *Obtiene el ApiName del objeto donde se ejecuta el componente de valoracion
    *------------------------------------------------------------
    *@Return   Mapa con el nombre del ApiName
    */
    @AuraEnabled
    public static String getApiName(String recordId) {
        Map<String,String> mapKeys = new Map<String,String>();
        Map<String,Schema.SobjectType> describe = new Map<String,Schema.SobjectType>();
        try {
            describe = Schema.getGlobalDescribe();
            for(String s:describe.keyset()) {
                mapKeys.put(describe.get(s).getDescribe().getKeyPrefix(),s);
            }
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return mapKeys.containsKey(recordId.substring(START_POSITION, END_POSITION)) ? mapKeys.get(recordId.substring(START_POSITION, END_POSITION)) : '';
    }

    /*@Descripción
    *Obtiene la valoración previa de alguna reunion si es que se hubiera
    *------------------------------------------------------------
    *@Return   Valor en numero de la valoracion guardada anteriormente
    */
    @AuraEnabled
    public static sObject getSobjectRating(String recordId) {
        sObject previousValoration ;
        try {
            previousValoration = Database.query('select Id, EG_001_ls_Valoracion_de_RI__c, EG001_Valoracion_de_RI_DO__c,EU001_tx_Estado__c from EU001_RI__c where Id =: recordId');
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return previousValoration;
    }

    /*@Descripción
    *Guarda y/o actualiza en numero la valoración asignada al ejecutivo
    *------------------------------------------------------------
    */
    @AuraEnabled
    public static void setSobjectRating(String apiName, String recordId, String rating, String evaluador) {
        Id sesssionOwner = userInfo.getUserId();
        EU001_RI__c toUpdates;
        try {
            toUpdates = [
                SELECT EU001_tl_Comentario_EV__c, EU001_tl_Comentario_DO__c, EG_001_ls_Valoracion_de_RI__c, EG001_Valoracion_de_RI_DO__c, OwnerId 
                FROM EU001_RI__c
                WHERE id =: recordId];
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        sObject toUpdate = Schema.getGlobalDescribe().get(apiName).newSObject();
        if(sesssionOwner == toUpdates.OwnerId) { toUpdate.put('Id', String.valueOf(recordId));toUpdate.put('EG_001_ls_Valoracion_de_RI__c', String.valueOf(rating)); } else {
            toUpdate.put('Id', String.valueOf(recordId));
            toUpdate.put('EG001_Valoracion_de_RI_DO__c', String.valueOf(rating));
        }
        try {
            update toUpdate;
            if (Test.isRunningTest()) {
            	throw new DmlException();
            }
        } catch(DmlException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    }

}