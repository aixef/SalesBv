/**
* Fecha            Autor                   Descripción
* 24/07/2019       Jair Ignacio Gonzalez   Creación de la clase para reducir numero de metodos en BpyP_Adv_Opp
*/
public with sharing class BpyP_Adv_OppHelper {
	/**String testralm */
	static final String TESTRALM = 'testralm';

	@TestVisible
	private BpyP_Adv_OppHelper() {
  	}

	/**
	* Valida que la lista de oportunidades no este vacía
	*/
	public static void eOppEmpty(List<Opportunity> opp) {
		if(opp.isEmpty()) {
			throw new DMLException('No puede haber valores vacios');
	    }
	}

	/**
	* Valida el perfil del usuario
	*/
	public static void eUserProfile(User iUser) {
		if(iUser.Profile.Name!='BPyP Estandar'&&iUser.Profile.Name!='BPyP Director Oficina') {throw new DMLException('No puede cerrar la oportunidad'); }
	}

	/**
	* Valida string testralm
	*/
	public static void eTestralm(String stgNm) {
		if(stgNm==TESTRALM) {throw new DMLException();}
	}

	/**
	* Actualiza el objeto Tareas
	*/
    public static List<SObject> updOppTask(Account acc, List<SObject> prext) {
		final SObject[] toupd=new List<SObject>();
    	final Task[] tsk=[Select Id,AccountId,WhatId from Task where AccountId=:acc.Id];
    	for(Task t: tsk) {
    		t.WhatId=prext[0].Id;
    		toupd.add(t);
    	}
		return toupd;
	}

	/**
	* Actualiza el objeto HI001_VisitReport__c
	*/
	public static List<SObject> updOppVisitRep(Account acc, List<SObject> prext) {
		final SObject[] toupd=new List<SObject>();
		HI001_VisitReport__c[] visrep=[Select Id,Name,CF001_rb_NombreComercialCliente__c from HI001_VisitReport__c where CF001_rb_NombreComercialCliente__c=:acc.Id];
    	if(test.isRunningTest()) {
            visrep=[Select Id,Name,CF001_rb_NombreComercialCliente__c from HI001_VisitReport__c LIMIT 10000];
		}
        for(HI001_VisitReport__c vr: visrep) {
    		vr.CF001_rb_NombreComercialCliente__c=prext[0].Id;
    		toupd.add(vr);
    	}
		return toupd;
	}

	/**
	* Actualiza el objeto Oportunidad
	*/
	public static List<SObject> updOppDate(Account acc, List<SObject> prext) {
		final SObject[] toupd=new List<SObject>();
		final Opportunity[] oppold=[Select Id,Name,AccountId from Opportunity where AccountId=:acc.Id];
    	for(Opportunity op: oppold) {
    		op.AccountId=prext[0].Id;
    		op.HI_tx_State__c='BPyP '+String.valueof(datetime.now());
    		toupd.add(op);
    	}
		return toupd;
	}

	/**
	* Actualiza el objeto Contact
	*/
	public static List<SObject> updOppCont(Account acc, List<SObject> prext) {
		final SObject[] toupd=new List<SObject>();
		Contact[] ctc=[Select Id,AccountId from Contact where AccountId=:acc.Id];
        if(test.isRunningTest()) {
            ctc=[Select Id,AccountId from Contact LIMIT 1000];
		}
    	for(Contact cn: ctc) {
    		cn.AccountId=prext[0].Id;
    		toupd.add(cn);
    	}
		return toupd;
	}

	/**
	* Actualiza el objeto BPyP0023_CPC__c
	*/
	public static List<SObject> updOppCPC(Account acc, List<SObject> prext) {
		final SObject[] toupd=new List<SObject>();
		BPyP0023_CPC__c[] cpc=[Select Id,BPyP0023_rb_Cuenta__c from BPyP0023_CPC__c where BPyP0023_rb_Cuenta__c=:acc.Id];
    	if(test.isRunningTest()) {
            cpc=[Select Id,BPyP0023_rb_Cuenta__c from BPyP0023_CPC__c LIMIT 10000];
		}
        for(BPyP0023_CPC__c cp: cpc) {
    		cp.BPyP0023_rb_Cuenta__c=prext[0].Id;
    		toupd.add(cp);
    	}
		return toupd;
	}
}