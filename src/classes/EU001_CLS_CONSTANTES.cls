/**
*Desarrollado por:       Indra
*Autor:                  Abraham Alfonso Tinajero Sanchez
*Proyecto:               Experiencia Unica
*Descripción:            Clase repositorio de variables constantes
*
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 23-08-2017     |    Abraham Tinajero      |           Creación     
*1.1    | 29-08-2017     |    Monserrat Gonzalez    |           Se agrego constante
*1.2    | 09-03-2018     |    Francisco J Licona    |           Se agregaron constantes
*1.3    | 12-03-2018     |    Abraham Tinajero      |       Se agregaron constantes y corrigen errores de sonar
*1.4    | 27-03-2018     |    Francisco J Licona    |       Se agregaron constantes para directores
*1.5    | 09-04-2018     |    Francisco J Licona    |       Se agregaron constantes para gerentes
*1.6    | 24-04-2018     |    Abraham Tinajero      |       Se agregaron constantes para Ligas de DO/EC
*1.7    | 07-08-2018     |  Ricardo Hernandez       |       Se Agrega la constante para Oportunidades de Pipeline Financiamiento.
*1.8    | 06-09-2018     |  Ricardo Hernandez       |       Se Agrega la constante para Oportunidades de Pipeline disposición.
*2.0	| 14-09-2018	 |  Francisco J Licona	    |	    Se agregan variables para cintillo dinámico.
*2.1    | 17-10-2018     |  Fernando Jaime          |       Se cambia Administrador del sistema por etiqueta personalizada
*2.2    | 25-10-2018     |  César Villanueva        |       Agregado valor USAC Cierre
*2.3	| 01-11-2018	 | 	 Adrian Pastor			| Se Agregan constantes para arrendamiento puro/financiero
**/
public class EU001_CLS_CONSTANTES {
    //Constantes Experiencia Única
    /** Función director Red*/
    public static final String EU001_STR_FUNCION_STAFFCENTRAL = 'BPYP STAFF DIRECCIÓN BANCA';
    /** Indicador Cartera Vigente CP*/
    public static final String EU001_STR_CARTERA_VIGENTE_CP = 'Cartera Vigente CP';
    /**Indicador Cartera vigente LP  */
    public static final String EU001_STR_CARTERA_VIGENTE_LP = 'Cartera Vigente LP';
    /**Indicador Cartera vigente */
    public static final String EU001_STR_CARTERA_VIGENTE = 'Cartera Vigente';
    /**Indicador Vista MN */
    public static final String EU001_STR_VISTA_MN = 'Vista MN';
    /**Indicador Inversiones */
    public static final String EU001_STR_INVERSIONES = 'Inversiones';
    /**Indicador Resto Captacion */
    public static final String EU001_STR_RESTO_CAPTACION = 'Resto Captacion';
    /**Indicador Resto Captacion */
    public static final String EU001_STR_RESTO_CAPTACION_ACENTO = 'Resto Captación';
    /**Indicador INF Recurrentes */
    public static final String EU001_STR_INF_RECURRENTES = 'INF Recurrentes';
    /**Indicador INF No Recurrentes  */
    public static final String EU001_STR_INF_NO_RECURRENTES = 'INF No Recurrentes';
    /**Indicador Margen Bruto */
    public static final String EU001_STR_MARGEN_BRUTO = 'Margen Bruto';
    /**Indicador Stock Nomina */
    public static final String EU001_STR_STOCK_NOMINA = 'Stock Nomina';
    /**Indicador Saneamiento */
    public static final String EU001_STR_SANEAMIENTO = 'Saneamiento';
    /**Indicador Nvos usuarios de credito */
    public static final String EU001_STR_USUARIO_NUEVO_CREDITO = 'Nvos usuarios de credito';
    /** Indicador Usuario Nvo de Credito*/
    public static final String EU001_STR_USUARIO_CREDITO = 'Usuario Nvo de Credito';
    /**Indicador Acciones comerciales */
    public static final String EU001_STR_ACCIONES_COMERCIALES = 'Acciones Comerciales';
    /**Indicador Experiencia Unica */
    public static final String EU001_STR_EXPERIENCIA_UNICA = 'Experiencia Unica';
    /**Indicador Control Interno */
    public static final String EU001_STR_CONTROL_INTERNO = 'Control Interno';
    /** Indicador Auditoria*/
    public static final String EU001_STR_AUDITORIA = 'Auditoria';
    /** Indicador Impagos*/
    public static final String EU001_STR_IMPAGOS = 'IMPAGOS';
    /** Indicador Gasto por division*/
    public static final String EU001_STR_GASTO_DIVISION = 'Gasto por Division';
    /**Indicador Expediente digital */
    public static final String EU001_STR_EXPEDIENTE_DIGITAL = 'Expediente Digital';
    /**Indicador Visitas */
    public static final String EU001_STR_VISITAS = 'Visitas';
    /** Indicador Oportunidades*/
    public static final String EU001_STR_OPORTUNIDADES = 'Oportunidades';
    /** Indicador Cerrada Ganada*/
    public static final String EU001_STR_OPORT_CERRADAGANADA = 'Cerrada Ganada';
    /** Indicador Certificacion EU*/
    public static final String EU001_STR_CERTIFICACION_EU='Certificacion EU';
    /**Indicador Total Ptos DOR */
    public static final String EU001_STR_TOTAL_PUNTOS_DOR='Total Ptos DOR';
    /** Indicador Total Gana Mas*/
    public static final String EU001_STR_TOTAL_GANA_MAS ='Total Gana Mas';
    /** Indicador Experiencia Unica*/
    public static final String EU001_STR_EXP_UNICA = 'Experiencia Única';
    /** Indicador Inversiones + Resto Captacion*/
    public static final String EU001_STR_INV_REST_CAP = 'Inversiones + Resto Captacion';
    /** Indicador Captacion ME*/
    public static final String EU001_STR_CAPTACION_ME = 'Captacion ME';
    /** Indicador EU001_Dor_Potencial_por_Ejecutivo*/
    public static final String EU001_REPORTE_DOR_POTENCIAL_POR_EJECUTIVO = 'EU001_Dor_Potencial_por_Ejecutivo';

