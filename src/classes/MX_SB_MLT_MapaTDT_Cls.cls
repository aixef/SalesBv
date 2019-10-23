/**----------------------------------------------------------
* Nombre: MX_SB_MLT_MapaTDT_Cls
* Autor Oscar Martínez
* Proyecto: SB Siniestros - BBVA Bancomer
* Descripción : Recupera los datos para mostrar el mapa en la tarea de datos.

* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                                 Desripción
* --------------------------------------------------------------------------------
* 1.0           25/04/2019     Oscar Martínez                         Creación
* 1.1           25/09/2019     Ing. Daniel Goncalves                  Se propaga excepción para casos de lista vacía
* 1.2           30/09/2019     Ing. Daniel Goncalves                  Se eliminan literals y se comenta method
* --------------------------------------------------------------------------------
**/

public with sharing class MX_SB_MLT_MapaTDT_Cls {
    
  private MX_SB_MLT_MapaTDT_Cls () {}
   /*
   * Method que regresa listado de casos segun ID enviado
   */
   @AuraEnabled
   public static List<Case> datosMapa (String idCase) {
        List<case> datosCase =  new List<Case>();
        
        try {
            datosCase = MX_SB_MLT_TareaDatosUtils_Cls.obtieneCase(idCase);
            if(datosCase.isEmpty()) {
                throw new CustomException ('Lista Vacía');
            }
        } catch ( CustomException ce ) {
             throw new AuraHandledException ( System.Label.MX_WB_LG_ErrorBack + ce);
        }
        return datosCase;
   }
}