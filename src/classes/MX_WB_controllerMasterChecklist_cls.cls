/****************************************************************************************************
    author: Javier Ortiz Flores
    company: Indra
    Description: controlador del componente MX_WB_cmp_MasterChecklist

    Information about changes (versions)
    -------------------------------------
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------
    1.0       01-Ene-2019     Javier Ortiz Flores          Creación de la Clase
    1.1       01-Ene-2019     Eduardo Hernández            Sobre carga de methods
    1.2    21/5/2019 15:23:40 Eduardo Hernández Cuamatzi   Re-factorized por sonar
****************************************************************************************************/
public With Sharing class MX_WB_controllerMasterChecklist_cls extends MX_WB_controllerMasterChecklist_ext {

    private MX_WB_controllerMasterChecklist_cls() {} //NOSONAR
    /**
     * inicializaObjeciones Obtiene Objeciones sin producto
     * @param  Etapa de la Oportunidad
     * @return       Lista de Objeciones
     */
    @AuraEnabled
    public static List<sObject> inicializaObjeciones(String etapa) {
        final String tipoRegistroDevName = getRelacionEtapa(etapa);
        final List<sObject> preguntasRelated = getPreguntas(tipoRegistroDevName);
        return preguntasRelated;
    }

    /**
     * getPreguntas Obtiene preguntas
     * @param  devNameTR devNameTR RecordType a recuperar
     * @return           Lista de Preguntas
     */
    public static List<sObject> getPreguntas(String devNameTR) {
        final List<sObject> preguntasMaster = new List<sObject>();
        final List<Master_Checklist__c> preguntas = new List<Master_Checklist__c>([Select Id, Name, MX_WB_objecion__c, recordTypeId
                                                                             from Master_Checklist__c
                                                                             where recordType.developerName =: devNameTR ORDER BY Name]);
        for(Master_Checklist__c iterapreguntas : preguntas) {
            if(String.isNotBlank(iterapreguntas.Name)) {
                preguntasMaster.add(iterapreguntas);
            }
        }
        return preguntasMaster;
    }

    /**
     * inicializaObjeciones Obtiene Objeciones sin producto
     * @param  Etapa de la Oportunidad
     * @param  producto del la oportunidad
     * @return         Lista de Objeciones
     */
    @AuraEnabled
    public static List<sObject> inicializaObjeciones(String etapa, String producto) {
        final String productoCorrect = corretName(producto);
        final String regTypDevName = getRelacionEtapa(etapa, productoCorrect);
        final List<sObject> preguntasRelated = getPreguntas(regTypDevName, productoCorrect);
        return preguntasRelated;
    }

    /**
     * getRelacionEtapa Recupera relación con etapas
     * @param  etapa    etapa oportunidad
     * @return          el tipo de registro a buscar
     */
    public static String getRelacionEtapa(String etapa) {
        String developerNameRT;
        final MX_WB_preguntasEtapa__c relacionMeta = MX_WB_preguntasEtapa__c.getValues(etapa);
        if(String.isNotBlank(relacionMeta.MX_WB_developerNameRT__c)) {
            developerNameRT=relacionMeta.MX_WB_developerNameRT__c;
        }
        return developerNameRT;
    }

    /**
     * llenaRespuestas Crea respuestas de Objeciones
     * @return   Preguntas de objeciones
     */
    public static Map<String, Opportunity_CheckList__c> llenaRespuestas() {
        final List<Opportunity_CheckList__c> respuestasExist = new List<Opportunity_CheckList__c>([Select id, MX_WB_MasterChecklistId__c, MX_WB_OpportunityId__c, ownerId From Opportunity_CheckList__c]);
        final Map<String, Opportunity_CheckList__c> respuestasMaster = new Map<String, Opportunity_CheckList__c>();
        for(Opportunity_CheckList__c iteraResp : respuestasExist) {
            respuestasMaster.put(iteraResp.MX_WB_MasterChecklistId__c, iteraResp);
        }
        return respuestasMaster;
    }

    /**
     * creaChecklist Crea lista de selección
     * @param  itera         respuestas a iterar
     * @param  OportunidadId Id de oportunidad trabajada
     * @return               lista de respuestas 
     */
    public static Opportunity_CheckList__c creaChecklist(RespuestasPar itera, id OportunidadId) {
        final Opportunity_CheckList__c tempNew = new Opportunity_CheckList__c();
        tempNew.MX_WB_MasterChecklistId__c = itera.id;
        tempNew.MX_WB_Valor__c = itera.check;
        tempNew.MX_WB_OpportunityId__c = OportunidadId;
        return tempNew;
    }

    /**
     * verificaDuplicados Valida si existen preguntas repetidas
     * @param  respuestas    Lista de respuestas evaluadas
     * @param  OportunidadId Oportunidad a trabajar
     * @return               Lista de preguntas
     */
    public static List<Opportunity_CheckList__c> verificaDuplicados(List<RespuestasPar> respuestas, id OportunidadId) {
        final List<Opportunity_CheckList__c> respuestasDuplicadas = new List<Opportunity_CheckList__c>();
        final String idDueno = system.UserInfo.getUserId();
        final Map<String, Opportunity_CheckList__c> respuestasExistentes = llenaRespuestas();
        for(RespuestasPar itera : respuestas) {
            if(respuestasExistentes.ContainsKey(itera.Id)) {
                final Opportunity_CheckList__c iteraRespuestas = respuestasExistentes.get(itera.Id);
                if(iteraRespuestas.ownerId.equals(idDueno)) {
                    iteraRespuestas.MX_WB_Valor__c = itera.check;
                    respuestasDuplicadas.add(iteraRespuestas);
                } else {
                    final Opportunity_CheckList__c tempNew = creaChecklist(itera, OportunidadId);
                    respuestasDuplicadas.add(tempNew);
                }
            } else if(!respuestasExistentes.ContainsKey(itera.Id)) {
                final Opportunity_CheckList__c tempNew = creaChecklist(itera, OportunidadId);
                respuestasDuplicadas.add(tempNew);
            }
        }
        return respuestasDuplicadas;
    }

    /**
     * guardaRespuestas genera registros de respuestas
     * @param  respuestas    respuestas a guardar
     * @param  OportunidadId Oportunidad trabajada
     * @return               resultado de la operación
     */
    @AuraEnabled
    public static Boolean guardaRespuestas(String respuestas, Id OportunidadId) {
        Boolean respuesta = false;
        List<Opportunity_CheckList__c> existentes = new List<Opportunity_CheckList__c>();
        if(String.isNotBlank(respuestas)) {
            final List<RespuestasPar> listRes = (List<RespuestasPar>)System.JSON.deserialize(respuestas, List<RespuestasPar>.class);
            existentes =  verificaDuplicados(listRes, OportunidadId);
        }

        if(!existentes.isEmpty()) {
            upsert existentes;
            respuesta = true;
        }

        return respuesta;
    }

     /**
     * Wrapper de clase para respuestas
     */
    public class RespuestasPar {
        /* Llamada a variable Id de la clase RespuestasPar*/
        @AuraEnabled
        public String Id {get; set;} //NOSONAR
        /* Llamada a variable Id de la clase RespuestasPar*/
        @AuraEnabled
        public String Name {get; set;} //NOSONAR
        /* Llamada a variable Id de la clase RespuestasPar*/
        @AuraEnabled
        public String RecordTypeId {get; set;} //NOSONAR
        /* Llamada a variable Id de la clase RespuestasPar*/
        @AuraEnabled
        public Boolean check { get; set; }
    }
}
