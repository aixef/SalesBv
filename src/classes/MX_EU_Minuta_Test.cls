/********************************************************************************
*	@Desarrollado por:		Estrategia Tecnológica  							*
*	@Autor:					Angel Fuertes Gómez             					*
*	@Proyecto:				Bancomer											*
*	@Descripción:			Clase test para el controlador Minuta_KitVisita_Ctrl*
*																				*
*	Cambios (Versiones)															*
*	--------------------------------------------------------------------------	*
*	No.		Fecha				Autor					Descripción				*
*	------  ----------  ----------------------  -----------------------------	*
*	1.0		29/05/2018	Angel Fuertes Gomez     Creación de clase Test 	        *
*   2.0     01/10/2018  Angel Fuertes Gomez     Nuevo método test para          *
*                                               validar el método getMes        *
*   2.1     29/01/2019  Ruben Quinto            Se sube cobertura de test       *
*   2.2     29/01/2019  Ruben Quinto            Se crea objeto de tipo 		    *
												document 				        *
*	2.3		12/04/2019	Iván Cabrer				Se valida envío a director      *
												de Sector				        *
*   3		30/08/2019	Cindy Hernández			Se eliminanr referencias a      *
                                                VariablesGlobales__c. Se        *
                                                cambia referencia de RT MX_BIE  *
                                                cambia referencia de RT MX_BIE  *
                                                por MX_BPP. Se modifica método  *
                                                validaEnvio para resolver error.*
*   3.1     05/09/2019  Cindy Hernández         Se realizan modificaciones para *
                                                resolver code smells detectados *
                                                por sonar.                      *
*********************************************************************************/
@isTest
public class MX_EU_Minuta_Test {

    @testSetup
    static void setup() {
        final gcal__GBL_Google_Calendar_Sync_Environment__c calEnviro = new gcal__GBL_Google_Calendar_Sync_Environment__c(Name = 'DEV');
        insert calEnviro;
        //Inserta Account
        final Account newAccount = new Account();
        newAccount.Name = '7ELEVEN SA DE CV';
        newAccount.No_de_cliente__c = '156102';
        newAccount.Industry = 'TEST';
        insert newAccount;

        //Inserta Contact
        final List<String> contactData = new List<String>{'Abraham', 'Gonzalez Perez', 'Decisor', 'CONTACTO EJECUTIVO', newAccount.Id};
        final Contact contact1 = EU_cls_TestData.generaContactoB(contactData);
        insert contact1;

        //Crea un usuario para asociarlo a la visita
        final User testUser = EU_cls_TestData.insertUser();

        //Obtiene recordType
        final RecordType[] ltsRecordType=[SELECT id,name FROM RecordType where SobjectType='dwp_kitv__Visit__c' ORDER BY Name ASC];

        //Crea un registro del tipo visita ASC
        final dwp_kitv__Visit__c visit = EU_cls_TestData.insertASCVisit(newAccount.Id, ltsRecordType[0].id);

        //Crea un registro del tipo visita BIE
        final dwp_kitv__Visit__c visitBIE = EU_cls_TestData.insertBIEVisit(newAccount.Id);

        //Inserta los objetos Team relacionados a la visita
        EU_cls_TestData.insertTeam(visit.Id, testUser.Id);

        //Inserta Custom Setting
        EU_cls_TestData.insertCtmSetting(ltsRecordType[0].Name);

        final List<ContentVersion> ltsD = new List<ContentVersion>();
        final ContentVersion contentVersion = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.txt',
          VersionData = Blob.valueOf('Test Content'),
          FirstPublishLocationId=visit.Id
        );
        insert contentVersion;
        ltsD.add(contentVersion);

        final ContentVersion contentVersionBIE = new ContentVersion(
          Title = 'PenguinsBIE',
          PathOnClient = 'PenguinsBIE.txt',
          VersionData = Blob.valueOf('Test ContentBIE'),
          FirstPublishLocationId=visitBIE.Id
        );
        insert contentVersionBIE;
        ltsD.add(contentVersionBIE);

