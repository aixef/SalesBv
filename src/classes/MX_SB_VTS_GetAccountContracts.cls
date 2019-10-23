/**
* BBVA - Mexico
* @Author: Jaime Terrats
* @Description: Controller for lwc mX_SB_VTS_GetAcccountContracts to retrieve all
*               the contracts from the account and show them as a related list in the
*               Opportunity Layout
* @Version: 1.0
**/
public without sharing class MX_SB_VTS_GetAccountContracts {
    /**
    * constructor
    */
    private MX_SB_VTS_GetAccountContracts() {} //NOSONAR

    /**
    * @method: fetchActiveContractsByAccount
    * @description returns a list of contracts
    * @param: oppId
    **/
    @AuraEnabled
    public static List<Contract> fetchActiveContractsByAccount(Id oppId) {
        List<Contract> activeContracts = new List<Contract>();
        try {
            final Id accId = [Select AccountId from Opportunity where Id =: oppId].AccountId;
            activeContracts = [Select Id, MX_WB_noPoliza__c, MX_WB_Producto__r.Name, CreatedDate from Contract where AccountId =: accId and Status = 'Activated'];
        } catch(System.QueryException qEx) {
            throw new AuraHandledException(System.Label.MX_WB_LG_ErrorBack + qEx);
        }

        return activeContracts;
    }
}
