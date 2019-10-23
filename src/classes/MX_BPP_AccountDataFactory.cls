/*--------------------------------------------------------------------------------------
*Autor:         Equipo Migración
*Proyecto:      Migración Salesforce
*Descripción:   Clase para crear los Datos de prueba para ser usados por las clases
                prueba del los triggers de cuenta.
*_______________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        28/JUN/2019     Alejandro Garza                     Creación.
---------------------------------------------------------------------------------------*/

@isTest
public with sharing class MX_BPP_AccountDataFactory {
    /**
    * @Method:      getBPYPStandardUser
    * @Description: Regresa un usuario estándar para BPYP
    **/
    public static User getBPYPStandardUser() {
        User usr = UtilitysDataTest_tst.crearUsuario('Test','BPyP Estandar',null);
        usr.Username ='Nombretest@gmail.com';
        usr.Email= 'Nombretest@gmail.com';
        usr.Alias= 'tst1';
        usr.VP_ls_Banca__c = 'Red BPyP';
        return usr;
    }

    /**
    * @Method:      getDirectorOfficeUser
    * @Description: Regresa un usuario director de oficina para BPYP
    **/
    public static User getDirectorOfficeUser() {
        User usr = UtilitysDataTest_tst.crearUsuario('Test','BPyP Director Oficina',null);
        usr.Username ='directoroficina@gmail.com';
        usr.Email= 'directoroficina@gmail.com';
        usr.Alias= 'directof';
        usr.VP_ls_Banca__c = 'Red BPyP';
        return usr;
    }

    /**
    * @Method:      crearVisitaComercial
    * @param:       String what,  String who
    * @Description: Metodo que retorna un registro tipo Task de tipo 'Visita Comercial'
    **/
    public static Task crearVisitaComercial(String what, String who) {
        Task tarea = UtilitysDataTest_tst.crearTarea(what, UserInfo.getUserId(), null);
       	tarea.Type = 'Visita comercial'+what;
        tarea.Subject = 'Tarea'+what;
        if(!String.isBlank(what)) {
            tarea.WhatId = what;
        }
        if(!String.isBlank(who)) {
            tarea.whoId = who;
        }
        tarea.IsRecurrence = false;
        tarea.Id_externo_Google__c = 'jha'+what;
        tarea.ActivityDate = Date.today().addDays(2);

        return tarea;
	}

    /**
    * @Method:      CrearEventoConTiempos
    * @param:       String what,  String who
    * @Description: Metodo que retorna un registro tipo Event con valores fijos en los campos de fecha
    **/
    public static Event CrearEventoConTiempos(String what, String who) {
        DateTime aux = Datetime.now();
        Event task = UtilitysDataTest_tst.crearEvento(aux.addDays(2), null, null);
        task.ActivityDate=Date.today().addDays(2);
        task.ActivityDateTime = aux.addDays(2);
        task.StartDateTime = aux.addDays(2);
        task.EndDateTime=aux.addDays(2).addMinutes(20);
        task.DurationInMinutes=20;
        task.IsRecurrence=false;
        task.Etag_Google__c='uihikhk';
        if(!String.isBlank(what)) {
            task.WhatId = what;
        }
        if(!String.isBlank(who)) {
            task.whoId = who;
        }

        return task;
    }

    /**
    * @Method:      crearConocimiento
    * @param:       String accountId
    * @Description: Método que retorna un objeto Conocimiento Profundo del cliente
    */
    public static BPyP0023_CPC__c crearConocimiento(String accountId, String recordTypeDevName) {
        BPyP0023_CPC__c cono = new BPyP0023_CPC__c();
        cono.BPyP0023_rb_Cuenta__c = accountId;
        if(String.isNotBlank(recordTypeDevName)) {
            cono.RecordTypeId = RecordTypeMemory_cls.getRecType('BPyP0023_CPC__c', recordTypeDevName);
        }
        return cono;
    }

    /**
    * @Method:      creaPlanDCuenta
    * @param:       Id idAcc, Id idContact
    * @Description: Metodo que retorna un registro tipo Ficha_de_conocimiento__c
    **/
    public static Ficha_de_conocimiento__c creaPlanDCuenta (Id idAcc, Id idContact) {
        Ficha_de_conocimiento__c pcObj = new Ficha_de_conocimiento__c();
        pcObj.Cliente__c = idAcc;
        //pcObj.PC001_lm_Sector__c = 'Agronegocios-Empacadora';
        //pcObj.PC001_rb_contactosDecisores__c = idContact;
        insert pcObj;

        return pcObj;
    }
}
