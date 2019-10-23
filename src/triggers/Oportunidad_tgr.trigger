/**
*Desarrollado por Softtek
*
*Autor :        Cristian Espinosa
*Proyecto :     MAX BBVA Bancomer
*Descripción :  Trigger general para el objeto oportunidad. Las clases que contienen la
*               lógica deben ser llamadas en el Handler de este trigger segun el tiempo
*               de ejecución requerido.
*______________________________________________________________________________________
*Version    Fecha           Autor                   Descripción
*1.0        11/Ago/2017     Cristian Espinosa       Creación.
*1.1        21/11/2017		Arsenio Perez			Adaptacion Kevin O
*
**/
trigger Oportunidad_tgr on Opportunity (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    new OportunidadTriggerHandler().run();
}