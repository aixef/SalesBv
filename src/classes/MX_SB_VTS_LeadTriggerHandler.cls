/**
 * @File Name          : MX_SB_VTS_LeadTriggerHandler.cls
 * @Description        :
 * @Author             : Eduardo Hernández
 * @Group              :
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 23/8/2019 16:31:19
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    9/8/2019 10:54:24   Eduardo Hernández     Initial Version
**/
public without sharing class MX_SB_VTS_LeadTriggerHandler extends TriggerHandler { //NOSONAR
    /*variable de almacenamiento trriger New*/
    final private List<Lead> triggerNewMap;
    final private Map<Id, Lead> oldMaps;
    /*Constructor*/
    public MX_SB_VTS_LeadTriggerHandler() {
        super();
        this.triggerNewMap = Trigger.new;
        this.oldMaps = (Map<Id, Lead>)Trigger.oldMap;
    }

    /**
     * beforeInsert función para lógica de beforeInsert
     */
	protected override void beforeInsert() {
        MX_SB_VTS_LeadTrigger.evaluateLeads(triggerNewMap);
    }

    /**
     * afterInsert función para lógica de beforeInsert
     */
    protected override void afterInsert() {
        MX_SB_VTS_LeadMultiCTI.validLeadCTI(triggerNewMap);

    }
    /*
    * beforeUpdate función para lógica de beforeUpdate
    */
    protected override void beforeUpdate() {
      MX_SB_VTS_LeadTrigger.substractContactTouch(triggerNewMap, oldMaps);
       MX_SB_VTS_LeadTrigger.substractEffectiveContact(triggerNewMap, oldMaps);
       MX_SB_VTS_LeadTrigger.substractNoEffectiveContact(triggerNewMap, oldMaps);

    }
}