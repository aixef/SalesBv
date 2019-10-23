/**
* Fecha            	Autor               	Descripción
* 12/18/2017       	Ricardo Almanza     	Creación de la clase para Avanzar oportunidad en BPyP
* 01/30/2018       	Ricardo Almanza    		Mejora para regla de validación que bloquea el modificar un campo después de cerrar oportunidad
* 02/06/2018       	Ricardo Almanza     	Bloquear cierre de oportunidad si no se es perfil Estandar o DO
* 02/08/2018       	Ricardo Almanza     	Asigna numero de cliente, si ya existe lo busca y asigna lo del prospecto al cliente,
* 02/23/2018       	Ricardo Almanza     	se creo metodo para obtener usuario que lo ejecuta y poder bloquear la actualización,
* 12/20/2018	   	Adrián Pastor			Se crea método para obtener los motivos de descarte segun sea el tipo de registro de la oportunidad creada.
* 12/20/2018	   	Mario Calderón			Se agrega boolean para utilizar regla de validación que fuerza al usuario a cerrar una oportunidad con
												el botón de flujo
* 12/28/2018	   	Mario Calderón	   		Se agregan parámetros de motivo de descarte y otro motivo de descarte en caso de que la
* 												etapa de la oportunidad sea Descartada/Rechazada
* 15/08/2019		Cindy Hernández	   		Se modifica el método updOpp para incluir los tipos de registro MX_BPP_PersonAcc_NoClient y MX_BPP_PersonAcc_Client.
*/
public with sharing class BpyP_Adv_Opp {

	/** String RecordTypeDeveloperName Account */
	static final String RTNOCLIENTE = 'BPyP_tre_noCliente';
	/** String RecordTypeDeveloperName Opportunity */
	static final String RTPNOCLIENTE = 'MX_BPP_PersonAcc_NoClient';

	@TestVisible
	private BpyP_Adv_Opp() {
  	}

	@AuraEnabled
	/**
	* Query a MX_BPP_Motivos_Descarte__c
	*/
	public static List<MX_BPP_Motivos_Descarte__c> motivosDescarte(String tgr) {
		try {
        	return [SELECT Id, MX_BPP_Motivo__c FROM MX_BPP_Motivos_Descarte__c WHERE Name Like :tgr+'%'];
		} catch(QueryException e) { throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e); }
    }
	@AuraEnabled
	/**
	*Query a Opportunity de acuerdo al Id
	*/
    public static Opportunity fetchOpp(String oppId) {
		try {
    		return [Select Id, Name, StageName, RecordType.Name, RecordType.Id, AccountId, Account.RecordType.DeveloperName, op_amountPivote_dv__c,MX_BPP_Bypass_VR__c, MX_RTL_Familia__c, MX_RTL_Producto__c from Opportunity where Id=:oppId];
		} catch(QueryException e) { throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e); }
    }
	@AuraEnabled
	/**
	*Query a User del usuario actual
	*/
    public static User fetchUsr() {
		try {
    		return [Select Id,Name,Profile.Name from User where Id=:UserInfo.getUserId()];
		} catch(QueryException e) { throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e); }
    }
	@AuraEnabled
	/**
	*Actualiza Oportunidad y objetos relacionados
	*/
    public static Result updOpp(String oppId,String stgNm,String clNum,Decimal amm,boolean bypass, String motivoDescarte, String otroMDescarte) {
		Result result = null;
        try {
        System.debug('Entrada Etgapa: '+stgNm);
    	final List<Opportunity> opp=[Select Id, Name, StageName, RecordType.Id, AccountId, Account.RecordType.DeveloperName, op_amountPivote_dv__c,MX_BPP_Bypass_VR__c,HI_ls_MotivoDescarte__c,Otro_motivo_de_descarte__c from Opportunity where Id=:oppId];
    	Account[] prext=null;
    	if(clNum!='0'&&clNum!=null&&clNum!='') {
    		prext=[Select Id,Name from Account where No_de_cliente__c=:clNum];
    	}
		BpyP_Adv_OppHelper.eOppEmpty(opp);
        final Account oAccount=[Select Id,AccountNumber,RecordTypeId,RecordType.DeveloperName from Account where Id=:opp[0].AccountId]; //NOSONAR
    	final User oUser=[Select Id,Name,Profile.Name from User where Id=:UserInfo.getUserId()];
		BpyP_Adv_OppHelper.eUserProfile(oUser);
    	if(prext!=null&&prext.size()>0) {
    		//Lista de objetos a Actualizar
    		final SObject[] toupd=new List<SObject>();
    		//Tareas
			SObject[] taskUpd=new List<SObject>();
			taskUpd = BpyP_Adv_OppHelper.updOppTask(oAccount, prext);
			toupd.addAll(taskUpd);
    		//Reportes de visita
			SObject[] visitRepUpd=new List<SObject>();
			visitRepUpd = BpyP_Adv_OppHelper.updOppVisitRep(oAccount, prext);
			toupd.addAll(visitRepUpd);
    		//oportunidad se actualiza campo DateTime con Now para poder escribir la modificación.
			SObject[] oppDateUpd=new List<SObject>();
			oppDateUpd = BpyP_Adv_OppHelper.updOppDate(oAccount, prext);
			toupd.addAll(oppDateUpd);
    		opp[0].AccountId=prext[0].Id;opp[0].HI_tx_State__c='BPyP 1'+String.valueof(datetime.now());
    		//Contactos
			SObject[] contUpd=new List<SObject>();
			contUpd = BpyP_Adv_OppHelper.updOppCont(oAccount, prext);
			toupd.addAll(contUpd);
    		//CPC
			SObject[] cpcUpd=new List<SObject>();
			cpcUpd = BpyP_Adv_OppHelper.updOppCPC(oAccount, prext);
			toupd.addAll(cpcUpd);
    		//Actualiza la cuenta a borrar ya que se encontro numero de cliente
	    	oAccount.mancuerna_Banca_Patrimonial__c ='ToDelete'; toupd.add(oAccount);
	    	update toupd;
        } else {
            if(oAccount.RecordType.DeveloperName == RTNOCLIENTE) {
            	oAccount.RecordTypeId = RecordTypeMemory_cls.getRecType('Account','BPyP_tre_Cliente');
            } else if(oAccount.RecordType.DeveloperName == RTPNOCLIENTE) {
                oAccount.RecordTypeId = RecordTypeMemory_cls.getRecType('Account','MX_BPP_PersonAcc_Client');
            }
            oAccount.No_de_cliente__c = clNum;
	    	update oAccount;
        }
		BpyP_Adv_OppHelper.eTestralm(stgNm);
		opp[0].MX_BPP_Bypass_VR__c=bypass;
		//helperOppUpd(opp, motivoDescarte, otroMDescarte);

	    result = new Result(helperOppUpd(opp, motivoDescarte, otroMDescarte, amm, stgNm),'Correcto',null);

		} catch(Exception e) { result = new Result(null, 'Error', e.getMessage()); //NOSONAR
                             System.debug('Oportunidad Error: '+e.getMessage());
							 throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);}
		return result;
    }

	static List<Opportunity> helperOppUpd(List<Opportunity> opp, String motivoDescarte, String otroMDescarte, Decimal amm, String stgNm) {
		if(!string.isBlank(motivoDescarte) && !('--Ninguno--').equals(motivoDescarte)) {
        //opp.campo motivo descarte
            if(!String.isBlank(otroMDescarte) && motivoDescarte == 'Otros factores (campo abierto)') {
        	   	opp[0].Otro_motivo_de_descarte__c=otroMDescarte;
            }
            opp[0].HI_ls_MotivoDescarte__c=motivoDescarte;
        }

        System.debug('Oportunidad: '+opp);

	    if(amm!=null) {
	    	opp[0].op_amountPivote_dv__c=amm;
            update opp;
        }
        System.debug('Stage Name: '+stgNm);
	    opp[0].StageName=stgNm;
	    update opp;

        if (opp[0].StageName != 'Cerrada ganada' && opp[0].StageName != 'Descartada / Rechazada') {
            opp[0].MX_BPP_Bypass_VR__c=false;
        	update opp;
        }

		return opp;
	}

	/** Clase Result */
    public class Result {
		/** Lista de Oportunidades */
    	@AuraEnabled public List<Opportunity> resopp {get;set;}
		/** Respuesta */
    	@AuraEnabled public String ans {get;set;}
		/** Error */
    	@AuraEnabled public String err {get;set;}
		/** Constructor de la clase */
    	public Result(List<Opportunity> inOpp,String inAns,String inErr) {
    		resopp=inOpp;
    		ans=inAns;
    		err=inErr;
    	}
    }
}