/**
 * @File Name          : MX_SB_VTS_WB_CTI_ext.cls
 * @Description        : 
 * @Author             : Eduardo Hernández
 * @Group              : 
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 13/8/2019 17:42:46
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    9/8/2019 10:30:53   Eduardo Hernández     Initial Version
 * 1.1    13/8/2019 10:30:53   Eduardo Hernández    Elimina bloques duplicados
**/
global virtual without sharing class MX_SB_VTS_WB_CTI_ext { //NOSONAR

    /*Función: Entrega la cadena de respuesta OK
    *28-01-2019
    *Karen Belem Sanchez Ruiz*/
    public static String sRespuestaOK(String sXml, list<string> lstNodos, list<string> lstNodosF) {
        Integer iInicio = 0;
        Integer iFin = 0;
        String sRespuesta = '';

        final string rXml = sXml.replace('<return xsi:type="xsd:string">',System.Label.MX_SB_VTS_ReturnElement);

        Integer iNodo = 0;
        for (String e : lstNodos) {
            iInicio = rXml.IndexOf(e,0);
            iFin = rXml.IndexOf(lstNodosF[iNodo],0);
            iFin = iFin + lstNodosF[iNodo].length();

            if (rXml.length() >0 && iInicio > 0 && iFin > 0) {
                final String sXmlx = rXml.substring(iInicio, iFin);
                if (sXmlx.length() > 0 && e == System.Label.MX_SB_VTS_ReturnElement) {
                    sRespuesta = parse(sXmlx);
                }
            }
            iNodo++;//NOSONAR
        }
        return sRespuesta;
    }

    /*Función: Entrega la cadena de respuesta OK
    *28-01-2019
    *Karen Belem Sanchez Ruiz*/
    public static String sRespuestaERROR(String sXml, list<string> lstNodos, list<string> lstNodosF) {
        Integer iInicio = 0;
        Integer iFin = 0;
        final string rXml = sXml.replace('<return xsi:type="xsd:string">',System.Label.MX_SB_VTS_ReturnElement);
        Integer iNodo = 0;
        String sRespuesta = '';

        for (String itemNode : lstNodos) {
            iInicio = rXml.IndexOf(itemNode,0);
            iFin = rXml.IndexOf(lstNodosF[iNodo],0);
            iFin = iFin + lstNodosF[iNodo].length();
            if (rXml.length() >0 && iInicio > 0 && iFin > 0) {
                final String sXmlx = rXml.substring(iInicio, iFin);
                if (sXmlx.length() > 0 && itemNode.equalsIgnoreCase(System.Label.MX_SB_VTS_ReturnElement)) {
                    sRespuesta = parse(sXmlx);
                }
            }
            iNodo++;//NOSONAR
        }
        return sRespuesta;
    }

    /*Función: Analiza los argumentos en xml y los carga en un documento
    *28-01-2019
    *Karen Belem Sanchez Ruiz*/
    public static String parse(String toParse) {
        String returnParse = '';
        final DOM.Document doc = new DOM.Document();
        try {
            doc.load(toParse);
            final DOM.XMLNode root = doc.getRootElement();
            returnParse = walkThrough(root);
        } catch (System.XMLException e) {
            returnParse = e.getMessage();
        }
        return returnParse;
    }
    /** method */
    public static String walkThrough(DOM.XMLNode node) {
        String finalReturn = '';
        if (node.getNodeType() == DOM.XMLNodeType.COMMENT) {
            finalReturn = 'Comment (' +  node.getText() + ')';
        }
        if (node.getNodeType() == DOM.XMLNodeType.TEXT) {
            finalReturn = 'Text: ' + node.getText() + ' ';
        }
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {   
            finalReturn = resolvedResponse(node);
        }
        return finalReturn;
    }

    /**
     * updateLeadRecord Acualizar leads     
     */
    public static void updateLeadRecord(String idLead, String response, String requestText) {
        final Lead leadUpdate = [Select Id, xmlRespuesta__c, xmlEnvio__c, EnviarCTI__c, LeadSource from Lead where Id =: idLead];
        if(leadUpdate.LeadSource == System.Label.MX_SB_VTS_OrigenCallMeBack) {
            leadUpdate.Id = idLead;
            leadUpdate.xmlRespuesta__c = response;
            leadUpdate.xmlEnvio__c = requestText;
            leadUpdate.EnviarCTI__c = true;
            update leadUpdate;
        }
    }
    
    /**
     * resolvedResponse Recorrer respuesta de Json
     */
    public static string resolvedResponse (DOM.XMLNode node) {
        String result = '\n';
        if (node.getText() != '') {
            result += node.getText();
        }

        if (node.getAttributeCount() > 0) {
            for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
                result += ', attribute #' + i + ':' + node.getAttributeKeyAt(i) + '=' + node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
                result += ', text=' + node.getText();
            }
        }
        for (Dom.XMLNode child: node.getChildElements()) {
            result += walkThrough(child);
        }
        return result;
    }

    /**
     * MX_SB_VTS_WB_CTI_ext crear httpRequest
     * @return   return httpRequest
     */
    public static HttpRequest createRequestXML(String endpoint, String doc) {
        final HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setHeader('SOAPAction' , 'WsCTIAction');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('Host', 'vcip.com.mx');
        request.setHeader('Connection', 'Keep-Alive');
        request.setHeader('User-Agent', 'Apache-HttpClient/4.1.1 (java 1.5)');
        request.setTimeout(120000);
        request.setBody(doc);
        return request;
    }

    /*
    *Función: sirve para extraer las credenciales para hacer el envío a CTI
    *28-01-2019
    *Karen Belem Sanchez Ruiz */
    public static MX_WB_CredencialesCTI__c credencialCTI(String nombreLista,Integer iTipo) {
        return MX_WB_CredencialesCTI__c.getValues(nombreLista + iTipo);
    }

    /*Función: Repsuesta del servicio y actualización del lead u oportunidad
    *28-01-2019
    *Karen Belem Sanchez Ruiz*/
    public static List<String> reqSolicitud(String doc, String idObjeto, String sObjeto) {
        final String endpoint = Label.wsEndPointWibe00;
        String sXml = '';
        String sRespuesta = '';
        final List<String> lstRequest = new List<String>();

        final HttpRequest request = createRequestXML(endpoint, doc);
        HttpResponse response = new HttpResponse();
        final Http http = new Http();

        response = http.send(request);
        sXml = response.getBody();
        final list<string> lstNodos = new list<string>{'<return>'};
        final list<string> lstNodosF = new list<string>{'</return>'};
        sRespuesta = sXml;
        if (sXml.contains('OK') ) {
            sRespuesta = sRespuestaOK(sXml,lstNodos,lstNodosF);
        } else {
            sRespuesta = sRespuestaERROR(sXml,lstNodos,lstNodosF);
        }
        URL.getSalesforceBaseUrl().toExternalForm();

        URL.getCurrentRequestUrl().toExternalForm();

        lstRequest.add(sRespuesta);
        lstRequest.add(doc);
        return lstRequest;
    }
}