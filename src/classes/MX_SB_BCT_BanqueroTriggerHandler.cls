/*
*
* @author Tania Vazquez
* @description Banquero Process
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    04/10/2019     Tania Vazquez     Create Account, Opportunities assignated to Banquero
*/
    public without sharing class MX_SB_BCT_BanqueroTriggerHandler extends TriggerHandler {
        
        /*Lista de banqueros a ser insertaros */
        List<Banquero__c> newBanList;
        
        /*Creacion de la lista de Banqueros a Trabajar*/
        public MX_SB_BCT_BanqueroTriggerHandler() {
            this.newBanList = Trigger.new;
        }
        
        /*Llamado a la funcionalidad de Banquero, creación y asignación de cuentas*/
        protected override void beforeInsert() {
           MX_SB_BCT_Ban_Convert_cls.searchAccountBanquero(newBanList);
        }
        
       
    }