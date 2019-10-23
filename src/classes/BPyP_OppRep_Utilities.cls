/**
* -----------------------------------------------------------------------------------
* @Name     BPyP_OppRep_Utilities
* @Author   Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* @Date     Created: 2019-06-16
* @Group    Digital Workplace Retail
* @Description Get the cases owned by the banker
* @Comments Created from the clipped code from the EU001_cls_ConsolaDirector class.
	It supports BPyP_OppRep.
* @Changes  Fecha       Autor 	        Descripción
1.1			26/06/2019	Cindy Hernández	Se agrega validación al método fillTempAmm
										para que al llenar el mapa tempAmm no se
										haga referencia a un valor nulo.
1.2		19/07/2019		Cindy Hernández Se agrega el método fetchOpps.
1.3		15/08/2019		Cindy Hernández Se agregan referencias a los tipos de registro
										MX_BPP_PersonAcc_Client y
										MX_BPP_PersonAcc_NoClient.
**/

public with sharing class BPyP_OppRep_Utilities {

	//Constructor with no arguments
	@TestVisible
    private BPyP_OppRep_Utilities() {
    }
    /** Creacion de metodo obtStAndEndDate */
    public static Datetime obtStAndEndDate(Integer month,String type) {
		Datetime dateTimeToReturn = null;
    	if(type == 'St') {
			dateTimeToReturn = datetime.newInstance(system.today().year(),month,1);
		} else if (type == 'En') {
			final Integer numberOfDays = Date.daysInMonth(system.today().year(), month);
			dateTimeToReturn = datetime.newInstance(system.today().year(),month,numberOfDays);
		}
    	return dateTimeToReturn;
    }
	/** */
	public static List<Integer> genRedBBVA() {
        return MX_BPP_CompUtils_cls.genRedBBVA();
    }
	/** */
    public static List<Integer> genGreenBBVA() {
    	return MX_BPP_CompUtils_cls.genGreenBBVA();
    }
	/** */
    public static List<Integer> genBlueBBVA() {
    	return MX_BPP_CompUtils_cls.genBlueBBVA();
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          10-06-2019
* @Description  Manage opportunity queries for the fetchDivData method.
* @Comments     Created from the clipped code block of method fetchDivData.
* @param        String tyAcc, Datetime sdt, Datetime edt, String oppToQuery
* @return       List<AggregateResult>
* @example      public static List<AggregateResult> getOppFetchDivData(String tyAcc, Datetime sdt, Datetime edt, String oppToQuery){
**/
	public static List<AggregateResult> getOppFetchDivData(String tyAcc, Datetime sdt, Datetime edt, String oppToQuery) {
		List<AggregateResult> opp = new List<AggregateResult>();
		if(tyAcc == 'C' || tyAcc == null) {
			if(oppToQuery == 'ldata') {
				opp = [Select StageName,Owner.Divisi_n__c,count(Id) RecordCount from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) group by StageName,Owner.Divisi_n__c order by StageName];
			} else if(oppToQuery == 'lamm') {
				opp = [Select StageName,Owner.Divisi_n__c, Recordtype.Name,SUM(Amount) Monto from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and Recordtype.DeveloperName='MX_BPP_RedBpyp' and CreatedDate >=:sdt and CreatedDate <=:(edt+1) group by StageName,Owner.Divisi_n__c, Recordtype.Name order by StageName];
			} else if(oppToQuery == 'ltyopp') {
				opp = [Select StageName from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) group by StageName order by StageName];
			}
		} else if(tyAcc == 'P') {
			opp = getOppFetchDivDataForLead(tyAcc, sdt, edt, oppToQuery);
		}
		return opp;
	}

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          10-06-2019
* @Description  Manage opportunity queries for the fetchDivData method for leads.
* @Comments     Created from the clipped code block of method getOppFetchDivData.
* @param        String tyAcc, Datetime sdt, Datetime edt, String oppToQuery
* @return       List<AggregateResult>
* @example      public static List<AggregateResult> getOppFetchDivDataForLead(String tyAcc, Datetime sdt, Datetime edt, String oppToQuery){
**/
	public static List<AggregateResult> getOppFetchDivDataForLead(String tyAcc, Datetime sdt, Datetime edt, String oppToQuery) {
		List<AggregateResult> opp = new List<AggregateResult>();
		if(oppToQuery == 'ldata') {
			opp = [Select StageName,Owner.Divisi_n__c,count(Id) RecordCount from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) group by StageName,Owner.Divisi_n__c order by StageName];
		} else if(oppToQuery == 'lamm') {
			opp = [Select StageName,Owner.Divisi_n__c, Recordtype.Name,SUM(Amount) Monto from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and Recordtype.DeveloperName='MX_BPP_RedBpyp' and CreatedDate >=:sdt and CreatedDate <=:(edt+1) group by StageName,Owner.Divisi_n__c, Recordtype.Name order by StageName];
		} else if(oppToQuery == 'ltyopp') {
			opp = [Select StageName from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) group by StageName order by StageName];
		}
		return opp;
	}


