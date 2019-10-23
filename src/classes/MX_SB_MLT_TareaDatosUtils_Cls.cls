/**--------------------------------------------------------------------------------
* Nombre: MX_SB_MLT_TareaDatosUtils_Cls
* Autor Oscar Martínez
* Proyecto: SB Siniestros - BBVA Bancomer
* Descripción : Methods reutilizables para el flujos de la creación de tarea de datos
* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                               Descripción
* --------------------------------------------------------------------------------
* 1.0           25/04/2019     Oscar Martínez                       Creación
* 1.1           07/05/2019     Oscar Martínez                       Se agrega Method que valida cadenas vacías
* 1.2           14/05/2019     Oscar Martínez                       Se modifica Method de obtieneCase, para evitar injection soql
* 1.3           15/05/2019     Daniel Goncalves Vivas               Corrección de acentos
* 1.4           23/08/2019     Daniel Goncalves Vivas               Manejo formato fecha en GetDate DD/MM/YYYY a YYYY-MM-DD
* 1.5           25/09/2019     Angel Nava                           Metodo para servicios
* 1.6           30/09/2019     Daniel Goncalves Vivas               Se declaran variables final 
* 1.7           08/10/2019     Daniel Goncalves Vivas               Se elimina método de mapeo contrato
* 1.8           10/10/2019     Daniel Goncalves Vivas               Se agrega método de getTimeGlass
* --------------------------------------------------------------------------------
**/

public with sharing class MX_SB_MLT_TareaDatosUtils_Cls {

    /*Valor de tres para tamaño arreglo de fecha*/
    static final Integer TRES = 3;
    /*Valor de uno para tamaño arreglo de time*/
    static final Integer UNO = 1;

    private MX_SB_MLT_TareaDatosUtils_Cls() {}
    
    /*
    * @description Method que devuelve una Lista de casos.
    * @param String idCase
    * @return List<sObject>
    */
    public static List<Case> obtieneCase(String idCase) {
        return [Select Id,Status,Origin,SiniestroAbierto__c,MX_SB_MLT_URLLocation__c,MX_SB_MLT_SegmentClient__c,TipoSiniestro__c,RecordType.Name,MX_SB_MLT_Event__c From Case where Id =: idCase];
    }

    /*
    * @description Method que valida que no este vacío el elemento.
    * @param String obj
    * @return String strResponse
    */
    public static String validaDatoVacio(String obj) {
        return String.isEmpty(obj) ? '' : obj;
    }
    
    /*
    * @description Method que valida que no este vacío el decimal.
    * @param String obj
    * @return Decimal
    */
    public static Decimal validaDatoDecimalVacio(String obj) {
        return String.isEmpty(obj) ? 0.00 : Decimal.valueOf(obj);
    }
    
    /*
    * @description valida que no este vacío el elemento y realiza el parseo a Date
    * @param String obFec
    * @return String strResponse
    */
    public static Date getDate(String obFec) {
        String obFecRs = '1961-01-01';
        
        if (String.isNotBlank(obFec)) {
                final String[] arrDt = obFec.split('/');

            if ( arrDt.size() == TRES ) {
                if ( arrDt[2].contains(' ') ) {
                  final String[] anio = arrDt[2].split(' ');  
                  obFecRs = anio[0] + '-' +  arrDt[1] + '-' + arrDt[0];
                } else {
                  obFecRs = arrDt[2] + '-' +  arrDt[1] + '-' + arrDt[0];
                }
            }            
        }
        return ( Date.valueOf(obFecRs) );
    }

   /*
   * @description regresa el valor del catalogo de claim center
   * @param String systemlegacy,String event
   * @return String strResponse
   */
    public static String validaEvent(String strlegacy,String event,Integer servicio) {
        String eventOut=event;
        final String servicioStr = String.valueOf(servicio);
        if(strlegacy=='ARCA' &&  servicioStr!='0') {
            final MX_SB_MLT_cat_claim_center__mdt[] catalogo = [select masterlabel,MX_SB_MLT_Valor__c,MX_SB_MLT_Catalogos__c from MX_SB_MLT_cat_claim_center__mdt where MX_SB_MLT_Catalogos__c='MA_Product' AND MX_SB_MLT_Valor__c=:servicioStr limit 1];
            if(catalogo.size()>0) {
                eventOut = catalogo[0].masterlabel;
            }
        }
        return eventOut;
    }

    /*
   * @description valida que no este vacío el elemento tiempo glass
   * @param String obFec String obDat
   * @return String 
   */
   public static String getTimeGlass(String obTime,String obDate) {
       String obTimeA;
       if (String.isBlank(obTime) && String.isNotBlank(obDate)) {
          final String[] arrDt = obDate.split('/');
          final String[] anio = arrDt[2].split(' ');
           if( anio.size() > UNO ) {
               obTimeA = anio[1].substring(0,4);
           } 
       }
       if (String.isNotBlank(obTime)) {
          obTimeA = obTime.substring(0,4);
       }
       return obTimeA;
   }
}