    /** Compromisos*/
    /**07-03-2018 Abraham Tinajero: se agregan los estatus de Hecho y Descartado de los compromisos */
    public static final String EU001_STR_COMPROMISO_ABIERTO = 'Abierto';
    /**Estatus abiertos y reprogramados */
    public static final String EU001_STR_COMPROMISO_ABIERTOREPROGRAMADO = 'Abiertos y Reprogramados';
    /** Estatus vencido*/
    public static final String EU001_STR_COMPROMISO_VENCIDO = 'Vencido';
    /** estatus hecho*/
    public static final String EU001_STR_COMPROMISO_HECHO = 'Hecho';
    /** Estatus Descartado*/
    public static final String EU001_STR_COMPROMISO_DESCARTADO = 'Descartado';
    /** Estatus Reprogramado*/
    public static final String EU001_STR_COMPROMISO_REPROGRAMADO = 'Reprogramado';
    /** Compromiso Cartera*/
    public static final String EU001_STR_COMPROMISO_CARTERA = 'Compromiso Cartera';
    /** Compromiso Captacion*/
    public static final String EU001_STR_COMPROMISO_CAPTACION = 'Compromiso Captación';
    /** Compromiso General*/
    public static final String EU001_STR_COMPROMISO_GENERAL = 'Compromiso General';
    /** Compromiso INFNoRec*/
    public static final String EU001_STR_COMPROMISO_IFN_NO_RECURRENTES = 'Compromiso INFNoRec';
    /** Compromiso INFRect*/
    public static final String EU001_STR_COMPROMISO_IFN_RECURRENTES = 'Compromiso INFRec';
    /** Compromiso Nuevo Usuarios*/
    public static final String EU001_STR_COMPROMISO_NVOS_USUARIOS = 'Compromiso Nuevos Usuarios';
    /** Compromiso Stock Nomina*/
    public static final String EU001_STR_COMPROMISO_STOCK_NOMINA = 'Compromiso Stock Nomina';
    /** Saneamiento*/
    public static final String EU001_STR_COMPROMISO_SANEAMIENTO = 'Saneamiento';

    /**JERARQUIAS DE DIRECTOR */
    public static final String EU001_DO_REFERENCIA = 'DIRECTOR DE OFICINA';
    /** Jerarquia Director de Regional */
    public static final String EU001_DR_REFERENCIA = 'DIRECTOR DE REGIONAL';
    /** Jerarquia Director Regional */
    public static final String EU001_DR_REFERENCIA2 = 'DIRECTOR REGIONAL';
    /** Jerarquia DIVISI*/
    public static final String EU001_DD_REFERENCIA = 'DIVISI';
    /** Jerarquia EJECUTIVO*/
    public static final String EU001_EC_REFERENCIA = 'EJECUTIVO';
    /** Jerarquia STAFF*/
    public static final String EU001_DRED_REFERENCIA = 'STAFF';
    /**Jerarquia %GERENTE% */
    public static final String EU001_GERENTE_REFERENCIA_MAY = '%GERENTE%';

    /** Revisión Individual*/
    /** Preparacion */
    public static final String EU001_STR_RI_PREPARACION  = 'Preparación';
    /**Presentación  */
    public static final String EU001_STR_RI_PRESENTACION = 'Presentación';
    /** Evaluacion*/
    public static final String EU001_STR_RI_TERMINADO = 'Evaluacion';
    /** Presentación*/
    public static final String EU001_STR_RI_PENDIENTE_PRESENTACION = 'Presentación';
    /** Evaluacion */
    public static final String EU001_STR_RI_EVALUACION = 'Evaluacion';
    /** Finalizacion */
    public static final String EU001_STR_RI_FINALIZACION = 'Finalizacion';
    /** Reunión Individual*/
    public static final String EU001_STR_META_RI = 'Reunión Individual';
    /** Promoción */
    public static final String EU001_STR_PROMOCION = 'Promoción';
    /** PromociOn*/
    public static final String EU001_STR_PROMOCION_2 = 'PromociOn';

    /** Alertas*/
    /** Alerta Incentivada*/
    public static final String EU001_STR_ALERTACRM_ALERTA_INCENTIVADA = 'Alerta Incentivada';
    /**Plan de choque */
    public static final String EU001_STR_ALERTACRM_PLAN_DE_CHOQUE = 'Plan de Choque';
    /**Resto plan de choque */
    public static final String EU001_STR_ALERTACRM_RESTO_PLAN_DE_CHOQUE = 'Resto Plan de Choque';
    /** Limites*/
    public static final String EU001_STR_ALERTACRM_LIMITES = 'Límites';
    /** Desvinculacion*/
    public static final String EU001_STR_ALERTACRM_DESVINCULACION = 'Desvinculación';
    /** G500*/
    public static final String EU001_STR_ALERTACRM_G500 = 'G500';
    /** Proximos vencimientos*/
    public static final String EU001_STR_ALERTACRM_PROXIMOS_VENCIMIENTOS = 'Próximos Vencimientos';
    /** Ratings*/
    public static final String EU001_STR_ALERTACRM_RAITINGS = 'Ratings';
    /** Gestión Obligatoria*/
    public static final String EU001_STR_ALERTACRM_GESTION_OBLIGATORIA = 'Gestión Obligatoria';
    /** Asignado a Central para cierre*/
    public static final String EU001_STR_ALERTACRM_ASIGNADOS_CENTRAL_CIERRE = 'Asignado a Central para cierre';

    //Errores
    /** Insertar*/
    public static final String EU001_STR_ERR_SIN_UG_INSERT = 'La UG no tiene Ejecutivo Asignado (insertar)';
    /**Actualizar */
    public static final String EU001_STR_ERR_SIN_UG_UPDATE = 'La UG no tiene Ejecutivo Asignado (Actualizar) ';

