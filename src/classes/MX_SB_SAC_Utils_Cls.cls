/**
----------------------------------------------------------
* Nombre: MX_SB_SAC_Utils_Cls
* Autor Saúl González
* Proyecto: SB SAC - BBVA Bancomer
* Descripción : Clase con metódos reutilizables para la consulta de polizas
* --------------------------------------------------------------------------------
* Versión       Fecha           Autor                   			Descripción
* --------------------------------------------------------------------------------
* 1.0           04/04/2019     Saúl González	           		   	Creación
* 2.0           21/07/2019     Ing. Karen Belem Sanchez Ruiz			Corrección de issues
* --------------------------------------------------------------------------------
*/

public with sharing class MX_SB_SAC_Utils_Cls {	//NOSONAR
    /**
    *
    * @description valor que se recibe de la operación del WS
    * @author Karen Sanchez
    */
    public static final String UNO = '1';

	/*
    * @description permite convertir de String a Tipo Date
    * @param String sFecha
	* @return Date dFecha
    */
	public static Date fechaYYYYMMDDHHMMSS(String sFecha) {
        final Date dFecha;
        if(String.isNotBlank(sFecha)) {
			dFecha = Date.valueOf(sFecha);
    	}
        return dFecha;
    }

	/*
    * @description permite convertir de String a Tipo Date fecha de DDMMYYYY a YYYYMMDD
    * @param String sFecha
	* @return Date dFecha
    */
    public static Date fechaDDMMYYYYTOYYYYMMDD(String sFecha) {
        final Date dFecha;
        if(String.isNotBlank(sFecha)) {
        	final String sDia = sFecha.substring(0, 2);
	        final String sMes = sFecha.substring(3, 5);
	        final String sAnio = sFecha.substring(6, 10);
	        dFecha = Date.newInstance(Integer.valueOf(sAnio), Integer.valueOf(sMes), Integer.valueOf(sDia));
        }
        return dFecha;
    }

    /*
    * @description permite convertir de String a Tipo Date fecha de MMDDYYYY a YYYYMMDD
    * @param String sFecha
	* @return Date dFecha
    */
    public static Date fechaMMDDYYYYTOYYYYMMDD(String sFecha) {
        final Date dFecha;
        if(String.isNotBlank(sFecha)) {
        	final String sDia = sFecha.substring(3, 5);
	        final String sMes = sFecha.substring(0, 2);
	        final String sAnio = sFecha.substring(6, 10);
	        dFecha = Date.newInstance(Integer.valueOf(sAnio), Integer.valueOf(sMes), Integer.valueOf(sDia));
        }
        return dFecha;
    }

	/*
    * @description valida que no este vacío el elemnto.
    * @param String obj
	* @return String strResponse
    */
    public static String validaDatoVacio(String obj) {
        return String.isNotBlank(obj) ? obj: '';
    }


    /*
    * @description permite obtener un map con el correo a partir de una lista de cuentas
    * @param List<Account> arrAccount
	* @return Map<String, Account> mapResponse
    */
    public static Map<String, Account> getMapAccount(List<Account> arrAccount) {
        Map<String, Account> mapResponse = new Map<String, Account>();
        if(arrAccount.isEmpty()) {
            final Map<String, Account>  strMANll = new Map<String, Account>();
            mapResponse=strMANll;
        }else {
            for(Account acct : arrAccount) {
                mapResponse.put(acct.PersonEmail, acct);
            }
        }
        return mapResponse;
    }

    /*
    * @description permite obtener un map con el numero de poliza a partir de una lista de Contratos
    * @param String sJsonResp
	* @return ErrorFormDto objErrorPolizaResp
    */
    public static Map<String, Contract> getMapContract(List<Contract> arrContract) {
        Map<String, Contract> mapResponse = new Map<String, Contract>();

        if(arrContract.isEmpty()) {
            final Map<String, Contract>  respNll = new Map<String, Contract>();
            mapResponse=respNll;
        }else {
            for(Contract cont : arrContract) {
                mapResponse.put(cont.MX_WB_noPoliza__c, cont);
            }
        }
        return mapResponse;
    }

    /**
     * updateCustoSetting Se actualiza la Custom setting que contiene el Token válido
     * @param  tokenSession token Válido
     */
    public static void updateCustoSetting(String tokenSession) {
        DateTime dtHoraIni, dtHoraFin;
        final MX_SB_SAC_LoginToken__c customSttngURL =  MX_SB_SAC_LoginToken__c.getInstance('Login Siniestros');
        dtHoraIni = DateTime.now();
        dtHoraFin = dtHoraIni.addMinutes(Integer.valueof(customSttngURL.Duracion__c));
        customSttngURL.Token__c = tokenSession;
        customSttngURL.FechaIni__c = DateTime.now();
        customSttngURL.FechaFin__c = dtHoraFin;
        update customSttngURL;
    }

    /**
     * matchSinisters evalúa la respuesta del WS y genera una lista de Siniestro__c
     * @param  objRespGetSiniestro El objeto de la respuesta del wS
     * @param  policyNum           Numero de póliza de la oportunidad
     * @return                     return Lista de Siniestros
     */
    public static List<Siniestro__c> matchSinisters(MX_SB_SAC_SiniestrosDtoCls.respRestGetSiniestro objRespGetSiniestro, String policyNum) {
        final List<Siniestro__c> lSiniestros = null;
        if (objRespGetSiniestro.JsonRes.contains(label.MX_SB_SAC_ErrorDTO)) {
            throw new QueryCustomException(objRespGetSiniestro.Detalle, objRespGetSiniestro.NombreMetodo, System.Label.MX_SB_SAC_ErrorWS,97); //NOSONAR
        } else {
            final List<MX_SB_SAC_SiniestrosDtoCls.SiniestrosDto> lSiniestroDto = MX_SB_SAC_SiniestrosDtoCls.jsonParserGetSiniestro(objRespGetSiniestro.JsonRes);

                final MX_SB_SAC_SiniestrosDtoCls.respSiniestroDto objRespSinDto = MX_SB_SAC_SiniestrosDtoCls.getSiniestrosSFDC(lSiniestroDto, policyNum);

                    lSiniestros = new List<Siniestro__c>();
                    lSiniestros.addAll(objRespSinDto.lSiniestros);

        }
        return lSiniestros;
    }
}