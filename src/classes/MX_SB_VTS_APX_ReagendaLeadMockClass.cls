/**
* BBVA - Mexico
* @Author: Julio Medellin
* @Version 1.0
* version 1.0   Creacionn de la Clase
* version 1.1 se remueven code smells
*/
@isTest
global class MX_SB_VTS_APX_ReagendaLeadMockClass implements HttpCalloutMock { // NOSONAR
    /* Implement this interface method */
    static string txtpost='POST', txtSession = '**************sessionToken*************';
    /*
    * Performs fake callout
    */
    global HTTPResponse respond(HTTPRequest req) {

        final HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('access_token', txtSession);
                res.setHeader('tsec', txtSession);
                res.setBody('{}');
                res.setStatusCode(200);
        return res;
    }
}
