/**-------------------------------------------------------------------------
 * Nombre: MX_SB_SAC_LoginSiniSucc_Mock
 * Autor Ing. Eduardo Hernandez
 * Proyecto: MW WB LG - BBVA Bancomer
 * Descripción : Clase Mock de respuesta OK
 * --------------------------------------------------------------------------
 * Versión     Fecha      Autor          Descripción
 * -------------------------------------------------------------------
 * 1.0      24/12/2018    Ing. Eduardo Hernandez        Creación
 * 1.1      21/07/2019   Ing. Karen Belem Sanchez       Reducción de incidencias
 * --------------------------------------------------------------------------
 */
@isTest
public class MX_SB_SAC_LoginSiniSucc_Mock implements HttpCalloutMock {
    /**
     * respond Respuesta correcta del servicio
     * @param  invoca nueva respuesta HHTP
     * @return     return HttpResponse
     */
    public HttpResponse respond(HTTPRequest req) {
        final HttpResponse res = new HttpResponse();
        res.setBody('{"token":"11aafdc20ebf418e2bba978b45eafa9f","operacionResultado":"OK","operacionMensaje":[],"browserUrl":null,"operacionMensajeExtra":""}');
        res.setStatusCode(200);
        res.setStatus('OK');
        res.setHeader('Content-Type', 'application/json');
        return res;
    }
}