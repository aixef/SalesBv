/**
*
* Creacion de clase MX_WB_EnvioLeads4HrsCTI_bch
*/
global with sharing class MX_WB_EnvioLeads4HrsCTI_bch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
/**
*
* @
*/
	global String query { get; set; }
    /**
    *
    * @
    */
    public List<MX_WB_MotivosNoContacto__c> listaMotivosNoContacto {
        get { return [Select MX_WB_MotivoNoContacto__c FROM MX_WB_MotivosNoContacto__c];}
    }
     /**
    * 
    * @
    */
	global MX_WB_EnvioLeads4HrsCTI_bch(string query) {
		this.query = query;
	}
     /**
    * 
    * @
    */
	global Database.QueryLocator start(Database.BatchableContext batCbl) {
		return Database.getQueryLocator(this.query);
	}
     /**
    * 
    * @
    */
   	global void execute(Database.BatchableContext batCbl, List<Lead> scope) {
   		for (Lead prospecto : scope) {
            final ReturnLead checkedLead = checkTelephoneCalls(prospecto, prospecto.Tasks);
            final Lead objDetalleCliente = checkedLead.prospecto;
            if(checkedLead.enviarCTI) {
                List<String> sProcesaSol = new List<String>();
                final String Id = objDetalleCliente.Id;
                final String FolioCot = objDetalleCliente.Folio_Cotizacion__c;
                final String OwnerId = objDetalleCliente.OwnerId;
                final String Nombre = objDetalleCliente.FirstName;
                final String Telefono1 = objDetalleCliente.MX_WB_ph_Telefono1__c;
                final String Telefono2 = objDetalleCliente.MX_WB_ph_Telefono2__c;
                final String Telefono3 = objDetalleCliente.MX_WB_ph_Telefono3__c;
                final String Objeto = 'Lead';
                final Integer Tipo = 3;
                sProcesaSol = MX_WB_CTI_cls.procesaSol(Id, FolioCot,'ASD', OwnerId, Nombre, Telefono1,Objeto,Tipo, Telefono2, Telefono3);

                prospecto.EnviarCTI__c = true;
                prospecto.MX_WB_TM_Congelado__c = true;
                prospecto.xmlEnvio__c = sProcesaSol[1];
                prospecto.xmlRespuesta__c = sProcesaSol[0];
            }
   		}

        update scope;
	}
 /**
* 
*@
*/
    public ReturnLead checkTelephoneCalls(Lead lead, List<Task> llamadas) {
        final ReturnLead toReturn = new ReturnLead();
        final List<String> listaMotivos = new List<String>();
        for(MX_WB_MotivosNoContacto__c motivo: listaMotivosNoContacto) {
            listaMotivos.add(motivo.MX_WB_MotivoNoContacto__c);
        }
        Boolean falloTel1 = false;
        Boolean falloTel2 = false;
        Boolean falloTel3 = false;
        for(Task llamada : llamadas) {
            if(lead.MX_WB_ph_Telefono1__c == llamada.Telefono__c && listaMotivos.contains(llamada.Motivos_CONTACTO__c)) {
                falloTel1 = true;
                lead.MX_WB_ph_Telefono1__c = '';
            }
            if(lead.MX_WB_ph_Telefono2__c == llamada.Telefono__c && listaMotivos.contains(llamada.Motivos_CONTACTO__c)) {
                falloTel2 = true;
                lead.MX_WB_ph_Telefono2__c = '';
            }
            if(lead.MX_WB_ph_Telefono3__c == llamada.Telefono__c && listaMotivos.contains(llamada.Motivos_CONTACTO__c)) {
                falloTel3 = true;
                lead.MX_WB_ph_Telefono3__c = '';
            }
        }
        toReturn.prospecto = lead;
        toReturn.enviarCTI = true;
        if(falloTel1 && falloTel2 && falloTel3) {
            toReturn.enviarCTI = false;
        }
        return toReturn;
    }
/**
* 
* @
*/
    public class ReturnLead {
        /**
        *
        * @
        */
        public Lead prospecto {get;set;}
        /**
        *
        * @
        */
        public Boolean enviarCTI {get;set;}
    }
/**
*
* @
*/
	global void finish(Database.BatchableContext batCbl) {
		System.debug('EN MX_WB_EnvioLeadsCTI_bch.finish Hora: ' + DateTime.now());
	}
}