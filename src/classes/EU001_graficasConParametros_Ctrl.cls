/**
* ------------------------------------------------------------------------------------------------
* @Name     EU001_graficasConParametros_Ctrl
* @Author   Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* @Date     Created: 2019-06-12
* @Group    Digital Workplace Retail
* @Description Get the cases owned by the banker
* @Comments Created from the clipped code from the EU001_cls_ConsolaDirector class
* @Changes  Se reduce el método getGeneraJSONReporte.
			Se agregan el método getAgrupadorOrValsEjecutivo, se eliminan los métodos getObtieneValoresDetalle y getLogroPorOficina.
**/

public With Sharing class EU001_graficasConParametros_Ctrl {

    //Constructor with no arguments
    @TestVisible
    private EU001_graficasConParametros_Ctrl() {
    }
    /** variable userUG*/
    private static String userUG = '';
    /** lista equipoDO*/
    private static List<String> equipoDO = new List<String>();
    /** Lista equipoDOUG*/
    private static List<String> equipoDOUG = new List<String>();
    /** Lista equipoDONC*/
    private static List<String> equipoDONC = new List<String>();
    /**Lista equipoDOUSR */
    private static List<User> equipoDOUSR = new List<User>();
    /** Lista ganaMasReal*/
    private static List<Decimal> ganaMasReal = new List<Decimal>();
    /** Lista dorReal */
    private static List<Decimal> dorReal = new List<Decimal>();

    @AuraEnabled
    /** Metodo */
    public Static List<List<String>> getGeneraJSONReporte(String nombreReporte, String ownerUG, String riOwner, String indicador) {
        UserUG = ownerUG;
        List<List<String>> conjunto = new List<List<String>>();
        List<String> agrupador = new List<String>();
        final List<String> indicadores = getIndicadores(nombreReporte);
        final List<String> concepto = getConceptos(nombreReporte);
        List<String> val1 = new List<String>();
        List<String> val2 = new List<String>();
        try {
            agrupador = getAgrupadorOrVals(nombreReporte, ownerUG, 'agrupador', agrupador, concepto, indicadores);
            val1 = getAgrupadorOrVals(nombreReporte, ownerUG, 'val1', agrupador, concepto, indicadores);
            val2 = getAgrupadorOrVals(nombreReporte, ownerUG, 'val2', agrupador, concepto, indicadores);
            if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_APOYOS)) {
                agrupador = new List<String>();
                agrupador.add('');
                agrupador.add('');
                conjunto = getTotalApoyos(riOwner);
            } else {
                agrupador = getAgrupadorOrValsEjecutivo(nombreReporte, ownerUG, 'agrupador', concepto);
                val1 = getAgrupadorOrValsEjecutivo(nombreReporte, ownerUG, 'val1', concepto);
                val2 = getAgrupadorOrValsEjecutivo(nombreReporte, ownerUG, 'val2', concepto);
            }

            if(!nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_APOYOS)) {
                conjunto.add(concepto);
                conjunto.add(agrupador);
                conjunto.add(val1);
                conjunto.add(val2);
            }
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return conjunto;

    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          05-07-2019
* @Description  Get the values needed to generate the JSON report for the EU001_REPORTE_DOR_POR_EJECUTIVO
                and EU001_REPORTE_DOR_POTENCIAL_POR_EJECUTIVO.
* @Comments     Created from the clipped code block of method getGeneraJSONReporte.
* @param        String nombreReporte, String ownerUG, String valueToReturn, List<String> concepto
* @return       List<String>
* @example      public Static List<String> getAgrupadorOrValsEjecutivo(nombreReporte, ownerUG, valueToReturn, concepto)
**/
    public Static List<String> getAgrupadorOrValsEjecutivo(String nombreReporte, String ownerUG, String valueToReturn, List<String> concepto) {
        List<String> agrupadorOrVal = new List<String>();
        if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POR_EJECUTIVO) ||
            nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POTENCIAL_POR_EJECUTIVO)) {
            if(valueToReturn == 'agrupador') {
                agrupadorOrVal = getAgrupadores('',nombreReporte);
            } else if(valueToReturn == 'val1') {
                agrupadorOrVal = getObtieneValoresDGM(concepto.get(0), ownerUG);
            } else if(valueToReturn == 'val2') {
                agrupadorOrVal = getObtieneValoresDGM(concepto.get(1), ownerUG);
            }
        }

        return agrupadorOrVal;

    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          18-06-2019
