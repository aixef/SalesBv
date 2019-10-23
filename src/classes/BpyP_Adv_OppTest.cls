/**
* Fecha            Autor               Descripción
* 12/18/2017       Ricardo Almanza     Creación de la clase de prueba para Avanzar oportunidad en BPyP
* 01/30/2018       Ricardo Almanza     Mejora para regla de validación que bloquea el modificar un campo después de cerrar oportunidad
* 02/06/2018       Ricardo Almanza     Bloquear cierre de oportunidad si no se es perfil Estandar o DO
* 02/08/2018       Ricardo Almanza     Asigna numero de cliente, si ya existe lo busca y asigna lo del prospecto al cliente,
* 02/23/2018       Ricardo Almanza     se creo metodo para obtener usuario que lo ejecuta y poder bloquear la actualización,
* 25/06/2018		Ricardo Hernandez	Se Corrige error, Se sube cobertura y se actualiza la versión API 43
* 25/09/2018		Cristian Espinosa	Se elimina dependencia a campo Producto_BEyG__c del objeto Opportunity
* 12/24/2018       Mario Calderón      Se agrega un parámetro de entrada al método que actualiza una oportunidad para recibir bandera de bypass
* 12/28/2018       Mario Calderón      Se creó método que prueba el descarte de una oportunidad con motivo de descarte "Otros factores" y
											con Otro motivo de descarte.
* 18/01/2019		Adrian Pastor		Se crea un metodo testObjects() para insertar un cliente ligado a una oportunidad
*
*/
@isTest
private class BpyP_Adv_OppTest {
	/** String Usuario */
	static final String STGUSUARIO = 'Usuario';
	/** String BPyP Estandar */
	static final String STGBPYPESTANDAR = 'BPyP Estandar';
	/** String EMPRESARIAL */
	static final String STGEMPRESARIAL = 'EMPRESARIAL';
	/** Opportunidad */
	static final String STGOPPORTUNIDAD = 'Oportunidad';
	/** Colocación */
	static final String STGCOLOCACION = 'Colocación';
	/** Collares */
	static final String STGCOLLARES = 'Collares';
	/** MX_BPP_RedBpyp */
	static final String STGRTOPP = 'MX_BPP_RedBpyp';
	/** Decimal AMM2 */
	static final Decimal AMM2;

	static testMethod void testObjects() {
		final User user = UtilitysDataTest_tst.crearUsuario(STGUSUARIO, STGBPYPESTANDAR, Null);
        user.Segmento_Ejecutivo__c = STGEMPRESARIAL;
        insert user;
		System.runAs(user) {
			final Account cliente = UtilitysDataTest_tst.crearCuenta('userBPyP','BPyP_tre_Cliente');
            cliente.MX_BPP_CPC_CheckClienteCPC__c = false;
            insert cliente;
            UtilitysDataTest_tst.crearProdForm(STGCOLOCACION, STGCOLLARES);
			final Opportunity opp = UtilitysDataTest_tst.crearOportunidad(STGOPPORTUNIDAD, cliente.id, user.id, STGCOLOCACION, STGCOLLARES, null, STGRTOPP);
        	insert opp;
        	String oppId2;
			oppId2 = opp.id+'';
			String stgNm;
			stgNm = 'Cerrada Ganada';
			String clNum;
			clNum = cliente.No_de_cliente__c;
			Boolean bypass;
			bypass = true;
	    	createData('',user,cliente);
			Decimal amm;
			amm = 123.00;
	    	Test.startTest();
			final List<Opportunity> resultUpdOpp = BpyP_Adv_Opp.updOpp(oppId2,stgNm,clNum,amm,bypass,'','').resopp;
            System.debug('Resultado: '+resultUpdOpp);
    		System.assertNotEquals(null,resultUpdOpp,'updOpp successful');
			Test.stopTest();
		}
    }
	static testMethod void testGetMotivoDescarte() {
      final User user = UtilitysDataTest_tst.crearUsuario(STGUSUARIO, STGBPYPESTANDAR, Null);
      user.Segmento_Ejecutivo__c = STGEMPRESARIAL;
      insert user;
      final Account cliente = crearCliente(user,'');
      UtilitysDataTest_tst.crearProdForm(STGCOLOCACION, STGCOLLARES);
      final Opportunity opp = UtilitysDataTest_tst.crearOportunidad(STGOPPORTUNIDAD, cliente.id, user.id, STGCOLOCACION, STGCOLLARES, null, STGRTOPP);
      insert opp;
      createData('',user,cliente);
      Test.startTest();
      System.runAs(user) {
    	final List<MX_BPP_Motivos_Descarte__c> resultgetMotivos = BpyP_Adv_Opp.motivosDescarte('Captacion - 1');
        System.assertNotEquals(null,resultgetMotivos,'Fetch Opportunity successful');
      }
      Test.stopTest();
    }
	static Account crearCliente(User iUser, String opt) {
		final Id rec = RecordTypeMemory_cls.getRecType('Account','BPyP_tre_Cliente');
		final Id rec2 = RecordTypeMemory_cls.getRecType('Account','BPyP_tre_noCliente');

		final Account outAcc= new Account();
		outAcc.Name='a';
		outAcc.RecordTypeId=''.equals(opt)?rec:rec2;
		outAcc.Owner=iUser;
		outAcc.OwnerId=iUser.Id;
		if (''.equals(opt)) {
			outAcc.No_de_cliente__c = '12345678';
		}
		Insert outAcc;
		return outAcc;
	}

