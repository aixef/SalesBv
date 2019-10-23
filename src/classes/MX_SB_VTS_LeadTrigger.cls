/**
 * @File Name          : MX_SB_VTS_LeadTrigger.cls
 * @Description        :
 * @Author             : Aixef
 * @Group              :
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 23/8/2019 16:35:06
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    9/8/2019 10:59:50   Aixef     Initial Version
**/
public without sharing class MX_SB_VTS_LeadTrigger { //NOSONAR
/**
     * evaluateLeads valida los leads de Call me back
     */
    public static void evaluateLeads(List<Lead> newEntryLead) {
        final List<String> lstListaNegra = new List<String>();
        for (Lead leadItem : newEntryLead) {
            if( leadItem.LeadSource == System.Label.MX_SB_VTS_OrigenCallMeBack) {
                evaluateWebtoLead(leadItem);
                if(String.isNotBlank(leadItem.Email)) {
                    lstListaNegra.add(leadItem.Email);
                }
                final String validPhone = evaluatePhone(leadItem);
                if (String.isNotBlank(validPhone)) {
                    lstListaNegra.add(validPhone);
                }
            }
        }
        if(lstListaNegra.isEmpty() == false) {
            evaluateBlackList(newEntryLead, lstListaNegra);
        }
    }

    /**
     * evaluateWebtoLead asigna la fecha de contacto
     */
    public static void evaluateWebtoLead(Lead leadItem) {
        if (String.isEmpty(leadItem.Priority__c) && String.isBlank(String.valueOf(leadItem.Hora_contacto__c))) {
            leadItem.Priority__c = '0';
        }
        if(String.isNotBlank(String.valueOf(leadItem.Hora_contacto__c))) {
            leadItem.Hora_contacto__c = DateTime.now();
        }
        evaluetePhoneNumber(leadItem);
    }

    /**
     * evaluateBlackList asigna el número de contacto estandar y personalizado
     */
    public static String evaluatePhone(Lead leadItem) {
        String validPhone = '';
        if(String.isNotEmpty(leadItem.TelefonoCelular__c)) {
            leadItem.MobilePhone = leadItem.TelefonoCelular__c;
            validPhone = leadItem.TelefonoCelular__c;
        } else if (String.isNotBlank(leadItem.MobilePhone)) {
            leadItem.TelefonoCelular__c = leadItem.MobilePhone;
            validPhone = leadItem.MobilePhone;
        }
        return validPhone;
    }

    /**
     * evaluateBlackList validar número teléfonico en lista negra
     */
    public static void evaluateBlackList(List<Lead> newEntryLead, List<String> lstListaNegra) {
        final Map<String,String> mapListaNegra = Utilities.verificarListaNegra(lstListaNegra);
        for (Lead leadItem : newEntryLead) {
            if(mapListaNegra.containsKey(leadItem.Email) || mapListaNegra.containsKey(leadItem.TelefonoCelular__c)) {
                leadItem.addError(System.Label.MX_SB_VTS_ErrorListaNegra);
            }
        }
    }

    /**
     * evaluetePhoneNumber validar número teléfonico
     */
    public static void evaluetePhoneNumber(Lead leadItem) {
        String sTelefono = '';
        if(String.isNotEmpty(leadItem.TelefonoCelular__c)) {
            sTelefono = leadItem.TelefonoCelular__c;
        } else if(String.isNotEmpty(leadItem.MobilePhone)) {
            sTelefono = leadItem.MobilePhone;
        }
        if (String.isNotBlank(sTelefono) && (sTelefono.isNumeric() == false || (sTelefono.length() == 10) == false)) {
            leadItem.addError(System.Label.MX_SB_VTS_ErrorValidarLead);
        }
    }
    /**
    * resta contador de toques
    */
    public static void substractContactTouch(List<Lead> leadItem, Map<Id, Lead> oldMap) {
        final Id recordType = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_Telemarketing_LBL).getRecordTypeId();
        for(Lead lst : leadItem) {

            final Lead oldLead = oldMap.get(lst.Id);
            final Integer contador = MX_SB_VTS_LeadAutoAssigner.checkNullVals(lst.MX_SB_VTS_ContadorRemarcado__c);
            if (lst.RecordTypeId.equals(recordType) && contador > 0 && lst.MX_SB_VTS_Tipificacion__c == 'No Contacto' && lst.MX_SB_VTS_Tipificacion_LV2__c == 'No Contacto' && String.isBlank(oldLead.MX_SB_VTS_Tipificacion_LV2__c)) {
                lst.MX_SB_VTS_ContadorRemarcado__c = contador-1;
            }
        }
    }

    /**
    * aumenta contador cuando es contacto efectivo
    */
    public static void substractEffectiveContact (List<Lead> leadItem,  Map<Id, Lead> oldMap) {
        final Id recordType = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_Telemarketing_LBL).getRecordTypeId();
        for(Lead lst: leadItem) {
            final Lead oldLead = oldMap.get(lst.Id);
            final Integer contador2 = MX_SB_VTS_LeadAutoAssigner.checkNullVals(lst.MX_SB_VTS_Llamadas_Efectivas__c);
            if(lst.RecordTypeId.equals(recordType) && lst.MX_SB_VTS_Tipificacion_LV2__c == 'Contacto Efectivo' && String.isBlank(oldLead.MX_SB_VTS_Tipificacion_LV2__c)) {
                lst.MX_SB_VTS_Llamadas_Efectivas__c = contador2+1;
            }
        }
    }
    /**
    * aumenta cuando es contcto no efectivo
    **/
    public static void substractNoEffectiveContact(List<Lead> leadItem, Map<Id, Lead> oldMap) {
        final Id recordType = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_Telemarketing_LBL).getRecordTypeId();
        for(Lead lst: leadItem) {
            final Lead oldLead = oldMap.get(lst.Id);
            final Integer contador3 = MX_SB_VTS_LeadAutoAssigner.checkNullVals(lst.MX_SB_VTS_Llamadas_No_Efectivas__c);
            if(lst.RecordTypeId.equals(recordType) && lst.MX_SB_VTS_Tipificacion_LV2__c == 'No Contacto' && String.isBlank(oldLead.MX_SB_VTS_Tipificacion_LV2__c)) {
                lst.MX_SB_VTS_Llamadas_No_Efectivas__c = contador3+1;
                lst.MX_SB_VTS_ContadorRemarcado__c = lst.MX_SB_VTS_ContadorRemarcado__c-1;
            }
        }
    }
}
