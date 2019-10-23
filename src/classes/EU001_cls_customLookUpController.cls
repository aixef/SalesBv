/**
*Desarrollado por:       Indra
*Autor:                  Isaías Velázquez Cortés
*Proyecto:               Experiencia Unica
*Descripción:            Clase para LookUp Personalizado (Reutilizable)
*
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 28-12-2017     |    Isaías Velázquez      |           Creación
*1.1    | 18-01-2018     |    Cristian Espinosa     |  Se cambian SOQL por SOSL (SHIELD). COMPONENTE REPETIDO,
*                                                      posible eliminación.
*2.0    | 15-08-18       | Luis Fernando Romero     |  Se agrega lista de campos a la búsqueda de sobjects
*2.1    | 24-05-2019     |    Cindy Hernández       |  Resolución de code smells detectados por sonar.
**/
public with sharing class EU001_cls_customLookUpController {

    //Constructor with no arguments
    @TestVisible
    private EU001_cls_customLookUpController() {
    }

  	@AuraEnabled
      /**Creacion de Lista  */
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String objectName, string indicador) {
        final SObjectType objectDescribe = Schema.getGlobalDescribe().get(objectName);
        final string filters= objectName =='opportunity' && !string.isBlank(indicador) ? ' WHERE Probability >0 and Probability <100 and MX_EU_TipoIndicador__c=:indicador' : '';
        final Map<String,Schema.SObjectField> mfields = objectDescribe.getDescribe().fields.getMap();
        final list<string> fields = new list<string>();
        for(Schema.SObjectField s:mfields.values()) {
            fields.add(string.valueOf(s));
        }
        final string allFields = string.join(fields,',');
        /*CODIGO PARA SHIELD */
        List<sObject> lsTmp = new List<sObject>();
        final List<sObject> returnList = new List<sObject>();
        final String sQuery =  'FIND \''+String.escapeSingleQuotes(searchKeyWord)+'\' IN NAME FIELDS RETURNING '+ String.escapeSingleQuotes(ObjectName) +'('+String.escapeSingleQuotes(allFields)+ String.escapeSingleQuotes(filters) +' order by createdDate DESC  LIMIT 20)';
        system.debug('queryy '+sQuery);
        List<List<sObject>> searchList = new List<List<sObject>>();
        try {
            searchList = search.query(sQuery);
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        lsTmp = searchList[0];
        for (sObject obj: lsTmp) {
            final String nameTmp = (String) obj.get('Name');
            if(nameTmp.containsIgnoreCase(searchKeyWord) && returnList.size() < 5) {
                returnList.add(obj);
            }
        }
        return returnList;
    }
}