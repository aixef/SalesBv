/*----------------------------------Desarrollado por INDRA---------------------------------
*Autor:         Ricardo Almanza Angeles
*Proyecto:      Max BBVA PI8
*Descripción:   Manejador para el trigger de BPyP de asignación de Clientes.
*_______________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        02/FEB/2018     Ricardo Almanza Angeles             Creación
*1.1        14/FEB/2018     Ricardo Almanza Angeles             Mejora por parte de salud de la org con mayor uso de mapas
*1.2        27/AGO/2019     Cindy Arianna Hernández Nieto       Se modifica el método updateAccountInfo para incluir el
																tipo de registro MX_BPP_PersonAcc_Client. El tipo de
																registro de la cuenta se elige en base al campo Sector__c.
-----------------------------------------------------------------------------------------*/
public with sharing class BPyP_ClienteImportar_cls {

	@TestVisible
	private BPYP_ClienteImportar_cls() {
	}
	/**Metodo asignaBkm */
	public static void asignaBkm(Map<Id, RecordType> mapRecordTypes,List<Account> newtrigacc) {
		final Map<String, RecordType> mapRecordInverso = new Map<String, RecordType>();
		for(RecordType tmp : mapRecordTypes.values()) {
			mapRecordInverso.put(tmp.DeveloperName, tmp);
		}
		final Set<String> empNum = getEmployees(newtrigacc);
		final Map<String, User> mapUser = getEmployeesByNumber(empNum);
		updateAccountInfo(newtrigacc, mapUser, mapRecordInverso);
	}

	private static Set<String> getEmployees(List<Account> newtrigacc) {
		final Set<String> empNum = new Set<String>();
		for(Account ac: newtrigacc) {
			if(ac.Tipo_de_Registro_Manual__c == 'BPYP_PRE' && String.isNotBlank(ac.BPyP_Un_Numero_Promotor__c)) {
				empNum.add(ac.BPyP_Un_Numero_Promotor__c);
			}
		}
		return empNum;
	}

	private static Map<String, User> getEmployeesByNumber(Set<String> empNum) {
		final Map<String, User> mapUser = new Map<String, User>();
		for(User usr : [Select Id,Name,EmployeeNumber from User where EmployeeNumber in :empNum]) {
			mapUser.put(usr.EmployeeNumber, usr);
		}
		return mapUser;
	}

	private static void updateAccountInfo(List<Account> newtrigacc, Map<String, User> mapUser, Map<String, RecordType> mapRecordInverso) {
		final List<MX_BPP_SectorCodes__mdt> personAccCodes = [SELECT MX_BPP_SectorCode__c FROM MX_BPP_SectorCodes__mdt WHERE MX_BPP_SectorAccountType__c = 'Cuenta personal'];
		final List<String> personAccStrCodes = new List<String>();
		for(MX_BPP_SectorCodes__mdt sectorCode : personAccCodes ) {
			personAccStrCodes.add(sectorCode.MX_BPP_SectorCode__c);
		}
		for(Account acc : newtrigacc) {
			if(mapUser.containsKey(acc.BPyP_Un_Numero_Promotor__c) && acc.Tipo_de_Registro_Manual__c == 'BPYP_PRE') {
				acc.OwnerId = mapUser.get(acc.BPyP_Un_Numero_Promotor__c).Id;
				acc.Tipo_de_Registro_Manual__c= '';
				if(personAccStrCodes.contains(acc.Sector__c)) {
					acc.RecordTypeId = mapRecordInverso.get('MX_BPP_PersonAcc_Client').Id;
				} else {
					acc.RecordTypeId = mapRecordInverso.get('BPyP_tre_Cliente').Id;
				}
			}
		}
	}
}