/*
* @Author: Jaime Terrats
* @Description: Test Hogar Service with 100 records
* npm i jsforce
*/

var jsforce = require('jsforce');


// repleace these values with your credentials in order to be able to connect to the sandbox
var login = 'https://test.salesforce.com',
    cId = '<CLIENT_ID>',
    cSecret = '<CLIENT_SECRET>',
    cUrl = '<ENVIRONMENT_URL_CALLBACK>'
    usr = '<YOUR_USER_NAME>',
    pswd = '<YOUR_PASSWORD_SECURITY_TOKEN>',
    accIds = [],
    emails = [],
    producto = ['ASD', 'Hogar', 'Vida'];

var conn = new jsforce.Connection({
    // you can change loginUrl to connect to sandbox or prerelease env by changing login value.
    loginUrl : login,
    clientId : cId,
    clientSecret : cSecret,
    redirectUri : cUrl
});

conn.login(usr, pswd, function(err, res) {
  if (err) { return console.error(err); }
  selectProduct(producto);
})

function selectProduct(producto) {
  if(producto[0] === 'ASD') {
    upsertASDAccount();
  }
  if(producto[1] === 'Hogar') {
    upsertCotHogar();
  }
}

function upsertASDAccount() {
  let payload = [];
  for(let i = 0; i < 5; i++) {
    payload.push({
      "cliente": {
        "nombre": "Eduardo",
        "apellidoPaterno": "Cuamatzi",
        "apellidoMaterno": "Perez",
        "correoElectronico": "eduardo.cua"+i+"@bbva.com",
        "fechaNacimiento": "1992-04-29",
        "telefono": "",
        "telefonoCelular": "5529164967",
        "edad": "27",
        "sexoDelConductor": "MASCULINO",
        "rfc": "",
        "nacionalidad": "MEXICO",
        "profesion": "EMPLEADO DE OFICINA",
        "colonia": "ACUEDUCTO RIO HONDO",
        "calleOAvenida": "",
        "codigoPostal": "11111",
        "numeroExterior": "",
        "numeroInterior": "",
        "origen": "Inbound",
        "ciudad": "DISTRITO FEDERAL",
        "estado": "CIUDAD DE MEXICO",
        "pais": "",
        "descripcion": "",
        "delegacion": "MIGUEL HIDALGO",
        "folioCliente": null,
        "folioDeCotizacion" : "03869"+i,
        "estatusCotizacion" : "CREADA",
        "descripcionIntermediarioCot": null,
        "valorRealIntermediarioCot": null
      }
    });
    conn.apex.post('/Clientes/', payload[i], function(err, res) {
      if(err) { return console.error(err); }
      accIds.push(res.id);
      emails.push(payload[i].cliente.correoElectronico);
      upsertCot(accIds, emails);
      console.log(res);
    });
  }
}


function upsertCot(accIds, emails) {
  let cotPayload = [];
  for(let i = 0; i < 5; i++) {
    cotPayload.push({
      "cotizacion": {
        "anio": "2019",
        "apellidoMaternoContratante": "Perez",
        "apellidoPaternoContratante": "Mendoza",
        "campanya": "PAGO_CON_PUNTOS",
        "comentariosPersonalizacion": null,
        "conduceAlguienMas": "NO",
        "laPersonaQueAdquiereLaPolizaEsElContratante": "SI",
        "correoElectronicoContratante": emails[i],
        "cuetaConDispositivos": "NO",
        "descripcion": null,
        "descripcionIntermediarioCot": null,
        "codigoCupon": "",
        "descuentoCupones": "NO",
        "edadConductoresAdicionles": "Mayor a 25",
        "formaDePago": "MENSUAL",
        "gclid": null,
        "marca": "AUDI",
        "modelo": "2019",
        "nombreDelContratante": "Valeria",
        "numeroPoliza": "01231263"+i,
        "numeroDeSerieDelVehiculo": "12345678901234567",
        "origenDeLaCotizacion": "Outbound",
        "placas": "mgz46778",
        "plan": "Amplio",
        "primaCotizada": "19441.81",
        "producto": "Seguro fronterizo de auto bancomer",
        "saleACarretera": null,
        "salvamentoCot": null,
        "sexoConductor": "H",
        "submarca": "A1",
        "telefonoCelularContratante": "2462014248",
        "tipoAuto": "AUTOMOVILES",
        "valorPromocion": null,
        "valorRealIntermediarioCot": null,
        "version": "1.4 TFSI COOL SPORTBACK AA EE CD BA S TRONIC HATCHBACK 4 CIL 5 P 4 OCUP",
        "esFraude": null,
        "folioDeCotizacion": "03869"+i,
        "estatus": "Emitida",
        "motivoDeInteres": "venta",
        "fechaPolizaIni" : "2019-07-03 00:00:00",
        "fechaPolizaFin" : "",
        "cliente" : accIds[i],
        "idDeAsesor" : "Internet"
      }
    });
    conn.apex.post('/Cotizacion/', cotPayload[i], function(res, err) {
      if(err) { return console.error(err); }
      console.log(res);
    });
  }
}

