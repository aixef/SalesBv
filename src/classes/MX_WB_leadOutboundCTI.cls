/**
* author: Javier Ortiz Flores
* company: Indra
* Description:    controlador After Update para proceso Outbound,
* 				donde se crea una tarea por llamada encontrada en el servicio CTI
*
* Information about changes (versions)
* -------------------------------------
* Number    Dates           Author                       Description
* ------    --------        --------------------------   -----------
* 1.0       01-Ene-2019     Javier Ortiz Flores          Creación de la Clase.
* 2.0		  23-Abr-2019	  Javier Ortiz Flores		   Se modifica método de creación de tareas de insert a upsert.
* 2.0		  07-May-2019	  Javier Ortiz Flores		   Ahora se dejan congelados los leads si tienen mas de 5 llamadas.
*/
public without sharing class MX_WB_leadOutboundCTI {
    /**
    * oppActTask field for SOQL
    **/
    public static final List<opportunity> oppAccTask = [SELECT accountId FROM Opportunity WHERE recordType.developerName = 'MX_WB_RT_Telemarketing'];

    /**
    * idCallTask field for recordTypeId
    **/
    public static final Id idCallTask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('MX_WB_llamadaCandidato').getRecordTypeId();

    /**
    * actualizaCTILead void method to update Lead record on CTI
    **/
    public static void actualizaCTILead(List<MX_WB_regresosCall_cls.returnCall> listaLLamada, string oppId) {
        final List<Task> listaTareas = listaTareas(oppId, true);
        final List<task> taskUpd = new List<task>();
        final Integer sizeLista = 5;
        if(listaLLamada.size() < sizeLista) {
            actualizaLead(listaLLamada);
            for(MX_WB_regresosCall_cls.returnCall iterallamadas : listaLLamada) {
                if(listaTareas.isEmpty()) {
                    final task call = creaTask(iterallamadas, oppId);
                    taskUpd.add(call);
                } else {
                    for(task iteraTask : listaTareas) {
                        if(iteraTask.MX_WB_fechaUltimoContacto__c != iterallamadas.Fecha_Llamada &&
                           iteraTask.MX_WB_EstatusCTI__c != iterallamadas.Disposicion &&
                           iteraTask.MX_WB_telefonoUltimoContactoCTI__c != iterallamadas.Tel_Marcado) {
                               final Task call = creaTask(iterallamadas, oppId);
                               taskUpd.add(call);
                           }
                    }
                }
            }
            if(!taskUpd.isEmpty()) {
                upsert taskUpd;
            }
        }
    }

    /**
    * actualizaLead void method to update Lead record
    **/
    public static void actualizaLead(List<MX_WB_regresosCall_cls.returnCall> listaRecords) {
        final set<id> idLeads = new set<id>();
        for(MX_WB_regresosCall_cls.returnCall iteraLlamadas : listaRecords) {
        	idLeads.add(iteraLlamadas.leadId);
        }
        final List<Lead> listUpdLead = new List<Lead>();
        for(id iteraId : idLeads) {
            final Lead updLead = new Lead();
            updLead.Id = iteraId;
            updLead.Mx_WB_contadorRemarcado__c = String.valueof(listaRecords.size());
            updLead.MX_WB_TM_Congelado__c = false;
            listUpdLead.add(updLead);
        }
        update listUpdLead;
    }

    /*
    * actualizaTareasLead void method to update Lead's Tasks
    */
    public static void actualizaTareasLead(List<MX_WB_regresosCall_cls.returnRecording> listaRecords) {
        final Lead updLead = new Lead();
        updLead.Id = listaRecords[0].leadId;
        updLead.Mx_WB_contadorRemarcado__c = String.valueof(listaRecords.size());
        updLead.MX_WB_TM_Congelado__c = false;
        update updLead;
    }

    /**
    * listaTareas method to return Lead's Tasks
    **/
    public static List<Task> listaTareas(string oppId, boolean whoWhat) {
        string consulta;
        if(whoWhat) {
            consulta = 'SELECT MX_WB_fechaUltimoContacto__c, WhoId, MX_WB_EstatusCTI__c, MX_WB_telefonoUltimoContactoCTI__c '
            +'FROM task WHERE recordTypeId =:idCallTask AND MX_WB_fechaUltimoContacto__c != null '
            +'AND MX_WB_EstatusCTI__c != null AND MX_WB_telefonoUltimoContactoCTI__c != null '
            +'AND WhoId =: oppId';
        } else {
            consulta = 'SELECT MX_WB_fechaUltimoContacto__c, OwnerId, WhoId, MX_WB_EstatusCTI__c, MX_WB_telefonoUltimoContactoCTI__c, MX_WB_fechaGrabacionLlamada__c, MX_WB_idGrabacion__c, MX_WB_duracionLlamada__c '
            +'FROM task WHERE recordTypeId =:idCallTask AND MX_WB_fechaUltimoContacto__c != null '
            +'AND MX_WB_EstatusCTI__c != null AND MX_WB_telefonoUltimoContactoCTI__c != null '
            +'AND WhatId =: oppId';
        }
        final List<Task> listaTareas = Database.Query(String.escapeSingleQuotes(consulta));
        return listaTareas;
    }

    /**
     oppTaskCreate void method to create Lead Task
    **/
    public static void oppTaskCreate(List<MX_WB_regresosCall_cls.returnRecording> listaRecords, string oppId) {
        final List<Task> listaTareas = listaTareas(oppId, false);
        List<task> taskUpd = new List<task>();
        actualizaTareasLead(listaRecords);
        for(opportunity iteraOpp : oppAccTask) {
            if(iteraOpp.Id.equals(oppId)) {
                for(MX_WB_regresosCall_cls.returnRecording iterallamadas : listaRecords) {
                    taskUpd = addTareas(taskUpd, listaTareas, oppId, iterallamadas);
                }
            }
        }
        if(!taskUpd.isEmpty()) {
            insert taskUpd;
        }
    }

    /**
     addTareas method to add Lead's Tasks
    **/
    public static List<Task> addTareas(List<Task> taskUpd, List<Task> listaTareas, String oppId, MX_WB_regresosCall_cls.returnRecording iterallamadas) {
        if(listaTareas.isEmpty()) {
            final task call = createOppTask(iterallamadas, oppId);
            taskUpd.add(call);
        } else {
            for(task iteraTask : listaTareas) {
                if(iteraTask.MX_WB_fechaGrabacionLlamada__c != iterallamadas.Fecha_Grabacion &&
                   iteraTask.MX_WB_idGrabacion__c != iterallamadas.Grabacion &&
                   iteraTask.MX_WB_duracionLlamada__c != iterallamadas.Duracion) {
                       final Task call = createOppTask(iterallamadas, oppId);
                       taskUpd.add(call);
                   }
            }
        }
        return taskUpd;
    }

    /**
     createOppTask method to crear Opp's Tasks
    **/
    public static Task createOppTask(MX_WB_regresosCall_cls.returnRecording listaRecords, String oppId) {
        final Task call = new Task();
        call.WhatId = oppId;
        call.Description = 'Llamada CTI';
        call.Subject = 'Call CTI';
        call.RecordTypeId = idCallTask;
        if(listaRecords.Fecha_Grabacion!=null) {
            call.MX_WB_fechaGrabacionLlamada__c = listaRecords.Fecha_Grabacion;
        }
        if(String.isNotBlank(listaRecords.Grabacion)) {
            call.MX_WB_idGrabacion__c = listaRecords.Grabacion;
        }
        if(listaRecords.Duracion > 0) {
            call.MX_WB_duracionLlamada__c = listaRecords.Duracion;
        }
        if(String.isNotblank(listaRecords.idUser)) {
            call.MX_WB_RFCusuarioAtencion__c = listaRecords.idUser;
        }
        return call;
    }

    /**
     creaTask method to create Task
    **/
    public static task creaTask(MX_WB_regresosCall_cls.returnCall iterallamadas, String oppId) {
        final Task call = new Task();
        if(String.isNotBlank(oppId)) {
            for(opportunity iteraOpp : oppAccTask) {
                if(iteraOpp.id.equals(oppId)) {
                    call.WhatId = iteraOpp.accountId;
                }
            }
        } else {
            call.WhoId = iterallamadas.leadId;
        }
        call.Description = 'Llamada CTI';
        call.Subject = 'Call';
        call.RecordTypeId = idCallTask;
        if(iterallamadas.Fecha_Llamada!=null) {
            call.MX_WB_fechaUltimoContacto__c = iterallamadas.Fecha_Llamada;
        }
        if(String.isNotBlank(iterallamadas.Disposicion)) {
            call.MX_WB_EstatusCTI__c = iterallamadas.Disposicion;
        }
        if(String.isNotBlank(iterallamadas.Tel_Marcado)) {
            call.MX_WB_telefonoUltimoContactoCTI__c = iterallamadas.Tel_Marcado;
        }
        if(String.isNotblank(iterallamadas.idUser)) {
            call.MX_WB_RFCusuarioAtencion__c = iterallamadas.idUser;
        }
        return call;
    }
}