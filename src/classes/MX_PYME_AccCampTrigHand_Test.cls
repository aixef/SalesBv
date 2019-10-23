/*******************************************************************************
@Name                   MX_PYME_AccCampTrigHand_Test
Desarrollado por:       Indra
@Author                 Ricardo Almanza
@Date                   2019-01-17
Proyecto:               PYME
@Group                  Trigger AccountCampaign
*************************************************************************************
@Description            Clase para clase métodos de trigger de AccountCampaign Manteniendo relación entre campaña y Oportunidad
*************************************************************************************
@Changes                (most recent first)
2019-02-11              Test updSuccAccCamp
2019-07-11              Change the query for the UtilitysDataTest_tst.crearUsuario method.
/*******************************************************************************/
@isTest
public with sharing class MX_PYME_AccCampTrigHand_Test {
    @isTest static void test_generacion_AccCamp() {
        //Crear usuario administrador
        User csidmnvl = UtilitysDataTest_tst.crearUsuario('csidmnvl', Label.MX_PERFIL_SystemAdministrator, 'DIRECCIÓN GENERAL BMI');
        insert csidmnvl;
        System.runAs(csidmnvl) {
            Account cliente = UtilitysDataTest_tst.crearCuenta('UsuarioTest', 'VP_tre_Cliente_PyME');
            cliente.no_de_cliente__c='01234567';
            insert cliente;
            system.debug('Id: ' + csidmnvl.Id);
            cond__Account_Campaign__c accCamp=UtilitysDataTest_tst.crearAccCampaign(csidmnvl.Id, 'MX_PYME_Campania_Cargada', 'T123', '01234567');
            insert accCamp;
            accCamp.cond__Others_rejection_reason_desc__c='Gestión sin productos';
            update accCamp;
            System.assertEquals([Select Id, cond__Campaign_status_approval_type__c from cond__Account_Campaign__c where Id=:accCamp.Id].cond__Campaign_status_approval_type__c, 'In Progress', 'Approval correcto');
            accCamp.cond__data_source_name__c='UpdEndDt';
            update accCamp;
            Campaign camp=[Select Id, MX_PYME_Productos__c, cond__campaign_id__c from Campaign where cond__campaign_id__c = 'T123'];
            camp.MX_PYME_Productos__c='Crédito Simple';
            update camp;
            accCamp.MX_PYME_Success__c=true;
            update accCamp;
            System.assertEquals([Select Id, cond__Campaign_status_approval_type__c,cond__sub_status_type__c from cond__Account_Campaign__c where Id=:accCamp.Id].cond__sub_status_type__c, 'Won', 'Marcado correcto');
            cond__Account_Campaign__c accCamp2=UtilitysDataTest_tst.crearAccCampaign(csidmnvl.Id, 'MX_PYME_Campania_Cargada', 'T123', '01234568');
            insert accCamp2;
            System.assertEquals([Select Id, RecordTypeId from cond__Account_Campaign__c where Id=:accCamp.Id].RecordTypeId, RecordTypeMemory_cls.getRecType('cond__Account_Campaign__c', 'MX_PYME_Campania_CargadaPrd'), 'Actualización de registro completo');
        }
    }
}