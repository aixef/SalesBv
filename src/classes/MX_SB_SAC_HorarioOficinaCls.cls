/**
 Nombre: MX_SB_SAC_HorarioOficinaCls
 @author   Karen Sanchez (KB)
 Proyecto: MX_SB_SAC - BBVA Bancomer   
 Descripción : Clase que busca el horario de oficina para guardarla en los registros de asignación ejecutado
                a traves de un process builder
 
            No.    Fecha            Autor             Description
                                                     
 @version  1.0   2019-04-15      Karen Belem (KB)      Creación
*/
public with sharing class MX_SB_SAC_HorarioOficinaCls { //NOSONAR
    
    /**
    Función: Ejecuta desde un process builder para asignar el horario de oficina y los SLAS
    2019-04-15
    Karen Belem Sanchez Ruiz
    */
    @InvocableMethod(label='mHorarioOficina' description='método que se ejecuta desde un process builder para asignar el horario de oficina y los SLAS')
    public static void mHorarioOficina (List<String> lstUpdEntIds) {
        mAsignaHorarioOficina(lstUpdEntIds);
    }
    /**
    Función: Asocia el horario de oficina con las asignaciones
    2019-04-16
    Karen Belem Sanchez Ruiz
    */
    
    public static void mAsignaHorarioOficina (List<String> lstUpdEntIds) {  
                    
        final List<BusinessHours> lstHorarioOficina = [SELECT Id FROM BusinessHours WHERE IsDefault=false AND Name =: label.MX_SB_SAC_HorarioOficina];
        if(!lstHorarioOficina.isEmpty()) {
            final Entitlement objAsignacion = new Entitlement();
            final List<Entitlement> lstsAsignacion = new List<Entitlement>();
            for(String sAsignacion : lstUpdEntIds) { 
                objAsignacion.Id = sAsignacion;
                objAsignacion.BusinessHoursId = lstHorarioOficina[0].Id;
                lstsAsignacion.add(objAsignacion);  
            }   
            Database.update(lstsAsignacion, false);    
        }
    }

}