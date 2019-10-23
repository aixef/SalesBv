/**
 * @File Name          : MX_WB_controllerMasterChecklist_ext.cls
 * @Description        : Clase extension para MX_WB_controllerMasterChecklist_cls
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              : BBVA
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 21/5/2019 16:31:16
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    21/5/2019 15:23:40   Eduardo Hernández Cuamatzi     Initial Version
**/
public virtual with sharing class MX_WB_controllerMasterChecklist_ext { //NOSONAR

    /**
    * corretName description
    * @param  producto producto description
    * @return          return description
    */
    public static String corretName (String producto) {
        String finalName = producto;
        finalName = correctASD(finalName);
        finalName = correctFrontNa(finalName);
        finalName = finalName.contains(Label.MX_SB_VTS_MOTO_LBL) ? Label.MX_SB_VTS_SEGURO_MOTO_LBL:producto;
        return finalName;
    }

    /**
    * correctASD description
    * @param  producto producto description
    * @return          correctASDN Valor correcto ASD
    */
    public static String correctASD(String producto) {
        String correctASDN = producto.toUpperCase();
        correctASDN = correctASDN.contains(Label.MX_SB_VTS_DINAMICO_LBL) ? Label.MX_SB_VTS_PRODUCTO_AUTO_DINAMICO_LBL : producto;
        correctASDN = correctASDN.contains(Label.MX_SB_VTS_DINAMICO2_LBL) ? Label.MX_SB_VTS_PRODUCTO_AUTO_DINAMICO_LBL : producto;
        return correctASDN;
    }

    /**
    * correctFrontNa description
    * @param  producto producto description
    * @return          correctFront Valor correcto Fronterizo
    */
    public static String correctFrontNa(String producto) {
        String correctFront = producto.toUpperCase();
        correctFront = correctFront.contains(Label.MX_SB_VTS_FRONTERIZO_LBL) ? Label.MX_SB_VTS_AUTO_FRONTERIZO_LBL : producto;
        correctFront = correctFront.contains(Label.MX_SB_VTS_NACIONALIZADO_LBL) ? Label.MX_SB_VTS_AUTO_NACIONALIZADO_LBL : producto;
        return correctFront;
    }

    /**
     * getPreguntas Obtiene preguntas
     * @param  devNameTR Tipo de registro a recuperar
     * @param  producto de interés
     * @return      lista de preguntas
     */
    public static List<sObject> getPreguntas(String devNameTR, String producto) {
        final List<sObject> preguntasMaster = new List<sObject>();
        final List<Master_Checklist__c> preguntas = new List<Master_Checklist__c>([Select Id, Name,MX_WB_CheckList_Name__c, MX_WB_objecion__c, recordTypeId from Master_Checklist__c where recordType.developerName =: devNameTR AND MX_WB_Producto__r.Name =: producto ORDER BY Name]);
        for(Master_Checklist__c iterapreguntas : preguntas) {
            if(String.isNotBlank(iterapreguntas.Name)) {
                preguntasMaster.add(iterapreguntas);
            }
        }
        return preguntasMaster;
    }

    /**
     * getRelacionEtapa Recupera relación con etapas
     * @param  etapa    etapa oportunidad
     * @param  producto producto de interés
     * @return          el tipo de registro a buscar
     */
    public static String getRelacionEtapa(String etapa, String producto) {
        String developerNameRT;
        final MX_WB_preguntasEtapa__c relacionMeta = MX_WB_preguntasEtapa__c.getValues(etapa);
        if(String.isNotBlank(relacionMeta.MX_WB_developerNameRT__c) && relacionMeta.MX_SB_VTS_Producto__c == producto) {
            developerNameRT=relacionMeta.MX_WB_developerNameRT__c;
        }
        return developerNameRT;
    }
}