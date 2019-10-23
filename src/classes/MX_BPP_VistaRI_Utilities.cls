/**
* ------------------------------------------------------------------------------------------------
* @Name     MX_BPP_VistaRI_Utilities
* @Author   Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* @Date     Created: 2019-06-12
* @Group    Digital Workplace Retail
* @Description Get the cases owned by the banker
* @Comments Created from the clipped code from the EU001_cls_ConsolaDirector class. It supports MX_BPP_VistaRI_Cls.
* @Changes
**/

public With Sharing class MX_BPP_VistaRI_Utilities {

    //Constructor with no arguments
    private MX_BPP_VistaRI_Utilities() {
    }
    /** */
    @RemoteAction public static void updateEstatus(String recordId) {
        EU001_RI__c toUpdate = [SELECT EU001_tl_Comentario_EV__c, EU001_tl_Comentario_DO__c, EG_001_ls_Valoracion_de_RI__c, EG001_Valoracion_de_RI_DO__c FROM EU001_RI__c WHERE id =: recordId];
        if(toUpdate.EU001_tl_Comentario_EV__c <> '' && toUpdate.EU001_tl_Comentario_DO__c <> '' && toUpdate.EG_001_ls_Valoracion_de_RI__c <> '' && toUpdate.EG001_Valoracion_de_RI_DO__c <> '' ) {
            toUpdate.EU001_tx_Estado__c= 'Finalizacion';
        }
        update toUpdate;
    }

    /*@Descripción
    *Se agrego clase para Obtener compromisos y apoyos de BPyP
    *04-06-2018
    *Ricardo Almanza Angeles */

    public class BPPCompApoRes {
        /** */
        @AuraEnabled public Integer compVig {get; set;}
        /** */
        @AuraEnabled public Integer compVenc {get; set;}
        /** */
        @AuraEnabled public Integer apoyVig {get; set;}
        /** */
        @AuraEnabled public Integer apoyVenc {get; set;}
        /** */
        public BPPCompApoRes(Integer cvig,Integer cvenc,Integer avig,Integer avenc) {
            this.compVig=cvig;
            this.compVenc=cvenc;
            this.apoyVig=avig;
            this.apoyVenc=avenc;
        }
    }

    /**
	Descripción: Método para crear un caso.
	*/
    public static Case createCaseTest(String tipoApoyo, String subject, String recType, Integer sts, EU001_RI__c riRecord) {
        final Case caso = new Case();
        caso.EU001_ls_Tipo_de_apoyo__c = tipoApoyo;
        caso.Subject = subject;
        caso.EU001_fh_Fecha_propuesta_de_cierre__c = Date.today().addDays(1);
        Integer statusNumber = 2;
        if(sts == statusNumber) {
            caso.Status = EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_VENCIDO;
        } else {
            caso.Status = EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO;
        }
        caso.Reuni_n_Individual_RI__c = riRecord.id;
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recType).getRecordTypeId();
        return caso;
    }

}