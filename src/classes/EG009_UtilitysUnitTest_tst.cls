/*-----------------------------------------------------------------------------------------
*----------------------------------Desarrollado por INDRA----------------------------------
*Autor:			Ing. Pedro Alan Hernandez Sierra
*Proyecto:		MAX 3.0 - BBVA Bancomer
*Descripción:	Clase "TEST" general de utilería para otros métodos de prueba
*_______________________________________________________________________________________
*Versión	Fecha			Autor								Descripción
*1.0        14/NOV/2017     Ing. Pedro Alan Hernandez Sierra    Creación.
*1.1        16/NOV/2017     Ing. Pedro Alan Hernandez Sierra    Modificación para agregar OtroAdmin
*1.2        30/ENE/2018     Ing. Pedro Alan Hernandez Sierra    Se agregan métodos: CreaCotizador y CreaOLI
*1.2        07/FEB/2018     Lic. Luis Ruben Quinto Muñoz	    Se Modifican métodos de creacion de usuarios
*1.3        15/FEB/2018     Lic. Luis Ruben Quinto Muñoz	    Se Modifican métodos de creacion de Oportunidad
*1.4        06/MAR/2018     Lic. Luis Ruben Quinto Muñoz	    Se Cambian metodos de prueba para creación de oportunidades
*1.5        05/JUN/2018     Lic. Luis Ruben Quinto Muñoz	    Se agrega el campo Divisi_n__c para que pase por una regla de validación
*2.0		31-07-2018      Ricardo Hernandez Reyes             Actualizo Versión API 43, Agrego label Administrador
*2.1        03-10-2018      Fernando Jaime						Se actualiza label de español por la de ingles
*2.2		09/07/2019		Jair Ignacio Gonzalez Gayosso		Se depuro clase con los metodos confirmados en la migracion de bpyp y pymes
-----------------------------------------------------------------------------------------*/
@isTest
public class EG009_UtilitysUnitTest_tst {

	/** String en_Us */
	static final String STGEN_US = 'en_US';

	@isTest
	/** Clase de prueba para EG009_Utility_cls */
	public static void ambientacionGeneral() {

		final Id profileId = [SELECT Id, Name FROM Profile WHERE Name =: System.label.MX_PERFIL_SystemAdministrator].Id;
		//Tipos de registro de Cuentas y Oportundiades
		final Map<String, RecordType> allRT = new Map<String, RecordType>();
		for(RecordType iteraRT : [SELECT Id, DeveloperName FROM RecordType WHERE (SobjectType = 'Account' OR SobjectType = 'Opportunity')]) {
			allRT.put(iteraRT.DeveloperName, iteraRT);
		}

		final User admin = new User(
            Alias = 'userUno',
            Email='adminBBVA@bbva.tst.deploy.com',
            EmailEncodingKey='ISO-8859-1',
            LastName='Prueba',
            LanguageLocaleKey=STGEN_US,
            LocaleSidKey=STGEN_US,
            ProfileId = profileId,
            UG__c = '0008134',
            Divisi_n__c = 'NOROESTE',
            Segmento_Ejecutivo__c = 'EMPRESARIAL',
            TimeZoneSidKey='America/Mexico_City',
            UserName='adminBBVA@bbva.tst.deploy.com',
            VP_ls_Banca__c = 'Red BEyG',
            IsActive=true
        );
        insert admin;

        final User otroAdmin = new User(
	            Alias = 'userDos',
	            Email = 'OtroAdmin@bbva.tst.deploy.com',
	            EmailEncodingKey='ISO-8859-1',
	            LastName = 'OtroAdmin',
	            LanguageLocaleKey=STGEN_US,
	            LocaleSidKey = STGEN_US,
	            ProfileId = profileId,
	            UG__c = '0008135',
	            Divisi_n__c = 'NOROESTE',
	            Segmento_Ejecutivo__c = 'EMPRESARIAL',
	            TimeZoneSidKey = 'America/Mexico_City',
	            UserName = 'OtroAdmin@bbva.tst.deploy.com',
	            VP_ls_Banca__c = 'Red BEyG',
	            IsActive = true
	        );
		insert otroAdmin;

		System.runAs(admin) {
			UtilitysDataTest_tst.crearProdForm('Colocación', 'Collares');

			final Trigger_Oportunidad__c setting = new Trigger_Oportunidad__c();
			setting.EG009_AC_FinanciamientoPipeline_cls__c = true;
			Insert setting;

			final Account grupoEconomico = new Account(
				Name = 'Grupo Económico [Alan Sierra]',
		        RecordTypeId = allRT.get('BPyP_tre_Cliente').Id
			);
	        insert grupoEconomico;

			final Account cliente = new Account(
				Name = 'Cliente [Alan Sierra]',
				No_de_cliente__c = '55218555',
		        RecordTypeId = allRT.get('BPyP_tre_Cliente').Id
			);
	        insert cliente;

            Test.startTest();
			System.assertNotEquals(null, cliente.Id);
			Test.stopTest();
    	}
	}

	/** Manda a llamar el metodo creaOportunidad */
	public static Opportunity creaOportunidad(Id cliente, Id tipoRegistro) {
		return creaOportunidad(cliente, tipoRegistro, null, null);
	}

	/** Crea una Oportunidad */
	public static Opportunity creaOportunidad(Id cliente, Id tipoRegistro, String producto, string familia) {
		final Opportunity opp = new Opportunity();
        opp.Name = 'Oportunidad Hija 01';
        opp.CloseDate = Date.today().addMonths(12);
        opp.Tipo_de_Oportunidad__c = 'Nueva';
        opp.AccountID = cliente;
		opp.RecordTypeId = tipoRegistro;
        opp.StageName = 'Abierta';
		opp.MX_RTL_Familia__c = familia;
        opp.MX_RTL_Producto__c = producto;
        opp.Amount = 123123123;
        opp.op_amountPivote_dv__c = 15000000 ;
	    insert opp;
	    return opp;
	}

}