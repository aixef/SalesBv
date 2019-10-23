/**-------------------------------------------------------------------------
* Nombre: MX_WB_TelemarketingController
* Autor Alexis Pérez
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Clase de prueba de la clase MX_WB_TelemarketingController.

* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Desripción<p />
* -------------------------------------------------------------------
* 1.0           06/12/2018      Alexis Pérez		   	Creación
* 2.0           18/05/2019      Jaime Terrats           Se actualiza clase de prueba
* 2.1           24/06/2019      Eduardo Hernández       Fix clase prueba para proceso de producto
* --------------------------------------------------------------------------
*/
@IsTest
public class MX_WB_TelemarketingController_tst {

    /**
     * Return the relevant script based on the opportunity
     * @param String strIdOpportunity
     * @return String The required script.
     */
    @testSetup
    public static void insertData() {
		final String idRecordTypeOppOutbound = [SELECT id from RecordType where Name ='Outbound' AND SObjectType = 'Opportunity'].Id;

        final MX_WB_FamiliaProducto__c objFamProd = new MX_WB_FamiliaProducto__c();
        objFamProd.Name = 'ASD';
        insert objFamProd;

        final MX_SB_VTS_FamliaProveedores__c objFamProdProve = new MX_SB_VTS_FamliaProveedores__c();
        objFamProdProve.MX_SB_VTS_Familia_de_productos__c = objFamProd.Id;
        objFamProdProve.Name = 'ASDvcip';
        insert objFamProdProve;

        final Product2 objProducto = new Product2();
        objProducto.Name = 'TestProductoMinion001';
        objProducto.IsActive = true;
        objProducto.MX_WB_FamiliaProductos__c = objFamProd.Id;
        objProducto.MX_SB_SAC_Proceso__c = 'VTS';
        insert objProducto;

        final Scripts_Stage_Product__c objScriptStageProduct = new Scripts_Stage_Product__c();
        objScriptStageProduct.MX_WB_Etapa__c = 'Contacto Efectivo';
        objScriptStageProduct.MX_WB_FamiliaProductos__c = objFamProd.Id;
        objScriptStageProduct.MX_WB_Script__c = 'MinionTestScript001';
        insert objScriptStageProduct;


        final Date objDTHoy = Date.today();
        final Campaign objCampana = new Campaign();
        objCampana.Name = 'TestMinion001';
        objCampana.IsActive = true;
        objCampana.StartDate = objDThoy;
        objCampana.EndDate = objDTHoy.addDays(30);
        objCampana.MX_WB_FamiliaProductos__c = objFamProd.Id;
        objCampana.MX_SB_VTS_FamiliaProducto_Proveedor__c = objFamProdProve.Id;
        insert objCampana;

        final Opportunity objCotizacion = new Opportunity();
        objCotizacion.Name = 'TestCotizacionMinion001';
        objCotizacion.StageName = 'Contacto Efectivo';
        objCotizacion.CampaignId = objCampana.Id;
        objCotizacion.CloseDate = objDTHoy.addDays(30);
        objCotizacion.RecordTypeId = idRecordTypeOppOutbound;
        objCotizacion.MX_WB_Producto__c=objProducto.Id;
        objCotizacion.Producto__c= 'TestProductoMinion001';
        insert objCotizacion;

        final Product2 objProducto2 = new Product2();
        objProducto2.Name = System.Label.MX_SB_VTS_PRODUCTO_AUTO_DINAMICO_LBL;
        objProducto2.IsActive = true;
        objProducto2.MX_WB_FamiliaProductos__c = objFamProd.Id;
        insert objProducto2;
    }

    @IsTest
    /** 
    */
    public static void TestDatosCorrectos_Marketing() {
        Test.startTest();
        final Opportunity objCotizacion = [SELECT Id FROM Opportunity WHERE Name = 'TestCotizacionMinion001'];
        objCotizacion.RecordTypeId=[Select id from RecordType where DeveloperName ='MX_WB_RT_Telemarketing' AND SObjectType = 'Opportunity'].Id;
        update objCotizacion;
        final String strScript = MX_WB_TelemarketingController.getScript(objCotizacion.Id);
        System.assertEquals('MinionTestScript001', strScript, 'Valor esperado');
        Test.stopTest();
    }
    @IsTest
    /** 
    */
    public static void TestDatosCorrectos_asd() {
        Test.startTest();
        final Opportunity objCotizacion = [SELECT Id FROM Opportunity WHERE Name = 'TestCotizacionMinion001'];
        objCotizacion.RecordTypeId=[Select id from RecordType where DeveloperName ='ASD' AND SObjectType = 'Opportunity'].Id;
        update objCotizacion;

        final String strScript = MX_WB_TelemarketingController.getScript(objCotizacion.Id);
        System.assertEquals('MinionTestScript001', strScript, 'Valor esperado');
        Test.stopTest();
    }

    @IsTest
    /** 
    */
    public static void TestExcepcionOpp() {
        Test.startTest();
        try {
            MX_WB_TelemarketingController.getScript('FallId');
        } catch(AuraHandledException ex) {
            ex.setMessage('Script-thrown exception');
            System.assertEquals('Script-thrown exception', ex.getMessage(), 'Testeo de excepcion: Valor esperado');
        }
        Test.stopTest();
    }
}