* @Description  Get the values needed to generate the JSON report.
* @Comments     Created from the clipped code block of method getGeneraJSONReporte.
* @param        String nombreReporte, String ownerUG, String valueToReturn, List<String> agrupador, List<String> concepto, List<String> indicadores
* @return       List<String>
* @example      public static List<String> getAgrupadorOrVals(String nombreReporte, String ownerUG, String valueToReturn,
                List<String> agrupador, List<String> concepto, List<String> indicadores) {
**/
    public static List<String> getAgrupadorOrVals(String nombreReporte, String ownerUG, String valueToReturn, List<String> agrupador, List<String> concepto, List<String> indicadores) {
        List<String> agrupadorOrVal = new List<String>();
        if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_LOGRO_POR_INDICADOR)) {
            if(valueToReturn == 'agrupador') {
                agrupadorOrVal = getAgrupadores('',nombreReporte);
            }
            if(valueToReturn == 'val1') {
                agrupadorOrVal = getObtieneValores(ownerUG,indicadores,concepto.get(0), true);
            }
            if(valueToReturn == 'val2') {
                agrupadorOrVal = getObtieneValores(ownerUG,indicadores,concepto.get(1), true);
            }
        } else if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POR_INDICADOR)) {
            if(valueToReturn == 'agrupador') {
                agrupadorOrVal = getAgrupadores(' pts',nombreReporte);
            }
            if(valueToReturn == 'val1') {
                agrupadorOrVal = getObtieneValores(ownerUG,agrupador,concepto.get(0), false);
            }
            if(valueToReturn == 'val2') {
                agrupadorOrVal = getObtieneValores(ownerUG,agrupador,concepto.get(1), false);
            }
        } else {
            agrupadorOrVal = getGanaMasAgrupadorOrVals(nombreReporte, ownerUG, valueToReturn, agrupador, concepto);
        }
        return agrupadorOrVal;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          05-07-2019
