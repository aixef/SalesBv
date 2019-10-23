/**-------------------------------------------------------------------------
* Name: Utility Quote Class
* @author Jaime Terrats
* Proyect: MW SB VTS - BBVA
* Description : Utility class for the Quotes
* --------------------------------------------------------------------------
*                         Date           Author                   Description
* -------------------------------------------------------------------
* @version 1.0           May/22/2019      Jaime Terrats            Header
*/
public without sharing class MX_SB_VTS_JSONParser {
    private MX_SB_VTS_JSONParser() {} // NOSONAR
    /*
     * datosCotizacion Datos de la cotización
     * @param	response	Obtiene un response
     * @return	jsonBody	Regresa un json
    */
    public static MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion datosCotizacion(String response) {
        MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion jsonBody = new MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion();
        try {
            final JSONParser parser = JSON.createParser(response);
            // validate if parser is not null
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    jsonBody = (MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion)parser.readValueAs(MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion.class);
                }
            }
        } catch(JSONException ex) {
            jsonBody = new MX_SB_VTS_HogarWrapper.MX_SB_VTS_DatosCotizacion();
        }
        return jsonBody;
    }
}