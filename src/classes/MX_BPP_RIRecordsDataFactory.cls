/**
* ------------------------------------------------------------------------------------------------
* @Name     MX_BPP_RIRecordsDataFactory
* @Author   Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* @Date     Created: 2019-07-02
* @Group    Digital Workplace Retail
* @Description Create the data for the test classes for RI(BPyP) functionality.
* @Comments Created from the clipped code from the UtilitysDataTest_tst and EU_cls_TestData classes.
            Se dejan los comentarios de las clases origen relacionados a métodos contenidos en esta clase.
* @Changes  04/09/2019  Cindy Hernández Se agrega el método creaVisita.
**/

/*----------------------------------Desarrollado por INDRA--------------------------------
UtilitysDataTest_tst
*Autor:         Trabajo en Equipo
*Proyecto:      MAX - BBVA Bancomer
*Descripción:   Clase para crear los Datos de prueba generales de utilería para ser usados
                en las demas clases de prueba
*_______________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        22/MAR/2018     Sergio Ortiz                        Creación.
*1.3        08/JUL/2018     Ricardo Almanza                     Se asignación de registro en crearReporteVisita
                                                                Se corrigen Parametros de entrada en algunos metodos.
*2.2        19-09-2018      Francisco J Licona                  Se agregan métodos que devuelven los objetos ExpUni_Tablero_Grupal__c
                                                                y EU_001_Compromiso__c.
*2.3       28/09/2018      Angel Fuertes Gomez                  Cambio del contacto decisor de BPyP
*2.9        22/FEB/2019     Luis Fernando Romero                Se agrega método para indicadores de logro
*2.9        22/FEB/2019     Luis Fernando Romero                Se agrega método para indicadores de logro
-----------------------------------------------------------------------------------------*/

