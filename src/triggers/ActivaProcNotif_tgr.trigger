/**
* Avanxo Colombia
* @author           NN
* Project:          WIBE
* Description:      Clase que implementa metodos para realizar la conexion desde SFDC hacia CTI.
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  2.0     2016-10-05      Manuel Medina (MM)      Ajuste relacionado con JIRA SAN1-13:
*                                                           - Incluir excepción para no enviar las oportunidades comerciales y cotizaciones 
*                                                           que estén tipificadas como "No interesado" y "Close Lost (Aplica solo para cotizaciones)".
 *Beeva México
* @author          Karen Belem Sanchez Ruiz  karenbelem.sanchez.ruiz@bbva.com
* -------------------------------------
*           No.    Fecha          Autor                            Descripción      
*           ----   ----------     ---------------------------      -------------  
* @version   2.1    10/04/2018    Karen Belem SAnchez Ruiz   (KB)  Se actualizó para hacer el envio a CTI de 30 min en cualquier estatus 
* @version   1.2    15/10/2018    José David Mendoza Fong          Se Agregan los tiempos de ejecucion faltantes
                                                                   y se agrega la ejecucion de WB_ProcNotifTriggerHandler
                                                                   Migracion a SFDC Trigger Framework
********************************************************************************************************************************************/

trigger ActivaProcNotif_tgr on ProcNotiOppNoAten__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
  new WB_ProcNotifTriggerHandler().run();    
}