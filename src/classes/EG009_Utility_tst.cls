/**
* Clase de prueba para EG009_Utility_cls
*/
@isTest
public with sharing class EG009_Utility_tst {

	static {

		EG009_UtilitysUnitTest_tst.ambientacionGeneral();

	}

	/** Clase de Prueba para GetActiveRecordTypes */
	public static testMethod void testGetRecordTypes() {

		final User user = [SELECT Id, VP_ls_Banca__c FROM User WHERE Email = 'adminBBVA@bbva.tst.deploy.com'];
		System.runAs(user) {

			final Map<String, RecordType> mapRecordTypes = new Map<String, RecordType>();
	        for(RecordType iteraRT : [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType =: 'Opportunity' AND IsActive = true]) {
	            mapRecordTypes.put(iteraRT.DeveloperName, iteraRT);
	        }


			System.assertEquals(mapRecordTypes.get('MX_BPP_RedBpyp').Id, EG009_Utility_cls.getActiveRecordTypes('Opportunity').get('MX_BPP_RedBpyp').Id, 'ID de Tipo de Registro: ');


		}

	}

	/** Clase de prueba para metodo orderRecordTypesByMap */
	public static testMethod void testOrderRecordTypesByMap() {
		final User user = [SELECT Id, VP_ls_Banca__c FROM User WHERE Email = 'adminBBVA@bbva.tst.deploy.com'];
		System.runAs(user) {

			final Map<Id, RecordType> mapRecordTypes = new Map<Id, RecordType>();
	        for(RecordType iteraRT : [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType =: 'Opportunity' AND IsActive = true]) {
	            mapRecordTypes.put(iteraRT.Id, iteraRT);
	        }

			System.assertNotEquals(null, EG009_Utility_cls.orderRecordTypesByMap(mapRecordTypes));

		}
	}

	/** Clase de prueba para metodo recordTypesValidos */
	public static testMethod void testRTValidos1() {
		final User user = [SELECT Id, VP_ls_Banca__c FROM User WHERE Email = 'adminBBVA@bbva.tst.deploy.com'];
        System.runAs(user) {
                System.assertEquals('Adquirente_v2, Adquirente_SSEE_Aplinet, Adquirente_SSEE_E_Commerce, Adquirente_SSEE_Intered, Adquirente_SSEE_Webtransfer ,CIE_V2, Bcom, Netcash, DEM_V2, SIT_V2 ,TIB_V2, Domiciliaci_n_V2, Multipagos, Host_to_Host_V2', EG009_Utility_cls.recordTypesValidos('RTCash1'), 'Retorna una cadena con developers names de tiposd e registro.: ');
        }

	}

    /** Clase de prueba para metodo recordTypesValidos */
	public static testMethod void testRTValidos2() {
		final User user = [SELECT Id, VP_ls_Banca__c FROM User WHERE Email = 'adminBBVA@bbva.tst.deploy.com'];
        System.runAs(user) {
                System.assertEquals('Adquirente_SSEE_Aplinet, Adquirente_SSEE_E_Commerce, Adquirente_SSEE_Intered, Adquirente_SSEE_Webtransfer, Host_to_Host_V2', EG009_Utility_cls.recordTypesValidos('RTCash2'), 'Retorna una cadena con developers names de tiposd e registro.: ');
        }
	}

    /** Clase de prueba para metodo recordTypesValidos */
	public static testMethod void testRTValidos3() {
		final User user = [SELECT Id, VP_ls_Banca__c FROM User WHERE Email = 'adminBBVA@bbva.tst.deploy.com'];
        System.runAs(user) {
                System.assertEquals(null, EG009_Utility_cls.recordTypesValidos(''), 'Retorna una cadena con developers names de tiposd e registro.: ');
        }
	}

}