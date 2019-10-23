/**-------------------------------------------------------------------------
* Nombre: MX_WB_ReagendaOpportunityController
* Autor Alexis Pérez
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Apex Controller for re-assignment Opportunity.

* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Desripción<p />
* -------------------------------------------------------------------
* 1.0           16/01/2019      Alexis Pérez		   	Creación
* 1.1			21/02/2019		Alexis Pérez			Se añade la selección del usuario en curso para poderlo visualizar como un
* 														usuario seleccionable en la lista de asesores.
*														Se añade fecha de cierre a task.
* --------------------------------------------------------------------------
*/
public with sharing class MX_WB_ReagendaOpportunityController {

    private MX_WB_ReagendaOpportunityController() {}
    /*
     * List with all active advisors.
     */
    public static List<User> lstUAsesores { get; set; }
    /*
     * List with of the schedules availables.
     */
    public static List<MX_WB_TlmktHorarios__c> lstHorarios {get; set;}

    /*
     * Current User
     */
    public static User objCurrentUser {get; set;}

    /*
     * static block with the load of the advisors and schedules.
     */
    static {
        final String idProfAsesor = [SELECT Id FROM Profile WHERE Name=: Label.MX_WB_lbl_PerfilAsesoresTlmkt].Id;
        lstUAsesores = [SELECT Name, Id, Turno__c FROM User WHERE profileId =: idProfAsesor AND IsActive = true];
        objCurrentUser = [SELECT Name, Id FROM User WHERE Id =: UserInfo.getUserId()];
        lstHorarios = [SELECT MX_WB_HorarioMaximo__c, MX_WB_HorarioMinimo__c, Name FROM MX_WB_TlmktHorarios__c WHERE NOT(Name=null)];
    }
    /*
     * Return map with all necesary information.
     */
    @AuraEnabled
    public static Map<String, Object> reuneData() {
        final Map<String, Object> mpAllData = new Map<String, Object>();
        try {
            mpAllData.put('usuarios', lstUAsesores);
            mpAllData.put('horarios', lstHorarios);
            mpAllData.put('turnos', recuperaTurnos());
            mpAllData.put('current', objCurrentUser);
            return mpAllData;
        } catch(QueryException ex) {
            throw new AuraHandledException(Label.MX_WB_lbl_ReagendamientoException + ex);
        }
    }

    /**
     * Return a list of strings with the turns.
     * @return List of turns.
     */
    public static List<String> recuperaTurnos() {
        final Set<String> stTurnos = new Set<String>();
        final List<String> lstTurnos = new List<String>();
        for(User itUser : lstUAsesores) {
            if(String.IsNotBlank(itUser.Turno__c)) {
                stTurnos.add(itUser.Turno__c);
            }
        }
        lstTurnos.addAll(stTurnos);
        return lstTurnos;
    }

    /**
     * Insert the task with the data of the re-assignment.
     * @param String owner, string fecha, String hora, String comentarios.
     * @return String with successful or exception.
     */
    @AuraEnabled
    public static String insertaTarea(String owner, string fecha, String hora, String comentarios, String idOpp) {
        try {
            final String[] datosFecha = fecha.split('-');
            final String[] datosHora = hora.split('\\.')[0].split(':');

            final String strDTAgenda = datosFecha[0] + '-' + datosFecha[1] + '-' + datosFecha[2] + ' ' + datosHora[0] + ':' + datosHora[1] + ':' +datosHora[2];
            final Datetime dtReagenda = Datetime.valueOf(strDTAgenda);

            final String strFechaCierre = datosFecha[0] + '-' + datosFecha[1] + '-' +datosFecha[2] + ' 23:59:59';
            Date fechaCierre = date.valueOf(strFechaCierre);
            fechaCierre = fechaCierre.addDays(1);
            final Task objTask = new Task();
            objTask.OwnerId = owner;
            objTask.Description = comentarios;
            objTask.Subject = 'Call';
            objTask.ReminderDateTime = dtReagenda;
            objTask.IsReminderSet = true;
            objTask.WhatId = idOpp;
            objTask.ActivityDate = fechaCierre;
            insert objTask;

            final Opportunity objOpp = [SELECT Id, Name FROM Opportunity WHERE Id=:idOpp];
            objOpp.OwnerId = owner;
            update objOpp;

            return Label.MX_WB_lbl_ReagendamientoExito;
        } catch(DMLException ex) {
            throw new AuraHandledException(Label.MX_WB_lbl_ReagendamientoException + ex);
        }
    }
}