	static void createData(String opt, User iUser, Account iAcc) {

		final BPyP0023_CPC__c cpc=new BPyP0023_CPC__c();
		cpc.RecordTypeId = RecordTypeMemory_cls.getRecType('BPyP0023_CPC__c','BPyP0023_tre_CPC');
		cpc.BPyP0023_rb_Cuenta__c = iAcc.Id;
		Insert cpc;

		crearTarea(iAcc.Id,'');

		if(''.equals(opt)) {
			crearContacto(iAcc);
		}

	}

  	static void crearTarea(String strTarea,String val) {
		final Task tarea = new Task();
			tarea.Type='Visita comercial'+strTarea;
			tarea.Subject = 'Tarea'+strTarea;
			if(''.equals(val)) {
				tarea.WhatId = strTarea;
			} else {
				tarea.whoId = strTarea;
			}
			tarea.IsRecurrence=false;
			tarea.Id_externo_Google__c='jha'+strTarea;
			tarea.ActivityDate=Date.today().addDays(2);
        	tarea.Status = 'Abierto';
		insert tarea;
	}

  	static void crearContacto(Account acc) {
		// insert new VariablesGlobales__c(
		// 	Name ='Usr_Tecom_Var_Glb',
		// 	Num_Max_Cnt_Tecom_ERRORmsg__c = 'Variable Globales',
		// 	Num_Max_Cnt_Tecom__c = 12
		// );
		final Contact nCont= new Contact ();
			nCont.FirstName = 'xyzFirst';
			nCont.LastName = 'XyZLast';
			nCont.AccountId = acc.ID;
			nCont.Email = 'xyzmail@mail.com';
		insert nCont;
  	}


    /**
     * This is a test method for fetchOpp
     */
    static testMethod void testfetchOpp() {

    	final User user = UtilitysDataTest_tst.crearUsuario(STGUSUARIO, STGBPYPESTANDAR, Null);
        user.Segmento_Ejecutivo__c = STGEMPRESARIAL;
        insert user;
    	final Account cliente = crearCliente(user,'');
		UtilitysDataTest_tst.crearProdForm(STGCOLOCACION, STGCOLLARES);
    	final Opportunity opp = UtilitysDataTest_tst.crearOportunidad(STGOPPORTUNIDAD, cliente.id, user.id, STGCOLOCACION, STGCOLLARES, null, STGRTOPP);
        insert opp;
        final String oppId = opp.id+'';
    	createData('',user,cliente);
    	Test.startTest();
    	System.runAs(user) {
    		final Opportunity resultFetchOpp = BpyP_Adv_Opp.fetchOpp(oppId);
			final User resultfetchUsr = BpyP_Adv_Opp.fetchUsr();
			System.assertNotEquals(null,resultFetchOpp,'Fetch Opportunity successfull');
			System.assertNotEquals(null,resultfetchUsr,'Fetch User successfull');
    	}

        Test.stopTest();
    }

	static testMethod void testUpdOppBpyP() {
        final User user = UtilitysDataTest_tst.crearUsuario(STGUSUARIO, STGBPYPESTANDAR, Null);
        user.Segmento_Ejecutivo__c = STGEMPRESARIAL;
        insert user;
        System.runAs(user) {
            final Account cliente = crearCliente(user,'');
            UtilitysDataTest_tst.crearProdForm(STGCOLOCACION, STGCOLLARES);
            final Opportunity opp = UtilitysDataTest_tst.crearOportunidad(STGOPPORTUNIDAD, cliente.id, user.id, STGCOLOCACION, STGCOLLARES, null, STGRTOPP);
            insert opp;
            String oppId, stgNm , clNum;
			oppId = opp.id+'';
			stgNm = 'Descartada / Rechazada';
			clNum = '4tpdOt2';
            Boolean bypass;
			bypass = true;
            createData('',user,cliente);
            Test.startTest();
            final BPyP_Adv_Opp.Result result=BpyP_Adv_Opp.updOpp(oppId,stgNm,clNum,AMM2,bypass,'Otros factores (campo abierto)','Prueba otro motivo de descarte');
			final List<Opportunity> resultUpdOpp = result.resopp;
            System.assertNotEquals(null,resultUpdOpp,'updOpp successful');
            Test.stopTest();
        }
    }

}