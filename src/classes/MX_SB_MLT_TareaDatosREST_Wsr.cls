/*
----------------------------------------------------------
* Nombre: MX_SB_MLT_TareaDatosREST_Wsr
* Autor Oscar Martínez / Saúl Gonzáles
* Proyecto: Siniestros - BBVA Bancomer
* Descripción : Expone y consume servicios REST para la comunicación con Claim Center y clipert.

* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                   			    Descripción
* --------------------------------------------------------------------------------
* 1.0           12/04/2019     Oscar Martínez / Saúl Gonzáles		   	Creación
* 1.1           29/04/2019     Oscar Martínez / Saúl Gonzáles		   	Adecuación de encapsulamineto del objeto Response
* 1.2           16/05/2019     Saúl González                            Actualización de variables
* 1.3           18/07/2019     Saúl González                            Actualización de campos
* 1.4           30/09/2019     Daniel Goncalves                         Catch en misma línea y clase pública
* --------------------------------------------------------------------------------
*/

@RestResource(urlMapping='/MX_SB_TareaDatosREST/*')
global class MX_SB_MLT_TareaDatosREST_Wsr {
    
    private MX_SB_MLT_TareaDatosREST_Wsr () {}
    
    /*
    * @description expone servicio para obtener el objeto json de la tarea de datos que envía Claim Center
    * @param String paramJson
	* @return  String response
    */
    @HttpPost
    global static MX_SB_MLT_TareaDatosREST_Wsr.Response guardaTareaDatos() {
       	final MX_SB_MLT_TareaDatosREST_Wsr.Response respuesta = new MX_SB_MLT_TareaDatosREST_Wsr.Response();
    	try {
			final RestRequest req = RestContext.request;
            final Blob body = req.requestBody;
            final String requestString = body.toString();
			final MX_SB_MLT_TareaDatosBussines_Cls tareaBussines = new MX_SB_MLT_TareaDatosBussines_Cls();
			Map<String,String> mapResponse =  new  Map<String,String>();
			mapResponse = tareaBussines.creaObjetoTareaDatos (requestString);	    	
	    	respuesta.respuesta = mapResponse.get('respuesta');
	    	respuesta.error =  mapResponse.get('error');
	    	respuesta.idSalesforce =  mapResponse.get('idSalesforce');
    	} catch (JSONException je) { respuesta.error = Label.MX_SB_MLT_ErrorTDT+' Problema con el objeto JSON.'; } catch (CalloutException ce) {
            respuesta.error = Label.MX_SB_MLT_ErrorTDT + ' Problemas en la comunicación del servicio.';
        }       
    	return respuesta;
    }

    /*
    * @description clase para respuesta
    */
    global class Response {
        /*Descripción de la respuesta de la insersión*/
    	private string respuesta;
        /*Descripción en caso de cachar algún error*/
    	private string error;
        /*Id de caso creado al momento de insertar*/
    	private string idSalesforce;
    }
}