/**
*
*Creacion de clase OppUpdEnvEmailBch_cls
* @version 1.0           02/07/2019      Julio/Eduardo/Arsenio      Modificacion y aislamiento de fecha creacion
*/
global with sharing class OppUpdEnvEmailBch_cls implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
	/**variable query*/
    global string query {get;set;}
    /**variable minuto*/
	global string minuto {get;set;}
    /**variable minuto creada*/
	global string minutoCreada {get;set;}
    /**variable minuto formalizada*/
	global string minutoFormalizada {get;set;}
    /**variable minuto tarificada*/
	global string minutoTarificada {get;set;}
    /**variable sOppAct*/
	global String sOppAct {get;set;}
	/** variable isCupon*/
	public Boolean isCupon {get;set;}

	/**Un constructor por default */
	global OppUpdEnvEmailBch_cls(string query, String minuto, String minutoCreada, String minutoFormalizada, String minutoTarificada, Boolean isCupon) {
		this.query = query;
		this.minuto            = minuto;
		this.minutoCreada      = minutoCreada;
		this.minutoFormalizada = minutoFormalizada;
		this.minutoTarificada  = minutoTarificada;
		this.isCupon  = isCupon;
	}

	/**Start*/
	global Database.querylocator start(Database.BatchableContext BC) {
		System.debug('EN OppUpdEnvEmailBch_cls.start query: ' + this.query);
		System.debug('EN OppUpdEnvEmailBch_cls.start minuto: ' + this.minuto);
		System.debug('EN OppUpdEnvEmailBch_cls.start minutoCreada: ' + this.minutoCreada);
		System.debug('EN OppUpdEnvEmailBch_cls.start minutoCreadasin: ' + minutoCreada);
		System.debug('EN OppUpdEnvEmailBch_cls.start minutoFormalizada: ' + this.minutoFormalizada);
		System.debug('EN OppUpdEnvEmailBch_cls.start minutoTarificada: ' + this.minutoTarificada);

		//Busca la zona horaria del usuario actual, ejemplo: (GMT-05:00) Hora de verano Central (America/Mexico_City)
		if(isCupon == false) {

			String sZonaIdUser = '';
			for (User objUser : [Select u.TimeZoneSidKey From User u
					where id = :UserInfo.getUserId()]) {
				sZonaIdUser = objUser.TimeZoneSidKey;
			}

			String sHoraDif = '';
			final Schema.DescribeFieldResult fieldResult = User.TimeZoneSidKey.getdescribe();
			final List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for(Schema.PicklistEntry p : ple) {
			if (sZonaIdUser == p.getValue()) {
				System.debug('Ya la encontre: ' +p.getlabel()+'  '+ p.getValue()+' \n');
				sHoraDif = p.getlabel().substring(0, 12);
				System.debug('Ya la encontre sHoraDif:  ' +sHoraDif);
				sHoraDif = sHoraDif.substring(4, sHoraDif.indexOf(':'));
				System.debug('Ya la encontre sHoraDif:  ' +sHoraDif);
				break;
			}//Fin si sZonaIdUser == p.getValue()
			}//Fin del for para ple
			System.debug('EN OppUpdEnvEmailBch_cls.start sHoraDif: ' + sHoraDif);

				DateTime dtFechaAct = DateTime.now();

				//Crea las horas y los minutos para el estatus de Formalizada
				System.debug('EN OppUpdEnvEmailBch_cls.start Formalizada: ' + this.minutoFormalizada);
				dtFechaAct = DateTime.now();
				System.debug('dtFechaAct: ' + dtFechaAct);
				final Integer iMinutosCreada = Integer.valueOf(this.minutoFormalizada) + 5;
				System.debug('iMinutosCreada: ' + iMinutosCreada);
				dtFechaAct.addHours(Integer.valueOf(sHoraDif)); //NOSONAR
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsCreada: ' + dtFechaAct);
				final DateTime dtFechaActC2 = dtFechaAct.addMinutes(-iMinutosCreada);
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsCreada dtFechaActC2: ' + dtFechaActC2);
				final Time tHoraConsCreada = Time.newInstance(dtFechaActC2.hourGmt(), dtFechaActC2.minuteGmt(), 0, 0);
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsCreada: ' + tHoraConsCreada);
				final DateTime dtFechaActC3 = dtFechaActC2.addMinutes(5);
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsCreada dtFechaActC3: ' + dtFechaActC3);
				final Time tHoraConsCreada2 = Time.newInstance(dtFechaActC3.hourGmt(), dtFechaActC3.minuteGmt(), 0, 0);
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsCreada2: ' + tHoraConsCreada2);
				query += ' And (( Opportunity.LastModifiedDate >= ' + String.valueOf(dtFechaActC2.dateGMT()) + 'T' + tHoraConsCreada;
				query += ' And Opportunity.LastModifiedDate <= ' + String.valueOf(dtFechaActC3.dateGMT()) + 'T' + tHoraConsCreada2 + ' And Status = \'Formalizada\' )';

				//Crea las horas y los minutos para el estatus de Tarificada
				System.debug('EN OppUpdEnvEmailBch_cls.start Tarificada: ' + this.minutoTarificada);
				dtFechaAct = DateTime.now();
				final Integer iMinutosFormalizada = Integer.valueOf(this.minutoTarificada) + 5;
				dtFechaAct.addHours(Integer.valueOf(sHoraDif)); //NOSONAR
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsFormalizada: ' + dtFechaAct);
				final DateTime dtFechaActF2 = dtFechaAct.addMinutes(-iMinutosFormalizada);
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsFormalizada dtFechaActF2: ' + dtFechaActF2);
				final Time tHoraConsFormalizada = Time.newInstance(dtFechaActF2.hourGmt(), dtFechaActF2.minuteGmt(), 0, 0);
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsFormalizada: ' + tHoraConsFormalizada);
				final DateTime dtFechaActF3 = dtFechaActF2.addMinutes(5);
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsFormalizada dtFechaActF3: ' + dtFechaActF3);
				final Time tHoraConsFormalizada2 = Time.newInstance(dtFechaActF3.hourGmt(), dtFechaActF3.minuteGmt(), 0, 0);
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsFormalizada2: ' + tHoraConsFormalizada2);
				query += ' OR ( Opportunity.LastModifiedDate >= ' + String.valueOf(dtFechaActF2.dateGMT()) + 'T' + tHoraConsFormalizada;
				query += ' And Opportunity.LastModifiedDate <= ' + String.valueOf(dtFechaActF3.dateGMT()) + 'T' + tHoraConsFormalizada2 + ' And Status = \'Tarificada\' )';

				//Crea las horas y los minutos para el estatus de minutoCreada
				System.debug('EN OppUpdEnvEmailBch_cls.start minutoCreada: ' + this.minutoCreada);
				dtFechaAct = DateTime.now();
				final Integer iMinutosTarificada = Integer.valueOf(this.minutoCreada) + 5;
				dtFechaAct.addHours(Integer.valueOf(sHoraDif)); //NOSONAR
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsTarificada: ' + dtFechaAct);
				final DateTime dtFechaActT2 = dtFechaAct.addMinutes(-iMinutosTarificada);
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsTarificada dtFechaActT2: ' + dtFechaActT2);
				final Time tHoraConsTarificada = Time.newInstance(dtFechaActT2.hourGmt(), dtFechaActT2.minuteGmt(), 0, 0);
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsTarificada: ' + tHoraConsTarificada);
				final DateTime dtFechaActT3 = dtFechaActT2.addMinutes(5);
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsTarificada dtFechaActT3: ' + dtFechaActT3);
				final Time tHoraConsTarificada2 = Time.newInstance(dtFechaActT3.hourGmt(), dtFechaActT3.minuteGmt(), 0, 0);
				System.debug('EN OppUpdEnvEmailBch_cls.start tHoraConsTarificada2: ' + tHoraConsTarificada2);
				query += ' OR ( Opportunity.LastModifiedDate >= ' + String.valueOf(dtFechaActT2.dateGMT()) + 'T' + tHoraConsTarificada;
				query += ' And Opportunity.LastModifiedDate <= ' + String.valueOf(dtFechaActT3.dateGMT()) + 'T' + tHoraConsTarificada2 + ' And Status = \'Creada\' ) )';

			//}//!Test.isRunningTest()

			//Si es una prueba
			if (Test.isRunningTest()) {
				query = 'Select Opportunity.Id, Opportunity.AccountId, Status, Opportunity.EnviarCTI__c, Opportunity.LastModifiedDate, ';
				query += ' MX_SB_VTS_Folio_Cotizacion__c, Opportunity.OwnerId, Opportunity.Producto__c, Opportunity.Account.PersonEmail From Quote ';
				query += ' Where Opportunity.EnviarCTI__c = false Limit 1';
			}

			System.debug('EN OppUpdEnvEmailBch_cls.start FINAL query: ' + query);
			System.debug('retur: '+ Database.getQueryLocator(query));
		}

		return Database.getQueryLocator(query);
	}

	/**Execute*/
	global void execute(Database.BatchableContext BC, List<Quote> scope) {
		System.debug('EN OppUpdEnvEmailBch_cls.');

		List<String> sProcesaSol = new List<String>();

    	//Toma la lista de reg que se estan enviando y mandalos al CTI
    	final Set<String> setIdAcc = new Set<String>();
		// config personalizada para los robots que generan cotizaciones (black list)
   		final Map<String, EmailNoValidosCotiza__c> mapEmailNoValidosCotiza = EmailNoValidosCotiza__c.getAll();
        final List<Opportunity> lOpp = new List<Opportunity>();

    	for (Quote objQuote : scope) {
   			if (!mapEmailNoValidosCotiza.containsKey(objQuote.Opportunity.Account.PersonEmail)) {
    			setIdAcc.add(objQuote.Opportunity.AccountId);
   			}//Fin si !mapEmailNoValidosCotiza.containsKey(oppAct.correoElectronicoContratante__c)
    	}
		System.debug('EN OppUpdEnvEmailBch_cls.execute setIdAcc: ' + setIdAcc);

		//Consulta los datos de los telefonos asocuados a las cuentas de la Opp
		for (Account cuenta : [Select Id, Name, MX_SecondLastName__pc, phone, Telefono_Celular2__c, Telefono_Oficina__c, PersonHomePhone
			From Account Where Id IN:setIdAcc]) {

			System.debug('EN OppUpdEnvEmailBch_cls.execute cuenta: ' + cuenta);

			Boolean bTelefOk = true;
			String sTelefono;

			sTelefono = String.isNotBlank(cuenta.Phone) ? cuenta.Phone : sTelefono;
            sTelefono = String.isNotBlank(cuenta.Telefono_Celular2__c) ? cuenta.Telefono_Celular2__c : sTelefono;
            sTelefono = String.isNotBlank(cuenta.PersonHomePhone) ? cuenta.PersonHomePhone : sTelefono;
            sTelefono = String.isNotBlank(cuenta.Telefono_Oficina__c) ? cuenta.Telefono_Oficina__c : sTelefono;

            if (!sTelefono.isNumeric())
                bTelefOk = false;

        	System.debug('ENTRO A rtwCotizacion.fnUpsertOportunidad ANTES DE ENVIARLA A WIBE sTelefono: '
        		+ sTelefono + ' bTelefOk: ' + bTelefOk);
			System.debug('EN OppUpdEnvEmailBch_cls.execute sTelefono: ' + sTelefono + ' bTelefOk: ' + bTelefOk);
			//Ve si hubo telefono y esta bien el numero mandalo a
			if (sTelefono != null && bTelefOk) {
				for (Quote objQuote : scope) {
                    sTelefono = String.isNotBlank(objQuote.MX_SB_VTS_Movil_txt__c) ? objQuote.MX_SB_VTS_Movil_txt__c : sTelefono;
                    sProcesaSol = MX_WB_CTI_cls.ProcesaSol(objQuote.OpportunityId, objQuote.MX_SB_VTS_Folio_Cotizacion__c, (isCupon)?'Cupon':'ASD', objQuote.Opportunity.OwnerId, cuenta.Name + cuenta.MX_SecondLastName__pc, sTelefono, 'Opportunity',1,'','');
                    final Opportunity objOpp = new Opportunity();
                    objOpp.Id = objQuote.OpportunityId;
                    objOpp.EnviarCTI__c = true;
                    objOpp.xmlEnvio__c = sProcesaSol[1];
                    objOpp.xmlRespuesta__c = sProcesaSol[0];
                    objOpp.Horaaproximadaenvio__c = Date.today();
                    lOpp.add(objOpp);
                }
			}//Fin si sTelefono != null && bTelefOk
		}//Fin del for para la lista de clientes asociadoa a la Opp

		update lOpp;
	}

	/**Finish*/
	global void finish(Database.BatchableContext BC) {
		System.debug('EN OppUpdEnvEmailBch_cls.finish Hora: ' + DateTime.now());
	}

}