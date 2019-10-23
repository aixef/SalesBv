/**
* ------------------------------------------------------------------------------------------------
* @Name     MX_PYME_Acc_OwnerAssignment_cls
* @Author   Jhovanny De La Cruz Cruz jhovanny.delacruz.contractor@bbva.com
* @Date     Created: 2019-02-06
* @Group    Assignment owners to new clients loaded in salesforce
* @Description Owners are assigned uniquely and massively of SME type clients
* @Changes
*
*  |2019-02-06  jhovanny.delacruz.contractor@bbva.com
*               Creation MX_PYME_Acc_OwnerAssignment_cls functionality class
*  |2019-04-01  Daniel García
*               Validations added for records of type "MASA_PYME"
*/
public with sharing class MX_PYME_Acc_OwnerAssignment_Cls {

    private MX_PYME_Acc_OwnerAssignment_Cls() {
    }

    /*------------------------------------------------------------------------------------------------------
*@Description The method will assign owners to new clients loaded in salesforce
* -----------------------------------------------------------------------------------------------------
* @Author   Jhovanny De La Cruz Cruz
* @Date     2019-02-06
* @param    TriggerNew List of new Accounts SME
* @return   void
* @example  MX_PYME_Acc_OwnerAssignment_cls.ownerAssignment(newAccounts);
* */
    public static void ownerAssignment(List<Account> TriggerNew) {
        Set<String> pymeMBs = new Set<String>();
        List<Account> filterAcc = managePYMEAccounts(TriggerNew);
        for(Account acc : filterAcc) {
            pymeMBs.add(acc.BPyP_tx_ActividadGiro__c);
        }
        assignOwnerPerActivity(filterAcc, pymeMBs);
    }

    private static List<Account> managePYMEAccounts(List<Account> TriggerNew) {
        User []usuMasa = [Select id from User where CommunityNickname = 'NoCarPyME' Limit 1];
        List<Account> filterAcc = new List<Account>();
        for (Account acc: TriggerNew) {
            if('PYME'.equals(acc.Tipo_de_Registro_Manual__c)) {
                if(String.isBlank(acc.BPyP_tx_ActividadGiro__c)) {
                    acc.BPyP_tx_ActividadGiro__c.addError(Label.MX_PyME_Error_9_Referencia_a_propietario_del_cliente);
                }else {
                    filterAcc.add(acc);
                }
            }else if('MASA_PYME'.equals(acc.Tipo_de_Registro_Manual__c)) {
                acc.Razon_social__c = acc.Name;
                acc.OwnerId = usuMasa[0].Id;
                acc.RecordTypeId = RecordTypeMemory_cls.getRecType('Account','VP_tre_Cliente_PyME');
                acc.Tipo_de_Registro_Manual__c = '';
            }
        }
        return filterAcc;
    }

    private static void assignOwnerPerActivity(List<Account> filterAcc, Set<String> pymeMBs) {
        List<User> pymesSalesRep = new List<User>();
        if(!pymeMBs.isEmpty()) {
            pymesSalesRep = [SELECT id,Name,FederationIdentifier FROM User WHere FederationIdentifier IN:pymeMBs AND isActive = true];
        }
        Map<String,String> mbids = new Map<String,String>();
        if(!pymesSalesRep.isEmpty()) {
            for(User us:pymesSalesRep) {
                mbids.put(us.FederationIdentifier, us.id);
            }
        }
        if(!mbids.isEmpty() && !filterAcc.isEmpty()) {
            for(Account acc: filterAcc) {
                acc.OwnerId = mbids.get(acc.BPyP_tx_ActividadGiro__c);
                acc.Tipo_de_Registro_Manual__c = '';
                acc.RecordTypeId = RecordTypeMemory_cls.getRecType('Account','VP_tre_Cliente_PyME');
            }
        }
    }
}