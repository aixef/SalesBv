/**
*
* @author Arsenio Perez Lopez 
* @description API to auto assign leads from Smart Center to call center agents
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    24/06/2019     Arsenio Perez      Create Mock
* @version  1.0    27/08/2019     Arsenio Perez      code smell
*
*/
@isTest
global class MX_SB_VTS_Integration_MockGenerator implements HttpCalloutMock {
    // Variables 
    Static string txtpost='POST', txtSession = '**************sessionToken*************';
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        final HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        switch on req.getEndpoint() {
            when 'https://validation/ok' {
                System.assertEquals('https://validation/ok', req.getEndpoint());
                System.assertEquals(txtpost, req.getMethod());
                res.setHeader('access_token', txtSession);
                res.setHeader('tsec', txtSession);
                res.setBody('{}');
                res.setStatusCode(200);
            }
            when 'http://www.example.com/ws_salesforce_desarrollo/api/vida/Crear_Carga' {
                System.assertEquals('http://www.example.com/ws_salesforce_desarrollo/api/vida/Crear_Carga', req.getEndpoint()); 
                System.assertEquals(txtpost, req.getMethod());
                res.setBody('{"LOADID":9,"FECHA":"20190415"}');
                res.setStatusCode(200);
            }
            when 'https://bbvacifrado.smartcenterservicios.com/ws_salesforce_desarrollo/api/login/authenticate' {
                System.assertEquals('https://bbvacifrado.smartcenterservicios.com/ws_salesforce_desarrollo/api/login/authenticate', req.getEndpoint()); 
                System.assertEquals(txtpost, req.getMethod());
                res.setHeader('access_token', txtSession);
                res.setHeader('tsec', txtSession);
                res.setBody('{}');
                res.setStatus('ok');
                res.setStatusCode(200);
            }
            when 'http://www.example.com/ws_salesforce_desarrollo/api/vida/Ent_RegistroGestion' {
                System.assertEquals('http://www.example.com/ws_salesforce_desarrollo/api/vida/Ent_RegistroGestion', req.getEndpoint()); 
                System.assertEquals(txtpost, req.getMethod());
                res.setBody('{"CARGA":9,"FECHA":"20190415"}');
                res.setStatusCode(200);
            }
            when 'http://www.example.com/ws_salesforce_desarrollo/api/vida/Baja_Linea' {
                System.assertEquals('http://www.example.com/ws_salesforce_desarrollo/api/vida/Baja_Linea', req.getEndpoint()); 
                System.assertEquals(txtpost, req.getMethod());
                res.setBody('{"Baja_Linea":9,"FECHA":"20190415"}');
                res.setStatusCode(200);
            }
            when 'http://www.example.com/ws_salesforce_desarrollo/api/vida/ConsultaCarga' {
                System.assertEquals('http://www.example.com/ws_salesforce_desarrollo/api/vida/ConsultaCarga', req.getEndpoint()); 
                System.assertEquals('GET', req.getMethod());
                res.setBody('{"CONSULTA":9,"FECHA":"20190415"}');
                res.setStatusCode(200);
            }
            when 'http://www.example.com/ws_salesforce_desarrollo/api/vida/ConsultaCarga?SERVICEID=2' {
                System.assertEquals('http://www.example.com/ws_salesforce_desarrollo/api/vida/ConsultaCarga?SERVICEID=2', req.getEndpoint()); 
                System.assertEquals('GET', req.getMethod());
                res.setBody('{"CONSULTA":9,"FECHA":"20190415"}');
                res.setStatusCode(200);
            }
            when else {
                //nothing
                throw new DmlException('req.exeption getpoin'+req.getEndpoint());
            }
        }
        return res;
    }
}