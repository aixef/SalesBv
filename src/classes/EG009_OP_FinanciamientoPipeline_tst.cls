/*-----------------------------------------------------------------------------------------
*----------------------------------Desarrollado por INDRA----------------------------------
*Autor:			Ing. Pedro Alan Hernandez Sierra
*Proyecto:		MAX 3.0 - BBVA Bancomer
*Descripción:	Clase "TEST" de Clase FI001_ReedireccionObservacionTRClase del Componente
				Lightning FI001_ReedireccionObservacionTipoRegistro.
*_______________________________________________________________________________________
*Versión	Fecha			Autor								Descripción
*1.0        14/NOV/2017     Ing. Pedro Alan Hernandez Sierra    Creación.
*1.1        16/NOV/2017     Ing. Pedro Alan Hernandez Sierra    Se modifica para agregar el EG009_UtilitysUnitTest_tst.
*1.2		18/ENE/2018		Cristian Espinosa					Se sustituyen los campos Name por No_de_cliente__c en
																las queries del cliente y grupo (SHIELD).
*1.2        30/ENE/2018     Ing. Pedro Alan Hernandez Sierra    Se ajusta método dejando las modificaciones para lo de shield,
																	solo que las modificaciones anteriores no cubrían al 100% la clase.
*1.2        07/FEB/2018     Lic. Luis Ruben Quinto Muñoz	    Se ajusta ActualizaPorcentajesEnMadres_Ganadas
*1.3        15/FEB/2018     Lic. Luis Ruben Quinto Muñoz	    Se ajustan test por reglas de validacion en oportunidad
2           20/FEB/2018     Lic. Luis Ruben Quinto Muñoz	    Se cambia campo EG009_fh_FechaDeComite__c  por op_fh_fechaSancion__c
2.1         28/FEB/2018     Lic. Luis Ruben Quinto Muñoz	    Se reestructura método SimulacionCargas_CerradaGanada
2.2         06/MAR/2018     Lic. Luis Ruben Quinto Muñoz	    Se Cambian metodos de prueba para cierre de dispociciones
2.3         21/MAR/2018     Lic. Luis Ruben Quinto Muñoz	    Se Cambian metodos para actualizar el responsable de cierre de la oportunidad
																	en la etapa de contratación
2.4         04/MAY/2018     Ing. Pedro Alan Hernandez Sierra	Se agrega campo de Pricing para que no entre la regla de validación de
																	descarte por precio.
2.5		    01/OCT/2018     Fernando Jaime						Se cambia Administrador del sistema por etiqueta personalizada
3.0		    18/10/2018		Antony de la rosa guzman			Se agregó IF cuando se crean oportunidades de arrendamiento homologación a Pipeline
3.1			09/07/2019		Jair Ignacio Gonzalez Gayosso		Se depuro clase con los metodos confirmados en la migracion de bpyp y pymes
-----------------------------------------------------------------------------------------*/
@isTest
public class EG009_OP_FinanciamientoPipeline_tst {
	/** String Opportunity */
	static final String STGOPPORTUNITY = 'Opportunity';
	/** String MX_BPP_RedBpyp */
	static final String STGRTOPP = 'MX_BPP_RedBpyp';
	/** String Collares */
	static final String STGCOLLARES = 'Collares';
	/** String Colocación */
	static final String STGCOLOCACION = 'Colocación';


	@testSetup static void testSetup() {

		EG009_UtilitysUnitTest_tst.ambientacionGeneral();

	}

	static TestMethod void creacionOportunidadHija() {
		final User user = [SELECT Id, VP_ls_Banca__c FROM User WHERE Email = 'adminBBVA@bbva.tst.deploy.com'];
		System.runAs(user) {
			final Account cliente = [SELECT Id FROM Account WHERE No_de_cliente__c = '55218555' LIMIT 1];
			final EG009_OP_FinanciamientoPipeline_cls eg009Test = new EG009_OP_FinanciamientoPipeline_cls();
            System.assertNotEquals(null, eg009Test, 'Se crea clase');
            EG009_UtilitysUnitTest_tst.creaOportunidad(cliente.Id, EG009_Utility_cls.getActiveRecordTypes(STGOPPORTUNITY).get(STGRTOPP).Id, STGCOLLARES, STGCOLOCACION);
            System.assertEquals(STGRTOPP, [SELECT Id, RecordType.DeveloperName FROM Opportunity WHERE Name = 'Oportunidad Collares' LIMIT 1].RecordType.DeveloperName, 'Tipo de Registro:');

		}
	}

}