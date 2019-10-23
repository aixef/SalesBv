/********************************************************************************
*   Autor:      Desconocido
*   Proyecto:    MAX 3.0 - BBVA Bancomer
*   Descripción:  Clase de Prueba para Opportunity_Tgr
*   -------------------------------------------------------------------------------------------
*   Versión    Fecha      		Autor                		Descripción
*   1.0      XX-XX-xxxx	    	 	  						Creación.
*   1.1 	26/ENE/2018		Ing. Arsenio Perez Lopez  	Se Aislan costantes detectadas por sonarCUbe
*   1.2      24/05/18       Luis Fernando Romero        se agrega linea para cubrir afterDelete
*   1.3     01-10-2018      Fernando Jaime              Se cambia Administrador del sistema por etiqueta personalizada
*   1.4		11/07/2019		Jair I Gonzalez 		    Se depuro clase con los metodos confirmados en la migracion de bpyp
*********************************************************************************/
@isTest
public without sharing class Opportunity_Trigger_TEST {

    /** Comentario de prueba */
	static list<String> constan = new list<string>{'Esto es un comentario de prueba','Otro'};

	@testSetup static void setup() {
        final User admin = new User(
            Alias = 'userUno',
            Email='adminBBVA@bbva.tst.deploy.com',
            EmailEncodingKey='ISO-8859-1',
            LastName='Prueba',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = [SELECT Id, Name FROM Profile WHERE Name =: Label.MX_PERFIL_SystemAdministrator].Id,
            UG__c = '0008134',
            Segmento_Ejecutivo__c = 'EMPRESARIAL',
            TimeZoneSidKey='America/Mexico_City',
            UserName='adminBBVA@bbva.tst.deploy.com',
            VP_ls_Banca__c = 'Red BPyP',
            IsActive=true
        );
        insert admin;

        System.runAs(admin) {
            final Account cliente = new Account();
            cliente.name = 'Prueba';
            insert cliente;

            UtilitysDataTest_tst.crearProdForm('Colocación', 'Collares');

            final Opportunity opp = new Opportunity();
            //opp.CR_REL_NombreAval__c = cliente.Id;
            opp.AccountID = cliente.Id;
            opp.StageName = 'Abierta';
            opp.Tipo_de_Oportunidad__c = 'Nueva';
            opp.CloseDate = Date.today();
            opp.Name = 'Prueba';
            opp.MX_RTL_Familia__c = 'Colocación';
            opp.MX_RTL_Producto__c = 'Collares';
            opp.Tipo_de_Registro_Manual2__c = 'Adquirente TPV';
            opp.op_amountPivote_dv__c = 100;
            opp.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: 'MX_BPP_RedBpyp'].Id;
            insert opp;
        }

	}

     @isTest static void actualizaOportunidadCambioEtapa() {

         final User user = [SELECT Id, VP_ls_Banca__c FROM User WHERE Email = 'adminBBVA@bbva.tst.deploy.com'];
         System.runAs(user) {
             final Opportunity oportunidadCreada = [SELECT Id, Name, StageName FROM Opportunity LIMIT 1];
             oportunidadCreada.StageName = 'Cerrada Ganada';
             Test.startTest();
             Update oportunidadCreada;
             system.assertEquals(oportunidadCreada.StageName , 'Cerrada Ganada','Funciono');
             Test.stopTest();
         }

     }

}