    //Tablero
    /**A) Real */
    public static final String EU001_STR_REAL = 'A) Real';
    /** A) Real complemento*/
    public static final String EU001_STR_REAL_A_COMPLEMENTO = 'A) Real complemento';
    /**C) Real complemento */
    public static final String EU001_STR_REAL_C_COMPLEMENTO = 'C) Real complemento';
    /** C) Real - Amort*/
    public static final String EU001_STR_REAL_AMORT = 'C) Real - Amort';
    /** C) Real */
    public static final String EU001_STR_REAL_C = 'C) Real';
    /** Real ajustado*/
    public static final String EU001_STR_REAL_AJUSTADO = 'Real Ajustado';
    /**Amortizacion */
    public static final String EU001_STR_AMORT = 'Amortizacion';
    /** B) Gap*/
    public static final String EU001_STR_GAP = 'B) Gap';
    /** E) Gap proyectado*/
    public static final String EU001_STR_GAP_PROY = 'E) Gap proyectado';
    /** B) Gap complemento*/
    public static final String EU001_STR_GAP_COMPLEMENTO = 'B) Gap complemento';
    /** E) Gap proyectado NR*/
    public static final String EU001_STR_GAP_PROY_NR = 'E) Gap proyectado NR';
    /** A) Puntos */
    public static final String EU001_STR_PUNTOS_DOR = 'A) Puntos';
    /** A) Logros */
    public static final String EU001_STR_LOGRO = 'A) Logro';
    /**presupuesto */
    public static final String EU001_STR_PRESUPUESTO = 'Presupuesto';
    /**D) Compromisos */
    public static final String EU001_STR_IMPACTO_COMPROMISOS = 'D) Compromisos';
    /** Backlog*/
    public static final String EU001_STR_BACKLOG = 'Backlog';
    /** B) Logro potencial*/
    public static final String EU001_STR_LOGRO_POTENCIAL = 'B) Logro potencial';
    /** B) puntos potenciales*/
    public static final String EU001_STR_PUNTOS_POTENCIALES_DOR = 'B) Puntos potenciales';
    /** C) Puntos maximos*/
    public static final String EU001_STR_PUNTOS_MAXIMOS_DOR = 'C) Puntos maximos';
    /** E) Gap proyectado*/
    public static final String EU001_STR_GAP_AJUSTADO = 'E) Gap proyectado';
    /** ptos DOR*/
    public static final String EU001_STR_TOTAL_PTOS_DOR = 'Ptos DOR';
    /**Puntos */
    public static final String EU001_STR_TOTAL_PTOS = 'Puntos';
    /** Peso*/
    public static final String EU001_STR_ATRIBUTO_PESO = 'Peso';
    /** C) Logro potencial backlog*/
    public static final String EU001_STR_POTENCIL_BACKLOG = 'C) Logro potencial backlog';
    /** Margen*/
    public static final String EU001_STR_MARGEN = 'Margen';
    /** total Dor potencial*/
    public static final String EU001_STR_TOTAL_DOR_POTENCIAL = 'Total Dor Potencial';
    /** Ptos individuales*/
    public static final String EU001_STR_TOTAL_PTOS_INDIVIDUALES = 'Ptos Individuales';
    /** Ranking Potencial*/
    public static final String EU001_STR_RANKING_PTCIAL = 'Ranking Potencial';
    /** DOR*/
    public static final String EU001_STR_PROMEDIO_DOR = 'DOR';
    /** DOR potencial*/
    public static final String EU001_STR_PROMEDIO_DOR_POT = 'DOR potencial';
    /** Gana mas*/
    public static final String EU001_STR_PROMEDIO_GANA_MAS = 'Gana más';
    /** Gana más potencial*/
    public static final String EU001_STR_PROMEDIO_GANA_MAS_POT = 'Gana más potencial';

    //VARIABLES PARA CONCEPTO DE TABLERO
    /** */
    public static final String EU001_STR_PUNTOS_DOR_SAVE = 'DOR CNT';
    /** */
    public static final String EU001_STR_RANKING_VV_SAVE = 'RANKING CNT';
    /** */
    public static final String EU001_STR_ACOMERCIALES_SAVE = 'Acciones Comerciales CNT';
    /** */
    public static final String EU001_STR_COMPVIGENTES_SAVE = 'Compromisos Vigentes CNT';
    /** */
    public static final String EU001_STR_COMPVENCIDOS_SAVE = 'Compromisos Vencidos CNT';
    /** */
    public static final String EU001_STR_GMASPOTENCIAL_SAVE = 'Gana Mas Potencial CNT';
    /** */
    public static final String EU001_STR_PCHOQUE_SAVE = 'Plan de Choque CNT';
    /** */
    public static final String EU001_STR_APOYOABIERTO_SAVE = 'Apoyo abierto CNT';
    /** */
    public static final String EU001_STR_APOYOVENCIDO_SAVE = 'Apoyo vencido CNT';
    /** FIN VARIABLES PARA CONCEPTO DE TABLERO*/
    /** Gana mas*/
    public static final String EU001_STR_ATRIBUTO_GANA_MAS = 'A) Gana Mas';
    /** Gana mas potencial*/
    public static final String EU001_STR_ATRIBUTO_GANA_MAS_POTENCIAL = 'B) Gana Mas Potencial';

    /** A. Cartera CP G+*/
    public static final String EU001_STR_CARTERA_CP_ATRIBUTO ='A. Cartera CP G+';
    /** B. Cartera LP G+*/
    public static final String EU001_STR_CARTERA_LP_ATRIBUTO ='B. Cartera LP G+';
    /**G. INF Recurrentes G+ */
    public static final String EU001_STR_INF_RECURRENTES_ATRIBUTO ='G. INF Recurrentes G+';
    /** H. INF No Recurrentes G+*/
    public static final String EU001_STR_INF_NO_RECURRENTES_ATRIBUTO ='H. INF No Recurrentes G+';
    /** E. Inversiones G+*/
    public static final String EU001_STR_INVERSIONES_ATRIBUTO ='E. Inversiones G+';
    /** D. Vista MN G+*/
    public static final String EU001_STR_VISTA_ATRIBUTO ='D. Vista MN G+';

    /** */
    public static final String EU001_STR_CARTERA_CP_CONCEPTO = 'A. Cartera CP';
    /** */
    public static final String EU001_STR_CARTERA_LP_CONCEPTO = 'B. Cartera LP';
    /** */
    public static final String EU001_STR_CARTERA_CONCEPTO = 'C. Cartera';
    /** */
    public static final String EU001_STR_VISTA_CONCEPTO = 'D. Vista MN';
    /** */
    public static final String EU001_STR_INVR_CAPTACION = 'E. Inv. + Resto Cap.';
    /** */
    public static final String EU001_STR_INVERSIONES_CONCEPTO = 'F. Inversiones';
    /** */
    public static final String EU001_STR_REST_CAPTACION = 'G. Captacion ME';
    /** */
    public static final String EU001_STR_RESTO_CONCEPTO = 'H. Resto Captacion';
    /** */
    public static final String EU001_STR_INF_RECURRENTES_CONCEPTO = 'I. INF Recurrentes';
    /** */
    public static final String EU001_STR_INF_NO_RECURRENTES_CONCEPTO = 'J. INF No Recurrentes';
    /** */
    public static final String EU001_STR_MARGEN_CONCEPTO = 'K. Margen Bruto';
    /** */
    public static final String EU001_STR_STOCK_NOMINA_CONCEPTO = 'L. Stock Nomina';
    /** */
    public static final String EU001_STR_NVOS_USARIOS_CONCEPTO = 'M. Nuevos Usuarios';

    /** */
    public static final String EU001_STR_GAP_ORIGINAL = 'B) Gap orig';
    /** */
    public static final String EU001_STR_GESTION = 'En Gestión';
    /** */
    public static final String EU001_STR_SIN_GESTION = 'Sin Gestión';
    /** */
    public static final String EU001_STR_PRIORIZADO = 'Priorizados';
    /** */
    public static final String EU001_STR_SIN_PRIORIZAR = 'Sin Priorizar';

