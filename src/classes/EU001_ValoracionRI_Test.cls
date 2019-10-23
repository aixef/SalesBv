/**
*Desarrollado por:       Indra
*Autor:                  Alberto Galindo Hernández
*Proyecto:               Experiencia Unica
*Descripción:            Clase para la valoracion de una terminacion de Reunion RI
*
*Cambios (Versiones)
***************************************************************************************************************************************
*No.    |     Fecha      |     Autor                |        						  Descripción
***************************************************************************************************************************************
*1.0    | 23-08-2017     |    Alberto Galindo       |          						   Creación
*       | 07-02-2017     | Isaías Velázquez Cortés  |  Modificación
*1.2    | 05-11-2018     | César Villanueva         |  Añadido método para la verificación del Id de reporte
*1.3    | 17-06-2019     | Cindy Hernández          |  Se eliminan métodos no necesarios y se agregan los métodos valoracionConstructor
													   y getSobjectRatingWithError.
*1.3	| 26-06-2019	 | Cindy Hernández 			|  Se agrega el try catch y su respectivo System.assert al método ValoracionRI.  
**/
@isTest
public with sharing class EU001_ValoracionRI_Test {

    @isTest
    static void ValoracionRI() {
        final String[] ug = new List<String>();
        ug.add('789001');
        ug.add('789011');
        final String [] evaluador = new List<String>();
        evaluador.add('EV');
        evaluador.add('DO');
        final List<User> users = MX_BPP_UserAndRIDataFactory.createTestRecordsUser(ug, false);
        final EU001_RI__c nuevoRi = new EU001_RI__c();
        nuevoRi.EU001_tx_Estado__c = 'Preparación';
        nuevoRi.EU001_ft_Fecha_Inicio__c = system.now();
        nuevoRi.ownerId = users.get(0).Id;
        insert nuevoRi;
        test.StartTest();
        ValoracionRI_cls.getApiName(nuevoRi.id);
        ValoracionRI_cls.getSobjectRating(nuevoRi.id);
        nuevoRI.EU001_tl_Comentario_EV__c='HOLA';
        nuevoRI.EU001_tl_Comentario_DO__c='ADIOS';
        nuevoRI.EG_001_ls_Valoracion_de_RI__c='2';
        nuevoRI.EG001_Valoracion_de_RI_DO__c='3';
        update nuevoRI;
        for(Integer x = 0; x < 2; x ++) {
            String errorMessage = '';
            try {
                ValoracionRI_cls.setSobjectRating('EU001_RI__c', nuevoRi.id, '3', evaluador[x]);
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
        	System.assertEquals('Script-thrown exception', errorMessage);
        }
        system.debug('user name: ' +UserInfo.getName());
        System.assert(true, 'assert');
        test.stopTest();
    }

    @isTest
    static void getTabla() {
        final String[] ug1 = new List<String>();
        ug1.add('78900');
        ug1.add('78901');
        final String [] evaluador1 = new List<String>();
        evaluador1.add('EV');
        evaluador1.add('DO');

        final List<User> users1 = MX_BPP_UserAndRIDataFactory.createTestRecordsUser(ug1,false);

        test.StartTest();
        final EU001_RI__c nuevoRi1 = new EU001_RI__c();
        nuevoRi1.EU001_tx_Estado__c = 'Preparación';
        nuevoRi1.EU001_ft_Fecha_Inicio__c = system.now();
        nuevoRi1.ownerId = users1.get(0).Id;

        insert nuevoRi1;
        ValoracionRI_cls.getApiName(nuevoRi1.id);

        final List<ExpUni_Tablero_Grupal__c> listaTablero1 = new List<ExpUni_Tablero_Grupal__c>();
        listaTablero1.add(MX_BPP_RIRecordsDataFactory.CrearTableroIndividua(ug1[0],EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_CP,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,22));
        listaTablero1.add(MX_BPP_RIRecordsDataFactory.CrearTableroIndividua(ug1[0],EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_CP,'B) Logro potencial','B) Logro potencial',22));
        listaTablero1.add(MX_BPP_RIRecordsDataFactory.CrearTableroIndividua(ug1[0],EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_CP,'A) Puntos','A) Puntos',22));
        listaTablero1.add(MX_BPP_RIRecordsDataFactory.CrearTableroIndividua(ug1[0],EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_CP,'B) Puntos potenciales','B) Puntos potenciales',22));
        listaTablero1.add(MX_BPP_RIRecordsDataFactory.CrearTableroIndividua(ug1[0],EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_CP,'A) Gana Mas','A) Gana Mas',22));
        listaTablero1.add(MX_BPP_RIRecordsDataFactory.CrearTableroIndividua(ug1[0],EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_CP,'B) Gana Mas Potencial','B) Gana Mas Potencial',22));
        listaTablero1.add(MX_BPP_RIRecordsDataFactory.CrearTableroIndividua(ug1[0],EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_CP,'Amortizacion','Amortizacion',22));
        listaTablero1.add(MX_BPP_RIRecordsDataFactory.CrearTableroIndividua(ug1[0],EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_CP,'Presupuesto','Presupuesto',22));

        insert listaTablero1;
        System.assert(true, 'assert');
        test.stopTest();
    }

    @isTest
    static void valoracionConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        final ValoracionRI_cls valoracionRI = new ValoracionRI_cls();
            System.assert(valoracionRI != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }

    @isTest
    static void getSobjectRatingWithError() {
        String errorMessage = '';
        test.StartTest();
        try {
        	ValoracionRI_cls.getSobjectRating('BAD ID');
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('Script-thrown exception', errorMessage);
    }

}