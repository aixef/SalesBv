/*---------------------------------------------------------------------------------------
*Desarrollado por:	Indra
*Autor:         	Sergio Andres Ortiz
*Proyecto:      	Salud ORG
*Descripción:   	Trigger para el objeto Casos
*_______________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        11/ABR/2018     Sergio Andres Ortiz                 Creación de la clase.
-----------------------------------------------------------------------------------------*/
trigger Casos_tgr on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	//Llamado a la clase con el manejo de eventos para los registros de casos
	new Case_Handler_cls().run();
}