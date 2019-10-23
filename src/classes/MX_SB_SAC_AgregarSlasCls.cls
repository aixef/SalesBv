/**
 Nombre: MX_SB_SAC_AgregarSlasCls
 @author   Karen Sanchez (KB)
 Proyecto: MX_SB_SAC - BBVA Bancomer   
 Descripción : Clase que busca el sla con base al motivo del caso para guardarlo en los registros de asignación ejecutado
				a traves de un process builder

            No.    Fecha            Autor             Description
                                                     
 @version  1.0   2019-04-15      Karen Belem (KB)      Creación
*/
public with sharing class MX_SB_SAC_AgregarSlasCls {//NOSONAR
    
     /**
    Función: Ejecuta desde un process builder para asignar los SLAS
    2019-04-15
    Karen Belem Sanchez Ruiz
    */
    @InvocableMethod(label='mAgregaSLA' description='Agrega el sla a las asignaciones correspondientes')
    public static void mAgregaSLA (List<string> lstCasesIds) {
        mAsignaSLA(lstCasesIds);
    }
    
    /**
    Función: Asocia los SLAS con el registro de asignación
    2019-04-16
    Karen Belem Sanchez Ruiz
    */	
    public static void mAsignaSLA (List<String> lstCasesIds) {
        List<Case> lstCaso  = new List<Case>();      
        final String idForUpdate = lstCasesIds[0];
        lstCaso = [SELECT Id, EntitlementId, Entitlement.SlaProcessId, Reason FROM Case WHERE Id =: idForUpdate];        
        final SlaProcess [] argSlaAsignado = [SELECT Id FROM SlaProcess WHERE Name =: lstCaso[0].Reason];  
        if (argSlaAsignado.size ()> 0) {
            final Entitlement objEntitlement = new Entitlement();
            objEntitlement.Id = lstCaso[0].EntitlementId; 
            objEntitlement.SlaProcessId =argSlaAsignado[0].Id;
            Database.update(objEntitlement,false);
        }
    }

}