/**-------------------------------------------------------------------------
 * Nombre: MX_WB_Campaign_tgr
 * Autor Ing. Karen Belem Sanchez
 * Proyecto: MW WB TeleMarketing - BBVA Bancomer
 * Descripción : Clase MX_WB_Campaign_tgr Trigger para Campaigns
 * --------------------------------------------------------------------------
 * Versión 		Fecha			Autor					Descripción
 * -------------------------------------------------------------------
 * 1.0			06/01/2019		Karen Belem Sanchez 	Creación
 * --------------------------------------------------------------------------
 */
trigger MX_WB_Campaign_tgr on campaign (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	new MX_WB_TriggerHandler_cls().run();
}