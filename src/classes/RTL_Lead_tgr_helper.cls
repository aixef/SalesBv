/** 
*
*@create class 
*/
public class RTL_Lead_tgr_helper {
    
 /**method */   
public static void verificaProducto(List<Lead> lstLeads) {
        for(Lead objLead:lstLeads) {
          	System.debug('HoraContacto: ' + objLead.Hora_contacto__c);
	    	System.debug('EN WB_Lead_Asignacion_cls.verificaProducto objLead: ' + objLead);          	
			//Prioridad 0.
			//Si la hora es igual a la hora actual y el estatus es igual a null entonces se pinta la prioridad 0.
			if(objLead.Priority__c == null && objLead.LeadSource == 'Call me back' && objLead.Hora_contacto__c == null) {
					objLead.Priority__c = '0';
			}
        }
        
    }
}