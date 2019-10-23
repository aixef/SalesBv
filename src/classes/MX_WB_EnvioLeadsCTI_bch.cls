/*
* Nombre: MX_WB_EnvioLeadsCTI_bch
* @author Karen Sanchez (KB)
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Batch que se ejecuta cuando se activa un proceso del trigger "" para hacer el envio de leads cada 30 min.

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           10/02/2019      Karen Sanchez            Creación
* @version 2.0           14/03/2019      Karen Sanchez            Modificación: Se modifica el campo prospecto.MX_WB_EnvioCTI__c
                                                                  para que se almacene la fecha del envío a CTI
* @version 3.0           16/03/2019      Karen Sanchez            Modificación: Se modifica el campo Motivos_CONTACTO__c por el de MX_WB_EstatusCTI__c 
                                                                  ya que este campo almacena el status de los teléfonos
*/
global with sharing class MX_WB_EnvioLeadsCTI_bch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
/**
*
*@ query
*/
    private String query;
    /**Tipo objeto a enviar por batch */
    final static String OBJETO = 'Lead';
    /** Tipo de envio para credenciales */
    final static Integer TIPO =3;
/**
*
*
*/
    public List<MX_WB_MotivosNoContacto__c> listaMotivosNoContacto {
        get { return [Select MX_WB_MotivoNoContacto__c FROM MX_WB_MotivosNoContacto__c];}
    }
/**
*
*@
*/
    global MX_WB_EnvioLeadsCTI_bch(string query) {
        this.query = query;
    }

    /*Funció: función que recibe la consulta de leads que manda el schedulable MX_WB_EnvioLeadsCTI_shc
    *28-01-2019
    *Karen Belem Sanchez Ruiz*/
    global Database.QueryLocator start(Database.BatchableContext batCbl) {
        return Database.getQueryLocator(this.query);
    }


    /*Función: función que se encarga de hacer el envio de leads a CTI a través  de un proceso a futuro y de
    *        actualizar los leads
    *28-01-2019
    *Karen Belem Sanchez Ruiz*/
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
                
                sProcesaSol = MX_WB_CTI_cls.procesaSol(Id, FolioCot,'ASD', OwnerId, Nombre, Telefono1,OBJETO,TIPO, Telefono2, Telefono3);
                prospecto.EnviarCTI__c = true;
                prospecto.MX_WB_TM_Congelado__c = true;
                prospecto.xmlEnvio__c = sProcesaSol[1];
                prospecto.xmlRespuesta__c = sProcesaSol[0];
                prospecto.MX_WB_EnvioCTI__c = Date.today();
            }
        }
        update scope;
    }

    /*Función: función que se encarga de descartar los teléfonos que ya no deben mandarse a CTI
    *28-02-2019
    *Karen Belem Sanchez Ruiz*/
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
            if(lead.MX_WB_ph_Telefono1__c == llamada.Telefono__c && listaMotivos.contains(llamada.MX_WB_EstatusCTI__c)) {
                falloTel1 = true;
                lead.MX_WB_ph_Telefono1__c = '';
            }
            if(lead.MX_WB_ph_Telefono2__c == llamada.Telefono__c && listaMotivos.contains(llamada.MX_WB_EstatusCTI__c)) {
                falloTel2 = true;
                lead.MX_WB_ph_Telefono2__c = '';
            }
            if(lead.MX_WB_ph_Telefono3__c == llamada.Telefono__c && listaMotivos.contains(llamada.MX_WB_EstatusCTI__c)) {
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


    /*Función: función que se encarga de obtener el prospecto y la bandera de envio a CTI
    *28-02-2019
    *Karen Belem Sanchez Ruiz*/
    public class ReturnLead {
        /**
        *
        *@
        */
        public Lead prospecto {get;set;}
        /**
        *
        *
        */
        public Boolean enviarCTI {get;set;}
    }
/**
*
*
*/
    global void finish(Database.BatchableContext batCbl) {}
}