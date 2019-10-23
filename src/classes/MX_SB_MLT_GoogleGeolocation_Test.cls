/*
----------------------------------------------------------------------------------
* Nombre: MX_SB_MLT_GoogleGeolocation_Test
* Isaías Velázquez Cortés
* Proyecto: Siniestros - BBVA Bancomer
* Descripción : Pruebas de MX_SB_MLT_GoogleGeolocation_Cls

* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                           Descripción
* --------------------------------------------------------------------------------
* 1.0           02/05/2019     Isaías Velázquez Cortés          Creación
* 1.1           14/05/2019     Daniel Goncalves Vivas           Cambios de Asserts con mensajes
* 1.2           25/09/2019     Juan Carlos Benitez Herrera      Cambios de catch NullPointerException a catch Exception
* 1.3           30/09/2019     Daniel Goncalves Vivas           Se eliminan variables de valores esperados
* --------------------------------------------------------------------------------
*/

@isTest
global class MX_SB_MLT_GoogleGeolocation_Test {
    /* Valor actual para pruebas */
    static String actualValuee; 

    @isTest static void testCalloutAddress() {
        Test.setMock(HttpCalloutMock.class, new MX_SB_MLT_MockHttpResponseGenerator_Test());
        final HttpResponse res = MX_SB_MLT_GoogleGeolocation_Cls.getReverseGeocode('19.3028657','-99.1527164');
        System.assertEquals('"plus_code" : { "compound_code" : "8R3W+4W Mexico City, CDMX, Mexico","global_code" : "76F28R3W+4W" },"results" : [],"status" : "ZERO_RESULTS"}', res.getBody(), 'Prueba Callout Address');
    }

    @isTest static void testCalloutMethodLocation() {
        Test.setMock(HttpCalloutMock.class, new MX_SB_MLT_MockHttpResponseGenerator_Test());
        final HttpResponse res = MX_SB_MLT_GoogleGeolocation_Cls.getLocationGeocode('Estadio+Azteca');
        System.assertEquals('"plus_code" : { "compound_code" : "8R3W+4W Mexico City, CDMX, Mexico","global_code" : "76F28R3W+4W" },"results" : [],"status" : "ZERO_RESULTS"}', res.getBody(), 'Prueba Callout Location');
    }

    @isTest static void testCalloutMethodAuraOk() {
        System.assertEquals('37.4224764,-122.0842499', MX_SB_MLT_GoogleGeolocation_Cls.getLocationGeocodeString('isATest'), 'Prueba Callout Aura OK');
    }
    
    @isTest static void testCalloutMethodAuraNull() {
               
        try {
            actualValuee = MX_SB_MLT_GoogleGeolocation_Cls.getLocationGeocodeString(null);
        } catch (Exception  e) {
            System.assert( String.isBlank( actualValuee ), 'Prueba Callout Aura Null' );
        }           
    }
}