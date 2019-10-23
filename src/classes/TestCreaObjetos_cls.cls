/**
 * Clase que se usa de utilerias.
 *
 */
@isTest
public with sharing class TestCreaObjetos_cls {
  /** Fecha para pruebas. */
  public static final DateTime FECHAPRUEBA = DateTime.now();
  /** Nombre para pruebas. */
  public static final String NAMEPRUEBA = 'UserPrueba' + FECHAPRUEBA;
  /** Numero para pruebas. */
  static final String NUMEROPRUEBA = '3007676475';


    /**
    * Metodo que crea registro de cliente
    *
    * @param  numero de cliente y strRT
    * @return registro de cliente
    */
    public static List<Account> creaClienteC(Integer noCliente, String strRT) {

        //La lista para los Cliente
        final List<Account> lCliente = new List<Account>();

        //Crea los Account
        for (Integer cnt=0; cnt < noCliente; cnt++) {

            final String sClaveDistPaso = String.valueOf(Math.random());
            //final String sClaveDist = sClaveDistPaso.substring(10);
            final String sNumeroCte = sClaveDistPaso.substring(10);

            final Account cliente = new Account();
            cliente.AccountNumber = sNumeroCte;
            //Cliente.RecordTypeId = strRT;
            cliente.FirstName = 'Jeisson';
            cliente.LastName = 'Rojas';
            cliente.PersonEmail  = 'jroja'+ sNumeroCte +'@mail.com';
            cliente.RFC__c = '000000000005';
            cliente.PersonMobilePhone = NUMEROPRUEBA;
            cliente.PersonHomePhone = NUMEROPRUEBA;
            cliente.PersonOtherPhone = NUMEROPRUEBA;
            cliente.Phone = NUMEROPRUEBA;

            //Insertalo en Cliente
            lCliente.add(cliente);
        }

        //Inserta los registros
        insert lCliente;

        //Regresa la lista de lCliente
        return lCliente;

    }

    /**
    * Metodo que crear registro de case
    *
    * @param  numero de oportunidad y id de cliente
    * @return registro de case
    */
    public static List<Case> creaOppVta (Integer noOppVta, String iIdCte) {
        //La lista para los Case
        final List<Case> lOppVta = new List<Case>();

        //Crea los Case
        for (Integer cnt=0; cnt < noOppVta; cnt++) {
            final Case oppVta = new Case();

            oppVta.Status = 'New';
            oppVta.Origin = 'Phone';
            oppVta.Priority = 'Medium';
            oppVta.AccountId = iIdCte == null ? null  : iIdCte;

            //Insertalo en lOppVta
            lOppVta.add(oppVta);
        }//Fin del for para los noOppVta

        //Inserta los registros
        insert lOppVta;

        //Regresa la lista de OppVta
        return lOppVta;
    }

    /**
    * Metodo para registro de tarea
    *
    * @param  numero de tarea, id de caso, y subject
    * @return registro de tarea
    */
    public static List<Task > creaTarea (Integer noTarea, String sIdCaso, String sSubject) {
        //La lista para los Task
        final List<Task > lTarea = new List<Task>();

        //Crea los Task
        for (Integer cnt=0; cnt < noTarea; cnt++) {
            final Task tarea = new Task();
            tarea.Description = 'Call';
            tarea.Priority = 'Normal';
            tarea.Status = 'No Iniciado';
            tarea.Subject = sSubject;
            tarea.IsReminderSet = false;
            tarea.WhatId = sIdCaso;

            //Insertalo en lTarea
            lTarea.add(tarea);
        }//Fin del for para los noTarea

        //Inserta los registros
        insert lTarea;

        //Regresa la lista de Tarea
        return lTarea;
    }

    /**Genera los objetos para levantar los procesos de notificación ProcNotiOppNoAten__c*/
    public static List<ProcNotiOppNoAten__c> lvtaProcNoti(String sHorario, String sMinutos) {
        //La lista para los ProcNotiOppNoAten__c
        final List<ProcNotiOppNoAten__c> lProcNoti = new List<ProcNotiOppNoAten__c>();

        //Crea los ProcNotiOppNoAten__c
        final ProcNotiOppNoAten__c procNoti = new ProcNotiOppNoAten__c();
        procNoti.Horario__c = sHorario;
        procNoti.Minutos__c = sMinutos;
        procNoti.Activo__c = false;

        //Insertalo en lProcNoti
        lProcNoti.add(procNoti);

        //Inserta los registros
        insert lProcNoti;

        //Regresa la lista de ProcNoti
        return lProcNoti;
    }

	/**
    * Metodo que crea registro de oportunidad
    *
    * @param  numero de oportunidad, id de cuenta y id recort type
    * @return registro de oportunidad.
    */
	public static List<Opportunity> creaOportunidad(Integer noOportunidad, String sIdAccount, String sIdRt,
		String sEstatus) {
       	System.debug('ENTRO A CreaOportunidad...');

        final String sClaveDistPaso = String.valueOf(Math.random());
        final String sNoPoliza = sClaveDistPaso.substring(0, 10).replace('.', '0');
       	System.debug('ENTRO A CreaOportunidad sNoPoliza: ' + sNoPoliza);

		Id sIdPriceBookEntry;

		//La lista para los Opportunity
		final List<Opportunity> lOportunidad = new List<Opportunity >();

		//Llenar mapa con Id Nombre para asignar los campos Name o FirstName y LastName
		for(Pricebook2 pbl : [select id,Name,IsStandard from Pricebook2 where isStandard=true limit 1]) {
			sIdPriceBookEntry = pbl.id;
		}//Fin del for para las listas de precios
       	System.debug('EN CreaOportunidad sIdPriceBookEntry: ' + sIdPriceBookEntry);
       	final Pricebook2  objPricebook2= new Pricebook2();
     	objPricebook2.Name='Standard Price Book1';
     	objPricebook2.IsActive=true;
     	insert objPricebook2;
		//Crea los RD_Bonos__c
		for (Integer cnt = 0; cnt < noOportunidad; cnt++) {
			final Opportunity  oportunidad = new Opportunity ();
			oportunidad.Name = NAMEPRUEBA;
			oportunidad.AccountId  = sIdAccount == null ? null : sIdAccount;
			oportunidad.Pricebook2Id = sIdPriceBookEntry == null ? null : sIdPriceBookEntry;
			oportunidad.CloseDate = Date.today();
			oportunidad.StageName = 'Prospección';
			oportunidad.RecordTypeId = sIdRt == null ? null : sIdRt;
			oportunidad.Estatus__c = sEstatus; //'Emitida'
			oportunidad.NumerodePoliza__c = sNoPoliza;
			oportunidad.FolioCotizacion__c = sNoPoliza;
			oportunidad.CORREOELECTRONICOCONTRATANTE__c = 'prueba@hotmail.com';
			oportunidad.Banco__c = 'BANAMEX';
			oportunidad.Codigoverificadorcompra__c = '1234';
			//Oportunidad.RFC_Contratante__c = 'FIAH720811CH5';
			oportunidad.RFCcontratante__c  = 'FIAH720811CH5';

			//Insertalo en lOportunidad
			lOportunidad.add(oportunidad);

		}//Fin del for para los noRdBonos

		//Inserta los registros
		insert lOportunidad;

		//Regresa la lista de lOportunidad
		return lOportunidad;
	}

	/**
    * Metodo que crea catalogo de documentación
    *
    * @param  numero catalogo de documentación
    * @return registro de catalogo de documentación.
    */
	public static List<CatalogoDocumentacion__c> creaCatalogoDocumentacion(Integer noCatalogoDocumentacion) {
       	System.debug('ENTRO A CreaCatalogoDocumentacion...');

        final String sClaveDistPaso = String.valueOf(Math.random());
        final String sNoPoliza = sClaveDistPaso.substring(0, 10).replace('.', '0');
       	System.debug('ENTRO A CreaCatalogoDocumentacion sNoPoliza: ' + sNoPoliza);

		//La lista para los CatalogoDocumentacion__c
		final List<CatalogoDocumentacion__c> lCataDocu = new List<CatalogoDocumentacion__c >();

		//Crea los RD_Bonos__c
		for (Integer cnt = 0; cnt < noCatalogoDocumentacion; cnt++) {
			final CatalogoDocumentacion__c  catalogoDocu = new CatalogoDocumentacion__c ();
			catalogoDocu.Name = 'Bonificaciones-Cargos irregulares';
			catalogoDocu.Motivo__c  = 'Bonificaciones';
			catalogoDocu.Detalle__c = 'Cargos irregulares';
			catalogoDocu.Subdetalle__c = 'Otros bancos';
			catalogoDocu.Dias__c = 'Hábil';
			catalogoDocu.NS__c = '5';
			catalogoDocu.Documentacion__c = 'Carta, IFE y estado de cuenta';
			catalogoDocu.RequiereValTel__c = true;
			catalogoDocu.RequiereDocumentacion__c = true;
			catalogoDocu.Ejecutor__c = 'BO3';
			catalogoDocu.Aprobador__c = 'Iserma Hernández';
			catalogoDocu.ClienteCandidato__c = 'Cliente';

			//Insertalo en lCatalogoDocumentacion
			lCataDocu.add(catalogoDocu);

		}//Fin del for para los noRdBonos

		//Inserta los registros
		insert lCataDocu;

		//Regresa la lista de lCatalogoDocumentacion
		return lCataDocu;
	}

    /**
    * Metodo que crea encuesta
    *
    * @param  numero de encuesta MKT
    * @return registro de encuesta
    */
    public static List<EncuestaMKTSFDC__c> creaEncuestaMKTSFDC(Integer noEncuestaMKTSFDC , String sNumeroEncuestaMKT) {
        //La lista para los EncuestaMKTSFDC__c
        final List<EncuestaMKTSFDC__c> lEncuestaMKTSFDC = new List<EncuestaMKTSFDC__c>();

        //Crea los EncuestaMKTSFDC__c
        for (Integer cnt=0; cnt < noEncuestaMKTSFDC; cnt++) {
            final EncuestaMKTSFDC__c encuestaMKTSFDC = new EncuestaMKTSFDC__c();

            encuestaMKTSFDC.NumeroEncuestaMKT__c = sNumeroEncuestaMKT;
            encuestaMKTSFDC.TipoEncuesta__c = 'Atención';
            encuestaMKTSFDC.Pregunta1__c = '¿Qué tan probable es que recomiendes wibe a un familiar o amigo?';
            encuestaMKTSFDC.Respuesta1__c = '4';
            encuestaMKTSFDC.Pregunta2__c = '¿Cómo valoras el servicio de atención a clientes wibe?';
            encuestaMKTSFDC.Respuesta2__c = '5';

            //Insertalo en lEncuestaMKTSFDC
            lEncuestaMKTSFDC.add(encuestaMKTSFDC);
        }//Fin del for para los noEncuestaMKTSFDC

        //Inserta los registros
        insert lEncuestaMKTSFDC;

        //Regresa la lista de EncuestaMKTSFDC
        return lEncuestaMKTSFDC;
    }

    /**
    * Metodo que crea registro de bloque
    *
    * @param  numero de bloque
    * @return registro de boque
    */
    public static List<Bloque__c> creaBloque(Integer noBloque) {
        //La lista para los Bloque__c
        final List<Bloque__c> lBloque = new List<Bloque__c>();

        //Crea los Bloque__c
        for (Integer cnt=0; cnt < noBloque; cnt++) {
            final Bloque__c bloque = new Bloque__c();

            bloque.BloqueActivo__c = true;

            //Insertalo en lBloque
            lBloque.add(bloque);
        }//Fin del for para los noBloque

        //Inserta los registros
        insert lBloque;

        //Regresa la lista de Bloque
        return lBloque;
    }

    /**
    * Metodo que crea registro de pagos espejo
    *
    * @param  numero pagos espejo y id poliza
    * @return registro de pagos espejo
    */
    public static List<PagosEspejo__c> creaPagosEspejo(Integer noPagosEspejo , String sIdPoliza,
    	String sIdBloque, String sIdFactura) {
        //La lista para los PagosEspejo__c
        final List<PagosEspejo__c> lPagosEspejo = new List<PagosEspejo__c>();

        //Crea los PagosEspejo__c
        for (Integer cnt=0; cnt < noPagosEspejo; cnt++) {
            final PagosEspejo__c objPagosEspejo = new PagosEspejo__c();

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

            //Insertalo en lPagosEspejo
            lPagosEspejo.add(objPagosEspejo);
        }//Fin del for para los noPagosEspejo

        //Inserta los registros
        insert lPagosEspejo;

        //Regresa la lista de PagosEspejo
        return lPagosEspejo;
    }



}