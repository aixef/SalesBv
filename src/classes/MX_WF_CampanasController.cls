/**
* ------------------------------------------------------------------------------
* @Nombre: MX_WF_CampanasController
* @Autor: Sandra Ventura García
* @Proyecto: Workflow Campañas
* @Descripción : Apex controller para componentes CmpListaCampanias, CmpListaTarjetas, CmpListaComercios
* ------------------------------------------------------------------------------
* @Versión       Fecha           Autor                         Descripción
* ------------------------------------------------------------------------------
* 1.0           18/09/2019     Sandra Ventura García	         test
* ------------------------------------------------------------------------------
*/
public with sharing class MX_WF_CampanasController {
   
  /**
  * @description: construnctor sin argumentos
  * @author Sandra Ventura
  */    
    @TestVisible
    private MX_WF_CampanasController() {}

  /**
  * @description: Devuelve lista de campañas.
  * @author Sandra Ventura
  */    
    @AuraEnabled
    public static List<Campaign> getListCampanas(String fFinVigCamp, String fIniVigCamp) { 
        try { 
             final Date fFinVigCampd = Date.valueOf(fFinVigCamp); 
             final Date fIniVigCampd = Date.valueOf(fIniVigCamp);
             return  [SELECT ID, Name, MX_WF_Campa_a_es_regional__c, StartDate,EndDate,MX_WF_Fecha_de_publicacion__c,Status FROM Campaign 
                      WHERE EndDate >= :fFinVigCampd  AND MX_WF_Fecha_de_publicacion__c<= :fIniVigCampd AND Status='Ejecución' AND MX_WF_Campa_a_es_regional__c='No' AND RecordType.DeveloperName = 'CRM_WF_Alianzas_Comerciales' ORDER BY Name ASC]; 
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_WF_ErrorGeneralWFC + e);
        }
    }
    
  /**
  * @description: Devuelve lista de tarjetas.
  * @author Sandra Ventura
  */ 
	@AuraEnabled
	public static List<MX_WF_Catalogo_tarjetas__c> getListTarjetas(String vfecha) {
        try {
            final Date vfechaH = Date.valueOf(vfecha); 
            return [SELECT id, Name, MX_WF_CAT__c, MX_WF_Marca__c,  MX_WF_Producto__c, MX_WF_Nombre_Producto__c 
                    FROM MX_WF_Catalogo_tarjetas__c WHERE MX_WF_Mes_de_ltima_modificaci_n__c <=: vfechaH ORDER BY MX_WF_Producto__c ASC];
        } catch(Exception e) {
			throw new AuraHandledException(System.Label.MX_WF_ErrorGeneralWFC + e);
		}
    }
    
  /**
  * @description: Devuelve lista de comercios.
  * @author Sandra Ventura
  */ 
	 @AuraEnabled
	public static List<Account> getListComercios(String grupoComercial) {
        try {
            final Id idGrupo = Id.valueOf(grupoComercial);
            return [SELECT ID, Name,  GBL_WF_Grupo_Comercial__r.Name  FROM Account WHERE  RecordType.DeveloperName = 'GBL_WF_Comercios' AND GBL_WF_Grupo_Comercial__r.Id =: idGrupo ORDER BY Name ASC];
           } catch(Exception e) {
			throw new AuraHandledException(System.Label.MX_WF_ErrorGeneralWFC+ e);
		} 
    }
}