/**
 * @File Name          : MX_SB_VTS_SendTrackingTelemarketing_sch.cls
 * @Description        : 
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              : 
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 7/10/2019 20:31:28
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/9/2019   Eduardo Hernández Cuamatzi     Initial Version
**/
public with sharing class MX_SB_VTS_SendTrackingTelemarketing_sch implements Schedulable {
    /** variable sQuery */
	public String sQuery {get;set;}

    /**
     * execute scheduld execute 
     * @param  schContext contexto scheduld
     */
    public void execute(SchedulableContext schContext) { 
        final MX_SB_VTS_SendTrackingTelemarketing_cls oppACls = new MX_SB_VTS_SendTrackingTelemarketing_cls(sQuery, Integer.valueOf(System.Label.CotizacionCreada));
        Database.executeBatch(oppACls, 1);
    }
}