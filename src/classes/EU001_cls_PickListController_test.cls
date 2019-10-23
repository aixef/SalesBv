/**
*Cambios (Versiones)
*************************************************************************************************************************
*No.    |     Fecha      |         Autor            |                  			Descripción
*************************************************************************************************************************
*1.1    |   17-06-2019   |    Cindy Hernández       | Se agregan métodos TestPickListException y TestPickListConstructor.
**/
@isTest
public class EU001_cls_PickListController_test {

    @isTest
   	static void TestPickList() {
        test.startTest();
		final List<String> TestList = EU001_cls_PickListController.getPickListValuesIntoList('EU_001_Compromiso__c','EU_001_ls_Estatus__c','');
        System.assert(TestList.contains('Abierto'));
        System.assert(true,'This Works!');
        test.stopTest();
    }

    @isTest
    static void TestPickListException() {
        String errorMessage = '';
        test.startTest();
        try {
            EU001_cls_PickListController.getPickListValuesIntoList('NoValidObject__c','EU_001_ls_Estatus__c','');
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('Script-thrown exception', errorMessage);
    }

    @isTest
    static void TestPickListConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        final EU001_cls_PickListController picklist = new EU001_cls_PickListController();
            System.assert(picklist != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }
}