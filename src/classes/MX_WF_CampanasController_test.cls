/**
* ------------------------------------------------------------------------------
* @Nombre: MX_WF_CampanasController_test
* @Autor: Sandra Ventura García
* @Proyecto: Workflow Campañas
* @Descripción : Clase de prueba para MX_WF_CampanasController
* ------------------------------------------------------------------------------
* @Versión       Fecha           Autor                         Descripción
* ------------------------------------------------------------------------------
* 1.0           18/09/2019     Sandra Ventura García	         test
* ------------------------------------------------------------------------------
*/
@isTest
private class MX_WF_CampanasController_test {

  /**
  * @description: Datos prueba lista campañas
  * @author Sandra Ventura
  */ 
   public static List<Campaign> createCampaign(Integer num) {
        final List<Campaign> camp = new List<Campaign>();
       
       final Id rectypeCamp = Schema.SObjectType.campaign.getRecordTypeInfosByName().get('Alianzas Comerciales').getRecordTypeId();
       
       final Date vStartDate = Date.newInstance(2019, 1, 1);
       final Date vEndDate = Date.newInstance(2019, 5, 1);
       
       for(Integer i=0;i<num;i++) {
         final Campaign cmps = new Campaign(recordtypeid = rectypeCamp, 
                                      Name='Test camp'+ i,
                                      CRM_WF_Tipo_De_Area_Solicitante__c = 'Squad',
                                      StartDate = vStartDate.addDays(i),
                                      EndDate = vEndDate.addDays(i),
                                      MX_WF_Fecha_de_publicacion__c = vStartDate.addDays(i)+2,
                                      CRM_WF_Area_Solicitante__c='SQUAD_ADQUIRENCIA',
                                      CRM_WF_Con_Criterios__c = 'No', 
                                      Status='Ejecución'
                                      );
            
            
            camp.add(cmps);
            
        }
        insert camp;
       
        return camp;
    }
    
  /**
  * @description: Datos prueba lista comercios
  * @author Sandra Ventura
  */ 
    public static List<Account> createAccount(Integer num) {
       final List<Account> grupc = new List<Account>();
        final Id recTypeGC = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grupos Comerciales').getRecordTypeId();

        final Account grupoc = new Account(recordtypeid = recTypeGC, Name='Grupotest1');
        
        insert grupc;
        
        final List<Account> acc = new List<Account>();
        final Id recTypeAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Comercios').getRecordTypeId();

        for(Integer i=0;i<num;i++) {
            final Account acct = new Account(recordtypeid = recTypeAcc, 
                                    Name='TestAccount'+ i,
                                    GBL_WF_Grupo_Comercial__c= grupoc.id);
            
            acc.add(acct);
            
        }
        insert acc;
       
        return acc;
    }

    
  /**
  * @description: Datos prueba lista tarjetas
  * @author Sandra Ventura
  */   
    public static List<MX_WF_Catalogo_tarjetas__c> createTarjetas(Integer num) {
        final List<MX_WF_Catalogo_tarjetas__c> tar = new List<MX_WF_Catalogo_tarjetas__c>();

        for(Integer i=0;i<num;i++) {
            final MX_WF_Catalogo_tarjetas__c tarj = new MX_WF_Catalogo_tarjetas__c(Name='TestTarjeta'+ i);
            
            tar.add(tarj);
            
        }
        insert tar;
    
        return tar;
    }
    
  /**
  * @description: test constructor 
  * @author Sandra Ventura
  */   
   @isTest static void testConstructorListas() {
        String errorMessage = '';
        test.startTest();
        try {
	        final MX_WF_CampanasController listas = new MX_WF_CampanasController();
            system.debug(listas);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage,'No se encuentran registros');
    }  
    
  /**
  * @description: test lista campañas 
  * @author Sandra Ventura
  */
    @isTest static void campanasTest() {
      
        final Campaign[] camp = MX_WF_CampanasController_test.createCampaign(100);     
        test.startTest();
        MX_WF_CampanasController.getListCampanas( '2019-08-30', '2019-4-30');
         System.assert(camp.size() > 1,'Success');
        test.stopTest();
        }
  /**
  * @description: test lista tarjetas 
  * @author Sandra Ventura
  */
    @isTest static void tarjetasTest() {
        
           final MX_WF_Catalogo_tarjetas__c[] tar = MX_WF_CampanasController_test.createTarjetas(200);
           final String tDate = string.valueofGmt(Date.today());
               
        test.startTest();
        MX_WF_CampanasController.getListTarjetas(tDate);
         System.assert(tar.size() > 1,'Success');
        test.stopTest();
        } 
  /**
  * @description: test lista comercios 
  * @author Sandra Ventura
  */ 
    @isTest static void comerciosTest() {

           final Account[] acc = MX_WF_CampanasController_test.createAccount(200);
           final Id grupoc = [SELECT GBL_WF_Grupo_Comercial__r.Id FROM Account WHERE Name LIKE 'TestAccount%' LIMIT 1].Id;
        
        test.startTest();
        MX_WF_CampanasController.getListComercios(grupoc);
         System.assert(acc.size() > 1,'Success');
        test.stopTest();
        }       
  /**
  * @description: test exception lista campañas 
  * @author Sandra Ventura
  */ 
   @isTest
    static void testCamExep() {
        String errorMessage = '';
        test.startTest();
        try {
	        MX_WF_CampanasController.getListCampanas( 'invalid', '2019-09-20');
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('Script-thrown exception', errorMessage,'No se encuentran registros');
    }   
  /**
  * @description: test exception lista comercios 
  * @author Sandra Ventura
  */ 
   @isTest
    static void testComExep() {
        String errorMessage = '';
        test.startTest();
        try {
	        MX_WF_CampanasController.getListComercios( 'invalidId');
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('Script-thrown exception', errorMessage,'El id es inválido');
    }
  /**
  * @description: test exception lista tarjetas 
  * @author Sandra Ventura
  */ 
   @isTest
    static void testTarExep() {
        String errorMessage = '';
        test.startTest();
        try {
	        MX_WF_CampanasController.getListTarjetas('invalidf');
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('Script-thrown exception', errorMessage,'Parámetro incorrecto');
    }     
}