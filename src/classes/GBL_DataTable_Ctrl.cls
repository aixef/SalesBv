/*
*********************************************************************************************
*   @Desarrollado por:      Estrategia Tecnológica                              			  *
*   @Autor:                 Angel Fuertes Gómez                                               *
*   @Proyecto:              Bancomer                                                          *
*   @Descripción:           Clase handler para el controlador local                           *
*                           DataTable                                                         *
*                                                                                             *
*   Cambios (Versiones)                                                                       *
*   ------------------------------------------------------------------------------------------*
*   No.     Fecha               Autor                   Descripción                           *
*   ------  ----------  ----------------------      --------------------------- --------------*
*   1.0     22/08/2018  Angel Fuertes Gomez          Creación de controlador    			  *
*   1.1     04/09/2018  Eulises Aguilar Rodriguez    Se agrego método sinergia  			  *
*   1.2     04/09/2018  Luis Ruben Quinto Muñoz      Se agrego método VISITAS   			  *
*   1.3     04/09/2018  Luis Ruben Quinto Muñoz      Se agrego método GRUPOS ECONOMICOS   	  *
*   1.4     11/09/2018  Eulises Aguilar Rodriguez    Se agrego método COBRANZA Y DISPERSIÓN   *
*   1.5     11/09/2018  Luis Ruben Quinto Muñoz      Se agrego método VISITAS TRIMESTRE   	  *
*   1.6     24/09/2018  Eulises Aguilar Rodriguez    Se corrige titulo de tabla 		      *
*   1.7     23/10/2018  Daniel García    			 Se agregó método                         *
*												     VISITAS FUERA DE RANGO CF                *
*	1.8		24/10/2018	Monserrat González Sánchez	 Se agrego método reciprocidadCASH		  *
* 	1.9    	31/10/2018  Jhovanny De La Cruz Cruz 	 Se agrego método valuesHandler	por       *
*													 sobrecarga de funciones                  *
*   2.0     31/10/2018  Jhovanny De La Cruz Cruz     Se agrego método getId  				  *
*   2.1     31/10/2018  Jhovanny De La Cruz Cruz     Se agrego método userRoleValidation      *
*   2.2     31/10/2018  Jhovanny De La Cruz Cruz     Se agrego método userLoggedIn    		  *
*   2.3     31/10/2018  Jhovanny De La Cruz Cruz     Corrección llamado a metodos             *
*   2.4     10/01/2019  Luis Ruben Quinto Muñoz      Se agrego método VISITAS CLIENTESPERTENECIENTES AL GRUPO*
*   2.5     11/02/2019  Daniel García     	         Se agregan métodos VISTA-DETALLE PRODUCTO
*   2.6     27/06/2019  Selena Rodriguez, Gabriel Rojas  Se optimizo metodo userRoleValidation*
*   2.7     05/07/2019  Selena Rodriguez, Gabriel Rojas  Se dividio el metodo valuesHandler   *
*                                                        porcomplejidad en Sonar*             *
**********************************************************************************************
*/
public without sharing class GBL_DataTable_Ctrl {
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to call dataTableWrapper  contains getter and setter for attribute´s GBL_DataTable_CMP
    * -----------------------------------------------------------------------------------------------------
    * */
    public class dataTableWrapper {
    /*
    @Description Getter y Setter para atributo en cmp GBL_DataTable_CMP
    */
        @AuraEnabled public List<String> nameColumn {get;set;}
    /*
    @Description Getter y Setter para atributo en cmp GBL_DataTable_CMP
    */
        @AuraEnabled public List<List<String[]>> allData {get;set;}
    /*
    @Description Getter y Setter para atributo en cmp GBL_DataTable_CMP
    */
        @AuraEnabled public boolean gblResultResponse {get;set;}
    /*
    @Description Getter y Setter para atributo en cmp GBL_DataTable_CMP
    */
        @AuraEnabled public String gblDescriptionResponse {get;set;}
    }
    private GBL_DataTable_Ctrl() {}
/*
* @description Metodo que funciona como Handler
* @param idObject Id of the object
* @param functionRow Nombre de la función a implementar
* @return rowHorWrapper Clase con los elementos necesarios para pintar datos en el componente
* @param bVariable Nombre de variable a enviar por herencia de componentes
* @param prefix Prefijo obtenido a partir de el metodo userRoleValidation
* @param title Variable contenedora de valores traidos de clics del ejecutivo
* @param flag Bandera de uso general
* @return rowHorWrapper Clase con los elementos necesarios para pintar datos en el componente*/

    @AuraEnabled(cacheable=true)
    public static dataTableWrapper valuesHandler (String functionRow,String bVariable,String solucion) {
        dataTableWrapper finalWrapper = new dataTableWrapper();
        finalWrapper.gblResultResponse = true;
        System.debug('functionRow ' + functionRow);
        try {
        Switch on functionRow {
            when 'VISTA' {
                finalWrapper = MX_PyME_DTM_datos_servicios_Cls.datosVista(bVariable);
            }
            when 'PLAZO' {
                finalWrapper = MX_PyME_DTM_datos_servicios_Cls.datosPlazo(bVariable);
            }
           	when 'FONDOS' {
                finalWrapper = MX_PyME_DTM_datos_servicios_Cls.datosFondos(bVariable);
            }
            when 'TN' {
                finalWrapper = MX_PyME_DataTableMethods_Cls.creditosTN(bVariable);
            }
            when 'TDMN' {
                finalWrapper = MX_PyME_DataTableMethods_Cls.creditosTDMNeg(bVariable);
            }
            when 'CREDITO SIMPLE' {
                finalWrapper = MX_PyME_DataTableMethods_Cls.creditoSimple(bVariable);
            }
            when else{
                finalWrapper=valuesHandlerSwitch(functionRow,bVariable,solucion);
            }
        }
        return finalWrapper;
        } catch(Exception e) {throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    }
/*------------------------------------------------------------------------------------------------------
    *@Description Method to call getBalanceDetail service from MX_PyME_ServiceCards_Cls class
    * -----------------------------------------------------------------------------------------------------
    * @Author   Selena Rodriguez
    * @Author   Gabriel Rojas
    * @Date     2019-07-05
    * @param    String functionRow Name function which will go to implements
    * @param    String bVariable name variable which will be implements for inherit
    * @param    String solucion variable recieve number of credit
    * @example  String valuesHandlerSwitch('OTROS CREDITOS','2MSE34163VBDW','MWDIMCIWE531678')
    * */

    public static dataTableWrapper valuesHandlerSwitch(String functionRow,String bVariable,String solucion) {
        dataTableWrapper finalWrapper = new dataTableWrapper();
        finalWrapper.gblResultResponse = true;
        System.debug('functionRow ' + functionRow);
        try {
        Switch on functionRow {
            when 'OTROS CREDITOS' {
                finalWrapper = MX_PyME_DataTableMethods_Cls.otrosCreditos(bVariable);
            }
            when 'SERVICIOS CRTC' {
                finalWrapper = MX_PyME_DataTableMethods_Cls.servicioCRTC(bVariable);
            }
            when 'SERVICIOS TPVS' {
                finalWrapper = MX_PyME_DataTableMethods_Cls.servicioTPVS(bVariable);
            }
            when 'SERVICIOS SEGR' {
                finalWrapper = MX_PyME_DTM_datos_servicios_Cls.serviciosSeguros(bVariable);
            }
            when 'DETALLE PRODUCTO' {
                finalWrapper = MX_PyME_DTM_datos_servicios_Cls.detalleProducto(bVariable,solucion);
            }
            when else{
                finalWrapper.gblResultResponse = false;
                finalWrapper.gblDescriptionResponse = 'No existe esa función';
            }
        }
        return finalWrapper;
        } catch(Exception e) {
         	throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    }

/** @description Metodo para validar e identificar el rol del usuario logueado
* @return roleprefix prefijo identificador de rol */
    @AuraEnabled
    public static String userRoleValidation() {
        try {
            String roleprefix = '';
            final String userRoleDN = [SELECT id,DeveloperName FROM UserRole WHERE id =: UserInfo.getUserRoleId() ].DeveloperName;
            final Map<String,List<Schema.PicklistEntry>>  mapRoleprefix=new Map<String,List<Schema.PicklistEntry>>();
            mapRolePrefix.put('BEYG',MX_CashManagement__mdt.MX_CH_BEYG__c.getDescribe().getPicklistValues());
            for(String  key: mapRolePrefix.keySet()) {
                for(Schema.PicklistEntry cont: mapRolePrefix.get(key)) {
                    if(userRoleDN == cont.getLabel()) {
                        roleprefix = key;
                        break;
                    }
                }
            }
            return roleprefix;
        } catch(Exception e) {throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    }
    /** @description Metodo para validar e identificar la UG del usuario logueado
    *  @return registro usuario*/
    @AuraEnabled
    public static User userLoggedIn() {
        try {
            return [SELECT Id, Name, UG__c FROM User WHERE Id =: UserInfo.getUserId()];
        } catch(QueryException e) {throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to call getBalanceDetail service from MX_PyME_ServiceCards_Cls class
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    clientId id of the client(Account)
    * @param    numContract string returned by clicking a credit record detail
    * @return   Void
    * @example  var action = component.get("c.callBalanceService"); javascript method
    */
    @AuraEnabled
    public static void callBalanceService(String clientId,String numContract) {
        try {
        final String srvBalance = test.isRunningTest() ? 'getBalanceDetailMock' : 'getBalanceDetail';
        MX_PyME_ServiceCards_Cls.getBalanceInfo(srvBalance,clientId,numContract);
       } catch(Exception e) {throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
       }
    }

}