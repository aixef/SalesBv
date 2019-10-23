/*
----------------------------------------------------------------------------------
* Nombre: MX_SB_MLT_MapaTDT_TEST
* Autor Oscar Martínez
* Proyecto: SB Siniestros - BBVA Bancomer
* Descripción : Prueba los Methods de MX_SB_MLT_MapaTDT_Cls

* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                               Descripción
* --------------------------------------------------------------------------------
* 1.0           08/05/2019     Oscar Martínez                       Creación
* 1.1           15/05/2019     Daniel Goncalves Vivas               Corrección acentos y typos
* 1.2           16/05/2019     Saúl González Reséndiz               Corrección de comentarios sonar
* 1.3           25/09/2019     Ing. Daniel Goncalves                Se agrega Setup
* 1.4           30/09/2019     Ing. Daniel Goncalves                Se declaran objetos como finals
* --------------------------------------------------------------------------------
*/

@isTest
private class MX_SB_MLT_MapaTDT_TEST {

    @testSetup
    static void setDatos() {

        final User objUsrTst = MX_WB_TestData_cls.crearUsuario('PruebaAdminTst', Label.MX_SB_VTS_ProfileAdmin); 
        insert objUsrTst;
        System.runAs(objUsrTst) {
            final Account objAccTst = MX_WB_TestData_cls.crearCuenta ( 'LastName', 'MX_WB_rt_PAcc_Telemarketing' );
            insert objAccTst;
            final Case objCaseTst = new Case(Status='New',Origin='Phone',Priority='Medium',AccountId=objAccTst.Id,MX_SB_MLT_URLLocation__c='19.305819,-99.2115422');
            insert objCaseTst;
        }
    }

    static testMethod void datosMapaNoVacia() {
        final Case objCaseTst = [SELECT Id, Origin FROM Case WHERE Priority = 'Medium' LIMIT 1];
        Test.startTest(); 
            final List<Case> lstCase = MX_SB_MLT_MapaTDT_Cls.datosMapa(objCaseTst.Id);
        Test.stopTest();        
        System.assertEquals(objCaseTst.Origin, lstCase.get(0).Origin, 'Retorna Valor de Caso Correctamente');
    }

    static testMethod void datosMapaCorrectos() {
        final Case objCaseTst = [SELECT Id, MX_SB_MLT_URLLocation__c FROM Case WHERE Priority = 'Medium' LIMIT 1];
        Test.startTest(); 
            final List<Case> lstCase = MX_SB_MLT_MapaTDT_Cls.datosMapa(objCaseTst.Id);
        Test.stopTest(); 
        System.assertEquals(objCaseTst.MX_SB_MLT_URLLocation__c, lstCase.get(0).MX_SB_MLT_URLLocation__c, 'Retorna Geolocalización de Caso Correctamente');      
    }

    static testMethod void datosMapaException() {
        final Account objAccTst = [SELECT Id FROM Account WHERE FirstName = 'LastName' LIMIT 1];
        try {
            MX_SB_MLT_MapaTDT_Cls.datosMapa(objAccTst.Id);
        } catch(AuraHandledException e) {
            System.assertEquals('Script-thrown exception', e.getMessage(),'Excepción Propagada Correctamente');
        }
    }
}