/**
EU_cls_TestData
*Desarrollado por:       Indra
*Autor:                  Abraham Alfonso Tinajero Sánchez
*Proyecto:               Experiencia Única
*Descripción:            ClaseTest para generar información de prueba
*
*Cambios (Versiones)
*-------------------------------------------------------------------------------
*No.         Fecha           Autor                          Descripción
*------   ----------------   --------------------          ---------------
*1.0      07-08-2017         Abraham Tnajero                Creación
*2.0      15-03-2018         Abraham Tnajero                Se optimizan métodos
*5.0	  20-06-2018		 Javier Ortiz Flores 			Se agrega compromiso con fecha anterior al día de hoy
*6.2      14-09-2018         César Villanueva               Se agrega tablero grupal de certificación EU.
**/
@isTest
public class MX_BPP_RIRecordsDataFactory {
    /**Creacion de metodo */
    public static ExpUni_Tablero_Grupal__c CrearTableroIndividua(String ug,String Indicador1,String indicador2, String Atributo, Decimal valor) {
        final ExpUni_Tablero_Grupal__c tablero1= new ExpUni_Tablero_Grupal__c();
        tablero1.EU_UG__c = ug;
        tablero1.EU_001_tx_Indicador__c = indicador1;
        tablero1.EU_Indicador__c =indicador2;
        tablero1.EU_001_tx_Atributo__c = Atributo;
        tablero1.EU_001_Un_Valor__c =valor;
        return tablero1;
    }
    /**Creacion de metodo */
    public static void generaTablero(String sUG) {
        createTabIndicadorl(sUG,EU001_CLS_CONSTANTES.EU001_STR_INF_RECURRENTES);
        createTabIndicadorl(sUG,EU001_CLS_CONSTANTES.EU001_STR_RESTO_CAPTACION);
        createTabIndicadorl(sUG,EU001_CLS_CONSTANTES.EU001_STR_INVERSIONES);
        createTabIndicadorl(sUG,EU001_CLS_CONSTANTES.EU001_STR_VISTA_MN);
        createTabIndicadorl(sUG,EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE);
        createTabIndicadorl(sUG,EU001_CLS_CONSTANTES.EU001_STR_CARTERA_VIGENTE_LP);
        createTabIndicadorl(sUG,EU001_CLS_CONSTANTES.EU001_STR_ACCIONES_COMERCIALES);
        createTabIndicadorl(sUG,EU001_CLS_CONSTANTES.EU001_STR_EXPERIENCIA_UNICA);
        createTabIndicadorl(sUG,EU001_CLS_CONSTANTES.EU001_STR_CONTROL_INTERNO);
        createTabIndicadorl(sUG,EU001_CLS_CONSTANTES.EU001_STR_AUDITORIA);
        createTabIndicadorl(sUG,EU001_CLS_CONSTANTES.EU001_STR_IMPAGOS);
        createTabIndicadorl(sUG,EU001_CLS_CONSTANTES.EU001_STR_GASTO_DIVISION);
        createTabIndicadorl(sUG,EU001_CLS_CONSTANTES.EU001_STR_EXPEDIENTE_DIGITAL);
    }
    /**Creacion de constructor */
    public static void createTabIndicadorl(String ug,String indicador) {
        final List<ExpUni_Tablero_Grupal__c> listTablero = new List<ExpUni_Tablero_Grupal__c>();

		listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_EXP_UNICA,EU001_cls_CONSTANTES.EU001_STR_RANKING_PTCIAL,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR_POT,EU001_CLS_CONSTANTES.EU001_STR_PROMEDIO_DOR_POT,147000));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_REAL_TAB,EU001_CLS_CONSTANTES.EU001_STR_REAL,147000));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_REAL_TAB,EU001_CLS_CONSTANTES.EU001_STR_GAP_ORIGINAL,-53000));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_REAL_TAB,EU001_CLS_CONSTANTES.EU001_STR_GAP,53000));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_REAL_TAB,EU001_CLS_CONSTANTES.EU001_STR_REAL_A_COMPLEMENTO,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_REAL_TAB,EU001_CLS_CONSTANTES.EU001_STR_GAP_COMPLEMENTO,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_REAL_COMPROMISOS,EU001_CLS_CONSTANTES.EU001_STR_GAP_COMPLEMENTO,147000));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_REAL_COMPROMISOS,EU001_CLS_CONSTANTES.EU001_STR_REAL_AMORT,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_REAL_COMPROMISOS,EU001_CLS_CONSTANTES.EU001_STR_IMPACTO_COMPROMISOS,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_REAL_COMPROMISOS,EU001_CLS_CONSTANTES.EU001_STR_GAP_PROY,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_REAL_COMPROMISOS,EU001_CLS_CONSTANTES.EU001_STR_REAL_C_COMPLEMENTO,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_REAL_COMPROMISOS,EU001_CLS_CONSTANTES.EU001_STR_GAP_PROY_NR,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_CARTERA_CP_TAB,EU001_CLS_CONSTANTES.EU001_STR_PUNTOS_DOR,10));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_CARTERA_CP_TAB,EU001_CLS_CONSTANTES.EU001_STR_PUNTOS_POTENCIALES_DOR,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_CARTERA_CP_TAB,EU001_CLS_CONSTANTES.EU001_STR_PUNTOS_MAXIMOS_DOR,18));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_CARTERA_CP_TAB_2,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,20));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_CARTERA_CP_TAB_2,EU001_CLS_CONSTANTES.EU001_STR_LOGRO_POTENCIAL,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_CARTERA_CP_TAB_2,EU001_CLS_CONSTANTES.EU001_STR_POTENCIL_BACKLOG,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_PRESUPUESTO,EU001_CLS_CONSTANTES.EU001_STR_PRESUPUESTO,62000));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_ATRIBUTO_PESO,EU001_CLS_CONSTANTES.EU001_STR_ATRIBUTO_PESO,4));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_AMORT,EU001_CLS_CONSTANTES.EU001_STR_AMORT,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_BACKLOG,EU001_CLS_CONSTANTES.EU001_STR_BACKLOG,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_REAL_AJUSTADO,EU001_CLS_CONSTANTES.EU001_STR_REAL_AJUSTADO,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_FECHA_ACT,EU001_CLS_CONSTANTES.EU001_STR_FECHA_ACT,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_MARGEN,EU001_CLS_CONSTANTES.EU001_STR_MARGEN,0));
        listTablero.add(CrearTableroIndividua(ug,indicador,EU001_CLS_CONSTANTES.EU001_STR_FEC_MARGEN,EU001_CLS_CONSTANTES.EU001_STR_FEC_MARGEN,0));

        insert listTablero;
    }

