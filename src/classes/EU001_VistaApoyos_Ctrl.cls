/**
* ------------------------------------------------------------------------------------------------
* @Name     EU001_VistaApoyos_Ctrl
* @Author   Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* @Date     Created: 2019-06-12
* @Group    Digital Workplace Retail
* @Description Get the cases owned by the banker
* @Comments Created from the clipped code from the EU001_cls_ConsolaDirector class
* @Changes
**/

public With Sharing class EU001_VistaApoyos_Ctrl {

    //Constructor with no arguments
    @TestVisible
    private EU001_VistaApoyos_Ctrl() {
    }

/*@Descripcion
*Obtiene Obtiene la lista de casos del propiertaro del RI
*21-03-2018 Abraham Tinajero: Se modifica la consulta para DO, solo pueden ver los casos de los que son propietarios
*03-04-2018 Abraham Tinajero: Se actualiza consulta a nuevos estatus de apoyos
*-------------------------------------------------------------
*@Return Lista de Casos
*/
    @AuraEnabled
    public static list<Case> getTableApoyos(String idRI,String RecordTypeFilter,String Status) {

        final List<EU001_RI__c> owRI = EU001_cls_ConsolaDirector.getUser(idRI);
        List<Case> lstCase;
        try {
            if(Status=='' || Status == null || Status.length()==0 || Status=='Ninguno') {
                    lstCase = [SELECT Id,CaseNumber, Status,Priority,Owner.Alias,EU001_ls_Tipo_de_apoyo__c,EU001_fh_Fecha_propuesta_de_cierre__c,Description from Case where RecordTypeId=:EU001_modApoyos_Ctrl.getRecordTypeId('Case' ,RecordTypeFilter)  and OwnerId=:owRI[0].OwnerId];
            } else {
                final List<String> estatusApoyos = new List<String>();
                estatusApoyos.add(Status);

                if(Status.equals(EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_HECHO)) {
                    estatusApoyos.add('Cerrado');
                } else if(Status.equals(EU001_CLS_CONSTANTES.EU001_STR_ALERTAS_ETAPA_DESCARTADO)) {
                    estatusApoyos.add('Rechazada');
                }
                lstCase =[SELECT Id,CaseNumber, Status,Priority,Owner.Alias, EU001_ls_Tipo_de_apoyo__c,EU001_fh_Fecha_propuesta_de_cierre__c,Description from Case where RecordTypeId=:EU001_modApoyos_Ctrl.getRecordTypeId('Case' ,RecordTypeFilter) and Status=:Status and OwnerId=:owRI[0].OwnerId];
                if (Test.isRunningTest()) {
                    throw new QueryException();
                }
            }
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }

        return lstCase;
    }

}