* @Description  Get the values needed to generate the JSON report for the EU001_REPORTE_DOR_POR_INDICADOR constant.
* @Comments     Created from the clipped code block of method getAgrupadorOrVals.
* @param        String nombreReporte, String ownerUG, String valueToReturn, List<String> agrupador, List<String> concepto, List<String> indicadores
* @return       List<String>
* @example      public static List<String> getGanaMasAgrupadorOrVals(nombreReporte, ownerUG, valueToReturn, agrupador, concepto ) {
**/
    public static List<String> getGanaMasAgrupadorOrVals(String nombreReporte, String ownerUG, String valueToReturn, List<String> agrupador, List<String> concepto) {
        List<String> agrupadorOrVal = new List<String>();
        if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_GANA_MAS_INDICADOR)) {
            if(valueToReturn == 'agrupador') {
                agrupadorOrVal = getAgrupadores(' G+', nombreReporte);
            }
            if(valueToReturn == 'val1') {
                agrupadorOrVal = getObtieneValores(ownerUG,agrupador,concepto.get(0), false);
            }
            if(valueToReturn == 'val2') {
                agrupadorOrVal = getObtieneValores(ownerUG,agrupador,concepto.get(1), false);
            }
        }
        return agrupadorOrVal;
    }

    @AuraEnabled
    /**MEtodo getTamanio*/
    public static Integer getTamanio(String numero) {
    Integer numeroLength = null;
        try {
            numeroLength = numero.length();
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return numeroLength;
    }

    @AuraEnabled
    /** Lista*/
    public Static List<String> getObtieneValoresDGM(String Concepto, String UserUG) {
        List<String> valores = new List<String>();
        getEsDO(UserUG);
        List<ExpUni_Tablero_Grupal__c> registrosReporte = new List<ExpUni_Tablero_Grupal__c> ();
        List<aggregateResult> registrosReporte0 = new List<aggregateResult> ();
        try {
            if(Concepto == EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR) {

                registrosReporte =  [SELECT EU_001_Un_Valor__c
                                                    FROM ExpUni_Tablero_Grupal__c
                                                    WHERE EU_UG__c IN :equipoDOUG
                                                    AND EU_001_tx_Indicador__c = :EU001_cls_CONSTANTES.EU001_STR_TOTAL_PUNTOS_DOR
                                                    AND EU_001_tx_Atributo__c = :EU001_cls_CONSTANTES.EU001_STR_TOTAL_PTOS_DOR ORDER BY EU_UG__c];
                for(ExpUni_Tablero_Grupal__c tab: registrosReporte) {
                    dorReal.add(tab.EU_001_Un_Valor__c);
                    valores.add(String.valueOf(tab.EU_001_Un_Valor__c));
                }
            } else if(Concepto == EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR_POT) {

                registrosReporte = [SELECT EU_001_Un_Valor__c
                                    FROM ExpUni_Tablero_Grupal__c
                                    WHERE EU_UG__c IN :equipoDOUG
                                    AND EU_001_tx_Indicador__c = :EU001_cls_CONSTANTES.EU001_STR_TOTAL_DOR_POTENCIAL ORDER BY EU_UG__c];

                valores = getValoresPromedioDorPot(registrosReporte);
            } else if(Concepto == EU001_CLS_CONSTANTES.EU001_STR_ATRIBUTO_GANA_MAS) {

                registrosReporte0 = [SELECT SUM(EU_001_Un_Valor__c), EU_UG__c
                                FROM ExpUni_Tablero_Grupal__c
                                WHERE EU_UG__c IN : equipoDOUG
                                AND EU_001_tx_Indicador__c = :EU001_cls_CONSTANTES.EU001_STR_TOTAL_GANA_MAS
                                AND EU_001_tx_Atributo__c = :EU001_cls_CONSTANTES.EU001_STR_ATRIBUTO_GANA_MAS
                                GROUP BY EU_UG__c ORDER BY EU_UG__c];
                for(aggregateResult tab: registrosReporte0) { final String val = String.valueOf(tab.get('expr0'));final Decimal val0 = Decimal.valueOf(val);ganaMasReal.add(val0.setScale(1));valores.add(String.valueOf(val0.setScale(1))); }
            } else if(Concepto == EU001_CLS_CONSTANTES.EU001_STR_ATRIBUTO_GANA_MAS_POTENCIAL) {

                registrosReporte0 = [SELECT SUM(EU_001_Un_Valor__c), EU_UG__c
                                FROM ExpUni_Tablero_Grupal__c
                                WHERE EU_UG__c IN : equipoDOUG
                                AND EU_001_tx_Atributo__c IN (: EU001_CLS_CONSTANTES.EU001_STR_ATRIBUTO_GANA_MAS_POTENCIAL,
                                                            : EU001_CLS_CONSTANTES.EU001_STR_ATRIBUTO_GANA_MAS)
                                AND (NOT (EU_001_tx_Indicador__c = :EU001_cls_CONSTANTES.EU001_STR_TOTAL_GANA_MAS))
                                GROUP BY EU_UG__c ORDER BY EU_UG__c];
                valores = getValoresGanaMas(registrosReporte0);
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return valores;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          17-06-2019
* @Description  Get the string list with the values for the EU001_STR_PROMEDIO_DOR_POT concept.
* @Comments     Created from the clipped code block of method getObtieneValoresDGM.
* @param        List<ExpUni_Tablero_Grupal__c> registrosReporte
* @return       List<String>
* @example      public Static List<String> getValoresPromedioDorPot(List<ExpUni_Tablero_Grupal__c> registrosReporte) {
**/
    public Static List<String> getValoresPromedioDorPot(List<ExpUni_Tablero_Grupal__c> registrosReporte) {
        Integer count = 0;
        final List<String> valores = new List<String>();
        for(ExpUni_Tablero_Grupal__c tab: registrosReporte) {
            final Decimal varLoop = dorReal.size();
            final Decimal varSUM = tab.EU_001_Un_Valor__c;
            if(count<varLoop) {
                if(tab.EU_001_Un_Valor__c <= 0) {
                    valores.add(String.valueOf(0));
                } else {
                    Decimal valNew=0;
                    if(dorReal[count]<varSUM) {
                        valNew = (dorReal[count] - varSUM)*-1;
                    } else {
                        valNew = dorReal[count] - varSUM;
                    }
                    valores.add(String.valueOf(valNew));
                    }
                count++;
            }
        }
        return valores;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          17-06-2019
* @Description  Get the string list with the values for the EU001_STR_ATRIBUTO_GANA_MAS_POTENCIAL concept.
* @Comments     Created from the clipped code block of method getObtieneValoresDGM.
* @param        List<AggregateResult> registrosReporte
* @return       List<String>
* @example      public Static List<String> getValoresGanaMas(List<AggregateResult> registrosReporte) {
**/
    public Static List<String> getValoresGanaMas(List<AggregateResult> registrosReporte) {
        final List<String> valores = new List<String>();
        Integer count = 0;
        for(aggregateResult tab: registrosReporte) {
            final String val = String.valueOf(tab.get('expr0'));
            final Decimal val0 = Decimal.valueOf(val);
            final Decimal varLoop = ganaMasReal.size();
            if(count<varLoop) {
                if(val0 <= 0) {
                    valores.add(String.valueOf(0));
                } else {
                    final String valStr = String.valueOf(val0.setScale(1));
                    Decimal valNew = 0;
                    if(ganaMasReal[count]<Decimal.valueOf(valStr)) {
                        valNew = (ganaMasReal[count] - Decimal.valueOf(valStr))*-1;
                    } else {
                        valNew = ganaMasReal[count] - Decimal.valueOf(valStr);
                    }
                    valores.add(String.valueOf(valNew));
                    }
                    count++;
            }
        }
        return valores;
    }

    @AuraEnabled
    /** Lista getObtieneValores*/
    public Static List<String> getObtieneValores(String ownerUG, List<String> Indicador, String Concepto, Boolean banderaFiltro) {

        final List<String> valores = new List<String>();
        List<ExpUni_Tablero_Grupal__c> registrosReporte = new List<ExpUni_Tablero_Grupal__c> ();

        try {
            if(banderaFiltro) {
                registrosReporte = [SELECT EU_Indicador__c, EU_001_Un_Valor__c ,EU_001_tx_Atributo__c
                                                                    FROM ExpUni_Tablero_Grupal__c
                                                                    WHERE EU_UG__c=:ownerUG
                                                                    AND EU_001_tx_Indicador__c IN :Indicador
                                                                    AND EU_001_tx_Atributo__c = :Concepto
                                                                    ORDER BY EU_Indicador__c ];
            } else {
                registrosReporte = [SELECT EU_Indicador__c, EU_001_Un_Valor__c ,EU_001_tx_Atributo__c
                                                                    FROM ExpUni_Tablero_Grupal__c
                                                                    WHERE EU_UG__c=:ownerUG
                                                                    AND EU_Indicador__c IN :Indicador
                                                                    AND EU_001_tx_Atributo__c = :Concepto
                                                                    ORDER BY EU_Indicador__c ];
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }

        for(ExpUni_Tablero_Grupal__c tab: registrosReporte) { valores.add(String.valueOf(tab.EU_001_Un_Valor__c)); }

        return valores;
    }

    @AuraEnabled
    /** Lista getImpactoCompPrior*/
    public Static List<String> getImpactoCompPrior(String indicador, String ownerUG) {
        String tipoDirector;
        List<String> valores = new List<String>();
        User userId = new User();
        try {
            userId = [Select id, UserRole.Name From User Where UG__c =: ownerUG];
            if(userId.UserRole.Name.contains(EU001_CLS_CONSTANTES.EU001_DD_REFERENCIA)) {
                tipoDirector = 'DD';
            } else if(userId.UserRole.Name.contains(EU001_CLS_CONSTANTES.EU001_DR_REFERENCIA)||userId.UserRole.Name.contains(EU001_CLS_CONSTANTES.EU001_DR_REFERENCIA2)) {
                tipoDirector = 'DR';
            } else {
                tipoDirector = 'DO';
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        final List<String> usersUG = EU001_cls_CompHandler.getDOteamPromPonderados(String.valueOf(userId.Id), true, tipoDirector);
        List<EU_001_Compromiso__c> registrosReporte = new List<EU_001_Compromiso__c> ();
        try {
        registrosReporte = [SELECT EU_001_Fm_Impacto__c, EU001_ca_priorizado__c, EU001_Un_nivelPriorizacion__c
                            FROM EU_001_Compromiso__c
                            WHERE OwnerId IN :usersUG
                            AND EU_001_ls_Estatus__c IN (:EU001_cls_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO,
                                                         :EU001_cls_CONSTANTES.EU001_STR_COMPROMISO_REPROGRAMADO)
                            AND EU_001_ls_Indicadores_de_cartera__c =: indicador and MX_EU_Avance__c=false];
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        if(tipoDirector == 'DO') {
            valores = getValDO(registrosReporte);
        } else if (tipoDirector == 'DR') {
            valores = getValDR(tipoDirector, registrosReporte);
        } else if (tipoDirector == 'DD') {
            valores = getValDD(tipoDirector, registrosReporte);
        }
        return valores;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          13-06-2019
* @Description  Get the string list with the values for the method getImpactoCompPrior.
* @Comments     Created from the clipped code block of method getImpactoCompPrior.
* @param        List<EU_001_Compromiso__c> registrosReporte
* @return       List<String>
* @example      public Static List<String> getVal(List<EU_001_Compromiso__c> registrosReporte) {
**/
    public Static List<String> getValDO(List<EU_001_Compromiso__c> registrosReporte) {
        Decimal val = 0;
        Decimal val0 = 0;
        final List<String> valores = new List<String>();
        for(EU_001_Compromiso__c tab: registrosReporte) {
            if((tab.EU001_Un_nivelPriorizacion__c > 0 && tab.EU001_Un_nivelPriorizacion__c < 4) && tab.EU001_ca_priorizado__c && tab.EU_001_Fm_Impacto__c != null) {
                val = val + tab.EU_001_Fm_Impacto__c;
            } else if(tab.EU001_Un_nivelPriorizacion__c == null && !tab.EU001_ca_priorizado__c && tab.EU_001_Fm_Impacto__c != null) {
                val0 = val0 + tab.EU_001_Fm_Impacto__c;
            }
        }
        valores.add(String.ValueOf(val));
        valores.add(String.ValueOf(val0));
        return valores;
    }

    /**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          13-06-2019
* @Description  Get the string list with the values for the method getImpactoCompPrior.
* @Comments     Created from the clipped code block of method getImpactoCompPrior.
* @param        String tipoDirector, List<EU_001_Compromiso__c> registrosReporte
* @return       List<String>
* @example      public Static List<String> getVal(String tipoDirector, List<EU_001_Compromiso__c> registrosReporte) {
**/
    public Static List<String> getValDR(String tipoDirector, List<EU_001_Compromiso__c> registrosReporte) {
        Decimal val = 0;
        Decimal val0 = 0;
        final List<String> valores = new List<String>();
        for(EU_001_Compromiso__c tab: registrosReporte) {
            if((tab.EU001_Un_nivelPriorizacion__c == 2 || tab.EU001_Un_nivelPriorizacion__c == 3) && tab.EU001_ca_priorizado__c) {
                val = val + tab.EU_001_Fm_Impacto__c;
            } else if((tab.EU001_Un_nivelPriorizacion__c == 1 && tab.EU001_ca_priorizado__c)||(tab.EU001_Un_nivelPriorizacion__c == null && !tab.EU001_ca_priorizado__c)) {
                val0 = val0 + tab.EU_001_Fm_Impacto__c;
            }
        }
        valores.add(String.ValueOf(val));
        valores.add(String.ValueOf(val0));
        return valores;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          13-06-2019
* @Description  Get the string list with the values for the method getImpactoCompPrior.
* @Comments     Created from the clipped code block of method getImpactoCompPrior.
* @param        String tipoDirector, List<EU_001_Compromiso__c> registrosReporte
* @return       List<String>
* @example      public Static List<String> getVal(String tipoDirector, List<EU_001_Compromiso__c> registrosReporte) {
**/
    public Static List<String> getValDD(String tipoDirector, List<EU_001_Compromiso__c> registrosReporte) {
        Decimal val = 0;
        Decimal val0 = 0;
        final List<String> valores = new List<String>();
        for(EU_001_Compromiso__c tab: registrosReporte) {
            if(tab.EU001_Un_nivelPriorizacion__c == 3 &&  tab.EU001_ca_priorizado__c) {
                val = val + tab.EU_001_Fm_Impacto__c;
            } else if(((tab.EU001_Un_nivelPriorizacion__c == 1 || tab.EU001_Un_nivelPriorizacion__c == 2) && tab.EU001_ca_priorizado__c)||(tab.EU001_Un_nivelPriorizacion__c == null && !tab.EU001_ca_priorizado__c)) {
                val0 = val0 + tab.EU_001_Fm_Impacto__c;
            }
        }
        valores.add(String.ValueOf(val));
        valores.add(String.ValueOf(val0));
        return valores;
    }

    @AuraEnabled
    /** Lista getIndicadores*/
    public Static List<String> getIndicadores(String nombreReporte) {
        List<String> indicadores = new List<String>();
        try {
            if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_CARTERA_CP)) {
                indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_CP);
            } else if (nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_CARTERA_LP)) {
                indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_LP);
            } else if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_VISTA_MN) ) {
                indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_VISTA_MN);
            } else if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_INVERIONES)) {
                indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INVERSIONES);
            } else if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_INV_REST_CAPT)) {
                indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INV_REST_CAP);
            } else if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_CAPT_ME)) {
                indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_CAPTACION_ME);
            } else if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_RESTO)) {
                indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_RESTO_CAPTACION);
            } else {
                indicadores = getOtherIndicadores(nombreReporte);
            }
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return indicadores;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          18-06-2019
* @Description  Get indicators for other reports.
* @Comments     Created from the clipped code block of method getIndicadores.
* @param        String nombreReporte
* @return       List<String>
* @example      List<String> getOtherIndicadores(String nombreReporte) {
**/
    public Static List<String> getOtherIndicadores(String nombreReporte) {
        final List<String> indicadores = new List<String>();
        if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_INF_RECURRENTES)) {
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INF_RECURRENTES);
        } else if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_INF_NO_RECURRENTES)) {
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INF_NO_RECURRENTES);
        } else if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_MARGEN)) {
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_MARGEN_BRUTO);
        } else if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_STOCK_NOMINA)) {
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_STOCK_NOMINA);
        } else if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_CERTIFICACION_EU)
                || nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_GESTION_COMERCIAL)) {
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU);
        } else if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POR_EJECUTIVO)) {
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_TOTAL_PUNTOS_DOR);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_TOTAL_DOR_POTENCIAL);
        } else if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POTENCIAL_POR_EJECUTIVO)) {
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_ATRIBUTO_GANA_MAS);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_ATRIBUTO_GANA_MAS_POTENCIAL);
        } else {
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_CP);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_LP);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_VISTA_MN);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INV_REST_CAP);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INVERSIONES);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_CAPTACION_ME);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_RESTO_CAPTACION);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INF_RECURRENTES);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INF_NO_RECURRENTES);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_MARGEN_BRUTO);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_STOCK_NOMINA);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_USUARIO_NUEVO_CREDITO);
        }
        return indicadores;
    }

