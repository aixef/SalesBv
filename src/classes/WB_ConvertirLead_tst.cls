/****************************************************************************************************
    Información general
    -------------------
    author: Javier Armando Tibamoza Cubillos
    email: jtibamoza@avanxo.com
    company: Avanxo Colombia
    Project: Implementación Salesforce
    Customer: WIBE
    Description: Crear clase de prueba

    Information about changes (versions)
    -------------------------------------
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------
    1.0       08-Mar-2016     Javier Tibamoza              Creación de la Clase
	1.1		  07-Feb-2018	  Eduardo Barrera			   Se agregan asserts en metodos de prueba
****************************************************************************************************/
@isTest
private class WB_ConvertirLead_tst {
    /**Numero para pruebas.*/
	public static final String NUMEROPRUEBA = '1234567890';
	@isTest
    static void testMethodOne() {

	    final String vaRtOppVenta = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ASD').getRecordTypeId();

    	//Inicia las pruebas
    	Test.startTest();

	        final String sClaveDistPaso = String.valueOf(Math.random());
	        final String sNoPoliza = sClaveDistPaso.substring(0, 10).replace('.', '0');
	       	System.debug('ENTRO A CreaOportunidad sNoPoliza: ' + sNoPoliza);

		    //Crea el cliente
			final List<Account> lCliente = TestCreaObjetos_cls.CreaClienteC(1, null);
			final Opportunity objOpp = WB_CrearData_cls.getOportunidad(lCliente.get(0), sNoPoliza, 'PRODUCTO');
			objOpp.RecordTypeId = vaRtOppVenta;
			objOpp.NumerodePoliza__c = sNoPoliza;
			insert  objOpp;

	        final Lead objLead = WB_CrearData_cls.getLead();
	        objLead.Company = 'Compañia';
	        objLead.OwnerId = UserInfo.getUserId();
			objLead.LeadSource = 'Outbound TLMK';
	        insert objLead;

			//Crea el ctrl
	        final WB_ConvertirLead_ctr ctrl = new WB_ConvertirLead_ctr( new ApexPages.Standardcontroller( objLead ) );
	        ctrl.fnConvertir();
        	final Opportunity opp = [SELECT ID, Name, AccountId, OwnerId FROM Opportunity WHERE OwnerId =: objLead.OwnerId LIMIT 1];
        	System.assertEquals(objLead.OwnerId, opp.OwnerId , 'La oportunidad en la conversión de Lead no fue creada correctamente');
        	//Llama fnVolver
	        ctrl.fnVolver();

        	//Llama de nuevo a la funcion y he inciaiza los datos
        	objLead.TelefonoCelular__c = NUMEROPRUEBA;
			objLead.Email = 'prueba@hotmail.com';
			objLead.Folio_Cotizacion__c = objOpp.FolioCotizacion__c;
        	objLead.Producto_Interes__c = 'Seguro de Moto Bancomer';
			System.debug('EN WB_ConvertirLead_tst.test_method_one ANTES DE UPD objLead.');
        	//Actualiza
			update objLead;
			//Crea el ctrl
	        final WB_ConvertirLead_ctr ctrl2 = new WB_ConvertirLead_ctr( new ApexPages.Standardcontroller( objLead ) );
			//Llama a fnConvertir
        	ctrl2.fnConvertir();

    	//Termina la prueba
    	Test.stopTest();

    }

    @isTest
    static void testMethodTwo() {

	    final String vaRtOppVenta = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ASD').getRecordTypeId();

    	//Inicia las pruebas
    	Test.startTest();

	        final String sClaveDistPaso = String.valueOf(Math.random());
	        final String sNoPoliza = sClaveDistPaso.substring(0, 10).replace('.', '0');
	       	System.debug('ENTRO A CreaOportunidad sNoPoliza: ' + sNoPoliza);

		    //Crea el cliente
			final List<Account> lCliente = TestCreaObjetos_cls.CreaClienteC(1, null);
			//La lista para los Opportunity
			final Opportunity objOpp = WB_CrearData_cls.getOportunidad(lCliente.get(0), sNoPoliza, 'PRODUCTO');
			objOpp.RecordTypeId = vaRtOppVenta;
			objOpp.NumerodePoliza__c = sNoPoliza;
			insert  objOpp;
			//Agregala a la lista

	        final Lead objLead = WB_CrearData_cls.getLead();
	        objLead.Company = 'Compañia_2';
	        objLead.OwnerId = UserInfo.getUserId();
			objLead.LeadSource = 'Outbound TLMK';
	        insert objLead;

			System.debug('EN WB_ConvertirLead_tst.test_method_one ANTES DE UPD lCliente.get(0).');
        	//Actualiza los datos del cliente
        	lCliente.get(0).Correo_Electronico__c = 'prueba@hotmail.com';
            update lCliente.get(0);
        	//Llama de nuevo a la funcion y he inciaiza los datos
        	objLead.FirstName = 'Prueba';
        	objLead.LastName = 'Prueba';
        	objLead.Phone = NUMEROPRUEBA;
        	objLead.TelefonoCelular__c = NUMEROPRUEBA;
			objLead.Email = 'prueba@hotmail.com';
        	objLead.Producto_Interes__c = 'Seguro de Moto Bancomer';
			objLead.Folio_Cotizacion__c = NUMEROPRUEBA;
			System.debug('EN WB_ConvertirLead_tst.test_method_one ANTES DE UPD objLead.');
        	//Actualiza
			update objLead;
			//Crea el ctrl
	        final WB_ConvertirLead_ctr ctrl3 = new WB_ConvertirLead_ctr( new ApexPages.Standardcontroller( objLead ) );
			//Llama a fnConvertir
        	ctrl3.fnConvertir();
        	final Opportunity opp = [SELECT ID, Name, AccountId, OwnerId FROM Opportunity WHERE OwnerId =: objLead.OwnerId LIMIT 1];
        	System.assertEquals(objLead.OwnerId, opp.OwnerId , 'La oportunidad en la conversión de Lead no fue creada correctamente');
        	//Un constructor para wrpCliOpp con parametros
			//final WB_ConvertirLead_ctr.oCliOpp wrpCliOpp = new WB_ConvertirLead_ctr.oCliOpp(lCliente.get(0).id, lOportunidad.get(0).id);

    	//Termina la prueba
    	Test.stopTest();

    }

}