/**
*
* @author Arsenio Perez Lopez
* @description API to auto assign leads from Smart Center to call center agents
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    24/06/2019     Arsenio Perez      Create API for Smart Center
* @version  1.0    27/08/2019     Arsenio Perez      Code smell
*
*/
@RestResource(urlMapping='/leadNoContacto/*')
global without sharing class MX_SB_VTS_SMARTNOCONTACTO_cls {
    @TestVisible
    Private MX_SB_VTS_SMARTNOCONTACTO_cls() {

    }
    /**
* Method: leadActionCont
* @param LeadId: ID del lead que se va a trabajar
* @param Tipo: Tipo (motivoNoContacto/Grabacion)
* @param motivoNoContacto (String)
* @param idGrabacion  (String)
* @param certificada  (Verdadera/Falsa)
*/
    @HttpPost
    global static String leadActionCont() {
        String ret ='';
        final Map<String, Object> listener = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
        final String leadId = String.valueOf(listener.get('LeadId'));
        final String Tipo = String.valueOf(listener.get('Tipo'));
        final String motivoNoContacto = String.valueOf(listener.get('MotivoNoContacto'));
        final String idGrabacion = String.valueOf(listener.get('IDGrabacion'));
        final String certificada = String.valueOf(listener.get('Certificada'));
        final String Tipotwo =leadId;
        final Boolean isLead = Tipotwo.startsWith('00Q');
        if('MotivoNocontacto'.equals(Tipo)) {
            ret = motivoNoContacto(leadId, motivoNoContacto, isLead);
        } else if('Grabacion'.equals(Tipo)) {
            ret = llamdaCertificacion(leadId, idGrabacion,certificada, isLead);
        } else {
            ret = System.Label.MX_WB_LG_ErrorBack;
        }
        return ret;
    }
    /**
* @Method:motivoNoContacto
* @Param: iIDLead: id del lead a contactar
* @param: motivoNoContacto de no contacto a relacionar con el lead
*/
    @TestVisible
    private static string motivoNoContacto(id iIDLead, String motivoNoContacto, Boolean isLead) {
        String retur = '';
        try {
            SObject IDowner = consiltaWonerRegistro(isLead,iIDLead);
            //Crea tarea
            Datetime tiepo = datetime.now();
            tiepo=tiepo.addHours(Integer.valueOf(MX_SB_VTS_MotorConsulta_cls.ConsltaMotor(iIDLead)));
            retur=InsertaTarea(String.valueOf(IDowner.get('OwnerId')), tiepo, motivoNoContacto, iIDLead, isLead,'');
            //REagenda llamda para dentro dl tiempo que dicteel motivo de no contacto.
            if(String.isNotEmpty(String.valueOf(IDowner.get('MX_SB_VTS_Numero_de_Llamadas__c')))) {
                IDowner.put('MX_SB_VTS_Numero_de_Llamadas__c',Integer.valueOf(IDowner.get('MX_SB_VTS_Numero_de_Llamadas__c'))+1);
            }
        } catch (DmlException e) {
            retur = System.Label.MX_WB_LG_ErrorBack;
            throw new DmlException(System.Label.MX_WB_LG_ErrorBack + e);
        }
        return retur;
    }
    /**
* @Method:llamdaCertificacion
* @Param: iIDLead: id del lead a contactar
* @param: idGrabacion de no contacto a relacionar con el lead
* @param: certificada de no contacto a relacionar con el lead
*/
    @TestVisible
    private static string llamdaCertificacion(Id iIDLead, String idGrabacion, String certificada, Boolean isLead) {
        String retur = '';
        try {
            if(String.isNotEmpty(certificada)) {
                final Task act=[Select id from Task where MX_WB_idGrabacion__c=:idGrabacion];
                act.MX_SB_VTS_certificada__c=certificada;
                update act;
                retur= act.id;
            } else {
                final SObject IDowner = consiltaWonerRegistro(isLead,iIDLead);
                Datetime tiepo = datetime.now();
                tiepo = tiepo.addDays(1);
                retur=InsertaTarea(String.valueOf(IDowner.get('OwnerId')), tiepo, 'Call', iIDLead, isLead,idGrabacion);
            }
        } catch (DmlException e) {
            retur = System.Label.MX_WB_LG_ErrorBack;
            throw new DmlException(System.Label.MX_WB_LG_ErrorBack + e);
        }
        return retur;
    }
    /**
* @Method:InsertaTarea
* @Param: owner: Id del dueño de la tarea
* @Param: datosHora: Horario de ls siguiente llamda
* @Param: comentarios: Comentarios del no contact
* @Param: idOp: Id del sObject que se envie LEAD / Oportunidad
* @Param: isLead: Valida si es un Lead o Una oportunidad
*/
    @TestVisible
    private static String InsertaTarea(String owner, datetime datosHora, String comentarios, String idOp, Boolean isLead,String idGrabacion) {
        try {
            final Task objTask = new Task();
            objTask.OwnerId = owner;
            objTask.Description = comentarios;
            objTask.Subject = 'Call';
            objTask.ReminderDateTime = datosHora;
            objTask.IsReminderSet = true;
            if(isLead) {
                objTask.WhoId = idOp;
            } else {
                objTask.WhatId = idOp;
            }
            if(String.isNotEmpty(idGrabacion)) {
                objTask.MX_WB_idGrabacion__c=idGrabacion;
            }
            final datetime tomorro = datosHora.addDays(1);
            objTask.ActivityDate = date.newinstance(tomorro.year(), tomorro.month(), tomorro.day());
            insert objTask;
            return objTask.Id;
        } catch(DMLException ex) {
            system.debug('ex: '+ex);
            throw new AuraHandledException(Label.MX_WB_lbl_ReagendamientoException + ex);
        }
    }
    /**
* @Method:consiltaWonerRegistro
* @Param: isLead: TIpo de Objeto
* @Param: iDs: Id del dueño de la tarea
*/
    @TestVisible
    private static SObject consiltaWonerRegistro(Boolean isLead, String iDs) {
        try {
            final String Obj =isLead ? 'LEAD':'OPPORTUNITY';
            final String tel =isLead ? 'MX_WB_ph_Telefono1__c,MX_WB_ph_Telefono2__c,MX_WB_ph_Telefono3__c':'TelefonoCliente__c';
            final String isds = iDs;//NOSONAR
            final String QUery = 'Select Id, OwnerId,MX_SB_VTS_Numero_de_Llamadas__c,'+
                tel+' from '+Obj +' where id =:isds';
            return Database.Query(String.escapeSingleQuotes(QUery));
        } catch(DmlException ex) {
            throw new AuraHandledException(Label.MX_WB_lbl_ReagendamientoException + ex);
        }
    }
}