/**
* ------------------------------------------------------------------------------
* @Nombre: MX_WF_Reporte_Wallet_test
* @Autor: Sandra Ventura García
* @Proyecto: Workflow Campañas
* @Descripción : Test para clase MX_WF_Reporte_Wallet.
* ------------------------------------------------------------------------------
* @Versión       Fecha           Autor                         Descripción
* ------------------------------------------------------------------------------
* 1.0           18/09/2019     Sandra Ventura García	         test
* ------------------------------------------------------------------------------
*/
@isTest
private class MX_WF_Reporte_Wallet_test {
    
  /**
  * @description: Datos prueba.
  * @author Sandra Ventura
  */ 
   public static List<MX_WF_Wallet__c> createWllts(Integer num) {
        final List<MX_WF_Wallet__c> wll = new List<MX_WF_Wallet__c>();
          String vAfiliaciones ='278732';
        for(Integer i=0;i<num;i++) {
            final MX_WF_Wallet__c wAfil = new MX_WF_Wallet__c(MX_WF_Estado__c='Aprobado',
                                                    MX_WF_Afiliaciones__c= vAfiliaciones, 
                                                    MX_WF_Fecha_fin__c= date.today(),
                                                    MX_WF_Nombre_de_promocion__c='Testpromo' + i, 
                                                    MX_WF_Promocion_Corta__c = 'Test' + i);
            
            
            wll.add(wAfil);
            vAfiliaciones = vAfiliaciones + i + '200,';
        }
        insert wll;
       
        return wll;
       
    }
    
  /**
  * @description: test reporte promociones.
  * @author Sandra Ventura
  */ 
    @isTest static void testreporteP() {
        
        MX_WF_Reporte_Wallet_test.createWllts(50);
        final Blob resultProm=  MX_WF_Reporte_Wallet.rptPromocion();
        System.assert(resultProm.size()<>0,'El reporte no fue generado');        
        
        }
  /**
  * @description: test reporte afiliaciones.
  * @author Sandra Ventura
  */ 
    @isTest static void testreporteA() {
        
        MX_WF_Reporte_Wallet_test.createWllts(50);
        
        final Blob resultAfil = MX_WF_Reporte_Wallet.rptAfiliacion();
        System.assert(resultAfil.size()<>0,'El reporte no fue generado');       
        }    
  /**
  * @description: test scheduler envio reportes.
  * @author Sandra Ventura
  */ 
    @isTest public static void  testschedule() {
        
        Test.StartTest();
        final MX_WF_Reporte_Wallet sh1 = new MX_WF_Reporte_Wallet();      
               final String jobId = system.schedule('Test', '0 0 9 * * ?', sh1);
               final CronTrigger crtri = [SELECT Id, CronExpression, TimesTriggered,NextFireTime
                                          FROM CronTrigger WHERE id = :jobId];
                System.assertEquals(0, crtri.TimesTriggered, 'Proceso exitoso');
        Test.stopTest();
        }


}