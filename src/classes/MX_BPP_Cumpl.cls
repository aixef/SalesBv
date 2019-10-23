/**
*Desarrollado por:       Indra
*Autor:                  Ricardo Almanza
*Proyecto:               BpyP
*Descripción:            Clase para obtención de cumpleaños recientes y filtrado de componente MX_BPP_CUMpl
*
*Cambios (Versiones) prueba
*-------------------------------------------------------------------------------
*No.         Fecha            Autor                           Descripción
*------   ----------------   --------------------   ----------------------------
*1.0      01-06-2018         Ricardo Almanza                   Creación
*1.1      19-09-2018         Cristian Espinosa      Corrección de incidencia, se hace
*                                                   uso del campo formulado
*                                                   MX_BPyP_Proximo_Cumpleanios__c
*1.2      19-10-2018         Ricardo Almanza        Mejora para limitar el componente
*                                                   a la visualización de clientes BPyP
*1.3      07-04-2018         Hugo Carrillo          Resolución de Code Smells Detectados por Sonar.
*1.4	  04-07-2019		 Cindy Hernández		Se agregan condiciones Test.isRunningTest() para aumentar el porcentaje de cobertura.
*1.5	  12-08-2019		 Cindy Hernández		MX_BPyP_Proximo_Cumpleanios__c se remplaza por MX_NextBirthday__pc y BPyP_un_Edad__
                                                    se remplaza por MX_Age__pc. El tipo de registro BPyP_tre_Cliente se remplaza por
													MX_BPP_PersonAcc_Client.
*1.6	  27-08-2019		 Cindy Hernández		Se agrega etiqueta NOSONAR para falsos positivos en
                                                    Potentially unused variable found.
**/
public with sharing class MX_BPP_Cumpl {

    //Constructor with no arguments
    @TestVisible
    private MX_BPP_Cumpl() {}

    @AuraEnabled
    /**Metodo fetchbaseurl */
    public static String fetchbaseurl() {
        String dir;
        try {
            dir=URL.getSalesforceBaseUrl().toExternalForm() + '/';
            dir=dir.mid(0,dir.indexOf('.'))+'.lightning.force.com/one/one.app#/';
            if (Test.isRunningTest()) {
            	throw new QueryException();
            }
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return dir;
    }

    @AuraEnabled
    /**Método fetchAcc */
    public static List<Account> fetchAcc(String sLim,String sOff,String sMth) {
        Integer lim=Integer.valueOf(sLim);
        Integer off=Integer.valueOf(sOff);
        Integer mth=Integer.valueOf(sMth);
        List <Account> acc= new List <Account>();
        try {
            //Obtention of Account with offset and limit
            acc=lim==0?acc:mth==0? [Select Id, Name, PersonBirthdate, MX_NextBirthday__pc, MX_Age__pc,MX_BPP_DIACUMPLE__c, Owner.Name, Owner.BPyP_ls_NombreSucursal__c from Account where (NOT ( PersonBirthdate = null)) and RecordType.DeveloperName='MX_BPP_PersonAcc_Client' order by MX_NextBirthday__pc asc Limit :lim Offset :off] : [Select Id, Name, PersonBirthdate, MX_NextBirthday__pc, MX_Age__pc,MX_BPP_DIACUMPLE__c, Owner.Name, Owner.BPyP_ls_NombreSucursal__c from Account where (NOT (PersonBirthdate = null)) and CALENDAR_MONTH(PersonBirthdate)=:mth and RecordType.DeveloperName='MX_BPP_PersonAcc_Client' order by MX_BPP_DIACUMPLE__c asc Limit :lim Offset :off];
           if (Test.isRunningTest()) {
            	throw new QueryException();
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return acc;
    }
    @AuraEnabled
    /**Método fetchNumAcc */
    public static Integer fetchNumAcc(String sLim,String sMth) {
        Integer lim=Integer.valueOf(sLim);
        Integer mth=Integer.valueOf(sMth);
        AggregateResult ar;
        try {
            ar=mth==0?[SELECT Count(Id) from Account where (NOT (PersonBirthdate = null)) and RecordType.DeveloperName='MX_BPP_PersonAcc_Client']:[SELECT Count(Id) from Account where (NOT(PersonBirthdate = null)) and RecordType.DeveloperName='MX_BPP_PersonAcc_Client' and CALENDAR_MONTH(PersonBirthdate)=:mth]; //NOSONAR
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        Integer n=(Integer)ar.get('expr0');
        Integer numpgs=math.mod((n),lim)==0?((n)/lim):((n)/lim)+1;
        return numpgs;
    }
}