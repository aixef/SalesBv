/*
*
* @author Jaime Terrats
* @description API to auto assign leads from Smart Center to call center agents
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    06/24/2019     Jaime Terrats     Create API for Smart Center
* @version  1.1    06/25/2019     Jaime Terrats     Change logic to work with Opportunities or Leads
* @version  1.2    06/26/2019     Jaime Terrats     Add method to create tasks when api is invoked
* @version  1.2.1  06/28/2019     Jaime Terrats     Remove code smells
* @version  1.3    06/28/2019     julio Medellin    Change Stage On  Opporunity
* @version  1.4    09/23/2019     Jaime Terrats     Add json parse to read values from json object
* @version  1.5    10/03/2019     Jaime Terrats     Clear values on fields
*
*/
@RestResource(urlMapping='/leadAutoAssigner/*')
global without sharing class MX_SB_VTS_LeadAutoAssigner { // NOSONAR

    /*
* Method that performs lead auto assignment from
* Smart center by getting the LeadId and owner RFC
*/
    @HttpPost
    global static String assignLead() {
        final String baseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/'; // NOSONAR
        final Map<String, Object> listener = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());

        final String recordId = String.valueOf(listener.get('recordId'));
        final String rfc =String.valueOf(listener.get('rfc'));
        final String callId = String.valueOf(listener.get('callId'));  // NOSONAR
        final String tipificacion = String.valueOf(listener.get('tipificacion'));  // NOSONAR

        String recordUrl = '';
        String type = ''; // NOSONAR
        Boolean isLead;
        if(String.isNotBlank(recordId)) {
            if(recordId.startsWith('00Q')) {
                type = 'Lead'; // NOSONAR
                isLead = true; // NOSONAR
            } else if(recordId.startsWith('006')) {
                type = 'Opportunity'; // NOSONAR
                isLead = false; // NOSONAR
            }
            final sObject record = getRecord(recordId, type);
            if(String.isNotBlank(recordId) && String.isNotBlank(rfc)) {

                final User usr = getUserInfo(rfc);
                if(String.isNotBlank(usr.Id)) {
                    try {
                        record.put('OwnerId', usr.Id);
                        recordUrl = baseUrl + record.Id;
                        final List<String> params = new List<String>();
                        params.add(callId);
                        params.add(record.Id);
                        params.add(String.valueOf(isLead));
                        params.add(usr.Id);
                        params.add(tipificacion);
                        final Task finalTask = createTask(params);
                        insert finalTask;
                        updateLead(record, isLead, finalTask.Id);
                        updateRecord(record, isLead, 1, 1, 1, 1);
                    } catch(DmlException dmlEx) {
                        recordUrl = System.Label.MX_WB_LG_ErrorBack; // NOSONAR
                        throw new DmlException(dmlEx);
                    }
                }
            } else {
                updateRecord(record, isLead, 1, 0, 1, 0);
                recordUrl = System.Label.MX_WB_LG_ErrorBack;
            }
        } else {
            recordUrl = System.Label.MX_WB_LG_ErrorBack;
        }
        return recordUrl;
    }

    /*
*
* Returns Agent Id
* @param: rfc string to find agent Id
*
*/
    private static User getUserInfo(String rfc) {
        return [Select Id from User where rfc__c =: rfc];
    }

    /*
*
* Increments fields from leads and opportunities based on a criteria
* @param:
*
*/
    public static void updateRecord(sObject record, Boolean isLead, Integer contadorLlamadas, Integer contadorToques, Integer contadorCe, Integer contadorCne) {
        if(isLead) {
            Lead leadUpdate = (Lead)record;

            final Integer llamadas = checkNullVals(leadUpdate.MX_SB_VTS_ContadorLlamadasTotales__c);
            final Integer toques = checkNullVals(leadUpdate.MX_SB_VTS_ContadorRemarcado__c);
            leadUpdate.MX_SB_VTS_ContadorLlamadasTotales__c = llamadas+contadorLlamadas;
            leadUpdate.MX_SB_VTS_ContadorRemarcado__c = toques+contadorToques;
            leadUpdate.Status =      Label.MX_SB_VTS_CONTACTO_LBL;
            leadUpdate.MX_SB_VTS_Tipificacion__c = '';
            leadUpdate.MX_SB_VTS_Tipificacion_LV2__c = '';
            leadUpdate.MX_SB_VTS_Tipificacion_LV3__c = '';
            leadUpdate.MX_SB_VTS_Tipificacion_LV4__c = '';
            leadUpdate.MX_SB_VTS_Tipificacion_LV5__c = '';
            leadUpdate.MX_SB_VTS_Tipificacion_LV6__c = '';
            update leadUpdate;
        } else {
            Opportunity oppUpdate = (Opportunity)record;

            final Integer llamadas = checkNullVals(oppUpdate.MX_SB_VTS_ContadorLlamadasTotales__c);
            final Integer toques = checkNullVals(oppUpdate.MX_SB_VTS_ContadorRemarcado__c);
            oppUpdate.MX_SB_VTS_ContadorLlamadasTotales__c = llamadas+contadorLlamadas;
            oppUpdate.MX_SB_VTS_ContadorRemarcado__c = toques+contadorToques;
            oppUpdate.StageName = Label.MX_SB_VTS_CONTACTO_LBL;
            oppUpdate.MX_SB_VTS_Tipificacion_LV1__c = '';
            oppUpdate.MX_SB_VTS_Tipificacion_LV2__c = '';
            oppUpdate.MX_SB_VTS_Tipificacion_LV3__c = '';
            oppUpdate.MX_SB_VTS_Tipificacion_LV4__c = '';
            oppUpdate.MX_SB_VTS_Tipificacion_LV5__c = '';
            oppUpdate.MX_SB_VTS_Tipificacion_LV6__c = '';
            update oppUpdate;
        }
    }
    /** */
    public static Integer checkNullVals (Decimal value) {
        Integer finalVal = 0;
        if(String.isNotBlank(String.valueOf(value))) {
            finalVal = Integer.valueOf(value);
        }
        return finalVal;
    }

    /*
*
* Update record
* @param: registro SObject, bandera es Lead, Id tarea
*
*/
    public static void updateLead(sObject record, Boolean isLead, Id taskId) {
        if(isLead) {
            final Lead leadRecord = (Lead)record;
            leadRecord.MX_SB_VTS_LookActivity__c = taskId;
            leadRecord.MX_SB_VTS_Tipificacion_LV6__c = '';
            update leadRecord;
        }
    }

    /*
*
* returns a lead or opportunity
* @params recorId return query data by record Id
* @params type used to define if the object is lead or opportunity
*
*/
    private static SObject getRecord(String recordId, String type) { // NOSONAR
        final String query = 'Select Id,MX_SB_VTS_ContadorRemarcado__c,MX_SB_VTS_Llamadas_Efectivas__c,MX_SB_VTS_Llamadas_No_Efectivas__c,MX_SB_VTS_ContadorLlamadasTotales__c, MX_SB_VTS_LookActivity__c, MX_SB_VTS_Tipificacion_LV6__c, OwnerId from ' + type +  ' where Id =: recordId';
        return Database.query(String.escapeSingleQuotes(query));
    }

    /*
*
* @param: params array with ids
* method: creates new task for reassigned lead / opportunity
*
*/
    private static Task createTask(List<String> params) {
        final Task newTask = new Task();
        newTask.Subject = 'Call';
        if(Boolean.valueOf(params[2])) {
            newTask.whoId = params[1];
        } else {
            newTask.whatId = params[1];
        }
        newTask.OwnerId = params[3];
        return newTask;
    }
}