/**
* @Method:  genereteCompromisoEU
* @Description: Método que retorna un Objeto de Compromiso Experiencia única.
* @Author:  Francisco J Licona
*/
    public static EU_001_Compromiso__c genereteCompromisoEU(String devNameTipoRegistro, String indicadorCartera, String estatus, Integer diasCierre, Id opp, Id reunionIndividual) {
        final EU_001_Compromiso__c comp = new EU_001_Compromiso__c();
        comp.RecordTypeId = RecordTypeMemory_cls.getRecType('EU_001_Compromiso__c', devNameTipoRegistro);
        comp.EU_001_ls_Estatus__c = estatus;
        comp.EU_001_dv_Compromiso__c = (Math.random()*10000);
        comp.EU_fm_Fecha_Cierre__c = date.today().addDays(diasCierre);
        comp.EU_001_Rb_Oportunidad__c = opp;
        comp.EU_001_Rb_Revisi_n_Individual_RI__c = reunionIndividual;
        return comp;
    }
    /**Creacion de metodo */
    public static void createTabCertificacion1(String ug) {
        final List<ExpUni_Tablero_Grupal__c> listTablero = new List<ExpUni_Tablero_Grupal__c>();

        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_A_REUNION_INDIVIDUAL,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,80));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_A_REUNION_INDIVIDUAL,EU001_CLS_CONSTANTES.EU001_STR_GAP,12));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_A_REUNION_INDIVIDUAL,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,34));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_A_REUNION_INDIVIDUAL,EU001_CLS_CONSTANTES.EU001_STR_GAP,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_C_VISITAS_TOTALES,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_C_VISITAS_TOTALES,EU001_CLS_CONSTANTES.EU001_STR_GAP,56));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_D_OPORTUNIDADES,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_D_OPORTUNIDADES,EU001_CLS_CONSTANTES.EU001_STR_GAP,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_E_PLAN_CUENTA,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_E_PLAN_CUENTA,EU001_CLS_CONSTANTES.EU001_STR_GAP,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_F_CONTACTOS,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_F_CONTACTOS,EU001_CLS_CONSTANTES.EU001_STR_GAP,10));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_G_GANADOR,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_G_GANADOR,EU001_CLS_CONSTANTES.EU001_STR_GAP,18));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_H_CASOS_INUSUSALES,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,52.9));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_H_CASOS_INUSUSALES,EU001_CLS_CONSTANTES.EU001_STR_GAP,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_I_CONTROL_EVENTOS,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_I_CONTROL_EVENTOS,EU001_CLS_CONSTANTES.EU001_STR_GAP,12));

        insert listTablero;

    }
    /**Creacion de metodo */
    public static void createTabCertificacion2(String ug) {
        final List<ExpUni_Tablero_Grupal__c> listTablero = new List<ExpUni_Tablero_Grupal__c>();

        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_J_GESTION_PORTAFOLIO,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,80));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_J_GESTION_PORTAFOLIO,EU001_CLS_CONSTANTES.EU001_STR_GAP,12));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_A_VISITAS_TOTALES,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,34));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_A_VISITAS_TOTALES,EU001_CLS_CONSTANTES.EU001_STR_GAP,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_CONCEPTO_VISITAS_ESTRA,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_CONCEPTO_VISITAS_ESTRA,EU001_CLS_CONSTANTES.EU001_STR_GAP,56));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_C_VISITAS_COMERCIALES,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_C_VISITAS_COMERCIALES,EU001_CLS_CONSTANTES.EU001_STR_GAP,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_D_VISITAS_SEGUIMIENTO,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_D_VISITAS_SEGUIMIENTO,EU001_CLS_CONSTANTES.EU001_STR_GAP,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_E_OPORTUNIDADES,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_E_OPORTUNIDADES,EU001_CLS_CONSTANTES.EU001_STR_GAP,10));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_F_PLAN_CUENTA,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_F_PLAN_CUENTA,EU001_CLS_CONSTANTES.EU001_STR_GAP,18));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_G_CONTACTOS,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,52.9));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_G_CONTACTOS,EU001_CLS_CONSTANTES.EU001_STR_GAP,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_H_GANADOR,EU001_CLS_CONSTANTES.EU001_STR_LOGRO,0));
        listTablero.add(CrearTableroIndividua(ug,EU001_CLS_CONSTANTES.EU001_STR_CERTIFICACION_EU,EU001_CLS_CONSTANTES.EU001_STR_H_GANADOR,EU001_CLS_CONSTANTES.EU001_STR_GAP,12));

        insert listTablero;

    }

    /**
    * @Method:      crearReporteVisita
    * @param:       Id accId, Date visitaProgramada,String devNameRecordtype,String objetivoVisita
    * @Description: Método que retorna un objeto tipo Reporte de visita
    */
    public static HI001_VisitReport__c crearReporteVisita(Id accId, Date visitaProgramada,String devNameRecordtype,String objetivoVisita) {
        final HI001_VisitReport__c newRV = new HI001_VisitReport__c();
        newRV.CF001_rb_NombreComercialCliente__c = accId;
        newRV.CF001_ft_Fecha_Visita_Programada__c = visitaProgramada;
        if(String.isNotBlank(devNameRecordtype)) {
            newRv.RecordTypeId=RecordTypeMemory_cls.getRecType('HI001_VisitReport__c', devNameRecordtype);
        }
        return newRV;
    }

    /**
    * @Method:      creaVisita
    * @Description: Crea un registro del tipo dwp_kitv__Visit__c
    * @param: String tipo, String ownerId, String accountId,String tipoRegistro
    */
    public static dwp_kitv__Visit__c creaVisita(List<String >visitData) {
    //Crea un registro del tipo visita
        final dwp_kitv__Visit__c visit = new dwp_kitv__Visit__c();
        visit.Name='Visita Prueba';
        visit.dwp_kitv__visit_start_date__c= datetime.newInstance(2018, 9, 15, 13, 30, 0);
        visit.dwp_kitv__visit_duration_number__c='30';
        visit.dwp_kitv__visit_purpose_type__c=visitData[0];
        visit.dwp_kitv__visit_status_type__c='01';
        visit.Fecha_cierre__c = datetime.newInstance(2018, 9, 15, 13, 30, 0);
        visit.Check_In_Geolocation__Latitude__s = 1.254;
        visit.Check_In_Geolocation__Longitude__s = 1.654;
        visit.dwp_kitv__account_id__c=visitData[2];
        visit.dwp_kitv__visit_location_desc__c='torre bancomer';
        visit.OwnerId=visitData[1];
        visit.RecordTypeId=RecordTypeMemory_cls.getRecType('dwp_kitv__Visit__c', visitData[3]);
        insert visit;
        return visit;
    }

}