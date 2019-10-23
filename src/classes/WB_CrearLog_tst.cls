@isTest
/** Clase WB_CrearLog_tst */
private class WB_CrearLog_tst {

	@isTest static void testMethodOne() {
		WB_CrearLog_cls.fnCrearLog('Test', 'Prueba', false);

        final List<WB_Log__c> listaLogs = [SELECT ID FROM WB_Log__c WHERE WB_Rta__c = false AND WB_Servicio_Web__c = 'Prueba' LIMIT 1];
        System.assertEquals(listaLogs.size(), 1, 'Log de prueba no fue encontrado/insertado');
	}
}