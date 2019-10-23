/**
* Indra
* @author           Javier Ortiz Flores
* Project:          WIBE
* Description:      Clase de utilidad que brinda distintas creaciones de objetos para clases test.
*
* Changes (Version)
* ------------------------------------------------------------------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    --------------------------------------
* @version  1.0     2018-12-18      Javier Ortiz F.         Creación de la Clase
* @version  1.1     2019-01-24      Ing. Daniel Goncalves.  Se agregan methods createDataCase, createFile y createDocumentLink
* @version  1.2     2019-02-07      Salvador Reyna          Se agregan methods de prueba
* @version  1.3     2019-02-07      Ing. Daniel Goncalves   Se corrige merge
* @version  1.4     2019-02-11      Ing. Eduardo Hernández  Se agregan methods createOppChkLst, createMasterCheck, createPreguntasEtapa
* @version  1.5     2019-02-12      Karen Belem Sanchez     Se agrega method createProcNotiOppNoAten
* @version  1.6     2019-02-14      Ing. Daniel Goncalves   Se corrigen comentarios
* @version  1.7     2019-02-18      Ing. Salvador Reyna     Se corrigen errores
* @version  1.8     2019-04-24      Ing. Karen Belem Sanchez  Se agregan method crearAsignacion y createCase
* @version  1.9     2019-05-19      Julio Medellín          Se especifica valores en oppWon
* @version  1.91    2019-05-19      Julio Medellín          Se crea proveedor
* @version  2.0     2019-10-03      Julio Medellín          Se Crea funcion para crear Producto
********************************************************************************************************************************************/
@isTest
public class MX_WB_TestData_cls {
    /**
    */
    public static final DateTime dFechaPruebaPrueba = DateTime.now();
    /**
    */
    public static final String sNamePrueba = 'UserPrueba' + dFechaPruebaPrueba;
    /**
    */
    public static final String sLastNamePrueba = 'ApellidoPrueba' + dFechaPruebaPrueba.millisecondGmt();
    /**
    */
    static Map<String, Profile> perfilMapa = new Map<String, Profile>();
    /**
    */
    static Map<String, UserRole> rolMapa   = new Map<String, UserRole>();
    /**
    */
    static List<Profile> lstProfile;
    /**
    */
    static List<UserRole> userRole;
    static {
        lstProfile = new List<Profile>([SELECT Id, Name FROM Profile WHERE Name != null]);
        userRole   = new List<UserRole>([SELECT Id, Name FROM UserRole WHERE Name != null]);
        for(Profile perfil:lstProfile) { perfilMapa.put(perfil.Name, perfil); }
        for(UserRole ur:userRole) { rolMapa.put(ur.Name, ur); }
    }
    /**
    */
    public static final Id pricebookId = Test.getStandardPricebookId();
    /**
    * @Method crearUsuario
    * @param String strLastName
    * @param Sring strProfileName
    * @Description method que retorna un objeto User
    * @return Objeto User
    **/
    public static User crearUsuario(String strLastName, String strProfileName) {
        final String email                  = 'tstBBVA'+(Math.random()*10000)+'@bbva.test.com';
        final User usuario                  = new User();
        usuario.LastName              = strLastName;
        usuario.Alias                 = String.valueOf((Math.random()*10000).round());
        usuario.Email                 = email;
        usuario.UserName              = email;
        usuario.EmailEncodingKey      = 'UTF-8';
        usuario.LanguageLocaleKey     = 'en_US';
        usuario.TimeZoneSidKey        = 'America/Mexico_City';
        usuario.LocaleSidKey          = 'en_US';
        usuario.IsActive              = true;
        usuario.CompanyName           = 'SulAmérica';
        usuario.ProfileId             = perfilMapa.get(strProfileName).Id;
        return usuario;
    }
    /**
    * @Method crearCuenta
    * @param String strName
    * @param String devNameTipoRegistro
    * @Description method que retorna un objeto cliente
    * @return Objeto Account
    **/
    public static Account crearCuenta(String strName, String devNameTipoRegistro) {
        final Long NoCliente              = (Math.random()*10000000).round();
        final Account cliente             = new Account();
        if(String.isNotBlank(devNameTipoRegistro) && (devNameTipoRegistro == 'PersonAccount' || devNameTipoRegistro == 'MX_WB_rt_PAcc_Telemarketing')) {
            cliente.FirstName           = strName;
            cliente.LastName            = strName;
        } else {
            cliente.Name                = strName;
        }
        cliente.AccountNumber       = String.valueOf(NoCliente);
            if(String.isNotBlank(devNameTipoRegistro)) {
            cliente.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(devNameTipoRegistro).getRecordTypeId();
        }
        return cliente;
    }
    /**
    * @Method crearOportunidad
    * @Description method que crea y retorna un objeto Oportunidad
    * @param String strName
    * @param Id idAccount
    * @param Id idOwner
    * @param String devNameTipoRegistro
    * @param Id idProdBEyG
    * @return Objeto Opportunity
    **/
    public static Opportunity crearOportunidad(String strName, Id idAccount, Id idOwner, String devNameTipoRegistro) {
        final String sClaveDistPaso = String.valueOf(Math.random());
        final String sNoPoliza = sClaveDistPaso.substring(0, 10).replace('.', '0');
        final Opportunity objOpp                      = new Opportunity();
        objOpp.Name                             = strName;
        objOpp.StageName                        = 'Prospección';
        objOpp.Estatus__c                       = 'Emitida';
        objOpp.NumerodePoliza__c                = sNoPoliza;
        objOpp.FolioCotizacion__c               = sNoPoliza;
        objOpp.AccountId                        = idAccount;
        objOpp.CloseDate                        = Date.today().addDays(15);
        objOpp.Banco__c                         = 'BANAMEX';
        objOpp.Codigoverificadorcompra__c       = '1234';
        objOpp.RFCcontratante__c                = 'XXXX720811XX5';
        objOpp.CORREOELECTRONICOCONTRATANTE__c  = 'prueba@hotmail.com';
        objOpp.OwnerId                          = idOwner;
        if(String.isNotBlank(devNameTipoRegistro)) {
            objOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(devNameTipoRegistro).getRecordTypeId();
        }
        return objOpp;
    }
    /**
    * @Method:      CreaTarea1
    * @param:       Integer noTarea, String sIdCaso, String sSubject
    * @Description: method que retorna un objeto task
    *//*
        Tarea.Description   = 'Call';
        Tarea.Priority      = 'Normal';
        Tarea.Status        = 'No Iniciado';
        Tarea.Subject       = sSubject;
        Tarea.IsReminderSet = false;
        Tarea.WhatId        = sIdCaso;
        Tarea.OwnerId       = idOwner;
        if(String.isNotBlank(devNameRecordType)) Tarea.RecordTypeId =
        Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get(devNameRecordType).getRecordTypeId();

        return Tarea;
    }*/
    /**
    * @Method:      PalabraRespuesta
    * @Description: method que retorna un objeto PalabraRespuesta__c
    *//*
        objPalabra.Name                 =   name;
        objPalabra.Palabra__c           =   Palabra;
        objPalabra.Categoria__c         =   Categoria;
        return objPalabra;
    }*/
    /**
    * @Method:      Encuesta
    * @Description: method que retorna un objeto PalabraRespuesta__c
    *//*

        objEncuenta.Name                    = Name;
        objEncuenta.CampoTipoEncuesta__c    = cambioTipoEncuesta;
        objEncuenta.NombreEncuesta__c       = NombreEncuesta;
        return objEncuenta;
    }*/
    /**
    * @Method:      Encuesta
    * @Description: method que retorna un objeto PalabraRespuesta__c
    *//*
        dispVit.Name                    =   Name;
        dispVit.Asignado__c             =   Status;
        return dispVit;
    }*/
    /**
    * @Method:      Encuesta
    * @Description: method que retorna un objeto PalabraRespuesta__c
    *//*
        objPreguntaRespuesta.Name                           =   Name;
        objPreguntaRespuesta.Pregunta__c                    =   Pregunta;
        objPreguntaRespuesta.Respuesta__c                   =   Respuesta;
        objPreguntaRespuesta.NumeroPregunta__c              =   numeroPregunta;
        objPreguntaRespuesta.DetalleClientePolizaCaso__c    =   idCliente;
        return objPreguntaRespuesta;
    }*/
    /**
    * @Method:      creaStringDin
    * @Description: method que retorna una cadena de tamaño determinado y con tantos saltos de línea como se requiera.
    */
    public static String creaStringDin(Integer tamanio, Integer noLineas) {
        String dataString = '';
        for(Integer j=0; j<noLineas; j++) {
            for(Integer i=0; dataString.length() <= tamanio; i++) {
                System.debug(i);
                dataString += generaCaracterAleatorio();
            }
            dataString += ' \n';
        }
        return dataString;
    }

