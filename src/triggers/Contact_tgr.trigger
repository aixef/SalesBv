/********************************************************************************
*	@Desarrollado por:		Indra												*
*	@Autor:					Arsenio Perez Lopez								*
*	@Proyecto:				Bancomer											*
*	@Descripción:			Trigger de usuarios									*
*																				*
*	Cambios (Versiones)															*
*	--------------------------------------------------------------------------	*
*	No.		Fecha				Autor					Descripción				*
*	------  ----------  ----------------------		---------------------------	*
*	1.0		18/10/2017	Arsenio perez lopez         	Creación Trigger		*
*********************************************************************************/
trigger Contact_tgr on Contact (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    new ContactTriggerHandler().run();
}