/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          10-06-2019
* @Description  Fill tempAmm map for the fetchDivData method.
* @Comments     Created from the clipped code block of method fetchDivData.
* @param        List<AggregateResult> lamm
* @return       Map<String,String>
* @example      public static Map<String,String> fillTempAmm(List<AggregateResult> lamm){
**/
	public static Map<String,String> fillTempAmm(List<AggregateResult> lamm) {
		final map<String,String> tempAmm = new Map<String,String>();
		for(AggregateResult amm: lamm) {
			String old = tempAmm.get((((String)amm.get('StageName'))+((String)amm.get('Divisi_n__c'))));
			if(tempAmm.get((((String)amm.get('StageName'))+((String)amm.get('Divisi_n__c'))))==null) {
				tempAmm.put((((String)amm.get('StageName'))+((String)amm.get('Divisi_n__c'))),'');
			} else {
				tempAmm.put((((String)amm.get('StageName'))+((String)amm.get('Divisi_n__c'))),old+'ralm ');
			}
			old = tempAmm.get((((String)amm.get('StageName'))+((String)amm.get('Divisi_n__c'))));
            if((String)amm.get('StageName') != null && (String)amm.get('Divisi_n__c') != null && (String)amm.get('Name') != null && (Decimal)amm.get('Monto') != null) {
            	tempAmm.put((((String)amm.get('StageName'))+((String)amm.get('Divisi_n__c'))), old + ((String)amm.get('Name'))+': $'+(((Decimal)amm.get('Monto')).format()));
        	}
		}
		return tempAmm;
	}

	/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          10-06-2019
* @Description  Manage opportunity querie for the fetchOffData method.
* @Comments     Created from the clipped code block of method fetchOffData.
* @param        String tyAcc, Datetime sdt, Datetime edt, String oppToQuery, String div
* @return       List<AggregateResult>
* @example      public static List<AggregateResult> getOppFetchOffData(String tyAcc, Datetime sdt, Datetime edt, String oppToQuery, String div){
**/
	public static List<AggregateResult> getOppFetchOffData(String tyAcc, Datetime sdt, Datetime edt, String oppToQuery, String div) {
		List<AggregateResult> opp = new List<AggregateResult>();
		if((tyAcc == 'C' || tyAcc == null) && oppToQuery == 'ltyopp') {
					opp = [Select StageName from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) group by StageName order by StageName];
		}
        if(tyAcc == 'C') {
			if(oppToQuery == 'ldata') {
				opp = [Select StageName,Owner.BPyP_ls_NombreSucursal__c,count(Id) RecordCount from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) group by StageName,Owner.BPyP_ls_NombreSucursal__c order by StageName];
			} else if(oppToQuery == 'lamm') {
				opp = [Select StageName,Owner.BPyP_ls_NombreSucursal__c, Recordtype.Name,SUM(Amount) Monto from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) and Recordtype.DeveloperName='MX_BPP_RedBpyp' group by StageName,Owner.BPyP_ls_NombreSucursal__c, Recordtype.Name order by StageName];
			}
		} else if(tyAcc == 'P') {
			opp = getOppFetchOffDataForLead(tyAcc, sdt, edt, oppToQuery, div);
		}
		return opp;
	}

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          10-06-2019
* @Description  Manage opportunity queries for the fetchOffData method for leads.
* @Comments     Created from the clipped code block of method fetchOffData.
* @param        String tyAcc, Datetime sdt, Datetime edt, String oppToQuery, String div
* @return       List<AggregateResult>
* @example      public static List<AggregateResult> getOppFetchOffDataForLead(String tyAcc, Datetime sdt, Datetime edt, String oppToQuery, String div){
**/
	public static List<AggregateResult> getOppFetchOffDataForLead(String tyAcc, Datetime sdt, Datetime edt, String oppToQuery, String div) {
		List<AggregateResult> opp = new List<AggregateResult>();
		if(oppToQuery == 'ltyopp') {
			opp = [Select StageName from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) group by StageName order by StageName];
		} else if(oppToQuery == 'ldata') {
			opp = [Select StageName,Owner.BPyP_ls_NombreSucursal__c,count(Id) RecordCount from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and CreatedDate >=:sdt and CreatedDate <=:(edt+1)  group by StageName,Owner.BPyP_ls_NombreSucursal__c order by StageName];
		} else if(oppToQuery == 'lamm') {
			opp = [Select StageName,Owner.BPyP_ls_NombreSucursal__c, Recordtype.Name,SUM(Amount) Monto from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) and Recordtype.DeveloperName='MX_BPP_RedBpyp' group by StageName,Owner.BPyP_ls_NombreSucursal__c, Recordtype.Name order by StageName];
		}
		return opp;
	}

	/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          11-06-2019
