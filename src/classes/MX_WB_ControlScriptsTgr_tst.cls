/**-------------------------------------------------------------------------
* Nombre: MX_WB_ControlScriptsTgr_tst
* Autor Alexis Pérez
* Proyecto: MW WB TLMKT - BBVA Bancomer
* Descripción : Clase de prueba para MX_WB_ControlScriptCls. 

* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Desripción<p />
* -------------------------------------------------------------------
* 1.0           06/12/2018      Alexis Pérez   			Creación
* --------------------------------------------------------------------------
*/

@IsTest
public class MX_WB_ControlScriptsTgr_tst {
    
    /*
     * Test method for the trigger created on the object Scripts_Stage_Product__c
     */
    @IsTest
    public static void test() {
        boolean error = false;
        try {
            final MX_WB_FamiliaProducto__c objFamProd = new MX_WB_FamiliaProducto__c();
            objFamProd.Name = 'ASD';
            insert objFamProd;
            
            final Product2 objProducto = new Product2();
            objProducto.Name = 'TestProductoMinion001';
            objProducto.IsActive = true;
            objProducto.MX_WB_FamiliaProductos__c = objFamProd.Id;
            insert objProducto;
            
            final Scripts_Stage_Product__c objScriptStageProduct = new Scripts_Stage_Product__c();
            objScriptStageProduct.MX_WB_Etapa__c = 'Contacto Efectivo';
            objScriptStageProduct.MX_WB_FamiliaProductos__c = objFamProd.Id;
            objScriptStageProduct.MX_WB_Script__c = 'TestScriptMinion001';
            insert objScriptStageProduct;
            
            final Scripts_Stage_Product__c objScriptStageProduct2 = new Scripts_Stage_Product__c();
            objScriptStageProduct2.MX_WB_Etapa__c = 'Contacto Efectivo';
            objScriptStageProduct2.MX_WB_FamiliaProductos__c = objFamProd.Id;
            objScriptStageProduct.MX_WB_Script__c = 'TestScriptMinion001Error';
            insert objScriptStageProduct2;
            
        } catch(DMLException ex) {
            error = true;
            System.assertEquals(error, ex.getMessage().contains(Label.MX_WB_lbl_MsgScriptException), 'Se esperaba error que contenga mensaje personalizado');
        }
    }
}