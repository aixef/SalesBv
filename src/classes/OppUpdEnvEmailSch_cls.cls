/** 
*@
*Creacion de clase OppUpdEnvEmailSch_cls
*/
global with sharing class OppUpdEnvEmailSch_cls implements Schedulable {
    /** variable sQuery */
	global String sQuery {get;set;}
    /** variable sMinuto*/
	global String sMinuto {get;set;}
    /** variable minutoCreada*/
	global string minutoCreada {get;set;}
    /** variable minutoFormalizada*/
	global string minutoFormalizada {get;set;}
    /** variable minutoTarificada*/
	global string minutoTarificada {get;set;}
    /** variable isCupon*/
    public Boolean isCupon {get;set;}
    /** metodo*/
    global void execute(SchedulableContext ctx) {
        minutoCreada = label.CotizacionCreada;
        minutoTarificada = label.CotizacionTarificada;
        minutoFormalizada = label.CotizacionFormalizada;

        final OppUpdEnvEmailBch_cls oppACls = new OppUpdEnvEmailBch_cls(sQuery, sMinuto, minutoCreada, minutoFormalizada, minutoTarificada, isCupon);
        final Id batchInstanceId = Database.executeBatch(oppACls, 1);
    }
}