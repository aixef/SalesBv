/*******************************************************************************
@Name                   MX_AccountCampaign_tgr
Desarrollado por:       Indra 
@Author                 Ricardo Almanza
@Date                   2019-01-10
Proyecto:               PYME
@Group                  Trigger AccountCampaign
*************************************************************************************
@Description            Trigger AccountCampaign
**************************************************************************************/
trigger MX_AccountCampaign_tgr on cond__Account_Campaign__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new MX_PYME_AccountCampaignHandler_Cls().run();
}