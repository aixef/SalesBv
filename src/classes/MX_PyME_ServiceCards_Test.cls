/**
* ------------------------------------------------------------------------------------------------
* @Name         MX_PyME_ServiceCards_Test
* @Author       Daniel García
* @Date         Created: 2019-02-11
* @Group        Test class for controller PyME services
* @Description  Class that call mocks to test PyME services
* @Changes      (most recent first)
*
*  |2019-02-11  First version
*
* ------------------------------------------------------------------------------------------------
*/
@isTest
public class MX_PyME_ServiceCards_Test {
     @isTest static void testServices() {
         iaso__GBL_Rest_Services_Url__c customSetting = new iaso__GBL_Rest_Services_Url__c();
         customSetting.Name = 'getDataServicesPyME';
         customSetting.iaso__Url__c = 'https://maxwebsealdesa.prev.bancomer.mx:6443/SRVS_A02/pymesCredit/';
         customSetting.iaso__Cache_Partition__c ='iaso.ServicesPartition';
         customSetting.iaso__Timeout__c = 20000;
         customSetting.iaso__cacheTTLInSecs__c = 300;
         customSetting.iaso__isCacheInOrg__c = true;
         insert customSetting;
         Account cliente = UtilitysDataTest_tst.crearCuenta('Cliente PyME','VP_tre_Cliente_PyME');
         cliente.No_de_cliente__c = '19560580';
         insert cliente;

         MX_PyME_Balance_Productos__c prod = new MX_PyME_Balance_Productos__c();
         prod.MX_PyME_Cliente__c = cliente.id;
         prod.MX_PyME_prodNumero_credito__c = '007458880501418141';
         insert prod;

         Test.startTest();
         MX_PyME_ServiceCards_Cls.getInfoFicha(cliente.id);
         MX_PyME_ServiceCards_Cls.getBalanceInfo('getBalanceDetailMock',cliente.id,prod.MX_PyME_prodNumero_credito__c);
         MX_PyME_ServiceCards_Cls.getServices(cliente.id);
         MX_PyME_Balance_Productos__c prTest = [Select MX_PyME_Descripcion_servicio__c,MX_PyME_Saldo_del_servicio__c From MX_PyME_Balance_Productos__c Where MX_PyME_Cliente__c =:cliente.id];
         Boolean prodCreatedByService=prTest == null ? false : true;
         System.assertEquals(true,prodCreatedByService,'Registro creado por servicio correctamente');
         Test.stopTest();
     }
}