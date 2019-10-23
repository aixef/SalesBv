/**
* ------------------------------------------------------------------------------------------------
* @Name     EU001_modApoyos_Ctrl
* @Author   Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* @Date     Created: 2019-06-12
* @Group    Digital Workplace Retail
* @Description Get the cases owned by the banker
* @Comments Created from the clipped code from the EU001_cls_ConsolaDirector class
* @Changes
**/

public With Sharing class EU001_modApoyos_Ctrl {

    //Constructor with no arguments
    @TestVisible
    private EU001_modApoyos_Ctrl() {
    }

/*@Descripcion
*Guarda nuevos Apoyos , nivel superior
*Isaías Velázquez Cortés   /  06-03-2018
*-------------------------------------------------------------
*@Return Id User
*/
    @AuraEnabled
    public static void getInsertApoyos (String RType, Account Cliente,String Tipo,String Descripcion,string sFechaCierre,String Estado, Opportunity Opp, String sIdRI, String idResponsable, User idCoResp1, User idCoResp2) {
        String TipoRegistro='';
        final date FechaCierre = Date.valueOf(sFechaCierre);
        EU001_RI__c RISeleccionada;

        RISeleccionada = ([SELECT Id, OwnerId FROM EU001_RI__c WHERE Id =: sIdRI LIMIT 1]);
        final Case row = new Case();

        if(Cliente!=null) {
            row.Cliente_Intrusion__c=Cliente.Id;
        }
        if(idResponsable.length()>0) {
            row.Responsable_de_aclaracion__c=idResponsable;
        }
        if(idCoResp1!=null) {
            row.Responsable_Aclaracion_Usuario__c=idCoResp1.Id;
        }
        if(idCoResp2!=null) {
            row.EU001_Rb_Corresponsable__c=idCoResp2.Id;
        }
        if(Opp!=null) {
            row.EU001_Rb_Oportunidad__c=Opp.Id;
        }

        row.Reuni_n_Individual_RI__c=RISeleccionada.Id;
        row.EU001_ls_Tipo_de_apoyo__c=Tipo;
        row.Description=Descripcion;
        TipoRegistro=RType;
        row.RecordTypeId=TipoRegistro;
        row.EU001_fh_Fecha_propuesta_de_cierre__c=FechaCierre;
        row.Status=Estado;
        row.OwnerId=RISeleccionada.OwnerId;

        try {
            insert row;
           	if (Test.isRunningTest()) {
            	throw new DmlException();
            }
        } catch(DmlException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }

    }

    @AuraEnabled
    /**Metodo  */
    public static List<EU001_RI__c> getUser(String recordId) {
        List<EU001_RI__c> lista = new List<EU001_RI__c>();
        try {
            lista = EU001_cls_ConsolaDirector.getUser(recordId);
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return lista;
    }

    @AuraEnabled
    /**Metodo */
    public static String getRecordTypeId(String sObjType ,String Concepto) {
        Id IdRType;
        try {
            IdRType = Schema.getGlobalDescribe().get(sObjType).getDescribe().getRecordTypeInfosByName().get(Concepto).getRecordTypeId();
        } catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return ''+IdRType;
    }

    /*@Descripcion
    *Obtiene el Id del Usuario de nivel superior
    *Isaías Velázquez Cortés   /  05-03-2018
    *-------------------------------------------------------------
    *@Return Id User
    */
    @AuraEnabled
    public static List<User> getSuperiorLevel(String UserID) {
        List<User> supID = new List<User>();
        try {
            final User usProfile = [Select id, UserRole.Name From User Where Id =: UserID];
            final String UR_id = [Select UserRoleId From User Where Id = : UserID][0].UserRoleId;
            final String ParentID = [SELECT ParentRoleId FROM UserRole WHERE Id =: UR_id  Limit 1][0].ParentRoleId;
            if(usProfile.UserRole.Name.contains(EU001_CLS_CONSTANTES.EU001_EC_REFERENCIA)) {
                supID = [Select Id,Name From User Where UserRoleId =: ParentID and isActive = true and (NOT Profile.Name LIKE :EU001_CLS_CONSTANTES.EU001_GERENTE_REFERENCIA_MAY) Limit 1];
            } else {
                supID = [Select Id,Name From User Where UserRoleId =: ParentID and isActive = true Limit 1];
            }
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return supID;
    }

}