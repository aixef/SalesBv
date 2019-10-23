/**
 * @File Name          : MX_SB_VTS_LeadMultiCTI_Util.cls
 * @Description        : 
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              : 
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 17/9/2019 19:07:07
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    30/8/2019 17:12:05   Eduardo Hernández Cuamatzi     Initial Version
**/
public virtual class MX_SB_VTS_LeadMultiCTI_Util { //NOSONAR

    final static Integer MAKERANDOM = 1;
       /**
     * getRandomProvider Asigna Aleatoriamente un proveedor al producto para cada lead a enviar
     * @param  valsFamPro   lista de Familia proveedores disponibles
     * @param  valsFam      lista de famlia de productos
     * @param  leadProducts lista de productos a enviar
     * @param  leadItemId   Id de lead a enviar
     * @return              Familia proveedor al que se envia lead
     */
    public static MX_SB_VTS_FamliaProveedores__c getRandomProvider(Map<Id, List<MX_SB_VTS_FamliaProveedores__c>> valsFamPro, Map<String, Product2> valsFam, Map<Id, String> leadProducts, Id leadItemId) {
        MX_SB_VTS_FamliaProveedores__c finalProvider = new MX_SB_VTS_FamliaProveedores__c();
        final Product2 famIdProduct = valsFam.get(leadProducts.get(leadItemId));
        final List<MX_SB_VTS_FamliaProveedores__c> lstProvProduct = valsFamPro.get(famIdProduct.MX_WB_FamiliaProductos__c);
        if(lstProvProduct.size() > MAKERANDOM) {
            finalProvider = lstProvProduct[Integer.valueof(math.random() * lstProvProduct.size())];
        } else {
            finalProvider = lstProvProduct[0];
        }
        return finalProvider;
    }

        /**
     * fillFullName Completa nombre completo cliente
     * @param  leadEntry Registro a enviar
     * @return           Nombre completo del cliente
     */
    public static String fillFullName(Lead leadEntry) {
        String fullName = '';
        fullName = leadEntry.FirstName;
        fullName += String.isNotBlank(leadEntry.LastName) ? ' '+leadEntry.LastName: '';
        fullName += String.isNotBlank(leadEntry.Apellido_Materno__c) ? ' '+leadEntry.Apellido_Materno__c : '';
        return fullName;
    }

    /**
     * checkDate evalua formato de fecha
     * @param  leadRecord registro de Lead ah evaluar
     * @return            fecha valida para envio a SmartCenter
     */
    public static String checkDate(Lead leadRecord) {
        String finalDate = '';
        if(String.isBlank(leadRecord.MX_SB_VTS_HoraCallMe__c)) {
            final Datetime myDT = Datetime.now();
            finalDate = myDT.format('dd/MM/yyyy hh:mm:ss');
        } else {
            final String[] arrDate = leadRecord.MX_SB_VTS_FechaCallme__c.split('/');
            finalDate = arrDate[2]+'/'+arrDate[1]+'/'+arrDate[0]+ ' ' +leadRecord.MX_SB_VTS_HoraCallMe__c;
        }
        return finalDate;
    }

    /**
     * findBandeja recupera bandeja HotLead para proveedor
     * @param  wrapperEnvio Lead a enviar
     * @param  lstBandejas  bandejas HotLeads por proveedor
     * @return              bandeja hotLeads
     */
    public static string findBandeja( WrapperEnvioCTI wrapperEnvio, List<MX_SB_VTS_Lead_tray__c> lstBandejas) {
        String idBandeja = '';
        for(MX_SB_VTS_Lead_tray__c bandeja : lstBandejas) {
            if(bandeja.MX_SB_VTS_Producto__r.Name.equalsIgnoreCase(wrapperEnvio.product) && 
            bandeja.MX_SB_VTS_ProveedorCTI__c.equals(wrapperEnvio.proveedor.MX_SB_VTS_ProveedorCTI__c)) {
                idBandeja = bandeja.MX_SB_VTS_ID_Bandeja__c;
            }
        }
        return idBandeja;
    }

    /**
     * sendtoVCIP enviar leads a VCIP
     * @param  envioCTI lista de leads ah enviar
     */
    public static void sendtoVCIP(List<WrapperEnvioCTI> envioCTI) {
        for(WrapperEnvioCTI itemWrapper : envioCTI) {
            MX_WB_CTI_cls.ftProcesaSol(itemWrapper.leadId.Id, itemWrapper.leadId.Folio_Cotizacion__c, 'ASD', itemWrapper.leadId.OwnerId, itemWrapper.sNombre, itemWrapper.leadId.MobilePhone, 'Lead', 0, '', '');//NOSONAR
        }
    }

    /**
     * Clase wrapper para control de registros a enviar
     */
    public class WrapperEnvioCTI {
        /** Variable  Id registro*/
        public Lead leadId {get;set;}
        /** Variable  Producto enviado*/
        public String product {get;set;}
        /** Variable  nombre concatenado*/
        public String sNombre {get;set;}
        /** Variable  número telefono*/
        public String sTelefono {get;set;}
        /** Variable  tipo de envio para credenciales*/
        public String typeSend {get;set;}
        /** Variable  tipo de credencial a enviar*/
        public Integer itipoVal {get;set;}
        /** Variable  proveedor al que se envia*/
        public MX_SB_VTS_FamliaProveedores__c proveedor {get;set;}
    }
}