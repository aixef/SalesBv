/**-------------------------------------------------------------------------
* Nombre: MX_SB_VTS_SendLead_helper_cls
* @author Arsenio Perez Lopez (xemo)
* Proyecto: MW SB VTS - BBVA
* Descripción : Clase de ayuda para el componente de envio de leads

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           03/06/2019      Arsenio  Perez            Creación
* @version 1.1           26/09/2019      Arsenio  Perez            Modificacion
* --------------------------------------------------------------------------*/
public without sharing class MX_SB_VTS_SendLead_helper_cls {
    /* */
    private MX_SB_VTS_SendLead_helper_cls() {
    }
     /*
        @MethodName: Consulta_Carga_invoke.
        @decription: Methodo para invocar La carga y descarga de leads para esto se usa el parametro method que establece la accion a realizar
        @Param: Method: Ent_RegistroGestion/Baja_Linea
     */
    public static Map<String,Object> Consulta_Carga_invoke(String serviceId) {
        final HttpResponse httpRest= invoke('ConsultaCarga', serviceId);
        return (Map<String,Object>) JSON.deserializeUntyped(httpRest.getBody());
    }
    /*
        @MethodName: Crear_Carga_invoke.
        @decription: Methodo para invocar la creacion de la carga.
        @Param: Method: Ent_RegistroGestion/Baja_Linea
     */
    public static Map<String,Object> Crear_Carga_invoke(String serviceId, String descripcion) {
        final REquestsendCarga tempRestc = new REquestsendCarga();
        tempRestc.SERVICEID=serviceId;
        tempRestc.DESCRIPCION=descripcion;
        final String invokeCarga= JSON.serialize(tempRestc);
        system.debug(InvokeCarga);
        final HttpResponse httpRest = invoke('CrearCarga', InvokeCarga);
        return (Map<String,Object>) JSON.deserializeUntyped(httpRest.getBody());
    }
    /*
        @MethodName: EntRegistroGestion_invoke.
        @decription: Methodo para invocar La carga y descarga de leads para esto se usa el parametro method que establece la accion a realizar
        @Param: Method: EntRegistroGestion/Baja_Linea
        @Param: SERVICEID '2'
        @Param: leattosend Lista de leads que se va enviar.
        @Param: LOGIN, hasta ahora va vacio.
        @Param: LOADID, la bandeja donde se van a almacenar.
        @Param: SCHEDULEDATE, La fecha cuando se realizara en el formato "Id,“dd/MM/yyyy hh:mm:ss”" Ejemplo: “09/04/2019 12:35:45”

    */
    public static Map<String,Object> EntRegistroGestion_invoke(String method,List<SObject> leattosend, String login,String serviceId,String loadId,Map<id,String> scheduledate) {
        final list<RequestSendLead> env = new List<RequestSendLead>();
        for(SObject temp: leattosend) {
            final String identificador=temp.Id;
            final RequestSendLead temp_rest = new RequestSendLead();
                temp_rest.ID_LEAD=returnEmpty(temp.Id);
                temp_rest.LOGIN=returnEmpty(login);
                temp_rest.SERVICEID=Integer.valueOf(returnEmptyphone(serviceId));
                temp_rest.LOADID=Integer.valueOf(returnEmptyphone(loadId));
                temp_rest.SCHEDULEDATE=returnEmpty(scheduledate.get(temp.Id));
                if(identificador.startsWith('00Q')) {
                    final Lead templead = (Lead)temp;
                    temp_rest.PHONE1=returnEmpty(templead.MX_WB_ph_Telefono1__c);
                    temp_rest.PHONE2=returnEmpty(templead.MX_WB_ph_Telefono2__c);
                    temp_rest.PHONE3=returnEmpty(templead.MX_WB_ph_Telefono3__c);
                } else {
                    final Opportunity optem = (Opportunity) temp;
                    temp_rest.PHONE1=returnEmpty(optem.TelefonoCliente__c);
                    temp_rest.PHONE2=returnEmpty('');
                    temp_rest.PHONE3=returnEmpty('');
                }
                env.add(temp_rest);
        }
        final Map<String,String> mapsent = new map<String,String>();
        mapsent.put('ListLeads',JSON.serialize(env));
        system.debug('mapsent'+mapsent);
        final HttpResponse httpRest = invoke(method, mapsent);
        final Map<String,Object> ret= (Map<String,Object>) JSON.deserializeUntyped(httpRest.getBody());
        system.debug(ret);
        return ret;
    }

    /* method to invoke the webservice */
    public static System.HttpResponse invoke(String method, Map<String,String> mapsent) {
        return iaso.GBL_Integration_GenericService.invoke(method, mapsent);
    }
        /* method to invoke the webservice */
    public static System.HttpResponse invoke(String method, String strsent) {
        return iaso.GBL_Integration_GenericService.invoke(method, strsent);
    }

    /*Return empyet */
    public static String returnEmptyphone(String remp) {
        return String.isBlank(remp)||String.isEmpty(remp)?'0':remp;
    }
    /*Return empty */
    public static String returnEmpty(String remp) {
        return String.isBlank(remp)||String.isEmpty(remp)?'':remp;
    }
    /*
    *
    */
    public class RequestSendLead {
        /*ID Lead que se envia */
        public String ID_LEAD { get; set; }
        /*Login Id que se ocupa para el aplicativo */
        public String LOGIN { get; set; }
        /*Servicio que se ocupa */
        public Integer SERVICEID {get;set;}
        /*ID de logeo */
        public Integer LOADID {get;set;}
        /*Fecha estimada de llamada */
        public String SCHEDULEDATE { get; set; }
        /*Telefono 1 para el llamado */
        public String PHONE1 { get; set; }
        /*Telefono 2 para el llamado */
        public String PHONE2 { get; set; }
        /*Telefono 3 para el llamado */
        public String PHONE3 { get; set; }
    }
    /*
    *
    */
    public class REquestsendCarga {
        /* Identificador del servicio */
        public String SERVICEID { get; set; }
        /* Descripcion del servicio */
        public String DESCRIPCION { get; set; }
    }
}
