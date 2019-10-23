/**
*
*
* @Descripción: Crea un log
*/
public with sharing class WB_CrearLog_cls {
    private WB_CrearLog_cls() {

    }
    /** Method fnCrearLog*/
    public static void fnCrearLog(String sMsn, String sServicio , Boolean blRta) {
        if( Label.WB_BorrarLog == 'OK' ) {
            final WB_Log__c oLog = new WB_Log__c();
            oLog.WB_Mensaje__c = sMsn;
            oLog.WB_Rta__c = blRta;
            oLog.WB_Servicio_Web__c = sServicio;
            insert oLog;
        }
    }
}