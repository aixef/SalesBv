/**
 * @File Name          : Lead_tgr.trigger
 * @Description        :
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              :
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 9/8/2019 10:08:04
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    13/5/2019 12:18:38   Eduardo Hernández Cuamatzi     Initial Version
 * 1.0    21/5/2019 14:46:16   Eduardo Hernández Cuamatzi     Correción Code Smells
**/
trigger Lead_tgr on Lead (before insert,before update, before delete, after insert, after update, after delete) {
    new MX_SB_VTS_LeadTriggerHandler().run();
}
