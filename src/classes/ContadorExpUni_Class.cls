/**
*Desarrollado por:       Indra
*Autor:                  CARLOS RICARDO HERNANDEZ REYES
*Proyecto:               Experiencia Unica
*Descripción:            Controlador para componente de Gráficos y consultade UG de Usuarios
*
*Cambios (Versiones)
*-------------------------------------------------------------------------------
*No.         Fecha           Autor                           Descripción
*------   ----------------   --------------------            ---------------
*1.0      02-07-2017           Ricardo Hernandez             Creación
*1.1      02-07-2017           Monserrat Gonzalez            Metodos de consulta de UG de Usuarios
*1.2      08-08-2017           Fernando Velázquez            Metodos para graficar y Listas para graficar
*1.3      09-08-2017           Fernando Velázquez            Creacion de variables para indicadores
*1.4      10-08-2017           Monserrat Gonzalez            Metodo para calcula la sumatoria de Impactos por compromiso EU
*1.5      23-08-2017           Alberto Galindo               Se acorta metodo de Actualización y se crean 3 metodos más
*1.6      30-08-2017           Monserrat Gonzalez            Método para calcular Total Meta RI para EC Certificación RI DO y EC
*1.7      30-08-2017           Fernando Velázquez            Ajuste de variables para calculo de Compromiso,Backlog,Logro Compromiso
*1.8      31-08-2017           Monserrat Gonzalez            Método para Desglosar las Metas Totales del RI Certificación RI DO y EC
*1.9      27-09-2017           Monserrat Gonzalez            Método para copiar los Apoyos y Compromisos abiertos a otra RI
*2.0      28-02-2018           Abraham Tinajero              Calculos de Plan de choque y opp para certificación EU
*2.1      13-03-2018           Abraham Tinajero              Se corrigen calculos de PLan de Cuenta para Certificación EU
*3.0      15-03-2018           Abraham Tinajero              Se actualizan los métdos de calculos para los nuevos indicadores
*3.1	  23-05-2018		   Ricardo Hernandez 			 Se modifica el calculo de las RI por mes.
*3.2      20-06-2018           Mario Rodríguez               Se modifica referencia No_de_cliente__c SHIELD
*4.0      14-09-2018           César Villanueva              Separación del método de Certificación EU
*5.0	  28-09-2019		   Francisco J Licona			 Se agregan validaciones correspondientes al proyecto BPyP en el método validaInsertEU
*5.1	  28-09-2019		   Francisco J Licona			 Se realiza correción correspondiente a error de sonarqube
*5.2      22-05-2019		   Cindy Hernández               Resolución de code smells detectados por sonar.
*5.3      28-05-2019		   Cindy Hernández               Recorte de las referencias al objeto GF001_Parametria__c. Recorte de métodos que no se utilizan.
**/
public without sharing class ContadorExpUni_Class {

    //Constructor with no arguments
    @TestVisible
    private ContadorExpUni_Class() {
    }

    @RemoteAction
    /** */
    public static void validaRIexistente(List<EU001_RI__c> revisionesIndividuales) {
        final String[] ownerIds = new List<String>();
        //Obtenemos los Id's de los RI a insertar
        for(EU001_RI__c ri: revisionesIndividuales) {
            ownerIds.add(ri.ownerid);

        }
        System.debug('Ownerss' + ownerIds);

        //Valdiamos si existe algun RI para el ejecutivo
        final List<EU001_RI__c> revisiones = [SELECT Id, Name,Ownerid FROM EU001_RI__c
                                WHERE ownerid IN :ownerIds
                                AND EU001_tx_Estado__c IN
                                (:EU001_CLS_CONSTANTES.EU001_STR_RI_PREPARACION,
                                :EU001_CLS_CONSTANTES.EU001_STR_RI_PENDIENTE_PRESENTACION,
                                :EU001_CLS_CONSTANTES.EU001_STR_RI_EVALUACION)];
        final Map<Id, EU001_RI__c> revisionesMap = new Map<Id, EU001_RI__c>();
        for(EU001_RI__c ri : revisiones) {
            revisionesMap.put(ri.OwnerId, ri);
        }

        if(!revisionesMap.isEmpty()) {
            for(EU001_RI__c ri : revisionesIndividuales) {
                        System.debug('risss' + ri.OwnerId);

                if(revisionesMap.containsKey(ri.OwnerId)) {
                                            System.debug('iguallll');
                    ri.addError(System.Label.MX_BPP_RI_Existente);
                }
            }
        }
    }

    //Hereda los compromisos abiertos en el nuevo RI
    //06-03-2017 - Se agrega cambio de estatus a los compromisos
    @RemoteAction
    /** */
    public static void nuevoRI(List<EU001_RI__c> revisionesInd) {
        final String[] ownerIds = new List<String>();
        final String[] idRI = new List<String>();

        //Se obtienen id del RI
        for(EU001_RI__c ri: revisionesInd) {
                ownerIds.add(ri.ownerid);
                idRI.add(ri.Id);
         }
        system.debug('ownerIds' + ownerIds);
        //Se Consultan los compromisos abiertos o reprogramados
        final Map<Id, EU_001_Compromiso__c> compromisoMap = new Map<Id, EU_001_Compromiso__c>();
        final List<EU_001_Compromiso__c> compromisoAR = [SELECT id, EU_001_Rb_Revisi_n_Individual_RI__c,
                                                EU001_Fm_Historico_Cambios_Fecha_Cierre__c,
                                                EU_fm_Fecha_Cierre__c,ownerid, EU_001_Rb_Oportunidad__r.Probability
                                                FROM EU_001_Compromiso__c
                                                WHERE EU_001_ls_Estatus__c
                                                IN (:EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO,
                                                :EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_REPROGRAMADO)
                                                AND ownerid IN :ownerIds];
        for (EU_001_Compromiso__c comp : compromisoAR) {
            compromisoMap.put(comp.OwnerId, comp);
        }

        final List<Case> casos = [SELECT id, Reuni_n_Individual_RI__c,ownerid
                                                FROM Case
                                                WHERE Status
                                                IN (:EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO,
                                                :EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_REPROGRAMADO)
                                                AND ownerid IN :ownerIds];


        final List<Case> upC = new List<Case>();

        if(!compromisoAR.isEmpty()) {
            updateComp(revisionesInd, compromisoMap);
        }

        if(!casos.isEmpty()) {
            for(EU001_RI__c ri: revisionesInd) {
                for(Case ca: casos) {
                    if(ca.ownerid.equals(ri.ownerid) && ri.EU001_tx_Estado__c.equals(EU001_cls_CONSTANTES.EU001_STR_RI_PREPARACION)) {
                        ca.Reuni_n_Individual_RI__c = ri.Id;
                        upC.add(ca);
                    }
                }
            }
        }
        update upC;
    }//fin metodo nuevoRI

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.contractor@bbva.com
* Date          06-06-2019
* @Description  Update commitments (EU_001_Compromiso__c).
* @Comments     Created from the clipped code block of class nuevoRI.
* @param        Id, EU_001_Compromiso__c> compromisoMap
* @void
* @example      public static void uodateComp(List<EU001_RI__c> revisionesInd, Map<Id, EU_001_Compromiso__c> compromisoMap) {
**/
    public static void updateComp(List<EU001_RI__c> revisionesInd, Map<Id, EU_001_Compromiso__c> compromisoMap) {
        final List<EU_001_Compromiso__c> up = new List<EU_001_Compromiso__c>();
        for(EU001_RI__c ri: revisionesInd) {
            if(compromisoMap.containsKey(ri.ownerid) && ri.EU001_tx_Estado__c.equals(EU001_cls_CONSTANTES.EU001_STR_RI_PREPARACION)) {
                if(compromisoMap.get(ri.ownerid).EU_001_Rb_Oportunidad__r.Probability == 100 ) {
                    compromisoMap.get(ri.ownerid).EU_001_ls_Estatus__c = EU001_cls_CONSTANTES.EU001_STR_COMPROMISO_HECHO;
                }else if(compromisoMap.get(ri.ownerid).EU_001_Rb_Oportunidad__r.Probability == 0) {
                    compromisoMap.get(ri.ownerid).EU_001_ls_Estatus__c = EU001_cls_CONSTANTES.EU001_STR_COMPROMISO_DESCARTADO;
                }
                compromisoMap.get(ri.ownerid).EU_001_Rb_Revisi_n_Individual_RI__c = ri.Id;
                up.add(compromisoMap.get(ri.ownerid));
            }
        }
        update up;
    }
}