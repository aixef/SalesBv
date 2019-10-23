/**
* ------------------------------------------------------------------------------------------------
* @Name     EU001_cls_CompHandler_Utilities
* @Author   Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* @Date     Created: 2019-07-12
* @Group    Digital Workplace Retail
* @Description Utility class for the EU001_cls_CompHandler class
* @Changes
**/
public with sharing class EU001_cls_CompHandler_Utilities {

    //Constructor with no arguments
    @TestVisible
    private EU001_cls_CompHandler_Utilities() {
    }

    /**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.contractor@bbva.com
* Date          06-06-2019
* @Description  Obtain the opportunity data to update.
* @Comments     Created from the clipped code block of the method actualizaMonto of the class EU001_cls_CompHandler.
* @param        EU_001_Compromiso__c comp, Opportunity opp
* @return       Opportunity The opportunity with the data to be updated.
* @example      public static Opportunity oppsToUpdate(comp, opp){
**/
    public static Opportunity oppsToUpdate(EU_001_Compromiso__c comp, Opportunity opp) {
        Opportunity newOpp = new Opportunity();
        final List<String> tiposRegistroLista = new List<String>{EU001_cls_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_COMERCIO_MULTIRECAUDADOR,
            EU001_cls_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_COMERCIO_DEM,
            EU001_cls_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_SIT,
            EU001_cls_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_SWIFTTI,
            EU001_cls_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_ATM,
            EU001_cls_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_SEGUROS,
            /**
*************************************************************************************
*No.    |     Fecha      |     Autor                |          Descripción
*************************************************************************************
*1.0    | 07-06-2018     |    Monserrat Gonzalez      | Se agregaron tipos de registro de bypy para la actualización del monto
**/
            Label.MX_BPP_RI_TipoCompromisoCaptacion,
            Label.MX_BPP_RI_TipoCompromisoColocacion,
            Label.MX_BPP_RI_TipoCompromisoSeguros,
            Label.MX_BPP_RI_TipoCompromisoServicios,
            EU001_cls_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_COMERCIO_INTERNACIONAL};
                if(tiposRegistroLista.contains(opp.Tipo_de_Registro_Manual2__c) || tiposRegistroLista.contains(comp.EU_001_ls_Indicadores_de_cartera__c) &&
                   (opp.closeDate != comp.EU_fm_Fecha_Cierre__c  || opp.op_amountPivote_dv__c != comp.EU_001_dv_Compromiso__c)) {
                       newOpp.Id = opp.Id;
                       newOpp.closeDate = comp.EU_fm_Fecha_Cierre__c;
                       newOpp.op_amountPivote_dv__c = comp.EU_001_dv_Compromiso__c;
                   } else if(opp.Tipo_de_Registro_Manual2__c.equals(EU001_cls_CONSTANTES.EU001_STR_FAMILIA_PRD_OPP_INVERSIONES) && (opp.closeDate != comp.EU_fm_Fecha_Cierre__c  || opp.Monto_de_la_oportunidad_Inv__c != comp.EU_001_dv_Compromiso__c)) {
                       newOpp.Id = opp.Id;
                       newOpp.closeDate = comp.EU_fm_Fecha_Cierre__c;
                       newOpp.Monto_de_la_oportunidad_Inv__c = comp.EU_001_dv_Compromiso__c;
                   } else {
                       newOpp = getOppForDiffSaldo(comp, opp);
                   }

        return newOpp;
    }

    /**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.contractor@bbva.com
* Date          07-07-2019
* @Description  Obtain the opportunity data to update.
* @Comments     Created from the clipped code block of the method oppsToUpdate.
* @param        EU_001_Compromiso__c comp, Opportunity opp
* @return       Opportunity The opportunity with the data to be updated.
* @example      getOppForDiffSaldo(comp, opp)
**/
    public static Opportunity getOppForDiffSaldo(EU_001_Compromiso__c comp, Opportunity opp) {
        final Opportunity newOpp = new Opportunity();
        if(opp.closeDate != comp.EU_fm_Fecha_Cierre__c  || opp.Saldo_promedio__c != comp.EU_001_dv_Compromiso__c) {
            newOpp.Id = opp.Id;
            newOpp.closeDate = comp.EU_fm_Fecha_Cierre__c;
            newOpp.Saldo_promedio__c = comp.EU_001_dv_Compromiso__c;
        }
        return newOpp;
    }

    public static void insertarCompromisos(List<EU_001_Compromiso__c> compList){
        if(!compList.isEmpty()) {
            insert compList;
        }
    }

    public static Boolean checkBPyP(String familia){
        Boolean isBPyP = false;
        if(familia.equals(Label.MX_BPP_RI_TipoCompromisoCaptacion) || familia.equals(Label.MX_BPP_RI_TipoCompromisoColocacion)
           || familia.equals(Label.MX_BPP_RI_TipoCompromisoSeguros) || familia.equals(Label.MX_BPP_RI_TipoCompromisoServicios)){
               isBPyP = true;
           }
        return isBPyP;
    }

    public static String setRecordTypeId(String familia){
        String rTypeID;
        if(familia.equals(Label.MX_BPP_RI_TipoCompromisoCaptacion)) {
            rTypeID =  Schema.SObjectType.EU_001_Compromiso__c.getRecordTypeInfosByName().get(Label.MX_BPP_CompCaptacion).getRecordTypeId();
        } else if(familia.equals(Label.MX_BPP_RI_TipoCompromisoColocacion)) {
            rTypeID =  Schema.SObjectType.EU_001_Compromiso__c.getRecordTypeInfosByName().get(Label.MX_BPP_CompColocacion).getRecordTypeId();
        } else if(familia.equals(Label.MX_BPP_RI_TipoCompromisoSeguros)) {
            rTypeID =  Schema.SObjectType.EU_001_Compromiso__c.getRecordTypeInfosByName().get(Label.MX_BPP_Seguros).getRecordTypeId();
        } else if(familia.equals(Label.MX_BPP_RI_TipoCompromisoServicios)) {
            rTypeID =  Schema.SObjectType.EU_001_Compromiso__c.getRecordTypeInfosByName().get(Label.MX_BPP_CompServicios).getRecordTypeId();
        }
        return rTypeID;
    }

}