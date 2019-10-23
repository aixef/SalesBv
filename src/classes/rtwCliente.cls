/**-------------------------------------------------------------------------
* Nombre: rtwCliente
* @author Julio Medellin
* Proyecto: MW SB VTS - BBVA
* Descripción : Clase control para componente rtwCliente

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Descripción
* -------------------------------------------------------------------
* @version 1.0           02/05/2019      Julio Medellin            Encabezado
* @version 1.0           02/05/2019      Julio Medellin            Se adecua clase al nuevo modelo de datos
* @version 1.1           09/05/2019      Eduardo Hernández         BugFix para petición del servicio ASD Org Retail
* @version 1.2           03/06/2019      Eduardo Hernández         Correcciones Issues Sonar
* @version 1.2.1         08/07/2019      Eduardo Hernández         Fix lista negra para clientes web
* --------------------------------------------------------------------------*/
@RestResource(urlMapping='/Clientes/*')
global without sharing class rtwCliente extends MX_SB_VTS_RtwCliente_Ext { //NOSONAR

    /**
    * rtwCliente Constructor privado
    * @return   Solución Issue singleton
    */
    private rtwCliente () {} //NOSONAR

    /**
    * @description: Se crea o actualiza un Cliente
    */
    @HttpPost
    global static resSFDC upsertCliente( reqCliente cliente ) {
        String sMsn = '';
        Boolean blRta = true;
        final resSFDC rSFDC = new resSFDC();
        rSFDC.error = 'Ejecución de Método: upsertcliente';
        try {
            //Request
            sMsn = 'Request: ' + cliente + '. ';
            String sId = null;
            Schema.DescribeSObjectResult oAccount = Account.sObjectType.getDescribe();
            Schema.DescribeSObjectResult oLead = Lead.sObjectType.getDescribe();
            final List<String> qaEmails = new List<String>();
            Map<String,String>  MAPBL = new  Map<String,String>();
            qaEmails.add(cliente.CorreoElectronico);
            qaEmails.add(cliente.telefono);
            qaEmails.add(cliente.telefonoCelular);
            Boolean noBlacklist = true;
            MAPBL= Utilities.verificarListaNegra(qaEmails);
            for(String valueList : MAPBL.values()) {
              if(valueList.equalsIgnoreCase(cliente.CorreoElectronico) || valueList.equalsIgnoreCase(cliente.telefono) || valueList.equalsIgnoreCase(cliente.telefonoCelular)) {
                noBlacklist = false;
              }
            }
            if (noBlacklist) {
                    sId = fnCrearCliente( cliente );
                    sMsn = createMsgReturn(sId, rSFDC);
            } else {
                rSFDC.message = 'Registro que pertece a la lista negra: ' + cliente.correoElectronico;
                sMsn += rSFDC.message;
                rSFDC.id = '';
            }
        } catch( DmlException ex ) {
            rSFDC.message = 'El siguiente error DML a ocurrido: ' + ex.getMessage();
            sMsn += rSFDC.message;
            blRta = false;
            rSFDC.id = '';
        } catch(Exception ex) {
            rSFDC.message = 'El siguiente error ha ocurrido: ' + ex.getMessage();
            sMsn += rSFDC.message;
            blRta = false;
            rSFDC.id = '';
        }
        WB_CrearLog_cls.fnCrearLog( sMsn, 'rtwCliente', blRta );
        return rSFDC;
    }

    /**
    * @description: Se crea o actualiza un Cliente
    */
    public static String fnCrearCliente( reqCliente cliente ) {
        String sIdAccount;
        Boolean bUpdateCte = true;
        String sCorreoElectronico = '';
        if (cliente.correoElectronico != null && cliente.correoElectronico != '') {
            sCorreoElectronico = String.valueOf(cliente.correoElectronico.toLowerCase('ES'));
            for (Account cte : [Select id, Correo_Electronico__c, (Select id, Estatus__c
            From Opportunities Where Estatus__c = 'Emitida') From Account
            Where Correo_Electronico__c = : sCorreoElectronico]) {
                sIdAccount = cte.id;
                if (!cte.Opportunities.isEmpty()) {
                    bUpdateCte = false;
                }
            }
        }
        String sIdProspecto = [ SELECT  Id FROM    RecordType Where   DeveloperName= 'Prospecto' and IsPersonType = true
        and SobjectType = 'Account'].Id;
        Account entCliente = new Account();
        fillEntClient(sIdAccount, bUpdateCte, entCliente, cliente);
        entCliente.PersonEmail = sCorreoElectronico;
        entCliente.Correo_Electronico__c = sCorreoElectronico;
        entCliente.RecordTypeId = sIdProspecto;
        String sIdCte = '';
        try {
            if(String.isNotBlank(cliente.correoElectronico) && String.isNotBlank(cliente.telefonoCelular)) {
                upsert entCliente;
            }
            if (entCliente.Id != null) {
                sIdCte = entCliente.Id;
            } else {
                sIdCte = '1';
            }
        } catch(Exception ex) {
            sIdCte = entCliente.id + '-' + ex.getMessage();
        }
        return sIdCte ;
    }

    /**Regresa un objeto del tipo PartyAddress si no hubo error a la hora de registrar el cliente */
    public static reqCliente JSONParserreqCliente(String sJsonResp) {
        reqCliente objAPPResp = new reqCliente();
        try {
            JSONParser parser = JSON.createParser(sJsonResp);
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    objAPPResp = (reqCliente)parser.readValueAs(reqCliente.class);
                }
            }
        } catch(Exception ex) {
            System.debug('ERROR EN JSONParserreqCliente: sJsonResp: ' + ex.getMessage());
        }
        return objAPPResp;
    }

    /**
     * fillEmailList llena lista de emails QA
     * @param  qaEmails Lista de correos QA
     */
    public static void fillEmailList (List<String> qaEmails) {
        Utilities.verificarListaNegra(qaEmails);
    }

    /**
     * createMsgReturn Crea mensaje de respuesta
     * @param  sId   Id de Cliente
     * @param  rSFDC objeto de respuesta
     * @param  sMsn  mensaje de respuesta para log
     */
    public static String createMsgReturn(String sId, resSFDC rSFDC) {
        String sMsn = '';
        if(sId.contains('-')) {
            rSFDC.message = 'Error al actualizar los datos del cliente: ' + sId.substring(sId.indexOf('-')+1, sId.length());
            sMsn += rSFDC.message + ' : ' + sId.substring(sId.indexOf('-')+1, sId.length());
            rSFDC.id = '';
        } else {
            rSFDC.message = 'Registro guardado exitosamente: ' + sId;
            sMsn += rSFDC.message;
            rSFDC.id = sId;
        }
        return sMsn;
    }

    /**
     * fillEntClient llena la información del cliente
     * @param  sIdAccount         Ide de la cuenta
     * @param  bUpdateCte         boolean si solo se actualiza cliente
     * @param  entCliente         request ws
     * @param  cliente            datos del cliente encontrado
     */
    public static void fillEntClient(String sIdAccount, Boolean bUpdateCte, Account entCliente, reqCliente cliente) {
        if (sIdAccount != null) {
            entCliente.Id = sIdAccount;
        }
        if (bUpdateCte) {
            entCliente.AccountSource = cliente.origen;
            entCliente.BillingCity = cliente.ciudad;
            entCliente.BillingCountry = cliente.pais;
            entCliente.BillingPostalCode = cliente.codigoPostal;
            entCliente.BillingState = cliente.estado;
            entCliente.BillingStreet = cliente.calleOAvenida;
            entCliente.Colonia__c = cliente.colonia;
            entCliente.Description = cliente.descripcion;
            entCliente.Profesion__c = cliente.profesion;
            entCliente.RFC__c = cliente.rfc;
            entCliente.Genero__c = cliente.sexoDelConductor;
            entCliente.Nacionalidad__c = cliente.nacionalidad;
            entCliente.Numero_Exterior__c = validEmptyNu(cliente.numeroExterior);
            entCliente.Numero_Interior__c = validEmptyNu(cliente.numeroInterior);
            entCliente.Delegacion__c = cliente.delegacion;
            entCliente.FirstName = cliente.nombre;
            entCliente.LastName = cliente.apellidoPaterno;
            entCliente.ApellidoMaterno__c = cliente.apellidoMaterno;
            entCliente.Motivonointeres__c = cliente.motivoNoInteres;
            entCliente.PersonBirthdate = cliente.FechaNacimiento;
            entCliente.Edad__c = ( cliente.edad != '' ? decimal.valueOf(cliente.edad) : null );
            entCliente.PersonHomePhone = cliente.telefono;
            entCliente.Phone = cliente.telefonoCelular;
            entCliente.Salutation = '';
            entCliente.Tipo_Persona__c = (cliente.rfc == '' ? 'Física' : 'Moral');
            entCliente.Motivo_de_no_elegibilidad__c = cliente.motivoNoElegibilidad ;
        } else {
            entCliente.Phone = cliente.telefonoCelular;
            entCliente.PersonHomePhone = cliente.telefono;
        }
        entCliente.codigoIntermediario__c = cliente.valorRealIntermediarioCot;
        entCliente.nombreIntermediario__c = cliente.descripcionIntermediarioCot;
    }
}
