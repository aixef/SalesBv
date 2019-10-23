/**
* BBVA Next Technologies
* @author           Karen Belem Sanchez Ruiz
* Project:          SB_SAC
* Description:      Clase de utilidad que brinda distintas creaciones de objetos para clases test.
*
* Changes (Version)
* ------------------------------------------------------------------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    --------------------------------------
* @version  1.8     2019-06-13      Ing. Karen Belem Sanchez  Se crea clase
* @version  1.9     2019-06-20      Saúl González Reséndiz    Se agrega métodos para creación de Credenciales
*/
@isTest
public class MX_SB_SAC_UtileriasTestCls {//NOSONAR
    
    /**
    * @Method crearCuenta
    * @param String strName
    * @param String sNameRT
    * @Description Retorna un objeto cliente
    * @return Objeto Account
    **/
    public static Account crearCuenta(String strName, String sNameRT) {
        final Double NoClienteDouble	= Math.random()*10000000;
        final Long NoCliente 			= NoClienteDouble.round();
        final Account cliente           = new Account();
        if(String.isNotBlank(sNameRT) && (sNameRT == 'PersonAccount' || sNameRT == 'MX_WB_rt_PAcc_Telemarketing')) {
            cliente.FirstName           = strName;
            cliente.LastName            = strName;
        } else {
            cliente.Name                = strName;
        }
        cliente.AccountNumber       = String.valueOf(NoCliente);
            if(String.isNotBlank(sNameRT)) {
            cliente.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(sNameRT).getRecordTypeId();
        }
        return cliente;
    }
    
    /**
    * @Method crearContrato
    * @param String cuentaId
    * @param Date startDate
    * @Description Retorna un objeto Contract
    * @return Objeto Contract
    **/
    public static Contract crearContrato(Id cuentaId, Date startDate) {
        final Contract contrato = new Contract();
        contrato.AccountId = cuentaId;
        contrato.startDate = Date.today();
        return contrato;       
    }
    
    /**
    * @Method crearCaso
    * @param String cuentaId
    * @param Date startDate
    * @Description Retorna un objeto Case
    * @return Objeto Case
    **/
    public static Case crearCaso(Id idOpp) {
        final Case caso = new Case();
        caso.MX_SB_SAC_Contrato__c = idOpp;
        caso.TipoSiniestro__c = 'PROCEDENTE DE PAGO';
        caso.Status = '';   
        caso.MX_SB_SAC_EsCliente__c = false;
        caso.Origin = 'ARCO';
        caso.MX_SB_SAC_Estado__c = 'Aguascalientes';
        caso.MX_SB_SAC_Emisor__c = 'BMOVIL';
        caso.MX_SB_SAC_TipoContacto__c = 'Asegurado';
        caso.Reason = 'Consultas';
        caso.SiniestroAbierto__c = 'No';
        return caso;
    }

    /**
    * @Method crearCredencial
    * @Description Retorna un objeto MX_SB_SAC_LoginToken__c
    * @return Objeto MX_SB_SAC_LoginToken__c
    **/
    public static MX_SB_SAC_LoginToken__c creaCredencial() {
        final MX_SB_SAC_LoginToken__c loginToken = new MX_SB_SAC_LoginToken__c();
        loginToken.Duracion__c = '180';
        loginToken.Pwd__c = '';
        loginToken.Url__c = 'https://www.wibe.com/cotizadores/api/commons/controller/polizas/';
        loginToken.Usr__c = '';
        return loginToken;
    } 

    /**
    * @Method creaCSParametros
    * @Description Retorna un objeto MX_SB_SAC_ParametrosPoliza__c
    * @return Custom Settings MX_SB_SAC_ParametrosPoliza__c
    **/
    public static MX_SB_SAC_ParametrosPoliza__c creaCSParametros() {
        final MX_SB_SAC_ParametrosPoliza__c paramsPoliza = new MX_SB_SAC_ParametrosPoliza__c();
		paramsPoliza.Name='Número Póliza';
        paramsPoliza.DescripcionCampos__c='numeroPoliza';
        paramsPoliza.Metodo__c='obtenerPolizaPorNumeroDePoliza';
        return paramsPoliza;
    }

    /**
    * @Method crea producto
    * @Description Retorna un objeto Product2
    * @return Product2
    **/
    public static Product2 creaProducto() {
        final Product2 product = new Product2();
        product.Name = 'WIBE';
        product.MX_SB_SAC_Proceso__c = 'SAC';
        return product;
    }

}