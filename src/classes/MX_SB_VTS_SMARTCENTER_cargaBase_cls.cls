/**-------------------------------------------------------------------------
* Nombre: MX_SB_VTS_SMARTCENTER_cargaBase_cls
* @author Arsenio Perez Lopez (xemo)
* Proyecto: MW SB VTS - BBVA
* Descripción : Clase de ayuda para el componente de envio de leads

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           03/06/2019      Arsenio  Perez            Creación
* --------------------------------------------------------------------------*/
global class MX_SB_VTS_SMARTCENTER_cargaBase_cls implements iaso.GBL_Integration_Headers {
    /** */
    global HttpRequest modifyRequest(HttpRequest request) {
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Host', 'bbvacifrado.smartcenterservicios.com');
        request.setHeader('Connection', 'Keep-Alive');
        request.setHeader('User-Agent', 'Apache-HttpClient/4.1.1 (java 1.5)');
        request.setHeader('content-length', '56');
        request.setHeader('Cache-Control', 'no-cache');
        request.setHeader('Accept', '*/*');

        System.debug('Endpoint:'+request.getEndpoint());
        if(request.getEndpoint().contains('Crear_Carga')){
          String body='{"SERVICEID": '+request.getHeader('SERVICEID')+',"DESCRIPCION":"'+request.getHeader('DESCRIPCION')+'"}';
          system.debug(body);
          request.setBody(body);
          request.setHeader('SERVICEID', '');
          request.setHeader('DESCRIPCION', '');
        } else if( request.getEndpoint().contains('Ent_RegistroGestion')||request.getEndpoint().contains('Baja_Linea')) {
          String bodyRequest = request.getBody();
          system.debug(request.getBody());
          bodyRequest=bodyRequest.removeStart('{ "ListLeads":[');
          bodyRequest=bodyRequest.removeEnd(']}');
          request.setBody(bodyRequest);
          system.debug(request.getBody());
        }
      return request;
    }
}