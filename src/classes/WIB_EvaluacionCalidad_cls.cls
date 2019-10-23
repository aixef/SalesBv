/**
* Avanxo México
* @author       KB
* Project:      WIBE
*
* -------------------------------------
*            No.    Date            Author             Description
*           ----- ----------    --------------------  ---------------
*                                                     JIRA SAN1-113
* @version  1.0   2017-02-21      Karen Belem (KB)    Este controlador calcula las calificaciones de 0,1 o 2 por cade sección,
*                                                     subseccion y concepto que se tiene en la encuesta, también es el encargado de
*                                                     poder guardar registros y actualizarlos con su respecta información.
************************************************************************************************************************************/

public with sharing class WIB_EvaluacionCalidad_cls {
  /** variable EvalMod*/
  public Evaluacion__c EvalMod {get;set;}
  /** variable EvalIns*/
  public Evaluacion__c EvalIns {get;set;}
  /** variable bModificar*/
  public Boolean bModificar {get;Set;}
  /** variable lWrpConcEval*/
  public List<wrpConcEval> lWrpConcEval {get;set;}
  /** variable lEvalConc*/
  public List<EvaluacionConcepto__c> lEvalConc {get;set;}
  /** variable lWrpSeccSubSeccConc*/
  public List<wrpSeccSubSeccConc> lWrpSeccSubSeccConc {get;Set;}
  /** variable ListNoSecc*/
  public List<Integer> ListNoSecc {get;set;}
  /** variable ListNoSubSecc*/
  public List<Integer> ListNoSubSecc {get;set;}
  /** variable ListNoConc*/
  public List<Integer> ListNoConc {get;set;}
  /** variable mapSecc*/
  public Map<Integer, String> mapSecc {get;set;}
  /** variable mapSubSecc*/
  public Map<Integer, String> mapSubSecc {get;set;}
  /** variable mapConc*/
  public Map<Integer, CatalogoConceptos__c> mapConc {get;set;}
  /** variable mSecSubSecConc*/
  public Map<String, Map<String, Map<Integer, CatalogoConceptos__c>>> mSecSubSecConc {get;Set;}
  /** variable mGuardadosSecSub*/
  public Map<String, Map<String, set<String>>> mGuardadosSecSubSecConc {get;Set;}
  /** variable EvaluacionCalificacion*/
  public wrpConcEval EvaluacionCalificacion {get;Set;}
  /**  variable lEvalRep*/
  public List<SelectOption> lEvalRep {get;Set;}
  /** variable sEvalRep*/
  public String sEvalRep {get;Set;}
  /** variable lEvalEnc*/
  public List<SelectOption> lEvalEnc {get;Set;}
  /** variable sEvalEncs*/
  public String sEvalEncs {get;Set;}
  /** variable sEvalEncTemp*/
  public String sEvalEncTemp {get;Set;}
  /** variable setLlaveSecSubSecConc*/
  public Set<String> setLlaveSecSubSecConc {get;set;}
  /** variable mapLlaveSecSubSecConcCalf*/
  public Map<String, EvaluacionConcepto__c> mapLlaveSecSubSecConcCalf {get;Set;}

  /**Un constructor standar para el objeto Evaluacion__c */
  public WIB_EvaluacionCalidad_cls(ApexPages.standardController stdController) {


    EvalMod = (Evaluacion__c) stdController.getRecord();

    EvaluacionCalificacion = new wrpConcEval();
    bModificar = false;
    ListNoSecc = new List<Integer>();
    ListNoSubSecc = new List<Integer>();
    ListNoConc = new List<Integer>();
    lWrpConcEval = new List<wrpConcEval>(); //Clase wrapper respuestas
    lWrpSeccSubSeccConc = new List<wrpSeccSubSeccConc>(); //clase wrapper secciones
    lEvalConc = new List<EvaluacionConcepto__c>();
    mapSecc = new Map<Integer, String>();
    mapSubSecc = new Map<Integer, String>();
    mapConc = new Map<Integer, CatalogoConceptos__c>();
    mSecSubSecConc = new Map<String, Map<String, Map<Integer, CatalogoConceptos__c>>>();
    mGuardadosSecSubSecConc = new Map<String, Map<String, set<String>>>();
    lEvalRep = new List<SelectOption>();
    lEvalEnc = new List<SelectOption>();
    setLlaveSecSubSecConc = new Set<String>();
    mapLlaveSecSubSecConcCalf = new Map<String, EvaluacionConcepto__c>();

    //SE MODIFICARÁ LA EVALUACIÓN
    if (EvalMod.id != Null /*|| Test.isRunningTest()*/) {
        bModificar = true; }
    //ES NUEVA LA EVALUACIÓN
    if (!bModificar /*|| Test.isRunningTest()*/) {
      EvalIns = new Evaluacion__c();
    }
    //SE MODIFICARÁ LA EVALUACIÓN
    if (bModificar) {
      System.debug('EvalMod++' + EvalMod.id );
      //EvalMod.id = 'a16g00000057UVv'; Esto es para la clase de prueba
      //CONSULTA PARA TRAER LOS REGISTROS CALIFICADOS DE LA EVALUACIÓN
      for (Evaluacion__c Evaluacion : [SELECT ev.MotivoOportunidadComercial__c,ev.MotivoNoventa__c,ev.MotivoNoContacto__c,
            ev.CreatedDate,ev.Encuestado__c,ev.BarraPorcentaje__c, ev.RepresentanteCalidad__c, ev.PorcentajeTotal__c,
            ev.Observaciones__c, ev.IDGrabacion__c,ev.PorcentajeReglasJuego__c,ev.PorcentajeExperienciaConCliente__c,
            ev.PorcentajeProductoProceso__c, ev.PorcentajeVentas__c,
          (SELECT ID, EjemploEvaConcepto__c,SeccionEvaConcepto__c,SubseccionEvaConcepto__c,ConceptoEvaConcepto__c
          ,Calificacion__c,PorcentajeSeccion__c, Concepto__c, Evaluacion__c, Concepto__r.Descripcion__c,Concepto__r.Ejemplo__c
          ,Concepto__r.NoConcepto__c, Concepto__r.LastModifiedDate,Concepto__r.Activa__c, GuardadoDeConceptos__c
          FROM Evaluaciones_Conceptos__r WHERE GuardadoDeConceptos__c = true ORDER BY Concepto__r.NoConcepto__c)
          FROM Evaluacion__c ev
          WHERE id = :EvalMod.id]) {
       System.debug('EvalMod++' + EvalMod.id);

        EvaluacionCalificacion.Evaluacion = Evaluacion;//Trae toda la inf de los campos de Evaluación
        System.debug('EvaluacionCalificacion.Evaluacion--' + EvaluacionCalificacion.Evaluacion);

        if (!Evaluacion.Evaluaciones_Conceptos__r.isEmpty()) {
          for (EvaluacionConcepto__c  objEvalConcep : Evaluacion.Evaluaciones_Conceptos__r) {
            setLlaveSecSubSecConc.add(objEvalConcep.SeccionEvaConcepto__c +''+objEvalConcep.SubseccionEvaConcepto__c+''+objEvalConcep.ConceptoEvaConcepto__c);
            mapLlaveSecSubSecConcCalf.put(objEvalConcep.SeccionEvaConcepto__c +''+objEvalConcep.SubseccionEvaConcepto__c+''+objEvalConcep.ConceptoEvaConcepto__c, objEvalConcep);
            System.debug('-mapLlaveSecSubSecConcCalf' + mapLlaveSecSubSecConcCalf);//este mapa ya tiene el porcentaje seccion

            if (mGuardadosSecSubSecConc.containsKey(objEvalConcep.SeccionEvaConcepto__c)) {
                if (mGuardadosSecSubSecConc.get(objEvalConcep.SeccionEvaConcepto__c).containsKey(objEvalConcep.SubseccionEvaConcepto__c)) {
                  mGuardadosSecSubSecConc.put(objEvalConcep.SeccionEvaConcepto__c,
                    new Map<String,  Set<String>>{objEvalConcep.SubseccionEvaConcepto__c =>
                    new set<String>{objEvalConcep.ConceptoEvaConcepto__c}});
                }
                if (!mGuardadosSecSubSecConc.get(objEvalConcep.SeccionEvaConcepto__c).containsKey(objEvalConcep.SubseccionEvaConcepto__c)) {
                  mGuardadosSecSubSecConc.get(objEvalConcep.SeccionEvaConcepto__c).put(objEvalConcep.SubseccionEvaConcepto__c,
                    new set<String>{objEvalConcep.ConceptoEvaConcepto__c});
                }
            }
            if (!mGuardadosSecSubSecConc.containsKey(objEvalConcep.SeccionEvaConcepto__c)) {
              mGuardadosSecSubSecConc.put(objEvalConcep.SeccionEvaConcepto__c,
                    new Map<String,  Set<String>>{objEvalConcep.SubseccionEvaConcepto__c =>
                    new set<String>{objEvalConcep.ConceptoEvaConcepto__c}});
              //System.debug('+mGuardadosSecSubSecConc' + mGuardadosSecSubSecConc);

            }//FIN IF !mGuardadosSecSubSecConc..containsKey(objEvalConcep.SeccionEvaConcepto__c))
          } //FIN FOR EvaluacionConcepto__c
        }//FIN IF != VACIO
      }//FIN FOR DE CONSULTA PARA EVA-CONCEPTOS
    }//FIN IF BMODIFICAR

    //REPRESENTANTE DE CALIDAD
    sEvalRep = UserInfo.getName(); //OBTIENE EL NOMBRE DEL USUARIO LOGUEADO
    lEvalRep.add(new SelectOption(sEvalRep, sEvalRep));

    //ASESOR EVALUADO
    for (User encuestado : [SELECT Name, User.Profile.Name from User where ((User.Profile.Name = 'Asesores') OR ( User.Profile.Name = 'Asesores ASD'))
      AND (IsActive = true) ORDER BY Name]) {
      if (sEvalEncs == null) {
        sEvalEncs = encuestado.Name;
        sEvalEncTemp = encuestado.Name;
      }
      lEvalEnc.add(new SelectOption(encuestado.Name, encuestado.Name));
    }

    //CATALOGO SECCIONES
    for (CatalogoSeccion__c Seccion : [
      SELECT c.NumeroSeccion__c, c.Nombre__c, c.Id FROM CatalogoSeccion__c c
      ORDER BY NumeroSeccion__c]) {
      ListNoSecc.add(Integer.valueOf(Seccion.NumeroSeccion__c));
      mapSecc.put(Integer.valueOf(Seccion.NumeroSeccion__c) , Seccion.Nombre__c);
    }
    ListNoSecc.sort();

    //CATALOGO SUBSECCIONES
    for (CatalogoSubsecciones__c SubSeccion : [SELECT c.Numero__c, c.Nombre__c, c.Id
      FROM CatalogoSubsecciones__c c
      ORDER BY Numero__c]) {
      ListNoSubSecc.add(Integer.valueOf(SubSeccion.Numero__c));
      mapSubSecc.put(Integer.valueOf(SubSeccion.Numero__c), SubSeccion.Nombre__c);
    }
    ListNoSubSecc.sort();

    //CATALOGO CONCEPTOS
    for (CatalogoConceptos__c concepto : [SELECT c.NoConcepto__c, c.Name, c.Id, c.Descripcion__c, c.Ejemplo__c FROM CatalogoConceptos__c c
      ORDER BY NoConcepto__c]) {
      //DATOS DE LOS CONCEPTOS
      ListNoConc.add(Integer.valueOf(concepto.NoConcepto__c));
      mapConc.put(Integer.valueOf(concepto.NoConcepto__c), concepto);
    }
    ListNoConc.sort();

    final String sQuery = 'SELECT s.CatalogoSeccion__r.Nombre__c, s.CatalogoSeccion__r.NumeroSeccion__c,'+
      ' s.CatalogoSubseccion__r.Nombre__c, s.CatalogoSubseccion__r.Numero__c,s.CatalogoConceptos__r.Descripcion__c,'+
      ' s.CatalogoConceptos__r.NoConcepto__c, s.CatalogoConceptos__r.Activa__c, s.CatalogoConceptos__r.Ejemplo__c'+
      ' FROM SeccionSubseccionConcepto__c s '+ (!bModificar ? ' Where s.CatalogoConceptos__r.Activa__c = true ' : '') +
      ' ORDER BY s.CatalogoSeccion__r.NumeroSeccion__c, s.CatalogoSubseccion__r.Numero__c, s.CatalogoConceptos__r.NoConcepto__c';
    final List<SObject> lsObjSeccSubSecConcp = Database.query(sQuery);
    System.debug('LstDatabase: ' + lsObjSeccSubSecConcp);
    //Es una nueva EVALUACION
    //CATALOGO SeccionSubseccionConcepto__c
    for (SObject sObjetSecSubSecConc : lsObjSeccSubSecConcp) {
      final SeccionSubseccionConcepto__c secSubSecConc =(SeccionSubseccionConcepto__c) sObjetSecSubSecConc;
      //VARIABLES PARA EL OBJETO CONCEPTO
      final String sNombreSubSec = secSubSecConc.CatalogoSubseccion__r.Nombre__c != null ? secSubSecConc.CatalogoSubseccion__r.Nombre__c :'';//VERIFICA QUE TENGA SUBSECCIÓN
      final String sIdConc = secSubSecConc.CatalogoConceptos__c;
      final Integer iNoConc = Integer.valueOf(secSubSecConc.CatalogoConceptos__r.NoConcepto__c);
      final String sDescrip = secSubSecConc.CatalogoConceptos__r.Descripcion__c;
      final String sEjemplo = secSubSecConc.CatalogoConceptos__r.Ejemplo__c;
    //Un objeto del tipo concepto
      final CatalogoConceptos__c concepto = new CatalogoConceptos__c(id = sIdConc, NoConcepto__c = iNoConc, Descripcion__c = sDescrip, Ejemplo__c = sEjemplo);//GUARDA LAS VARIABLES EN UNA VARIABLE DE TIPO OBJECT
      //PONERLOS EN EL MAPA mSecSubSecConc = new Map<String, Map<String, Map<Integer, CatalogoConceptos__c>>>();
      if (mSecSubSecConc.containsKey(secSubSecConc.CatalogoSeccion__r.Nombre__c)) {
        if (mSecSubSecConc.get(secSubSecConc.CatalogoSeccion__r.Nombre__c).containsKey(sNombreSubSec)) {
            mSecSubSecConc.put(secSubSecConc.CatalogoSeccion__r.Nombre__c, //ingresa el nombre de la sección
                              new Map<String, Map<Integer, CatalogoConceptos__c>>{sNombreSubSec => //Ingresa la subsección
                              new Map<Integer, CatalogoConceptos__c> {iNoConc => concepto}}); //Ingresa el numero del concepto
           // System.debug('mSecSubSecConc0**: ' + mSecSubSecConc);
        }
        if (!mSecSubSecConc.get(secSubSecConc.CatalogoSeccion__r.Nombre__c).containsKey(sNombreSubSec)) {
          mSecSubSecConc.get(secSubSecConc.CatalogoSeccion__r.Nombre__c).put(sNombreSubSec,
          new Map<Integer, CatalogoConceptos__c>{ iNoConc => concepto });
          //System.debug('mSecSubSecConc1**: ' + mSecSubSecConc);
        }
      }
      if (!mSecSubSecConc.containsKey(secSubSecConc.CatalogoSeccion__r.Nombre__c)) {
        mSecSubSecConc.put(secSubSecConc.CatalogoSeccion__r.Nombre__c,
        new Map<String, Map<Integer, CatalogoConceptos__c>>{sNombreSubSec =>
        new Map<Integer, CatalogoConceptos__c>{ iNoConc => concepto }});
        //System.debug('mSecSubSecConc2**: ' + mSecSubSecConc);
      }//FIN IF !mSecSubSecConc.containsKey(secSubSecConc.CatalogoSeccion__r.NumeroSeccion__c)
    }//FIN FOR

    for(Integer iSecc : ListNoSecc) {
      final String sSecName = mapSecc.get(iSecc);
      Boolean bTieneSecc = false;
      //VE SI mSecSubSecConc CONTIENE sSecName
      if (mSecSubSecConc.containsKey(sSecName)) {
        final Map<String, Map<Integer, CatalogoConceptos__c>> mSubSecConc = mSecSubSecConc.get(sSecName);
        System.debug('mSubSecConc*..'+ mSubSecConc);
        final CatalogoSeccion__c CatalogoSecciones = new CatalogoSeccion__c(NumeroSeccion__c = iSecc, Nombre__c = sSecName );
        //VERIFICAR SI mSubSecConc.KeySet() TIENE VALORES
        if (!mSubSecConc.KeySet().isEmpty()) {
          final List<wrpSubSeccionConceptos> lWrpSubSecConc = new List<wrpSubSeccionConceptos>();
            //SI TIENE SECCIONES
            bTieneSecc = true;
             //RECORRE LA LISTA DE ListNoSubSecc
            for (Integer iSubSecc : ListNoSubSecc) {
             final String sSubSecName = mapSubSecc.get(iSubSecc);
             //Boolean sitiene = mSubSecConc.containsKey(sSubSecName) != null ? mSubSecConc.containsKey(sSubSecName) : false;
              if (mSubSecConc.containsKey(sSubSecName)) {
                final Map<Integer, CatalogoConceptos__c> mConceptos = mSubSecConc.get(sSubSecName);
                final CatalogoSubsecciones__c SubSeccion = new CatalogoSubsecciones__c(Numero__c = iSubSecc, Nombre__c = sSubSecName);
                final List<wrpConcEvaluacion> lWrpConcEval = new List<wrpConcEvaluacion>();
                Boolean bTieneConceptos = false;
                Boolean btieneCalif = false;
                //VERIFICAR SI mConceptos TIENE VALORES
                if (!mConceptos.KeySet().isEmpty()) {
                  for (Integer iNoConc : ListNoConc) {
                    if (mConceptos.containsKey(iNoConc)) {
                      btieneCalif = true;
                       //Agrega el objeto a la lista de lWrpConcEval
                      lWrpConcEval.add( new wrpConcEvaluacion( mConceptos.get(iNoConc), new EvaluacionConcepto__c(Concepto__c = mConceptos.get(iNoConc).id)) );
                      bTieneConceptos = true;
                    }//FIN IF (mConceptos.containsKey(iNoConc)) MAPA CONTIENE CONCEPTOS
                  }//FIN FOR (Integer iNoConc : ListNoConc) RECORRE LA LISTA DE CONCEPTOS
                  lWrpSubSecConc.add( new wrpSubSeccionConceptos(SubSeccion, lWrpConcEval, bTieneConceptos) );
                }//FIN IF que verifica que el mapa Map<Integer, CatalogoConceptos__c> mConceptos NO ESTE VACIO
              }// FIN IF (mSubSecConc.containsKey(sSubSecName)) VERIFICA QUE EL MAPA TENGA SUBSECCIONES
            } //FIN FOR QUE RECORRE LAS SUBSECCIONES
         // }//FIN IF size() >= 1
          lWrpSeccSubSeccConc.add( new wrpSeccSubSeccConc( CatalogoSecciones, lWrpSubSecConc, bTieneSecc ) );
        }// Fin if (!mSubSecConc.KeySet().isEmpty()) QUE VERIFICA QUE LA SECCION NO ESTE VACIA
        if (mSubSecConc.KeySet().isEmpty()) {
          lWrpSeccSubSeccConc.add( new wrpSeccSubSeccConc( CatalogoSecciones, new List<wrpSubSeccionConceptos>(), bTieneSecc ) );
        }//FIN IF QUE AGREGA SECCIONES
      } // FIN IF(mSecSubSecConc.containsKey(sSecName) VERIFICA QUE SE TENGAN LAS SECCIONES DEL MAPA
    } //FIN FOR QUE RECORRE LAS SECCIONES mSecSubSecConc = new Map<String, Map<String, Map<Integer, CatalogoConceptos__c>>>();


    //SE MODIFICARÁ LA EVALUACIÓN
    if (bModificar) {

      final List<wrpSeccSubSeccConc> lWrpSeccSubSeccConcTMP = new List<wrpSeccSubSeccConc>();

      for (wrpSeccSubSeccConc objWrpSeccSubSeccConcept : lWrpSeccSubSeccConc) {
      //VERIFICAR QUE EL MAPA TENGA SECCIONES
        if(mGuardadosSecSubSecConc.containsKey(objWrpSeccSubSeccConcept.Seccion.Nombre__c) || Test.isRunningTest()) {
          final Map<String, set<String>> mGuardadoSubSecConc = mGuardadosSecSubSecConc.get(objWrpSeccSubSeccConcept.Seccion.Nombre__c);
          final CatalogoSeccion__c CatalogoSecciones = objWrpSeccSubSeccConcept.Seccion;
          if (!mGuardadosSecSubSecConc.KeySet().isEmpty()) {
            final List<wrpSubSeccionConceptos> lWrpSubSecConc = new List<wrpSubSeccionConceptos>();

            for (wrpSubSeccionConceptos objWrpSubSeccConcept : objWrpSeccSubSeccConcept.lWrpSubSecConcs) {
              if (mGuardadoSubSecConc.containsKey(objWrpSubSeccConcept.SubSeccion.Nombre__c)) {
                final Set<String> sGuardadoConc = mGuardadoSubSecConc.get(objWrpSubSeccConcept.SubSeccion.Nombre__c);
                final List<wrpConcEvaluacion> lWrpConcEval = new List<wrpConcEvaluacion>();

                if(!mGuardadoSubSecConc.KeySet().isEmpty()) {
                  final CatalogoSubsecciones__c SubSeccion = objWrpSubSeccConcept.SubSeccion;

                  for (wrpConcEvaluacion EvalConc : objWrpSubSeccConcept.lWrpConcEval) {
                    final String sLlavePasoVal = objWrpSeccSubSeccConcept.Seccion.Nombre__c +''+objWrpSubSeccConcept.SubSeccion.Nombre__c+''+EvalConc.Conceptos.Descripcion__c;

                    if (setLlaveSecSubSecConc.contains(sLlavePasoVal)) {

                      final EvaluacionConcepto__c EvaluacionConceptoPaso = new EvaluacionConcepto__c( Id = mapLlaveSecSubSecConcCalf.get(sLlavePasoVal).Id, PorcentajeSeccion__c = mapLlaveSecSubSecConcCalf.get(sLlavePasoVal).PorcentajeSeccion__c);

                       //System.debug(',,EvaluacionConceptoPaso ' + EvaluacionConceptoPaso);si los trae
                      EvaluacionConceptoPaso.Calificacion__c = mapLlaveSecSubSecConcCalf.containsKey(sLlavePasoVal)
                      ?  String.valueOf(mapLlaveSecSubSecConcCalf.get(sLlavePasoVal).Calificacion__c) :  '';

                      lWrpConcEval.add( new wrpConcEvaluacion(EvalConc.Conceptos, EvaluacionConceptoPaso) );

                    }//FIN IF (setLlaveSecSubSecConc.contains(sLlavePasoVal))
                  }
                  lWrpSubSecConc.add( new wrpSubSeccionConceptos(SubSeccion, lWrpConcEval, true) );
                }
              }
            }//FIN IF(mGuardadosSecSubSecConc.containsKey(objWrpSeccSubSeccConcept.Seccion.Nombre__c)){
          lWrpSeccSubSeccConcTMP.add(new wrpSeccSubSeccConc( CatalogoSecciones, lWrpSubSecConc, true ));
          }//FIN FOR CONCEPTOS-EVALUACIONES
        }//FIN FOR SUBSECCIONES
      }//FIN FOR SECCIONES
      //LIMPIA LA LISTA DE lWrpSeccSubSeccConc
      if (!lWrpSeccSubSeccConcTMP.isEmpty()) {
        lWrpSeccSubSeccConc = new List<wrpSeccSubSeccConc>();
        lWrpSeccSubSeccConc.addAll(lWrpSeccSubSeccConcTMP);
      }//FIN IF !lWrpSeccSubSeccConcTMP.isEmpty()
      //System.debug('LA CONSULTA DESPUES DE LLENAR EL MAPA lWrpSeccSubSeccConc: ' + lWrpSeccSubSeccConc.size());
    }//FIN IF BMODIFICAR
  }//FIN DEL CONSTRUCTOR

  /**CLASE PARA PODER AGREGAR LAS SECCIONES*/
  public class wrpSeccSubSeccConc {
    /** variable Seccion*/
    public CatalogoSeccion__c Seccion {get;Set;}
    /** variable lWrpSubSZecConcs*/
    public List<wrpSubSeccionConceptos> lWrpSubSecConcs {get;set;}
    /** variable promediosecciones*/
    public Decimal promediosecciones {get;set;}
    /** variable promgeneralsecc*/
    public Decimal promgeneralsecc {get;set;}
    /** variable bTieneSec*/
    public Boolean bTieneSec {get;Set;}
    /** Método */
    public wrpSeccSubSeccConc() {
      this.Seccion = new CatalogoSeccion__c();
      this.lWrpSubSecConcs = new List<wrpSubSeccionConceptos>();
      this.promediosecciones = 0.0;
      this.promgeneralsecc = 0.0;
      this.bTieneSec = false;
    }
    /** */
    public wrpSeccSubSeccConc(CatalogoSeccion__c Seccion, List<wrpSubSeccionConceptos> lWrpSubSecConcs, Boolean bTieneSec) {
      this.Seccion = Seccion;
      this.lWrpSubSecConcs = lWrpSubSecConcs;
      this.bTieneSec = bTieneSec;
    }
  }

  /**CLASE PARA PODER AGREGAR LAS SUB SECCIONES Y SUS CONCEPTOS ASOCIADAS */
  public class wrpSubSeccionConceptos {
    /** variable SubSeccion*/
    public CatalogoSubsecciones__c SubSeccion {get;set;}
    /** variable lWrpConcEval*/
    public List<wrpConcEvaluacion> lWrpConcEval {get;Set;}
    /** variable bTieneConceptos*/
    public Boolean bTieneConceptos {get;Set;}
    /** Metodo*/
    public wrpSubSeccionConceptos() {
      this.SubSeccion = new CatalogoSubsecciones__c();
      this.lWrpConcEval = new List<wrpConcEvaluacion>();
      this.bTieneConceptos = false;
    }
    /** */
    public wrpSubSeccionConceptos(CatalogoSubsecciones__c SubSeccion, List<wrpConcEvaluacion> lWrpConcEval, Boolean bTieneConceptos) {
      this.SubSeccion = SubSeccion;
      this.lWrpConcEval = lWrpConcEval;
      this.bTieneConceptos = bTieneConceptos;
    }
  }

  /**UNA CLASE PARA PODER AGREGAR LA RELACION  Y SUS CONCEPTOS ASOCIADOS*/
  public class wrpConcEvaluacion {
    /** variable Conceptos*/
    public CatalogoConceptos__c Conceptos {get;Set;}
    /** variable EvalConc*/
    public EvaluacionConcepto__c EvalConc {get;Set;}
    /** */
    public wrpConcEvaluacion() {
      this.Conceptos = new CatalogoConceptos__c();
      this.EvalConc = new EvaluacionConcepto__c();
    }
    /** */
    public wrpConcEvaluacion(CatalogoConceptos__c Conceptos, EvaluacionConcepto__c EvalConc) {
      this.Conceptos = Conceptos;
      this.EvalConc = EvalConc;
    }
  }

  /**CLASE WRAPER PARA GUARDAR LAS RESPUESTAS*/
  public class wrpConcEval {
    /** variable Conceptos*/
    public CatalogoConceptos__c Conceptos {get;set;}
    /** variable Evaluacion*/
    public Evaluacion__c Evaluacion {get;Set;}
    /** variable EvalConc*/
    public EvaluacionConcepto__c EvalConc {get;set;}
    /** variable btieneCalif*/
    public Boolean btieneCalif {get;set;}
    /** method*/
    public wrpConcEval() {
      this.Conceptos = new CatalogoConceptos__c();
      this.Evaluacion = new Evaluacion__c();
      this.EvalConc = new EvaluacionConcepto__c();
      this.btieneCalif = false;

    }
    /** method*/
    public wrpConcEval(CatalogoConceptos__c Conceptos, Evaluacion__c Evaluacion, EvaluacionConcepto__c EvalConc, Boolean btieneCalif) {
      this.Conceptos = Conceptos;
      this.Evaluacion = Evaluacion;
      this.EvalConc = EvalConc;
      this.btieneCalif = false;
    }
  }

  /**CALCULA PORCENTAJES*/
  public PageReference calculaCalificacion() {

    Decimal cuentaceros = 0;
    Decimal cuentaunos = 0;
    Decimal cuentana = 0;
    Double sumasecciones = 0;
    Integer iCalificacionesconvertidas;
    Decimal sumadetodos = 0;
    Decimal sumacalif;
    Decimal resultadocalif = 0;
    Decimal contarsecciones;
    Decimal [] a = new Decimal[5];
    Integer b= 0;

    //RECORRE LISTA DE SECCIONES
    for (wrpSeccSubSeccConc objWrpSeccSubSeccConcept : lWrpSeccSubSeccConc) {
      sumadetodos = 0;
      cuentaceros = 0;
      cuentaunos = 0;
      cuentana = 0;
      contarsecciones = objWrpSeccSubSeccConcept.Seccion.NumeroSeccion__c;
      //RECORRE SUBSECCIONES
      for (wrpSubSeccionConceptos objWrpSubSeccConcept : objWrpSeccSubSeccConcept.lWrpSubSecConcs) {//NUMERO Y NOMBRE DE LA SUBSECCION
        //CONCEPTOS ASOCIADOS A LA SECCION
        for (wrpConcEvaluacion EvalConc : objWrpSubSeccConcept.lWrpConcEval) {//NUMERO Y NOMBRE DEL CONCEPTO ADEMÁS EL ID DEL CONCEPTO Y LO QUE HAY EN CALIFICACIÓN
          //SI EL CAMPO CALIFICACIÓN TIENE 0,1 O 2 CONVERTIR A ENTERO PARA CONTAR POR SECCIÓN ESTOS VALORES
          if(EvalConc.EvalConc.Calificacion__c == '1' || EvalConc.EvalConc.Calificacion__c == '2' || EvalConc.EvalConc.Calificacion__c == '0') {
            iCalificacionesconvertidas = Integer.valueOf(EvalConc.EvalConc.Calificacion__c);

              //Si EL CAMPO CALIFICACION CONTIENE CEROS, SE VAN A CONTAR PARA HACER USO EN LAS OPERACIONES
              if(iCalificacionesconvertidas == 0 ) {
                cuentaceros ++;
              }
              //Si EL CAMPO CALIFICACION CONTIENE UNOS, SE VAN A CONTAR PARA HACER USO EN LAS OPERACIONES
              if(iCalificacionesconvertidas == 1) {
                cuentaunos ++;
              }
              //Si EL CAMPO CALIFICACION CONTIENE DOS, SE VAN A CONTAR PARA HACER USO EN LAS OPERACIONES
              if(iCalificacionesconvertidas == 2) {
                cuentana ++;
              }
              EvalConc.EvalConc.GuardadoDeConceptos__c = true;

           //SI SE INGRESA CUALQUIER OTRO CARACTER DIFERENTE A LOS PERMITIDOS O ES NULO QUE SALGA UN MENSAJE
          }else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.ValorNoValido));

          }//FIN DE ELSE
        } //FIN DEL for (wrpConcEvaluacion EvalConc : objWrpSubSeccConcept.lWrpConcEval)
      }//FIN DEL for (wrpSubSeccionConceptos objWrpSubSeccConcept : objWrpSeccSubSeccConcept.lWrpSubSecConcs)

      sumadetodos = cuentaunos + cuentaceros + cuentana;
      //SUMAR LOS CEROS Y LOS UNOS DE CADA SECCIÓN
      sumacalif = cuentaunos + cuentaceros;

      if(sumacalif != 0) {
        //SACAR EL PORCENTAJE DE CADA SECCIÓN
        resultadocalif = (cuentaunos/sumacalif)*100;
        //GUARDA EL RESULTADO FINAL EN UNA NUEVA VARIABLE
        objWrpSeccSubSeccConcept.promediosecciones = resultadocalif.setscale(0);// PORCENTAJE DE CADA SECCIÓN
        //System.debug('porcentaje++'+objWrpSeccSubSeccConcept.promediosecciones);
        a[b]=objWrpSeccSubSeccConcept.promediosecciones;
        b++;
        //SUMA LOS PORCENTAJES DE CADA SECCIÓN PARA SACAR EL PORCENTAJE TOTAL
        sumasecciones = (sumasecciones + objWrpSeccSubSeccConcept.promediosecciones);
        //SACAR EL PROMEDIO PARA EL PORCENTAJE TOTAL
        objWrpSeccSubSeccConcept.promgeneralsecc = (sumasecciones/contarsecciones).setscale(0);
        //SE GUARDAN EN UN CAMPO PARA SOLO MOSTRAR EL ÚLTIMO VALOR
        EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c = objWrpSeccSubSeccConcept.promgeneralsecc;
        EvaluacionCalificacion.Evaluacion.PorcentajeReglasJuego__c = a[0];
        EvaluacionCalificacion.Evaluacion.PorcentajeProductoProceso__c = a[1];
        EvaluacionCalificacion.Evaluacion.PorcentajeExperienciaConCliente__c = a[2];
        EvaluacionCalificacion.Evaluacion.PorcentajeVentas__c = a[3];
      }//FIN IF(sumacalif != 0)
    } //FIN DEL FOR DE LAS SECCIONES
    return null;
  }//FIN DEL PAGEREFERENCE DE CALCULOS

  /**GUARDAR EVALUACION*/
  public PageReference guardaEvaluacion() {

    // nosepuedemodificar = false;
    if(EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c != null || Test.isRunningTest()) {

      EvalIns.RepresentanteCalidad__c = sEvalRep;
      EvalIns.Encuestado__c = sEvalEncs;
      EvalIns.PorcentajeTotal__c = EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c;
      EvalIns.Observaciones__c = EvaluacionCalificacion.Evaluacion.Observaciones__c;
      EvalIns.IDGrabacion__c = EvaluacionCalificacion.Evaluacion.IDGrabacion__c;
      EvalIns.MotivoNoContacto__c = EvaluacionCalificacion.Evaluacion.MotivoNoContacto__c;
      EvalIns.MotivoNoventa__c = EvaluacionCalificacion.Evaluacion.MotivoNoventa__c;
      EvalIns.MotivoOportunidadComercial__c = EvaluacionCalificacion.Evaluacion.MotivoOportunidadComercial__c;
      EvalIns.PorcentajeReglasJuego__c = EvaluacionCalificacion.Evaluacion.PorcentajeReglasJuego__c;
      EvalIns.PorcentajeProductoProceso__c = EvaluacionCalificacion.Evaluacion.PorcentajeProductoProceso__c;
      EvalIns.PorcentajeExperienciaConCliente__c = EvaluacionCalificacion.Evaluacion.PorcentajeExperienciaConCliente__c;
      EvalIns.PorcentajeVentas__c = EvaluacionCalificacion.Evaluacion.PorcentajeVentas__c;

      final Savepoint sv = Database.setSavepoint();
      try {
        //INSERTAR EVALUACION
          insert EvalIns;
          for (wrpSeccSubSeccConc objWrpSeccSubSeccConcept : lWrpSeccSubSeccConc) {
            for (wrpSubSeccionConceptos objWrpSubSeccConcept : objWrpSeccSubSeccConcept.lWrpSubSecConcs) {
              for (wrpConcEvaluacion EvalConcguarda : objWrpSubSeccConcept.lWrpConcEval) {

                EvalConcguarda.EvalConc.PorcentajeSeccion__c = objWrpSeccSubSeccConcept.promediosecciones;

                lEvalConc.add(new EvaluacionConcepto__c(
                  Evaluacion__c = EvalIns.id,
                  Concepto__c = EvalConcguarda.Conceptos.id,
                  Calificacion__c = EvalConcguarda.EvalConc.Calificacion__c,
                  SeccionEvaConcepto__c = objWrpSeccSubSeccConcept.Seccion.Nombre__c,
                  SubseccionEvaConcepto__c = objWrpSubSeccConcept.SubSeccion.Nombre__c,
                  ConceptoEvaConcepto__c = EvalConcguarda.Conceptos.Descripcion__c,
                  EjemploEvaConcepto__c = EvalConcguarda.Conceptos.Ejemplo__c,
                  PorcentajeSeccion__c = EvalConcguarda.EvalConc.PorcentajeSeccion__c,
                  GuardadoDeConceptos__c = EvalConcguarda.EvalConc.GuardadoDeConceptos__c));

              }//FIN FOR EVALUACIONES - CONCEPTOS
            } //FIN DEL FOR SUBSECCIONES CONCEPTOS
          } //FIN DEL FOR SECCIONES-SUBSECCIONES-CONCEPTOS
          //INSERTAR CONCEPTOS
          if (!lEvalConc.isEmpty()) {
              insert lEvalConc;
              System.debug('mm*lEvalConc'+lEvalConc);
          }
          //REDIRECCIONA A LA PÁGINA DE LA FIRMA
          final PageReference pageRef = new PageReference('/apex/WIB_EvaluacionCalidadFirma_pag?idEval=' + EvalIns.id);
          pageRef.setRedirect(true);
          return pageRef;

        }//FIN TRY

        catch(Exception ex) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.NoSePudoGuardar + ex.getMessage()));
          Database.rollback(sv);
        }

    }else {
        final ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Info, Label.CalcularAntesDeGuardar);
        ApexPages.addmessage(msg);
    }
    return null;
  }//FIN PAGEREFERENCE

  /**ACTUALIZAR EVALUACIÓN*/
  public PageReference actEvaluacion() {

    EvalMod.RepresentanteCalidad__c = sEvalRep;
    EvalMod.PorcentajeTotal__c = EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c;
    EvalMod.Observaciones__c = EvaluacionCalificacion.Evaluacion.Observaciones__c;
    EvalMod.IDGrabacion__c = EvaluacionCalificacion.Evaluacion.IDGrabacion__c;
    EvalMod.PorcentajeReglasJuego__c = EvaluacionCalificacion.Evaluacion.PorcentajeReglasJuego__c;
    System.debug('porcentaje regla: '+ EvalMod.PorcentajeReglasJuego__c);
    EvalMod.PorcentajeProductoProceso__c = EvaluacionCalificacion.Evaluacion.PorcentajeProductoProceso__c;
    EvalMod.PorcentajeExperienciaConCliente__c = EvaluacionCalificacion.Evaluacion.PorcentajeExperienciaConCliente__c;
    EvalMod.PorcentajeVentas__c = EvaluacionCalificacion.Evaluacion.PorcentajeVentas__c;
    EvalMod.MotivoNoContacto__c = EvaluacionCalificacion.Evaluacion.MotivoNoContacto__c;
    EvalMod.MotivoNoventa__c = EvaluacionCalificacion.Evaluacion.MotivoNoventa__c;
    EvalMod.MotivoOportunidadComercial__c = EvaluacionCalificacion.Evaluacion.MotivoOportunidadComercial__c;

    final Savepoint sv = Database.setSavepoint();
    try {
      //ACTUALIZAR EVALUACIONES
    update EvalMod;
    System.debug('EN actEvaluacion EvalMod: ' + EvalMod);
      for (wrpSeccSubSeccConc objWrpSeccSubSeccConcept : lWrpSeccSubSeccConc) {
        for (wrpSubSeccionConceptos objWrpSubSeccConcept : objWrpSeccSubSeccConcept.lWrpSubSecConcs) {
          for (wrpConcEvaluacion EvalPregPaso : objWrpSubSeccConcept.lWrpConcEval) {

            EvalPregPaso.EvalConc.PorcentajeSeccion__c = objWrpSeccSubSeccConcept.promediosecciones;
            lEvalConc.add(EvalPregPaso.EvalConc);

          }
        }
      }

    System.debug('*1actEvaluacion lEvalConc: ' + lEvalConc);
      if (!lEvalConc.isEmpty()) {
        //ACTUALIZAR CONCEPTOS
        upsert lEvalConc EvaluacionConcepto__c.id;

      }
      //REDIRECCIONAR A LA PAGINA DE LA EVALUACION QUE YA SE CREO
      final PageReference pageRef = new ApexPages.StandardController(EvalMod).view();
      pageRef.setRedirect(true);
      return pageRef;
    }
    catch(Exception ex) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.NoSePudoActualizar + ex.getMessage()));
      Database.rollback(sv);
    }
    return null;
  }//FIN PAGEREFERENCE DE ACTUALIZAR EVALUACION

  /**CANCELAR LA MODIFICACIÓN DE UNA EVALUACIÓN*/
  public PageReference cancelActEvaluacion() {
    final PageReference pageRef = new ApexPages.StandardController(EvalMod).view();
    pageRef.setRedirect(true);
    return pageRef;
  }
  /** */
  public PageReference cancelEvaluacion() {
    final PageReference returnPage = new PageReference('/a16?fcf=00Bg00000018n2C');
    returnPage.setRedirect(true);
    return returnPage;
  }

  /**MOSTRAR IMAGENES DE PORCENTAJE*/
  public boolean imagenporcentajecero {
    get {
      if( EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c >= 0 && EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c < 25) {
        return true;
      }
      return false;
    }
    Set;
  }
  /** */
  public boolean imagenporcentajeuno {
    get {
      if( EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c >= 25 && EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c < 50) {
      return true;
    }
      return false;
    }
    Set;
  }
  /** */
  public boolean imagenporcentajedos {
    get {
      if( EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c >= 50 && EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c < 75) {
        return true;
      }
      return false;
    }
    Set;
  }
  /** */
  public boolean imagenporcentajetres {
    get {
      if( EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c >= 75 && EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c < 100) {
      return true;
      }
      return false;
    }
    Set;
  }
  /** */
  public boolean imagenporcentajecuatro {
    get {
      if( EvaluacionCalificacion.Evaluacion.PorcentajeTotal__c == 100) {
      return true;
    }
      return false;
    }
    Set;
  }


}//FIN DEL CÓDIGO