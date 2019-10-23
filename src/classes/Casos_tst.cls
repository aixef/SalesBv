/*----------------------------------Desarrollado por INDRA-------------------------------------
*Autor:         	Sergio Andres Ortiz
*Proyecto:      	Salud ORG
*Descripción:   	Clase de prueba para el trigger Casos_tgr,  y sus metodos
* 					definidos en la clase Case_Handler_cls y Case_cls
*______________________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        11/ABR/2018     Sergio Andres Ortiz                 Creación de la clase.
*1.1        09/MAYO/2018    Hector Michel Diaz                 	Metodo para traspaso de banca.
*1.2        23/MAYO/2018    Eulises Aguilar Rodriguez           Metodo para cambio de segmento.
*1.2        01/JUN/2018     Eulises Aguilar Rodriguez           Metodo para clientes masa.
*1.3        01/OCT/2018     Fernando Jaime						Se cambia Administrador del sistema por etiqueta personalizada
*2.0        10/JUL/2019     Cindy Hernández						Se eliminan todos los métodos isTest y se crea el método cambioPropietarioPyMETest
																y el método createCaseTeamMemeberTest.
-----------------------------------------------------------------------------------------------*/
@isTest
private class Casos_tst {
	/**variable usuarioAdmin */
	private static User usuarioAdmin;
	/** variable usuario2*/
    private static User usuario2;
	/** variable usuario3*/
    private static User usuario3;
	/** variable cliente2*/
    private static Account cliente2;
	/** variable strDMLExeption*/
    private static String strDMLExeption = 'DML exception ';

	private static void crearDatos() {
		//Crear usuario administrador
		usuarioAdmin = UtilitysDataTest_tst.crearUsuario('PruebaAdm', Label.MX_PERFIL_SystemAdministrator, 'BBVA ADMINISTRADOR');
		insert usuarioAdmin;

		System.runAs(usuarioAdmin) {
			//Crear usuarios
			usuario2 = UtilitysDataTest_tst.crearUsuario('PruebaEmp2', 'BPyP Director Oficina', 'BPYP DIRECTOR OFICINA LOMAS');
			usuario2.VP_ls_Banca__c = 'Red PyME';
			usuario2.Divisi_n__c = 'SUR PYME';
            insert usuario2;
			usuario3 = UtilitysDataTest_tst.crearUsuario('CLIENTES MASA', 'BPyP Estandar', 'BPYP BANQUERO PRIVADO y UHN LOMAS');
			usuario3.VP_ls_Banca__c = 'Red PyME';
			usuario3.Divisi_n__c = 'SUR PYME';
            usuario3.Director_divisional__c = usuario2.Id;
            insert usuario3;
			//Crear clientes
			cliente2 = UtilitysDataTest_tst.crearCuenta('PruebaCliente2', 'BPyP_tre_Cliente');
			cliente2.OwnerId = usuarioAdmin.Id;
			cliente2.Segmento__c = 'MEDIANA EMP';
            cliente2.No_de_cliente__c = '234';
            cliente2.Cuentas_Bloqueadas__c = false;
            insert cliente2;

		}
	}

    /**
    * @Method:      crearCaso
    * @param:       Account idAccount, String strStatus, String strComentario, Id idPlantilla, String devNameTipoRegistro
    * @Description: Método que retorna un objeto Caso
    */
    public static Case crearCaso(Account idAccount, String strStatus, String strComentario, String devNameTipoRegistro) {
        final Case objCaso                        = new Case();
        objCaso.Account                     = idAccount;
        objCaso.Status                      = strStatus;
        objCaso.RecordTypeId                = RecordTypeMemory_cls.getRecType('Case', devNameTipoRegistro);
        return objCaso;
    }

	@isTest
    static void cambioPropietarioPyMETest() {
		crearDatos();
		System.runAs(usuarioAdmin) {
			Test.startTest();
			Case testInclusion = new Case();

	        try {
	            testInclusion = crearCaso(cliente2, 'Solicitada', 'TestComentario1', 'MX_PyME_Case_CarterizacionPyME');
	            testInclusion.Responsable_Aclaracion_Usuario__c = usuario3.Id;
              	testInclusion.Detalle_de_soluci_n__c = '12345';
                insert testInclusion;

                testInclusion.Status = 'Aprobada';
                testInclusion.MX_EU_Apoyo_oportunidad__c = true;
                testInclusion.CS_rb_nombreEjecutivo__c = usuario3.Id;
	            update testInclusion;

	        } catch(Exception e) {
		      	System.Debug (strDMLExeption + e.getMessage());
		    }
	        Test.stopTest();
	    }
        final Account updatedAcc = [SELECT Cuentas_Bloqueadas__c FROM Account WHERE No_de_cliente__c = '234'];
	    System.assertEquals(true, updatedAcc.Cuentas_Bloqueadas__c);
	}

	@isTest
    static void createCaseTeamMemeberTest() {
		crearDatos();
        final List<Case> newCasesList = new List<Case>();
        Case testInclusion = new Case();

		System.runAs(usuario3) {
			Test.startTest();

	        try {
	            testInclusion = crearCaso(cliente2, 'Solicitada', 'TestComentario1', 'MX_PyME_Case_CarterizacionPyME');
	            testInclusion.Responsable_Aclaracion_Usuario__c = usuario3.Id;
              	testInclusion.Detalle_de_soluci_n__c = '12345';
                testInclusion.Status = 'Solicitada';
                testInclusion.MX_EU_Apoyo_oportunidad__c = true;
                testInclusion.CS_rb_nombreEjecutivo__c = usuario3.Id;
                testInclusion.MX_PyME_Traspaso_entre_divisiones__c = false;
                testInclusion.Alerta_Generada__c = true;
                insert testInclusion;
                newCasesList.add(testInclusion);
                Case_cls.createCaseTeamMemeber(newCasesList);
	        } catch(Exception e) {
		      	System.Debug (strDMLExeption + e.getMessage());
		    }
	        Test.stopTest();
	    }
		final List<CaseShare> createdCaseShare = [SELECT Id FROM CaseShare WHERE CaseId =: testInclusion.Id and RowCause = 'Manual'];
        System.assert(!createdCaseShare.isEmpty());
	}

}