/*
*Obtiene la lista de agrupadores para los gráficos
*de la vista
*03-43-2018 @Abraham Tinajero: Se eliminan conceptos de grafico de Certificación EU
*27-09-2018 @César Villanueva: Eliminación de indicadores "Cuentas" y "Visitas Seguimiento" en gráficas de Certificación EU
*------------------------------------------------------------
*@Return    Lista de String de agrupadores
*/
    @AuraEnabled
    public Static List<String> getAgrupadores(String subFijo, String nombreReporte) {
        List<String> indicadores = new List<String>();
        try {
            if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_CERTIFICACION_EU)) {
                indicadores.add(EU001_CLS_CONSTANTES.EU001_CONCEPTO_RI);
                indicadores.add(EU001_CLS_CONSTANTES.EU001_CONCEPTO_VISITAS);
                indicadores.add(EU001_CLS_CONSTANTES.EU001_CONCEPTO_OPP);
                indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_E_PLAN_CUENTA);
            } else if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_GESTION_COMERCIAL)) {
                indicadores.add(EU001_CLS_CONSTANTES.EU001_CONCEPTO_VISITAS);
                indicadores.add(EU001_CLS_CONSTANTES.EU001_CONCEPTO_VISITAS_ESTRA);
                indicadores.add(EU001_CLS_CONSTANTES.EU001_CONCEPTO_VISITAS_COMER);
                indicadores.add(EU001_CLS_CONSTANTES.EU001_CONCEPTO_DETALLE_OP);
                indicadores.add(EU001_CLS_CONSTANTES.EU001_CONCEPTO_DETALLE_PC);
            } else {
                indicadores = getOtherAgrupadores(subFijo, nombreReporte);
            }
        } catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return indicadores;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          18-06-2019
