/*******************************************************************************
@Name                   MX_PYME_AccCampTrigHand
Desarrollado por:       Indra
@Author                 Ricardo Almanza
@Date                   2019-01-10
Proyecto:               PYME
@Group                  Trigger AccountCampaign
*************************************************************************************
@Description            Clase extends TriggerHandler, para manejar todos los eventos del
                    Trigger en el objeto Account Campaign (cond__Account_Campaign__c)
*************************************************************************************
@Changes                (most recent first)
2019-02-11              Added updSuccAccCamp
*************************************************************************************
*/
public without sharing class MX_PYME_AccountCampaignHandler_Cls extends TriggerHandler {
    /** Lista lstNewAccCamp*/
    List<cond__Account_Campaign__c> lstNewAccCamp   = (list<cond__Account_Campaign__c>)(Trigger.new);
    /** Lista lstOldAccCamp*/
    List<cond__Account_Campaign__c> lstOldAccCamp   = (list<cond__Account_Campaign__c>)(Trigger.old);
    /** Mapa maNewAccCamp*/
    Map<Id,cond__Account_Campaign__c> mapNewAccCamp = (Map<Id,cond__Account_Campaign__c>)(Trigger.newMap);
    /** Mapa mapOldAccCamp*/
    Map<Id,cond__Account_Campaign__c> mapOldAccCamp = (Map<Id,cond__Account_Campaign__c>)(Trigger.oldMap);
    /*
    @beforeInsert event override en la Clase TriggerHandler
    Logica Encargada de los Eventos BeforeInsert */
    protected override void beforeInsert() {
        MX_PYME_AccCampTrigHand_Cls.CrtCampAccCamp(lstNewAccCamp,lstOldAccCamp);
        cond.AccountCampaignTriggerHandler.concatenateAccountCampaignName(lstNewAccCamp);
        cond.AccountCampaignTriggerHandler.relateAccountsAndCampaigns(lstNewAccCamp);
        cond.AccountCampaignTriggerHandler.changeOwner(lstNewAccCamp, mapOldAccCamp);
        MX_PYME_AccCampTrigHand_Cls.updRecTyAccCamp(lstNewAccCamp);
        MX_PYME_AccCampTrigHand_Cls.updStatAccCamp(lstNewAccCamp);
        MX_PYME_AccCampTrigHand_Cls.updSuccAccCamp(lstNewAccCamp);
    }
    /*
    @beforeUpdate event override en la Clase TriggerHandler
    Logica Encargada de los Eventos BeforeUpdate*/
    protected override void beforeUpdate() {
        MX_PYME_AccCampTrigHand_Cls.updDtEndAccCamp(lstNewAccCamp);
        cond.AccountCampaignTriggerHandler.concatenateAccountCampaignName(lstNewAccCamp);
        cond.AccountCampaignTriggerHandler.changeOwner(lstNewAccCamp, mapOldAccCamp);
        MX_PYME_AccCampTrigHand_Cls.updRecTyAccCamp(lstNewAccCamp);
        MX_PYME_AccCampTrigHand_Cls.updStatAccCamp(lstNewAccCamp);
        MX_PYME_AccCampTrigHand_Cls.updSuccAccCamp(lstNewAccCamp);
    }
    /*
    @beforeDelete event override en la Clase TriggerHandler
    Logica Encargada de los Eventos BeforeDelete*/
    //protected override void beforeDelete() {

    //}

    /*
    @afterInsert event override en la Clase TriggerHandler
    Logica Encargada de los Eventos AfterInsert*/
    protected override void afterInsert() {
        cond.AccountCampaignTriggerHandler.deleteAccountCampaigns(lstNewAccCamp);
        if(!Test.isRunningTest()) {
            cond.AccountCampaignTriggerHandler.generarNotificaciones(lstNewAccCamp);
        }
    }

    /*
    @afterUpdate event override en la Clase TriggerHandler
    Logica Encargada de los Eventos afterUpdate*/
    protected override void afterUpdate() {
        if(!Test.isRunningTest()) {
            cond.AccountCampaignTriggerHandler.afterUpdate(lstNewAccCamp, mapNewAccCamp, mapOldAccCamp);
        }
        cond.AccountCampaignTriggerHandler.approvedAccountCampaign(mapNewAccCamp, mapOldAccCamp);
    }

    /*
    @afterDelete event override en la Clase TriggerHandler
    Logica Encargada de los Eventos afterDelete*/
    //protected override void afterDelete() {

    //}

    /*
    @afterUndelete event override en la Clase TriggerHandler
    Logica Encargada de los Eventos afterUndelete*/
    //protected override void afterUndelete() {

    //}
}