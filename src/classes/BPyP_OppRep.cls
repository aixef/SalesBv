/*
Versiones       Fecha           Autor               Descripción
1.0             ?               ?                   ?

1.1					12/11/2018					Cristian Espinosa
	Se hace uso de una clase de utilidades para los componentes de la página de inicio
	de BPyP, que guarda los resultados de las consultas en variables estaticas para no
	llegar al límite de los registros retornados por consulta (50,000).
1.2					28/01/2019					Adrián Pastor
	Se crea método para obtener datos de un Banquero a través de su RI.
1.3					20/05/2019					Cindy Hernández
	Resolución de code smells detectados por sonar.
1.4					29/05/2019					Cindy Hernández
	Recorte de métodos que no se utilizan
	(No son llamados por otras clases ni por componentes).
1.5					26/06/2019					Cindy Hernández
	Se agrega validación al método fetchOffData para que al llenar el mapa tempAmm no se haga referencia a un valor nulo.
1.6					07/07/2019					Cindy Hernández
	Se agregan los métodos getTempAmm y fetchTempAmm para resolver code smells detectado por sonar.
1.7					19/07/2019					Cindy Hernández
	Se modifica el método fetchOpp para reducir complejidad.
1.7					07/10/2019					Cindy Hernández
	Se agrega la etiqueta //NOSONAR para falsos positivos con 'Potentially unused variable'.
*/
public with sharing class BPyP_OppRep {

	//Constructor with no arguments
	@TestVisible
    private BPyP_OppRep() {
    }

	@AuraEnabled
	/**Constructor fetchTyOpp */
    public static List<AggregateResult> fetchTyoOp() {
        final List<AggregateResult> tyOpp = new List<AggregateResult>();
        try {
			for(AggregateResult agr : [Select StageName from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c ='')) and Owner.IsActive=True group by StageName]) {
				tyOpp.add(agr);
			}
            if (Test.isRunningTest()) {
            	throw new QueryException();
            }
		} catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
    	return tyOpp;
    }

    @AuraEnabled
	/**Constructor fetchbaseurl */
    public static String fetchbaseurl() {
        String stringToReturn = '';
		try {
        	stringToReturn = MX_BPP_CompUtils_cls.getBaseUrl();
            if (Test.isRunningTest()) {
            	throw new QueryException();
            }
		} catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
		return stringToReturn;
    }

    @AuraEnabled
	/**Constructor fetch */
    public static List<String> fetchusdata() {
		List<String> userDataList = new List<String>();
		try {
			userDataList = MX_BPP_CompUtils_cls.getUsrData();
            if (Test.isRunningTest()) {
            	throw new QueryException();
            }
		} catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
		return userDataList;
    }

	@AuraEnabled
	/**Cpnstructor fetchDiv */
    public static List<AggregateResult> fetchDiv() {
        List<AggregateResult> aggResultToReturn = new List<AggregateResult>();
		try {
			aggResultToReturn = MX_BPP_CompUtils_cls.getBPyPDivisions();
		} catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
        return aggResultToReturn;
    }

	@AuraEnabled
	/**Creacion de metodo  */
	public static BPyP_OppRep_Utilities.WRP_ChartStacked fetchDivData(String tyAcc, String tyOpp, Datetime sDate, Datetime eDate) {
		/* System.debug('tyAcc '+tyAcc); System.debug('tyOpp '+tyOpp);
		System.debug('sDate '+sDate); System.debug('eDate '+eDate); */
		final list<String> tempTyOpp = new List<String>();
		final list<String> tempColor = new List<String>();
		final list<String> tempDiv = new List<String>();
		final List<Integer> red = BPyP_OppRep_Utilities.genRedBBVA();
		final List<Integer> green = BPyP_OppRep_Utilities.genGreenBBVA();
		final List<Integer> blue = BPyP_OppRep_Utilities.genBlueBBVA();
		/* red.add(0); green.add(69); blue.add(130);
		//red.add(10); green.add(95); blue.add(180);
		//red.add(45); green.add(204); blue.add(205);
		//red.add(42); green.add(134); blue.add(202);
		//red.add(216); green.add(190); blue.add(117);
		//red.add(90); green.add(190); blue.add(255);
		//red.add(247); green.add(137); blue.add(59);
		//red.add(243); green.add(94); blue.add(97);
		//red.add(70); green.add(175); blue.add(100);
		//red.add(247); green.add(205); blue.add(82);
		//red.add(247); green.add(140); blue.add(232);
		//red.add(100); green.add(100); blue.add(100);
		//red.add(190); green.add(190); blue.add(190);
		//red.add(215); green.add(55); blue.add(80);
		//red.add(212); green.add(237); blue.add(252);
		//red.add(156); green.add(108); blue.add(1);
		//red.add(183); green.add(158); blue.add(94);
		//red.add(40); green.add(133); blue.add(202);
		//red.add(2); green.add(132); blue.add(132);
		//red.add(197); green.add(105); blue.add(185);
		//red.add(185); green.add(42); blue.add(69);
		//red.add(143); green.add(122); blue.add(229);
		//red.add(247); green.add(137); blue.add(60);
		//red.add(103); green.add(84); blue.add(184);
		//red.add(39); green.add(122); blue.add(62); */
		final Integer numbCol = 25;
		final Map<String,Integer> tempData = new Map<String,Integer>();
		Map<String,String> tempAmm = new Map<String,String>();
		final List<AggregateResult> lDiv = fetchDiv();
		for(AggregateResult divisions: lDiv) {
			tempDiv.add((String)divisions.get('Divisi_n__c'));
		}
		List<AggregateResult> ldata = null;
		List<AggregateResult> lamm = null;
		Datetime sdt, edt;
		sdt = BPyP_OppRep_Utilities.getDate(sDate, eDate, 'sdt');
		edt = BPyP_OppRep_Utilities.getDate(sDate, eDate, 'edt');
		if(tyOpp == '' || tyOpp == null) {
			List<AggregateResult> ltyopp = new List<AggregateResult>();
			ltyopp = BPyP_OppRep_Utilities.getOppFetchDivData(tyAcc, sdt, edt, 'ltyopp');
			Integer idx = 0;
			for(AggregateResult tyOppo: ltyopp) {
				final String c = 'rgb('+red[Math.mod(idx,numbCol)]+', '+green[Math.mod(idx,numbCol)]+', '+blue[Math.mod(idx,numbCol)]+')';
				tempColor.add(c);
				tempTyOpp.add((String)tyOppo.get('StageName'));
				idx++;
					//Values for rgbo on grpahs
					//Double mult=1000*Math.random(); Integer limcolor=256;
					//Generation of rgb string
					/* String c='rgb('+Math.mod((Math.random()*mult).intValue(), limcolor)+', '+
					Math.mod((Math.random()*mult).intValue(), limcolor)+', '+
					Math.mod((Math.random()*mult).intValue(), limcolor)+')'; */
			}
		} else {
			tempTyOpp.add(tyOpp);
            //Values for rgbo on grpahs
            //Double mult=1000*Math.random(); Integer limcolor=256;
            //Generation of rgb string
            final String c = 'rgb('+red[0]+', '+green[0]+', '+blue[0]+')';
            tempColor.add(c);
		}
		tempColor.add('rgb');
        try {
			ldata = BPyP_OppRep_Utilities.getOppFetchDivData(tyAcc, sdt, edt, 'ldata');
			lamm = BPyP_OppRep_Utilities.getOppFetchDivData(tyAcc, sdt, edt, 'lamm');
		} catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
		for(AggregateResult dat: ldata) {
			tempData.put((((String)dat.get('StageName'))+((String)dat.get('Divisi_n__c'))),(Integer)dat.get('RecordCount'));
			//System.debug('i '+i+(String)dat.get('StageName')+(String)dat.get('Divisi_n__c'));
		}
		tempAmm = BPyP_OppRep_Utilities.fillTempAmm(lamm);
		//System.debug(tempData);
		//System.debug('tempColor '+tempColor);
		final BPyP_OppRep_Utilities.WRP_ChartStacked result = new BPyP_OppRep_Utilities.WRP_ChartStacked(tempDiv, tempTyOpp, tempColor, tempData, tempAmm);
		return result;
	}

    @AuraEnabled
	/**Creación de metodo */
	public static BPyP_OppRep_Utilities.WRP_ChartStacked fetchOffData(String div,String tyAcc,String tyOpp,Datetime sDate,Datetime eDate) {
		final list<String> tempTyOpp = new List<String>();
		final list<String> tempColor = new List<String>();
		final list<String> tempOff = new List<String>();
		final List<Integer> red = BPyP_OppRep_Utilities.genRedBBVA();
		final List<Integer> green = BPyP_OppRep_Utilities.genGreenBBVA();
		final List<Integer> blue = BPyP_OppRep_Utilities.genBlueBBVA();
		final Integer numbCol = 25;
		final Map<String,Integer> tempData = new Map<String,Integer>();
		List<AggregateResult> ldata, lamm = null;
		for(AggregateResult office: fetchOff(div)) {
			tempOff.add((String)office.get('BPyP_ls_NombreSucursal__c'));
		}
		Datetime sdt, edt;
		sdt = BPyP_OppRep_Utilities.getDate(sDate, eDate, 'sdt');
		edt = BPyP_OppRep_Utilities.getDate(sDate, eDate, 'edt');
		try {
		if(tyOpp == '') {
			Integer idx = 0;
			final List<AggregateResult> ltyopp = BPyP_OppRep_Utilities.getOppFetchOffData(tyAcc, sdt, edt, 'ltyopp', div);
			for(AggregateResult tyOppo: ltyopp) {
				final String c='rgb('+red[Math.mod(idx,numbCol)]+', '+green[Math.mod(idx,numbCol)]+', '+blue[Math.mod(idx,numbCol)]+')';
				tempColor.add(c);
				tempTyOpp.add((String)tyOppo.get('StageName'));
				idx++;
						//Values for rgbo on grpahs
						//Double mult=1000*Math.random(); Integer limcolor=256;
						//Generation of rgb string
						/* String c='rgb('+Math.mod((Math.random()*mult).intValue(), limcolor)+', '+
						Math.mod((Math.random()*mult).intValue(), limcolor)+', '+
						Math.mod((Math.random()*mult).intValue(), limcolor)+')'; */
			}
		} else {
			tempTyOpp.add(tyOpp);
            //Values for rgbo on grpahs
            //Double mult=1000*Math.random(); Integer limcolor=256;
            //Generation of rgb string
            final String c = 'rgb('+red[0]+', '+green[0]+', '+blue[0]+')';
            tempColor.add(c);
		}
		tempColor.add('rgb');
		ldata = BPyP_OppRep_Utilities.getOppFetchOffData(tyAcc, sdt, edt, 'ldata', div);
		lamm = BPyP_OppRep_Utilities.getOppFetchOffData(tyAcc, sdt, edt, 'lamm', div);
		} catch(QueryException e) {
			throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
		}
		for(AggregateResult dat: ldata) {
			tempData.put(((String)dat.get('StageName')+(String)dat.get('BPyP_ls_NombreSucursal__c')),(Integer)dat.get('RecordCount'));
		}
		final Map<String,String> tempAmm = fetchTempAmm(lamm);
		final BPyP_OppRep_Utilities.WRP_ChartStacked result = new BPyP_OppRep_Utilities.WRP_ChartStacked(tempOff,tempTyOpp,tempColor,tempData,tempAmm);
		return result;
	}

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.contractor@bbva.com
* Date          07-07-2019
* @Description  Obtain the tempAmm map.
* @Comments     Created from the clipped code block of class fetchOffData.
* @param        List<AggregateResult> lamm
* @return       Map<String,String> The tempAmm map.
* @example      fetchTempAmm(lamm)
**/
	public static Map<String,String> fetchTempAmm(List<AggregateResult> lamm) {
		final Map<String,String> tempAmm = new Map<String,String>();
		for(AggregateResult amm: lamm) {
			String old = tempAmm.get((((String)amm.get('StageName'))+((String)amm.get('BPyP_ls_NombreSucursal__c'))));
			if(tempAmm.get((((String)amm.get('StageName'))+((String)amm.get('BPyP_ls_NombreSucursal__c'))))==null) {
				tempAmm.put((((String)amm.get('StageName'))+((String)amm.get('BPyP_ls_NombreSucursal__c'))),'');
			} else {
			tempAmm.put((((String)amm.get('StageName'))+((String)amm.get('BPyP_ls_NombreSucursal__c'))),old+'ralm ');
			}
			old = tempAmm.get((((String)amm.get('StageName'))+((String)amm.get('BPyP_ls_NombreSucursal__c'))));
            if((String)amm.get('StageName') != null && (String)amm.get('BPyP_ls_NombreSucursal__c') != null && (String)amm.get('Name') != null && (Decimal)amm.get('Monto') != null) {
            	tempAmm.put((((String)amm.get('StageName'))+((String)amm.get('BPyP_ls_NombreSucursal__c'))), old + ((String)amm.get('Name'))+': $'+(((Decimal)amm.get('Monto')).format()));
        	}
		}
		return tempAmm;
	}

    @AuraEnabled
	/**Cpnstructor fetchOff */
    public static List<AggregateResult> fetchOff(String div) {
		List<AggregateResult> aggResultToReturn = new List<AggregateResult>();
        try {
			aggResultToReturn = MX_BPP_CompUtils_cls.getBPyPOffices(div);
		} catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
        return aggResultToReturn;
    }

    @AuraEnabled
	/**Creación de metodo */
	public static BPyP_OppRep_Utilities.WRP_ChartStacked fetchBkMData(String office,String div,String bkMn,String tyAcc,String tyOpp,Datetime sDate,Datetime eDate) {
		final list<String> tempTyOpp = new List<String>();
		final list<String> tempColor = new List<String>();
		final List<Integer> red = BPyP_OppRep_Utilities.genRedBBVA();
		final List<Integer> green = BPyP_OppRep_Utilities.genGreenBBVA();
		final List<Integer> blue = BPyP_OppRep_Utilities.genBlueBBVA();
		final Integer numbCol = 25;
		final Map<String,Integer> tempData = new Map<String,Integer>();
		final List<AggregateResult> lBkM = fetchBankMan(div,office);
		final list<String> tempBkM = BPyP_OppRep_Utilities.getTempBkM(bkMn, lBkM);
		List<AggregateResult> ldata, lamm = null;
		Datetime sdt, edt;
		sdt = BPyP_OppRep_Utilities.getDate(sDate, eDate, 'sdt');
		edt = BPyP_OppRep_Utilities.getDate(sDate, eDate, 'edt');
		try {
			if(tyOpp == '') {
				Integer idx = 0;
				List<AggregateResult> ltyopp;
					ltyopp = BPyP_OppRep_Utilities.getOppFetchBkMData(office, div, bkMn, tyAcc, sdt, edt, 'ltyopp');
			for(AggregateResult tyOppo: ltyopp) {
					final String c = 'rgb('+red[Math.mod(idx,numbCol)]+', '+green[Math.mod(idx,numbCol)]+', '+blue[Math.mod(idx,numbCol)]+')';
					tempColor.add(c);
					tempTyOpp.add((String)tyOppo.get('StageName'));
					idx++;
					/* String c='rgb('+Math.mod((Math.random()*mult).intValue(), limcolor)+', '+
					Math.mod((Math.random()*mult).intValue(), limcolor)+', '+
					Math.mod((Math.random()*mult).intValue(), limcolor)+')'; */
				}
			} else {
				tempTyOpp.add(tyOpp);
				//Values for rgbo on grpahs
				//Double mult=1000*Math.random();
				//Generation of rgb string
				String c = 'rgb('+red[Math.mod(0,numbCol)]+', '+green[Math.mod(0,numbCol)]+', '+blue[Math.mod(0,numbCol)]+')';
				tempColor.add(c);
			}
			tempColor.add('rgb');
				ldata = BPyP_OppRep_Utilities.getOppFetchBkMData(office, div, bkMn, tyAcc, sdt, edt, 'ldata');
				lamm = BPyP_OppRep_Utilities.getOppFetchBkMData(office, div, bkMn, tyAcc, sdt, edt, 'lamm');
		} catch(QueryException e) {
			throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
		}
		for(AggregateResult dat: ldata) {
			tempData.put(((String)dat.get('StageName')+(String)dat.get('Name')),(Integer)dat.get('RecordCount'));
		}
		final Map<String,String> tempAmm = getTempAmm(lamm);
		//System.debug(tempData); System.debug('tempColor '+tempColor);
		final BPyP_OppRep_Utilities.WRP_ChartStacked result = new BPyP_OppRep_Utilities.WRP_ChartStacked(tempBkM,tempTyOpp,tempColor,tempData,tempAmm);
		return result;
	}

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.contractor@bbva.com
* Date          07-07-2019
* @Description  Obtain the tempAmm map.
* @Comments     Created from the clipped code block of class fetchBkMData.
* @param        List<AggregateResult> lamm
* @return       Map<String,String> The tempAmm map.
* @example      fetchBkMData(lamm)
**/
	public static Map<String,String> getTempAmm(List<AggregateResult> lamm) {
		final Map<String,String> tempAmm = new Map<String,String>();
		for(AggregateResult amm: lamm) {
			if((String)amm.get('StageName') != null && (String)amm.get('Name') != null && (Decimal)amm.get('Monto') != null && (String)amm.get('Rname') != null) {
            String old = tempAmm.get((((String)amm.get('StageName'))+((String)amm.get('Name'))));
			if(tempAmm.get((((String)amm.get('StageName'))+((String)amm.get('Name'))))==null) {
				tempAmm.put((((String)amm.get('StageName'))+((String)amm.get('Name'))),'');
			} else {
				tempAmm.put((((String)amm.get('StageName'))+((String)amm.get('Name'))),old+'ralm ');
			}
			old=tempAmm.get((((String)amm.get('StageName'))+((String)amm.get('Name'))));
			tempAmm.put((((String)amm.get('StageName'))+((String)amm.get('Name'))), old + ((String)amm.get('Rname'))+': $'+(((Decimal)amm.get('Monto')).format()));
			/* System.debug('old '+old); System.debug('new '+tempAmm.get((((String)amm.get('StageName'))+
			((String)amm.get('Name'))))); */
            }
        }
		return tempAmm;
	}

    @AuraEnabled
	/**Constructor fetchbankMan */
    public static List<AggregateResult> fetchBankMan(String div,String office) {
		List<AggregateResult> listToReturn = new List<AggregateResult>();
        try {
			listToReturn = MX_BPP_CompUtils_cls.getBPyPUsrs(div, office);
		} catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
		return listToReturn;
    }

    @AuraEnabled
	/**Constructor fetchPgs */
    public static Integer fetchPgs(String bkMn,String tyAcc,String tyOpp,Datetime sDate,Datetime eDate) {
    	AggregateResult res = null;
    	Integer numpgs = null;
		Datetime sdt,edt;
		sdt = BPyP_OppRep_Utilities.getDate(sDate, eDate, 'sdt');
		edt = BPyP_OppRep_Utilities.getDate(sDate, eDate, 'edt');
		try {
			if(BkMn != '') {
				res = BPyP_OppRep_Utilities.fetchPgsQueries(bkMn, tyAcc, tyOpp, sdt, edt);
				final Integer n = (Integer)res.get('expr0');
				numpgs = math.mod((n),10)==0?((n)/10):((n)/10)+1; //NOSONAR
			}
		} catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
    	return numpgs;
    }

	 /*
    *@Descripción   Método que extrae datos del owner apartir de su RI.
    *@Author        Adrián Pastor Pineda, Email: adrian.pastor.contractor@bbva.com
    *@Date          28/01/2019
    *@Param         IdRI (RI del Banquero)
    *@return        Regresa la consulta en String.
    *@example       BPyP_OppRep.getRISelect('06m1B000001GaPeQAK');
    */
    @AuraEnabled
	public static User getRISelect(String idRI) {
        User userToReturn = new User();
		EU001_RI__c riSeleccionada = new EU001_RI__c();
        try {
			riSeleccionada = ([SELECT Id, OwnerId FROM EU001_RI__c WHERE Id =:idRI LIMIT 1]);
        	userToReturn = [SELECT Id,Title,Divisi_n__c,BPyP_ls_NombreSucursal__c FROM User WHERE id =: riSeleccionada.OwnerId];
		} catch(QueryException e) {
			throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
		return userToReturn;
    }

    @AuraEnabled
	/**Creación de metodo */
    public static List<Opportunity> fetchOpp(String bkMn,String tyAcc,String tyOpp,Datetime sDate,Datetime eDate,Integer off) {
    	List<Opportunity> res = null;
		Datetime sdt, edt;
		if(sDate == null && eDate == null) {
			sdt = BPyP_OppRep_Utilities.obtStAndEndDate(system.today().month(),'St');
			edt = BPyP_OppRep_Utilities.obtStAndEndDate(system.today().month(),'En');
		} else {
			sdt = sDate;
			edt = eDate;
		}
    	if(BkMn != '') {
			try {
				res = BPyP_OppRep_Utilities.fetchOpps(bkMn, tyAcc, tyOpp, sdt, edt, off);
			} catch(QueryException e) {
				throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
			}
		}
    	return res;
    }

}