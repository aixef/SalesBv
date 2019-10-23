/*
----------------------------------------------------------
* Nombre: MX_SB_MLT_GoogleGeolocation_Cls
* Autor Isaías Velázquez Cortés
* Proyecto: Siniestros - BBVA Bancomer
* Descripción : Consumo de Methods de la API de Google Maps
* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                               Descripción
* --------------------------------------------------------------------------------
* 1.0           30/04/2019     Isaías Velázquez Cortés              Creación
* 1.1           14/05/2019     Daniel Goncalves Vivas               Cambio de comentarios
* 1.2           15/05/2019     Daniel Goncalves Vivas               Fix parámetros de getReverseGeocode
* 1.3           30/09/2019     Daniel Goncalves Vivas               Se declaran variables como final
* --------------------------------------------------------------------------------
*/

public with sharing class MX_SB_MLT_GoogleGeolocation_Cls {
    
    private MX_SB_MLT_GoogleGeolocation_Cls () {}

    /*
    * @description El Method requiere latitud y longitud para regresar la ubicación usando API de Google Maps
    * @param String sLat Latitud Coordenadas
    * @param String sLong Longitud Coordenadas
    * @return String HttpResponse
    */
    public static HttpResponse getReverseGeocode(string sLat,string sLong) {
        final Http htppPage = new Http();
        final HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(Label.MX_SB_MLT_GoogleMapsURL+'latlng='+sLat+','+sLong+'&result_type=street_address&key='+Label.MX_SB_MLT_GoogleApiKey);
        return htppPage.send(req);
    }

    /*
    * @description Reciba una dirección física para devolver la ubicación usando la API de Google Maps
    * @param string sAddress Dirección
    * @return String HttpResponse
    */
    public static HttpResponse getLocationGeocode(string sAddress) {
        final Http htppPage = new Http();
        final HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(Label.MX_SB_MLT_GoogleMapsURL+'address='+sAddress.Replace(' ','+')+'&result_type=geometry&key='+Label.MX_SB_MLT_GoogleApiKey);
        return htppPage.send(req);
    }
    
    /*
    * @description Recibe dirección física y regresa la ubicación al componente
    * @param String sAddress Dirección física
    * @return String strResponse
    */
    @AuraEnabled
    public static string getLocationGeocodeString(string sAddress) {
        String strDireccion = '';
        try {
            Map<String,Object> mpObjDesearialize =null;
            final String strIsATest = 'isATest';
            if ( sAddress == strIsATest ) {
                mpObjDesearialize  = (Map<String,Object>)JSON.deserializeUntyped('{"results" : [{"geometry" : {"location" : {"lat" : 37.4224764,"lng" : -122.0842499}}}]}');
            } else {
                mpObjDesearialize  = (Map<String,Object>)JSON.deserializeUntyped(getLocationGeocode(sAddress).getBody());                
            }
            final List<Object> results = (List<Object>)mpObjDesearialize.get('results');
            final Map<String,Object> firstResult = (Map<String,Object>)results[0]; 
            final Map<String,Object> geometry = (Map<String,Object>)firstResult.get('geometry');
            final Map<String,Object> location = (Map<String,Object>)geometry.get('location');
            strDireccion =  location.get('lat')+','+location.get('lng');
        } catch ( ListException le ) {
               throw new AuraHandledException ( System.Label.MX_WB_LG_ErrorBack + le);
        }
        return strDireccion;
    }
}