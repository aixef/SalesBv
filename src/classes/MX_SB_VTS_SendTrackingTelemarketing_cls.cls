/**
 * @File Name          : MX_SB_VTS_SendTrackingTelemarketing_cls.cls
 * @Description        :
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              :
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 3/10/2019 18:42:48
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    26/9/2019   Eduardo Hernández Cuamatzi     Initial Version
**/
global without sharing class MX_SB_VTS_SendTrackingTelemarketing_cls implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful { //NOSONAR
    /**variable query*/
    public string finalQuery {get;set;}
    /**variable minuto*/
	public Integer minutosCall {get;set;}
    /**variable random creada*/
    public final static Integer RANDOMNUM = 1;
    /**variable ERROR creada*/
    public final static Integer ISERRORPOST = 0;
    /**variable ERROR creada*/
    public final static String FORMATTIME = 'yyyy-MM-dd'+'\''+'T'+'\''+'hh:mm:ss';

    /**
     * MX_SB_VTS_SendTrackingTelemarketing_cls constructor
     * @param  finalQuery  query a ejecutar
     * @param  minutosCall tiempo hacia atras tracking web
     */
    global MX_SB_VTS_SendTrackingTelemarketing_cls(String finalQuery, Integer minutosCall) {
        this.finalQuery = finalQuery;
        this.minutosCall = minutosCall;
    }

    /**
     * start Inicio de batch
     * @param  batchContext contexto batch
     * @return ejecución de base
     */
    global Database.querylocator start(Database.BatchableContext batchContext) {
        final Datetime dateSend = Datetime.now();
        final String tNow = addMinutesTime(dateSend, FORMATTIME, -minutosCall);
        final String tCreada = addMinutesTime(dateSend, FORMATTIME, 0);
        this.finalQuery += ' And (Opportunity.LastModifiedDate >= ' + (tNow+'.000+0000')+ ')';
        this.finalQuery += ' And (Opportunity.LastModifiedDate <= '+ (tCreada+'.000+0000') +' And Status NOT IN (\''+'Emitida'+'\'))';
        return Database.getQueryLocator(this.finalQuery);
    }

    /**
     * execute Ejecución de batch
     * @param  batchContext contexto batch
     * @param  scopeQuotes  Resultado de ejecución base
     */
    global void execute(Database.BatchableContext batchContext, List<Quote> scopeQuotes) {
        final Map<String, EmailNoValidosCotiza__c> mapEmailNoValCtz = EmailNoValidosCotiza__c.getAll();
        final Set<String> familyProducts = new Set<String>();
        for (Quote objQuote : scopeQuotes) {
            familyProducts.add(objQuote.MX_SB_VTS_Familia_Productos__c);
        }
        final Map<Id,MX_SB_VTS_FamliaProveedores__c> mapFamProve = new Map<Id, MX_SB_VTS_FamliaProveedores__c>([Select Id, MX_SB_VTS_Familia_de_productos__c,MX_SB_VTS_Identificador_Proveedor__c, 
            Name, MX_SB_VTS_ProveedorCTI__c from MX_SB_VTS_FamliaProveedores__c where MX_SB_VTS_Familia_de_productos__c =: familyProducts]);
        final Map<String, List<SObject>> mapProveer = findMapSend(scopeQuotes, mapFamProve, mapEmailNoValCtz);
        processMaping(mapProveer);
    }

    /**
     * finish ejecución al finalizar
     * @param  batchContext contexto batch
     */
    global void finish(Database.BatchableContext batchContext) { //NOSONAR
    }

    /**
     * findMapSend recupera mapa de registros
     * @param  scopeQuotes             registros a trabajar
     * @param  mapProvers              mapa de proveedores
     * @param  mapEmailNoValCtz emails a excluir
     * @return                         lista de registros a enviar
     */
    public Map<String, List<SObject>> findMapSend(List<Quote> scopeQuotes, Map<Id,MX_SB_VTS_FamliaProveedores__c> mapProvers, Map<String, EmailNoValidosCotiza__c> mapEmailNoValCtz) {
        final Map<String, List<SObject>> mapSend = new Map<String, List<SObject>>();
        for (Quote objQuoteSend : scopeQuotes) {
            if (!mapEmailNoValCtz.containsKey(objQuoteSend.Opportunity.Account.PersonEmail)) {
                final String proveer = findProveer(objQuoteSend, mapProvers);
                if (mapSend.containsKey(proveer)) {
                    mapSend.get(proveer).add(objQuoteSend.Opportunity);
                } else {
                    final List<SObject> lstObjects = new List<SObject>{objQuoteSend.Opportunity};
                    mapSend.put(proveer, lstObjects);
                }
            }
        }
        return mapSend;
    }

    /**
     * findProveer encontrar proveedor de envio
     * @param  objQuote   lista de registros a trabajar
     * @param  mapProvers mapa de proveedores
     * @return            proveedor al que se enviara el registro
     */
    public String findProveer(Quote objQuote, Map<Id,MX_SB_VTS_FamliaProveedores__c> mapProvers) {
        String proveer = '';
        final List<MX_SB_VTS_FamliaProveedores__c> listProvee = new List<MX_SB_VTS_FamliaProveedores__c>();
        for (MX_SB_VTS_FamliaProveedores__c famProve : mapProvers.values()) {
            if(famProve.MX_SB_VTS_Familia_de_productos__c.equals(objQuote.MX_SB_VTS_Familia_Productos__c)) {
                listProvee.add(famProve);
            }
        }
        if(listProvee.size() > RANDOMNUM) {
            proveer = listProvee[Integer.valueof(math.random() * listProvee.size())].MX_SB_VTS_Identificador_Proveedor__c;
        } else {
            proveer = listProvee[0].MX_SB_VTS_Identificador_Proveedor__c;
        }
        return proveer;
    }

    /**
     * processMaping procesamiento de mapa
     * @param  mapProveer mapProveer mapa de proveedores
     */
    public static void processMaping(Map<String, List<SObject>> mapProveer) {
        final List<Opportunity> updateOpps = new List<Opportunity>();
        final Map<String, MX_SB_VTS_Lead_tray__c> mapLeadsTry = new Map<String, MX_SB_VTS_Lead_tray__c>();
        for (MX_SB_VTS_Lead_tray__c lstTrays : [Select Id,MX_SB_VTS_ProveedorCTI__c,MX_SB_VTS_ProveedorCTI__r.MX_SB_VTS_Identificador_Proveedor__c, MX_SB_VTS_ID_Bandeja__c, MX_SB_VTS_Tipo_bandeja__c from 
            MX_SB_VTS_Lead_tray__c where MX_SB_VTS_Tipo_bandeja__c =: System.Label.MX_SB_VTS_HotLeads]) {
                mapLeadsTry.put(lstTrays.MX_SB_VTS_ProveedorCTI__r.MX_SB_VTS_Identificador_Proveedor__c, lstTrays);
            }
        for (String proveer : mapProveer.keySet()) {
            switch on proveer {
                when 'SMART CENTER' {
                    updateOpps.addAll(sendOppsSmart(proveer, mapProveer, mapLeadsTry));
                }
            }
        }
        update updateOpps;
    }

    /**
     * sendOppsSmart envio a SmartCenter
     * @param  proveedor  proveedor Smart
     * @param  mapProveer Mapa de registros por proveedor
     * @param  lstTrays   Mapa de bandejas hotleads
     * @return            lista de Oportunidades enviadas
     */
    public static List<Opportunity> sendOppsSmart(String proveedor, Map<String, List<SObject>> mapProveer, Map<String, MX_SB_VTS_Lead_tray__c> lstTrays) {
        final Map<Id, Opportunity> lstOpps = new Map<Id,Opportunity>();
        final String method = 'EntRegistroGestion';
        final String serviceId = System.Label.MX_SB_VTS_SmartServiceHogar;
        final Map<Id,String> schedults = new Map<Id,String>();
        final String timeUser = findLocalTime('dd/MM/yyyy HH:mm:ss');
        for(SObject objectRec : mapProveer.get(proveedor)) {
            schedults.put(objectRec.Id, timeUser);
        }
        final Map<String,Object> response = MX_SB_VTS_SendLead_helper_cls.EntRegistroGestion_invoke(method, mapProveer.get(proveedor), '',
            serviceId, lstTrays.get(proveedor).MX_SB_VTS_ID_Bandeja__c, schedults);
        final Integer codeResp = (Integer)response.get('CARGA');
        Boolean sendOk = true;
        if (codeResp < ISERRORPOST) {
            sendOk = false;
        }
        for(SObject afterObject : mapProveer.get(proveedor)) {
            final Opportunity opps = (Opportunity)afterObject;            
            opps.EnviarCTI__c = sendOk;
            opps.xmlRespuesta__c = String.valueOf(response.get('CARGA'));
            if(lstOpps.containsKey(opps.Id) == false) {
           		lstOpps.put(opps.Id, opps);
            }
        }
        return lstOpps.values();
    }

    /**
     * findLocalTime recupera hora local
     * @param  formatTime formato de fecha
     * @return            fecha formateada
     */ 
    public static String findLocalTime (String formatTime) {
        final Datetime timeNow = Datetime.now();
        final String timeZone = [Select Id, TimeZoneSidKey from User where Id =: UserInfo.getUserId()].TimeZoneSidKey;
        return timeNow.format(formatTime,timeZone);
    }

    /**
     * addMinutesTime agrega minutos a hora local
     * @param  timeLocal tiempo local
     * @param  format    formato de hora
     * @param  minutes   minutos agregados
     * @return           fecha formateada
     */
    public static String addMinutesTime(DateTime timeLocal, String format, Integer minutes) {
        final DateTime timeUpdate = timeLocal.addMinutes(minutes);
        return timeUpdate.format(format);
    }
}