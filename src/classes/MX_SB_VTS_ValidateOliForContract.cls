/**
 * @File Name          : MX_SB_VTS_ValidateOliForContract.cls
 * @Description        :
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              :
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 3/10/2019 22:25:36
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    3/5/2019 12:40:00   Jaime Terrats                  Initial Version
 * 1.0    6/5/2019 17:06:57   Eduardo Hernández Cuamatzi     Validación por Tipos de registro para ASD y Telemarketing
 * 1.0    22/5/2019 16:31:42  Eduardo Hernández Cuamatzi     Validación para leads Telemarketing con filtrado de Oportunidades
 * 1.0    20/6/2019 16:31:42  Eduardo Hernández Cuamatzi     Se modifica Query de busqueda.
 * 1.1    2/10/2019 19:45     Jaime Terrats                  Se agrega nuevo record type para generacion de contratos
**/

public without sharing class MX_SB_VTS_ValidateOliForContract {

    private MX_SB_VTS_ValidateOliForContract() {} //NOSONAR

    /** Genera contrato */
    public static void generateContractFromOli(List<OpportunityLineItem> oliToProcess) {
        final List<OpportunityLineItem> validOlis = new List<OpportunityLineItem>();
        final Set<Id> lstOli = new Set<Id>();
        final Set<Id> lstProductOli = new Set<Id>();
        final Set<String> lstClippNums = new Set<String>();
        final Set<Id> lstOppId = new Set<Id>();
        for(OpportunityLineItem oliItem : oliToProcess) {
            lstOli.add(oliItem.OpportunityId);
            lstProductOli.add(oliItem.Product2Id);
        }
        final Map<Id, Opportunity> valuesOpp = new Map<Id, Opportunity>([Select Id, AccountId, Owner.Id,owner.profile.Name, RecordType.DeveloperName from Opportunity where Id IN : lstOli]);
        final Map<Id, Product2> valuesProduct = new Map<Id, Product2>([Select Id, Name, MX_WB_FamiliaProductos__c, MX_WB_FamiliaProductos__r.Name from Product2 where Id IN : lstProductOli]);

        for(OpportunityLineItem oli: oliToProcess) {

            if( String.isNotBlank(oli.MX_WB_noPoliza__c) &&  (System.Label.MX_SB_VTS_RecordTypeASD.equals(valuesOpp.get(oli.OpportunityId).recordType.DeveloperName) ||
            System.Label.MX_SB_VTS_RecordTypeOutOpp.equals(valuesOpp.get(oli.OpportunityId).recordType.DeveloperName) ||
            System.Label.MX_SB_VTS_Telemarketing_LBL.equals(valuesOpp.get(oli.OpportunityId).recordType.DeveloperName))) {
                validOlis.add(oli);
                lstClippNums.add(oli.MX_WB_noPoliza__c);
                lstOppId.add(oli.OpportunityId);
            }
        }
        if(validOlis.isEmpty()==false) {
            final List<Lead> leadsOutbound = [SELECT Id, ConvertedAccountId, MX_WB_RCuenta__c FROM Lead WHERE recordType.developerName = 'MX_WB_rt_Telemarketing'
                AND Id IN (SELECT LeadId FROM CampaignMember WHERE Campaign.isActive=true) AND ConvertedOpportunityId IN : lstOppId];
            MX_WB_contratosOpp_cls.creaContrato(validOlis, valuesOpp, valuesProduct, lstClippNums, leadsOutbound);

        }
    }
}
