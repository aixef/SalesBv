/**
 * @File Name          : MX_SB_VTS_LeadDeactivation
 * @Description        :
 * @Author             : Jaime Terrats
 * @Group              :
 * @Last Modified By   : Jaime Terrats
 * @Last Modified On   : 8/6/2019
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/6/2019           Jaime Terrats             Creacion de la clase
**/
global class MX_SB_VTS_LeadDeactivation implements Database.Batchable<sObject>, Database.Stateful {//NOSONAR
    /*
    * get campaign ids
    */
    private Set<Id> campId = new Set<Id>(); //NOSONAR
    /*
    * get campaign status
    */
    private Boolean status; //NOSONAR
    /*
    * get new owner id
    */
    private String newOwner; //NOSONAR

    /*
    * @param cmId campaign ids, active campaign status, owner new Owner Id
    */
    public MX_SB_VTS_LeadDeactivation(Set<Id> cmId, Boolean active, Id owner) {
		campId = cmId;
        status = active;
        newOwner = owner;
    }
    /*
    * starts batch class
    */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('Select Id,Status, MX_WB_DisabledByTrigger__c,' +
                                        'OwnerId from Lead where Id IN:campId AND IsConverted = False');
    }
    /*
    * process update
    */
    global void execute(Database.BatchableContext bc, List<Lead> records) {
        final List<Lead> leadsToUpdate = new List<Lead>();
        for(Lead lead : records) {
            lead.MX_WB_DisabledByTrigger__c = status;
            lead.OwnerId = newOwner;
            leadsToUpdate.add(lead);
        }
        Database.update(leadsToUpdate);
    }
    /*
    * saves operation log
    */
    global void finish(Database.BatchableContext bc) {
    	final AsyncApexJob asyncJob = [select Id, Status, NumberOfErrors,
            				JobItemsProcessed, TotalJobItems, CreatedBy.Email
            				from AsyncApexJob where Id = :bc.getJobId()];

        WB_CrearLog_cls.fnCrearLog(asyncJob.status, 'Desactivacion de Campanias', false);
    }
}
