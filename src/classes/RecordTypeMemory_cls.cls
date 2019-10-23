/*---------------------------------------Desarrollado por INDRA-------------------------------------------------------------------------
*Autor:         Sergio Andres Ortiz
*Proyecto:      Salud ORG
*Descripción:   Clase que recupera todos los tipos de registro y los almacena en memoria
                para ser usada en todas las consultas a tipos de registro, para su uso:
                1. consultar un Id de Tipo de Registro especifico en un objeto
                RecordTypeMemory_cls.getRecType('devNameObjeto', 'devNameTipoRegistro')
                2. consultar todos los Ids de Tipo de Registro en un objeto
                RecordTypeMemory_cls.getAllSObjectRecType('devNameObjeto')
*_______________________________________________________________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        16/MAR/2018     Sergio Andres Ortiz                 Creación de la clase.
*1.1        03/ABR/2018     Sergio Andres Ortiz                 Se permite consultar tambien por el Name
                                                                y se retorna un Set de Ids en el metodo
                                                                getAllSObjectRecType
*1.2        08/MAY/2018     Sergio Andres Ortiz                 Se elimina return null para eliminar bug
																en sonarqube.
*1.3        11/JUL/2018     Pedro Alan Hdz Sierra               Se agrega método getAllSObjectRecTypeByMapApiName() para obtener un mapa.
*1.4        29/05/2019		Cindy Hernández 				    Recorte de métodos que no se utilizan (No son llamados por otras clases ni por
                                                    			componentes).
-----------------------------------------------------------------------------------------------------------------------------------------*/
public without sharing class RecordTypeMemory_cls {

	//Constructor with no arguments
    @TestVisible
	private RecordTypeMemory_cls() {
    }

	/**Mapa mapRecTypes */
	private static Map<String, Map<String,Id>> mapRecTypes = new Map<String, Map<String,Id>>();
  	/**Mapa mapAuxObjRecType */
	  private static Map<String, Id> mapAuxObjRecType  = new Map<String, Id>();
  	/** Mapa mapTdRecordType*/
	  private static Map<String, RecordType> mapIdRecordType  = new Map<String, RecordType>();

	static {
		List<RecordType> lstRecType = [SELECT Id, SobjectType, DeveloperName, Name FROM RecordType WHERE IsActive = true];
		for (RecordType objRecType : lstRecType) {
			mapAuxObjRecType = mapRecTypes.get(objRecType.SobjectType);
			if ( mapAuxObjRecType == null ) {
				mapAuxObjRecType = new Map<String, Id>();
				mapRecTypes.put(objRecType.SobjectType, mapAuxObjRecType);
			}
			mapAuxObjRecType.put(objRecType.DeveloperName, objRecType.Id); //mapa con llave devNameRecType y valor idRecType
			mapAuxObjRecType.put(objRecType.Name, objRecType.Id); //mapa con llave NameRecType y valor idRecType
			mapIdRecordType.put(objRecType.id, objRecType);
		}
	}

	/**
    * @Method:      getRecType
    * @param:       String devNameObjeto, String devNameTipoRegistro
    * @Description: Método que retorna el Id del tipo de registro consultado por su DeveloperName o Name
    * @author       Sergio Ortiz
    */
	public static id getRecType(String devNameObjeto, String devNameTipoRegistro) {
		Map<String, Id> mapObjRecType = mapRecTypes.get(devNameObjeto);
		return mapObjRecType.get(devNameTipoRegistro);
	}

}