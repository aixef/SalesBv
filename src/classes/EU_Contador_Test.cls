/**
*Desarrollado por:       Indra
*Autor:                  ABRAHAM TINAJERO
*Proyecto:               Experiencia Unica
*Descripción:            Clase Test para la clase ContadorExpUni_Class
*
*Cambios (Versiones)
*-------------------------------------------------------------------------------
*No.         Fecha            Autor                           Descripción
*------   ----------------   --------------------   ----------------------------
*1.0      04-07-2017         Abraham Tinajero        Creación
*1.0      14-08-2017         Monserrat Gonzalez      Método CalculoImpacto para Experiencia única
*1.2      28-02-2018         Abraham Tinajero        Se actualiza metodo par creación de planes de cuenta
*1.3      15-03-2018         Abraham Tinajero        Se actualiza metodo para los nuevos indicadores
*1.4      20-06-2018         Mario Rodríguez         Se cambian referencias de Tipos de Registros por método Developer Name SHIELD
*2.0      28-03-2019         Francisco J Licona      Se corrige creación de usuario para asignación de UG en la creación del tablero
*3.0      19-06-2019         Cindy Hernández         Se eliminan los métodos que no se utilizan y se agrega el método contadorConstructor
**/
@isTest
public with sharing class EU_Contador_Test {

    @isTest static void CreacionRIError1() {
        test.StartTest();
        final String[] ug = new List<String>();
        ug.add('37025');
        ug.add('37024');
        final List<User> users = MX_BPP_UserAndRIDataFactory.createTestRecordsUser(ug,false);

        final EU001_RI__c nuevoRi = new EU001_RI__c();
        nuevoRi.EU001_tx_Estado__c = 'Preparación';
        nuevoRi.EU001_ft_Fecha_Inicio__c = system.now();
        nuevoRi.ownerId = users.get(0).Id;

        insert nuevoRi;

        try {
            final EU001_RI__c nuevoRi01 = new EU001_RI__c();
            nuevoRi01.EU001_tx_Estado__c = 'Preparación';
            nuevoRi01.EU001_ft_Fecha_Inicio__c = system.now();
            nuevoRi01.ownerId = users.get(0).Id;

            final Database.SaveResult result = Database.insert(nuevoRi01);
            System.assertEquals(true, result.isSuccess(), 'Se realizó la inserción correctamente');
        } catch (DmlException e) {
            final String message = e.getMessage();
            System.assertEquals(true, message.contains('Aún existe una RI en estado Preparación, Presentación o Evaluación, debes finalizar esta RI para poder generar una nueva'), 'No ocurrió un error como se esperaba');
        }
        Test.stopTest();
    }

    @isTest static void CreacionTableroError2() {
        test.StartTest();
         try {
            final ExpUni_Tablero_Grupal__c tablero1 = new ExpUni_Tablero_Grupal__c();
            tablero1.EU_UG__c ='37020';
            tablero1.EU_001_tx_Indicador__c ='Cartera Vigente CP';
            tablero1.EU_Indicador__c ='Real';
            tablero1.EU_001_tx_Atributo__c = 'a)Real';
            tablero1.EU_001_Un_Valor__c =147000;
            tablero1.EU_Logro__c = 0;

            final Database.SaveResult result = Database.insert(tablero1);
            System.assertEquals(true, result.isSuccess(), 'Se realizó la inserción correctamente');
        } catch (DmlException e) {
            final String message = e.getMessage();
            System.assertEquals(true, message.contains('La UG no tiene Ejecutivo Asignado (insertar)'), 'No ocurrió un error como se esperaba');
        }
        Test.stopTest();
    }

    @isTest static void heredaRI() {
        final EU001_RI__c nuevoRI = new EU001_RI__c();

        insert nuevoRI;

        final EU_001_Compromiso__c comp = new EU_001_Compromiso__c();
        comp.RecordTypeId = RecordTypeMemory_cls.getRecType('EU_001_Compromiso__c', 'BPyP Captación');
        comp.EU_001_ls_Estatus__c = EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO;
        comp.EU_001_dv_Compromiso__c = 135000;
        comp.EU_fm_Fecha_Cierre__c = date.today().addDays(3);
        comp.EU_001_Rb_Revisi_n_Individual_RI__c = nuevoRI.id;

        insert comp;

        final Case casoRI = new Case();
        casoRI.EU001_ls_Tipo_de_apoyo__c = 'Producto';
        casoRI.Subject = 'Test-subject';
        casoRI.EU001_fh_Fecha_propuesta_de_cierre__c = Date.today().addDays(10);
        casoRI.Status = EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO;
        casoRI.Reuni_n_Individual_RI__c = nuevoRI.id;
        casoRI.RecordTypeId = RecordTypeMemory_cls.getRecType('Case', 'Apoyos');

        insert casoRI;

        nuevoRI.EU001_tx_Estado__c  = EU001_CLS_CONSTANTES.EU001_STR_RI_FINALIZACION;
        nuevoRI.EG_001_ls_Valoracion_de_RI__c ='4';
        nuevoRI.EG001_Valoracion_de_RI_DO__c ='4';

        update nuevoRI;

        final EU001_RI__c nuevoRI_2 = new EU001_RI__c();

        final Database.SaveResult result = Database.insert(nuevoRI_2);
		System.assertEquals(True, result.isSuccess(), 'Se actualizó correctamente la RI.');
    }

    @isTest
    static void contadorConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        final ContadorExpUni_Class contadorExpUni = new ContadorExpUni_Class();
            System.assert(contadorExpUni != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }

}