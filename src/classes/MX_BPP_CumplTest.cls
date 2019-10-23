/**
*Desarrollado por:       Indra
*Autor:                  Ricardo Almanza
*Proyecto:               BpyP
*Descripción:            Clase Test para la clase MX_BPP_Cumpl
*
*Cambios (Versiones) prueba
*-------------------------------------------------------------------------------
*No.         Fecha            Autor                           Descripción
*------   ----------------   --------------------   ----------------------------
*1.0      07-06-2018         Ricardo Almanza                   Creación
*2.0	  04-07-2018		 Cindy Hernández		Se agrega el método cumpleanosConstructor para aumentar el porcentaje de cobertura de la clase MX_BPP_Cumpl
													Se agrega try catch en el método test_fetchAcc.
**/
@isTest
private class MX_BPP_CumplTest {

    /**
     * This is a test method for fetchAcc
     */
    static testMethod void test_fetchAcc() {

        Test.startTest();
        String errorMessage = '';
        try {
            String result_fetchbaseurl = MX_BPP_Cumpl.fetchbaseurl();
            System.assertNotEquals(null, result_fetchbaseurl, 'fetchbaseurl correcto');
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        System.assertEquals('Script-thrown exception', errorMessage);
        String sLim='10';
        String sMth='0';
        Integer result_fetchNumAcc = MX_BPP_Cumpl.fetchNumAcc(sLim , sMth);
        System.assertNotEquals(null, result_fetchNumAcc, 'fetchNumAcc correcto');

        String sOff='0';
        errorMessage = '';
        try {
            List<Account> acc= MX_BPP_Cumpl.fetchAcc(sLim , sOff , sMth);
            System.assertNotEquals(null, acc, 'fetchAcc correcto');
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        System.assertEquals('Script-thrown exception', errorMessage);
        Test.stopTest();
    }

    @isTest
    static void cumpleanosConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
      	    final MX_BPP_Cumpl cumpleanos = new MX_BPP_Cumpl();
            System.assert(cumpleanos != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }

}