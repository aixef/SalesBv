/**
*Desarrollado por:       Indra
*Autor:                  Abraham Alfonso Tinajero Sanchez
*Proyecto:               Experiencia Unica
*Descripción:            Clase handler para componente Ligthning de cintillo de RI
*
*Cambios (Versiones)
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 23-08-2017     |    Abraham Tinajero      |           Creación
*       | 06-12-2017     |   Isaías Velázquez       |         Modificación
*1.1    | 06-02-2018     |    Javier Ortiz          | Se cambia la asignación de variables a dínamicas,
*       |                |                          | tomando como base la parametria Acciones Comerciales
*       |                |                          | y Plan de Choque
*1.2    | 21-02-2018     |   Francisco J Licona     |       Modificación
*1.3    | 28-02-2018     |  Abrhaam Tinajero        | Se actualiza el calculo de monto de la opp de nómina
*1.4    | 01-03-2018     |     Javier Ortiz         | Se agrega tope por parametria para cálculo de puntos DOR
*1.5    | 09-03-2018     |  Abraham Tinajero        | Se actualiza el calculo de Ranking potencial
*2.0    | 21-02-2018     |   Francisco J Licona     | Se re estructura la consulta de plan de choque
*2.1    | 09-05-2018     |     Javier Ortiz         | getPorCumplAlertIncMensual se eliminan casos inecesarios y
                                                      se reestructuran condiciones para asignación de banderas de iconos.
| getPorCumplAlertIncTrim se eliminan casos inecesarios.
| getPorCumplMes se crea condición para discriminar por mes, y se cambian las fechas de consulta de los registros de alertas
*3.0    | 23-05-2018     |  Ricardo Hernandez       | Se Agrega la condicion para ignorar las opp de Arrendamiento.
*3.1    | 07-08-2018     | Ricardo Hernandez        | Se Agrega la Condición para ignorar las Opp de Pipeline que no tienen Plazo
                                                      (Lista de Opp para generar Compromisos).
*3.2	| 20-08-2018	 |  Javier Ortiz Flores     | Se agrega llamado a función que extrae url de custom metadata.
*3.3    | 06-09-2018     | Ricardo Hernandez        | Se Agrega la Condición para Visualizar las Oportunidades de Pipeline Financiamiento con
                                                    Plazo y las Disposiciones. También se agrego la condición para generar compromisos de Pipeline Cartera LP o CP.
*4.0	| 04-09-2018	 |  Javier Ortiz Flores 	| Se cambia método de extracción de oportunidades para generar compromisos,
                                                    por consulta en string para cambiar parámetros dependiendo de donde se invoque el componente.
*5.0    | 14-09-2018     |   Francisco J Licona     | Se agregan métodos para, Consulta de fecha de actualización del Cintillo y datos del usuario
                                                    Dueño de la RI, al igual que Guardado de fecha de última actualización del cintillo.
*5.1	| 20-09-2018	 | 	 Francisco J Licona		| Se hace refactor de algunos métodos.
*6.0	| 24-10-2018	 |	 Francisco J Licona	    | Se agrega método para obtener fecha del tablero la cual indica la carga mas reciente del mismo.
*6.1	| 01-11-2018	 | 	 Adrian Pastor			| Se Agregan los tipos de registro para arrendamiento puro/financiero en los metodos
                                                        getOppToComp y generaCompromisosOpp
*6.2    | 05-11-2018     |   César Villanueva       | Refactorización de método de actualización de oportunidades con filtro de fecha
*6.3	| 25-01-2019	 |	 Mario Calderón			| Se agregan parámetros al método "getOppToComp" para filtrar también por familia y producto
*6.4	| 23-05-2019	 |	 Cindy Hernández		| Resolución de code smells detectados por sonar.
*6.5	| 28-05-2019	 |	 Cindy Hernández		| Recorte de las referencias al objeto GF001_Parametria__c.
*6.6	| 07-07-2019	 |	 Cindy Hernández		| Se agrega el método getOppForDiffSaldo pare resolver code smell detectado por sonar.
*6.7	| 12-07-2019	 |	 Cindy Hernández		| Los métodos getOppForDiffSaldo y oppsToUpdate se pasan a la clase EU001_cls_CompHandler_Utilities
                                                        para resolver code smell detectado por sonar.
**/
public with sharing class EU001_cls_CompHandler {

    //Constructor with no arguments
    @TestVisible
    private EU001_cls_CompHandler() {
    }

    @AuraEnabled
    /** */
    public static String getOwnerIdRi(String idRI) {
        String ownId;
        try {
            ownId = [SELECT OwnerId FROM EU001_RI__c WHERE id =: idRI].OwnerId;
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return ownId;
    }

/*@Descripción
* Obtiene el listado del equipo del DO
*------------------------------------------------------------
* @Return lista de ejecutivos del DR y DD según jerarquía.
* Autor: Javier Ortiz Flores
*/
    @AuraEnabled
    public static List<String> getDOteamPromPonderados(String ownerId, Boolean tipoDato, String tipoDirector) {
        String myPosition = '';
        List<String> equipoDO = new List<String>();
        final List<String> roleIds = new List<String>();
        List<UserRole> rolesDir = new List<UserRole>();
        try {
            myPosition = [SELECT UserRoleId FROM User WHERE Id = : ownerId][0].UserRoleId;
            rolesDir = [SELECT Id FROM UserRole WHERE parentroleid =: myPosition];
            if(!rolesDir.isEmpty()) {
                for(UserRole roles: rolesDir) {
                    roleIds.add(roles.Id);
                }
            }
            if(!roleIds.isEmpty()) {
                equipoDO = EU001_cls_GetDOTeam.getDOTeam(tipoDirector, roleIds, tipoDato);
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return equipoDO;
    }

/*@Descripción
*Obtiene la fecha inicio del trimestre actual
*------------------------------------------------------------
*@Return  Decimal Fecha de inicio del trismestre actual
*/
    @AuraEnabled
    public static Date getPrimerDiaTrim( Date dateToday) {
        Date localDate = Date.today();
        final String compare = String.valueOf(dateToday);
        try {
            if(compare != null && compare != 'null') {
                localDate = dateToday;
            }
            final Integer mes = localDate.month();
            if( mes < 4) {
                localDate = Date.newInstance(localDate.year(), 1, 1);
            } else if( mes < 7) {
                localDate = Date.newInstance(localDate.year(), 4, 1);
            } else if( mes < 10) {
                localDate = Date.newInstance(localDate.year(), 7, 1);
            } else {
                localDate = Date.newInstance(localDate.year(), 10, 1);
            }
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return localDate;
    }
/*@Descripción
*Obtiene la fecha fin del trimestre actual
*------------------------------------------------------------
*@Return  Decimal Fecha de fin del trimestre actual
*/
    @AuraEnabled
    public static Date getUltimoDiaTrim(Date dateToday) {
        Date localDate = Date.today();
        final String compare0 = String.valueOf(dateToday);
        try {
            if(compare0 != null && compare0 != 'null') {
                localDate = dateToday;
            }
            final Integer mes = localDate.month();
            Integer numberOfDays = 0;
            if( mes < 4) {
                numberOfDays = Date.daysInMonth(localDate.year(), 3);
                localDate = Date.newInstance(localDate.year(), 3, numberOfDays);
            } else if( mes < 7) {
                numberOfDays = Date.daysInMonth(localDate.year(), 6);
                localDate = Date.newInstance(localDate.year(), 6, numberOfDays);
            } else if( mes < 10) {
                numberOfDays = Date.daysInMonth(localDate.year(), 9);
                localDate = Date.newInstance(localDate.year(), 9, numberOfDays);
            } else {
                numberOfDays = Date.daysInMonth(localDate.year(), 12);
                localDate = Date.newInstance(localDate.year(), 12, numberOfDays);
            }
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return localDate;
    }

    /*@Descripción: Método que regresa el primer día del mes en curso
  *----------------------------------------------------------------
  *@Autor: Mario Calderón
  *@Fecha: 08-07-2019
  *@param: Fecha de hoy.
  *@return: Fecha con el primer día del mes actual
  *@Ejemplo: EU001_cls_CompHandler.getPrimerDiaMes(fechaHoy);
 *-----------------------------------------------------------------
  * Versión |      Autor    |             Descripción
  * v1.0     Mario Calderón     Creación
 */
    @AuraEnabled public static Date getPrimerDiaMes(Date dateToday) {
        Date localDate;
        try {
            final String compare = String.valueOf(dateToday);
        	if(compare != null && compare != 'null') {
            	localDate = dateToday;
        	}
        	final Integer mes = localDate.month();
        	localDate = Date.newInstance(localDate.year(), mes, 1);
        } catch(System.NullPointerException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return localDate;
    }

  /*@Descripción: Método que regresa el último día del mes en curso
  *---------------------------------------------------------------
  *@Autor: Mario Calderón
  *@Fecha: 08-07-2019
  *@param: Fecha de hoy.
  *@return: Fecha con el último día del mes actual
  *@Ejemplo EU001_cls_CompHandler.getUltimoDiaDosMesesSig(fechaHoy);
 *----------------------------------------------------------------
  * Versión |      Autor    |             Descripción
  * v1.0     Mario Calderón     Creación
 */

    @AuraEnabled public static Date getUltimoDiaDosMesesSig(Date dateToday) {
        Date localDate;
        	try {
        		final String compare0 = String.valueOf(dateToday);
        		if(compare0 != null && compare0 != 'null') {
            		localDate = dateToday;
        		}
        		final Date laterDate = localDate.addMonths(2);
        		final Integer mes = laterDate.month();
        		Integer numberOfDays = 0;
        		numberOfDays = Date.daysInMonth(laterDate.year(), mes);
        		localDate = Date.newInstance(laterDate.year(), mes, numberOfDays);
            } catch(System.NullPointerException e) {
                throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
            }
        return localDate;
    }

/*@Descripción
*Obtiene el total de puntos dor potenciales por ejecutivo
*20-03-2018 @AbrahamTinajero: Se actualiza consulta por propietario deRI
*27-03-2018 @AbrahamTinajero: Se actualiza consulta de opp ordenadas de menor a mayor por fecha de cierre
*05-11-2018 @CesarVillanueva: Se actualiza la consulta para el filtro de fechas de oportunidades
*06-11-2018 @LuisFernandoRomero: Se modifica filtro de oportunidades
*10-01-2019 @LuisFernandoRomero: Se elimina condición para oportunidades de disposición, se elimina condición de etapas, 
                                se corrige condición para filtro
*11-01-2019 @LuisFernandoRomero: Se excluyen oportunidades de Programa Financiero
*25-01-2019 @Mario Calderón: Se modifica consulta para el filtrado de oportunidades para filtrar por familia y por producto
*-----------------------------------------------------------------------
*@Return    Lista de Opps del propietario de la RI
*/
    @AuraEnabled@TestVisible
    public static List<OpportunityWrapper> getOppToComp(String idRI, String fechaInicio, String fechaFin, String indicadordisp, String campoPadre, String campoHijo) {
        final String ownerId = getOwnerIdRi(idRI);
        final List<OpportunityWrapper> oppWrapperList = new List<OpportunityWrapper>();
        final String[] ids = new List<String>();
        List<EU_001_Compromiso__c> oppsComps =  new List<EU_001_Compromiso__c>();
        try {
            oppsComps = [SELECT EU_001_Rb_Oportunidad__c, Name FROM EU_001_Compromiso__c WHERE EU_001_ls_Estatus__c
                        IN (:EU001_cls_CONSTANTES.EU001_STR_COMPROMISO_REPROGRAMADO, :EU001_cls_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO)
                        AND (NOT (EU_001_Rb_Oportunidad__c = NULL)) AND Ownerid = :ownerId];
            for(EU_001_Compromiso__c comp : oppsComps) {
                ids.add(comp.EU_001_Rb_Oportunidad__c);
            }
            final Date lastDate = Date.valueOf(fechaFin);
            final Date firstDay = Date.valueOf(fechaInicio);
            final list<string> excludedRecordTypes= new list<String> {'EG009_tre_ProgramaFinanciero'};
                final String camposConsult = 'Id, Account.Name, Name, CloseDate, MX_RTL_Familia__c, MX_RTL_Producto__c,'+
                ' Saldo_promedio__c, CR_SEL_Plazo__c, Probability, stageName, op_amountPivote_dv__c, Monto_de_la_oportunidad_Inv__c, '+
                'Monto_de_la_oportunidad_en_pesos__c, Numero_de_Nominados__c, Nomina_Rango_04__c, Nomina_Rango_05__c, '+
                'amount, recordTypeId, recordType.DeveloperName';
            String auxIndicador = '';
            String auxcampoPadre = '';
            String auxcampoHijo = '';
            if(!String.isBlank(indicadordisp)) {
                auxIndicador = 'MX_EU_TipoIndicador__c=:indicadordisp AND';
            }
            if(!String.isBlank(campoPadre)) {
                auxcampoPadre = ' AND MX_RTL_Familia__c=:campoPadre';
            }
            if(!String.isBlank(campoHijo)) {
                auxcampoHijo = ' AND MX_RTL_Producto__c=:campoHijo';
            }
            final String consultaOppDinam = 'SELECT '+camposConsult+' FROM Opportunity '+
                'WHERE Id!=:ids AND Ownerid = :ownerId AND Probability < 100 AND Probability > 0 AND '+ auxIndicador +
                ' CloseDate >=: firstDay AND CloseDate <=: lastDate and IsClosed= false AND Recordtype.DeveloperName!=:excludedRecordTypes' +
                auxcampoPadre+auxcampoHijo;
            final List<Opportunity> oppList = Database.query(consultaOppDinam);
            final Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>([SELECT Name, DeveloperName FROM RecordType
                                                                            WHERE sobjecttype = 'Opportunity']);
            for(Opportunity opp : oppList) {
                final OpportunityWrapper newOpp = getOppToAdd(opp, recordTypeMap);
                oppWrapperList.add(newOpp);
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return oppWrapperList;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.contractor@bbva.com
* Date          06-06-2019
* @Description  Obtain the opportunity to add for the class .
* @Comments     Created from the clipped code block of the method getOppToComp.
* @param        Opportunity opp, Map<Id, RecordType> recordTypeMap
* @return       OpportunityWrapper The opportunity to be added to the list.
* @example      public static OpportunityWrapper getOppToAdd(Opportunity opp, Map<Id, RecordType> recordTypeMap) {
**/
    public static OpportunityWrapper getOppToAdd(Opportunity opp, Map<Id, RecordType> recordTypeMap) {
        Boolean addOpp = true;
        final OpportunityWrapper newOpp = new OpportunityWrapper();
        final RecordType recordType = recordTypeMap.get(opp.recordTypeId);
        final List<String> recordTypeListToExclude = new List<String>{EU001_cls_CONSTANTES.MX_TR_OPP_PIP_FINANCIAMIENTO_ARRPURO,
                                                        EU001_cls_CONSTANTES.MX_TR_OPP_PIP_FINANCIAMIENTO_ARRFINANCIERO,
                                                        EU001_cls_CONSTANTES.EU001_TR_OPP_FINANCIAMIENTO,
                                                        EU001_cls_CONSTANTES.EU001_TR_OPP_ARRENDAMIENTO,
                                                        EU001_cls_CONSTANTES.EU001_TR_OPP_PIPELINE_FINANCIAMIENTO,
                                                        EU001_cls_CONSTANTES.EU001_TR_OPP_PIPELINE_DISPOSICION_FINANCIAMIENTO};
        if(recordTypeListToExclude.contains(recordType.DeveloperName) && String.isBlank(opp.CR_SEL_Plazo__c)) {
            addOpp = false;
        }
        if(addOpp) {
            final List<String> recordTypeList = new List<String>{EU001_cls_CONSTANTES.EU001_TR_OPP_CIE,
                                                                EU001_cls_CONSTANTES.EU001_TR_OPP_HOST_TO_HOST,
                                                                EU001_cls_CONSTANTES.EU001_TR_OPP_APLINET,
                                                                EU001_cls_CONSTANTES.EU001_TR_OPP_E_COMERCE,
                                                                EU001_cls_CONSTANTES.EU001_TR_OPP_WEBTRANSFER,
                                                                EU001_cls_CONSTANTES.EU001_TR_OPP_TPV,
                                                                EU001_cls_CONSTANTES.EU001_TR_OPP_PAGO_DE_IMPUESTOS_ADUANALES,
                                                                EU001_cls_CONSTANTES.EU001_TR_OPP_SUA};
            newOpp.seleccion = false;
            newOpp.cierre = false;
            newOpp.oppId = opp.Id;
            newOpp.oppName = opp.Name;
            newOpp.Etapa = opp.stageName;
            newOpp.oppCloseDate = opp.CloseDate;
            newOpp.nombCliente = opp.Account.Name;
            newOpp.MX_RTL_Familia = opp.MX_RTL_Familia__c;
            newOpp.MX_RTL_Producto = opp.MX_RTL_Producto__c;
            newOpp.recordTypeId = opp.recordTypeId;
            newOpp.CR_SEL_Plazo = opp.CR_SEL_Plazo__c;
            newOpp.probability = opp.Probability;
            newOpp.recordTypeDevName = recordType.DeveloperName;

            if(recordType.DeveloperName.equals(EU001_cls_CONSTANTES.EU001_TR_OPP_DISPOSICION)) {
                newOpp.oppAmount = opp.op_amountPivote_dv__c;
            } else if(recordType.DeveloperName.equals(EU001_cls_CONSTANTES.EU001_TR_OPP_NOMINA) ||
                        recordType.DeveloperName.equals(EU001_cls_CONSTANTES.EU001_TR_OPP_NOMINA_USAC)) {
                            newOpp.oppAmount = opp.amount;
                            newOpp.Numero_de_Nominados = opp.Numero_de_Nominados__c;
                            newOpp.Nomina_Rango_04 = opp.Nomina_Rango_04__c;
                            newOpp.Nomina_Rango_05 = opp.Nomina_Rango_05__c;
            } else if(recordTypeList.contains(recordType.DeveloperName)) {
                newOpp.oppAmount = opp.Monto_de_la_oportunidad_en_pesos__c;
            } else {
                newOpp.oppAmount = opp.amount;
            }
        }
        return newOpp;
    }

/*@Descripción
*Clase wrapper de opportunidades
*-----------------------------------------------------------
*/
    @TestVisible public class OpportunityWrapper {
        @auraEnabled
        /** */
        public String recordTypeDevName {get; set;}
        @auraEnabled
        /** */
        public Boolean seleccion {get; set;}
        @auraEnabled
        /** */
        public Boolean cierre {get; set;}
        @auraEnabled
        /** */
        public Id oppId {get; set;}
        @auraEnabled
        /** */
        public String oppName {get; set;}
        @auraEnabled
        /** */
        public Decimal oppAmount {get; set;}
        @auraEnabled
        /** */
        public Date oppCloseDate {get; set;}
        @auraEnabled
        /** */
        public String MX_RTL_Familia {get; set;}
        @auraEnabled
        /** */
        public String MX_RTL_Producto {get; set;}
        @AuraEnabled
        /** */
        public String CR_SEL_Plazo {get; set;}
        @auraEnabled
        /** */
        public Decimal probability {get; set;}
        @auraEnabled
        /** */
        public String nombCliente {get; set;}
        @auraEnabled
        /** */
        public Id recordTypeId {get; set;}
        @auraEnabled
        /** */
        public Decimal Numero_de_Nominados {get; set;}
        @auraEnabled
        /** */
        public Decimal Nomina_Rango_04 {get; set;}
        @auraEnabled
        /** */
        public Decimal Nomina_Rango_05 {get; set;}
        @auraEnabled
        /** */
        public String Etapa {get; set;}
    }

/*@Descripción
*Se agrego método para generar Compromisos de la banca BPYP
*18-05-2018
*Monserrat Gonzalez */

    @AuraEnabled
    public static Boolean generaCompromisosOppBPYP(String listOpp) {
        final String userId = UserInfo.getUserId();
        Boolean result = false;
        EU001_RI__c riActiva;
        final List<Id> idops=new List<Id>();
        try {
            final List<OpportunityWrapper> listOppObj = (List<OpportunityWrapper>)JSON.deserialize(listOpp,List<OpportunityWrapper>.class);
            for(OpportunityWrapper opp : listOppObj) {
                idops.add(opp.oppId);
            }
            final Map<Id,Opportunity> listOppUpt = new Map<Id,Opportunity>([SELECT Id,Name,RecordTypeId,CloseDate,Amount,MX_RTL_Familia__c,RecordType.DeveloperName
                                                                                FROM Opportunity WHERE Id in :idops]);

            riActiva = [SELECT Id FROM EU001_RI__c WHERE EU001_tx_Estado__c IN (:Label.MX_BPP_Comp_StatusPresentacion,:Label.MX_BPP_Comp_StatusPreparacion)
                        AND Ownerid = :userId LIMIT 1];

            compData(riActiva, listOppObj, listOppUpt);
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        } catch(DmlException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        } catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return result;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.contractor@bbva.com
* Date          07-06-2019
* @Description  Insert commitments .
* @Comments     Created from the clipped code block of the method generaCompromisosOppBPYP.
* @param        EU001_RI__c riActiva, List<OpportunityWrapper> listOppObj, Map<Id,Opportunity> listOppUpt
* @void
* @example      public static void compData(EU001_RI__c riActiva, List<OpportunityWrapper> listOppObj, Map<Id,Opportunity> listOppUpt) {
**/

    public static void compData(EU001_RI__c riActiva, List<OpportunityWrapper> listOppObj, Map<Id,Opportunity> listOppUpt) {

        final List<EU_001_Compromiso__c> compList = new List<EU_001_Compromiso__c>();
        final List<Opportunity> oppsToUpd = new List<Opportunity>();
        for(OpportunityWrapper opp : listOppObj) {
            if(opp.seleccion) {
                Boolean isBPyP = false;
                final EU_001_Compromiso__c nuevoComp = new EU_001_Compromiso__c();
                nuevoComp.EU_001_Rb_Revisi_n_Individual_RI__c = riActiva.Id;
                nuevoComp.EU_001_Rb_Oportunidad__c = opp.oppId;
                nuevoComp.EU_001_ls_Estatus__c = Label.MX_BPP_Comp_StatusAbierto;
                nuevoComp.EU_fm_Fecha_Cierre__c  = opp.oppCloseDate;
                nuevoComp.EU_001_dv_Compromiso__c = opp.oppAmount;
                isBPyP = EU001_cls_CompHandler_Utilities.checkBPyP(listOppUpt.get(opp.oppId).MX_RTL_Familia__c);
                String iDD = EU001_cls_CompHandler_Utilities.setRecordTypeId(listOppUpt.get(opp.oppId).MX_RTL_Familia__c);
                if(isBPyP){
                    nuevoComp.RecordTypeId = iDD;
                    nuevoComp.EU_001_ls_Indicadores_de_cartera__c = listOppUpt.get(opp.oppId).MX_RTL_Familia__c;
                }
                compList.add(nuevoComp);
                if (isBPyP && ((opp.oppCloseDate <> listOppUpt.get(opp.oppId).CloseDate) || (opp.oppAmount <> listOppUpt.get(opp.oppId).Amount))) {
                    final Opportunity oppToUpd = new Opportunity();
                    oppToUpd.Id = opp.oppId;
                    oppToUpd.CloseDate = opp.oppCloseDate;
                    oppToUpd.Amount = opp.oppAmount;
                    oppToUpd.op_amountPivote_dv__c  = opp.oppAmount;
                    oppsToUpd.add(oppToUpd);
                }
            }
        }
        EU001_cls_CompHandler_Utilities.insertarCompromisos(compList);
    }

/*@Descripción
*Obtiene el número de compromisos Abiertos
*------------------------------------------------------------
*@Return    Número de compromisos Abiertos
*/
    public static void actualizaMonto(List<EU_001_Compromiso__c> listComp) {
        final String[] arrayIdsOpp = new List<String>();

        for(EU_001_Compromiso__c comp : listComp) {
            arrayIdsOpp.add(comp.EU_001_Rb_Oportunidad__c);
        }

        final List<Opportunity> oppComp = [SELECT Id, Tipo_Producto__c, Tipo_de_Registro_Manual2__c  , MX_RTL_Familia__c, Saldo_promedio__c, op_amountPivote_dv__c, CloseDate,Monto_de_la_oportunidad_Inv__c
                                     FROM Opportunity
                                     WHERE Id IN :arrayIdsOpp
                                     AND probability < 100
                                     AND probability > 1 ];

        final List<Opportunity> oppUpdtComp = new List<Opportunity>();
        //Opportunity oppToCompare = new Opportunity();

        for(EU_001_Compromiso__c comp : listComp) {
            for(Opportunity opp : oppComp) {
                if(opp.Id == comp.EU_001_Rb_Oportunidad__c) {
                    final Opportunity oppToUpdate = EU001_cls_CompHandler_Utilities.oppsToUpdate (comp, opp);
                    if(oppToUpdate != new Opportunity()) {
                    	oppUpdtComp.add(oppToUpdate);
                    }
                }
            }
        }
        if(oppUpdtComp.size() > 0) {
            update oppUpdtComp;
        }
    }

}