/**
 * Clase MX_WB_ActualizarLeadOppCTI_cls
 *
 */
public with sharing class MX_WB_ActualizarLeadOppCTI_cls {
	/**
    * Metodo Actualiza CTI Lead
    *
    * @param sRespuesta, doc y idobjeto
    * @return Lead
    */
	public static void actualizaCTILead(String sRespuesta, String doc, String idObjeto) {
		final Lead entLead = new Lead();
        entLead.Id = IdObjeto;
        entLead.xmlRespuesta__c = sRespuesta;
        entLead.xmlEnvio__c = doc;
        entLead.EnviarCTI__c = true;
        update entLead;
	}
}