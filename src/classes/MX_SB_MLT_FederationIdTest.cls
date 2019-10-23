/**-------------------------------------------------------------------------------
* Nombre: MX_SB_MLT_FederationIdTest
* Autor: Marco Antonio Cruz Barboza
* Proyecto: Siniestros - BBVA
* Descripción : Test de MX_SB_MLT_FederationId
* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                       Descripción
* --------------------------------------------------------------------------------
* 1.0         26/08/2019     Marco Antonio Cruz Barboza     Creación
* 1.1         23/09/2019     Daniel Goncalves Vivas         Modificación Asert Test
* 1.2         24/09/2019     Daniel Goncalves Vivas         Se agrega método para probar excepción
* 1.3         30/09/2019     Daniel Goncalves Vivas         Se declaran variables como final y se elimina un assert sobrante
* --------------------------------------------------------------------------------
**/

@isTest
private class MX_SB_MLT_FederationIdTest {
    @testSetup
    static void setDatos() {

        final User objUsrTst = MX_WB_TestData_cls.crearUsuario('PruebaTst', Label.MX_SB_MLT_SupervisorMultiasistencia); 
        insert objUsrTst;
    }

    static testMethod void validateFederationId() {
        final User objUsrTst = [SELECT FederationIdentifier FROM User WHERE LastName = 'PruebaTst' LIMIT 1]; 
        String idFed, idFedRes;     
        Test.startTest(); 
        objUsrTst.FederationIdentifier = 'MX1234';
        update objUsrTst;
        System.runAs(objUsrTst) {
            idFed = objUsrTst.FederationIdentifier;           
            idFedRes = MX_SB_MLT_FederationId.usuarioId();
        }
        Test.stopTest();
        system.assertEquals( idFed, idFedRes, 'Exitoso Consulta Federation Id');    
    }
    
    static testMethod void auraHandleExceptionTst() { 
        final User objUsrTst = [SELECT FederationIdentifier FROM User WHERE LastName = 'PruebaTst' LIMIT 1];    
        Test.startTest();
        objUsrTst.FederationIdentifier = '';
        update objUsrTst;
        System.runAs(objUsrTst) {
            try {
           	    MX_SB_MLT_FederationId.usuarioId();
            Test.stopTest();
            } catch (AuraHandledException auEx) {
                System.assert(auEx.getMessage().contains('Script')? true : false, 'No se encuentra usuario AuraHandledException');
            }
        }
    }   
}