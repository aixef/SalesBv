/**
 * @File Name          : MX_SB_VTS_RtwCliente_Ext.cls
 * @Description        : 
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              : 
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 3/6/2019 12:39:56
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    28/5/2019 17:40:42   Eduardo Hernández Cuamatzi     Initial Version
**/
global virtual without sharing class MX_SB_VTS_RtwCliente_Ext {//NOSONAR

    /*Variabale NUVALSTR nulos*/
    public static final String NUVALSTR = null ;
    /**
    * @desrciption: Objeto de Respuesta - Response
    */
    global class resSFDC {//NOSONAR
        /*Variable de respuesta error alservicio REST */
        global String error {get; set;}
         /*Variable de respuesta message alservicio REST */
        global String message {get; set;}
         /*Variable de respuesta id alservicio REST */
        global String id {get; set;}
    }

    /**
    * @desrciption: Objeto de Entrada - Request
    */
    global class reqCliente {//NOSONAR
         /*Variable de respuesta folioCliente alservicio REST */
        global String folioCliente {get; set;}
         /*Variable de respuesta nombre alservicio REST */
        global String nombre {get; set;}
         /*Variable de respuesta apellidoPaterno alservicio REST */
        global String apellidoPaterno {get; set;}
         /*Variable de respuesta apellidoMaterno alservicio REST */
        global String apellidoMaterno {get; set;}
         /*Variable de respuesta correoElectronico alservicio REST */
        global String correoElectronico {get; set;}
         /*Variable de respuesta fechaNacimiento alservicio REST */
        global Date fechaNacimiento {get; set;}
         /*Variable de respuesta telefono alservicio REST */
        global String telefono {get; set;}
        /*Variable de respuesta telefonoCelular alservicio REST */
        global String telefonoCelular {get; set;}
         /*Variable de respuesta edad alservicio REST */
        global String edad {get; set;}
         /*Variable de respuesta sexoDelConductor alservicio REST */
        global String sexoDelConductor {get; set;}
         /*Variable de respuesta rfc alservicio REST */
        global String rfc {get; set;}
         /*Variable de respuesta nacionalidad alservicio REST */
        global String nacionalidad {get; set;}
         /*Variable de respuesta profesion alservicio REST */
        global String profesion {get; set;}
         /*Variable de respuesta colonia alservicio REST */
        global String colonia {get; set;}
         /*Variable de respuesta calleOAvenida alservicio REST */
        global String calleOAvenida {get; set;}
         /*Variable de respuesta codigoPostal alservicio REST */
        global String codigoPostal {get; set;}
         /*Variable de respuesta numeroExterior alservicio REST */
        global String numeroExterior {get; set;}
         /*Variable de respuesta numeroInterior alservicio REST */
        global String numeroInterior {get; set;}
         /*Variable de respuesta origen alservicio REST */
        global String origen {get; set;}
        /*Variable de respuesta ciudad alservicio REST */
        global String ciudad {get; set;}
         /*Variable de respuesta estado alservicio REST */
        global String estado {get; set;}
         /*Variable de respuesta pais alservicio REST */
        global String pais {get; set;}
         /*Variable de respuesta descripcion alservicio REST */
        global String descripcion {get; set;}
         /*Variable de respuesta motivoNoInteres alservicio REST */
        global String motivoNoInteres {get; set;}
         /*Variable de respuesta delegacion alservicio REST */
        global String delegacion {get; set;}
         /*Variable de respuesta motivoNoElegibilidad alservicio REST */
        global String motivoNoElegibilidad {get; set;}
         /*Variable de respuesta gclid alservicio REST */
        global String gclid {get; set;}
         /*Variable de respuesta estatusCotizacion alservicio REST */
        global String estatusCotizacion {get; set;}
         /*Variable de respuesta folioDeCotizacion alservicio REST */
        global String folioDeCotizacion {get; set;}
         /*Variable de respuesta valorRealIntermediarioCot alservicio REST */
        global String valorRealIntermediarioCot {get; set;}
         /*Variable de respuesta descripcionIntermediarioCot alservicio REST */
        global String descripcionIntermediarioCot {get; set;}
         /*Variable de respuesta TipoDeRegistro alservicio REST */
        global String TipoDeRegistro {get; set;}
         /*Variable de respuesta productoPlan alservicio REST */
        global ProductoPlan productoPlan {get;set;}
    }

    /**
    * @description: Se crea o actualiza un Lead
    */
    public static String fnCrearCandidato( reqCliente cliente ) {
        String sCorreoElectronico = String.valueOf(cliente.correoElectronico.toLowerCase('ES'));
        Lead entCandidato = new Lead();
        entCandidato.Id = validEmptyNu(cliente.folioCliente);
        entCandidato.LeadSource = cliente.origen;
        entCandidato.City = cliente.ciudad;
        entCandidato.Country = cliente.pais;
        entCandidato.PostalCode = cliente.codigoPostal;
        entCandidato.State = cliente.estado;
        entCandidato.Street = cliente.calleOAvenida;
        entCandidato.Colonia__c = cliente.colonia;
        entCandidato.Description = cliente.descripcion;
        entCandidato.Profesion__c = cliente.profesion;
        entCandidato.RFC__c = cliente.rfc;
        entCandidato.Genero__c = cliente.sexoDelConductor;
        entCandidato.Nacionalidad__c = cliente.nacionalidad;
        entCandidato.Numero_Exterior__c = validEmptyNu(cliente.numeroExterior);
        entCandidato.Numero_Interior__c = validEmptyNu(cliente.numeroInterior);
        entCandidato.Delegacion__c = cliente.delegacion;
        entCandidato.FirstName = cliente.nombre;
        entCandidato.LastName = cliente.apellidoPaterno;
        entCandidato.Apellido_Materno__c =  cliente.apellidoMaterno;
        entCandidato.Motivonointeres__c = cliente.motivoNoInteres;
        entCandidato.Fecha_Nacimiento__c = cliente.FechaNacimiento;
        entCandidato.Edad__c = validAge(cliente.edad);
        entCandidato.Email = sCorreoElectronico;
        entCandidato.Phone = cliente.telefono;
        entCandidato.MobilePhone = cliente.telefonoCelular;
        entCandidato.Salutation = '';
        entCandidato.Tipo_Persona__c = cliente.rfc == '' ? 'Física' : 'Moral';
        entCandidato.Motivo_de_no_elegibilidad__c = cliente.motivoNoElegibilidad ;
        upsert entCandidato;
        return entCandidato.Id;
    }

    /**
     * validEmptyNu valida cadenas vaciás
     * @param  valued valor evaluado
     * @return        valor o nulo
     */
    public static String validEmptyNu (String valued) {
        String valStrs = NUVALSTR;
        if(String.isNotBlank(valued)) {
            valStrs = valued;
        }
        return valStrs;
    }

    /**
     * validAge evaluá edad correcta
     * @param  valuedAge valor a evaluar
     * @return           retorna edad o 0
     */
    public static Decimal validAge (String valuedAge) {
        Decimal ageVal = 0;
        if(String.isNotBlank(valuedAge)) {
            ageVal = Decimal.valueOf(valuedAge);
        }
        return ageVal;
    }

    /**
     * validEmptyField Valida campo
     * @param	evaluateValue	Valida valor
     * @return	validField	Retorna campo validado
     */
    public static String validEmptyField(String evaluateValue) {
        String validField = '';
        if (String.isNotBlank(evaluateValue) && String.isNotEmpty(evaluateValue)) {
            validField = evaluateValue;
        }
        return validField ;
    }
}