/**
* ------------------------------------------------------------------------------------------------
* @Name     MX_WB_EvaluacionCalidad_test
* @Author   Salvador Reyna Gonzalez
* @Date     Created: 2019-01-09
* @Group  	Telemarketing
* @Description This class works as a Test Class for the APEX Class MX_WB_EvaluacionCalidad_ctrl
* @Coverage 98%
* @Changes
* @changes by Jaime Terrats, fix record type from cliente empresarial to person account
*/
@isTest
private class MX_WB_EvaluacionCalidad_test {
    /**
    *Field
    */
    static Opportunity oppWon;
    /**
    *Field
    */
    static String evaluacionesConcepto;
    /**
    *Field
    */
    static String evaluacionesSeccion;
    /**
    *Field
    */
    static String evaluacionesPuntoEntrenamiento;
    /**
    *Field
    */
    static List<String> deletePuntoEntrenamiento;
    /**
    *
    */
    static Evaluacion__c evalua;
    /**
    *
    */
    static List<MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionSeccion> listWrpES;
    /**
    *
    */
    static List<MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionConceptoInfo> listWrpEC;

    /*******************************************************************************************************
    * @description Inserts records on Account, Opportunity, CatalogoConceptos__c, CatalogoSecciones__c,
    * 		CatalogoSubsecciones__c, SeccionSubseccionConcepto__c
    */

    static void initData() {
        final RecordType rtSSC = [Select Id from RecordType Where SObjectType ='SeccionSubseccionConcepto__C' AND DeveloperName='Outbound'];

        final Account cuentaTest                  = MX_WB_TestData_cls.createAccount('Test Account','PersonAccount');
        insert cuentaTest;
        oppWon                              = MX_WB_TestData_cls.createOppClosed('Test Opp', cuentaTest.Id, 'ASD');
        insert oppWon;
        final CatalogoConceptos__c  concepto      = MX_WB_TestData_cls.createConcept('Presentacion BBVA',1,5,'Selecciona');
        insert concepto;
        final CatalogoConceptos__c concepto2      = MX_WB_TestData_cls.createConcept('Presentacion BBVA',1,5,'ENF');
        insert concepto2;
        final CatalogoSubsecciones__c subseccion  = MX_WB_TestData_cls.createSubsection('Subsecc 1', 2);
        insert subseccion;
        final CatalogoSubsecciones__c subseccion2 = MX_WB_TestData_cls.createSubsection('Subsecc 2', 1);
        insert subseccion2;
        final CatalogoSeccion__c seccion          = MX_WB_TestData_cls.createSection('Seccion 1',1);
        insert seccion;
        final CatalogoSeccion__c seccion2         = MX_WB_TestData_cls.createSection('Seccion 2. Nombre completo',2);
        insert seccion2;

        final SeccionSubseccionConcepto__c ssc = MX_WB_TestData_cls.createSectionSubsectionConcept(seccion.Id,subseccion.Id,concepto.Id);
        ssc.RecordTypeId = rtSSC.Id;
        insert ssc;
        final SeccionSubseccionConcepto__c ssc2 = MX_WB_TestData_cls.createSectionSubsectionConcept(seccion2.Id,subseccion2.Id,concepto2.Id);
        ssc2.RecordTypeId = rtSSC.Id;
        insert ssc2;
        final SeccionSubseccionConcepto__c ssc3 = MX_WB_TestData_cls.createSectionSubsectionConcept(seccion.Id,subseccion.Id,concepto2.Id);
        ssc3.RecordTypeId = rtSSC.Id;
        insert ssc3;
        final SeccionSubseccionConcepto__c ssc4 = MX_WB_TestData_cls.createSectionSubsectionConcept(seccion.Id,null,concepto2.Id);
        ssc4.RecordTypeId = rtSSC.Id;
        insert ssc4;

        listWrpEC= new List<MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionConceptoInfo>();
        listWrpEC.add(createWrappersEC(seccion,subseccion,concepto,'1'));
        listWrpEC.add(createWrappersEC(seccion2,subseccion2,concepto2,'0'));

        listWrpES = new List<MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionSeccion>();

        final MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionSeccion wrpES = new MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionSeccion();
        wrpES.CatalogoSeccion = seccion.Id;
        wrpES.SeguirHaciendo = 'Test SH';
        wrpES.DejarDeHacer = 'Test DH';
        wrpES.EmpezarAHacer = 'Test EH';
        listWrpES.add(wrpES);

        final List<MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionPuntoEntrenamiento> listWrapperPuntoEntrenamiento = new List<MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionPuntoEntrenamiento>();
        final MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionPuntoEntrenamiento wrapperPuntoEntrenamiento = new MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionPuntoEntrenamiento();
        wrapperPuntoEntrenamiento.idConcepto = concepto.Id;
        wrapperPuntoEntrenamiento.label = concepto.MX_WB_PuntosEntrenamiento__c;
        listWrapperPuntoEntrenamiento.add(wrapperPuntoEntrenamiento);

        evaluacionesConcepto = JSON.serialize(listWrpEC);
        evaluacionesSeccion  = JSON.serialize(listWrpES);
        evaluacionesPuntoEntrenamiento = JSON.serialize(listWrapperPuntoEntrenamiento);
		deletePuntoEntrenamiento = new List<String>();
    }
    /*******************************************************************************************************
    * @description Loads the data configured to show Section, Subsection and Concept Wrappers
    */
    static testMethod void initEvaluacion() {
        initData();
        Test.startTest();
        final MX_WB_EvaluacionCalidad_ctrl.WrapperConfiguracion wrpData = MX_WB_EvaluacionCalidad_ctrl.cargaConfiguracion();
        System.assertEquals(wrpData.wrapperSSC.size(), 2, 'wrapperSSC no igual a 2');
        Test.stopTest();
    }