    /** */
    public static final String EU001_STR_TIPO_REG= 'Valoracion Ventas';
    /** */
    public static final String EU001_STR_BANCA= 'Red BEyG';
    /** */
    public static final String EU001_STR_PERFIL1= 'Ejecutivo de cuenta empresas';
    /** */
    public static final String EU001_STR_PERFIL2= 'EJEC. OF. EMP.'; 
    /** */
    public static final String EU001_STR_PERFIL3= 'CUENTAS CLAVE';
    /** */
    public static final String EU001_STR_PERFIL4= 'Ejecutivo de cuenta gobierno';
    /** */
    public static final String EU001_STR_PERFIL5= 'Ejecutivo de cuenta mixto';
    /** */
    public static final String EU001_STR_PERFIL6= 'EJEC. OF.GOB.';
    /** */
    public static final String EU001_STR_PERFIL7= 'CUENTAS CLAVE GOB';

    //Record Type
    /** */
    public static final String EU001_STR_PONDERACION_DOR = 'EU001_tr_PonderacionDOR';
    /** */
    public static final String EU001_STR_DOR_GM = 'EU001_tre_DOR_GM_Potenciales';
    /** */
    public static final String EU001_STR_TRE_CERTIFICACION = 'EU001_tre_Certificacion_EU';
    /** */
    public static final String EU001_STR_TRE_REPORTE_SEGUIMIENTO = 'Reporte Visita de Seguimiento';


    //Etapas oportindad
    /** Crédito dispuesto*/
    public static final String EU001_STR_ETAPA_OPP_CREDITO_DISPUESTO = 'Crédito dispuesto';
    /**Desembolso PyME */
    public static final String EU001_STR_ETAPA_OPP_DESEMBOLSO_PYME = 'Desembolso PyME';
    /** Desembolso*/
    public static final String EU001_STR_ETAPA_OPP_DESEMBOLSO = 'Desembolso';
    /** Cerrada Ganada*/
    public static final String EU001_STR_ETAPA_OPP_CERRADA_GANADA = 'Cerrada Ganada';
    /** Descartada / Rechazada*/
    public static final String EU001_STR_ETAPA_OPP_DESCARTADA_RECHAZADA = 'Descartada / Rechazada';
    /** Revisión */
    public static final String EU001_STR_ETAPA_OPP_EN_REVISION = 'Revisión';

    /** Tipos de Registro de Parametria*/
    public static final String EU001_STR_PARAMETRIA_TOPES_CAMPANA = 'Tope por Campaña';

    /** Tipos de Registro de Oportunidad*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_FINANCIAMIENTO = 'Financiamiento';
    /** Arrendamiento*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_ARRENDAMIENTO = 'Arrendamiento';
    /**Banca eléctronica */
    public static final String EU001_STR_FAMILIA_PRD_OPP_BANCA_ELECTRONICA = 'Banca electrónica';
    /** Adquirente*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_ADQUIRIENTE = 'Adquirente';
    /** CIE*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_CIE = 'CIE';
    /** DEM*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_DEM = 'DEM';
    /** Host to Host*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_HOST_TO_HOST = 'Host to Host';
    /** TIB*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_TIB = 'TIB';
    /** Domiciliacion*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_DOMILICIACION = 'Domiciliación';
    /** Fiduciario*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_FIDUCIARIO = 'Fiduciario';
    /** Nómina*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_NOMINA  = 'Nómina';
    /**Vista */
    public static final String EU001_STR_FAMILIA_PRD_OPP_VISTA   = 'Vista';
    /**Inversiones */
    public static final String EU001_STR_FAMILIA_PRD_OPP_INVERSIONES = 'Inversiones';
    /**Colocación */
    public static final String STR_FAM_COL = 'Colocación';
    /** Comercio Internacional */
    public static final String EU001_STR_FAMILIA_PRD_OPP_COMERCIO_INTERNACIONAL = 'Comercio internacional';
    /** Multirecaudador*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_COMERCIO_MULTIRECAUDADOR = 'Multirecaudador';
    /** DEM*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_COMERCIO_DEM = 'DEM';
    /** SIT*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_SIT = 'SIT';
    /** Swift / Trasferencia internacional*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_SWIFTTI = 'Swift / Trasferencia internacional';
    /**ATM */
    public static final String EU001_STR_FAMILIA_PRD_OPP_ATM = 'ATM';
    /** Seguros*/
    public static final String EU001_STR_FAMILIA_PRD_OPP_SEGUROS = 'Seguros';

