/*----------------------------------Desarrollado por INDRA---------------------------------
*Autor:         Ricardo Almanza Angeles
*Proyecto:      Max BBVA PI8
*Descripción:   Manejador para el trigger de BPyP de asignación de Clientes.
*_______________________________________________________________________________________
*Versión    Fecha       Autor                           Descripción
*1.0        14/FEB/2018 Ricardo Almanza Angeles         Creación
*1.1        27/AGO/2019 Cindy Arianna Hernández Nieto   Se modifica el método test_AsignaBkm
                                                        para crear cuentas personales y
                                                        corporativas.
                                                        Se cambia el nombre del método
                                                        test_AsignaBkm por testAsignaBkm.
-----------------------------------------------------------------------------------------*/
@isTest
private class BPyP_ClienteImportar_clsTest {

    /**
     * This is a test method for AsignaBkm
     */
    static testMethod void testAsignaBkm() {
        final User user1 = [Select Id,Name,VP_ls_Banca__c from User where Id=:UserInfo.getUserId()];
        final User user2 = MX_BPP_AccountDataFactory.getBPYPStandardUser();
        insert user2;
        System.debug('ralm bt Trigger_Oportunidad__c.getInstance().BPyP_ClienteImportar_cls__c '+Trigger_Oportunidad__c.getInstance().BPyP_ClienteImportar_cls__c);
        insert new Trigger_Oportunidad__c(BPyP_ClienteImportar_cls__c = true);
        System.debug('ralm at Trigger_Oportunidad__c.getInstance().BPyP_ClienteImportar_cls__c '+Trigger_Oportunidad__c.getInstance().BPyP_ClienteImportar_cls__c);
        user1.EmployeeNumber='123';
        Test.startTest();
        update user1;
        final Account[] accl=new List<Account>();
        Account[] accl2=new List<Account>();
        final Id[] idAcc=new List<Id>();
        final List<MX_BPP_SectorCodes__mdt> personAccCodes = [SELECT MX_BPP_SectorCode__c FROM MX_BPP_SectorCodes__mdt WHERE MX_BPP_SectorAccountType__c = 'Cuenta personal' LIMIT 1];
        Account personAcc;
        for(Integer i = 0; i < 200; i++) {
			personAcc = new Account();
	        personAcc.Tipo_de_Registro_Manual__c = 'BPYP_PRE';
	        personAcc.BPyP_Un_Numero_Promotor__c = '123';
	        personAcc.FirstName = 'Test ' + i;
            personAcc.LastName = 'Test';
	        personAcc.OwnerId = user2.Id;
            personAcc.Sector__c = personAccCodes[0].MX_BPP_SectorCode__c;
	        accl.add(personAcc);
	    }
        final Account businessAcc = new Account();
        businessAcc.Tipo_de_Registro_Manual__c = 'BPYP_PRE';
        businessAcc.BPyP_Un_Numero_Promotor__c = '123';
        businessAcc.Name = 'Test Business Acc';
        businessAcc.Sector__c = 'M31';
        businessAcc.OwnerId = user2.Id;
        accl.add(businessAcc);
        insert accl;
        Test.stopTest();
        for(Account ac: accl) {idAcc.add(ac.Id); }
        accl2 = [SELECT Id,Name,OwnerId FROM Account WHERE Id in :idAcc];
        for(Account ac: accl2) {
        	System.assertEquals(ac.OwnerId, user1.Id, 'Correcta asignación de usuario');
        }
    }

}