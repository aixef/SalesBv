/**
* Avanxo México
* @author       KB
* Project:      WIBE
*
* -------------------------------------
*            No.    Date            Author             Description
*           ----- ----------    --------------------  ---------------
*                                                     JIRA SAN1-113
* @version  1.0   2017-02-21      Karen Belem (KB)    Clase de prueba para saber que cobertura tiene.                                                    *
************************************************************************************************************************************/
@isTest
public class WIB_EvaluacionCalidad_tst {

	@TestSetup
    static void setup() {
        final List<SObject> lSecc = Test.loadData(CatalogoSeccion__c.sObjectType,'CatalogoSeccion');
        final List<SObject> lSubsecc = Test.loadData(CatalogoSubsecciones__c.sObjectType,'CatalogoSubseccion');
        final List<SObject> lConcept = Test.loadData(CatalogoConceptos__c.sObjectType,'CatalogoConceptos');

        final List<SeccionSubseccionConcepto__c> lSecSubsecConcept = new List<SeccionSubseccionConcepto__c>();
        final List<Integer> numSubsecConcepto = new List<Integer>{3,7,6,7};
        Integer contSubsecCon = 0;
        Integer indSeccion = 0;

        for (SObject seccion : lSecc) {
            final Integer cantSecSubsecCon = numSubsecConcepto[indSeccion];
            for(Integer i=0;i<cantSecSubsecCon;i++) {
                final SeccionSubseccionConcepto__c secSubCon = new SeccionSubseccionConcepto__c();
                secSubCon.CatalogoSeccion__c = ((CatalogoSeccion__c)seccion).Id;
                secSubCon.CatalogoSubseccion__c = ((CatalogoSubsecciones__c)lSubsecc[contSubsecCon]).Id;
                secSubCon.CatalogoConceptos__c = ((CatalogoConceptos__c)lConcept[contSubsecCon]).Id;
                lSecSubsecConcept.add(secSubCon);
                contSubsecCon++;
            }
            indSeccion++;
        }

        try {
            insert lSecSubsecConcept;
        }catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.NoSePudoGuardar + ex.getMessage()));
        }

    }

    @isTest static void testCalculaCalificacion() {
        final Evaluacion__c eva = new Evaluacion__c();

        final ApexPages.StandardController pagEva  = new ApexPages.StandardController(eva);
        final WIB_EvaluacionCalidad_cls evaluacion = new WIB_EvaluacionCalidad_cls(pagEva);

        for (WIB_EvaluacionCalidad_cls.wrpSeccSubSeccConc objWrpSeccSubSeccConcept : evaluacion.lWrpSeccSubSeccConc) {
            for (WIB_EvaluacionCalidad_cls.wrpSubSeccionConceptos objWrpSubSeccConcept : objWrpSeccSubSeccConcept.lWrpSubSecConcs) {
                for (WIB_EvaluacionCalidad_cls.wrpConcEvaluacion EvalConc : objWrpSubSeccConcept.lWrpConcEval) {
                    EvalConc.EvalConc.Calificacion__c = '1';
                }
            }
        }

        final PageReference calificacion = evaluacion.calculaCalificacion();
        System.assertEquals(null,calificacion);
    }

    @isTest static void testGuardarEvaluacion() {
        final Evaluacion__c eva = new Evaluacion__c();

        final ApexPages.StandardController pagEva  = new ApexPages.StandardController(eva);
        final WIB_EvaluacionCalidad_cls evaluacion = new WIB_EvaluacionCalidad_cls(pagEva);

        for (WIB_EvaluacionCalidad_cls.wrpSeccSubSeccConc objWrpSeccSubSeccConcept : evaluacion.lWrpSeccSubSeccConc) {
            for (WIB_EvaluacionCalidad_cls.wrpSubSeccionConceptos objWrpSubSeccConcept : objWrpSeccSubSeccConcept.lWrpSubSecConcs) {
                for (WIB_EvaluacionCalidad_cls.wrpConcEvaluacion EvalConc : objWrpSubSeccConcept.lWrpConcEval) {
                    EvalConc.EvalConc.Calificacion__c = '1';
                }
            }
        }

        final PageReference calificacion = evaluacion.calculaCalificacion();
        System.assertEquals(null,calificacion);

        final PageReference guardarEva = evaluacion.guardaEvaluacion();
        System.assertNotEquals(null,guardarEva);
    }

    @isTest static void testActualizarEvaluacion() {
        Evaluacion__c eva = new Evaluacion__c();

        final ApexPages.StandardController pagEva  = new ApexPages.StandardController(eva);
        final WIB_EvaluacionCalidad_cls evaluacion = new WIB_EvaluacionCalidad_cls(pagEva);

        for (WIB_EvaluacionCalidad_cls.wrpSeccSubSeccConc objWrpSeccSubSeccConcept : evaluacion.lWrpSeccSubSeccConc) {
            for (WIB_EvaluacionCalidad_cls.wrpSubSeccionConceptos objWrpSubSeccConcept : objWrpSeccSubSeccConcept.lWrpSubSecConcs) {
                for (WIB_EvaluacionCalidad_cls.wrpConcEvaluacion EvalConc : objWrpSubSeccConcept.lWrpConcEval) {
                    EvalConc.EvalConc.Calificacion__c = '1';
                }
            }
        }

        final PageReference calificacion = evaluacion.calculaCalificacion();
        System.assertEquals(null,calificacion);

        final PageReference guardarEvaluacion = evaluacion.guardaEvaluacion();
        System.assertNotEquals(null,guardarEvaluacion);

        Test.setCurrentPage(guardarEvaluacion);

        final String idEva = ApexPages.currentPage().getParameters().get('idEval');

        eva = [select Id from Evaluacion__c where Id =: idEva];

        final ApexPages.StandardController pagActEva  = new ApexPages.StandardController(eva);
        final WIB_EvaluacionCalidad_cls actEva = new WIB_EvaluacionCalidad_cls(pagActEva);

        final PageReference actEval = actEva.actEvaluacion();
        System.assertNotEquals(null,actEval);
    }

    @isTest static void testCancelarEvaluacion() {
        final Evaluacion__c eva = new Evaluacion__c();

        final ApexPages.StandardController pagEva  = new ApexPages.StandardController(eva);
        final WIB_EvaluacionCalidad_cls evaluacion = new WIB_EvaluacionCalidad_cls(pagEva);

        final PageReference cancelaEvaluacion = evaluacion.cancelEvaluacion();
        System.assertNotEquals(null,cancelaEvaluacion);
    }

    @isTest static void testCancelarActualizarEvaluacion() {
        final Evaluacion__c eva = new Evaluacion__c();

        final ApexPages.StandardController pagEva  = new ApexPages.StandardController(eva);
        final WIB_EvaluacionCalidad_cls evaluacion = new WIB_EvaluacionCalidad_cls(pagEva);

        final PageReference cancelActEvaluacion = evaluacion.cancelActEvaluacion();
        System.assertNotEquals(null,cancelActEvaluacion);
    }

    @isTest static void testImagenes() {
        final Evaluacion__c eva = new Evaluacion__c();

        final ApexPages.StandardController pagEva  = new ApexPages.StandardController(eva);
        final WIB_EvaluacionCalidad_cls evaluacion = new WIB_EvaluacionCalidad_cls(pagEva);

        evaluacion.EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c = 0;
        final Boolean Imagencero = evaluacion.imagenporcentajecero;
        System.assert(Imagencero);

        evaluacion.EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c = 30;
        final Boolean Imagenuno = evaluacion.imagenporcentajeuno;
        System.assert(Imagenuno);

        evaluacion.EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c = 60;
        final Boolean Imagendos = evaluacion.imagenporcentajedos;
        System.assert(Imagendos);

        evaluacion.EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c = 80;
        final Boolean Imagentres = evaluacion.imagenporcentajetres;
        System.assert(Imagentres);

        evaluacion.EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c = 100;
        final Boolean Imagencuatro = evaluacion.imagenporcentajecuatro;
        System.assert(Imagencuatro);

    }

    @isTest static void testClassWrapper() {
        final Evaluacion__c eva = new Evaluacion__c();
        final CatalogoConceptos__c Conceptos = new CatalogoConceptos__c();
        final EvaluacionConcepto__c EvalConc = new EvaluacionConcepto__c();
        final Boolean btieneCalif = false;

        final WIB_EvaluacionCalidad_cls.wrpSeccSubSeccConc SeccSubSeccConc = new  WIB_EvaluacionCalidad_cls.wrpSeccSubSeccConc();

        System.assertNotEquals(null,SeccSubSeccConc.Seccion);
        System.assertNotEquals(null,SeccSubSeccConc.lWrpSubSecConcs);
        System.assertEquals(0.0,SeccSubSeccConc.promediosecciones);
        System.assertEquals(0.0,SeccSubSeccConc.promgeneralsecc);
        //System.assert(!SeccSubSeccConc.bTieneSec);

        final WIB_EvaluacionCalidad_cls.wrpSubSeccionConceptos SubSeccionConceptos = new  WIB_EvaluacionCalidad_cls.wrpSubSeccionConceptos();

        System.assertNotEquals(null,SubSeccionConceptos.SubSeccion);
        System.assertNotEquals(null,SubSeccionConceptos.lWrpConcEval);
        //System.assert(!SubSeccionConceptos.bTieneConceptos);

        final WIB_EvaluacionCalidad_cls.wrpConcEvaluacion ConcEvaluacion = new  WIB_EvaluacionCalidad_cls.wrpConcEvaluacion();

        System.assertNotEquals(null,ConcEvaluacion.Conceptos);
        System.assertNotEquals(null,ConcEvaluacion.EvalConc);

        final WIB_EvaluacionCalidad_cls.wrpConcEval ConceptEvalFalse = new  WIB_EvaluacionCalidad_cls.wrpConcEval(Conceptos, eva, EvalConc, btieneCalif);

        System.assertNotEquals(null,ConceptEvalFalse.Conceptos);
        System.assertNotEquals(null,ConceptEvalFalse.Evaluacion);
        System.assertNotEquals(null,ConceptEvalFalse.EvalConc);
        //System.assert(!ConceptEvalFalse.btieneCalif);
    }

}//FIN CODIGO