/**-------------------------------------------------------------------------
* Nombre: MX_SB_VTS_ScripLead_cls
* @author Arsenio Perez Lopez (xemo)
* Proyecto: MW SB VTS - BBVA 
* Descripción : Clase control para componente MX_SB_VTS_ScripLead

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           25/04/2019      Arsenio  Perez            Creación
* @version 1.0           25/04/2019      Eduardo Hernandoez        Creación
* --------------------------------------------------------------------------*/
@isTest()
public with sharing class MX_SB_VTS_ScripLead_tst {
    
    @TestSetup
    static void makeData() {
        final Lead LeadTemp = MX_WB_TestData_cls.createLead('Juan');
        LeadTemp.Status= 'Apertura';
        LeadTemp.LeadSource='Inbound';
        LeadTemp.RecordTypeId = Schema.SobjectType.Lead.getRecordTypeInfosByDeveloperName().get('ASD').getRecordTypeId();
        Insert LeadTemp;
        Scripts_Stage_Product__c Script = new Scripts_Stage_Product__c(
            Name='Apertura', 
            MX_WB_Etapa__c= 'Apertura', 
            MX_SB_VTS_OrigenOpp__c ='Inbound',
            MX_WB_Script__c='juanito');
        insert Script;

    }

    @istest static void test2 () {
        final Lead tempLead = [select id, Status from lead where LastName = 'Juan'];
            test.startTest();
                final string temo =   MX_SB_VTS_ScripLead_cls.getScript(tempLead.Id);
                system.assertEquals('juanito', temo);
            test.stopTest();
    }

   @istest static void test3 () {       
            test.startTest();
            final string temo;
            try {
                temo =   MX_SB_VTS_ScripLead_cls.getScript('');
            } catch (AuraHandledException e) {
                system.assert(String.isEmpty(temo),'Valida que al ingresar un vacio no se regrese un script'+e.getMessage());
            }   
            test.stopTest();
    }

}