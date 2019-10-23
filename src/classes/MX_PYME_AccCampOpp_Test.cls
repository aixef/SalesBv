/*******************************************************************************
@Name                   MX_PYME_AccCampOpp_Test
Desarrollado por:       Indra
@Author                 Ricardo Almanza
@Date                   2019-01-17
Proyecto:               PYME
@Group                  Trigger Oportunidad
*************************************************************************************
@Description            Clase de test para la clase MX_PYME_AccCampOpp
*************************************************************************************
@Changes
2019-04-04  ricardo.almanza.contractor@bbva.com     Uso de etiqueta para multilenguajes
2019-07-11  jairignacio.gonzalez.contractor@bbva.com    Se depuro clase con los metodos confirmados en la migracion de bpyp y pymes
/*******************************************************************************/
@isTest
public with sharing class MX_PYME_AccCampOpp_Test {
    @isTest static void testGeneracionOpp() {
        final User csidmnvl = UtilitysDataTest_tst.crearUsuario('MX_PYME_Test', Label.MX_PERFIL_SystemAdministrator, 'DIRECCIÓN GENERAL BMI');
        insert csidmnvl;

        System.runAs(csidmnvl) {
            final Account cliente = UtilitysDataTest_tst.crearCuenta('UsuarioTest', 'VP_tre_Cliente_PyME');
            cliente.no_de_cliente__c = '01234567';
            insert cliente;
            final cond__Account_Campaign__c accCamp = UtilitysDataTest_tst.crearAccCampaign(csidmnvl.Id, 'MX_PYME_Campania_Cargada', 'T123', '01234567');
            insert accCamp;
            final Campaign camp = [Select Id, MX_PYME_Productos__c, cond__campaign_id__c from Campaign where cond__campaign_id__c = 'T123'];
            System.assertNotEquals(null, camp.Id,'Campaña creada por trigger');
            camp.MX_PYME_Productos__c = 'Auto';
            update camp;

            UtilitysDataTest_tst.crearProdForm('Colocación', 'Auto');
            final Opportunity opp = UtilitysDataTest_tst.crearOportunidad('Test AccCamp', cliente.Id, csidmnvl.Id, 'Colocación', 'Auto', null, 'MX_BPP_RedBpyp');
            opp.cond__participant_campaign_id__c = accCamp.Id;
            Insert opp;
            System.assertNotEquals(null, opp.Id,'Oportunidad creada y enlazada a campaña');
            final cond__Account_Campaign__c accCamp2 = UtilitysDataTest_tst.crearAccCampaign(csidmnvl.Id, 'MX_PYME_Campania_Cargada', 'T123', '01234568');
            insert accCamp2;
            opp.cond__participant_campaign_id__c = accCamp2.Id;
            try {
                update opp;
            } catch(System.DmlException e) {
                system.assert(e.getMessage().contains(Label.MX_PYME_AccCampAccErrOpp), 'Error controlado de no cliente asociado');
            }
            delete opp;
        }
    }
}