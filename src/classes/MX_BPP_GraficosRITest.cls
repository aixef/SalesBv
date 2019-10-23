/**
*Desarrollado por:       Indra
*Autor:                  Ricardo Almanza
*Proyecto:               BpyP
*Descripción:            Clase Test para la clase MX_BPP_GraficosRI
*
*Cambios (Versiones) prueba
*-------------------------------------------------------------------------------
*No.         Fecha            Autor                           Descripción
*------   ----------------   --------------------   ----------------------------
*1.0      07-06-2018         Ricardo Almanza                   Creación
*1.1      15-06-2018         Ricardo Almanza              Mejora para EU de BPyP
*1.2      17-06-2019         Cindy Hernández              Se modifican los métodos test_fetchGraph y test_getDataTablero
                                                          para que se creen los usuarios a ser utilizados.
                                                          Se agrega el método graficosConstructor.
**/
@isTest
private class MX_BPP_GraficosRITest {

    private static EU001_RI__c creaRI() {
        final EU001_RI__c ri = new EU001_RI__c();
        ri.EU001_tx_Estado__c = 'Preparación';
        ri.EU001_ft_Fecha_Inicio__c = System.now();
        return ri;
    }

/**
* This is a test method for fetchGraphs
*/
    static testMethod void test_fetchGraph() {
        final List<String> ug = new List<String>{'99999', '88888'};
        final List<User> users = MX_BPP_UserAndRIDataFactory.createTestRecordsUser(ug, false);
        final User u = users[0];
        System.runAs(u) {
            Test.startTest();
            final EU001_RI__c ri = creaRI();
            insert ri;
            final String IDRI = ri.Id;
            final ExpUni_Tablero_Grupal__c[] nteu = new List<ExpUni_Tablero_Grupal__c>();
            final List<String> ptsEvalEU = new list<String> { 'SISTEMÁTICA','EECC','IGBPyP','IRENE 2.0','EFICIENCIA DE CORREOS','FORMACION'};
            for(String ev : ptsEvalEU) {
                final ExpUni_Tablero_Grupal__c teuf = new ExpUni_Tablero_Grupal__c();
                teuf.EU_001_tx_Indicador__c = ev;
                teuf.EU_Puntos__c = 1;
                teuf.EU_UG__c = u.UG__c;
                teuf.EU_Indicador__c = Label.MX_BPP_EU;
                teuf.MX_BPP_Valor5__c = Decimal.valueOf(u.EmployeeNumber);
                nteu.add(teuf);
            }
            insert nteu;
            final MX_BPP_GraficosRI.WRP_Chart result_fetchEUBPP = MX_BPP_GraficosRI.fetchEUBPP(IDRI);
            System.assertNotEquals(null, result_fetchEUBPP, 'result_fetchEUBPP correcto');

            final ExpUni_Tablero_Grupal__c tep = new ExpUni_Tablero_Grupal__c();
            tep.EU_Indicador__c = Label.MX_BPP_TABLERO;
            tep.MX_BPP_Codigo_Tablero__c = u.EmployeeNumber;
            tep.EU_UG__c = u.UG__c;
            tep.MX_BPP_Valor4__c = 1;
            insert tep;

            final MX_BPP_GraficosRI.WRP_Chart result_fetchPuntosBPP = MX_BPP_GraficosRI.fetchPuntosBPP(IDRI);
            System.assertNotEquals(null, result_fetchPuntosBPP, 'result_fetchPuntosBPP correcto');

            Test.stopTest();
        }
    }

/**
* This is a test method for getDataTablero y asociados
*/
    static testMethod void test_getDataTablero() {

        Test.startTest();

        final String objectName = 'ExpUni_Tablero_Grupal__c';
        final String fieldName = 'EU_001_tx_Indicador__c';
        final String result_getFieldLabel = MX_BPP_GraficosRI.getFieldLabel(objectName , fieldName);
        System.assertNotEquals(null, result_getFieldLabel, 'result_getFieldLabel correcto');

        final List<String> ug = new List<String>{'99999', '88888'};
        final List<User> users = MX_BPP_UserAndRIDataFactory.createTestRecordsUser(ug, false);
        final User u = users[0];
        final ExpUni_Tablero_Grupal__c tep = new ExpUni_Tablero_Grupal__c();
        tep.EU_Indicador__c = Label.MX_BPP_TABLERO;
        tep.MX_BPP_Codigo_Tablero__c = u.EmployeeNumber;
        tep.EU_UG__c = u.UG__c;
        tep.MX_BPP_Valor4__c = 1;
        insert tep;
        final String fieldEmpleado = u.EmployeeNumber;
        final List<Object> options = MX_BPP_GraficosRI.getPicklistOptions(objectName , fieldName , fieldEmpleado);
        System.assertNotEquals(null, options, 'getPicklistOptions correcto');

        final String indicador;
        // String fieldEmpleado;
        final List<ExpUni_Tablero_Grupal__c> eut = MX_BPP_GraficosRI.getDataTablero(indicador , fieldEmpleado);
        System.assertNotEquals(null, eut, 'getDataTablero correcto');

        Test.stopTest();
    }

    @isTest
    static void graficosConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        final MX_BPP_GraficosRI graficosRI = new MX_BPP_GraficosRI();
            System.assert(graficosRI != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }

}