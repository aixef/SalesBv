/**-------------------------------------------------------------------------
 * Nombre: MX_WB_CampaniasNoDuplicadas
 * Autor Ing. Karen Belem Sanchez
 * Proyecto: MW WB TeleMarketing - BBVA Bancomer
 * Descripción : Clase MX_WB_CampaniasNoDuplicadas que desactiva las campañas activas de la misma familia e inhabilita los leads relacionados a la misma
 * --------------------------------------------------------------------------
 * Versión 		Fecha			Autor					Descripción
 * -------------------------------------------------------------------
 * 1.0			28/11/2018		Karen Belem Sanchez 	Creación
 * 1.1			12/02/2019		Eduardo Hernández 	 	Se agregan methods para desactivar Lead para todas las campañas activas diferentes a la insertada
 * 1.1.1		13/02/2019		Eduardo Hernández 	 	Se modifica lógica para la validación de Leads activos a desactivar y re-activación 
                                                        de leads de una campaña re-activada
 * 1.1.2		14/02/2019		Eduardo Hernández 	 	Se modifica la asignación de IsActive a las campañas activas cuando se crea una inactiva
 * 1.1.3		15/02/2019		Eduardo Hernández 	 	Correcciones para marcar Leads, re activar campañas y desmarcar leads, agregar campañas inactivas
 * 1.1.4        17/04/2019      Arsneio Perez Lopez     Modificacion del filtrado por cambio de modelo ln 30-45
 * 1.2          31/07/2019      Jaime Terrats           Modificacion para reactivacion de leads o desactivacion de leads
 * ----------------------------------------------------------------------------
 */
public without sharing class MX_WB_CampaniasNoDuplicadas {


    /* CampaniasNoDuplicadasCreaAct Desactiva las campañas activas de la misma familia cuando se inserta o actualiza una campaña y pasa a estar activa
	* @Params lstCampaign lista de Campaign que se actualiza o inserta
	*/
	public static void CampaniasNoDuplicadasCreaAct(List<Campaign> lstCampaign) {
		List<Campaign> lstcampanias = new List<Campaign>();
        final Set<String> sMX_FamiliaProveedorCTI = new Set<String>();
        final Set<String> sMX_Tipo_Campana = new Set<String>();
		String  xFamiliaProveedorCTI,xTipo_Campana;
		Boolean bActivo;
		Id idUltimaActiva;
		for(Campaign oNombreFamilia : lstCampaign) {
            xFamiliaProveedorCTI = oNombreFamilia.MX_SB_VTS_FamiliaProducto_Proveedor__c;
            xTipo_Campana = oNombreFamilia.MX_SB_VTS_Tipo_Campana__c;
            sMX_FamiliaProveedorCTI.add(xFamiliaProveedorCTI);
            sMX_Tipo_Campana.add(xTipo_Campana);
			bActivo = oNombreFamilia.IsActive;
            if(Trigger.isUpdate && oNombreFamilia.IsActive) {
                idUltimaActiva = oNombreFamilia.Id;
            }

		}
		lstcampanias = [SELECT Id, Name, IsActive,MX_WB_FamiliaProductos__c,MX_SB_VTS_FamiliaProducto_Proveedor__c,MX_SB_VTS_Tipo_Campana__c
                        FROM Campaign WHERE IsActive = true
                        AND MX_SB_VTS_FamiliaProducto_Proveedor__c IN: sMX_FamiliaProveedorCTI
                        AND MX_SB_VTS_Tipo_Campana__c IN: sMX_Tipo_Campana];
		if(String.isBlank(idUltimaActiva) && Trigger.isInsert) {
			onInsertCampaign(lstcampanias, bActivo);
		} else {
			if(lstcampanias.size() > 1 && Trigger.isUpdate) {
                onUpdateActiveCamp(lstcampanias, bActivo,idUltimaActiva, lstCampaign);
            } else {
                campainsDisabledLeads(lstCampaign, !bActivo);
            }
		}
	}
/**
*
* @
*/
    public static void onInsertCampaign(List<Campaign> lstcampanias, Boolean bActivo) {
        final List<Campaign>  oCampania = new List<Campaign>();
        for(Campaign oCampaniaQuery : lstcampanias) {
            final Campaign itemCamp = new Campaign();
            itemCamp.Id = oCampaniaQuery.Id;
            itemCamp.IsActive = !bActivo;
            oCampania.add(itemCamp);
        }
        if(bActivo && lstcampanias.size() > 0) {
            campainsDisabledLeads(lstcampanias, !bActivo);
        }
        update oCampania;
    }
/**
*
* @
*/
    public static void onUpdateActiveCamp(List<Campaign> lstcampanias, Boolean bActivo, Id idUltimaActiva,List<Campaign> lstCampaign) {
        final List<Campaign>  oCampania = new List<Campaign>();
        for(Campaign oCampaniaQuery : lstcampanias) {
            if(idUltimaActiva != oCampaniaQuery.Id) {
                final Campaign itemCamp = new Campaign();
                itemCamp.Id = oCampaniaQuery.Id;
                itemCamp.IsActive = !bActivo;
                oCampania.add(itemCamp);
            }
        }
        campainsDisabledLeads(oCampania, bActivo);
        campainsDisabledLeads(lstCampaign, !bActivo);
        update oCampania;
    }

    /* campainsDisabledLeads Desactiva los leads de las campañas que sean diferente a
    la actualizada y reactiva los leads de la campaña activa que hayan sido marcados
	* @Params lstCampaign lista de Campaign que se actualiza
	*/
    public static void campainsDisabledLeads(List<Campaign> lstCampaign, Boolean active) {
        final List<CampaignMember> cmsReAct = [SELECT CampaignID, LeadId, Status FROM CampaignMember WHERE CampaignID IN: lstCampaign];
        final Set<Id> cmLeadId = new Set<Id>();
        for(CampaignMember cm : cmsReAct) {
            cmLeadId.add(cm.LeadId);
        }
        enableDisaOldList(cmLeadId, active);
    }

    /* enableDisaOldList Busca los Leads de los CampaignMembers asociados a las campañas que se desactivan
	* @Params CampaignMember lista de CampaignMember asignados a la campaña activa o desactivada
	*/
    public static void enableDisaOldList(Set<Id> cmLeadId, Boolean active) {
        final String ownerId = selectQueueOwner(active);
        MX_SB_VTS_LeadDeactivation runBatch = new MX_SB_VTS_LeadDeactivation(cmLeadId, active, ownerId);
        Database.executeBatch(runBatch);
    }

    /*
    * @Description: realiza la asignacion del owner segun sea campania activa o inactiva
    */
    private static String selectQueueOwner(Boolean active) {
        String idQueue = '';
        if(active == true) {
            idQueue = [Select Id from Group where Name =: System.Label.MX_SB_VTS_InactiveQueue and Type = 'Queue'].Id;
        } else {
            idQueue = [Select Id from Group where Name = 'Asesores ASD Tlmkt' and Type = 'Queue'].Id;
        }
        return idQueue;
    }
}
