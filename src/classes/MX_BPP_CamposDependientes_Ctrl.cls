/**
*Desarrollado por:       BBVA Bancomer
*Autor:                  Francisco Javier Licona Rodriguez
*Proyecto:               BPyP
*Descripción:            Clase para el guardado y extracción de datos de las Oportunidades BPYP.
*------------------------------------------------------------------------------------------
*No.         Fecha                       Autor                         Descripción
*------   ----------------   -------------------------------   ----------------------------
*1.0      24-12-2018         Francisco J Licona Rodriguez       Creación
*1.1	  05-02-2019		 Mario A. Calderón Muñoz			Modificaciones correspondientes a
*																lo reportado por SonarQube
*1.2      24-05-2019         Cindy Hernández                    Resolución de code smells detectados por sonar.
**/
public with sharing class MX_BPP_CamposDependientes_Ctrl
{
    @TestVisible
    private MX_BPP_CamposDependientes_Ctrl() {
    }

	/*@Descripción Método que obtiene los valores correspondientes del campo controlador y el campo dependiente.
	*-------------------------------------------------------------
	*@Autor: Francisco J Licona Rodriguez
	*@Fecha: 24-12-2018
	*@param: objDetail Tipo de objeto donde se buscarán los valores
	*@param: contrfieldApiName String que recibe el nombre API del campo controlador
	*@param: depfieldApiName String que recibe el nombre API del campo dependiente
	*@Return Mapa con los valores del campo controlador en la llave del mapa y los valores dependientes en los valores del mapa
	*@Ejemplo: getDependentMap({'sobjectType' : 'Opportunity'},'Tipo_de_Registro_Manual2__c','Tipo_Producto__c')
	*/
    @AuraEnabled public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) {
        final String controllingField = contrfieldApiName.toLowerCase('es');
        final String dependentField = depfieldApiName.toLowerCase('es');
        final Map<String,List<String>> objResults = new Map<String,List<String>>();
        final Schema.sObjectType objType = objDetail.getSObjectType();
        try {
            if(objType != null) {
                final Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
                if(objFieldMap.containsKey(controllingField) || objFieldMap.containsKey(dependentField)) {
                    final Schema.SObjectField theField = objFieldMap.get(dependentField);
                    final Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
                    final List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
                    final List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
                    final List<String> controllingValues = new List<String>();
                    for(Schema.PicklistEntry ple : contrEntries) {
                        final String label = ple.getLabel();
                        objResults.put(label, new List<String>());
                        controllingValues.add(label);
                    }
                    for(PicklistEntryWrapper plew : depEntries) {
                        final String label = plew.label;
                        final String validForBits = base64ToBits(plew.validFor);
                        for(Integer i = 0; i < validForBits.length(); i++) {
                            final String bit = validForBits.mid(i, 1);
                            if(bit == '1') {
                                objResults.get(controllingValues.get(i)).add(label);
                            }
                        }
                    }
                } else {
                    throw new AuraHandledException(System.Label.MX_BPP_Sin_Campos_Dependientes);
                }
            }
        } catch(AuraHandledException qe) {
        	objResults.clear();
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + qe);
        }
        return objResults;
    }


	/*@Descripción Método que transforma números decimales a binario
	*-------------------------------------------------------------
	*@Autor: Francisco J Licona Rodriguez
	*@Fecha: 24-12-2018
	*@param val Intero con un número
	*@Return String con el número transformado
	*@Ejemplo decimalToBinary(10)
	*/
    public static String decimalToBinary(Integer val) {
        String bits = '';
        Integer valAux = val;
        while(valAux > 0) {
            final Integer remainder = Math.mod(valAux, 2);
            valAux = Integer.valueOf(Math.floor(valAux / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }

	/*@Descripción Método que recibe una cadena y la transforma a mayúsculas y minúsculas
	*-------------------------------------------------------------
	*@Autor: Francisco J Licona Rodriguez
	*@Fecha: 24-12-2018
	*@param validFor String con el valor obtenido
	*@Return String con la nueva etiqueta
	*@Ejemplo base64ToBits('Captación')
	*/
    public static String base64ToBits(String validFor) {
        String validForBits = '';
        if(!String.isEmpty(validFor)) {
            for(Integer i = 0; i < validFor.length(); i++) {
                final String thisChar = validFor.mid(i, 1);
                final Integer val = base64Chars.indexOf(thisChar);
                final String bits = decimalToBinary(val).leftPad(6, '0');
                validForBits += bits;
            }
        }
        return validForBits;
    }
    /** */
    private static final String base64Chars = '' +'ABCDEFGHIJKLMNOPQRSTUVWXYZ' + 'abcdefghijklmnopqrstuvwxyz' + '0123456789+/';

	/*@Descripción
	*Método que recibe una lista con valores de los campos
	*-------------------------------------------------------------
	*@Autor: Francisco J Licona Rodriguez
	*@Fecha: 24-12-2018
	*@param PLEs Lista con valores de los campos de tipo Schema.PicklistEntry
	*@Return Una lista con el los valores de los campos en forma de objeto de Salesforce.
	*@Ejemplo wrapPicklistEntries(PickListValues)
	*/
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>) JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }

	/*@Descripción Clase Setter y Getter para pasar variables.
	*-------------------------------------------------------------
	*@Autor: Francisco J Licona Rodriguez
	*@Fecha: 24-12-2018
	*/
    public class PicklistEntryWrapper
    {
        /** */
        public String label {get;set;}
        /** */
        public String validFor {get;set;}
    }
}
