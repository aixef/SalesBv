/*
* BBVA - Mexico
* @Author: Diego Olvera
* MX_SB_VTS_APX_ReagendaLead
* @Version 1.0
* @LastModifiedBy: Eduardo Hernández Cuamatzi
* @ChangeLog
* 1.0 Created class - Diego Olvera
* 1.1 Add validation rules, assignments, fixed issues -  Jaime Terrats
* 1.2 Add logic for opportunity object - Diego Olvera
* 1.3 Add new method to handle phone number assignations
*/

public without sharing class MX_SB_VTS_APX_ReagendaLead {
    /**
    * constructor
    */
    private MX_SB_VTS_APX_ReagendaLead() {} //NOSONAR
    /*
    * @Method: saveTask
    * @Description: creates task depending on the business flow
    * @Params: myTask: Task Object, segmented: Boolean, leadId
    */
    @AuraEnabled
    public static void saveTask(Task myTask, Boolean segmented, String leadId) {
        try {
            final Id managerId = [Select ManagerId from User where Id =: UserInfo.getUserId()].ManagerId;
            if(segmented == false) {
                myTask.OwnerId = managerId;
            }
            if(leadId.startsWith('00Q')) {
                getLeadTask(leadId, myTask);
                myTask.WhoId = leadId;
                if(segmented == true) {
                    final Id queueId = [Select Id from Group where Type = 'Queue' and DeveloperName = 'MX_SB_VTS_Reagenda'].Id;
                    final List<Lead> sendLeadToCTI = checkRecordSource(leadId, true);
                    for(Lead updLead : sendLeadToCTI) {
                        updLead.OwnerId = queueId;
                    }
                    envioAutomatico(sendLeadToCTI, myTask);
                    Database.update(sendLeadToCTI);
                }
            } else if(leadId.startsWith('006')) {
                getOpportunityTask(leadId, myTask);
                myTask.WhatId = leadId;
                final List<Opportunity> sendOppToCTI = checkRecordSource(leadId, false);
                for(Opportunity updOpp : sendOppToCTI) {
                    updOpp.OwnerId = managerId;
                }
                if(segmented == true) {
                    envioAutomatico(sendOppToCTI, myTask);
                }
            	Database.update(sendOppToCTI);
            }
            upsert myTask;
        } catch(DmlException dmlEx) {
            throw new AuraHandledException(System.Label.MX_WB_LG_ErrorBack + dmlEx);
        }
    }
    /*
    * @Method: getLeadTask
    * @Description: assigns id to task if already exists one
    * @Params: myTask: Task Object, recordId: lead id
    */
    private static void getLeadTask(Id recordId, Task myTask) {
        final Lead tId = [Select MX_SB_VTS_LookActivity__c from Lead where Id =: recordId];
        if(String.isNotBlank(tId.MX_SB_VTS_LookActivity__c)) {
            myTask.Id = tId.MX_SB_VTS_LookActivity__c;
        }
    }

    /*
    * @Method: getOpportunityTask
    * @Description: assigns id to task if already exists one
    * @Params: myTask: Task Object, recordId: lead id
    */
    private static void getOpportunityTask(Id recordId, Task myTask) {
        final Opportunity oId = [Select MX_SB_VTS_LookActivity__c from Opportunity where Id =: recordId];
        if(String.isNotBlank(oId.MX_SB_VTS_LookActivity__c)) {
            myTask.Id = oId.MX_SB_VTS_LookActivity__c;
        }
    }

    /*
    * @Method: finUsers
    * @Description: return object data type which contains current user info,
    * MX_SB_VTS_ProveedoresCTI__c data and current date
    */
    @AuraEnabled
    public static Object getUsers() {
        final List<Object> listValues = new List<Object>();
        try {
            final User getManager = [Select Id, MX_SB_VTS_ProveedorCTI__c, Manager.ManagerId, Manager.Name  from User WHERE Id =: UserInfo.getUserId()];
            final MX_SB_VTS_ProveedoresCTI__c proveedor = [Select Id, MX_SB_VTS_TieneSegmento__c From MX_SB_VTS_ProveedoresCTI__c Where Name =: getManager.MX_SB_VTS_ProveedorCTI__c];
            final DateTime currentDate = System.now();
            listValues.add(getManager);
            listValues.add(proveedor);
            listValues.add(currentDate);
        } catch(System.QueryException qEx) {
            throw new AuraHandledException(System.Label.MX_WB_LG_ErrorBack + qEx);
        }
        return listValues;
    }
    /**
    * @Method: envioAtuomatic
    * @Description: invoke service to perform callout to external service
    **/
    public static void  envioAutomatico(List<sObject> lstCTI, Task myTask) {
        final MX_SB_VTS_Lead_tray__c getTray = [Select Id, MX_SB_VTS_ID_Bandeja__c from MX_SB_VTS_Lead_tray__c where MX_SB_VTS_Tipo_Bandeja__c =: System.Label.MX_SB_VTS_HotLeads];
        final String formatDate = myTask.FechaHoraReagenda__c.format('dd/MM/yyyy hh:mm:ss');
        final Map<Id,String> tempdate = new Map<Id,String>();
            for(sObject obj: lstCTI) {
                tempdate.put(obj.Id, formatDate);
            }
        MX_SB_VTS_SendLead_helper_cls.EntRegistroGestion_invoke('EntRegistroGestion', lstCTI, '', System.Label.MX_SB_VTS_SmartServiceHogar, getTray.MX_SB_VTS_ID_Bandeja__c, tempdate);
    }
    /**
    * @method: checkLeadSource: validate lead origin for call me back, tracking web and outbound tlmk
    * @return: list of leads to be used
    **/
    private static List<SObject> checkRecordSource(String recordId, Boolean isLead) {
        final List<SObject> recordList = new List<SObject>();
        if(isLead) {
            final List<Lead> sendLeadToCTI = [Select Id, LeadSource, MobilePhone, MX_WB_ph_Telefono1__c, MX_WB_ph_Telefono2__c, MX_WB_ph_Telefono3__c, OwnerId from Lead where Id =: recordId];
            for(Lead checkLead : sendLeadToCTI) {
                switch on checkLead.LeadSource {
                    when 'Call me back', 'Tracking Web' {
                        checkLead.MX_WB_ph_Telefono1__c = checkLead.MobilePhone;
                        checkLead.MX_WB_ph_Telefono2__c = checkLead.MobilePhone;
                        checkLead.MX_WB_ph_Telefono3__c = checkLead.MobilePhone;
                        recordList.add(checkLead);
                   }
                   when 'Outbound TLMK' {
                       recordList.add(checkLead);
                   }
                }
            }
        } else {
            final List<Opportunity> sendOppToCTI = [Select Id, TelefonoCliente__c, OwnerId from Opportunity where Id =: recordId];
            recordList.addAll(sendOppToCTI);
        }
        return recordList;
    }
}
