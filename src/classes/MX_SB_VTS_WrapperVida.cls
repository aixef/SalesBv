/**
 * @File Name          : MX_SB_VTS_WrapperVida.cls
 * @Description        : Estructura wrapper para servicio de Vida
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              : BBVA Bancomer
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 17/10/2019 18:23:13
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    20/5/2019 10:45:50   Eduardo Hernández Cuamatzi     Initial Version
**/
global virtual with sharing class MX_SB_VTS_WrapperVida { // NOSONAR
    /*
    * Wrapper class for service response
    */
    global class MX_SB_VTS_ResponseSFDC { // NOSONAR
        /* displays error message if something fails*/
        public String error { get; set; }
        /* success message*/
        public String message { get; set; }
        /* account Id returned by the service*/
        public String recordId { get; set; }
    }

     /*
    * Wrapper class for service response
    */
    global class MX_SB_VTS_DatosCotizacion { // NOSONAR
         /* llamada a variable datosIniciales del servicio REST de los Datos de cotizacion*/
        public MX_SB_VTS_DatosIniciales datosIniciales { get; set; }
        /* llamada a variable datosAdicionalesVida del servicio REST de los Datos de cotizacion*/
        public MX_SB_VTS_CoberturaInicial datosAdicionalesVida { get; set; } // NOSONAR
        /* llamada a variable datosPrecio del servicio REST de los Datos de cotizacion*/
        public MX_SB_VTS_DatosPrecio datosPrecio { get; set; }
        /* llamada a variable tipoDeSeguroVida del servicio REST de los Datos de cotizacion*/
        public MX_SB_VTS_TipoSeguroVida tipoDeSeguroVida { get; set; }
        /* llamada a variable datosCliente del servicio REST de los Datos de cotizacion*/
        public MX_SB_VTS_DatosCliente datosCliente { get; set; }
        /* llamada a variable datosDomicilio del servicio REST de los Datos de cotizacion*/
        public MX_SB_VTS_DatosDomicilio datosDomicilio { get; set; }
        /* llamada a variable datosDomAsegurado del servicio REST de los Datos de cotizacion*/
        public List<MX_SB_VTS_Beneficiarios> beneficiarios { get; set; }
    }

    /*
    * Wrapper that builds object
    */
    public class MX_SB_VTS_DatosIniciales {
        /* llamada a variable totalSumAsegurada del servicio REST*/
        public String sumaAsegurada { get; set; }
        /* llamada a variable folioCotizacion del servicio REST*/
        public String folioCotizacion { get; set; }
        /* llamada a variable statusCotizacion del servicio REST*/
        public String statusCotizacion { get; set; }
        /* llamada a variable origen del servicio REST*/
        public String origen { get; set; }
        /* llamada a variable producto del servicio REST*/
        public String producto { get; set; }
        /* llamada a variable numeroPoliza del servicio REST*/
        public String numeroPoliza { get; set; }
        /* llamada a variable folioTracking del servicio REST */
        public String folioTracking { get; set; }
    }

    /*
    * Wrapper that builds object
    */
    public class MX_SB_VTS_DatosCliente {
        /* llamada a variable nombre del servicio REST*/
        public String nombre { get; set; }
        /* llamada a variable apPaterno del servicio REST*/
        public String apPaterno { get; set; }
        /* llamada a variable apMaterno del servicio REST*/
        public String apMaterno { get; set; }
        /* llamada a variable email del servicio REST*/
        public String email { get; set; }
        /* llamada a variable fechaNacimiento del servicio REST*/
        public String fechaNacimiento { get; set; }
        /* llamada a variable celular del servicio REST*/
        public String celular { get; set; }
        /* llamada a variable telefonoCasa del servicio REST*/
        public String telefonoCasa { get; set; }
        /* llamada a variable sexo del servicio REST*/
        public String sexo { get; set; }
        /* llamada a variable rfc del servicio REST*/
        public String rfc {get; set; }
    }

    /*
    * Wrapper that builds object
    */
    public class MX_SB_VTS_CoberturaInicial {
        /* llamada a variable cancerígena del servicio REST*/
        public String cancerTumoresLeucemiaLupus { get; set; } // NOSONAR
        /* llamada a variable cardiopatias del servicio REST*/
        public String aneurismaTrombosisEmbolia { get; set; } // NOSONAR
        /* llamada a variable pulmonares del servicio REST*/
        public String emficemaBronquitisTuberculosis { get; set; } // NOSONAR
        /* llamada a variable hepaticas del servicio REST*/
        public String insuficienciasCirrosisHepatitis { get; set; } // NOSONAR
    }

    /*
    * Wrapper that builds object
    */
    public class MX_SB_VTS_DatosPrecio {
        /* llamada a variable precioParcialidades del servicio REST*/
        public String precioParcialidades { get; set; } // NOSONAR
        /* llamada a variable precioTotal del servicio REST*/
        public String precioTotal { get; set; }
        /* llamada a variable msiBancomer del servicio REST*/
        public String msiBancomer { get; set; }
        /* llamada a variable cupon del servicio REST*/
        public String cupon { get; set; }
    }

    /*
    * Wrapper that builds object
    */
    public class MX_SB_VTS_TipoSeguroVida {
        /* llamada a variable tipoPlan del servicio REST*/
        public String tipoPlan { get; set; }
        /* llamada a variable precioParcialidades del servicio REST*/
        public String precioAnual { get; set; }
        /* llamada a variable frequenciaPago del servicio REST*/
        public String frequenciaPago { get; set; }
        /* llamada a variable cantidadDePagos del servicio REST*/
        public String cantidadDePagos { get; set; }
        /* llamada a variable totalFallecimiento del servicio REST*/
        public String totalFallecimiento { get; set; } // NOSONAR
        /* llamada a variable totalGastosFunerarios del servicio REST*/
        public String totalGastosFunerarios { get; set; } // NOSONAR
        /* llamada a variable totalMuerteAccidental del servicio REST*/
        public String totalMuerteAccidental { get; set; } // NOSONAR
    }

    /*
    * Wrapper that builds object
    */
    public class MX_SB_VTS_DatosDomicilio {
        /* llamada a variable calleCliente del servicio REST del domicilio del cliente*/
        public String calleCliente { get; set; }
        /* llamada a variable cpCliente del servicio REST del domicilio del cliente*/
        public String cpCliente { get; set; }
        /* llamada a variable coloniaCliente del servicio REST del domicilio del cliente*/
        public String coloniaCliente { get; set; }
        /* llamada a variable codColoniaCliente del servicio REST del domicilio del cliente*/
        public String codColoniaCliente { get; set; }
        /* llamada a variable ciudadCliente del servicio REST del domicilio del cliente*/
        public String ciudadCliente { get; set; }
        /* llamada a variable codCiudad del servicio REST del domicilio del cliente*/
        public String codCiudad { get; set; }
        /* llamada a variable numExtCliente del servicio REST del domicilio del cliente*/
        public String numExtCliente { get; set; }
        /* llamada a variable numIntCliente del servicio REST del domicilio del cliente*/
        public String numIntCliente { get; set; }
        /* llamada a variable estadoCliente del servicio REST del domicilio del cliente*/
        public String estadoCliente { get; set; }
        /* llamada a variable codEstadoCliente del servicio REST del domicilio del cliente*/
        public String codEstadoCliente { get; set; }
        /* llamada a variable paisCliente del servicio REST del domicilio del cliente*/
        public String paisCliente { get; set; }
        /* llamada a variable codPaisCliente del servicio REST del domicilio del cliente*/
        public String codPaisCliente { get; set; }
        /* llamada a variable cupon del servicio REST*/
        public String codigoPostal { get; set; }
    }

    /*
    * Wrapper class for service response
    */
    public class MX_SB_VTS_Beneficiarios {
        /* llamada a variable nombre del servicio REST de beneficiarios*/
        public String nombre { get;set; }
        /* llamada a variable nombre del servicio REST de beneficiarios*/
        public String apellidoPaterno { get;set; }
        /* llamada a variable nombre del servicio REST de beneficiarios*/
        public String apellidoMaterno { get;set; }
        /* llamada a variable nombre del servicio REST de beneficiarios*/
        public String parentesco { get;set; }
        /* llamada a variable nombre del servicio REST de beneficiarios*/
        public String procentaje { get;set; }
    }
}
