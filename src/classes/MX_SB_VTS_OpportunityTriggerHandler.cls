/*
 *  @author: Jaime Terrats
 *  @description: Opportunity Trigger handler
 *  @version: 1.0
 *
 *__________________________________________________________________________________________________
 * @version                Author                      date								description
	1.1					Jaime Terrats					20/06/2019 					Se agrega un nuevo metodo detonante.
    1.2                 Diego Olvera                    03/10/2019                  Se agrega metodo para accionar contador.
 */

public without sharing class MX_SB_VTS_OpportunityTriggerHandler extends TriggerHandler {
    /*variable de almacenamiento trriger New*/
    final private List<Opportunity> triggerNewMap;
	/* variable global oldMap*/
    final private Map<Id, Opportunity> oldMaps;

    /**Lista de Oportunidades*/
	private List<Opportunity> newOppList;

    /**
     * MX_SB_VTS_OpportunityTriggerHandler constructor
     * @return   Constructor de clase
     */
    public MX_SB_VTS_OpportunityTriggerHandler() {
        this.newOppList = Trigger.new;
        this.triggerNewMap = Trigger.new;
        this.oldMaps = (Map<Id, Opportunity>)Trigger.oldMap;
    }

    /**
     * beforeInsert Override de before Insert
     */
    protected override void beforeInsert() {
        MX_SB_VTS_CierreOpp.validNamesOppASD(newOppList);
    }

    /*
	 * Process before update logic
	 */
    protected override void beforeUpdate() {
        MX_SB_VTS_CierreOpp.validaCierre(newOppList);
        MX_SB_VTS_OpportunityTrigger.substractContactTouchOpp(triggerNewMap, oldMaps);
        MX_SB_VTS_OpportunityTrigger.substractEffectiveContactOpp(triggerNewMap, oldMaps);
        MX_SB_VTS_OpportunityTrigger.substractNoEffectiveContactOpp(triggerNewMap, oldMaps);
    }

}