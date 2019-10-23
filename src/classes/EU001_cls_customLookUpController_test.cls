/**
*Desarrollado por:       Luis Fernando R.
*Autor:                  Luis Fernando R.
*Proyecto:               Experiencia Unica
*Descripción:            Clase Test para LookUp Personalizado (Reutilizable)*Cambios (Versiones)
*******************************************************************************************************************************************
*No.    |     Fecha      |     Autor                |          					Descripción
*******************************************************************************************************************************************
*1.0    | 27-08-2018     |    Luis Fernando R       | Se modifica creación de registros a clase de utilería
*1.0    | 17-06-2019     |    Cindy Hernández       | Se modifica el tipo de registro para la creación de cuantas en el método customLookUp
                                                     y se agregan System.assert correctos.Se agrega el método customLookUpConstructor.
**/
@isTest
public class EU001_cls_customLookUpController_test {

    @isTest
    static void customLookUp() {
        final list<Account> lsToInsert = new list<Account>();
		lsToInsert.add(MX_BPP_AccAndOppDataFactory.crearCuenta('Juan', 'BPyP_tre_Cliente'));
		insert lsToInsert;
		Test.startTest();
        final list<Id> lsIds = new list<Id>();
		for(Account tmp : lsToInsert) {
		 	lsIds.add(tmp.Id);
		}
		Test.setFixedSearchResults(lsIds);
		final List <sObject> myObj = EU001_cls_customLookUpController.fetchLookUpValues('Juan', 'Account', null);
        System.assert(!myObj.isEmpty());
        Test.stopTest();
    }

    @isTest
    static void customLookUpConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        final EU001_cls_customLookUpController customLookup = new EU001_cls_customLookUpController();
            System.assert(customLookup != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }

}