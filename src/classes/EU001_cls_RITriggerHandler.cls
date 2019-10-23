/**
*Desarrollado por:       Indra
*Autor:                  Abraham Tinajero
*Proyecto:               MAX - Experiencia Unica PI8
*Descripción:            Clase Handler para el trigger sobre Reunión Individual
*
*Cambios (Versiones)
*-------------------------------------------------------------------------------------------------
*No.         Fecha          	 	Autor                           Descripción
*------   ----------------  	---------------------------    -----------------------------------
*1.0      05-03-2018            	Abraham Tinajero	       		Creación
**/

public class EU001_cls_RITriggerHandler extends TriggerHandler {

    /*
    @beforeInsert event override en la Clase TriggerHandler
    Logica Encargada de los Eventos BeforeInsert */
    protected override void beforeInsert() {
    	ContadorExpUni_Class.validaRIexistente(Trigger.new);
    }
    /*
    @beforeUpdate event override en la Clase TriggerHandler
    Logica Encargada de los Eventos BeforeUpdate*/
    //protected override void beforeUpdate(){

    //}

    /*
    @beforeDelete event override en la Clase TriggerHandler
    Logica Encargada de los Eventos BeforeDelete*/
    //protected override void beforeDelete(){

    //}

    /*
    @afterInsert event override en la Clase TriggerHandler
    Logica Encargada de los Eventos AfterInsert*/
    protected override void afterInsert() {
    	ContadorExpUni_Class.nuevoRI(Trigger.new);
    }

    /*
    @afterUpdate event override en la Clase TriggerHandler
    Logica Encargada de los Eventos afterUpdate*/
    //protected override void afterUpdate(){

    //}

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