* @Description  Get agrupadores for other reports.
* @Comments     Created from the clipped code block of method getAgrupadores.
* @param        String subFijo, String nombreReporte
* @return       List<String>
* @example      public Static List<String> getOtherAgrupadores(String subFijo, String nombreReporte) {
**/
    public Static List<String> getOtherAgrupadores(String subFijo, String nombreReporte) {
        final List<String> indicadores = new List<String>();
        if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POR_EJECUTIVO)
            || nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POTENCIAL_POR_EJECUTIVO)) {
            final List<User> equipoDirector = getTeamDirector(UserUG);
            for(User tab: equipoDirector) { indicadores.add(tab.Name); }
        } else if(nombreReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_GANA_MAS_INDICADOR)) {
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_CARTERA_CP_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_CARTERA_LP_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_VISTA_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INVERSIONES_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INF_RECURRENTES_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INF_NO_RECURRENTES_CONCEPTO + subFijo);
        } else {
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_CARTERA_CP_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_CARTERA_LP_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_CARTERA_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_VISTA_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INVR_CAPTACION + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INVERSIONES_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_REST_CAPTACION + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_RESTO_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INF_RECURRENTES_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_INF_NO_RECURRENTES_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_MARGEN_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_STOCK_NOMINA_CONCEPTO + subFijo);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_NVOS_USARIOS_CONCEPTO + subFijo);
        }
        return indicadores;
    }

    @AuraEnabled
    /** Lita getConceptos*/
    public Static List<String> getConceptos(String tipoReporte) {
        List<String> concepto = new List<String>();
        try {
            if(tipoReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_LOGRO_POR_INDICADOR)
                || tipoReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_COMPROMISO_EJECUTIVO)) {
                concepto.add(EU001_CLS_CONSTANTES.EU001_STR_LOGRO);
                concepto.add(EU001_CLS_CONSTANTES.EU001_STR_LOGRO_POTENCIAL);
            } else if(tipoReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POR_INDICADOR)) {
                concepto.add(EU001_CLS_CONSTANTES.EU001_STR_PUNTOS_DOR);
                concepto.add(EU001_CLS_CONSTANTES.EU001_STR_PUNTOS_POTENCIALES_DOR);
            } else if(tipoReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_GANA_MAS_INDICADOR)) {
                concepto.add(EU001_CLS_CONSTANTES.EU001_STR_ATRIBUTO_GANA_MAS);
                concepto.add(EU001_CLS_CONSTANTES.EU001_STR_ATRIBUTO_GANA_MAS_POTENCIAL);
            } else if(tipoReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_CERTIFICACION_EU)
                    || tipoReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_GESTION_COMERCIAL)) {
                concepto.add(EU001_CLS_CONSTANTES.EU001_STR_LOGRO);
                concepto.add(EU001_CLS_CONSTANTES.EU001_STR_GAP);
            } else {
                concepto = getOtherConcepts(tipoReporte);
            }
        } catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return concepto;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          18-06-2019
