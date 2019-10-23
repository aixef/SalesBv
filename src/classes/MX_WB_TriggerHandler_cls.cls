/**-------------------------------------------------------------------------
 * Nombre: MX_WB_TriggerHandler_cls
 * Autor Ing. Karen Belem Sanchez
 * Proyecto: MW WB TeleMarketing - BBVA Bancomer
 * Descripción : Clase TriggerHandler
 * --------------------------------------------------------------------------
 * Versión 		Fecha			Autor					Descripción
 * -------------------------------------------------------------------
 * 1.0			28/11/2018		Karen Belem Sanchez 	Creación
 * 1.1			13/02/2019		Eduardo Hernández 	 	Se agrega para desactivar Lead en AfterUpdate
 * 1.1			15/02/2019		Eduardo Hernández 	 	Correción para afterUpdate, se elimna la lista de triggers Old
 * 1.2          07/11/2019      Hugo Carrillo           Se agregan los métodos que correspondían al trigger MX_Campaign_tgr
 *                                                      en la org de empresas.
 * --------------------------------------------------------------------------
 */
public class MX_WB_TriggerHandler_cls  extends TriggerHandler {
    /**
    */
    List<Campaign> tgrNewCampaign = (list<Campaign>)(Trigger.new);
    /** */
    List<Campaign> lstNewCamp   = (list<Campaign>)(Trigger.new);
    /** */
    List<Campaign> lstOldCamp   = (list<Campaign>)(Trigger.old);
    /** */
    Map<Id,Campaign> mapNewCamp = (Map<Id,Campaign>)(Trigger.newMap);
    /** */
    Map<Id,Campaign> mapOldCamp = (Map<Id,Campaign>)(Trigger.oldMap);
    /*
    @beforeInsert event override en la Clase TriggerHandler
    Logica Encargada de los Eventos BeforeInsert */
    protected override void beforeInsert() {
        MX_WB_CampaniasNoDuplicadas.CampaniasNoDuplicadasCreaAct(tgrNewCampaign);
    }

    /*
    @afterInsert event override en la Clase TriggerHandler
    Logica Encargada de los Eventos AfterInsert*/
    protected override void afterInsert() {
        MX_PYME_CampTrigHand_Cls.updAccCamponPrd(mapNewCamp,null);
    }

    /*
	@afterUpdate event override en la Clase TriggerHandler
	Logica Encargada de los Eventos afterUpdate*/
	protected override void afterUpdate() {
        MX_PYME_CampTrigHand_Cls.updAccCamponPrd(mapNewCamp,mapOldCamp);
        MX_WB_CampaniasNoDuplicadas.CampaniasNoDuplicadasCreaAct(tgrNewCampaign);
    }

}