    /** Tipos de Registro de productos*/
    public static final String MX_TR_OPP_PIP_FINANCIAMIENTO_ARRPURO = 'MX_PIP_tre_OpFinanciamiento_Puro';
	/**MX_PIP_tre_Arrendamiento */
    public static final String MX_TR_OPP_PIP_FINANCIAMIENTO_ARRFINANCIERO = 'MX_PIP_tre_Arrendamiento';
    /** EG009_tre_OportunidadFinanciamiento*/
    public static final String EU001_TR_OPP_PIPELINE_FINANCIAMIENTO = 'EG009_tre_OportunidadFinanciamiento';
    /** EG009_tre_Financiamiento*/
    public static final String EU001_TR_OPP_PIPELINE_DISPOSICION_FINANCIAMIENTO = 'EG009_tre_Financiamiento';
    /** EG009_tre_Disposicion*/
    public static final String EU001_TR_OPP_PIPELINE_DISPOSICION = 'EG009_tre_Disposicion';
    /** EG009_tre_disposicionUSAC*/
    public static final String EU001_TR_OPP_PIPELINE_DISPOSICION_USAC = 'EG009_tre_disposicionUSAC';
    /** Adquirente_SSEE_Aplinet*/
    public static final String EU001_TR_OPP_APLINET = 'Adquirente_SSEE_Aplinet';
    /** Adquirente_SSEE_E_Commerce*/
    public static final String EU001_TR_OPP_E_COMERCE = 'Adquirente_SSEE_E_Commerce';
    /** Adquirente_SSEE_Intered*/
    public static final String EU001_TR_OPP_INTERED = 'Adquirente_SSEE_Intered';
    /** Adquirente_SSEE_Webtransfer*/
    public static final String EU001_TR_OPP_WEBTRANSFER = 'Adquirente_SSEE_Webtransfer';
    /** Adquirente_v2*/
    public static final String EU001_TR_OPP_TPV = 'Adquirente_v2';
    /** Aduanas*/
    public static final String EU001_TR_OPP_PAGO_DE_IMPUESTOS_ADUANALES = 'Aduanas';
    /** Aportaciones*/
    public static final String EU001_TR_OPP_SUA = 'Aportaciones';
    /**ATM */
    public static final String EU001_TR_OPP_ATM = 'ATM';
    /**Bcom */
    public static final String EU001_TR_OPP_BANCA_ELECTRONICA = 'Bcom';
    /**Cambios */
    public static final String EU001_TR_OPP_Cambios = 'Cambios';
    /** Ciclos_V_Prev_Soc_Am_Prev_Soc*/
    public static final String EU001_TR_OPP_INVERSIONES = 'Ciclos_V_Prev_Soc_Am_Prev_Soc';
    /** CIE_V2*/
    public static final String EU001_TR_OPP_CIE = 'CIE_V2';
    /**Cobertura_de_Tasa */
    public static final String EU001_TR_OPP_COBERTURA_DE_TASA = 'Cobertura_de_Tasa';
    /**Cobertura_de_Tipo_de_Cambio */
    public static final String EU001_TR_OPP_COBERTURA_DE_TIPO_DE_CAMBIO = 'Cobertura_de_Tipo_de_Cambio';
    /** Comercion_Internacional_P4*/
    public static final String EU001_TR_OPP_COMERCIO_INTERNACIONAL = 'Comercion_Internacional_P4';
    /** Comercion_Internacional_P4*/
    public static final String EU001_TR_OPP_SEGUROS = 'Comercion_Internacional_P4';
    /**DEM_V2 */
    public static final String EU001_TR_OPP_DEM = 'DEM_V2';
    /**DIE */
    public static final String EU001_TR_OPP_DIE = 'DIE';
    /** Domiciliaci_n_V2*/
    public static final String EU001_TR_OPP_DOMICILIACION = 'Domiciliaci_n_V2';
    /** EG_tre_CotizacionArrendamiento*/
    public static final String EU001_TR_OPP_ARRENDAMIENTO = 'EG_tre_CotizacionArrendamiento';
    /**FI001_tre_Fideicomiso */
    public static final String EU001_TR_OPP_FIDEICOMISO = 'FI001_tre_Fideicomiso';
    /**Financiamiento */
    public static final String EU001_TR_OPP_FINANCIAMIENTO = 'Financiamiento';
    /**Fondos */
    public static final String EU001_TR_OPP_INVERSIONES_FONDOS = 'Fondos';
    /** Host_to_Host_V2*/
    public static final String EU001_TR_OPP_HOST_TO_HOST = 'Host_to_Host_V2';
    /** Multipagos*/
    public static final String EU001_TR_OPP_MULTIPAGOS = 'Multipagos';
    /** Multirecaudador*/
    public static final String EU001_TR_OPP_MULTIRECAUDADOR = 'Multirecaudador';
    /**Netcash */
    public static final String EU001_TR_OPP_BANCA_ELECTRONICA_NETCASH = 'Netcash';
    /** Nomina*/
    public static final String EU001_TR_OPP_NOMINA = 'Nomina';
    /**Nomina_USAC_Contratacion */
    public static final String EU001_TR_OPP_NOMINA_USAC = 'Nomina_USAC_Contratacion';
    /**OP_tre_alianzasComerciales */
    public static final String EU001_TR_OPP_ALIANZAS_COMERCIALES = 'OP_tre_alianzasComerciales';
    /**OP_tre_alianzasComercialesAsesor */
    public static final String EU001_TR_OPP_ALIANZAS_COMERCIALES_ASESOR = 'OP_tre_alianzasComercialesAsesor';
    /** OP_tre_disposicionCredito*/
    public static final String EU001_TR_OPP_DISPOSICION = 'OP_tre_disposicionCredito';
    /** OP_tre_disposicionCreditoUSAC*/
    public static final String EU001_TR_OPP_DISPOSICION_USAC = 'OP_tre_disposicionCreditoUSAC';
    /**Pensiones */
    public static final String EU001_TR_OPP_FIDEICOMISO_PENSIONES = 'Pensiones';
    /** PlazoMDD*/
    public static final String EU001_TR_OPP_MDD = 'PlazoMDD';
    /**SegurosAutoFlotillaUnica */
    public static final String EU001_TR_OPP_AUTO_FLOTILLA = 'SegurosAutoFlotillaUnica';
    /**SegurosVidaGrupoUnica */
    public static final String EU001_TR_OPP_GRUPO_VIDA = 'SegurosVidaGrupoUnica';
    /** SegurosGarantias*/
    public static final String EU001_TR_OPP_SEGUROS_GARANTIA = 'SegurosGarantias';
    /** Servicios_de_Asesor_a_Estrategica*/
    public static final String EU001_TR_OPP_SERVICIOS_ASESORIA_ESTRATEGICA = 'Servicios_de_Asesor_a_Estrategica';
    /**Servicios_de_Financiamiento */
    public static final String EU001_TR_OPP_SERVICIOS_DE_FINANCIAMIENTO = 'Servicios_de_Financiamiento';
    /**SIT_V2 */
    public static final String EU001_TR_OPP_SIT = 'SIT_V2';
    /** Swift*/
    public static final String EU001_TR_OPP_SWIFT = 'Swift';
    /** Tarjetas*/
    public static final String EU001_TR_OPP_TARJETAS = 'Tarjetas';
    /** Testamentario*/
    public static final String EU001_TR_OPP_FIDUCIARIO = 'Testamentario';
    /** TIB_V2*/
    public static final String EU001_TR_OPP_TIB = 'TIB_V2';
    /**Vista */
    public static final String EU001_TR_OPP_VISTA = 'Vista';

    /** Tipo de registros Visitas*/
    public static final String EU001_STR_REPORTE_VISITA_ESTRATEGICA = 'Reporte Visita Estratégica';
    /** Reporte Visita Comercial*/
    public static final String EU001_STR_REPORTE_VISITA_COMERCIAL = 'Reporte Visita Comercial';
    /**Reporte Visita de Seguimiento */
    public static final String EU001_STR_REPORTE_VISITA_SEGUIMIENTO = 'Reporte Visita de Seguimiento';

    /**Poductos Opp */
    public static final String EU001_STR_PRD_OPP_CUENTA_CHEQUES_MN= 'Cuenta de Cheques MN';
    /**Aplinet */
    public static final String EU001_STR_PRD_OPP_APPLINET = 'Aplinet';
    /**Asset Management Previsión Social */
    public static final String EU001_STR_PRD_ASSET_MANAGEMENT_PREVISION_SOCIAL = 'Asset Management Previsión Social';
    /**Garantías */
    public static final String EU001_STR_PRD_GARANTIAS = 'Garantías';

    /** Plazo*/
    public static final String EU001_STR_PLAZO_PRD_OPP_FINANCIAMIENTO = '0 a 1 año';
    /**1 A 3 años */
    public static final String EU001_STR_PLAZOM_PRD_OPP_FINANCIAMIENTO = '1 A 3 años';

    /**Porcentaje minimo de opp */
    public static final Integer EU001_INT_OPP_PR_MINIMO = 35;

