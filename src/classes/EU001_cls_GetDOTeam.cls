/**
* ------------------------------------------------------------------------------------------------
* @Name     EU001_cls_GetDOTeam
* @Author   Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* @Date     Created: 2019-06-07
* @Group    Digital Workplace Retail
* @Description Obtain the DO team
* @Changes
**/

public with sharing class EU001_cls_GetDOTeam {

    //Constructor with no arguments
    @TestVisible
    private EU001_cls_GetDOTeam() {
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.contractor@bbva.com
* Date          07-06-2019
* @Description  Obtain the DO team.
* @Comments     Created from the clipped code block of class getDOteamPromPonderados.
* @param        String tipoDirector, List<String> roleIds, Boolean tipoDato
* @return       List<String> The DO team.
* @example      public static List<String> getDOTeam(String tipoDirector, List<String> roleIds, Boolean tipoDato){
**/
    public static List<String> getDOTeam(String tipoDirector, List<String> roleIds, Boolean tipoDato) {
        List<String> equipoDO = new List<String>();
        if(tipoDirector == 'DR') {
            equipoDO = getDOTeamForDR(roleIds, tipoDato);
        } else if(tipoDirector == 'DD') {
            equipoDO = getDOTeamForDD(roleIds, tipoDato);
        } else {
            final List<User> equipo = [SELECT Id, UG__c FROM User WHERE UserRoleId IN: roleIds AND IsActive = True];
            if(!equipo.isEmpty()) {
                for(User eq : equipo) {
                    if(tipoDato) {
                        equipoDO.add(eq.Id);
                    } else {
                        equipoDO.add(eq.UG__c);
                    }
                }
            }
        }
        return equipoDO;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.contractor@bbva.com
* Date          07-06-2019
* @Description  Obtain the DO team for DR.
* @Comments     Created from the clipped code block of class getDOteamPromPonderados.
* @param        List<String> roleIds, Boolean tipoDato
* @return       List<String> The DO team for DR.
* @example      public static List<String> getDOTeamForDR(List<String> roleIds, Boolean tipoDato){
**/
    public static List<String> getDOTeamForDR(List<String> roleIds, Boolean tipoDato) {
        final List<String> equipoDO = new List<String>();
        final List<String> roleIdsDR = new List<String>();
        final List<UserRole> funcionDO = [SELECT Id FROM UserRole WHERE parentroleid =: roleIds];
        if(!funcionDO.isEmpty()) {
            for(UserRole roles: funcionDO) {
                roleIdsDR.add(roles.Id);
            }
        }
        final List<User> usuariosRegional = [SELECT UG__c FROM User WHERE UserRoleId IN: roleIdsDR AND IsActive = True];
        for(User iteraUGTem : usuariosRegional) {
            if(tipoDato) {
                equipoDO.add(iteraUGTem.Id);
            } else {
                equipoDO.add(iteraUGTem.UG__c); }
        }
        return equipoDO;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.contractor@bbva.com
* Date          07-06-2019
* @Description  Obtain the DO team for DD.
* @Comments     Created from the clipped code block of class getDOteamPromPonderados.
* @param        List<String> roleIds, Boolean tipoDato
* @return       List<String> The DO team for DD.
* @example      public static List<String> getDOTeamForDD(List<String> roleIds, Boolean tipoDato){
**/
    public static List<String> getDOTeamForDD(List<String> roleIds, Boolean tipoDato) {
        final List<String> equipoDO = new List<String>();
        final List<String> roleIdsDR = new List<String>();
        final List<UserRole> funcionDR = [SELECT Id FROM UserRole WHERE parentroleid =: roleIds];
        if(!funcionDR.isEmpty()) {
            for(UserRole roles: funcionDR) {
                roleIdsDR.add(roles.Id);
            }
        }
        final List<UserRole> funcionDO = [SELECT Id FROM UserRole WHERE parentroleid IN: roleIdsDR];
        if(!funcionDO.isEmpty()) {
            for(UserRole roles: funcionDO) {
                roleIdsDR.add(roles.Id);
            }
        }
        final List<User> usuariosRegional = [SELECT UG__c FROM User WHERE UserRoleId IN: roleIdsDR AND IsActive = True];
        for(User iteraUGTem : usuariosRegional) {
            if(tipoDato) {
                equipoDO.add(iteraUGTem.Id);
            } else {
                equipoDO.add(iteraUGTem.UG__c);
            }
        }
        return equipoDO;
    }

}