* @Description  Get tempBkM list for the fetchBkMData method.
* @Comments     Created from the clipped code block of method fetchBkMData.
* @param        String bkMn, List<AggregateResult> lBkM
* @return       List<String>
* @example      public static List<String> getTempBkM(String bkMn, List<AggregateResult> lBkM){
**/
	public static List<String> getTempBkM(String bkMn, List<AggregateResult> lBkM) {
		final list<String> tempBkM = new List<String>();
		if(bkMn == '' || bkMn == null ) {
			if(lBkM != null) {
				for(AggregateResult bkM: lBkM) {
					tempBkM.add((String)bkM.get('Name'));
				}
			}
		} else if (bkMn != '' || bkMn != null) {
			tempBkM.add(bkMn);

		}
		return tempBkM;
	}

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          11-06-2019
* @Description  Manage opportunity queries for the fetchBkMData method.
* @Comments     Created from the clipped code block of method fetchBkMData.
* @param        String tyAcc, Datetime sdt, Datetime edt, String oppToQuery
* @return       List<AggregateResult>
* @example      public static List<AggregateResult> getOppFetchBkMData(String tyAcc, Datetime sdt, Datetime edt, String oppToQuery){
**/
	public static List<AggregateResult> getOppFetchBkMData(String office, String div, String bkMn, String tyAcc, Datetime sdt, Datetime edt, String oppToQuery) {
		List<AggregateResult> opp = new List<AggregateResult>();

		if(bkMn == '') {
			opp = getOppFetchBkMDataForClients(office, div, bkMn, tyAcc, sdt, edt, oppToQuery);
			if(tyAcc == 'P') {
				if(oppToQuery == 'ldata') {
					opp = [Select StageName,Owner.Name,count(Id) RecordCount from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and Owner.BPyP_ls_NombreSucursal__c=:office and (NOT (Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div   and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and CreatedDate >=:sdt and CreatedDate <=:(edt+1)  group by StageName,Owner.Name order by StageName];
				} else if(oppToQuery == 'lamm') {
					opp = [Select StageName,Owner.Name, Recordtype.Name Rname,SUM(Amount) Monto from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and Owner.BPyP_ls_NombreSucursal__c=:office and (NOT (Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) and Recordtype.DeveloperName='MX_BPP_RedBpyp' group by StageName,Owner.Name,Recordtype.Name order by StageName];
				} else if(oppToQuery == 'ltyopp') {
					opp = [Select StageName from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and Owner.BPyP_ls_NombreSucursal__c=:office and (NOT (Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) group by StageName order by StageName];
				}
			}
		} else if(bkMn != '') {
			opp = getOppFetchBkMDataWithBkM(office, div, bkMn, tyAcc, sdt, edt, oppToQuery);
		}
		return opp;
	}

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          11-06-2019
* @Description  Manage opportunity queries for the fetchBkMData method.
* @Comments     Created from the clipped code block of method fetchBkMData.
* @param        String office, String div, String bkMn, Datetime sdt, Datetime edt, String oppToQuery
* @return       List<AggregateResult>
* @example      public static List<AggregateResult> getOppFetchBkMDataForClients(String office,
* String div, String bkMn, Datetime sdt, Datetime edt, String oppToQuery){
**/
	public static List<AggregateResult> getOppFetchBkMDataForClients(String office, String div, String bkMn, String tyAcc, Datetime sdt, Datetime edt, String oppToQuery) {
		List<AggregateResult> opp = new List<AggregateResult>();
			if(tyAcc == 'C'  || tyAcc == null) {
				if(oppToQuery == 'ldata') {
					opp = [Select StageName,Owner.Name,count(Id) RecordCount from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) group by StageName,Owner.Name order by StageName];
				} else if(oppToQuery == 'lamm') {
					opp = [Select StageName,Owner.Name, Recordtype.Name Rname,SUM(Amount) Monto from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and Owner.BPyP_ls_NombreSucursal__c=:office and (NOT (Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div   and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) and Recordtype.DeveloperName='MX_BPP_RedBpyp' group by StageName,Owner.Name,Recordtype.Name order by StageName];
				} else if(oppToQuery == 'ltyopp') {
					opp = [Select StageName from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and Owner.BPyP_ls_NombreSucursal__c=:office and (NOT (Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div   and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) group by StageName order by StageName];
				}
			}
		return opp;
	}

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          11-06-2019
* @Description  Manage opportunity queries for the fetchBkMData method when there is a BkM.
* @Comments     Created from the clipped code block of method fetchBkMData.
* @param        String tyAcc, Datetime sdt, Datetime edt, String oppToQuery
* @return       List<AggregateResult>
* @example      public static List<AggregateResult> getOppFetchBkMDataWithBkM(String tyAcc, Datetime sdt, Datetime edt, String oppToQuery){
**/
	public static List<AggregateResult> getOppFetchBkMDataWithBkM(String office, String div, String bkMn, String tyAcc, Datetime sdt, Datetime edt, String oppToQuery) {
		List<AggregateResult> opp = new List<AggregateResult>();
		if(tyAcc == 'C') {
			if(oppToQuery == 'ldata') {
				opp = [Select StageName,Owner.Name,count(Id) RecordCount from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) and Owner.Name=:bkMn group by StageName,Owner.Name order by StageName];
			} else if(oppToQuery == 'lamm') {
				opp = [Select StageName,Owner.Name, Recordtype.Name Rname,SUM(Amount) Monto from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and Owner.BPyP_ls_NombreSucursal__c=:office and (NOT (Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div   and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) and Recordtype.DeveloperName='MX_BPP_RedBpyp' and Owner.Name=:bkMn group by StageName,Owner.Name,Recordtype.Name order by StageName];
			} else if(oppToQuery == 'ltyopp') {
				opp = [Select StageName from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and Owner.BPyP_ls_NombreSucursal__c=:office and (NOT (Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div   and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) and Owner.Name=:bkMn group by StageName order by StageName];
			}
		} else if(tyAcc == 'P') {
			if(oppToQuery == 'ldata') {
				opp = [Select StageName,Owner.Name,count(Id) RecordCount from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) and Owner.Name=:bkMn group by StageName,Owner.Name order by StageName];
			} else if(oppToQuery == 'lamm') {
				opp = [Select StageName,Owner.Name, Recordtype.Name Rname,SUM(Amount) Monto from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and Owner.BPyP_ls_NombreSucursal__c=:office and (NOT (Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div   and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) and Recordtype.DeveloperName='MX_BPP_RedBpyp' and Owner.Name=:bkMn group by StageName,Owner.Name,Recordtype.Name order by StageName];
			} else if(oppToQuery == 'ltyopp') {
				opp = [Select StageName from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and Owner.BPyP_ls_NombreSucursal__c=:office and (NOT (Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div   and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) and Owner.Name=:bkMn group by StageName order by StageName];
			}
		}
		return opp;
	}

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          10-06-2019
* @Description  Get sdt and edt datetimes.
* @Comments     Created from the clipped code block of several methods.
* @param        Datetime sDate, Datetime eDate, String dateType
* @return       Datetime
* @example      public static Datetime getDate(Datetime sDate, Datetime eDate, String dateType){
**/
	public static Datetime getDate(Datetime sDate, Datetime eDate, String dateType) {
		Datetime dateToReturn;
		if(sDate == null && eDate == null) {
			if(dateType == 'sdt') {
				dateToReturn = obtStAndEndDate(system.today().month(),'St');
			} else if (dateType == 'edt') {
				dateToReturn = obtStAndEndDate(system.today().month(),'En');
			}
		} else {
			if(dateType == 'sdt') {
				dateToReturn = sDate;
			} else if (dateType == 'edt') {
				dateToReturn = eDate;
			}
		}
		return dateToReturn;
	}

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          10-06-2019
* @Description  Process the query needed for the method fetchPgs.
* @Comments     Created from the clipped code block of method fetchPgs.
* @param        String bkMn, String tyAcc, String tyOpp, Datetime sdt, Datetime edt
* @return       AggregateResult
* @example      public static AggregateResult fetchPgsQueries(String bkMn, String tyAcc, String tyOpp, Datetime sdt, Datetime edt){
**/
	public static AggregateResult fetchPgsQueries(String bkMn, String tyAcc, String tyOpp, Datetime sdt, Datetime edt) {
    	AggregateResult res = null;
		if (tyAcc == 'C' && tyOpp != '') {
			res = [Select Count(Id) from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and Owner.Name=:bkMn and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c =' ')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and StageName=:tyOpp and CreatedDate >=:sdt and CreatedDate <=:(edt+1) ];
		} else if (tyAcc == 'P' && tyOpp != '') {
			res = [Select Count(Id) from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and Owner.Name=:bkMn and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and StageName=:tyOpp and CreatedDate >=:sdt and CreatedDate <=:(edt+1) ];
		} else if (tyAcc == 'C' && tyOpp == '') {
			res = [Select Count(Id) from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and Owner.Name=:bkMn and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) ];
		} else if (tyAcc == 'P' && tyOpp == '') {
			res = [Select Count(Id) from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and Owner.Name=:bkMn and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) ];
		}
    	return res;
    }

    /** Wrapper class for chart.js with labels, data and color*/
    public class WRP_ChartStacked {
		/**lista lsLabels */
        @AuraEnabled public list<String> lsLabels {get; set;}
		/**lista lsTyOpp */
        @AuraEnabled public list<String> lsTyOpp {get; set;}
		/**lista lsColor */
        @AuraEnabled public list<String> lsColor {get; set;}
		/** Mapa lsData*/
        @AuraEnabled public Map<String, Integer> lsData {get; set;}
		/** Mapa lsTool*/
        @AuraEnabled public Map<String, String> lsTool {get; set;}
		/** Metodo */
        public WRP_ChartStacked(list<String> label,list<String> tyOpp,list<String> color,Map<String, Integer> data,Map<String, String> amm) {
            lsLabels=label;
            lsTyOpp=tyOpp;
            lsColor=color;
            lsData=data;
            lsTool=amm;
        }

    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          19-07-2019
* @Description  Manage opportunity queries for the fetchOpp method in BPyP_OppRep class.
* @Comments     Created from the clipped code block of method fetchOpp.
* @param        String bkMn,String tyAcc,String tyOpp,Datetime sdt,Datetime edt,Integer off
* @return       List<Opportunity>
* @example      fetchOpps(bkMn, tyAcc, tyOpp, sdt, edt, off)
**/    public static List<Opportunity> fetchOpps(String bkMn,String tyAcc,String tyOpp,Datetime sdt,Datetime edt,Integer off) {
    	List<Opportunity> res = null;
		if (tyAcc == 'C' && tyOpp != '') {
            System.debug('typo C y lleno');
			res = [Select Id, StageName, Name, Account.Name, MX_RTL_Producto__c, (Select MX_RTL_SubProducto__c From OpportunityLineItems), Amount, CloseDate, CreatedDate, Owner.Name from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and Owner.Name=:bkMn and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and StageName=:tyOpp and CreatedDate >=:sdt and CreatedDate <=:(edt+1) limit 10 offset :off];
		} else if (tyAcc == 'P' && tyOpp != '') {
            System.debug('typo P y lleno');
			res = [Select Id, StageName, Name, Account.Name, MX_RTL_Producto__c, (Select MX_RTL_SubProducto__c From OpportunityLineItems), Amount, CloseDate, CreatedDate, Owner.Name from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and Owner.Name=:bkMn and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and StageName=:tyOpp and CreatedDate >=:sdt and CreatedDate <=:(edt+1) limit 10 offset :off];
		} else if (tyAcc == 'C' && tyOpp == '') {
            System.debug('typo C y vacio');
			res = [Select Id, StageName, Name, Account.Name, MX_RTL_Producto__c, (Select MX_RTL_SubProducto__c From OpportunityLineItems), Amount, CloseDate, CreatedDate, Owner.Name from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and Owner.Name=:bkMn and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_Cliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) limit 10 offset :off];
		} else if (tyAcc == 'P' && tyOpp == '') {
            System.debug('typo P y vacio');
			res = [Select Id, StageName, Name, Account.Name, MX_RTL_Producto__c, (Select MX_RTL_SubProducto__c From OpportunityLineItems), Amount, CloseDate, CreatedDate, Owner.Name from Opportunity where Owner.VP_ls_Banca__c = 'Red BPyP' and Owner.Name=:bkMn and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.IsActive=True and (Account.RecordType.DeveloperName='BPyP_tre_noCliente' OR Account.RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and CreatedDate >=:sdt and CreatedDate <=:(edt+1) limit 10 offset :off];
		}
    	return res;
    }

}