function upsertCotHogar() {
  let cotPayload = [];
    for(let i = 0; i < 5; i++) {
      cotPayload.push({
        "datosCotizacion":{
          "DatosIniciales":{
            "codigoPostal": "22000",
            "folioCotizacion": "19030962"+i,
            "valorHogar": "2000000",
            "statusCotizacion": "Emitida",
            "origen": "outbound",
            "producto": "Hogar",
            "numeroPoliza": "19030962"+i
          },
          "TipoDeSeguro":{
            "conOSinSismo":"con",
            "danosInmueble":"90000.00",
            "danosAContenidos":"90000.00",
            "porRobo":"90000.00",
            "roturaDeCristales":"90000.00",
            "responsabilidadPrivadaFamiliar":"90000.00",
            "danosEquipoElectrico":"180000.00",
            "precioAnual":"5527.81",
            "frequenciaPago":"Anual",
            "cantidadDePagos":"1"
          },
          "DatosPrecio":{
            "precioParcialidades":"5527.81",
            "precioTotal":"5527.81",
            "msiBancomer":"true",
            "cupon": "false"
          },
          "DatosAdicionales":{
            "cercaniaMantosAquiferos":false,
            "murosTabiqueLadrilloBlock":true,
            "techoTabiqueLadrilloBlock":true,
            "casaODepartamento":"casa",
            "noPisosInmueble":"2",
            "pisoHabitado":""},
          "DatosCliente":{
            "nombre": "Jim",
            "apPaterno":"Terr",
            "apMaterno":"Lue",
            "email":"jaimealberto.terrats.contractor@bbva.com",
            "fechaNacimiento":"09/03/1987",
            "telefonoCasa":"5571095432",
            "celular":"5571095432",
            "sexo":"f",
            "rfc":"bafl890410"
          },
          "DatosDomicilio":{
            "calleCliente":"Moctezuma",
            "cpCliente":"11000",
            "coloniaCliente":"ACUEDUCTO RIO HONDO",
            "codColoniaCliente":"02",
            "ciudadCliente":"MIGUEL HIDALGO",
            "codCiudad":"01",
            "numExtCliente":"11",
            "numIntCliente":"",
            "estadoCliente":"DISTRITO FEDERAL",
            "codEstadoCliente":"03",
            "paisCliente":"01",
            "codPaisCliente":"MEX"
          },
          "DatosDomAsegurado": {
            "calleCliente":"Moctezuma",
            "cpCliente":"11000",
            "coloniaCliente":"ACUEDUCTO RIO HONDO",
            "codColoniaCliente":"02",
            "ciudadCliente":"MIGUEL HIDALGO",
            "codCiudad":"01",
            "numExtCliente":"11",
            "numIntCliente":"",
            "estadoCliente":"DISTRITO FEDERAL",
            "codEstadoCliente":"03",
            "paisCliente":"01",
            "codPaisCliente":"MEX"
          }
        }
      });
    conn.apex.post('/Hogar/', cotPayload[i], function(res, err) {
      if(err) { return console.error(err); }
      console.log(res);
    });
  }
}
