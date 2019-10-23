/**
* Indra
* @author           Javier Ortiz Flores
* Project:          Telemarketing
* Description:      Asignación de leads a campañas vigentes después de insertarlos.
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     2018-12-18      Javier Ortiz F.		    Creación de la Clase
* @version  1.1     2018-12-18      Eduardo Hernández     	Se cambia la logica para Marcar Leads cuando se crea un miembro de
                                                            campaña false si la campaña esta activa y true si la campaña esta inactiva
********************************************************************************************************************************************/
public without sharing class MX_WB_LeadCampaign_cls {

    private MX_WB_LeadCampaign_cls() {}
    /**
	 * verifyCampain description Recibe una lista de CampaignMember recupera los leads de la campaña y los marca segun la inversa 
        del estatus activo de la campaña
	 * @params	 lstMembers lista de CampaignMember a validar
	 */
    public static void verifyCampain(List<CampaignMember> lstMembers) {
        final List<Lead> lstLead = new List<Lead>();
        final List<CampaignMember> lstMembersSource = [Select Id, LeadId, Campaign.IsActive, LeadSource from CampaignMember where Id IN: lstMembers];
        for(CampaignMember campaingItem : lstMembersSource) {
            final String outLeadSource = 'Outbound';
            if(campaingItem.LeadSource == outLeadSource) {
                final Lead itemLead = new Lead();
                itemLead.Id = campaingItem.LeadId;
           		itemLead.MX_WB_DisabledByTrigger__c = !campaingItem.Campaign.IsActive;
                lstLead.add(itemLead);
           }
    	}
        update lstLead;
    }
}
