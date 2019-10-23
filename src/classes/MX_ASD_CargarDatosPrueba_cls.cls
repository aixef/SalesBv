/**
 * ASD_CargarDatosPrueba_cls
 * Author   Edmundo Zacarias   edmundo.zacarias.contracto@bbva.com
 * Date     Created: 2019-02-05
 * Group    Utility Class Test
 * Description Esta clase global es para cargar datos de los que dependen varias clases test.
* Contiene métodos para generar registros sobre Custom Settings y Objetos Custom.
 */
@isTest
public class MX_ASD_CargarDatosPrueba_cls {

    /**
    * Metodo de utilería pra crear usuario
    *
    * @param
    * @return
    */
    @isTest
    public static User crearDatosUsuario() {
        final String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        final Profile prfProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        final User usrUser = new User(Alias = 'adminu', Email='standarduser@testorg.com',
                                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es_MX',
                                      LocaleSidKey='es_MX', ProfileId = prfProfile.Id,
                                      TimeZoneSidKey='America/Mexico_City',
                                      UserName=uniqueUserName,Turno__c='Matutino',Usuario__c='ASD000100',Canal__c='1',Sub_Canal__c='2',Agencia__c='VCIP',Servicio__c='VCIP%20SOLUCIONES,%20S.A.%20DE%20C.V.');
        System.assertEquals(usrUser.Alias,'adminu','El alias del usuario es adminu');
        return usrUser;
    }

    /**
    * Metodo de utilería para registro de custom setting
    *
    * @param
    * @return
    */
    public static void crearConstantesASD() {
        final Constantes_ASD__c constantesASD = new Constantes_ASD__c();
        constantesASD.Auto_Seguro_Dinamico__c = 'Auto Seguro Dinamico';
        constantesASD.Seguro_Fronterizo__c = 'Seguro Fronterizo';
        constantesASD.Seguro_Moto_Bancomer__c = 'Seguro de Moto Bancomer';
        System.debug('=====' + constantesASD);
        insert constantesASD;
    }

    /**
    * Metodo que crea la url para el cotizador
    *
    * @param  developername, url, masterlabel
    * @return         url auto seguro dinamico
    */
    public static URL_Auto_Seguro_Bancomer__mdt crearURLAutoSeguroBancomerMdt(String developerName, String url, String masterLabel, String tipoDeUso) {
        final URL_Auto_Seguro_Bancomer__mdt urlAutSegBancMdt = new URL_Auto_Seguro_Bancomer__mdt();
        urlAutSegBancMdt.DeveloperName = developerName;
        urlAutSegBancMdt.URL__c = url;
        urlAutSegBancMdt.MasterLabel = masterLabel;
        urlAutSegBancMdt.tipoUsoVehiculoCot__c = tipoDeUso;
        return urlAutSegBancMdt;
    }

}