* @Description  Get concepts for other report types.
* @Comments     Created from the clipped code block of method getConceptos.
* @param        String tipoReporte
* @return       List<String>
* @example      public static List<User> getFuncionDelUsuario(Boolean grfVal) {
**/
    public Static List<String> getOtherConcepts(String tipoReporte) {
        final List<String> concepto = new List<String>();
        String conceptoRA = '';
        if(tipoReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_ALERTAS_INCENTIVADAS) ||
            tipoReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_PLAN_CHOQUE)) {
            concepto.add(EU001_CLS_CONSTANTES.EU001_STR_GESTION);
            concepto.add(EU001_CLS_CONSTANTES.EU001_STR_SIN_GESTION);
        } else if(tipoReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_TOTAL_COMPROMISO) ) {
            concepto.add(EU001_CLS_CONSTANTES.EU001_STR_PRIORIZADO);
            concepto.add(EU001_CLS_CONSTANTES.EU001_STR_SIN_PRIORIZAR);

        } else if(tipoReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POR_EJECUTIVO) ) {
            concepto.add(EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR);
            concepto.add(EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR_POT);
        } else if(tipoReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DOR_POTENCIAL_POR_EJECUTIVO) ) {
            concepto.add(EU001_CLS_CONSTANTES.EU001_STR_ATRIBUTO_GANA_MAS);
            concepto.add(EU001_CLS_CONSTANTES.EU001_STR_ATRIBUTO_GANA_MAS_POTENCIAL);
        } else if(tipoReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_APOYOS) ) {
            concepto.add('Abierto');
            concepto.add('Aprobada');
            concepto.add('Rechazada');
            concepto.add('Reprogramado');
        } else {
            if(tipoReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_CARTERA_CP) || tipoReporte.equals(EU001_CLS_CONSTANTES.EU001_REPORTE_DETALLE_CARTERA_LP)) {
                conceptoRA = EU001_CLS_CONSTANTES.EU001_STR_REAL_AMORT;
            } else {
                conceptoRA = EU001_CLS_CONSTANTES.EU001_STR_REAL_C;
            }
            concepto.add(EU001_CLS_CONSTANTES.EU001_STR_REAL);
            concepto.add(EU001_CLS_CONSTANTES.EU001_STR_GAP);
            concepto.add(conceptoRA);
            concepto.add(EU001_CLS_CONSTANTES.EU001_STR_IMPACTO_COMPROMISOS);
            concepto.add(EU001_CLS_CONSTANTES.EU001_STR_GAP_AJUSTADO);
        }
        return concepto;
    }

    @AuraEnabled
    /** Lista getAgrupadoresDetalle*/
    public Static List<String> getAgrupadoresDetalle() {
        final List<String> indicadores = new List<String>();
        try {
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_REAL_TAB);
            indicadores.add(EU001_CLS_CONSTANTES.EU001_STR_REAL_COMPROMISOS);
        } catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return indicadores;
    }

