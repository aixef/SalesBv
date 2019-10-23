/* Avanxo Colombia
* @author           Francisco Javier
* Project:          WIBE
* Description:      Clase que implementa funciones para realizar la conexion desde SFDC hacia CTI.
*
* Changes (Version)
* -------------------------------------
*     No.   Date      Author          Description
*     ----- ----------    --------------------  ---------------
* @version  1.0   2019-03-07    Francisco García García (FG)    Creación
********************************************************************************************************************************************/
public without sharing class MX_WB_CTI_cls extends MX_SB_VTS_WB_CTI_ext { //NOSONAR
    /** variables */
    static final String sObjetoOpp, sObjetoLead;

    static {
        sObjetoOpp ='Opportunity';
        sObjetoLead = 'Lead';
    }


    /*Función: función a futuro que sirve para extraer los resultados del request del servicio
    *28-01-2019
    *Karen Belem Sanchez Ruiz*/
    @future(callout=true)
    public static void ftProcesaSol(String sIdOpp, String sFolioCotizacion, String sIdProducto, String sIdOwnerId, String sNameCte, String sTelefono, String sObjeto, Integer iTipo, String sTelefono2, String sTelefono3) {
        String sXML, tel1, tel2, tel3;
        final String sNombre = String.isNotBlank(sNameCte) ? sNameCte : '' ;
        final String sFolio = String.isNotBlank(sFolioCotizacion) ? sFolioCotizacion : '' ;
        List<String> lstTelefonos = new List<String>();

        lstTelefonos = validacionTelefono(sObjeto,sTelefono,sTelefono2,sTelefono3);
        tel1 = lstTelefonos[0];
        tel2 = lstTelefonos[1];
        tel3 = lstTelefonos[2];

        sXML = generarXML(tel1, sNombre, String.isBlank(sIdProducto) ? '' : sIdProducto, sIdOpp, sIdOwnerId, sFolio, iTipo, tel2,tel3);
        if(String.isNotBlank(sXML)) {
            reqSolicitud(sXML, sIdOpp, sObjeto);
           final List<String> sRequest = reqSolicitud(sXML, sIdOpp, sObjeto);
            if(sObjeto.equalsIgnoreCase('Lead') && iTipo == 0) {
                updateLeadRecord(sIdOpp,sRequest[0],sRequest[1]);
            }
        }
    }
    /**
    *
    */
    public static List<String> procesaSol(String sIdOpp, String sFolioCotizacion, String sIdProducto, String sIdOwnerId, String sNameCte, String sTelefono, String sObjeto, Integer iTipo , String sTelefono2, String sTelefono3) {
        String sXML, tel1, tel2, tel3;
        final String sNombre = String.isNotBlank(sNameCte) ? sNameCte : '' ;
        final String sFolio = String.isNotBlank(sFolioCotizacion) ? sFolioCotizacion : '';
        List<String> lstTelefonos = new List<String>();
        List<String> sRequest = new List<String>();

        lstTelefonos = validacionTelefono(sObjeto,String.isNotBlank(sTelefono) ? sTelefono : '',String.isNotBlank(sTelefono2) ? sTelefono2 : '',String.isNotBlank(sTelefono3) ? sTelefono3 : '');
        tel1 = lstTelefonos[0];
        tel2 = lstTelefonos[1];
        tel3 = lstTelefonos[2];

        sXML = generarXML(tel1, sNombre, sIdProducto, sIdOpp, sIdOwnerId, sFolio, iTipo, tel2,tel3);
        if(String.isNotBlank(sXML)) {
            sRequest = reqSolicitud(sXML, sIdOpp, sObjeto);
            if(sObjeto.equalsIgnoreCase('Lead') && iTipo == 0) {
                updateLeadRecord(sIdOpp,sRequest[0],sRequest[1]);
            }
        }
        return sRequest;
    }

    /*28-01-2019 Función: Valida el teléfono para asignar lada
    *Karen Belem Sanchez Ruiz*/
    public static List<String> validacionTelefono(String sObjeto, String sTelefono, String sTelefono2, String sTelefono3) {
        final List<String> telefonos = new List<String>();

        telefonos.add( (String.isNotBlank(sTelefono) && sTelefono.startsWith('55'))  ? '044' + sTelefono   : '045' + sTelefono );
        telefonos.add( (String.isNotBlank(sTelefono2) && sTelefono2.startsWith('55')) ? '044' + sTelefono2  : '045' + sTelefono2 );
        telefonos.add( (String.isNotBlank(sTelefono3) && sTelefono3.startsWith('55')) ? '044' + sTelefono3  : '045' + sTelefono3 );

        return telefonos;
    }

    /*28-01-2019 Función: Se genera el XML
    *Karen Belem Sanchez Ruiz*/
    public static String generarXML(String sTelefono,String sNombre,String sProducto, String sIdProspecto, String sAgente, String sFolio, 
    Integer iTipo, String sTelefono2, String sTelefono3) {
        MX_WB_CredencialesCTI__c credenciales = new MX_WB_CredencialesCTI__c();
        final dom.Document doc = new dom.Document();

        final String soapXSI = 'http://www.w3.org/2001/XMLSchema-instance';
        final String soapXSD = 'http://www.w3.org/2001/XMLSchema';
        final String soapENV = 'http://schemas.xmlsoap.org/soap/envelope/';
        final String soapWS = Label.soapWS;

        final dom.Xmlnode envelope = doc.createRootElement('Envelope', soapENV, 'soapenv');
        envelope.addChildElement('Header', soapENV, 'soapenv');
        final dom.XmlNode body = envelope.addChildElement('Body', soapENV, 'soapenv');

        envelope.setNamespace('xsi', soapXSI);
        envelope.setNamespace('xsd', soapXSD);
        envelope.setNamespace('soapenv', soapENV);
        envelope.setNamespace('ws', soapWS);

        final dom.XmlNode setCall = body.addChildElement('setCall', soapWS, null);
        setCall.setAttribute('soapenv:encodingStyle','http://schemas.xmlsoap.org/soap/encoding/');
        credenciales = credencialCTI(sProducto,iTipo);
        setCall.addChildElement('user',null,null).addTextNode(credenciales.MX_WB_Usuario__c);
        setCall.addChildElement('pass',null,null).addTextNode(credenciales.MX_WB_Contrasenia__c);
        setCall.addChildElement('phone',null,null).addTextNode(sTelefono);
        setCall.addChildElement('name',null,null).addTextNode(sNombre);
        setCall.addChildElement('product',null,null).addTextNode(String.isBlank(sProducto) ? label.wsProductoSeguroDeAuto :sProducto);
        setCall.addChildElement('leadId',null,null).addTextNode(sIdProspecto);
        setCall.addChildElement('agent',null,null).addTextNode(sAgente);
        setCall.addChildElement('callType',null,null).addTextNode('ANYONE');
        setCall.addChildElement('folio',null,null).addTextNode(sFolio);
        setCall.addChildElement('phone',null,null).addTextNode(sTelefono2);
        setCall.addChildElement('phone',null,null).addTextNode(sTelefono3);

        return Doc.toXmlString();
    }
}
