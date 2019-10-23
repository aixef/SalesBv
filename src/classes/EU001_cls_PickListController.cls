/**
*Desarrollado por:       Indra
*Autor:                  Isaías Velázquez Cortés
*Proyecto:               Experiencia Unica
*Descripción:            Clase para PickList Personalizado (Reutilizable)
*
*Cambios (Versiones)
****************************************************************************************************
*No.    |     Fecha      |         Autor            |                  Descripción
****************************************************************************************************
*1.0    |   28-12-2017   |    Isaías Velázquez      |                   Creación
*1.1    |   03-06-2019   |    Cindy Hernández       | Resolución de code smells detectados por sonar.
**/
public class EU001_cls_PickListController {

    //Constructor with no arguments
    @TestVisible
    private EU001_cls_PickListController() {
    }

    @AuraEnabled
    /** Método getPickListValuesIntoList */
    public static List<String> getPickListValuesIntoList(String objectType, String selectedField,String recordType) {
        final List<String> pickListValuesList = new List<String>();
        try {
            final Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);

            final Schema.DescribeSObjectResult res = convertToObj.getDescribe();
            final Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();

        final List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        // RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType=:objectType and Name=:recordType  LIMIT 1];
            for( Schema.PicklistEntry pickListVal : ple) {
            //   if ( pickListVal. == 'REFERENCE' )
                pickListValuesList.add(pickListVal.getLabel());
            }
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return pickListValuesList;
    }
}