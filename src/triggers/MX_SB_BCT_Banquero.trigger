/*Trigger que ejecuta el proceso de Banquero*/
trigger MX_SB_BCT_Banquero on Banquero__c (before insert) {
	new MX_SB_BCT_BanqueroTriggerHandler().run();
}