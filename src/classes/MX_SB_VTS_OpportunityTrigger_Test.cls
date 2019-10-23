/*
* BBVA - Mexico
* @Author: Jaime Terrats
* MX_SB_VTS_OpportunityTrigger_Test
* @Version 1.0
* @LastModifiedBy: Jaime Terrats
* @ChangeLog
* 1.0 Add coverage methods - Jaime Terrats
*/
@isteST
private class MX_SB_VTS_OpportunityTrigger_Test {
	/*UserNAme*/
    final static String TUSERNAME = 'test Opp Trigger';
	/* Msj Assert */
    final static String ASSERTMESG = 'Exito';
	/*
	 * Make data method
	 */
    @TestSetup
    static void makeData() {
    	final User tUser = MX_WB_TestData_cls.crearUsuario(TUSERNAME, System.Label.MX_SB_VTS_ProfileAdmin);
    	insert tUser;
        System.runAs(tUser) {
            final Account accToAssign = MX_WB_TestData_cls.crearCuenta('Doe', 'PersonAccount');
            accToAssign.PersonEmail = 'test@test.com.oppTriggerTest';
            insert accToAssign;
            
            final Opportunity oppToTest = MX_WB_TestData_cls.crearOportunidad(TUSERNAME, accToAssign.Id, tUser.Id, System.Label.MX_SB_VTS_Telemarketing_LBL);
            oppToTest.Producto__c = 'Hogar';
            oppToTest.Reason__c = 'Venta';
            insert oppToTest;
        }
    }
    @isTest
    private static void testSubstractContactTouchOpp() {
        Test.startTest();
        final Opportunity opp = [Select Id, RecordTypeId, MX_SB_VTS_Llamadas_Efectivas__c, MX_SB_VTS_Tipificacion_LV1__c, MX_SB_VTS_Tipificacion_LV2__c, MX_SB_VTS_ContadorRemarcado__c from Opportunity where Name =: TUSERNAME];
        final Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>();
        final List<Opportunity> newList = new List<Opportunity>();
        oldMap.put(opp.Id, opp);
        opp.MX_SB_VTS_Tipificacion_LV1__c = 'No Contacto';
        opp.MX_SB_VTS_Tipificacion_LV2__c = 'No Contacto';
        newlist.add(opp);
        MX_SB_VTS_OpportunityTrigger.substractContactTouchOpp(newList, oldMap);
        System.assertEquals(null, opp.MX_SB_VTS_ContadorRemarcado__c, ASSERTMESG);
        Test.stopTest();
    }
    @isTest
    private static void testSubstractEffectiveContactOpp() {
        Test.startTest();
        final Opportunity opp = [Select Id, RecordTypeId, MX_SB_VTS_Llamadas_Efectivas__c, MX_SB_VTS_Tipificacion_LV1__c, MX_SB_VTS_Tipificacion_LV2__c, MX_SB_VTS_ContadorRemarcado__c from Opportunity where Name =: TUSERNAME];
        final Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>();
        final List<Opportunity> newList = new List<Opportunity>();
        oldMap.put(opp.Id, opp);
        opp.MX_SB_VTS_Tipificacion_LV1__c = 'Contacto';
        opp.MX_SB_VTS_Tipificacion_LV2__c = 'Contacto Efectivo';
        newlist.add(opp);
        MX_SB_VTS_OpportunityTrigger.substractEffectiveContactOpp(newList, oldMap);
        System.assertEquals(null, opp.MX_SB_VTS_Llamadas_Efectivas__c, ASSERTMESG);
        Test.stopTest();
    }
}