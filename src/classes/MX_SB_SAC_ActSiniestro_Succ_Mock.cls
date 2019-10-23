/**
 Nombre: MX_SB_SAC_ActSiniestro_Succ_Mock
 @author   Karen Sanchez (KB)
 Proyecto: MX_SB_SAC - BBVA Bancomer   
 Descripción : Mock

            No.    Fecha            Autor             Description
                                                     
 @version  1.0   2019-07-21      Karen Belem (KB)      Creación
*/
@isTest
public class MX_SB_SAC_ActSiniestro_Succ_Mock implements HttpCalloutMock {
    /**
    Función: Response de WS 
    2019-07-21
    Karen Belem Sanchez Ruiz
    */
     public HttpResponse respond(HTTPRequest req) {
        final HttpResponse res = new HttpResponse();
        res.setBody('{"operacionMensaje": ["Mensaje", "Mensaje2", "Mensaje2"],"browseUrl": null,"operacionResultado": "OK","operacionMensajeExtra": "","siniestrosPoliza":{"informacionSiniestros":[{"tipo": "COLISION","folio": "B64790873","estatus":"Activo","culpabilidad": "ASEGURADO","fecha":[2016,1,19],"coberturas":[{"nombre": "GASTOS MEDICOS TERCEROS","clave": "H","estatus":"CERRADA","saldo":"0.00"},{"nombre":"RESPONSABILIDAD CIVIL VEHICULOS","clave":"C1","estatus":"ABIERTA","saldo":"1.00"},{"nombre":"DAÑOS MATERIALES","clave":"A","estatus":"CERRADA","saldo":"0.00"}]}]}}');
        res.setStatusCode(400);
        res.setStatus('ERROR');
        res.setHeader('Content-Type', 'application/json');
        return res;
    }
}