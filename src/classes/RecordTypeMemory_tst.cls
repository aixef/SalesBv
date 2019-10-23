/*----------------------------------Desarrollado por INDRA---------------------------------
*Autor:         Sergio Andres Ortiz
*Proyecto:      Salud ORG
*Descripción:   Clase de prueba para RecordTypeMemory_cls, la cual
				recupera todos los tipos de registro y los almacena en memoria
*_______________________________________________________________________________________
*Versión    Fecha           Autor                   Descripción
*1.0        16/MAR/2018     Sergio Andres Ortiz     Creación de la clase.
*1.1        03/ABR/2018     Sergio Andres Ortiz     Se prueba el cambio en el metodo getAllSObjectRecType
                                                    para retornar un Set de Ids
*1.2        11/JUL/2018     Pedro Alan Hdz Sierra	Se agrega Método 3 para cubrir: RecordTypeMemory_cls.getAllSObjectRecTypeByMapApiName().
*1.3        18/JUN/2019     Cindy Hernández Nieto	Se modifica el método  Método test_RecordTypeMemory2 para incluir el try catch.
													Se agrega el método recordMemoryConstructor.
-----------------------------------------------------------------------------------------*/
@isTest
private class RecordTypeMemory_tst {

    @isTest static void test_RecordTypeMemory2() {
		String errorMessage = '';
        test.startTest();
        try {
			Id idRecordTypeCuenta = RecordTypeMemory_cls.getRecType('Account', 'Cliente_Gobierno');
            System.assertEquals(null, idRecordTypeCuenta);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
	}

    @isTest
    static void recordMemoryConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        RecordTypeMemory_cls recMemory = new RecordTypeMemory_cls();
            System.assert(recMemory != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }
}