    /**
    * @Method:      generaCaracterAleatorio
    * @Description: method que retorna un caracter de manera aleatoria.
    */
    private static String generaCaracterAleatorio() {
        final String[] arr = new String[] { 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',',','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',',','0','1','2','3','4','5','6','7','8','9',',' };
        final Double dbAleatorio = Math.random()*65;
        final Integer intAleatorio = dbAleatorio.intValue();
        final String elegido = arr[intAleatorio];
        return elegido;
    }
/**
*Method CreaClienteC
*/
    public static List<Account> CreaClienteC(Integer noCliente, String strRT) {
        final List<Account> lCliente = new List<Account>();

        for (Integer cnt=0; cnt < noCliente; cnt++) {
            final String sClaveDistPaso = String.valueOf(Math.random());
            final String sClaveDist = sClaveDistPaso.substring(10);
            final String sNumeroCte = sClaveDistPaso.substring(10);

            System.debug(sClaveDist);

            final Account Cliente = new Account();
            Cliente.AccountNumber = sNumeroCte;
            //Cliente.RecordTypeId = strRT;
            Cliente.FirstName = 'Jeisson';
            Cliente.LastName = 'Rojas';
            Cliente.PersonEmail  = 'jroja'+ sNumeroCte +'@mail.com';
            Cliente.RFC__c = '000000000005';
            Cliente.PersonMobilePhone = '3007676475';
            Cliente.PersonHomePhone = '3007676475';
            cliente.PersonOtherPhone = '3007676475';
            cliente.Phone = '3007676475';
            lCliente.add(Cliente);
        }

        insert lCliente;
        return lCliente;
    }
    /*
        List<Case> lOppVta = new List<Case>();

        for (Integer cnt=0; cnt < noOppVta; cnt++) {
            Case OppVta = new Case();
            OppVta.Status = 'New';
            OppVta.Origin = 'Phone';
            OppVta.Priority = 'Medium';
            OppVta.AccountId = iIdCte != null ? iIdCte : null;
            lOppVta.add(OppVta);
        }

        insert lOppVta;
        return lOppVta;
    }*/
    /*
        List<Task > lTarea = new List<Task>();

        for (Integer cnt=0; cnt < noTarea; cnt++) {
            Task Tarea = new Task();
            Tarea.Description = 'Call';
            Tarea.Priority = 'Normal';
            Tarea.Status = 'No Iniciado';
            Tarea.Subject = sSubject;
            Tarea.IsReminderSet = false;
            Tarea.WhatId = sIdCaso;
            lTarea.add(Tarea);
        }

        insert lTarea;
        return lTarea;
    }*/
    /*
        ProcNotiOppNoAten__c ProcNoti = new ProcNotiOppNoAten__c();
        ProcNoti.Horario__c = sHorario;
        ProcNoti.Minutos__c = sMinutos;
        ProcNoti.Activo__c = false;
        lProcNoti.add(ProcNoti);

        insert lProcNoti;
        return lProcNoti;
    }*/

    public static List<Opportunity> CreaOportunidad(Integer noOportunidad, String sIdAccount, String sIdRt, String sEstatus) {
        final String sClaveDistPaso = String.valueOf(Math.random());
        final String sNoPoliza = sClaveDistPaso.substring(0, 10).replace('.', '0');
        String sIdPriceBookEntry = '';

        final List<Opportunity> lOportunidad = new List<Opportunity >();

        for(Pricebook2 pbl : [select id,Name,IsStandard from Pricebook2 where isStandard=true limit 1]) {
            sIdPriceBookEntry = pbl.id;
        }
        final Pricebook2  objPricebook2= new Pricebook2();
        objPricebook2.Name='Standard Price Book1';
        objPricebook2.IsActive=true;
        insert objPricebook2;

        for (Integer cnt = 0; cnt < noOportunidad; cnt++) {
            final Opportunity  Oportunidad = new Opportunity ();
            Oportunidad.Name = sNamePrueba;
            Oportunidad.AccountId  = sIdAccount != null ? sIdAccount : null;
            Oportunidad.Pricebook2Id = sIdPriceBookEntry != null ? sIdPriceBookEntry : null;
            Oportunidad.CloseDate = Date.today();
            Oportunidad.StageName = 'Prospección';
            Oportunidad.RecordTypeId = sIdRt != null ? sIdRt : null;
            Oportunidad.Estatus__c = sEstatus; //'Emitida'
            Oportunidad.NumerodePoliza__c = sNoPoliza;
            Oportunidad.FolioCotizacion__c = sNoPoliza;
            Oportunidad.CORREOELECTRONICOCONTRATANTE__c = 'prueba@hotmail.com';
            Oportunidad.Banco__c = 'BANAMEX';
            Oportunidad.Codigoverificadorcompra__c = '1234';
            Oportunidad.RFCcontratante__c  = 'FIAH720811CH5';
            lOportunidad.add(Oportunidad);

        }

        insert lOportunidad;
        return lOportunidad;
    }
    /*

        String sNoPoliza = sClaveDistPaso.substring(0, 10).replace('.', '0');
        List<CatalogoDocumentacion__c> lCatalogoDocumentacion = new List<CatalogoDocumentacion__c >();

        for (Integer cnt = 0; cnt < noCatalogoDocumentacion; cnt++) {
            CatalogoDocumentacion__c  CatalogoDocumentacion = new CatalogoDocumentacion__c ();
            CatalogoDocumentacion.Name = 'Bonificaciones-Cargos irregulares';
            CatalogoDocumentacion.Motivo__c  = 'Bonificaciones';
            CatalogoDocumentacion.Detalle__c = 'Cargos irregulares';
            CatalogoDocumentacion.Subdetalle__c = 'Otros bancos';
            CatalogoDocumentacion.Dias__c = 'Hábil';
            CatalogoDocumentacion.NS__c = '5';
            CatalogoDocumentacion.Documentacion__c = 'Carta, IFE y estado de cuenta';
            CatalogoDocumentacion.RequiereValTel__c = true;
            CatalogoDocumentacion.RequiereDocumentacion__c = true;
            CatalogoDocumentacion.Ejecutor__c = 'BO3';
            CatalogoDocumentacion.Aprobador__c = 'Iserma Hernández';
            CatalogoDocumentacion.ClienteCandidato__c = 'Cliente';
            lCatalogoDocumentacion.add(CatalogoDocumentacion);

        }

        insert lCatalogoDocumentacion;
        return lCatalogoDocumentacion;
    }*/
    /*
        List<EncuestaMKTSFDC__c> lEncuestaMKTSFDC = new List<EncuestaMKTSFDC__c>();

        for (Integer cnt=0; cnt < noEncuestaMKTSFDC; cnt++) {
            EncuestaMKTSFDC__c EncuestaMKTSFDC = new EncuestaMKTSFDC__c();
            EncuestaMKTSFDC.NumeroEncuestaMKT__c = sNumeroEncuestaMKT;
            EncuestaMKTSFDC.TipoEncuesta__c = 'Atención';
            EncuestaMKTSFDC.Pregunta1__c = '¿Qué tan probable es que recomiendes wibe a un familiar o amigo?';
            EncuestaMKTSFDC.Respuesta1__c = '4';
            EncuestaMKTSFDC.Pregunta2__c = '¿Cómo valoras el servicio de atención a clientes wibe?';
            EncuestaMKTSFDC.Respuesta2__c = '5';
            lEncuestaMKTSFDC.add(EncuestaMKTSFDC);
        }

        insert lEncuestaMKTSFDC;
        return lEncuestaMKTSFDC;
    }*/
    /*
        List<Bloque__c> lBloque = new List<Bloque__c>();

        for (Integer cnt=0; cnt < noBloque; cnt++) {
            Bloque__c Bloque = new Bloque__c();
            Bloque.BloqueActivo__c = true;
            lBloque.add(Bloque);
        }

        insert lBloque;
        return lBloque;
    }*/
    /*
        List<PagosEspejo__c> lPagosEspejo = new List<PagosEspejo__c>();

        for (Integer cnt=0; cnt < noPagosEspejo; cnt++) {
            PagosEspejo__c objPagosEspejo = new PagosEspejo__c();
            objPagosEspejo.Sistema__c = '';
            objPagosEspejo.Semaforo__c = '';
            objPagosEspejo.RespuestaDeCobranza__c = '';
            objPagosEspejo.Puntos__c = 100.00;
            objPagosEspejo.Producto__c = 'WIBE';
            objPagosEspejo.Poliza__c = sIdPoliza;
            objPagosEspejo.Nombre__c = 'PPRUEBA';
            objPagosEspejo.ImportePesos__c = 2053.00;
            objPagosEspejo.ImporteDolares__c = 0.00;
            objPagosEspejo.FormaDePago__c = 'SEMESTRAL';
            objPagosEspejo.Elegir_Pago__c = true;
            objPagosEspejo.Factura__c = sIdFactura;
            objPagosEspejo.Correo3__c = 'Prueba1@hotmail.com';
            objPagosEspejo.Correo2__c = 'Prueba1@hotmail.com';
            objPagosEspejo.Correo1__c = 'Prueba1@hotmail.com';
            objPagosEspejo.CodigoProducto__c = '';
            objPagosEspejo.Clasificacion__c = 'HD';
            objPagosEspejo.CausadeRechazodeCobranza__c = 'TARJETA RESTRINGIDA';
            objPagosEspejo.Bloque__c = sIdBloque;
            objPagosEspejo.BloqueLupa__c = sIdBloque;
            objPagosEspejo.ApellidoPaterno__c = 'Prueba';
            objPagosEspejo.Antiguedad__c = 1;
            objPagosEspejo.Pagado__c = false;
            objPagosEspejo.Orden__c = cnt++;
            objPagosEspejo.AgendaAtencion__c = false;
            lPagosEspejo.add(objPagosEspejo);
        }

        insert lPagosEspejo;
        return lPagosEspejo;
    }
    */
    public static Account creaCuenta(String firstName, String lastName) {
        final Id idRecordType = [SELECT DeveloperName,Id,Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Prospecto'].Id;
        final Account objAccount = new Account();
        objAccount.FirstName = 'Prueba';
        objAccount.LastName = 'Test';
        objAccount.AccountSource = 'Outbound';
        objAccount.RecordTypeId = idRecordType;
        objAccount.Correo_Electronico__c = 'minion01@gmail.com';
        objAccount.PersonEmail= 'minion01@gmail.com';
        return objAccount;
    }
/**
*Method creaOportunidad
*/
    public static Opportunity creaOportunidad(Account objAccount, String nombreOportunidad, Opportunity polizaEspejo) {
        final String sClaveDistPaso = String.valueOf(Math.random());
        final String sNoPoliza = sClaveDistPaso.substring(0, 10).replace('.', '0');
        final Opportunity objOpp = new Opportunity();
        objOpp.Name = nombreOportunidad;
        objOpp.StageName = 'Prospección';
        objOpp.Estatus__c = 'Emitida';
        objOpp.NumerodePoliza__c = sNoPoliza;
        objOpp.FolioCotizacion__c = sNoPoliza;
        objOpp.AccountId = objAccount.Id;
        objOpp.CloseDate = Date.today().addDays(20);
        objOpp.Banco__c = 'Bancomer';
        objOpp.Codigoverificadorcompra__c = '1234';
        objOpp.RFCcontratante__c = 'XXXX720811XX5';
        objOpp.CORREOELECTRONICOCONTRATANTE__c = 'minion001@gmail.com';
        if(polizaEspejo != null) {
            objOpp.PolizaEspejo__c = polizaEspejo.Id;
        }
        return objOpp;
    }
    /*
        objTask.ActivityDate = Date.today().addDays(2);
        objTask.Description = 'Test description';
        objTask.WhatId = whatId;
        objTask.Subject = strSubject;
        return objTask;
    }*/

    /**
    * @Method:      Crear Catalogo Documentacion
    * @param:       String name, String motivo, String detalle, String subDetalle, String clienteCandidato
    * @Description: Se crea un catalogo en base a los parametros, procurar no generar registros con los mismos parametros Motivo, detalle y subdetalle
    *//*
        String sNoPoliza = sClaveDistPaso.substring(0, 10).replace('.', '0');
        CatalogoDocumentacion__c  catalogoDocumentacion = new CatalogoDocumentacion__c ();
        CatalogoDocumentacion.Name = name;
        CatalogoDocumentacion.Motivo__c  = motivo;
        CatalogoDocumentacion.Detalle__c = detalle;
        CatalogoDocumentacion.Subdetalle__c = subDetalle;
        CatalogoDocumentacion.Dias__c = 'Hábil';
        CatalogoDocumentacion.NS__c = '5';
        CatalogoDocumentacion.Documentacion__c = documentacion;
        CatalogoDocumentacion.RequiereValTel__c = validacion;
        CatalogoDocumentacion.RequiereDocumentacion__c = documents;
        CatalogoDocumentacion.Ejecutor__c = 'BO3';
        CatalogoDocumentacion.Aprobador__c = 'Iserma Hernández';
        CatalogoDocumentacion.ClienteCandidato__c = clienteCandidato;
        CatalogoDocumentacion.Activo__c = true;
        return catalogoDocumentacion;
    }*/

    public static Case createDataCase(Id idOpp, String estado, String estadoSistema, String siniestro, String siniestro2) {
        final Case caso = new Case();
        caso.Poliza__c = idOpp;
        caso.TipoSiniestro__c = siniestro;
        caso.SiniestroAbierto__c = siniestro2;
        caso.Status = estado;
        caso.EstadoSistema__c = estadoSistema;
        return caso;
    }

   /**
    * @Method:      Crear Nuevo Pago
    * @param:       String idOpp, String factura, String codigoProducto, Decimal importePesos, String producto
    * @Description: Se instancea el objeto Pago__c y se setean sus datos
    *//*
        pago.Poliza__c= idOpp;
        pago.Factura__c = factura;
        pago.CodigoProducto__c=codigoProducto;
        pago.ImportePesos__c = importePesos;
        pago.Producto__c = producto;
        pago.VencimientoDelRecibo__c =  system.today();
        return pago;
    }*/
    /**
    * @Method:      Crear Nuevo Pago en liena
    * @param:      String numeroTarjeta__c, String numeroAprobacion, String tipoTarjeta,
    String cuatroDigitos, String promociones, String puntosBancomer, Decimal montoPuntosBancomer
    * @Description: Se instancea el objeto PagoLinea__c y se setean sus datos
    *//*
    public static PagoLinea__c creaNuevoPagoLinea(String numeroTarjeta, String numeroAprobacion, String tipoTarjeta,
        PagoLinea__c pagoL = new PagoLinea__c();
        pagoL.NumeroTarjeta__c= numeroTarjeta;
        pagoL.NumeroAprobacion__c=numeroAprobacion;
        pagoL.TipoTarjeta__c = tipoTarjeta;
        pagoL.Ultimos4DigitoTarjetaSistema__c=cuatroDigitos;
        pagoL.Promociones__c = promociones;
        pagoL.PuntosBancomer__c=puntosBancomer;
        pagoL.MontoPuntosBancomer__c = montoPuntosBancomer;
        return pagoL;
    }*/
    /**
     * @Method:         createAccount
     * @Description:    Crea una Oportunidad con etapa cerrada.
     * */
    public static Account createAccount(String name, String devNameTipoRegistro) {
        final Account cuenta = new Account();
        if(String.isNotBlank(devNameTipoRegistro)) {
            cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(devNameTipoRegistro).getRecordTypeId();
        }
        if(System.Label.MX_SB_VTS_PersonRecord.equals(devNameTipoRegistro)) {
            cuenta.LastName = name;
            cuenta.FirstName = name;

        } else {
            cuenta.Name = name;
        }
        return cuenta;
    }

    /**
    * @Method:         createOppClosed
    * @Description:    Crea una Oportunidad con etapa cerrada.
    **/
    public static Opportunity createOppClosed(String name, Id accountId, String devNameTipoRegistro) {
        final Opportunity oppWon = new Opportunity();
        oppWon.Name = name;
        oppWon.StageName = 'Closed Won';
        oppWon.CloseDate = Date.today().addDays(5);
        oppWon.Producto__c = 'Auto Seguro Dinamico';
        oppWon.Estatus__c = 'Emitida';
        oppWon.LeadSource = 'Inbound';
        oppWon.FolioCotizacion__c = 'Test123';
        oppWon.Plan__c = 'Basico';
        oppWon.Producto__c = 'Hogar';
        oppWon.Reason__c = 'Venta';
        oppWon.MX_SB_VTS_Aplica_Cierre__c = true;
        oppWon.AccountId = accountId;
        if(String.isNotBlank(devNameTipoRegistro)) {
            oppWon.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(devNameTipoRegistro).getRecordTypeId();
        }
        return oppWon;
    }

    /**
    * @Method:         createConcept
    * @Description:    Crea un concepto de evaluacion.
    **/
    public static CatalogoConceptos__c createConcept(String descripcion, Integer noConcepto, Integer noPonderacion, String tipoError) {
        final CatalogoConceptos__c concepto = new CatalogoConceptos__c();
        concepto.Activa__c = true;
        concepto.MX_WB_ClasificacionErrorNoVenta__c = tipoError;
        concepto.MX_WB_ClasificacionErrorVenta__c = tipoError;
        concepto.Descripcion__c = descripcion;
        concepto.NoConcepto__c = noConcepto;
        concepto.MX_WB_Ponderacion__c = noPonderacion;
        concepto.MX_WB_PuntosEntrenamiento__c = 'Test Punto';
        return concepto;
    }
    /**
    * @Method:         createSubsection
    * @Description:    Crea una subsección de evaluacion.
    **/
    public static CatalogoSubsecciones__c createSubsection(String descripcion, Integer noSubsection) {
        final CatalogoSubsecciones__c subseccion = new CatalogoSubsecciones__c();
        subseccion.Nombre__c = descripcion;
        subseccion.Numero__c = noSubsection;
        return subseccion;
    }
    /**
    * @Method:         createSection
    * @Description:    Crea una sección de evaluacion.
    **/
    public static CatalogoSeccion__c createSection(String descripcion, Integer noSection) {
        final CatalogoSeccion__c seccion = new CatalogoSeccion__c();
        seccion.Nombre__c   = descripcion;
        seccion.NumeroSeccion__c    = noSection;
        return seccion;
    }
    /**
    * @Method:         createSectionSubsectionConcept
    * @Description:    Crea un registro de relacion Sección-Subsección-Concepto (SSC) de evaluacion.
    **/
    public static SeccionSubseccionConcepto__c createSectionSubsectionConcept(Id sectionId, Id subsectionId, Id conceptId) {
        final SeccionSubseccionConcepto__c ssc = new SeccionSubseccionConcepto__c();
        ssc.CatalogoConceptos__c = conceptId;
        ssc.CatalogoSubseccion__c = subsectionId;
        ssc.CatalogoSeccion__c = sectionId;
        return ssc;
    }
    /**
     * createMasterCheck Crea un registro Master_Checklist__c
     * @params   name - Nombre del master checkList
     *           recordT - RecordType es el developerName de Master_Checklist__c
     *           producto - Id del producto relacionado
     *           userId - Id del usuario que crea el registro
     * @return   return registro Master_Checklist__c
     */
    public static Master_Checklist__c createMasterCheck (String name, String recordT, Id userId) {
        final Master_Checklist__c mstrCheckLst = new Master_Checklist__c();
        mstrCheckLst.Name = name;
        mstrCheckLst.RecordTypeId = recordT;
        //mstrCheckLst.CreatedById = userId;
        return mstrCheckLst;
    }

    /**
    * @Method createProductsFamily
    * @Description Se crea una familia de Productos
    * @param String strNameFamily
    * @return Objeto de la Familia de Producto
    **/
    public static MX_WB_FamiliaProducto__c createProductsFamily(String strNameFamily) {
        final MX_WB_FamiliaProducto__c objFamilyPro = new MX_WB_FamiliaProducto__c();
        objFamilyPro.Name = strNameFamily;
        return objFamilyPro;
    }

    /**
    * @Method:         priceBookEntryNew
    * @Description:    crea relación producto oportunidad.
    **/
    public static PricebookEntry priceBookEntryNew(String productoId) {
        final PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id      = pricebookId;
        standardPrice.Product2Id        = productoId;
        standardPrice.UnitPrice         = 10000;
        standardPrice.IsActive          = true;
        return standardPrice;
    }

    /**
    * @Method productNew
    * @Description crea producto
    * @param String nombreProduct
    * @return Objeto Producto2
    **/
     public static product2  productNew(String nombreProduct) {
        final product2 producto = new product2();
        producto.name   = nombreProduct;
        producto.IsActive=TRUE;
        producto.MX_SB_SAC_Proceso__c = 'VTS';
        producto.Family = 'none';
        return producto;
    }


    /**
    * @Method:         oppLineItmNew
    * @Description:    crea relación producto oportunidad.
    **/
    public static opportunityLineItem oppLineItmNew(String oppId, String priceBookReg, String idProducto, Integer cantidad, Integer precio) {
        final opportunityLineItem oppLineItm = new opportunityLineItem();
        oppLineItm.OpportunityId    = oppId;
        oppLineItm.PricebookEntryId = priceBookReg;
        oppLineItm.Product2Id       = idProducto;
        oppLineItm.Quantity         = cantidad;
        oppLineItm.UnitPrice        = precio;
        return oppLineItm;
    }

    /**
    * @Method createPriceBook2
    * @Description Se crea un Pricebook2 Standard
    * @return Objeto de Pricebook2
    **/
    public static Pricebook2 createStandardPriceBook2 ( ) {
        final Pricebook2  objStPricebook2= new Pricebook2();
        objStPricebook2.Id = Test.getStandardPricebookId();
        objStPricebook2.IsActive = true;
        update objStPricebook2;
        return objStPricebook2;
    }

    /**
     * createPreguntasEtapa Crea un registro MX_WB_preguntasEtapa__c
     * @params   proceso - Proceso de la etapa a crear
     *           developerN - nombre único de la etapa
     * @return   return registro MX_WB_preguntasEtapa__c
     */
    public static MX_WB_preguntasEtapa__c createPreguntasEtapa(String name, String proceso, String developerN) {
        final MX_WB_preguntasEtapa__c pregunta =  new MX_WB_preguntasEtapa__c();
        pregunta.Name = name;
        pregunta.MX_WB_proceso__c = proceso;
        pregunta.MX_WB_developerNameRT__c = developerN;
        return pregunta;
    }

    /**
    * @Method createCampania
    * @Description method que retorna un objeto campaign
    * @param String Name
    * @return Objeto de campaign
    **/
    public static campaign createCampania(String Name) {
        final campaign campana                  = new campaign();
        campana.IsActive                  = true;
        campana.Name                      = Name;
        campana.StartDate                 = system.date.Today();
        campana.EndDate                   = system.date.Today();
        campana.Type                      = 'Outbound';
        campana.Status                    = 'Activa';
        return campana;
    }

    /**
    * @Method:      Prospecto
    * @Description: method que retorna un objeto Lead
    **/
    public static Lead createLead(String lastName) {
        final Lead prospecto                  = new Lead();
        prospecto.LastName              =   lastName;
        return prospecto;
    }

    /**
    * @Method:      CampaignMember
    * @Description: method que retorna un objeto CampaignMember
    **/
    public static CampaignMember createCampaignMember(Id idLead, Id idCampaignId) {
        final CampaignMember objCampaignMember   = new CampaignMember();
        objCampaignMember.Status           = 'Enviado';
        objCampaignMember.CampaignId       = idCampaignId;
        objCampaignMember.LeadId           = idLead;
        return objCampaignMember;
    }

    /**
     * createOppChkLst Crea un registro Opportunity_CheckList__c
     * @params   masterId - Id del Master_Checklist__c relacionado
     *           userId - Id del usuario que crea el registro
     *           OppId - Id del producto relacionado
     *           valor - Boolean para marcar respuesta
     * @return   return registro Opportunity_CheckList__c
     */
    public static Opportunity_CheckList__c createOppChkLst (Id masterId, Id userId, Id OppId, Boolean valor) {
        final Opportunity_CheckList__c oppChkLst = new Opportunity_CheckList__c();
        oppChkLst.MX_WB_MasterChecklistId__c = masterId;
        //oppChkLst.CreatedById = userId;
        oppChkLst.MX_WB_OpportunityId__c = OppId;
        oppChkLst.MX_WB_Valor__c = valor;
        return oppChkLst;
    }

     /**
     * createProcNotiOppNoAten Crea un registro ProcNotiOppNoAten__c
     * @params   Proceso - Es el flujo por el cual se ejecutará
     *           Minutos - Tiempo en el que se ejecutará el proceso
     *           Horario - Es el turno en el que se ejecutará el proceso
     *           Activo - true si se quiere activar el proceso programado
     * @return   return registro ProcNotiOppNoAten__c
     */
    public static ProcNotiOppNoAten__c createProcNotiOppNoAten (String sProceso, String sMinutos, String sHorario, Boolean bActivo) {
        final ProcNotiOppNoAten__c objProNotiOppAten = new ProcNotiOppNoAten__c();
        objProNotiOppAten.Horario__c = sHorario;
        objProNotiOppAten.Minutos__c = sMinutos;
        objProNotiOppAten.Activo__c = bActivo;
        objProNotiOppAten.Proceso__c = sProceso;
        return objProNotiOppAten;
    }
    /**
    * Create Provedor
    * @Params   Nametxt -Nombre del provedor
    * @return   return registro MX_SB_VTS_ProveedoresCTI__c
    */
    public static MX_SB_VTS_ProveedoresCTI__c ProvedorCTI(String Nametxt) {
        final MX_SB_VTS_ProveedoresCTI__c provedor = new MX_SB_VTS_ProveedoresCTI__c ();
        provedor.name =Nametxt;
        return provedor;
    }
    /**
    * Create FamilyProductProvedor
    * @Params   IDFamilia  - Id de la familia a asociar
    *           IDProvedor - Id del provedor a asociar
    * @return   return registro familyProductPrverdor
    */
    public static MX_SB_VTS_FamliaProveedores__c FamiliaProvedores(String IDFamilia, String IDProvedor) {
        final MX_SB_VTS_FamliaProveedores__c Familia = new MX_SB_VTS_FamliaProveedores__c();
        Familia.MX_SB_VTS_Familia_de_productos__c = IDFamilia;
        Familia.MX_SB_VTS_ProveedorCTI__c = IDProvedor;
        return Familia;
    }
    /**
    * Create MX_SB_VTS_Generica__c
    * @Params   IDFamilia  - Id de la familia a asociar
    *           IDProvedor - Id del provedor a asociar
    * @return   return registro familyProductPrverdor
    */
    public static MX_SB_VTS_Generica__c GeneraGenerica(String txtName, String TxtType) {
        final MX_SB_VTS_Generica__c GeneraGen = new MX_SB_VTS_Generica__c();
        GeneraGen.Name = txtName;
        GeneraGen.MX_SB_VTS_Type__c = TxtType;
        return GeneraGen;
    }
    /**
    * Create MX_SB_VTS_Generica__c
    * @Params   IDFamilia  - Id de la familia a asociar
    *           IDProvedor - Id del provedor a asociar
    * @return   return registro familyProductPrverdor
    */
    public static MX_SB_VTS_FamliaProveedores__c GeneraFamiliaProvedor(String txtName,string IDFamilia, String IDProvedor) {
        final MX_SB_VTS_FamliaProveedores__c familiaprovedor = new MX_SB_VTS_FamliaProveedores__c();
        familiaprovedor.Name=txtName;
        familiaprovedor.MX_SB_VTS_ProveedorCTI__c=IDProvedor;
        familiaprovedor.MX_SB_VTS_Familia_de_productos__c=IDFamilia;
        return familiaprovedor;
    }


    /*
    * Create Quote
    * @Params oppId - Opportunity Id
              quoteName
    *         folioCotizacion - Quote number provided from external app
    * @return return quoteTest
    */
    public static Quote crearQuote(Id oppId, String quoteName, String folioCotizacion) {
        final Quote quoteTest = new Quote();
        quoteTest.OpportunityId = oppId;
        quoteTest.Name = quoteName;
        quoteTest.MX_SB_VTS_Folio_Cotizacion__c = folioCotizacion;
        return quoteTest;
    }

    /**
    * @Method crearAsignacion
    * @Description method que crea y retorna un objeto de Asignación
    * @param String strName
    * @param Id idAccount
    * @return Objeto Entitlement
    **/
    public static Entitlement crearAsignacion(String strName, Id idAccount) {
        final Entitlement objEntitlement = new Entitlement();
        objEntitlement.Name  = strName;
        objEntitlement.AccountId = idAccount;
        return objEntitlement;
    }

    /**
    * @Method createCase
    * @Description method que crea y retorna un objeto de Caso
    * @param String estado
    * @param Id idOpp
    * @return Objeto Case
    **/
    public static Case createCase(Id idOpp, String estado) {
        final Case caso = new Case();
        caso.Poliza__c = idOpp;
        caso.Status = estado;
        return caso;
    }
    /*
    * @Method vtsTestLead
    * @Description method to create lead for new business process
    * @param String name, String recordTypeName
    * @return Object Lead
    */
    public static Lead vtsTestLead(String name, String recordTypeName) {
        final Lead testLead = new Lead();
        testLead.LastName = name;
        testLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
        return testLead;
    }

    /**
    @Method: vtsCreateContract
    @Description: generates a test contract
    @Param: Account Id, Owner Id, Product Id
    @return returns contract object
    */
    public static Contract vtsCreateContract(Id accId, Id owId, Id pId) {
        final Contract testContract = new Contract();
        testContract.StartDate = System.today();
        testContract.AccountId = accId;
        testContract.OwnerId = owId;
        testContract.MX_WB_Producto__c = pId;
        return testContract;
    }
    /*
    * Creates task
    */
    public static task crearTarea(String wId,String strSubject) {
        final task objTask = new Task(
        ActivityDate = Date.today().addDays(2),
        Description = 'Test description',
        FechaHoraReagenda__c  =  Date.today().addDays(5),
        Subject = strSubject);
        if(wId.startsWith('006')) {
            objTask.WhatId = wId;
        } else if(wId.startsWith('00Q')) {
            objTask.WhoId = wId;
        }
        return objTask;

    }
    /*
    * Creates Lead tray
    */
    public static MX_SB_VTS_Lead_tray__c crearBandeja(String tBandeja,String idBandeja) {
        final MX_SB_VTS_Lead_tray__c bandeja = new MX_SB_VTS_Lead_tray__c();
        bandeja.MX_SB_VTS_Tipo_Bandeja__c = tBandeja;
        bandeja.MX_SB_VTS_ID_Bandeja__c = idBandeja;

        return bandeja;
    }
    /**Crea una tarea con su descripcion, tipo de registro, estado y asignada a un registro */
    public static Task crearTarea(String whatId, String whoId, String developerName, String descrip, String status) {
        final Id idTask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get(developerName).getRecordTypeId();
        final Task tarea = new Task();
            tarea.Description = descrip;
            tarea.WhoId = whoId;
            tarea.WhatId = whatId;
            tarea.RecordTypeId = idTask;
            tarea.Status = status;
            tarea.Subject = descrip;
        return tarea;
    }
    /** Crea Proveedor */
    Public static  MX_SB_VTS_ProveedoresCTI__c crearProveedor(String name) {
        final MX_SB_VTS_ProveedoresCTI__c proveedor = new MX_SB_VTS_ProveedoresCTI__c();
        proveedor.Name = name;
        return proveedor;
    }
    
     /** Crea Producto */
    Public static  Product2 crearProducto(String name,String family) {
         Product2 prod = new Product2(
          Name = name, 
          Family = family);
        return prod;
    }
      
        
    
    
}