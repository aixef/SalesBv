/*
*
* @author Jaime Terrats
* @description Wrapper class for API Hogar
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    04/10/2019     Jaime Terrats     Create data structure to get incoming data from web tracking
* @version  1.1    05/10/2019     Jaime Terrats     Remove code smells
*/
global without sharing class MX_SB_VTS_HogarWrapper { //NOSONAR
    private MX_SB_VTS_HogarWrapper() {} //NOSONAR

    /*
    * Wrapper class for service response
    */
    global class MX_SB_VTS_ResponseSFDC { // NOSONAR
        /* displays error message if something fails*/
        global String error { get; set; }
        /* success message*/
        global String message { get; set; }
        /* account Id returned by the service*/
        global String id { get; set; }
    }
    /*
    * Wrapper that builds object
    */
    global class MX_SB_VTS_DatosIniciales { // NOSONAR
        /* llamada a variable codigoPostal del servicio REST*/
        global String codigoPostal { get; set; }
        /* llamada a variable folioCotizacion del servicio REST*/
        global String folioCotizacion { get; set; }
        /* llamada a variable valorHogar del servicio REST*/
        global String valorHogar { get; set; }
        /* llamada a variable statusCotizacion del servicio REST*/
        global String statusCotizacion { get; set; }
        /* llamada a variable origen del servicio REST*/
        global String origen { get; set; }
        /* llamada a variable producto del servicio REST*/
        global String producto { get; set; }
        /* llamada a variable numeroPoliza del servicio REST*/
        global String numeroPoliza { get; set; }
        /* llamada a variable folioTracking del servicio REST */
        global String folioTracking { get; set; }
    }
    /*
    * Wrapper that builds object
    */
    global class MX_SB_VTS_TipoDeSeguro { // NOSONAR
        /* llamada a variable conOSinSismo del servicio REST*/
        global String conOSinSismo { get; set; }
        /* llamada a variable danosInmueble del servicio REST*/
        global String danosInmueble { get; set; }
        /* llamada a variable danosAContenidos del servicio REST*/
        global String danosAContenidos { get; set; }
        /* llamada a variable porRobo del servicio REST*/
        global String porRobo { get; set; }
        /* llamada a variable roturaDeCristales del servicio REST*/
        global String roturaDeCristales { get; set; } // NOSONAR
        /* llamada a variable responsabilidadPrivadaFamiliar del servicio REST*/
        global String responsabilidadPrivadaFamiliar { get; set; } // NOSONAR
        /* llamada a variable danosEquipoElectrico del servicio REST*/
        global String danosEquipoElectrico { get; set; } // NOSONAR
        /* llamada a variable precioAnual del servicio REST*/
        global String precioAnual { get; set; }
        /* llamada a variable frequenciaPago del servicio REST*/
        global String frequenciaPago { get; set; }
        /* llamada a variable cantidadDePagos del servicio REST*/
        global String cantidadDePagos { get; set; }
    }
    /*
    * Wrapper that builds object
    */
    global class MX_SB_VTS_DatosPrecio { // NOSONAR
        /* llamada a variable precioParcialidades del servicio REST*/
        global String precioParcialidades { get; set; } // NOSONAR
        /* llamada a variable precioTotal del servicio REST*/
        global String precioTotal { get; set; }
        /* llamada a variable msiBancomer del servicio REST*/
        global String msiBancomer { get; set; }
        /* llamada a variable cupon del servicio REST*/
        global String cupon { get; set; }
    }
    /*
    * Wrapper that builds object
    */
    global class MX_SB_VTS_DatosAdicionales { // NOSONAR
        /* llamada a variable cercaniaMantosAquiferos del servicio REST*/
        global Boolean cercaniaMantosAquiferos { get; set; } // NOSONAR
        /* llamada a variable murosTabiqueLadrilloBlock del servicio REST*/
        global Boolean murosTabiqueLadrilloBlock { get; set; } // NOSONAR
        /* llamada a variable techoTabiqueLadrilloBlock del servicio REST*/
        global Boolean techoTabiqueLadrilloBlock { get; set; } // NOSONAR
        /* llamada a variable casaODepartamento del servicio REST*/
        global String casaODepartamento { get; set; } // NOSONAR
        /* llamada a variable noPisosInmueble del servicio REST*/
        global String noPisosInmueble { get; set; }
        /* llamada a variable pisoHabitado del servicio REST*/
        global String pisoHabitado { get; set; }
    }
    /*
    * Wrapper that builds object
    */
    global class MX_SB_VTS_DatosCliente { // NOSONAR
        /* llamada a variable nombre del servicio REST*/
        global String nombre { get; set; }
        /* llamada a variable apPaterno del servicio REST*/
        global String apPaterno { get; set; }
        /* llamada a variable apMaterno del servicio REST*/
        global String apMaterno { get; set; }
        /* llamada a variable email del servicio REST*/
        global String email { get; set; }
        /* llamada a variable fechaNacimiento del servicio REST*/
        global String fechaNacimiento { get; set; }
        /* llamada a variable telefonoCasa del servicio REST*/
        global String telefonoCasa { get; set; }
        /* llamada a variable celular del servicio REST*/
        global String celular { get; set; }
        /* llamada a variable sexo del servicio REST*/
        global String sexo { get; set; }
        /* llamada a variable rfc del servicio REST*/
        global String rfc {get; set; }
    }
    /*
    * Wrapper that builds object
    */
    global class MX_SB_VTS_DatosDomicilio { // NOSONAR
        /* llamada a variable calleCliente del servicio REST del domicilio del cliente*/
        global String calleCliente { get; set; }
        /* llamada a variable cpCliente del servicio REST del domicilio del cliente*/
        global String cpCliente { get; set; }
        /* llamada a variable coloniaCliente del servicio REST del domicilio del cliente*/
        global String coloniaCliente { get; set; }
        /* llamada a variable codColoniaCliente del servicio REST del domicilio del cliente*/
        global String codColoniaCliente { get; set; }
        /* llamada a variable ciudadCliente del servicio REST del domicilio del cliente*/
        global String ciudadCliente { get; set; }
        /* llamada a variable codCiudad del servicio REST del domicilio del cliente*/
        global String codCiudad { get; set; }
        /* llamada a variable numExtCliente del servicio REST del domicilio del cliente*/
        global String numExtCliente { get; set; }
        /* llamada a variable numIntCliente del servicio REST del domicilio del cliente*/
        global String numIntCliente { get; set; }
        /* llamada a variable estadoCliente del servicio REST del domicilio del cliente*/
        global String estadoCliente { get; set; }
        /* llamada a variable codEstadoCliente del servicio REST del domicilio del cliente*/
        global String codEstadoCliente { get; set; }
        /* llamada a variable paisCliente del servicio REST del domicilio del cliente*/
        global String paisCliente { get; set; }
        /* llamada a variable codPaisCliente del servicio REST del domicilio del cliente*/
        global String codPaisCliente { get; set; }
    }
    /*
    * Wrapper that builds object
    */
    global class MX_SB_VTS_DatosCotizacion { // NOSONAR
        /* llamada a variable datosIniciales del servicio REST de los Datos de cotizacion*/
        global MX_SB_VTS_DatosIniciales datosIniciales { get; set; }
        /* llamada a variable tipoDeSeguro del servicio REST de los Datos de cotizacion*/
        global MX_SB_VTS_TipoDeSeguro tipoDeSeguro { get; set; }
        /* llamada a variable datosPrecio del servicio REST de los Datos de cotizacion*/
        global MX_SB_VTS_DatosPrecio datosPrecio { get; set; }
        /* llamada a variable datosAdicionales del servicio REST de los Datos de cotizacion*/
        global MX_SB_VTS_DatosAdicionales datosAdicionales { get; set; }
        /* llamada a variable datosCliente del servicio REST de los Datos de cotizacion*/
        global MX_SB_VTS_DatosCliente datosCliente { get; set; }
        /* llamada a variable datosDomicilio del servicio REST de los Datos de cotizacion*/
        global MX_SB_VTS_DatosDomicilio datosDomicilio { get; set; }
        /* llamada a variable datosDomAsegurado del servicio REST de los Datos de cotizacion*/
        global MX_SB_VTS_DatosDomicilio datosDomAsegurado { get; set; }
    }
}