/*@Descripción
* Obtiene el listado del equipo del Director
*------------------------------------------------------------
* @Return lista de ejecutivos del dueño de la RI según jerarquía.
* Autor: Javier Ortiz Flores
*/
    @AuraEnabled
    public static List<User> getTeamDirector(String OwnerUg) {
        final List<User> equipoDO= new List<User>();
        final List<String> roleIds= new List<String>();
        List<UserRole> rolesDir = new List<UserRole>();
        List<User> equipo = new List<User>();
        try {
            final  String myPosition = [SELECT UserRoleId FROM User WHERE UG__c = : OwnerUg][0].UserRoleId;
            rolesDir = [SELECT Id FROM UserRole WHERE parentroleid =: myPosition];
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        } if(!rolesDir.isEmpty()) {
            for(UserRole roles: rolesDir) {
                roleIds.add(roles.Id); } }
        try {
            equipo = [SELECT Id, UG__c, Name, No_de_nomina__c FROM User WHERE UserRoleId IN: roleIds AND IsActive = True and (NOT Profile.Name LIKE :EU001_CLS_CONSTANTES.EU001_GERENTE_REFERENCIA_MAY) AND (NOT (UG__c = '')) ORDER BY UG__c];
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        if(!equipo.isEmpty()) {
            for(User eq : equipo) {
                equipoDO.add(eq);
            }
        }
    return equipoDO;
    }

    @AuraEnabled
    /** Lista getTeamDirectorDO*/
    public static List<User> getTeamDirectorDO(String OwnerUg) {
        final List<User> equipoDO = new List<User>();
        final List<String> roleIds = new List<String>();
        List<UserRole> rolesDir = new List<UserRole>();
        List<User> equipo = new List<User>();
        try {
            final String myPosition = [SELECT UserRoleId FROM User WHERE UG__c = : OwnerUg][0].UserRoleId;
            rolesDir = [SELECT Id FROM UserRole WHERE parentroleid =: myPosition];
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
            catch(ListException e) {
                throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        if(!rolesDir.isEmpty()) {
            for(UserRole roles: rolesDir) {
                roleIds.add(roles.Id); } }
        try {
            equipo = [SELECT Id, UG__c, Name, No_de_nomina__c FROM User WHERE (UserRoleId IN: roleIds OR UG__c =:OwnerUg) AND IsActive = True and (NOT Profile.Name LIKE :EU001_CLS_CONSTANTES.EU001_GERENTE_REFERENCIA_MAY) AND (NOT (UG__c = '')) ORDER BY UG__c];
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        } if(!equipo.isEmpty()) {
            for(User eq : equipo) {
                equipoDO.add(eq);
            }
        }
    return equipoDO;
    }

    @AuraEnabled
    /** Lista getTotalApoyos*/
    public Static List<List<String>> getTotalApoyos(String ownerId) {
        final List<EU001_cls_ConsolaDirector.WRP_Table> wrUser = getTable(false);
        final List<Id> usersUG = new List<Id>();

        for(EU001_cls_ConsolaDirector.WRP_Table usuarios : wrUser) {
            if(usuarios.Acc.UG__c != UserUG) {
                usersUG.add(usuarios.Acc.Id);
                } }

        final List<List<String>> valores = new List<List<String>>();
        final List<String> valor = new List<String>();
        final List<String> agrupador = new List<String>();
        final List<String> leyenda = new List<String>();
        List<aggregateResult> registrosReporte = new List<aggregateResult> ();
        final Id idRTVisitas = RecordTypeMemory_cls.getRecType('Case', 'Apoyos');
        try {
            final EU001_RI__c selectedRI = [SELECT OwnerId FROM EU001_RI__c WHERE Id =: ownerId];
            registrosReporte = [SELECT Count(Id), STATUS
                                FROM Case
                                WHERE OwnerId =:selectedRI.OwnerId
                                AND recordtypeId =: idRTVisitas
                                GROUP BY status
                                ORDER BY status];
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        for(aggregateResult tab: registrosReporte) {
            valor.add(String.valueOf(tab.get('expr0')));
        }
        for(aggregateResult tab: registrosReporte) {
            agrupador.add('');
            leyenda.add(String.valueOf(tab.get('STATUS')));
        }
        valores.add(leyenda);
        valores.add(agrupador);
        valores.add(valor);
        return valores;
    }

    @AuraEnabled
    /** Lista*/
    public static list<EU001_cls_ConsolaDirector.WRP_Table> getTable(Boolean grfVal) {
        final Set<Id> UsuariosAbajo = new Set<Id>();
        final Set<Id> UserListToRI = new Set<Id>();
        final map<Id, EU001_cls_ConsolaDirector.WRP_Table> mapResult = new map<Id, EU001_cls_ConsolaDirector.WRP_Table>();
        List<User> funcionDelUsuario = new List<User>();
        try {
            funcionDelUsuario = getFuncionDelUsuario(grfVal);
            System.debug('userUG: ' + userUG);
            final List<UserRole> NivelAbajoFuncion = ([SELECT Name, Id, ParentRoleId FROM UserRole WHERE ParentRoleId =: funcionDelUsuario[0].UserRoleId]);
            if(NivelAbajoFuncion.isEmpty()) {
                UserListToRI.add(userInfo.getUserId());
            } else if(!NivelAbajoFuncion.isEmpty()) {
                for(UserRole IteraUrole : NivelAbajoFuncion) {
                    UsuariosAbajo.add(IteraURole.Id);
                }
                for(User IteraUsuarios : [Select Id, Name, UserRoleId,Segmento_Ejecutivo__c from User where UserRoleId IN: UsuariosAbajo AND isActive=:true]) {
                    UserListToRI.add(IteraUsuarios.Id);
                }
            }

            for(EU001_RI__c  ls :[SELECT OwnerId, Name, Id, EU001_tx_Estado__c, EU001_ft_Fecha_Inicio__c, EU001_ft_Fecha_Cierre__c, EU001_fm_UG_Propietario__c FROM EU001_RI__c WHERE ownerid =: UserListToRI or ownerid =: userInfo.getUserId()]) {
                if(mapResult.containsKey(ls.OwnerId)) {
                    mapResult.get(ls.OwnerId).lsOpp.add(ls);
                } else {
                    mapResult.put(ls.OwnerId, new EU001_cls_ConsolaDirector.WRP_Table(new User(Id = ls.OwnerId, UG__c = ls.EU001_fm_UG_Propietario__c), new list<EU001_RI__c>{ls}));
                }
            }

            final map<Id, User> mapAccont = new map<Id, User>([Select Id, Liga__c, Name, UG__c,Segmento_Ejecutivo__c from User where id IN: mapResult.keySet()]);

            for(EU001_cls_ConsolaDirector.WRP_Table tmp : mapResult.values()) {
                mapResult.get(tmp.Acc.Id).Acc = mapAccont.get(tmp.Acc.Id);
            }
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return mapResult.values();
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          17-06-2019
* @Description  Get the user role.
* @Comments     Created from the clipped code block of method getTable.
* @param        Boolean grfVal
* @return       List<User>
* @example      public static List<User> getFuncionDelUsuario(Boolean grfVal) {
**/
    public static List<User> getFuncionDelUsuario(Boolean grfVal) {
        List<User> funcionDelUsuario = new List<User>();
        if(grfVal) {
            funcionDelUsuario = ([SELECT Id, Name, UserRoleId,Segmento_Ejecutivo__c FROM User WHERE UG__c =: userUG LIMIT 1]);
        } else {
            funcionDelUsuario = ([SELECT Id, Name, UserRoleId,Segmento_Ejecutivo__c FROM User WHERE Id =: userInfo.getUserId() LIMIT 1]);
        }
        return funcionDelUsuario;
    }

    @AuraEnabled
    /** Metodo*/
    public static void getEsDO(String ownerUG) {
        final String myPosition = [Select UserRoleId From User Where UG__c = : ownerUG][0].UserRoleId;
        final List<UserRole> role1 = [SELECT Id, Name FROM UserRole WHERE parentroleid =:myPosition ];
        final List<String> roleIds= new List<String>();
        if(!role1.isEmpty()) {

            for(UserRole roles: role1) {
                roleIds.add(roles.Id);
            }
            List<User> equipo = new List<User>();
            try {
                equipo = [Select Id, UG__c, No_de_nomina__c,EU001_pr_Calificaci_n_Certificaci_n_EU__c, EG001_ls_Certificacion_EU__c,Name from User where UserRoleId IN: roleIds AND IsActive = True];
            } catch(QueryException e) {
                throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
            }
            if(equipo.size()>0) {
                for(User eq : equipo) {
                    equipoDO.add(eq.Id);
                    equipoDOUG.add(eq.UG__c);
                    equipoDONC.add(eq.No_de_nomina__c);
                    equipoDOUSR.add(eq);
                }
            }
        }
    }

    @AuraEnabled
    /** Metodo getInforme*/
    public static String getInforme(String NomInforme) {
        final Report Informe = Test.isRunningTest() ? new Report() : [SELECT Id FROM Report WHERE developername =: NomInforme];
        Reports.ReportResults reportResult;
        string resulend = '';
        try {
            if(!Test.isRunningTest()) {
            reportResult = Reports.ReportManager.runReport(Informe.Id, true);
            }
            resulend = Test.isRunningTest() ? '{}' : JSON.serialize(reportResult);
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return resulend;
    }

}