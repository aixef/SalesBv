/**
* ------------------------------------------------------------------------------------------------
* @Name         MX_PyME_DataTableMethods
* @Author       Selena Rodriguez
* @Author       Gabriel Rojas
* @Date         Created: 2019-07-04
* @Group        Class for complements Data Tables in PyME client tab
* @Description  Class that  complements the class MX_PyME_DataTableMethods_Cls which creates tables in the PyMe client tab
* @Changes      (most recent first)
*
*  |2019-07-04  First version
* ------------------------------------------------------------------------------------------------
*/
public  with sharing class MX_PyME_DTM_datos_servicios_Cls {
    /*List ARGS que contiene valores por defecto que seran tomados durante el codigo dependiendo la condicion*/
    public static final List<String> ARGS = new String[]{'0','number','###.###.##0,00'};
    /*SNDATO variable String que se utiliza para creacion cuentas*/
    static final String SNDATO ='sin dato';
    private MX_PyME_DTM_datos_servicios_Cls() {
    }

    /*------------------------------------------------------------------------------------------------------
    *@Description Method to create table of Vista in the PyME client tab
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    bVariable Id of the client(Account)
    * @return   GBL_DataTable_Ctrl.dataTableWrapper
    * @example  finalWrapper = MX_PyME_DataTableMethods.datosVista(bVariable) */

        public static GBL_DataTable_Ctrl.dataTableWrapper datosVista(id bVariable) {
            final GBL_DataTable_Ctrl.dataTableWrapper newData = new GBL_DataTable_Ctrl.dataTableWrapper();
            newData.gblResultResponse = true;
            newData.nameColumn = new List<String>{'Saldo promedio','Mes anterior','Variación'};
            List<String[]> ltsValues;
            final List<Account> credsTN = [Select MX_PyME_Vista_Saldo_diario__c,MX_PyME_Vista_Saldo_mAnterior__c,MX_PyME_Vista_Saldo_variacion__c From Account where id=:bVariable];
             if ( credsTN.isEmpty()) {
                newData.gblResultResponse = false;
                newData.gblDescriptionResponse = 'No hay registros de Vista';
            } else {
                ltsValues = new List<String[]>();
                final List<List<String[]>> allD = new List<List<String[]>>();
                ltsValues.add(credsTN[0].MX_PyME_Vista_Saldo_diario__c == null ? new String[]{SNDATO,null} : new String[]{'$ ' + String.format(credsTN[0].MX_PyME_Vista_Saldo_diario__c.format(), ARGS),null});
                ltsValues.add(credsTN[0].MX_PyME_Vista_Saldo_mAnterior__c == null ? new String[]{SNDATO,null} : new String[]{'$ ' + String.format(credsTN[0].MX_PyME_Vista_Saldo_mAnterior__c.format(), ARGS),null});
                ltsValues.add(credsTN[0].MX_PyME_Vista_Saldo_variacion__c == null ? new String[]{SNDATO,null} : new String[]{'$ ' + String.format(credsTN[0].MX_PyME_Vista_Saldo_variacion__c.format(), ARGS),null});
                allD.add(ltsValues);
                newData.allData = allD;
            }
            return newData;
        }
     /*------------------------------------------------------------------------------------------------------
    *@Description Method to create table of Plazo in the PyME client tab
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    bVariable Id of the client(Account)
    * @return   GBL_DataTable_Ctrl.dataTableWrapper
    * @example  finalWrapper = MX_PyME_DataTableMethods.datosPlazo(bVariable) 
    */

    public static GBL_DataTable_Ctrl.dataTableWrapper datosPlazo(id bVariable) {
        final GBL_DataTable_Ctrl.dataTableWrapper newData = new GBL_DataTable_Ctrl.dataTableWrapper();
        newData.gblResultResponse = true;
        newData.nameColumn = new List<String>{'Saldo promedio','Mes anterior','Variación'};
        List<String[]> ltsValues;
        final List<Account> credsTN = [Select MX_PyME_Plazo_Saldo_diario__c,MX_PyME_Plazo_Saldo_mes_anterior__c,MX_PyME_Plazo_Saldo_variacion__c From Account where id=:bVariable];
        if(credsTN.isEmpty()) {
             newData.gblResultResponse = false;
            newData.gblDescriptionResponse = 'No hay registros de Plazo';
        } else {
            final List<List<String[]>> allD = new List<List<String[]>>();
            ltsValues = new List<String[]>();
            ltsValues.add(credsTN[0].MX_PyME_Plazo_Saldo_diario__c == null ? new String[]{SNDATO,null} : new String[]{'$ ' + String.format(credsTN[0].MX_PyME_Plazo_Saldo_diario__c.format(), ARGS),null});
            ltsValues.add(credsTN[0].MX_PyME_Plazo_Saldo_mes_anterior__c ==null ? new String[]{SNDATO,null} : new String[]{'$ ' + String.format(credsTN[0].MX_PyME_Plazo_Saldo_mes_anterior__c.format(), ARGS),null});
            ltsValues.add(credsTN[0].MX_PyME_Plazo_Saldo_variacion__c == null ? new String[]{SNDATO,null} : new String[]{'$ ' + String.format(credsTN[0].MX_PyME_Plazo_Saldo_variacion__c.format(), ARGS),null});
            allD.add(ltsValues);
            newData.allData = allD;
        }
        return newData;
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to create table of Vista in the PyME client tab
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    bVariable Id of the client(Account)
    * @return   GBL_DataTable_Ctrl.dataTableWrapper
    * @example  finalWrapper = MX_PyME_DataTableMethods.datosFondos(bVariable) */

    public static GBL_DataTable_Ctrl.dataTableWrapper datosFondos(id bVariable) {
        final GBL_DataTable_Ctrl.dataTableWrapper newData = new GBL_DataTable_Ctrl.dataTableWrapper();
        newData.gblResultResponse = true;
        newData.nameColumn = new List<String>{'Saldo promedio','Mes anterior','Variación'};
        List<String[]> ltsValues;
        final List<Account> credsTN = [Select MX_PyME_Fondos_Saldo_diario__c,MX_PyME_Fondos_Saldo_mes_anterior__c,MX_PyME_Fondos_Saldo_variacion__c From Account where id=:bVariable];
        if ( credsTN.isEmpty()) {
            newData.gblResultResponse = false;
            newData.gblDescriptionResponse = 'No hay registros de Fondos';
        } else {
            final List<List<String[]>> allD = new List<List<String[]>>();
            ltsValues = new List<String[]>();
            ltsValues.add(credsTN[0].MX_PyME_Fondos_Saldo_diario__c == null ? new String[]{SNDATO,null} : new String[]{'$ ' + String.format(credsTN[0].MX_PyME_Fondos_Saldo_diario__c.format(),ARGS),null});
            ltsValues.add(credsTN[0].MX_PyME_Fondos_Saldo_mes_anterior__c == null ? new String[]{SNDATO,null} : new String[]{'$ ' + String.format(credsTN[0].MX_PyME_Fondos_Saldo_mes_anterior__c.format(), ARGS),null});
            ltsValues.add(credsTN[0].MX_PyME_Fondos_Saldo_variacion__c == null ? new String[]{SNDATO,null} : new String[]{'$ ' + String.format(credsTN[0].MX_PyME_Fondos_Saldo_variacion__c.format(), ARGS),null});
            allD.add(ltsValues);
            newData.allData = allD;
        }
        return newData;
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to create content of tables depending of the type of credit
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    bVariable Id of the client(Account)
    * @param    credit Indicates te type of table
    * @return   GBL_DataTable_Ctrl.dataTableWrapper
    * @example  createDynamicCreditTables('CreditoSimple',bVariable);
    */
    public static GBL_DataTable_Ctrl.dataTableWrapper createDynamicCreditTables(String credit,id bVariable) {
        final GBL_DataTable_Ctrl.dataTableWrapper newData = new GBL_DataTable_Ctrl.dataTableWrapper();
        System.debug('createDynamicCreditTables');
        newData.gblResultResponse = true;
        newData.nameColumn = new List<String>{'Concepto del credito','Saldo','Indicador Impago','Detalle'};
        List<List<String[]>> allD = new List<List<String[]>>();

        String tipoProductoA = 'A';
        String tipoProductoB = 'B';
        String cptoCreditoNeg = '%TDC NEGOCIOS%';
        String ctoCreditoMicro = '%TDC MICRO%';
        tipoProductoA = String.escapeSingleQuotes(tipoProductoA);
        cptoCreditoNeg = String.escapeSingleQuotes(cptoCreditoNeg);
        tipoProductoB = String.escapeSingleQuotes(tipoProductoB);
        ctoCreditoMicro = String.escapeSingleQuotes(ctoCreditoMicro);
        final Map<String,String> consultasMap = new Map<String,String>();

        consultasMap.put('TDCNegocio','SELECT MX_PyME_Concepto_Credito__c,MX_PyME_Saldo_deudor__c,MX_PyME_Indicador_impago__c,MX_PyME_prodNumero_credito__c,MX_PyME_Tipo_producto__c FROM MX_PyME_Balance_Productos__c WHERE MX_PyME_Tipo_producto__c =: tipoProductoA AND MX_PyME_Concepto_Credito__c LIKE: cptoCreditoNeg AND MX_PyME_Cliente__c=:bVariable');
        consultasMap.put('CreditoSimple', 'SELECT MX_PyME_Concepto_Credito__c,MX_PyME_Saldo_deudor__c,MX_PyME_Indicador_impago__c,MX_PyME_prodNumero_credito__c,MX_PyME_Tipo_producto__c FROM MX_PyME_Balance_Productos__c WHERE MX_PyME_Tipo_producto__c =: tipoProductoB AND MX_PyME_Cliente__c=:bVariable');
        consultasMap.put('TDCMicroNegocio','SELECT MX_PyME_Concepto_Credito__c,MX_PyME_Saldo_deudor__c,MX_PyME_Indicador_impago__c,MX_PyME_prodNumero_credito__c,MX_PyME_Tipo_producto__c FROM MX_PyME_Balance_Productos__c WHERE MX_PyME_Tipo_producto__c =: tipoProductoA AND MX_PyME_Concepto_Credito__c LIKE: ctoCreditoMicro AND MX_PyME_Cliente__c=:bVariable');
        final String query = consultasMap.get(String.escapeSingleQuotes(credit));
        System.debug('query ' + query);
        final list<MX_PyME_Balance_Productos__c> lstDataTable=Database.query(String.escapeSingleQuotes(query));
        System.debug('lstDataTable ' + lstDataTable);
        allD = getDynamicTableData(lstDataTable);
        System.debug('allD ' + allD);
        if ( allD.isEmpty()) {
            newData.gblResultResponse = false;
            newData.gblDescriptionResponse = 'No hay registros de estos créditos';
        } else {
            newData.allData = allD;
        }
        return newData;
    }

    /*------------------------------------------------------------------------------------------------------
        *@Description Supports dynamic table creation by gathering balance fields when applicable
        * -----------------------------------------------------------------------------------------------------
        * @param    lstDataTable Queried balance product records
        * @return   List<List<String[]>> List containing record information for dynamic table creation
    */
    private static List<List<String[]>> getDynamicTableData(List<MX_PyME_Balance_Productos__c> lstDataTable) {
        final List<List<String[]>> allData = new List<List<String[]>>();
        final List<String[]> ltsValues = new List<String[]>();
        for(MX_PyME_Balance_Productos__c creds : lstDataTable) {
            ltsValues.clear();
            ltsValues.add(checkNullData(creds, 'MX_PyME_Concepto_Credito__c', new String[]{SNDATO,null}, new String[]{creds.MX_PyME_Concepto_Credito__c ,null}));
            ltsValues.add(checkNullData(creds, 'MX_PyME_Saldo_deudor__c', new String[]{SNDATO,null}, new String[]{'$ ' + String.format(creds.MX_PyME_Saldo_deudor__c.format(), ARGS),null}));
            ltsValues.add(checkNullData(creds, 'MX_PyME_Indicador_impago__c', new String[]{'',null}, new String[]{creds.MX_PyME_Indicador_impago__c,null}));
            ltsValues.add(checkNullData(creds, 'MX_PyME_prodNumero_credito__c', new String[]{SNDATO,'TEST',String.valueOf(Schema.Account.SObjectType)}, new String[]{creds.MX_PyME_prodNumero_credito__c}));
            allData.add(ltsValues);
        }
        return allData;
    }

    /*------------------------------------------------------------------------------------------------------
        *@Description Supports dynamic table creation by checking for null values in data
        * -----------------------------------------------------------------------------------------------------
        * @param    record Record that will be checked
        * @param    field Field that will be checked for null values
        * @param    valueIfNull The resulting value if the field is null
        * @param    valueNotNull The resulting value if the field is not null
        * @return   List<String> List containing record information for dynamic table creation
    */
    private static List<String> checkNullData(SObject record, String field, List<String> valueIfNull, List<String> valueNotNull) {
        List<String> result;
        if(record.get(field) == null) {
            result = valueIfNull;
        } else {
            result = valueNotNull;
        }
        return result;
    }
    /*------------------------------------------------------------------------------------------------------
    *@Description Method to create content of tables depending of the type of service
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    bVariable Id of the client(Account)
    * @param    service Indicates te type of service
    * @return   GBL_DataTable_Ctrl.dataTableWrapper
    * @example  createDynamicServiceTables('TPV',bVariable);
    * */
    public static GBL_DataTable_Ctrl.dataTableWrapper createDynamicServiceTables(String service,id bVariable) {

        String identificadorTPVS= 'TPVS', identificadorCRTC='CRTC', identFISICA='FISICA';
        identificadorTPVS = String.escapeSingleQuotes(identificadorTPVS);
        identificadorCRTC = String.escapeSingleQuotes(identificadorCRTC);
        identFISICA = String.escapeSingleQuotes(identFISICA);
        final GBL_DataTable_Ctrl.dataTableWrapper newData = new GBL_DataTable_Ctrl.dataTableWrapper();
        newData.gblResultResponse = true;
        newData.nameColumn = new List<String>{'Concepto del credito','Saldo'};
        final List<List<String[]>> allD = new List<List<String[]>>();
        List<String[]> ltsValues;

        final Map<String,String> consultasMap = new Map<String,String>();

        consultasMap.put('TPV','SELECT MX_PyME_Descripcion_servicio__c,MX_PyME_Saldo_del_servicio__c FROM MX_PyME_Balance_Productos__c Where MX_PyME_Cliente__c=:bVariable And MX_PyME_Identificador_servicio__c=: identificadorTPVS');
        consultasMap.put('CRTC','SELECT MX_PyME_Descripcion_servicio__c,MX_PyME_Saldo_del_servicio__c FROM MX_PyME_Balance_Productos__c Where MX_PyME_Cliente__c=:bVariable And MX_PyME_Identificador_servicio__c=: identificadorCRTC');
        consultasMap.put('OCR','SELECT MX_PyME_Descripcion_servicio__c,MX_PyME_Saldo_del_servicio__c FROM MX_PyME_Balance_Productos__c Where MX_PyME_Cliente__c=:bVariable And MX_PyME_Identificador_servicio__c=: identFISICA');
        final String query = consultasMap.get(String.escapeSingleQuotes(service));
        final list<MX_PyME_Balance_Productos__c> lstDataTable=Database.query(String.escapeSingleQuotes(query));
            for(MX_PyME_Balance_Productos__c servs : lstDataTable) {
                ltsValues = new List<String[]>();
                ltsValues.add(servs.MX_PyME_Descripcion_servicio__c == null ? null : new String[]{servs.MX_PyME_Descripcion_servicio__c,null});
                ltsValues.add(servs.MX_PyME_Saldo_del_servicio__c == null ? null : new String[]{'$ ' + String.format(servs.MX_PyME_Saldo_del_servicio__c .format(), ARGS),null});
                allD.add(ltsValues);
            }
            if ( allD.isEmpty()) {
                newData.gblResultResponse = false;
                newData.gblDescriptionResponse = 'No hay registros de estos servicios';
            } else {
                newData.allData = allD;
            }
            return newData;
    }

    /*------------------------------------------------------------------------------------------------------
    *@Description Method to create table of SERVICIOS SEGR in the PyME client tab
    * -----------------------------------------------------------------------------------------------------
    * @Author   Daniel García
    * @Date     2019-02-10
    * @param    bVariable Id of the client(Account)
    * @return   GBL_DataTable_Ctrl.dataTableWrapper
    * @example  finalWrapper = MX_PyME_DataTableMethods.serviciosSeguros(bVariable) */

    public static GBL_DataTable_Ctrl.dataTableWrapper serviciosSeguros(id bVariable) {
            final GBL_DataTable_Ctrl.dataTableWrapper newData = new GBL_DataTable_Ctrl.dataTableWrapper();
            newData.gblResultResponse = true;
            newData.nameColumn = new List<String>{'Descripción','Status'};
            final List<List<String[]>> allD = new List<List<String[]>>();
            List<String[]> ltsValues;
            for(MX_PyME_Balance_Productos__c credsTN : [Select MX_PyME_Descripcion_servicio__c,MX_PyME_Fecha_activacion__c From MX_PyME_Balance_Productos__c Where MX_PyME_Cliente__c=:bVariable And MX_PyME_Identificador_servicio__c='SEGR']) {
                ltsValues = new List<String[]>();
                ltsValues.add(credsTN.MX_PyME_Descripcion_servicio__c == null ? new String[]{SNDATO,null} : new String[]{credsTN.MX_PyME_Descripcion_servicio__c,null});
                ltsValues.add(credsTN.MX_PyME_Fecha_activacion__c == null ? new String[]{SNDATO,null} : new String[]{credsTN.MX_PyME_Fecha_activacion__c,null});
                allD.add(ltsValues);
            }
            if ( allD.isEmpty()) {
                newData.gblResultResponse = false;
                newData.gblDescriptionResponse = 'No hay registros de seguros';
            } else {
                newData.allData = allD;
            }
            return newData;

        }
        /*------------------------------------------------------------------------------------------------------
        *@Description Method to create table of DETALLE PRODUCTO in the PyME client tab
        * -----------------------------------------------------------------------------------------------------
        * @Author   Daniel García
        * @Date     2019-02-10
        * @param    bVariable Id of the client(Account)
        * @param    numContract Number of contract related to a client
        * @return   GBL_DataTable_Ctrl.dataTableWrapper
        * @example  finalWrapper = MX_PyME_DataTableMethods.detalleProducto(bVariable)  */

        public static GBL_DataTable_Ctrl.dataTableWrapper detalleProducto(id bVariable,String numContract) {
            String pdtoA='productoA';
            String pdtoB='productoB';
            System.debug('numContract ' + numContract);
            final GBL_DataTable_Ctrl.dataTableWrapper newData = new GBL_DataTable_Ctrl.dataTableWrapper();
            newData.gblResultResponse = true;
            final List<List<String[]>> allD = new List<List<String[]>>();
            final List<String[]> ltsValues = new List<String[]>();
            final Map<String, List<String>> mapNameColum = new Map<String,List<String>>();
            mapNameColum.put(pdtoA,new List<String>{'No. Crédito','Importe concedido','Total por liquidar','Amortizaciones pendientes','No. impagos'});
            mapNameColum.put(pdtoB,new List<String>{'No. Tarjeta','Linea de crédito','Compras+Disposiciones','Porcentaje de uso','No. impagos'});

            final MX_PyME_Balance_Productos__c[] prod=[Select Name,MX_PyME_Tipo_producto__c From MX_PyME_Balance_Productos__c where MX_PyME_prodNumero_credito__c=:numContract Limit 1];
            final List<MX_PyME_Detalle_productos__c> detprds=[Select MX_PyME_Saldo_otorgado__c,MX_PyME_Porcentaje_uso__c,MX_PyME_No_impagos__c,MX_PyME_No_credito_tarjeta__c,MX_PyME_Amortizaciones__c,MX_PyME_Compras_Disposiciones__c From MX_PyME_Detalle_productos__c Where MX_PyME_No_credito_bp__c=:numContract];
            System.debug('prod ' + prod);
            System.debug('detprds ' + detprds);

            for(MX_PyME_Detalle_productos__c credsCS : detprds) {
                ltsValues.clear();
                ltsValues.add(checkNullData(credsCS, 'MX_PyME_No_credito_tarjeta__c', new String[]{SNDATO,null}, new String[]{credsCS.MX_PyME_No_credito_tarjeta__c,null}));
                ltsValues.add(checkNullData(credsCS, 'MX_PyME_Saldo_otorgado__c', new String[]{SNDATO,null}, new String[]{'$ ' + String.format(credsCS.MX_PyME_Saldo_otorgado__c .format(), ARGS),null}));
                ltsValues.add(checkNullData(credsCS, 'MX_PyME_Compras_Disposiciones__c', new String[]{SNDATO,null}, new String[]{'$ ' + String.format(credsCS.MX_PyME_Compras_Disposiciones__c .format(), ARGS),null}));

                if(prod[0].MX_PyME_Tipo_producto__c == pdtoB) {
                    ltsValues.add(checkNullData(credsCS, 'MX_PyME_Amortizaciones__c', new String[]{SNDATO,null}, new String[]{String.valueOf(credsCS.MX_PyME_Amortizaciones__c),null}));
                } else if(prod[0].MX_PyME_Tipo_producto__c == pdtoA) {
                    ltsValues.add(checkNullData(credsCS, 'MX_PyME_Porcentaje_uso__c', new String[]{SNDATO,null}, new String[]{'% ' + String.valueOf(credsCS.MX_PyME_Porcentaje_uso__c),null}));
                }
                ltsValues.add(checkNullData(credsCS, 'MX_PyME_No_impagos__c', new String[]{SNDATO,null}, new String[]{String.valueOf(credsCS.MX_PyME_No_impagos__c),null}));
                allD.add(ltsValues);
            }
            newData.nameColumn = mapNameColum.get(prod[0].MX_PyME_Tipo_producto__c);

            if ( allD.isEmpty()) {
                newData.gblResultResponse = false;
                newData.gblDescriptionResponse = 'No hay registros de detalle de este producto';
            } else {
                newData.allData = allD;
            }
            return newData;
        }
}