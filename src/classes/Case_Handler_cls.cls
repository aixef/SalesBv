/*---------------------------------------------------------------------------------------
*Desarrollado por:  Indra
*Autor:             Sergio Andres Ortiz
*Proyecto:          Salud ORG
*Descripción:       Clase extends TriggerHandler, para manejar todos los eventos del
                    Trigger en el objeto Casos (Case)
*_______________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        11/ABR/2018     Sergio Andres Ortiz                 Creación de la clase.
*2.0        28/JUN/2018     Francisco Javier                    Se añade el método AsignaPropietario();
*3.0        12-08-2018      Francisco J Licona                  Se elimina llamado a método de error en aprobaciones
*4.0        23-01-2019      Jhovanny De La Cruz					Se añaden metodos generados en  Case_cls para PyME (validacionEjecutivoPyME
                                                                y cambioPropietarioPyME)
*5.0        06-02-2019      Jhovanny De La Cruz					Se cambia el orden de ejecución de métodos before insert agregando primero a
                                                                validacionEjecutivoPyME por validación previa a asignación de tipo de registro
*6.0		16-04-2019		Iván Cabrer Trevilla				Se crea método assignDesignate para asignar al propietario del caso como usuario designado en casos BIE.
*7.0        17-05-2019      Daniel García                       Se elimina la llamada al método validacionEjecutivoPyME.
*8.0		10/07/2019		Cindy Hernández						Se comentan los métodos beforeInsert, afterUpdate y afterInsert ya que no se utilizan para PyME ni BPyP.
-----------------------------------------------------------------------------------------*/
public without sharing class Case_Handler_cls extends TriggerHandler {
    /** Lista lsNewCase*/
    List<Case> lstNewCase   = (list<Case>)(Trigger.new);
    /** Lista lsOldCase*/
    List<Case> lstOldCase   = (list<Case>)(Trigger.old);
    /** Mapa mapNewCase*/
    Map<Id,Case> mapNewCase = (Map<Id,Case>)(Trigger.newMap);
    /** Mapa mapOldCase*/
    Map<Id,Case> mapOldCase = (Map<Id,Case>)(Trigger.oldMap);

    /*
    @beforeInsert event override en la Clase TriggerHandler
    Logica Encargada de los Eventos BeforeInsert */
    /*protected override void beforeInsert() {
        //new Case_cls().ValidaAlertaCRM(lstNewCase);
        //new Case_cls().ValidaCambioPropietario(lstNewCase);
		//new Case_cls().assignDesignate(lstNewCase);
    }*/
    /*
    @beforeUpdate event override en la Clase TriggerHandler
    Logica Encargada de los Eventos BeforeUpdate*/
    protected override void beforeUpdate() {
        //new Case_cls().ValidaConversionCliente(lstNewCase);
        new Case_cls().cambioPropietarioPyME(lstNewCase,mapOldCase);
    }

    /*
    @beforeDelete event override en la Clase TriggerHandler
    Logica Encargada de los Eventos BeforeDelete*/
    //protected override void beforeDelete(){

    //}

    /*
    @afterInsert event override en la Clase TriggerHandler
    Logica Encargada de los Eventos AfterInsert*/
    /*protected override void afterInsert(){
        //new Case_cls().getCaseName(lstNewCase);
    }*/

    /*
    @afterUpdate event override en la Clase TriggerHandler
    Logica Encargada de los Eventos afterUpdate*/
    /*protected override void afterUpdate(){

        //new Case_cls().AsignaPropietario(lstNewCase);
        //new Case_cls().ConvierteCliente(lstNewCase, mapNewCase);
    }*/

    /*
    @afterDelete event override en la Clase TriggerHandler
    Logica Encargada de los Eventos afterDelete*/
    //protected override void afterDelete(){

    //}

    /*
    @afterUndelete event override en la Clase TriggerHandler
    Logica Encargada de los Eventos afterUndelete*/
    //protected override void afterUndelete(){

    //}

}