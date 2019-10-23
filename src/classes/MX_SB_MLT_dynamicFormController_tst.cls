/**---------------------------------------------------------------------------------
* Nombre: MX_SB_MLT_dynamicFormController_tst
* Autor: Angel Ignacio Nava
* Proyecto: Siniestros - BBVA
* Descripción : Prueba de MX_SB_MLT_dynamicFormController_cls
* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                       Desripción
* --------------------------------------------------------------------------------
* 1.0           13/07/2019     Angel Ignacio Nava           Creación
* 1.1           23/07/2019     Daniel Goncalves Vivas       Corrección Code Smells
* 1.2           30/09/2019     Daniel Goncalves Vivas       Se declaran variables como final
* --------------------------------------------------------------------------------
**/
@isTest
public class MX_SB_MLT_dynamicFormController_tst {
    /*Número de Empleados para Pruebas*/
    static final Integer NUM_OF_EMPL = 20;

    @testSetup
    static void setDatos() {

        MX_WB_TestData_cls.CreaClienteC(1, 'luffy');
        final Case objCaseTst = new Case();
        insert objCaseTst;
    }

    /**
     * Prueba para algún valor vacío
     */ 
    @isTest
    static void errorCamposObligatorios() {
        test.startTest();      
            System.assertEquals('', MX_SB_MLT_dynamicFormController_cls.getField('Case', null, 'id', 'Contract', 'Name'), 'Valor Vacío esperado');
        test.stopTest();
    }

    /**
     * Prueba para valor vacío de objeto principal
     */
    @isTest
    static void objPrincipalVacio() {
        test.startTest();
            System.assertEquals('' , MX_SB_MLT_dynamicFormController_cls.getField('Case', [ SELECT id FROM case LIMIT 1].Id, 'AccountId', 'Account', 'Name'), 'Valor Objeto Principal Vacío esperado');
        test.stopTest();
    }
    /**
     * Prueba para el campo buscado como vacío
     */
    @isTest
    static void objExternoVacio() {

        final Account objAccTst = [ SELECT ID FROM Account LIMIT 1 ];
        final Case objCaseTst = [ SELECT ID FROM Case LIMIT 1];
        objCaseTst.accountId = objAccTst.ID;
        update objCaseTst;

        test.startTest();
            final String valor = MX_SB_MLT_dynamicFormController_cls.getField('Case', objCaseTst.Id, 'AccountId', 'Account', 'BillingState');            
            System.assert(String.isBlank(valor), 'Valor Externo Vacío esperado');
        test.stopTest();
    }

    /**
     * Method para el resultado correcto regular
     */
    @isTest
    static void resultadoCorrecto() {
        
        final Account objAccTst = [ SELECT ID, Name FROM Account LIMIT 1 ];
        final Case objCaseTst = [ SELECT ID FROM Case LIMIT 1];
        objCaseTst.accountId = objAccTst.ID;
        update objCaseTst;

        test.startTest();          
            System.assertEquals(objAccTst.name , MX_SB_MLT_dynamicFormController_cls.getField('Case', objCaseTst.Id, 'AccountId', 'Account', 'Name'), 'Valor en caracteres esperado');
        test.stopTest();
    }

     /**
     * Method para el resultado correcto con un número
     */
    @isTest
    static void resultadoCorrectoNumero() {
        
        final Account objAccTst = [ SELECT ID FROM Account LIMIT 1 ];
        final Case objCaseTst = [ SELECT ID FROM Case LIMIT 1];
        objCaseTst.accountId = objAccTst.ID;
        update objCaseTst;        
        objAccTst.NumberOfEmployees = NUM_OF_EMPL; 
        final String resultado = String.valueOf(NUM_OF_EMPL);       
        update objAccTst;

        test.startTest();
            final String valor = MX_SB_MLT_dynamicFormController_cls.getField('Case', objCaseTst.Id, 'AccountId', 'Account', 'NumberOfEmployees');
            System.assertEquals(resultado, valor, 'Valor en número esperado');
        test.stopTest();
    }
    
}