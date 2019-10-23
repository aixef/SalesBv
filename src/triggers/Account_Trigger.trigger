/*----------------------------------Desarrollado por INDRA---------------------------------
*Autor:         Ing. Pedro Alan Hernandez Sierra
*Proyecto:      Max BBVA PI7
*Descripción:   Trigger general para el objeto Account. Las clases que contienen la
*               lógica deben ser llamadas en el Handler de este trigger segun el tiempo
*               de ejecución requerido.
*_______________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        16/NOV/2017     Ing. Pedro Alan Hernandez Sierra    Creación.
*1.1        28/FEB/2018     Arsenio Perez L                     Se Agregan los tiempos de ejecucion faltantes.
-----------------------------------------------------------------------------------------*/
trigger Account_Trigger on Account (after delete, after insert, after undelete, after update, before delete, before insert, before update){
    new Account_Handler().run();    
}