    /** Certificacion EU*/
    public static final String EU001_STR_CASOS_INUSUALES = 'Casos Inusuales';
    /** Eventos Subsecuentes*/
    public static final String EU001_STR_EVENTOS_SUBSECUENTES = 'Eventos Subsecuentes';
    /** Descartado*/
    public static final String EU001_STR_ALERTAS_ETAPA_DESCARTADO = 'Descartado';
    /** Rechazado*/
    public static final String EU001_STR_ALERTAS_ETAPA_RECHAZADO = 'Rechazado';
    /** Reunión Individual*/
    public static final String EU001_STR_REUNION_INDIVIDUAL = 'Reunión Individual';
    /**Control de Eventos */
    public static final String EU001_STR_CONTROL_EVENTOS =  'Control de Eventos';
    /** Plan de Cuenta*/
    public static final String EU001_STR_PLAN_CUENTA = 'Plan de Cuenta';
    /** Actualización de contactos*/
    public static final String EU001_STR_ACTUIALIZACION_CONTACTOS = 'Actualización de contactos';
    /**Comité de Negocios */
    public static final String EU001_STR_COMITE_NEGOCIOS = 'Comité de Negocios';
    /** Gestión de Portafolio*/
    public static final String EU001_STR_GESTION_PORTAFOLIO = 'Gestión de Portafolio';
    /** Cerrado Ganado*/
    public static final String EU001_STR_CERRADO_GANADO = 'Cerrado Ganado';
    /** Asignado a DO para descarte*/
    public static final String EU001_STR_ASIGNADO_DO_DESCARTE = 'Asignado a DO para descarte';
    /** Asignado a USAC para cierre*/
    public static final String EU001_STR_ASIGNADO_USAC_CIERRE = 'Asignado a USAC para cierre';

    /**Visitas Totales */
    public static final String EU001_STR_VISITAS_TOTALES = 'Visitas Totales';
    /** Visitas Comerciales*/
    public static final String EU001_STR_VISITAS_COMERCIALES =  'Visitas Comerciales';
    /** Visitas Estratégicas*/
    public static final String EU001_STR_VISITAS_ESTRATEGIAS =  'Visitas Estratégicas';
    /** Visitas Seguimiento*/
    public static final String EU001_STR_VISITAS_SEGUIMIENTO=  'Visitas Seguimiento';
    /**Contactos */
    public static final String EU001_STR_CONTACTOS = 'Contactos';
    /** Casos Inusuales PLD*/
    public static final String EU001_STR_TABLEROS_CASOS_INUSUALES = 'Casos Inusuales PLD';
    /** Control de Eventos*/
    public static final String EU001_STR_TABLEROS_CONTROL_EVENTOS = 'Control de Eventos';

    /** Tipo de regstro de parametría*/
    public static final String EU001_STR_TRE_PONDERACION_DOR= 'Ponderación DOR';
    /** Ponderación Gana Más*/
    public static final String EU001_STR_TRE_PONDERACION_GANA_MAS= 'Ponderación Gana Más';
    /**Margen Oportunidad */
    public static final String EU001_STR_TRE_MARGEN_OPP= 'Margen Oportunidad';
    /** DOR GM Potenciales*/
    public static final String EU001_STR_TRE_PONDERACION_GM_MATRIZ= 'DOR GM Potenciales';

    /**Tipo de Registro Compromisos */
    public static final String EU001_TRE_COMPROMISO_CARTERA = 'Cartera';
    /** Captacion*/
    public static final String EU001_TRE_COMPROMISO_CAPTACION = 'Captación';
    /**INF Recurrentes */
    public static final String EU001_TRE_COMPROMISO_IFN_RECURRENTES = 'INF Recurrentes';
    /**INF No Recurrentes */
    public static final String EU001_TRE_COMPROMISO_IFN_NO_RECURRENTES = 'INF No Recurrentes';
    /** Nvos Usuarios de Crédito*/
    public static final String EU001_TRE_COMPROMISO_NVOS_USUARIOS = 'Nvos Usuarios de Crédito';
    /**Stock Nómina */
    public static final String EU001_TRE_COMPROMISO_STOCK_NOMINA = 'Stock Nómina';
    /** Saneamiento*/
    public static final String EU001_TRE_COMPROMISO_SANEAMIENTO = 'Saneamiento';
    /**General */
    public static final String EU001_TRE_COMPROMISO_GENERAL = 'General';
    /**Genérico */
    public static final String EU001_TRE_COMPROMISO_SIN_INDICADOR = 'Genérico';

    /** EV*/
    public static final String EU001_STR_EJECUTIVO_VTA = 'EV';
    /**DO */
    public static final String EU001_STR_DIRECTOR_OFICINA = 'DO';
    /**DR */
    public static final String EU001_STR_DIRECTOR_REGIONAL = 'DR';
    /**DD */
    public static final String EU001_STR_DIRECTOR_DIVISIONAL = 'DD';
    /**%DIRECTOR DE OFICINA EMPRESAS% */
    public static final String EU001_STR_DIRECTOR_OFICINA_LIKE_CONSULTA = '%DIRECTOR DE OFICINA EMPRESAS%';

