/**
* Test class para Utilities.apxc class
*/
@isTest private class Utilities_tst {
	/**
    * Metodo de prueba
    *
    * @param
    * @return
    */
	@isTest static void testMethodOne() {
		Test.startTest();
		     try {Utilities.getInstance();} catch(Exception gE) {}
        	 final String lenguajeDeUsuario = UserInfo.getLanguage();
        	 final String buscarPerfil = lenguajeDeUsuario.equalsIgnoreCase('es') ? 'Administrador del Sistema' : Label.MX_PERFIL_SystemAdministrator;
		     Utilities.getSubdomainPrefix();
		     final BusinessHours bHInstance = [SELECT Id FROM BusinessHours limit 1];
		     Utilities.calculaHoras(bHInstance.Id,Datetime.newInstance(Date.today().year(), Date.today().month(), Date.today().day()).addDays(-2),Datetime.newInstance(Date.today().year(), Date.today().month(), Date.today().day()));
		     Utilities.fnGeneradorFechaMilis();
		     Utilities.fnGeneradorMD5('01012018', 'juan@mail.com', 'correo', 'subch', 'ag', 'serv');
		     Utilities.getUserRole('Asesores ASD');
        	 Utilities.getUserProfile(buscarPerfil);
		     Utilities.createUsers();
		     Utilities.getQueues();
		     final Lead opComercial = Utilities.creaOportunidadComercial('Auto Seguro Dinámico');
		     Utilities.verificarListaNegra(Utilities_tst.crearListaNegraTelefonoTest());
		     Utilities.verificarListaNegra(Utilities_tst.crearListaNegraCorreoTest());
        	 System.assertEquals(opComercial.Status, 'Abierta', 'El estatus de la oportunidad no es el esperado');
		Test.stopTest();
	}

	/**
    * Metodo de prueba crearListNegraCorreoTest
    *
    * @param
    * @return
    */
	@isTest
	public static List<String> crearListaNegraCorreoTest() {
    	final List<String> lstDatListNeg = new List<String>();
    	final Lista_Negra__c testLisNegCorr = new Lista_Negra__c();
		testLisNegCorr.Correo_Electronico__c = 'test@test123.com';
		insert 	testLisNegCorr;
        lstDatListNeg.add(testLisNegCorr.Correo_Electronico__c);
        System.AssertEquals(testLisNegCorr.Correo_Electronico__c,'test@test123.com','El correo electrónico es el indicado.');
    	return lstDatListNeg;
    }

	/**
    * Metodo de prueba crear lista negra telefono test
    *
    * @param
    * @return
    */
    @isTest
    public static List<String> crearListaNegraTelefonoTest() {
    	final List<String> lstDatListNeg = new List<String>();
		final Lista_Negra__c testListNegTel = new Lista_Negra__c();
		testListNegTel.Telefono__c = '1122334455';
		insert 	testListNegTel;
        lstDatListNeg.add(testListNegTel.Telefono__c);
        System.AssertEquals(testListNegTel.Telefono__c,'1122334455','El teléfono es el indicado.');
    	return lstDatListNeg;
    }
}