        Document documentObj;
        documentObj = new Document();
        documentObj.Body = Blob.valueOf('Some Document Text');
        documentObj.ContentType = 'application/pdf';
        documentObj.DeveloperName = 'PenguinsDoc';
        documentObj.IsPublic = true;
        documentObj.Name = 'PenguinsDoc';
        documentObj.FolderId = UserInfo.getUserId();
        insert documentObj;
    }

    /*
    * @Descripción Método Test para el controlador Minuta_KitVisita_Ctrl
    * @return No retorna nada
    */
	@isTest
    static void validaEnvio() {
        Test.startTest();
        final MX_EU_Minuta_Ctrl  testMinutaCtrl1 = validaEnvioVisitas('Visita Prueba');
        System.assert(testMinutaCtrl1.correoEnviado, 'Envío de correo:');
        Test.stopTest();
    }

    static MX_EU_Minuta_Ctrl validaEnvioVisitas(String visitName) {
        final dwp_kitv__Visit__c objFinal=[select id,RecordType.name from dwp_kitv__Visit__c where name=:visitName];
        final List<ContentVersion> ltsD = [SELECT Id FROM ContentVersion where FirstPublishLocationId=:objFinal.Id];
        final String sltsD = '[{"Id":"'+ltsD[0].Id+'","Title":"Penguins","IsAssetEnabled":true}]';
        final String smyCS1 = '{"LastModifiedDate":"2018-06-27T20:47:16.000Z","IsDeleted":false,"dwp_kitv__Attach_file__c":true,"dwp_kitv__Visualforce_Name__c":"minuta","SetupOwnerId":"00D7E000000DWnZUAW","dwp_kitv__Disable_send_field_in_BBVA_team__c":false,"Name":"'+objFinal.RecordType.Name+'","SystemModstamp":"2018-06-27T20:47:16.000Z","dwp_kitv__Minimum_members_BBVA_team__c":0,"CreatedById":"0057E000004vXF5QAM","dwp_kitv__Subject__c":"BBVA Minuta","CreatedDate":"2018-06-26T23:22:44.000Z","Id":"a057E000004y5JiQAI","LastModifiedById":"0057E000004vXF5QAM","dwp_kitv__Disable_send_field_in_contacts__c":false,"dwp_kitv__Minimum_Number_of_Agreement__c":1}';
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(objFinal.Id));
        ApexPages.currentPage().getParameters().put('myCS', smyCS1);
        ApexPages.currentPage().getParameters().put('documents', sltsD);
        final MX_EU_Minuta_Ctrl  testMinutaCtrl = new MX_EU_Minuta_Ctrl();
        testMinutaCtrl.sendMail();
        return testMinutaCtrl;
    }

    static testMethod void validaEnvioSinPermisos() {
        final dwp_kitv__Visit__c objFinal = [SELECT id,RecordType.name FROM dwp_kitv__Visit__c WHERE name='Visita Prueba'];
        final List<ContentVersion> ltsD = [SELECT Id FROM ContentVersion WHERE FirstPublishLocationId=:objFinal.Id];
        final String sltsDV = '[{"Id":"'+ltsD[0].Id+'","Title":"Penguins","IsAssetEnabled":true}]';
        final String smyCS2 = '{"LastModifiedDate":"2018-06-27T20:47:16.000Z","IsDeleted":false,"dwp_kitv__Attach_file__c":true,"dwp_kitv__Visualforce_Name__c":"minuta","SetupOwnerId":"00D7E000000DWnZUAW","dwp_kitv__Disable_send_field_in_BBVA_team__c":false,"Name":"'+objFinal.RecordType.Name+'","SystemModstamp":"2018-06-27T20:47:16.000Z","dwp_kitv__Minimum_members_BBVA_team__c":0,"CreatedById":"0057E000004vXF5QAM","dwp_kitv__Subject__c":"BBVA Minuta","CreatedDate":"2018-06-26T23:22:44.000Z","Id":"a057E000004y5JiQAI","LastModifiedById":"0057E000004vXF5QAM","dwp_kitv__Disable_send_field_in_contacts__c":false,"dwp_kitv__Minimum_Number_of_Agreement__c":1}';
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(objFinal.Id));
        ApexPages.currentPage().getParameters().put('myCS', smyCS2);
        ApexPages.currentPage().getParameters().put('documents', sltsDV);
        final MX_EU_Minuta_Ctrl  testMinutaCtrl = new MX_EU_Minuta_Ctrl();
        testMinutaCtrl.vfError = true;
        testMinutaCtrl.sendMail();
        System.assert(!testMinutaCtrl.correoEnviado, 'Envío de correo:');
        Test.StopTest();
    }

    /*
    * @Descripción Método Test para validar el método getMes
    * @return No retorna nada
    */
    static testMethod void getMesTest() {
        String resp = '';
        final dwp_kitv__Visit__c objVs = [SELECT id FROM dwp_kitv__Visit__c WHERE name='Visita Prueba'];
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(objVs.Id));
        final MX_EU_Minuta_Ctrl  testMin = new MX_EU_Minuta_Ctrl();
        for(integer i =1 ; i <= 13 ; i++) {
            resp = testMin.getMes(i<10?'0'+i:String.valueOf(i));
        }
        resp = testMin.getMes('01');
        System.assertEquals('Enero', resp, 'Mes actual correcto.');
        Test.StopTest();
    }
}