    /** Constantes Clases Test*/
    public static final String EU001_STR_PLAN_PISO='Plan Piso';
    /** Empresas;Gobierno;Empresas*/
    public static final String EU001_STR_BANCAS='Empresas;Gobierno;Empresas';
    /**Crédito */
    public static final String EU001_STR_CREDITO='Crédito';
    /** Fondos Largo Plazo*/
    public static final String EU001_STR_FONDOS_LARGO_PLAZO='Fondos Largo Plazo';
    /**Fondos Corto Plazo */
    public static final String EU001_STR_FONDOS_CORTO_PLAZO='Fondos Corto Plazo';
    /** Plazo*/
    public static final String EU001_STR_PLAZO = 'Plazo';
    /** Fondos*/
    public static final String EU001_STR_FONDOS='Fondos';
    /** Cobranza*/
    public static final String EU001_STR_COBRANZA='Cobranza';
    /**Comercio Internacional P4 */
    public static final String EU001_STR_FAMILIA_PRD_OPP_COMERCIO_INTERNACIONAL_P4 = 'Comercio Internacional P4';
    /** Moneda Nacional*/
    public static final String EU001_STR_MONEDA_NACIONAL = 'Moneda Nacional';
    /** Cajeros Automáticos (ATMs)*/
    public static final String EU001_STR_CAJEROS_AUTOMATICOS = 'Cajeros Automáticos (ATMs)';
    /**Otro */
    public static final String EU001_STR_OTRO = 'Otro';
    /** Pago de Impuestos Aduanales*/
    public static final String EU001_STR_PAGO_IMPUESTOS_ADUANALES = 'Pago de Impuestos Aduanales';
    /** Aduanas*/
    public static final String EU001_STR_ADUANAS = 'Aduanas';
    /** Pendiente Autorización de Divisional*/
    public static final String EU001_STR_PENDIENTE_AUTORIZACION_DIV = 'Pendiente Autorización de Divisional';
    /** Formalización crédito*/
    public static final String EU001_STR_FORMALIZACION_CREDITO = 'Formalización crédito';
    /** Formalización*/
    public static final String EU001_STR_FORMALIZACION = 'Formalización';
    /**Contratación  */
    public static final String EU001_STR_CONTRATACION= 'Contratación';
    /**Producto */
    public static final String EU001_STR_PRODUCTO = 'Producto';
    /** Resitasd SA*/
    public static final String EU001_STR_NOMBRE_CLIENTE = 'Resitasd SA';
    /**836483352 */
    public static final String EU001_STR_NO_CLIENTE = '836483352';
    /**Opp Test */
    public static final String EU001_STR_NOMBRE_TEST = 'Opp Test';
    /**Nueva */
    public static final String EU001_STR_NUEVA = 'Nueva';
    /** */
    public static final Integer EU001_STR_PROBABILIDAD = 75;
    /** */
    public static final Decimal EU001_STR_MONTO = 300000;
    /** Calcular RAR y/o Compromiso*/
    public static final String EU001_STR_CALCULAR_RAR = 'Calcular RAR y/o Compromiso';
    /** 5 a 7 años*/
    public static final String EU001_STR_LARGO_PLAZO = '5 a 7 años';
    /**7 a 10 años */
    public static final String EU001_STR_LARGO_PLAZO_7 = '7 a 10 años';
    /** Integración de información*/
    public static final String EU001_STR_INTEGRACION_INFORMACION = 'Integración de información';
    /** Real*/
    public static final String EU001_STR_REAL_TAB = 'Real';
    /** C) Real*/
    public static final String EU001_STR_REAL_C_TAB = 'C) Real';
    /** Real + Compromisos*/
    public static final String EU001_STR_REAL_COMPROMISOS = 'Real + Compromisos';
    /** A. Cartera CP pts*/
    public static final String EU001_STR_CARTERA_CP_TAB = 'A. Cartera CP pts';
    /**A. Cartera CP */
    public static final String EU001_STR_CARTERA_CP_TAB_2 = 'A. Cartera CP';
    /** Fecha_Act*/
    public static final String EU001_STR_FECHA_ACT = 'Fecha_Act';
    /** Fec_Margen*/
    public static final String EU001_STR_FEC_MARGEN = 'Fec_Margen';
    /** Gana Mas*/
    public static final String EU001_STR_GANA_MAS = 'Gana Mas';
    /** */
    public static final String EU001_STR_PERFIL_ADMIN = Label.MX_PERFIL_SystemAdministrator;
    /**@gmail.com */
    public static final String EU001_STR_CORREO_GMAL ='@gmail.com';
    /** userNameTst*/
    public static final String EU001_STR_USERNAME ='userNameTst';
    /** UserTst*/
    public static final String EU001_STR_USER_NAME ='UserTst';
    /**Test */
    public static final String EU001_STR_USER_LASTNAME ='Test';
    /** tst1*/
    public static final String EU001_STR_ALIAS = 'tst1';
    /**America/Mexico_City */
    public static final String EU001_STR_ZONA_HORARIA = 'America/Mexico_City';
    /** en_US*/
    public static final String EU001_STR_IDIOMA ='en_US';
    /**ISO-8859-1 */
    public static final String EU001_STR_ENCODING ='ISO-8859-1';
    /** es*/
    public static final String EU001_STR_CLAVE_IDIOMA ='es';
    /**Elegible */
    public static final String EU001_STR_CERTIFICACION ='Elegible';
    /**1234 */
    public static final String EU001_STR_EMPIEZA_NOMINA ='1234';
    /** A. Reunion Individual*/
    public static final String EU001_STR_A_REUNION_INDIVIDUAL ='A. Reunion Individual';
    /**B. Comité de Negocios */
    public static final String EU001_STR_B_COMITE_NEGOCIOS ='B. Comité de Negocios';
    /** C. Visitas Totales*/
    public static final String EU001_STR_C_VISITAS_TOTALES ='C. Visitas Totales';
    /** D. Oportunidades*/
    public static final String EU001_STR_D_OPORTUNIDADES ='D. Oportunidades';
    /**E. Plan de Cuenta */
    public static final String EU001_STR_E_PLAN_CUENTA ='E. Plan de Cuenta';
    /**F. Contactos */
    public static final String EU001_STR_F_CONTACTOS ='F. Contactos';
    /**G. GanaDOR */
    public static final String EU001_STR_G_GANADOR ='G. GanaDOR';
    /** H. Casos Inusuales PLD*/
    public static final String EU001_STR_H_CASOS_INUSUSALES ='H. Casos Inusuales PLD';
    /** I. Control de Eventos*/
    public static final String EU001_STR_I_CONTROL_EVENTOS ='I. Control de Eventos';
    /**J. Gestión de Portafolio */
    public static final String EU001_STR_J_GESTION_PORTAFOLIO ='J. Gestión de Portafolio';
    /**A. Visitas Totales */
    public static final String EU001_STR_A_VISITAS_TOTALES ='A. Visitas Totales';
    /**B. Visitas Estratégicas */
    public static final String EU001_STR_B_VISITAS_ESTRATEGICAS ='B. Visitas Estratégicas';
    /** C. Visitas Comerciales*/
    public static final String EU001_STR_C_VISITAS_COMERCIALES ='C. Visitas Comerciales';
    /** D. Visitas Seguimiento*/
    public static final String EU001_STR_D_VISITAS_SEGUIMIENTO='D. Visitas Seguimiento';
    /** E. Oportunidades*/
    public static final String EU001_STR_E_OPORTUNIDADES='E. Oportunidades';
    /**F. Plan de Cuenta */
    public static final String EU001_STR_F_PLAN_CUENTA='F. Plan de Cuenta';
    /**G. Contactos */
    public static final String EU001_STR_G_CONTACTOS='G. Contactos';
    /**H. GanaDOR */
    public static final String EU001_STR_H_GANADOR='H. GanaDOR';
    /** CORPORATIVO*/
    public static final String EU001_STR_LIGA_EJECUTIVO='CORPORATIVO';
    /** EMPRESARIAL*/
    public static final String EU001_STR_LIGA_EMPRESARIAL='EMPRESARIAL';
    /**MEDIANA EMPRESA */
    public static final String EU001_STR_LIGA_MEDIANA='MEDIANA EMPRESA';
    /**FEDERAL */
    public static final String EU001_STR_LIGA_FEDERAL='FEDERAL';
    /** GOBIERNO RESTO*/
    public static final String EU001_STR_LIGA_GOBIERNO='GOBIERNO RESTO';
    /**GRANDES CUENTAS */
    public static final String EU001_STR_LIGA_GDES_CUENTAS='GRANDES CUENTAS';
    /** Cobertura Empresarial*/
    public static final String EU001_STR_COBERTURA_EMPRESARIAL='Cobertura Empresarial';
    /** familia*/
    public static final String EU001_STR_FAMILIA='familia';
    /** Gana puntos DOR si logras atraer Nuevos Negocios Especializados*/
    public static final String EU001_STR_DESC_OPP='Gana puntos DOR si logras atraer Nuevos Negocios Especializados';
    /** Oportunidades Modelo Corporativo*/
    public static final String EU001_STR_NOMBRE_OPP='Oportunidades Modelo Corporativo';
    /**Genérico Visita */
    public static final String EU001_STR_GENERICO_VISITA='Genérico Visita';
    /** IReNe*/
    public static final String EU001_STR_IRENE ='IReNe';
    /**High */
    public static final String EU001_STR_PRIORIDAD = 'High';

