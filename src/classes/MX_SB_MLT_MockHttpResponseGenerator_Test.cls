/*
----------------------------------------------------------------------------------
* Nombre: MX_SB_MLT_MockHttpResponseGenerator_Test
* Autor Isaías Velázquez Cortés
* Proyecto: Siniestros - BBVA Bancomer
* Descripción : Mock de Servicio de Google API
* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                   		Descripción
* --------------------------------------------------------------------------------
* 1.0           10/05/2019     Isaías Velázquez Cortés		   	Creación
* 1.1           15/05/2019     Daniel Goncalves Vivas           Se agrega label para GoogleURL y se elimina código repetido
* --------------------------------------------------------------------------------
*/
@isTest
global class MX_SB_MLT_MockHttpResponseGenerator_Test implements HttpCalloutMock {
    /*
    * @description Construye Response de Mock
    * @param HTTPRequest req Request HTTP
    * @return HTTPResponse Response
    */
    global HTTPResponse respond(HTTPRequest req) {
        if(req.getEndpoint().contains('latlng')) {
            System.assertEquals(Label.MX_SB_MLT_GoogleMapsURL + 'latlng=19.3028657,-99.1527164&result_type=street_address&key='+Label.MX_SB_MLT_GoogleApiKey, req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
        } else {
            System.assertEquals(Label.MX_SB_MLT_GoogleMapsURL + 'address=Estadio+Azteca&result_type=geometry&key='+Label.MX_SB_MLT_GoogleApiKey, req.getEndpoint());
        }
        final HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('"plus_code" : { "compound_code" : "8R3W+4W Mexico City, CDMX, Mexico","global_code" : "76F28R3W+4W" },"results" : [],"status" : "ZERO_RESULTS"}');
        res.setStatusCode(200);
        return res;
    }
}