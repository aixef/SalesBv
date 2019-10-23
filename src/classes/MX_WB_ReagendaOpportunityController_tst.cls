/**-------------------------------------------------------------------------
* Nombre: MX_WB_ReagendaOpportunityController
* Autor Alexis Pérez
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Apex Controller test for re-assignment Opportunity.

* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Desripción<p />
* -------------------------------------------------------------------
* 1.0           16/01/2019      Alexis Pérez		   	Creación
* 1.1			21/02/2019		Alexis Pérez			Se prueba la selección del usuario en curso para poderlo visualizar como un
* 														usuario seleccionable en la lista de asesores.
* --------------------------------------------------------------------------
*/
@IsTest
public class MX_WB_ReagendaOpportunityController_tst {

    /*
     * Insert Data.
     */
    @TestSetup
    public static void insertData() {
        final MX_WB_TlmktHorarios__c objHoraTlmkt = new MX_WB_TlmktHorarios__c();
        objHoraTlmkt.Name = 'Matutino';
        objHoraTlmkt.MX_WB_HorarioMinimo__c = '09:00';
        objHoraTlmkt.MX_WB_HorarioMaximo__c = '13:00';
        insert objHoraTlmkt;

    }

    /*
     * Test method.
     */
    @IsTest
    public static void pruebas() {
        final String idRTOutOpp = [SELECT id from RecordType where Name ='Outbound' AND SObjectType = 'Opportunity'].Id;
        final Date objDTHoy = Date.today();
        final Opportunity objCotizacion = new Opportunity();
        objCotizacion.Name = 'TestCotizacionMinion001';
        objCotizacion.StageName = 'Contacto Efectivo';
        objCotizacion.CloseDate = objDTHoy.addDays(30);
        objCotizacion.RecordTypeId = idRTOutOpp;
        insert objCotizacion;

        final Profile profileId = [SELECT Id FROM Profile WHERE Name=: Label.MX_WB_lbl_PerfilAsesoresTlmkt LIMIT 1];
     	final User user = new User(LastName = 'Test', FirstName='ASD', Alias = 'testasd', Email = 'testasd@novalid.com',
                            Username = 'testasd@novalid.com', ProfileId = profileId.id, TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US');
        insert user;

        boolean hayError = false;
        final Map<String, Object> mpAllData = MX_WB_ReagendaOpportunityController.reuneData();
        final List<User> lstUsers = (List<User>)mpAllData.get('usuarios');
        System.assertEquals(false, lstUsers.IsEmpty(), 'Se esperaba una lista con valores');

        final String insertTaskSuccess = MX_WB_ReagendaOpportunityController.insertaTarea(lstUsers.get(0).Id, '2050-01-21', '09:00:00.0000', 'Reagendado a las 9:00 am', objCotizacion.Id);
        System.assertEquals(Label.MX_WB_lbl_ReagendamientoExito, insertTaskSuccess, 'Mensaje de éxito en la inserción');

        try {
            MX_WB_ReagendaOpportunityController.insertaTarea(null, '2050-01-21', '09:00:00.0000', 'Reagendado a las 9:00 am', objCotizacion.Id);
        } catch(System.AuraHandledException ex) {
            hayError = true;
            System.assertEquals(hayError, String.IsNotEmpty(ex.getMessage()), 'Error con mensaje esperado');
        }
    }
}