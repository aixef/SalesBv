/**
* -------------------------------------------------------------------------------
* Nombre: MX_SB_MLT_dynamicFormController_cls
* Autor: Angel Ignacio Nava
* Proyecto: Siniestros - BBVA
* Descripción : Clase controladora del componente MX_SB_MLT_DynamicFormController
* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                       Descripción
* --------------------------------------------------------------------------------
* 1.0           13/07/2019     Angel Ignacio Nava           Creación
* 1.1           23/07/2019     Daniel Goncalves Vivas       Corrección Code Smells
* 1.2           30/09/2019     Daniel Goncalves Vivas       Se declaran variables como final
* --------------------------------------------------------------------------------
*/

public with sharing class MX_SB_MLT_dynamicFormController_cls { //NOSONAR
    /**
     * Method para obtener campo de objeto deseado
     * entradas objectIn objeto principal, recordIdIn id de objeto principal 
     * fieldReferenceIn campo ref en objeto principal, objectOut objeto externo, fieldOut campo en objeto externo
     */
    @auraEnabled
    public static String getField ( String objectIn, String recordId, String fieldReferenceIn, String objectOut, String fieldOut ) { //NOSONAR
       
       String fieldOutResult;
       try {

           if( String.isBlank( objectIn ) || String.isBlank( recordId ) || String.isBlank( fieldReferenceIn ) || String.isBlank( objectOut ) || String.isBlank( fieldOut ) ) {
                fieldOutResult = '';         
            } else {            
                String strQueryField = 'SELECT id, ' + String.escapeSingleQuotes( fieldReferenceIn ) + ' FROM ' + String.escapeSingleQuotes( objectIn ) + ' WHERE id = \'' + String.escapeSingleQuotes( recordId ) + '\' LIMIT 1';
                final Object objGenericoIn = Database.query(strQueryField );            
                final List<object> queryObjInI = (List<object>)Json.deserializeUntyped( Json.serialize( objGenericoIn ) );        
                final Map<String,object> queryObjIn = (Map<String,Object>)Json.deserializeUntyped( Json.serialize( queryObjInI[0] ) );
                final String idObjectOut = (String)queryObjIn.get( fieldReferenceIn );

                if ( String.isBlank( idObjectOut ) ) {
                    fieldOutResult = '';
                } else {
                    strQueryField = 'SELECT Id, ' + String.escapeSingleQuotes( fieldOut ) + ' FROM ' + String.escapeSingleQuotes( objectOut ) + ' WHERE id = \'' + String.escapeSingleQuotes( idObjectOut ) + '\' LIMIT 1';
                    final Object objGenericoOut = Database.query(strQueryField);
                    final List<object> queryObjInII = (List<object>)Json.deserializeUntyped( Json.serialize( objGenericoOut ) );
                    final Map<String,object> queryObjOut = (Map<String,Object>)Json.deserializeUntyped( Json.serialize( queryObjInII[0] ) );
                    
                    try {
                        fieldOutResult = (String)queryObjOut.get(fieldOut);
                    } catch( TypeException typExcep ) {
                        final Integer integerData = (Integer)queryObjOut.get(fieldOut);
                        fieldOutResult = String.valueOf(integerData);
                    }

                    if ( String.isBlank( fieldOutResult ) ) {
                        fieldOutResult = '';
                    }
                }
            }
        } catch ( CustomException ce ) {
            throw new AuraHandledException ( System.Label.MX_WB_LG_ErrorBack + ce);
        }
        return fieldOutResult;
    }
}