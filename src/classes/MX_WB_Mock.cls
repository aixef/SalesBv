/**-------------------------------------------------------------------------
* Nombre: MX_WB_Mock
* @author Karen Sanchez (KB)
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Clase que sirve para simular los llamados al WS de CTI

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           14/01/2019      Karen Sanchez            Creación
* --------------------------------------------------------------------------*/
@isTest
public class MX_WB_Mock implements HttpCalloutMock {
    /** 
    *
    */
    protected Integer code;
    /** 
    *
    */
    protected String status;
    /** 
    *
    */
    protected String body;
    /** 
    *
    */
    protected Map<String, String> responseHeaders;
/** 
*Method
*/
    public MX_WB_Mock(Integer code, String status, String body, Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseHeaders = responseHeaders;
    }
/** 
*Method 
*/
    public HTTPResponse respond(HTTPRequest req) {

        final HttpResponse res = new HttpResponse();
        for (String key : this.responseHeaders.keySet()) {
            res.setHeader(key, this.responseHeaders.get(key));
        }
        res.setBody(this.body);
        res.setStatusCode(this.code);
        res.setStatus(this.status);
        return res;
    }

}