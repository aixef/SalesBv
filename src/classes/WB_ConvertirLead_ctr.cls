/****************************************************************************************************
    Información general
    -------------------
    author: Javier Armando Tibamoza Cubillos
    email: jtibamoza@avanxo.com
    company: Avanxo Colombia
    Project: Implementación Salesforce
    Customer: WIBE
    Description: Crear VF para convertir Candidatos

    Information about changes (versions)
    -------------------------------------
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------
    1.0       08-Mar-2016     Javier Tibamoza              Creación de la Clase
****************************************************************************************************/
public with sharing class WB_ConvertirLead_ctr {
	/**variable olead*/
    public Lead oLead {get;set;}
    /**variable oleadpaso*/
    public Lead oleadPaso {get;set;}

    /**
    * description: Constructor
    */
    public WB_ConvertirLead_ctr() {}
    /** description: Constructor*/
    public WB_ConvertirLead_ctr(ApexPages.StandardController stdController) {

        oLead = (Lead)stdController.getRecord();
        oLeadPaso = new Lead();
        try {
            oLeadPaso = new Lead();
            for (lead l : [Select Id, Name, OwnerId, TelefonoCelular__c, Phone, Email, Folio_Cotizacion__c
                From Lead Where Id =: oLead.Id]) {
                oLeadPaso = l;
            }
        } catch(Exception ex) { }
    }
    /** Method*/
    public PageReference fnConvertir() {

        System.debug('EN WB_ConvertirLead_ctr.fnConvertir oLeadPaso: ' + oLeadPaso);
        Boolean bFolOppExis = false;
        String sNameFolCtDup = '';

        if (userInfo.getUserId() != oleadPaso.OwnerId) {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Para poder visualizar los datos de la cotización generada debe ser propietario de la oportunidad comercial.'));
            return null;
        }

        //HECTOR: VE QUE TENGA LOS DATOS DE CORREO Y NUMERO DE TELEFONO
        if (oLeadPaso.TelefonoCelular__c == NULL || oLeadPaso.Email == NULL) {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Para poder cotizar tiene que capturar la clave de correo y el Número de Teléfono.'));
            return null;
        }

        //Ve si existe una Opp con el folio FolioCotizacion__c
        if (oLeadPaso.Folio_Cotizacion__c != null) {
	        for (Opportunity objOppDup : [SELECT Id, Name From Opportunity Where FolioCotizacion__c =: oLeadPaso.Folio_Cotizacion__c]) {
	            bFolOppExis = true;
	            sNameFolCtDup = objOppDup.Name;
	        }
        }//Fin si oLeadPaso.Folio_Cotizacion__c != null

        //HECTOR: VE SI YA EXISTE EL FOLIO DE LA  COTIZACION
        if (bFolOppExis ) {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'El folio de la cotizacion : ' + oLeadPaso.Folio_Cotizacion__c + ' ya existe para la Cotizcion: ' + sNameFolCtDup ));
            return null;
        }

        Savepoint savep;
        try {

            savep = Database.setSavepoint();
            oLead.Llamada_Realizada__c=true;
            Database.update(oLead);

            //Id idRetorno = fnConvertir( oLead.firstname + '_' + oLead.lastname, false).sIdOpp;
            final Id idRetorno = fnConvertir( oLead.firstname + '_' + oLead.lastname, false, oLeadPaso.phone, oLeadPaso.email).sIdOpp;

            System.debug('EN WB_ConvertirLead_ctr.fnConvertir0 idRetorno : ' + idRetorno );

            final PageReference orderPage = new PageReference('/' + idRetorno );
            orderPage.setRedirect( true );

            if (userInfo.getUserId() != oleadPaso.OwnerId) {
                return null;
            }

            return orderPage;

        } catch( Exception e ) {
            Database.rollback( savep );
            ApexPages.addmessage( new ApexPages.message( ApexPages.severity.ERROR, e.getMessage() ) );

        }

        return null;
    }
    /** Method */
   public oCliOpp fnConvertir( String sNombreOportunidad, Boolean blRetornarIdCliente, String sPhone, String sEmail ) {
        String sIdClteAct;

        System.debug('EN WB_ConvertirLead_ctr.fnConvertir sNombreOportunidad: ' + sNombreOportunidad + ' blRetornarIdCliente: ' + blRetornarIdCliente
        + ' sPhone: ' + sPhone + ' sEmail: ' + sEmail);

        Account cteExis = new Account();
        Boolean bExisteCte = false;

        final oCliOpp wrpCliOpp = new oCliOpp();

        List<Opportunity> lOportunidad = new List<Opportunity>();

        final List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();

        final LeadStatus convertStatus = [
          select    MasterLabel
          from      LeadStatus
          where     IsConverted = true
          limit 1 ];

        //Consulta los datos del cliente si es que ya existe en SFDC
        for (Account cliente : [Select id, Name, Correo_Electronico__c
            , isPersonAccount, PersonBirthdate, FirstName, LastName, PHONE
            , Edad__c, Genero__c, RFC__c, Nacionalidad__c, Profesion__c, Colonia__c
            , BillingPostalCode, Numero_Exterior__c, Numero_Interior__c, AccountSource
            , BillingCity, BillingState, BillingCountry, BillingStreet, Delegacion__c
            From Account
            Where Correo_Electronico__c = :sEmail
            ]) {
            sIdClteAct = cliente.id;
            bExisteCte = true;
            cteExis = cliente;
        }//Fin del for para los clientes que tienen esta clave de correo

        System.debug('EN WB_ConvertirLead_ctr.fnConvertir2 sIdClteAct: ' + sIdClteAct + ' bExisteCte: ' + bExisteCte + ' cteExis: ' + cteExis);

        //Un objeto del tipo SavePoint
        //final SavePoint svFinal = Database.setSavepoint();

        try {

            final Database.LeadConvert leadconv = new Database.LeadConvert();
            //Ve si existe el cliente
            leadconv.setLeadId( oLead.Id );
            if (bExisteCte) {
                leadconv.setAccountId(sIdClteAct);
            leadconv.setOpportunityName( sNombreOportunidad );
            leadconv.setDoNotCreateOpportunity( false );
            leadconv.setConvertedStatus( convertStatus.MasterLabel );
            leadConverts.add( leadconv );
            }

            final List<Database.LeadConvertResult> lcr = Database.convertLead( leadConverts );
            System.debug('EN WB_ConvertirLead_ctr.fnConvertir4 leadconv.getAccountId(): ' + leadconv.getAccountId());

            if (bExisteCte) {
                 wrpCliOpp.sIdCliente = sIdClteAct;
            } else {
                wrpCliOpp.sIdCliente = lcr[0].getAccountId();
                sIdClteAct = lcr[0].getAccountId();
            }

            System.debug('EN WB_ConvertirLead_ctr.fnConvertir6 sIdClteAct : ' + sIdClteAct);
            //Valida si se quiere retornar el Id de la Opp
            lOportunidad = [SELECT Id,accountid From Opportunity Where Name =: sNombreOportunidad
                And AccountId =: sIdClteAct  ];

            //Incializa los datos de la opp si es que el cliente ya existe y actualizala
            if (bExisteCte) {
            final Opportunity objOpportunity = lOportunidad.get(0);

            //Cambia los datos del contratante en (objOpportunity) por los del asegurado
            objOpportunity.nombreDelContratante__c = cteExis.FirstName;
            objOpportunity.apellidoPaternoContratante__c = cteExis.LastName;
            objOpportunity.correoElectronicoContratante__c = cteExis.Correo_Electronico__c == null ? null : cteExis.Correo_Electronico__c;
            objOpportunity.telefonoCelularContratante__c = cteExis.Phone;
            objOpportunity.Fecha_Nacimiento_Contratante__c = cteExis.PersonBirthdate == null ? null : Date.valueOf(cteExis.PersonBirthdate);
            objOpportunity.EdadBeneficiario__c = cteExis.Edad__c == null ? null : cteExis.Edad__c;
            objOpportunity.SexoDelConductorBenef__c = cteExis.Genero__c;
            objOpportunity.RFCBenef__c = cteExis.RFC__c;
            objOpportunity.NacionalidadBenef__c = cteExis.Nacionalidad__c;
            objOpportunity.ProfesionBenef__c = cteExis.Profesion__c;
            objOpportunity.ColoniaBenef__c = cteExis.Colonia__c;
            objOpportunity.CalleAvenida__c = cteExis.BillingStreet;
            objOpportunity.CodigoPostalBenef__c = cteExis.BillingPostalCode == null ? null : cteExis.BillingPostalCode;
            objOpportunity.NumeroExteriorBenef__c = cteExis.Numero_Exterior__c == null ? null : cteExis.Numero_Exterior__c;
            objOpportunity.numeroInteriorBenef__c = cteExis.Numero_Interior__c == null ? null : cteExis.Numero_Interior__c;
            objOpportunity.OrigenBenef__c = cteExis.AccountSource;
            objOpportunity.CiudadBenef__c = cteExis.BillingCity;
            objOpportunity.EstadoBenef__c = cteExis.BillingState;
            objOpportunity.PaisBenef__c = cteExis.BillingCountry;
            objOpportunity.DelegacionBenef__c = cteExis.Delegacion__c;

            System.debug('EN WB_ConvertirLead_ctr.fnConvertir6 objOpportunity: ' + objOpportunity);
            update objOpportunity;

            }//Fin si bExisteCte

            //Valida si existe la Opp
            wrpCliOpp.sIdOpp = ( lOportunidad.isEmpty() ? ''  : lOportunidad[0].Id);
            wrpCliOpp.sIdCliente=( lOportunidad.size() > 0 ? lOportunidad[0].AccountId : '' );

            System.debug('EN WB_ConvertirLead_ctr.fnConvertir7 wrpCliOpp: ' + wrpCliOpp);

            //***PARA UNA PRUEBA ***//
            //Database.rollback(svFinal);

        } catch(Exception ex) {
            ApexPages.addmessage( new ApexPages.message( ApexPages.severity.ERROR, ex.getMessage() ) );
            System.debug('ENTRO A WB_ConvertirLead_ctr.fnConvertir8 ERROR AL convertir el lead: ' + ex.getMessage());
        }

        return wrpCliOpp;
    }
    /** */
    public PageReference fnVolver() {

        PageReference orderPage;
        if (userInfo.getUserId() == oleadPaso.OwnerId) {
            orderPage = new PageReference('/' + oLead.Id );
        } else {
            orderPage = new PageReference('/');
        }
        orderPage.setRedirect( true );
        return orderPage;
    }

    /**
    * description: Wrapper
    */
    public class oCliOpp {
        /**variable sid cliente*/
        public String sIdCliente {get;set;}
        /**variable sid oportunidad*/
        public String sIdOpp {get;set;}
        /** method oCliOpp*/
        public oCliOpp() {
            this.sIdCliente = '';
            this.sIdOpp = '';
        }
        /** Method*/
        public oCliOpp( String sIdCliente, String sIdOpp ) {
            this.sIdCliente = sIdCliente;
            this.sIdOpp = sIdOpp;
        }
    }

}