    static MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionConceptoInfo createWrappersEC(CatalogoSeccion__c seccion, CatalogoSubsecciones__c subseccion, CatalogoConceptos__c concepto, String calificacion) {
        final MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionConceptoInfo wrpEC = new MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionConceptoInfo();
        wrpEC.SubseccionEvaConcepto = subseccion.Nombre__c;
        wrpEC.SeccionEvaConcepto = seccion.Nombre__c;
        wrpEC.Concepto = concepto.Id;
        wrpEC.Ponderacion = Integer.valueOf(concepto.MX_WB_Ponderacion__c);
        wrpEC.Calificacion = calificacion;
        wrpEC.ConceptoEvaConcepto = concepto.Descripcion__c;
        wrpEC.GuardadoDeConceptos = true;
        wrpEC.ErrorFatal = false;
        return wrpEC;
    }
    /*******************************************************************************************************
    * @description Uses the MX_WB_EvaluacionCalidad methods to look up, analize and create new records on
    * 		Evaluacion__c, EvaluacionConcepto__c and MX_WB_EvaluacionSeccion__c.
    */
    static testMethod void saveEvaluacion() {
        initData();
        evalua = new Evaluacion__c();
        evalua.MX_WB_PuntajeTotal__c = 80;
        evalua.Encuestado__c = 'Test Usuario';
        evalua.IDGrabacion__c = 'Test123';
        evalua.MX_WB_PuntajeBase__c = 100;
        evalua.MX_WB_ErroresFatales__c = 0;
        evalua.MX_WB_ErroresNoFatales__c = 0;
        evalua.MX_WB_Cotizacion__c = oppWon.Id;

        Test.startTest();
        final MX_WB_EvaluacionCalidad_ctrl.WrapperMessage assertMsj = MX_WB_EvaluacionCalidad_ctrl.guardaEvaluacion(evalua, evaluacionesConcepto, evaluacionesSeccion, evaluacionesPuntoEntrenamiento, deletePuntoEntrenamiento, false);
        System.assertEquals(assertMsj.status, 'OK', 'Estatus diferente de OK');

        final MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionInfo evaluaBD = MX_WB_EvaluacionCalidad_ctrl.obtieneEvaluacion(oppWon.Id);
        System.assertEquals(evaluaBD.evaluacion.MX_WB_Cotizacion__c, oppWon.Id, 'Cotizacion diferente a Oportunidad');
        System.assertEquals(evaluaBD.evaluacionSecciones.size(), 1, 'Evaluacion Secciones diferente de 1');
        System.assertEquals(evaluaBD.evaluacionConceptos.size(), 2, 'Evaluacion Conceptos diferente de 2');

        try {
        	MX_WB_EvaluacionCalidad_ctrl.guardaEvaluacion(evalua, evaluacionesConcepto, evaluacionesSeccion, '[]', deletePuntoEntrenamiento, true);
        } catch(AuraHandledException err) {
            System.assertEquals(err.getMessage(), 'Script-thrown exception', 'Error diferente');
        }

        for(MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionSeccion wrpESiteration : listWrpES) {
            wrpESiteration.idEvaluacionSeccion = evaluaBD.evaluacionSecciones.get(wrpESiteration.CatalogoSeccion).Id;
        }

        for(MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionConceptoInfo wrpECiteration : listWrpEC) {
            wrpECiteration.idEvaluacionConcepto = evaluaBD.evaluacionConceptos.get(wrpECiteration.Concepto).Id;
        }

        evaluacionesConcepto = JSON.serialize(listWrpEC);
        evaluacionesSeccion = JSON.serialize(listWrpES);


        for(MX_WB_EvaluacionPuntosEntrenamiento__c puntos :[Select Id from MX_WB_EvaluacionPuntosEntrenamiento__c]) {
            deletePuntoEntrenamiento.add(puntos.Id);
        }

        final MX_WB_EvaluacionCalidad_ctrl.WrapperMessage assertMsj3 = MX_WB_EvaluacionCalidad_ctrl.guardaEvaluacion(evalua, evaluacionesConcepto, evaluacionesSeccion, '[]', deletePuntoEntrenamiento, true);
        System.assertEquals(assertMsj3.status, 'OK', 'Estatus diferente de OK');

        Test.stopTest();
    }

    /*******************************************************************************************************
    * @description Uses the MX_WB_EvaluacionCalidad methods to look up, analize and create new records on
    * 		Evaluacion__c, EvaluacionConcepto__c and MX_WB_EvaluacionSeccion__c.
    */
    static testMethod void exceptionsEvaluacion() {
        initData();
        final String exceptionString = 'Script-thrown exception';
        try {
        	MX_WB_EvaluacionCalidad_ctrl.obtieneEvaluacion(oppWon.AccountId);
        } catch(AuraHandledException err) {
            System.assertEquals(err.getMessage(), exceptionString, 'Error diferente');
        }

        try {
            final List<SeccionSubseccionConcepto__c> listSCC =  [SELECT Id from SeccionSubseccionConcepto__c];
            delete listSCC;
        	MX_WB_EvaluacionCalidad_ctrl.cargaConfiguracion();
        } catch(AuraHandledException err) {
            System.assertEquals(err.getMessage(), exceptionString, 'Error diferente');
        }
    }
}