    //Nombre reportes
    /** Logro_por_indicador*/
    public static final String EU001_REPORTE_LOGRO_POR_INDICADOR = 'Logro_por_indicador';
    /**EU_001_Puntos_DOR_por_Indicador */
    public static final String EU001_REPORTE_DOR_POR_INDICADOR = 'EU_001_Puntos_DOR_por_Indicador';
    /**EU_001_Puntos_DOR_por_Indicador1 */
    public static final String EU001_REPORTE_GANA_MAS_INDICADOR = 'EU_001_Puntos_DOR_por_Indicador1';
    /** Detalle_Cartera_CP*/
    public static final String EU001_REPORTE_DETALLE_CARTERA_CP = 'Detalle_Cartera_CP';
    /**Detalle_CarteraVigente_LP */
    public static final String EU001_REPORTE_DETALLE_CARTERA_LP = 'Detalle_CarteraVigente_LP';
    /** Detalle_Vista_MN*/
    public static final String EU001_REPORTE_DETALLE_VISTA_MN = 'Detalle_Vista_MN';
    /** Detalle_Inversiones_Resto_Captacion*/
    public static final String EU001_REPORTE_DETALLE_INV_REST_CAPT = 'Detalle_Inversiones_Resto_Captacion';
    /** Detalle_Captacion_ME*/
    public static final String EU001_REPORTE_DETALLE_CAPT_ME = 'Detalle_Captacion_ME';
    /**Detalle_Inversiones */
    public static final String EU001_REPORTE_DETALLE_INVERIONES = 'Detalle_Inversiones';
    /** Detalle_Resto_Capcion*/
    public static final String EU001_REPORTE_DETALLE_RESTO = 'Detalle_Resto_Capcion';
    /**Detalle_Resto_Capcion */
    public static final String EU001_REPORTE_DETALLE_RESTO_Acento = 'Detalle_Resto_Capcion';
    /**Detalle_INF_Recurrentes */
    public static final String EU001_REPORTE_DETALLE_INF_RECURRENTES = 'Detalle_INF_Recurrentes';
    /** Detalle_INF_NoRecurrentes*/
    public static final String EU001_REPORTE_DETALLE_INF_NO_RECURRENTES = 'Detalle_INF_NoRecurrentes';
    /** Detalle_MargenBruto*/
    public static final String EU001_REPORTE_DETALLE_MARGEN = 'Detalle_MargenBruto';
    /** Detalle_StockNomina*/
    public static final String EU001_REPORTE_DETALLE_STOCK_NOMINA = 'Detalle_StockNomina';
    /** Certificacion_EU*/
    public static final String EU001_REPORTE_CERTIFICACION_EU = 'Certificacion_EU';
    /** Gestion_Comercial*/
    public static final String EU001_REPORTE_GESTION_COMERCIAL = 'Gestion_Comercial';
    /** Gesti_n_Alertas_Incentivadas_Inicio_Ligh*/
    public static final String EU001_REPORTE_ALERTAS_INCENTIVADAS = 'Gesti_n_Alertas_Incentivadas_Inicio_Ligh';
    /**Gesti_n_Plan_de_Choque_Inicio_Ligh2 */
    public static final String EU001_REPORTE_PLAN_CHOQUE = 'Gesti_n_Plan_de_Choque_Inicio_Ligh2';
    /**EU001_inf_TotalDeCompromisos */
    public static final String EU001_REPORTE_TOTAL_COMPROMISO = 'EU001_inf_TotalDeCompromisos';
    /**EU001_inf_CompromisosEjecutivos */
    public static final String EU001_REPORTE_COMPROMISO_EJECUTIVO = 'EU001_inf_CompromisosEjecutivos';
    /** EU001_inf_ApoyosEU*/
    public static final String EU001_REPORTE_APOYOS = 'EU001_inf_ApoyosEU';

    /** A. Reunion Individual*/
    public static final String EU001_CONCEPTO_RI = 'A. Reunion Individual';
    /** A. Visitas Totales*/
    public static final String EU001_CONCEPTO_VISITAS = 'A. Visitas Totales';
    /**D. Oportunidades */
    public static final String EU001_CONCEPTO_OPP = 'D. Oportunidades';
    /** F. Plan de Cuenta*/
    public static final String EU001_CONCEPTO_PC = 'F. Plan de Cuenta';
    /**F. Contactos */
    public static final String EU001_CONCEPTO_CONTACTOS = 'F. Contactos';
    /**H. Casos Inusuales PLD */
    public static final String EU001_CONCEPTO_CASOS = 'H. Casos Inusuales PLD';
    /**I. Control de Eventos */
    public static final String EU001_CONCEPTO_CONTROL_EVENTOS = 'I. Control de Eventos';
    /** J. Gestion de Portafolio*/
    public static final String EU001_CONCEPTO_GESTION_PORTA = 'J. Gestion de Portafolio';
    /** EU001_Dor_por_Ejecutivo*/
    public static final String EU001_REPORTE_DOR_POR_EJECUTIVO = 'EU001_Dor_por_Ejecutivo';

    /**B. Visitas Estrategicas */
    public static final String EU001_CONCEPTO_VISITAS_ESTRA ='B. Visitas Estrategicas';
    /** C. Visitas Comerciales*/
    public static final String EU001_CONCEPTO_VISITAS_COMER ='C. Visitas Comerciales';
    /** D. Visitas Seguimiento*/
    public static final String EU001_CONCEPTO_VISITAS_SEGUI ='D. Visitas Seguimiento';
    /**E. Oportunidades */
    public static final String EU001_CONCEPTO_DETALLE_OP ='E. Oportunidades';
    /** F. Plan de Cuenta*/
    public static final String EU001_CONCEPTO_DETALLE_PC ='F. Plan de Cuenta';
    /** G. Contactos*/
    public static final String EU001_CONCEPTO_DETALLE_CONTACTOS ='G. Contactos';
}