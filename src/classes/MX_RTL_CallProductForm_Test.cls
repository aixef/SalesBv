/**_____________________________________________________________________________________
*MX_RTL_CallProductForm_Test
*Proyecto:      Migracion Salesforce Retail
*Descripción:   Clase de prueba para MX_RTL_CallProductForm
*_______________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        10/09/2019     Jair Ignacio Gonzalez                  Creación.
**/
@isTest
public class MX_RTL_CallProductForm_Test {

    /**
     * *Descripción: Clase de prueba para MX_RTL_CallProductForm
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

            final Opportunity opp = UtilitysDataTest_tst.crearOportunidad('Test 001', acc.Id, UserInfo.getUserId(), 'Colocación', 'Collares', null, 'MX_BPP_RedBpyp');
            insert opp;
        	String stgOppId = opp.Id;
        	Test.startTest();

        	final Opportunity objOpp = MX_RTL_CallProductForm.getOpp(stgOppId);
        	stgOppId = objOpp.Id;
        	final Integer intFds = MX_RTL_CallProductForm.getProdConf(stgOppId);
        	MX_RTL_CallProductForm.updCheckOpp(stgOppId);
        	System.assert(intFds > 0, 'Se crea su Product Configuration');
        	Test.stopTest();

        }
}