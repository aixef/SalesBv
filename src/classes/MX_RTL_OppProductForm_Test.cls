/**
* MX_RTL_OppProductForm_Test
* Proyecto:      Migracion Salesforce Retail
* Descripción:   Clase de prueba para MX_RTL_OppProductForm
*
* Versión    Fecha           Autor                               Descripción
* 1.0        10/09/2019     Jair Ignacio Gonzalez                  Creación.
**/
@isTest
private class MX_RTL_OppProductForm_Test {
    
    /**
     * *Descripción: Clase de prueba para MX_RTL_OppProductForm y MX_RTL_OppProductForm_helper
    **/
    static testMethod void insOpp() {
        final Id personAccountRTId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get('MX_BPP_PersonAcc_NoClient').getRecordTypeId();
        final Account acc = new Account();
        acc.FirstName = 'Justino';
        acc.LastName = 'Flores';
        final Double ramdomNoCliente = Math.random()*10000000;
        acc.No_de_cliente__c = String.valueOf(ramdomNoCliente.round());
        acc.PersonBirthdate = System.today();
        acc.MX_Occupation__pc = 'ABARROTES';
        acc.MX_OccupationCode__pc = 'ABT';
        acc.RecordTypeId = personAccountRTId;
        insert acc;
        
        UtilitysDataTest_tst.crearProdForm('Colocación', 'Collares');
        
        Test.startTest();
        final Opportunity opp = UtilitysDataTest_tst.crearOportunidad('Test 001', acc.Id, UserInfo.getUserId(), 'Colocación', 'Collares', null, 'MX_BPP_RedBpyp');
        insert opp;
        opp.StageName = 'En Gestión';
        update opp;
        System.assertNotEquals(opp.Id, null);
        Test.stopTest();
    }

}