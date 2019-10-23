/**
 * @File Name          : MX_SB_VTS_OLITriggerHandler.cls
 * @Description        : 
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              : 
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 9/5/2019 15:16:10
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    3/5/2019 12:40:00   Jaime Terrats                  Initial Version
 * 1.0    6/5/2019 17:00:52   Eduardo Hernández Cuamatzi     Se elimina Method de after Delete
 * 1.1    21/5/2019 17:00:52   Arsenio Perez Lopez     code smell
**/

public without sharing class MX_SB_VTS_OLITriggerHandler extends TriggerHandler {
    /*variable de almacenamiento.*/
    final private List<OpportunityLineItem> newOli;
    /*Constructor*/
    public MX_SB_VTS_OLITriggerHandler() {
        super();
        this.newOli = Trigger.new;
    }
    /* Method para ejecutar en el contesto after update*/
    protected override void afterUpdate() {
        MX_SB_VTS_ValidateOliForContract.generateContractFromOli(newOli);
    }
    /* Method para ejecutar en el contesto after Insert*/
    protected override void afterInsert() {
        MX_SB_VTS_ValidateOliForContract.generateContractFromOli(newOli);
    }
}