/**
* ------------------------------------------------------------------------------------------------
* @Name         MX_PyME_DataTableMethods
* @Author       Daniel García
* @Date         Created: 2019-02-11
* @Group        Class for Data Tables in PyME client tab
* @Description  Class that implements the GBL_DataTable component to create tables in the PyMe client tab
* @Changes      (most recent first)
*
*  |2019-02-11  First version
*  |2019-02-22  Changed columns title in tables                  Daniel García
*  |2019-07-04  Separate methods datosVista,datosPlazo           Selena Rodriguez, Gabriel Rojas
*               datosFondo,createDynamicCreditTables
*               createDynamicServicesTables,serviciosSeguros
*               detalleProducto in class
*               MX_PyME_DTM_datos_servicios_Cls
* ------------------------------------------------------------------------------------------------
*/
public without sharing  class MX_PyME_DataTableMethods_Cls {
    private MX_PyME_DataTableMethods_Cls() {}
    /**variable args */
    public static final List<String> args = new String[]{'0','number','###.###.##0,00'};
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to create table of creditos TN in the PyME client tab
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    BVariable Id of the client(Account)
    * @return   GBL_DataTable_Ctrl.dataTableWrapper
    * @example  finalWrapper = MX_PyME_DataTableMethods.creditosTN(BVariable);
    * */
    public static GBL_DataTable_Ctrl.dataTableWrapper creditosTN(id BVariable) {
        return MX_PyME_DTM_datos_servicios_Cls.createDynamicCreditTables('TDCNegocio',BVariable);
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to create table of creditos TMN in the PyME client tab
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    BVariable Id of the client(Account)
    * @return   GBL_DataTable_Ctrl.dataTableWrapper
    * @example  finalWrapper = MX_PyME_DataTableMethods.creditosTDMNeg(BVariable);
    * */
    public static GBL_DataTable_Ctrl.dataTableWrapper creditosTDMNeg(id BVariable) {
        return MX_PyME_DTM_datos_servicios_Cls.createDynamicCreditTables('TDCMicroNegocio',BVariable);
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to create table of CREDITO SIMPLE in the PyME client tab
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    BVariable Id of the client(Account)
    * @return   GBL_DataTable_Ctrl.dataTableWrapper
    * @example  finalWrapper = MX_PyME_DataTableMethods.creditoSimple(BVariable);
    * */
    public static GBL_DataTable_Ctrl.dataTableWrapper creditoSimple(id BVariable) {
        return MX_PyME_DTM_datos_servicios_Cls.createDynamicCreditTables('CreditoSimple',BVariable);
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to create table of OTROS CREDITOS in the PyME client tab
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    BVariable Id of the client(Account)
    * @return   GBL_DataTable_Ctrl.dataTableWrapper
    * @example  finalWrapper = MX_PyME_DataTableMethods.otrosCreditos(BVariable);
    * */
    public static GBL_DataTable_Ctrl.dataTableWrapper otrosCreditos(id BVariable) {
        return MX_PyME_DTM_datos_servicios_Cls.createDynamicServiceTables('OCR',BVariable);
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to create table of SERVICIOS CRTC in the PyME client tab
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    BVariable Id of the client(Account)
    * @return   GBL_DataTable_Ctrl.dataTableWrapper
    * @example  finalWrapper = MX_PyME_DataTableMethods.servicioCRTC(BVariable);
    * */
    public static GBL_DataTable_Ctrl.dataTableWrapper servicioCRTC(id BVariable) {
        return MX_PyME_DTM_datos_servicios_Cls.createDynamicServiceTables('CRTC',BVariable);
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to create table of SERVICIOS TPVS in the PyME client tab
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    BVariable Id of the client(Account)
    * @return   GBL_DataTable_Ctrl.dataTableWrapper
    * @example  finalWrapper = MX_PyME_DataTableMethods.servicioTPVS(BVariable);
    * */
    public static GBL_DataTable_Ctrl.dataTableWrapper servicioTPVS(id BVariable) {
        return MX_PyME_DTM_datos_servicios_Cls.createDynamicServiceTables('TPV',BVariable);
    }

}