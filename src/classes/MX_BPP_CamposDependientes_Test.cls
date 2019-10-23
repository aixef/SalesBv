/**
*Desarrollado por:       Accenture SC
*Autor:                  Mario Calderón
*Proyecto:               BPyP
*Descripción:            Clase Test para la clase MX_BPP_CamposDependientes_cls
*
*Cambios (Versiones) prueba
*-------------------------------------------------------------------------------
*No.         Fecha            Autor                         Descripción
*------   ----------------   --------------------   ----------------------------
*1.0      28-01-2019         Mario Calderón                 Creación
*1.0      17-06-2019         Cindy Hernández		Se modifica el método getDependentMap_Test2 para incluir el try catch.
													Se agrega el método camposDepConstructor.
**/

@isTest
public class MX_BPP_CamposDependientes_Test {

    @isTest
    static void getDependentMap_Test() {
        Test.startTest();
        final String tipo = 'Opportunity';
        final Schema.SObjectType targetType = Schema.getGlobalDescribe().get(tipo);
        final Map<String,List<String>> actual = MX_BPP_CamposDependientes_Ctrl.getDependentMap(targetType.newSObject(),'Tipo_de_Registro_Manual2__c', 'Tipo_Producto__c');
        System.assertNotEquals(null, actual,'Correcto!');
        Test.stopTest();
    }

    @isTest
    static void getDependentMap_Test2() {
        final String tipo = 'Account';
        String errorMessage = '';
        final Schema.SObjectType targetType = Schema.getGlobalDescribe().get(tipo);
        Map<String,List<String>> actual = new Map<String,List<String>>();
        Test.startTest();
        try {
        	actual = MX_BPP_CamposDependientes_Ctrl.getDependentMap(targetType.newSObject(),'Tipo_de_Registro_Manual2__c', '');
        } catch (Exception e) {
        	errorMessage = e.getMessage();
        }
        Test.stopTest();
        System.assertEquals('Script-thrown exception', errorMessage);
        System.assertEquals(true, actual.isEmpty(),'No se encontraron campos dependientes en el objeto');
    }

    @isTest
    static void camposDepConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        final MX_BPP_CamposDependientes_Ctrl camposDep = new MX_BPP_CamposDependientes_Ctrl();
	        System.assert(camposDep != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }
}