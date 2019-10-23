/**
* ------------------------------------------------------------------------------------------------
* @Name     MX_WB_EvaluacionCalidad_ctrl
* @Author   Salvador Reyna Gonzalez
* @Date     Created: 2019-01-09
* @Group  	Telemarketing
* @Description This class works as a controller for the component MX_WB_EvaluacionCalidad
* @Changes
*/
public without sharing class MX_WB_EvaluacionCalidad_ctrl {
    /**
    * 
    */	
    static List<Id> ListNoSeccion = new List<Id>();
    /**
    * 
    */
    static List<Id> ListNoSubseccion = new List<Id>();
    /**
    * 
    */
    static List<Id> ListNoConcepto = new List<Id>();
    /**
    * 
    */
    static List<WrapperSeccionSubseccionConcepto> listWrapperSeccionSubseccionConcepto = new List<WrapperSeccionSubseccionConcepto>();
    /**
    * 
    */
    static Map<Id, CatalogoSeccion__c> mapSeccion = new Map<Id, CatalogoSeccion__c>();
    /**
    * 
    */
    static Map<Id, CatalogoSubsecciones__c> mapSubseccion = new Map<Id, CatalogoSubsecciones__c>();
    /**
    * 
    */
    static Map<String, Map<String, List<CatalogoConceptos__c>>> mapSeccionSubSeccionConcepto = new Map<String, Map<String, List<CatalogoConceptos__c>>>();

    private MX_WB_EvaluacionCalidad_ctrl() {}

    /**
    * @description Searches a record related to the Opportunity in the Evaluacion__c object using the "idOpportunity" param
    * @Param String idOpportunity
    * @return Evaluacion__c
    */
    @AuraEnabled
    public static WrapperEvaluacionInfo obtieneEvaluacion(Id idOpportunity) {
        final WrapperEvaluacionInfo wrapperEvaluacion = new WrapperEvaluacionInfo();
        final Map<Id, MX_WB_EvaluacionSeccion__c> mapEvaluacionSeccion = new Map<Id, MX_WB_EvaluacionSeccion__c>();
        final Map<Id , EvaluacionConcepto__c> mapEvaluacionConcepto = new Map<Id , EvaluacionConcepto__c>();
        try {
            if(idOpportunity.getSobjectType() == Schema.Opportunity.SObjectType) {
                wrapperEvaluacion.evaluacion = [Select MX_WB_ErroresFatales__c, MX_WB_ErroresNoFatales__c, MX_WB_PuntajeTotal__c, MX_WB_PuntajeBase__c, MX_WB_Cotizacion__c,
                			CreatedDate, Encuestado__c,BarraPorcentaje__c, RepresentanteCalidad__c, PorcentajeTotal__c,
                            Observaciones__c, IDGrabacion__c,PorcentajeReglasJuego__c,PorcentajeExperienciaConCliente__c,
                            PorcentajeProductoProceso__c, PorcentajeVentas__c,OwnerId From Evaluacion__c Where MX_WB_Cotizacion__c =: idOpportunity];
                for(MX_WB_EvaluacionSeccion__c evs :  [Select MX_WB_CatalogoSeccion__c, MX_WB_DejarDeHacer__c, MX_WB_EmpezarAHacer__c, MX_WB_SeguirHaciendo__c From MX_WB_EvaluacionSeccion__c Where MX_WB_Evaluacion__r.MX_WB_Cotizacion__c =: idOpportunity]) {
                    mapEvaluacionSeccion.put(evs.MX_WB_CatalogoSeccion__c , evs);
                }
                wrapperEvaluacion.evaluacionSecciones = mapEvaluacionSeccion;

                wrapperEvaluacion.evaluacionPuntosEntrenamiento = [Select MX_WB_Concepto__c, MX_WB_PuntoEntrenamiento__c, Id From MX_WB_EvaluacionPuntosEntrenamiento__c Where MX_WB_Evaluacion__r.MX_WB_Cotizacion__c =: idOpportunity];

                wrapperEvaluacion.evaluacionSecciones = mapEvaluacionSeccion;
                for(EvaluacionConcepto__c evc :  [Select Id, EjemploEvaConcepto__c,SeccionEvaConcepto__c,SubseccionEvaConcepto__c,ConceptoEvaConcepto__c ,Calificacion__c,PorcentajeSeccion__c, Concepto__c, Evaluacion__c From EvaluacionConcepto__c Where Evaluacion__r.MX_WB_Cotizacion__c =: idOpportunity]) {
                    mapEvaluacionConcepto.put(evc.Concepto__c , evc);
                }
                wrapperEvaluacion.evaluacionConceptos = mapEvaluacionConcepto;
            } else {
                throw new CustomException(Label.MX_WB_CL_ExceptionListMsg, 'Invalid Id', Label.MX_WB_CL_ExceptionListType, 0);
            }
        } catch(CustomException er) {
            throw new AuraHandledException(System.Label.MX_WB_LG_ErrorBack + er);
        }
        return wrapperEvaluacion;
    }
    /*******************************************************************************************************
    * @description InnerClass used as a Wrrapper to return all the evaluacion info
    */
    public class WrapperEvaluacionInfo {
        /**
        * 
        */
        @auraEnabled public Evaluacion__c evaluacion {get;set;}
        /**
        * 
        */
        @auraEnabled public Map<Id , EvaluacionConcepto__c> evaluacionConceptos {get;set;}
        /**
        * 
        */
        @AuraEnabled public Map<Id, MX_WB_EvaluacionSeccion__c> evaluacionSecciones {get;set;}
        /**
        * 
        */
        @AuraEnabled public List<MX_WB_EvaluacionPuntosEntrenamiento__c> evaluacionPuntosEntrenamiento {get;set;}
    }

    /*
    * @description Loads the data of Sections, Subsections and Concepts configured, returns a list of ordered sections, subsections and concepts Wrappers
    * @return List<wrapperSeccSubSeccConc>
	*/
    @AuraEnabled
    public static WrapperConfiguracion cargaConfiguracion() {
        final WrapperConfiguracion returnConfiguration = new WrapperConfiguracion();
        returnConfiguration.permisoModificar = false;
        if(Schema.sObjectType.Evaluacion__c.isUpdateable()) {
            returnConfiguration.permisoModificar = true;
        }
        try {
            for (CatalogoSeccion__c seccion : [SELECT c.NumeroSeccion__c, c.Nombre__c, c.Id FROM CatalogoSeccion__c c ORDER BY NumeroSeccion__c]) {
                ListNoSeccion.add(seccion.Id);
                mapSeccion.put(seccion.Id , seccion);
            }
            for (CatalogoSubsecciones__c subSeccion : [SELECT c.Numero__c, c.Nombre__c, c.Id FROM CatalogoSubsecciones__c c ORDER BY Numero__c]) {
                ListNoSubseccion.add(subSeccion.Id);
                mapSubseccion.put(subSeccion.Id, subSeccion);
            }
            for (CatalogoConceptos__c concepto : [SELECT c.NoConcepto__c, c.Name, c.Id, c.Descripcion__c, c.Ejemplo__c FROM CatalogoConceptos__c c ORDER BY NoConcepto__c]) {
                ListNoConcepto.add(concepto.Id);
            }

            final String sQuery = 'SELECT s.CatalogoSeccion__r.Id, s.CatalogoSeccion__r.Nombre__c, s.CatalogoSeccion__r.NumeroSeccion__c,'+
                ' s.CatalogoSubseccion__r.Nombre__c, s.CatalogoSubseccion__r.Numero__c,s.CatalogoConceptos__r.Descripcion__c,'+
                ' s.CatalogoConceptos__r.NoConcepto__c, s.CatalogoConceptos__r.MX_WB_Ponderacion__c, s.CatalogoConceptos__r.MX_WB_ClasificacionErrorNoVenta__c,'+
                ' s.CatalogoConceptos__r.MX_WB_ClasificacionErrorVenta__c, s.CatalogoConceptos__r.Activa__c, s.CatalogoConceptos__r.Ejemplo__c,'+
                ' s.CatalogoConceptos__r.MX_WB_PuntosEntrenamiento__c FROM SeccionSubseccionConcepto__c s WHERE s.RecordType.Name = \'Outbound\''+
                ' ORDER BY s.CatalogoSeccion__r.NumeroSeccion__c, s.CatalogoSubseccion__r.Numero__c, s.CatalogoConceptos__r.NoConcepto__c';
            final List<SObject> listObject = Database.query(sQuery);

            if(listObject.isEmpty() ) {
                throw new CustomException(Label.MX_WB_CL_ExceptionListMsg, 'Invalid Id', Label.MX_WB_CL_ExceptionListType, 0);
            } else {
                mapSeccionSubSeccionConcepto = getmapSeccionSubSeccionConcepto(listObject);
                listWrapperSeccionSubseccionConcepto = getListSCC();
            }
        } catch(CustomException er) {
            throw new AuraHandledException(System.Label.MX_WB_LG_ErrorBack + er);
        }

        returnConfiguration.wrapperSSC = listWrapperSeccionSubseccionConcepto;
        return returnConfiguration;
    }

    /*
    * @description Analizes a list of SeccionSubseccionCatalogo__c and fills a Map ordered
    * @return List<WrapperSeccionSubseccionConcepto>
	*/
    public static List<WrapperSeccionSubseccionConcepto> getListSCC() {
        final List<WrapperSeccionSubseccionConcepto> listWrapperSeccionSubseccionConcepto = new List<WrapperSeccionSubseccionConcepto>();
        for(Id idSeccion : ListNoSeccion) {
            final CatalogoSeccion__c seccion = mapSeccion.get(idSeccion);
            if(mapSeccionSubSeccionConcepto.containsKey(seccion.Id)) {
                final Map<String, List<CatalogoConceptos__c>> mapSubseccionConcepto = mapSeccionSubSeccionConcepto.get(seccion.Id);
                if(!mapSubseccionConcepto.KeySet().isEmpty()) {
                    listWrapperSeccionSubseccionConcepto.add(analizeSectionSubsectionConcept(mapSubseccionConcepto, seccion, true));
                }
                if (mapSeccionSubSeccionConcepto.KeySet().isEmpty()) {
                    listWrapperSeccionSubseccionConcepto.add( new WrapperSeccionSubseccionConcepto(seccion, new List<WrapperSubSeccionConceptos>(), false ) );
                }
            }
        }
        return listWrapperSeccionSubseccionConcepto;
    }
    /*
    * @description Analizes and creates a WrapperSeccionSubseccionConcepto for a given Section-Subsection-Concept
    * @return WrapperSeccionSubseccionConcepto
	*/
    public static WrapperSeccionSubseccionConcepto analizeSectionSubsectionConcept(Map<String, List<CatalogoConceptos__c>> mapSubseccionConcepto ,CatalogoSeccion__c seccion, boolean bTieneSeccion) {
        final List<WrapperSubSeccionConceptos> lWrapperSubSeccionConcepto = new List<WrapperSubSeccionConceptos>();
        for (Id idSubseccion : ListNoSubseccion) {
            final CatalogoSubsecciones__c iSubseccion = mapSubseccion.get(idSubseccion);
            if (mapSubseccionConcepto.containsKey(iSubseccion.Nombre__c)) {
                final List<CatalogoConceptos__c> listConceptos = mapSubseccionConcepto.get(iSubseccion.Nombre__c);
                final CatalogoSubsecciones__c subseccion = new CatalogoSubsecciones__c(Numero__c = iSubseccion.Numero__c, Nombre__c = iSubseccion.Nombre__c);
                final List<WrapperEvaluacionConcepto> listWrapperEvaluacionConcepto = new List<WrapperEvaluacionConcepto>();
                Boolean bTieneConceptos = false;
                if (listConceptos.size() > 0 ) {
                    for (Id idNoConcepto : ListNoConcepto) {
                        for (CatalogoConceptos__c concepto : listconceptos) {
                            if (concepto.Id == idNoConcepto) {
                                listWrapperEvaluacionConcepto.add( new WrapperEvaluacionConcepto( concepto, new EvaluacionConcepto__c(Concepto__c = concepto.id)) );
                                bTieneConceptos = true;
                            }
                        }
                    }
                    lWrapperSubSeccionConcepto.add(new WrapperSubseccionConceptos(SubSeccion, listWrapperEvaluacionConcepto, bTieneConceptos) );
                }
            }
        }
        return new WrapperSeccionSubseccionConcepto(seccion, lWrapperSubSeccionConcepto, bTieneSeccion);
    }
    /*******************************************************************************************************
    * @description Analizes a list of SeccionSubseccionCatalogo__c and fills a Map ordered
    * @return Map<String, Map<String, List<CatalogoConceptos__c>>>
	*/
    public static Map<String, Map<String, List<CatalogoConceptos__c>>> getmapSeccionSubSeccionConcepto(List<SObject> listObject) {
        final Map<String, Map<String, List<CatalogoConceptos__c>>> mapSeccionSubSeccionConcepto = new Map<String, Map<String, List<CatalogoConceptos__c>>>();
        for (SObject sObjetSeccionSubseccionConcepto : listObject) {
            final SeccionSubseccionConcepto__c seccionSubseccionConcepto =(SeccionSubseccionConcepto__c) sObjetSeccionSubseccionConcepto;
            final String nombreSubSeccion = seccionSubseccionConcepto.CatalogoSubseccion__r.Nombre__c == null ? '':seccionSubseccionConcepto.CatalogoSubseccion__r.Nombre__c;
            final CatalogoConceptos__c concepto = new CatalogoConceptos__c(id = seccionSubseccionConcepto.CatalogoConceptos__c,
                    NoConcepto__c = Integer.valueOf(seccionSubseccionConcepto.CatalogoConceptos__r.NoConcepto__c),
                    Descripcion__c = seccionSubseccionConcepto.CatalogoConceptos__r.Descripcion__c,
					Ejemplo__c = seccionSubseccionConcepto.CatalogoConceptos__r.Ejemplo__c,
                    MX_WB_Ponderacion__c = seccionSubseccionConcepto.CatalogoConceptos__r.MX_WB_Ponderacion__c,
                    MX_WB_ClasificacionErrorVenta__c = seccionSubseccionConcepto.CatalogoConceptos__r.MX_WB_ClasificacionErrorVenta__c,
					MX_WB_ClasificacionErrorNoVenta__c = seccionSubseccionConcepto.CatalogoConceptos__r.MX_WB_ClasificacionErrorNoVenta__c,
                    MX_WB_PuntosEntrenamiento__c = seccionSubseccionConcepto.CatalogoConceptos__r.MX_WB_PuntosEntrenamiento__c);

            if (mapSeccionSubSeccionConcepto.containsKey(seccionSubseccionConcepto.CatalogoSeccion__c)) {
                if (mapSeccionSubSeccionConcepto.get(seccionSubseccionConcepto.CatalogoSeccion__c).containsKey(nombreSubSeccion)) {
                    mapSeccionSubSeccionConcepto.get(seccionSubseccionConcepto.CatalogoSeccion__c).get(nombreSubSeccion).add(concepto);
                }
                if (!mapSeccionSubSeccionConcepto.get(seccionSubseccionConcepto.CatalogoSeccion__c).containsKey(nombreSubSeccion)) {
                    mapSeccionSubSeccionConcepto.get(seccionSubseccionConcepto.CatalogoSeccion__c).put(nombreSubSeccion, new List<CatalogoConceptos__c>{concepto});
                }
            } else if(!mapSeccionSubSeccionConcepto.containsKey(seccionSubseccionConcepto.CatalogoSeccion__c)) {
                mapSeccionSubSeccionConcepto.put(seccionSubseccionConcepto.CatalogoSeccion__c, new Map<String, List<CatalogoConceptos__c>>{nombreSubSeccion => new List<CatalogoConceptos__c>{concepto}});
            }
        }
        return mapSeccionSubSeccionConcepto;
    }

    /*******************************************************************************************************
    * @description Analize a String and split it by the '.' char, then returns the first part of it or the rest parts of the String
    * @Param String Cadena
    * @Param Boolean isInicial
    * @return String
	*/
    private static String obtieneCadena(String cadena, Boolean esInicial) {
        String returnCadena = '';
        final List<String>listCadena= cadena.split('\\.');
        if(esInicial) {
            returnCadena = listCadena.get(0);
        } else {
            for(Integer indice = 1;indice<listCadena.size(); indice++) {
                returnCadena+=listCadena.get(indice);
            }
        }
        return returnCadena;
    }
    /*******************************************************************************************************
	* @description Inserts or updates Evaluacion__c, EvaluacionConcepto__c and MX_WB_EvaluacionSeccion__c,
	* 		updates the opportunity MX_WB_EvaluacionCalidad__c field if the Evaluacion__c record has been succesfully saved.
    * @Param Evaluacion__c evaluacion
    * @Param String evaluacionConcepto
    * @Param String evaluacionesSeccion
    * @Param Boolean isUpdate
    * @return wrapperMessage
    */
    @AuraEnabled
    public static WrapperMessage guardaEvaluacion(Evaluacion__c evaluacion,String evaluacionesConcepto, String evaluacionesSeccion, String evaluacionPuntosEntrenamiento, List<String> toDelete, Boolean isUpdate) {
        final WrapperMessage resultado =  new WrapperMessage();
        final RecordType rtEvaluacion = [Select Id from RecordType Where SObjectType ='Evaluacion__c' AND DeveloperName='Outbound'];

        List<EvaluacionConcepto__c> lstEvaluacionConcepto =  new List<EvaluacionConcepto__c>();
        List<MX_WB_EvaluacionSeccion__c> lstEvaluacionSeccion=  new List<MX_WB_EvaluacionSeccion__c>();
        final List<MX_WB_EvaluacionPuntosEntrenamiento__c> lstEvaluacionPuntoEntrenamiento =  new List<MX_WB_EvaluacionPuntosEntrenamiento__c>();
        final List<MX_WB_EvaluacionPuntosEntrenamiento__c> lstEvaluacionPuntoEntrenamientoBorrar =  new List<MX_WB_EvaluacionPuntosEntrenamiento__c>();
        final List<MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionPuntoEntrenamiento> listEvaluacionPuntosEntrenamiento = (List<MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionPuntoEntrenamiento>)JSON.deserialize(evaluacionPuntosEntrenamiento, List<MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionPuntoEntrenamiento>.class);
        final List<MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionConceptoInfo> listEvaluacionConceptos = (List<MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionConceptoInfo>)JSON.deserialize(evaluacionesConcepto, List<MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionConceptoInfo>.class);
        final List<MX_WB_EvaluacionCalidad_ctrl.wrapperEvaluacionSeccion> listEvaluacionSecciones = (List<MX_WB_EvaluacionCalidad_ctrl.wrapperEvaluacionSeccion>)JSON.deserialize(evaluacionesSeccion, List<MX_WB_EvaluacionCalidad_ctrl.wrapperEvaluacionSeccion>.class);
        final Savepoint sv = Database.setSavepoint();
        try {
            for(String puntoEliminia: toDelete) {
                lstEvaluacionPuntoEntrenamientoBorrar.add(new MX_WB_EvaluacionPuntosEntrenamiento__c(Id=puntoEliminia));
            }

            delete lstEvaluacionPuntoEntrenamientoBorrar;
            for(MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionPuntoEntrenamiento wprPuntoEntrenamiento : listEvaluacionPuntosEntrenamiento ) {
                final MX_WB_EvaluacionPuntosEntrenamiento__c evaluacionPunto =  new MX_WB_EvaluacionPuntosEntrenamiento__c();
                evaluacionPunto.MX_WB_Concepto__c = wprPuntoEntrenamiento.idConcepto;
                evaluacionPunto.MX_WB_PuntoEntrenamiento__c = wprPuntoEntrenamiento.label;
                lstEvaluacionPuntoEntrenamiento.add(evaluacionPunto);
            }
            lstEvaluacionConcepto = checkWrapperEvaluacion(listEvaluacionConceptos, isUpdate);
            lstEvaluacionSeccion = checkWrapperSeccion(listEvaluacionSecciones, isUpdate);
            if(isUpdate) {
                update evaluacion;
                update lstEvaluacionConcepto;
                update lstEvaluacionSeccion;

                for(MX_WB_EvaluacionPuntosEntrenamiento__c puntoEntrenamiento: lstEvaluacionPuntoEntrenamiento) {
                    puntoEntrenamiento.MX_WB_Evaluacion__c = evaluacion.Id;
                }
                insert lstEvaluacionPuntoEntrenamiento;

                resultado.status = 'OK';
                resultado.message ='La evaluación se actualizó exitosamente.';
            } else {
                evaluacion.RecordTypeId = rtEvaluacion.Id;
                insert evaluacion;
                final Opportunity opp = new Opportunity();
                opp.Id = evaluacion.MX_WB_Cotizacion__c;
                opp.MX_WB_EvaluacionCalidad__c = 'Realizada';
                update opp;
                for(EvaluacionConcepto__c evalua: lstEvaluacionConcepto) {
                    evalua.Evaluacion__c = evaluacion.Id;
                }
                for(MX_WB_EvaluacionSeccion__c evalua: lstEvaluacionSeccion) {
                    evalua.MX_WB_Evaluacion__c = evaluacion.Id;
                }
                for(MX_WB_EvaluacionPuntosEntrenamiento__c puntoEntrenamiento: lstEvaluacionPuntoEntrenamiento) {
                    puntoEntrenamiento.MX_WB_Evaluacion__c = evaluacion.Id;
                }
                insert lstEvaluacionPuntoEntrenamiento;

                insert lstEvaluacionConcepto;
                insert lstEvaluacionSeccion;
                resultado.status = 'OK';
                resultado.message = System.label.MX_WB_EvaluacionGuardada;
            }
        } catch(Exception ex) {
            resultado.status = 'ERROR';
            resultado.message = System.label.MX_WB_LG_ErrorBack + '. Detalle: ' + ex.getMessage();
            Database.rollback(sv);
        }
        return resultado;
    }

    /*******************************************************************************************************
	* @description Evaluates the Concepts and return a List of EvalucionConcepto__c
    * @Param List<MX_WB_EvaluacionCalidad_ctrl.wrapperEvaluacionConceptoInfo> listEvaluacionConceptos
    * @Param boolean isUpdate
    * @return List<EvaluacionConcepto__c>
    */
    public static List<EvaluacionConcepto__c> checkWrapperEvaluacion(List<MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionConceptoInfo> listEvaluacionConceptos, boolean isUpdate) {
        final List<EvaluacionConcepto__c> innerLstEvaluacionConcepto =  new List<EvaluacionConcepto__c>();
        for(MX_WB_EvaluacionCalidad_ctrl.WrapperEvaluacionConceptoInfo wprEvaluacionConcepto : listEvaluacionConceptos ) {
                final EvaluacionConcepto__c evaluacionConcepto =  new EvaluacionConcepto__c();
                if(isUpdate) {
                    evaluacionConcepto.Id = wprEvaluacionConcepto.idEvaluacionConcepto;
                } else {
                    evaluacionConcepto.Concepto__c  = wprEvaluacionConcepto.concepto;
                }
                evaluacionConcepto.Calificacion__c = wprEvaluacionConcepto.calificacion;
                evaluacionConcepto.SeccionEvaConcepto__c = wprEvaluacionConcepto.seccionEvaConcepto;
                evaluacionConcepto.SubseccionEvaConcepto__c  = wprEvaluacionConcepto.subseccionEvaConcepto;
                evaluacionConcepto.ConceptoEvaConcepto__c = wprEvaluacionConcepto.conceptoEvaConcepto;
                evaluacionConcepto.EjemploEvaConcepto__c = wprEvaluacionConcepto.ejemploEvaConcepto;
                evaluacionConcepto.PorcentajeSeccion__c = wprEvaluacionConcepto.porcentajeSeccion;
                evaluacionConcepto.MX_WB_Ponderacion__c = wprEvaluacionConcepto.ponderacion;
                evaluacionConcepto.GuardadoDeConceptos__c = wprEvaluacionConcepto.guardadoDeConceptos;
                evaluacionConcepto.MX_WB_ErrorFatal__c = wprEvaluacionConcepto.errorFatal;
                innerLstEvaluacionConcepto.add(evaluacionConcepto);
            }
        return innerLstEvaluacionConcepto;
    }

    /*******************************************************************************************************
	* @description Evaluates the Sections and return a List of MX_WB_EvaluacionSeccion__c
    * @Param List<MX_WB_EvaluacionCalidad_ctrl.wrapperEvaluacionSeccion>
    * @Param boolean isUpdate
    * @return List<MX_WB_EvaluacionSeccion__c>
    */
    public static List<MX_WB_EvaluacionSeccion__c> checkWrapperSeccion(List<MX_WB_EvaluacionCalidad_ctrl.wrapperEvaluacionSeccion> listEvaluacionSecciones, boolean isUpdate) {
        final List<MX_WB_EvaluacionSeccion__c> innerLstEvaluacionSeccion=  new List<MX_WB_EvaluacionSeccion__c>();
        for(MX_WB_EvaluacionCalidad_ctrl.wrapperEvaluacionSeccion wprEvaluacionSeccion : listEvaluacionSecciones ) {
                final MX_WB_EvaluacionSeccion__c evaSeccion =  new MX_WB_EvaluacionSeccion__c();
                if(isUpdate) {
                    evaSeccion.Id = wprEvaluacionSeccion.idEvaluacionSeccion;
                } else {
                    evaSeccion.MX_WB_CatalogoSeccion__c  = wprEvaluacionSeccion.CatalogoSeccion;
                }
                evaSeccion.MX_WB_SeguirHaciendo__c = wprEvaluacionSeccion.SeguirHaciendo;
                evaSeccion.MX_WB_DejarDeHacer__c = wprEvaluacionSeccion.DejarDeHacer;
                evaSeccion.MX_WB_EmpezarAHacer__c = wprEvaluacionSeccion.EmpezarAHacer;
                innerLstEvaluacionSeccion.add(evaSeccion);
            }
        return innerLstEvaluacionSeccion;
    }

    /*******************************************************************************************************
    * @description InnerClass used as a Wrrapper to return the relationship between Section, Subsection and Concept
    */
    public class WrapperConfiguracion {
        /**
        * 
        */
        @AuraEnabled public List<WrapperSeccionSubseccionConcepto> wrapperSSC {get;Set;}
        /**
        * 
        */
        @AuraEnabled public boolean permisoModificar {get;Set;}
    }

    /*******************************************************************************************************
    * @description InnerClass used as a Wrrapper to return the relationship between Section, Subsection and Concept
    */
    public class WrapperSeccionSubseccionConcepto {
        /**
        * 
        */
        @AuraEnabled public CatalogoSeccion__c seccion {get;Set;}
        /**
        * 
        */
        @AuraEnabled public String nombreInicial {get;Set;}
        /**
        * 
        */
        @AuraEnabled public String nombreFinal {get;Set;}
        /**
        * 
        */
        @AuraEnabled public List<wrapperSubseccionConceptos> listWrapperSubseccionConceptos {get;set;}
        /**
        * 
        */
        @AuraEnabled public Boolean bTieneSeccion {get;Set;}
    /**
    * 
    */
        public WrapperSeccionSubseccionConcepto(CatalogoSeccion__c seccion, List<WrapperSubSeccionConceptos> listWrapperSubseccionConceptos, Boolean bTieneSeccion) {
            this.seccion = seccion;
            this.listWrapperSubseccionConceptos = listWrapperSubseccionConceptos;
            this.bTieneSeccion = bTieneSeccion;
            this.nombreInicial = obtieneCadena(seccion.Nombre__c, true);
            this.nombreFinal = obtieneCadena(seccion.Nombre__c, false);
        }
    }

    /*******************************************************************************************************
    * @description InnerClass used as Wrrapper to return the relationship between Subsection and Concept
    */
    public class wrapperSubseccionConceptos {
        /**
        * 
        */
        @AuraEnabled public CatalogoSubsecciones__c subseccion {get;set;}
        /**
        * 
        */
        @AuraEnabled public List<WrapperEvaluacionConcepto> listWrapperEvaluacionConcepto {get;Set;}
        /**
        * 
        */
        @AuraEnabled public Boolean bTieneConceptos {get;Set;}
    /**
    * 
    */
        public wrapperSubseccionConceptos(CatalogoSubsecciones__c subseccion, List<WrapperEvaluacionConcepto> listWrapperEvaluacionConcepto, Boolean bTieneConceptos) {
            this.subseccion = subseccion;
            this.listWrapperEvaluacionConcepto = listWrapperEvaluacionConcepto;
            this.bTieneConceptos = bTieneConceptos;
        }
    }

    /*******************************************************************************************************
    * @description InnerClass used as Wrrapper to return information with concept and the record of EvaluacionConcepto__c
    */
    public class WrapperEvaluacionConcepto {
        /**
        * 
        */
        @AuraEnabled public CatalogoConceptos__c conceptos {get;Set;}
        /**
        * 
        */
        @AuraEnabled public EvaluacionConcepto__c evaluacionConcepto {get;Set;}
        /**
        * Method and constructor
        */
        public WrapperEvaluacionConcepto(CatalogoConceptos__c conceptos, EvaluacionConcepto__c evaluacionConcepto) {
            this.conceptos = conceptos;
            this.evaluacionConcepto = evaluacionConcepto;
        }
    }

    /*******************************************************************************************************
    * @description InnerClass used as Wrrapper to store information about a concept
    */
    public class WrapperEvaluacionConceptoInfo {
        /** 
        */
        @AuraEnabled public Id idEvaluacionConcepto {get;Set;}
        /** 
        */
        @AuraEnabled public String concepto {get;Set;}
        /** 
        */
        @AuraEnabled public Integer ponderacion {get;Set;}
        /** 
        */
        @AuraEnabled public String calificacion {get;Set;}
        /** 
        */
        @AuraEnabled public String seccionEvaConcepto {get;Set;}
        /** 
        */
        @AuraEnabled public String subseccionEvaConcepto {get;Set;}
        /** 
        */
        @AuraEnabled public String conceptoEvaConcepto {get;Set;}
        /** 
        */
        @AuraEnabled public String ejemploEvaConcepto {get;Set;}
        /** 
        */
        @AuraEnabled public Decimal porcentajeSeccion {get;Set;}
        /** 
        */
        @AuraEnabled public Boolean guardadoDeConceptos {get;Set;}
        /** 
        */
        @AuraEnabled public Boolean errorFatal {get;Set;}
    }

    /*******************************************************************************************************
    * @description InnerClass used as Wrrapper to store MX_WB_EvaluacionSeccion__c values, this helps to save the records on the object
    */
    public class WrapperEvaluacionPuntoEntrenamiento {
        /** 
        */
        @AuraEnabled public String idConcepto {get;Set;}
        /** 
        */
        @AuraEnabled public String label {get;Set;}
    }
    /*******************************************************************************************************
    * @description InnerClass used as Wrrapper to store MX_WB_EvaluacionSeccion__c values, this helps to save the records on the object
    */
    public class WrapperEvaluacionSeccion {
        /** 
        */
        @AuraEnabled public Id idEvaluacionSeccion {get;Set;}
        /** 
        */
        @AuraEnabled public String catalogoSeccion {get;Set;}
        /** 
        */
        @AuraEnabled public String seguirHaciendo {get;Set;}
        /** 
        */
        @AuraEnabled public String dejarDeHacer {get;Set;}
        /** 
        */
        @AuraEnabled public String empezarAHacer {get;Set;}
        /** 
        */
        public WrapperEvaluacionSeccion() {
            seguirHaciendo = '';
            dejarDeHacer = '';
            empezarAHacer = '';
        }
    }

    /*******************************************************************************************************
    * @description InnerClass used as Wrrapper to return a message and status to the JS controller with the operation result
    */
    public class WrapperMessage {
        /** 
        */
        @AuraEnabled public String status {get;Set;}
        /** 
        */
        @AuraEnabled public String message {get;Set;}
    }
}