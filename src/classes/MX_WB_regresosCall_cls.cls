/****************************************************************************************************
author: Javier Ortiz Flores
company: Indra
Description:    Genera XML y trata respuesta de servicio CTI para la extracción de registros.

Information about changes (versions)
-------------------------------------
Number    Dates           Author                       Description
------    --------        --------------------------   -----------
1.0       01-Ene-2019     Javier Ortiz Flores          Creación de la Clase
****************************************************************************************************/
public without sharing class MX_WB_regresosCall_cls {
    /**
    */
    public static returnCall llamada = new returnCall();
    /**
    */
    public static returnRecording record = new returnRecording();

    @future(callout=true)
    /**
    */
    public static void procesaCall(String idLead, String listName, String oppId) {
        final String sXML = GenerarXML(idLead, listName);
        if(String.isNotBlank(sXML)) {
            final String sRespuesta = reqSolicitud(sXML, oppId);
            if(string.isNotBlank(sRespuesta)) {
                getListCall(sRespuesta, true, oppId);
                getListCall(sRespuesta, false, oppId);
            }
        }
    }
    /**
    */
    public static String ftprocesaCall(String idLead, String listName, String oppId) {
        String sXML, sRespuesta;
        sXML = GenerarXML(idLead, listName);
        if(String.isNotBlank(sXML)) {
            sRespuesta = reqSolicitud(sXML, oppId);
        }
        return sRespuesta;
    }
    /**
    */
    public static String GenerarXML(String sIdProspecto, String listName) {
        final String soapXSI = 'http://www.w3.org/2001/XMLSchema-instance';
        final String soapXSD = 'http://www.w3.org/2001/XMLSchema';
        final String soapENV = 'http://schemas.xmlsoap.org/soap/envelope/';
        final String soapWS = Label.soapWS;

        final dom.Document doc = new dom.Document();
        final dom.Xmlnode envelope = doc.createRootElement('Envelope', soapENV, 'soapenv');
        final dom.XmlNode header = envelope.addChildElement('Header', soapENV, 'soapenv');
        final dom.XmlNode body = envelope.addChildElement('Body', soapENV, 'soapenv');

        System.debug(header);

        envelope.setNamespace('xsi', soapXSI);
        envelope.setNamespace('xsd', soapXSD);
        envelope.setNamespace('soapenv', soapENV);
        envelope.setNamespace('ws', soapWS);

        final dom.XmlNode setCall = body.addChildElement('getCall', soapWS, null);
        setCall.setAttribute('soapenv:encodingStyle','http://schemas.xmlsoap.org/soap/encoding/');

        final MX_WB_CredencialesCTI__c credenciales = CredencialCTI(listName);
        final dom.XmlNode nUser = setCall.addChildElement('user',null,null).addTextNode(credenciales.MX_WB_Usuario__c);
        final dom.XmlNode nPass = setCall.addChildElement('pass',null,null).addTextNode(credenciales.MX_WB_Contrasenia__c);
        final dom.XmlNode nLeadId = setCall.addChildElement('leadId',null,null).addTextNode(sIdProspecto);

        System.debug('nUser: ' + nUser + ' nLead: ' + nLeadId);
        return Doc.toXmlString();
    }
    /*@Descripción
*Se agrega para extraer URL de custom settings, estas sirven como referencia según la pestaña,
depende el nombre que recibe la función es el reporte al que se dirige.
*07-08-2018
*Javier Ortiz Flores
*/
    public static MX_WB_CredencialesCTI__c CredencialCTI(String nombreLista) {
        final MX_WB_CredencialesCTI__c ListCTI = MX_WB_CredencialesCTI__c.getValues(nombreLista);
        return ListCTI;
    }
    /**
    *Method
    */
    public static String reqSolicitud(String doc, String oppId) {
        final String endpoint = Label.MX_WB_endpoint;

        final HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        final Http http = new Http();

        request.setEndpoint(endpoint);
        request.setHeader('SOAPAction' , Label.MX_WB_ipHeader);
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('Host', 'vcip.com.mx');
        request.setHeader('Connection', 'Keep-Alive');
        request.setHeader('User-Agent', 'Apache-HttpClient/4.1.1 (java 1.5)');
        request.setTimeout(120000);
        request.setBody(doc);

        response = http.send(request);
        String sXml = response.getBody();
        final List<string> lstNodos = new list<string>{'<return>'};
        final List<string> lstNodosF = new list<string>{'</return>'};
        Integer iInicio = 0;
        Integer iFin = 0;
        final String sRespuesta = sXml;

        if (sXml.contains('OK')) {
            final string rXml = sXml.replace('<return xsi:type="xsd:string">','<return>');
            sXml = rXml;
            Integer iNodo = 0;
            for (String e : lstNodos) {
                iInicio = sXml.IndexOf(e,0);
                System.debug(iInicio);
                iFin = sXml.IndexOf(lstNodosF[iNodo],0);
                iFin = iFin + lstNodosF[iNodo].length();
                iNodo++;
            }
        }
        return sRespuesta;
    }
    /** 
    */
    public static void getListCall(string sRespuesta, boolean CallRecord, String oppId) {
        final List<returnCall> llamadasList = new List<returnCall>();
        final List<returnRecording> recordsList = new List<returnRecording>();
        String sRespuestaCall = '';
        sRespuestaCall = normalizaXML(sRespuesta, CallRecord);
        final Dom.Document xmlJ = new Dom.Document();
        xmlJ.load(sRespuestaCall);
        String campo, valor;
        for(Dom.XmlNode node :xmlJ.getRootElement().getChildElements()) {
            if(node.getName() == 'item') {
                llamada = new returnCall();
                record = new returnRecording();
                for(Dom.XmlNode node2 : node.getChildElements()) {
                    if(node2.getName() == 'item') {
                        for(Dom.XmlNode node3 : node2.getChildElements()) {
                            if(node3.getName() == 'key') {
                                campo='';
                                campo = node3.getText();
                            } else if(node3.getName() == 'value') {
                                valor='';
                                valor = node3.getText();
                                if(CallRecord) {
                                    llamada = llenadoLlamada(campo, valor, llamada);
                                } else {
                                    record = llenadoRecord(campo, valor, record);
                                }
                            }
                        }
                    }
                }
                if(llamada != null && CallRecord) {
                    llamadasList.add(llamada);
                } else {
                    recordsList.add(record);
                }
            }
        }
        if(!llamadasList.isEmpty()) {
			system.debug('Entro a llamadas :::'+llamadasList);
            MX_WB_leadOutboundCTI.actualizaCTILead(llamadasList, oppId);
        }
        if(!recordsList.isEmpty() && String.isNotBlank(oppId)) {
			system.debug('Entro a records :::'+recordsList);
            MX_WB_leadOutboundCTI.oppTaskCreate(recordsList, oppId);
        }
    }
    /** 
    *Method and constructor
    */
    public static String normalizaXML(String sRespuesta, boolean callRecord) {
        String sRespuestaCall;
        if(callRecord) {
            sRespuestaCall = sRespuesta.substringBefore('<item><key xsi:type="xsd:string">recordings</key>');
            sRespuestaCall = sRespuestaCall.substringAfterLast('<key xsi:type="xsd:string">calls</key>');
        } else {
            sRespuestaCall = sRespuesta.substringBeforeLast('</return>');
            sRespuestaCall = sRespuestaCall.substringAfterLast('<key xsi:type="xsd:string">recordings</key>');
        }
        sRespuestaCall = sRespuestaCall.replace(' xsi:type="xsd:string"', '');
        sRespuestaCall = sRespuestaCall.replace('<value SOAP-ENC:arrayType="ns2:Map[1]" xsi:type="SOAP-ENC:Array">', '');
        sRespuestaCall = sRespuestaCall.replace('<value SOAP-ENC:arrayType="ns2:Map[2]" xsi:type="SOAP-ENC:Array">', '');
        sRespuestaCall = sRespuestaCall.replace('<value SOAP-ENC:arrayType="ns2:Map[3]" xsi:type="SOAP-ENC:Array">', '');
        sRespuestaCall = sRespuestaCall.replace('<value SOAP-ENC:arrayType="ns2:Map[4]" xsi:type="SOAP-ENC:Array">', '');
        sRespuestaCall = sRespuestaCall.replace('<value SOAP-ENC:arrayType="ns2:Map[5]" xsi:type="SOAP-ENC:Array">', '');
        sRespuestaCall = sRespuestaCall.replace('<value SOAP-ENC:arrayType="ns2:Map[6]" xsi:type="SOAP-ENC:Array">', '');
        sRespuestaCall = sRespuestaCall.replace('<value SOAP-ENC:arrayType="ns2:Map[7]" xsi:type="SOAP-ENC:Array">', '');
        sRespuestaCall = sRespuestaCall.replace('<value SOAP-ENC:arrayType="ns2:Map[8]" xsi:type="SOAP-ENC:Array">', '');
        sRespuestaCall = sRespuestaCall.replace(' xsi:type="ns2:Map"', '');
        sRespuestaCall = sRespuestaCall.replace(' xsi:nil="true"', '');
        sRespuestaCall = sRespuestaCall.substringBeforeLast('</value></item>');
        sRespuestaCall = '<value>'+sRespuestaCall+'</value>';
		return sRespuestaCall;
    }
    /** 
    */
    public static returnRecording llenadoRecord(String campo, String Valor, returnRecording record) {
        if('Fecha_Gracion'.equals(campo)) {
            record.Fecha_Grabacion = DateTime.valueOf(valor);
        }
        if('Grabacion'.equals(campo)) {
            record.Grabacion = valor;
        }
        if('Duracion'.equals(campo)) {
            record.Duracion = integer.valueOf(valor);
        }
        if('idUser'.equals(campo)) {
            record.idUser = valor;
        }
        if('leadId'.equals(campo)) {
            record.leadId = valor;
        }
        return record;
    }
    /** 
    *Method and constructor
    */
    public static returnCall llenadoLlamada(String campo, String Valor, returnCall llamada) {
        if('Fecha_Llamada'.equals(campo)) {
            llamada.Fecha_Llamada = DateTime.valueOf(valor);
        }
        if('Tel_Marcado'.equals(campo)) {
            llamada.Tel_Marcado = valor;
        }
        if('Disposicion'.equals(campo)) {
            llamada.Disposicion = valor;
        }
        if('Tel_1'.equals(campo)) {
            llamada.Tel_1 = valor;
        }
        if('Tel_2'.equals(campo)) {
            llamada.Tel_2 = valor;
        }
        if('Tel_3'.equals(campo)) {
            llamada.Tel_3 = valor;
        }
        if('idUser'.equals(campo)) {
            llamada.idUser = valor;
        }
        if('leadId'.equals(campo)) {
            llamada.LeadId = valor;
        }
        return llamada;
    }
    /** 
    */
    public class returnCall {
        @AuraEnabled
        /** 
        */
        public String Disposicion {get; set;}
        @AuraEnabled
        /** 
        */
        public DateTime Fecha_Llamada {get; set;}
        @AuraEnabled
        /** 
        */
        public String Tel_1 {get; set;}
        @AuraEnabled
        /** 
        */
        public String Tel_2 {get; set;}
        @AuraEnabled
        /** 
        */
        public String Tel_3 {get; set;}
        @AuraEnabled
        /** 
        */
        public String Tel_Marcado {get; set;}
        @AuraEnabled
        /** 
        */
        public String idUser {get; set;}
        @AuraEnabled
        /** 
        */
        public String leadId {get; set;}
    }
    /** 
        */
    public class returnRecording {
        @AuraEnabled
        /** 
        */
        public DateTime Fecha_Grabacion {get; set;}
        @AuraEnabled
        /** 
        */
        public String Grabacion {get; set;}
        @AuraEnabled
        /** 
        */
        public Integer Duracion {get; set;}
        @AuraEnabled
        /** 
        */
        public String idUser {get; set;}
        @AuraEnabled
        /** 
        */
        public String leadId {get; set;}
    }
}
