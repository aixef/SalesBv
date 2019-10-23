/****************************************************************************************************
    Información general
    -------------------
    author: Javier Armando Tibamoza Cubillos
    email: jtibamoza@avanxo.com
    company: Avanxo Colombia
    Project: Implementación Salesforce
    Customer: WIBE
    Description: Crear clase para crear Data

    Information about changes (versions)
    -------------------------------------
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------
    1.0       08-Mar-2016     Javier Tibamoza              Creación de la Clase
	1.1       10-Ene-2019     José David Mendoza           Se agrega TipoPersonaCliente__c a la creación de la oportunidad
****************************************************************************************************/
@isTest
public class WB_CrearData_cls {
    /** Method getCliente*/
    public static Account getCliente( String sNombre, String sApellido ) {
        final Account oCliente = new Account();
        oCliente.Firstname = sNombre;
        oCliente.Lastname = sApellido;
        oCliente.Correo_Electronico__c = 'prueba@test.com';
        oCliente.PersonEmail = 'prueba@test.com';
        oCliente.Phone = '3224446655';
        oCliente.Genero__c = 'Masculino';
        oCliente.PersonBirthdate = system.today().addYears(-35);
        oCliente.AccountSource = 'Call me back';
        return oCliente;
    }
    /** Method getLead*/
    public static Lead getLead() {
        final Lead oLead = new Lead();
        oLead.Lastname = 'Prueba Lead';
        oLead.Firstname = 'Nombre Lead';
        oLead.status = 'Creado';
        return oLead;
    }
    /** Method getOportunidad*/
    public static Opportunity getOportunidad(Account oCliente ,String sFolio, String sProducto) {
        Decimal decRan = Math.random();
        decRan = Math.round( decRan*1000 );
        final Opportunity oOpp = new Opportunity();
        oOpp.FolioCotizacion__c = sFolio;
        oOpp.AccountId = oCliente.Id;
        oOpp.Name = 'Opp Test' + decRan;
        oOpp.StageName = 'Prospecting';
        oOpp.CloseDate = system.today().addDays(10);
        oOpp.Estatus__c = 'Emitida';
        oOpp.Motivoelegibilidad__c = 'Motivo uso comercial';
        oOpp.Sexo_conductor__c = 'Masculino';
        oOpp.telefonoCelularContratante__c = '3224446655';
        oOpp.correoElectronicoContratante__c = oCliente.PersonEmail;
        oOpp.CorreoCliente__c = oCliente.PersonEmail;
        oOpp.Producto__c = sProducto;
        oOpp.CargaInicial__c = true;
        oOpp.NumerodePoliza__c = '1234567890';
        oOpp.TipoPersonaCliente__c = 'MORAL';
        return oOpp;
    }
    /** Method*/
    public static TemporalCasosPolizas__c getTemporalCasosPolizas(String sIdCase) {

        final TemporalCasosPolizas__c oTempCasosPoli = new TemporalCasosPolizas__c();
        oTempCasosPoli.Caso__c = sIdCase;
        oTempCasosPoli.NoPoliza__c = '1234567890';
        oTempCasosPoli.Name = '1234567890';

        return oTempCasosPoli;
    }
    /** */
    public static case getCase(Id OpportunityId) {
        final Case oCase = new Case();
        oCase.Subject = 'Prueba CASE';
        oCase.status = 'Abierto';
        oCase.Priority = 'Media';
        oCase.Poliza__c = OpportunityId;
        
  
        return oCase;
    
        
    }

}