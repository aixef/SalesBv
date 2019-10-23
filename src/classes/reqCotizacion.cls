/**-------------------------------------------------------------------------
* Nombre: reqCotizacion
* @author Julio Medellin
* Proyecto: MW SB VTS - BBVA 
* Descripción : Clase wrapper para respuesta de petición Rest
* --------------------------------------------------------------------------
*                         Fecha           Autor                   Descripción
* -------------------------------------------------------------------
* @version 1.0           02/05/2019      Julio Medellin           Clase para mantener los registros Cotizador(wrap)
* @version 1.0           21/06/2019      Julio Medellin           Modificacion para solucionar codsmell
* --------------------------------------------------------------------------*/
global class reqCotizacion {//NOSONAR       
    /* llamada a variable cliente del servicio REST*/
    global String cliente { get; set;}
    /* llamada a variable idDeAsesor del servicio REST*/
    global String idDeAsesor { get; set; }
    /* llamada a variable primaCotizada del servicio REST*/
    global String primaCotizada { get; set; }
    /* llamada a variable origenDeLaCotizacion del servicio REST*/
    global String origenDeLaCotizacion { get; set; }
    /* llamada a variable folioDeCotizacion del servicio REST*/
    global String folioDeCotizacion { get; set; }
    /* llamada a variable estatus del servicio REST*/
    global String estatus { get; set; }
    /* llamada a variable formaDePago del servicio REST*/
    global String formaDePago { get; set; }
    /* llamada a variable plan del servicio REST*/
    global String plan { get; set; }
    /* llamada a variable descuentoFacultado del servicio REST*/
    global String descuentoFacultado { get; set; }
    /* llamada a variable descuentoCupones del servicio REST*/
    global String descuentoCupones { get; set; }
    /* llamada a variable anio del servicio REST*/
    global String anio { get; set; }
    /* llamada a variable marca del servicio REST*/
    global String marca { get; set; }
    /* llamada a variable submarca del servicio REST*/
    global String submarca { get; set; }
    /* llamada a variable version del servicio REST*/
    global String version { get; set; }
    /* llamada a variable tipoAuto del servicio REST*/
    global String tipoAuto { get; set; }
    /* llamada a variable conduceAlguienMas del servicio REST*/
    global String conduceAlguienMas { get; set; }
    /* llamada a variable numeroDeSerieDelVehiculo del servicio REST*/
    global String numeroDeSerieDelVehiculo { get; set; }
    /* llamada a variable alguienMasConduce del servicio REST*/
    global String alguienMasConduce { get; set; }
    /* llamada a variable placas del servicio REST*/
    global String placas { get; set; }
    /* llamada a variable laPersonaQueAdquiereLaPolizaEsElContratante del servicio REST*/
    global String laPersonaQueAdquiereLaPolizaEsElContratante { get; set; }
    /* llamada a variable nombreDelContratante del servicio REST*/
    global String nombreDelContratante { get; set; }
    /* llamada a variable napellidoPaternoContratanten del servicio REST*/
    global String apellidoPaternoContratante { get; set; }
    /* llamada a variable apellidoMaternoContratante del servicio REST*/
    global String apellidoMaternoContratante { get; set; }
    /* llamada a variable correoElectronicoContratante del servicio REST*/
    global String correoElectronicoContratante { get; set; }
    /* llamada a variable telefonoCelularContratante del servicio REST*/
    global String telefonoCelularContratante { get; set; }
    /* llamada a variable fechaCierre del servicio REST*/
    global Date   fechaCierre { get; set; }
    /* llamada a variable comentariosPersonalizacion del servicio REST*/
    global String comentariosPersonalizacion { get; set; }
    /* llamada a variable cuetaConDispositivos del servicio REST*/
    global String cuetaConDispositivos { get; set; }
    /* llamada a variable descripcion del servicio REST*/
    global String descripcion { get; set; }
    /* llamada a variable edadConductoresAdicionles del servicio REST*/
    global String edadConductoresAdicionles { get; set; }
    /* llamada a variable modelo del servicio REST*/
    global String modelo { get; set; }
    /* llamada a variable producto del servicio REST*/
    global String producto { get; set; }
    /* llamada a variable saleACarretera del servicio REST*/
    global String saleACarretera { get; set; }
    /* llamada a variable sexoConductor del servicio REST*/
    global String sexoConductor { get; set; }
    /* llamada a variable motivoDeInteres del servicio REST*/
    global String motivoDeInteres { get; set; }
    /* llamada a variable numeroPoliza del servicio REST*/
    global String numeroPoliza { get; set; }
    /* llamada a variable idOportunidadComercial del servicio REST*/
    global String idOportunidadComercial {get;set;}
    /* llamada a variable gclid del servicio REST*/
    global String gclid { get; set; }
    /* llamada a variable salvamentoCot del servicio REST*/
    global String salvamentoCot { get; set; }
    /* llamada a variable valorRealIntermediarioCot del servicio REST*/
    global String valorRealIntermediarioCot { get; set; }
    /* llamada a variable descripcionIntermediarioCot del servicio REST*/
    global String descripcionIntermediarioCot { get; set; }
    /* llamada a variable tipoDeRegistro del servicio REST*/
    global String tipoDeRegistro { get; set; }
    /* llamada a variable campanya del servicio REST*/
    global String campanya { get; set; }
    /* llamada a variable valorPromocion del servicio REST*/
    global String valorPromocion { get; set; }
    /* llamada a variable aseguradora del servicio REST*/
    global String aseguradora { get; set; }
    /* llamada a variable fechaPolizaIni del servicio REST*/
    global String fechaPolizaIni { get; set; }
    /* llamada a variable fechaPolizaFin del servicio REST*/
    global String fechaPolizaFin { get; set; }
    /* llamada a variable esFraude del servicio REST*/
    public String esFraude {get;set;}
    /* llamada a variable codigoCupon del servicio REST*/
    public String codigoCupon {get;set;}
    /*Variable de respuesta productoPlan alservicio REST */
    public ProductoPlan productoPlan {get;set;}
    
}