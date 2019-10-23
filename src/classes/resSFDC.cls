/**-------------------------------------------------------------------------
* Nombre: resSFDC
* @author Julio Medellin
* Proyecto: MW SB VTS - BBVA 
* Descripción : Clase wrapper para respuesta de petición Rest

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Descripción
* -------------------------------------------------------------------
* @version 1.0           02/05/2019      Julio Medellin           Clase de respuesta RESt
* --------------------------------------------------------------------------*/
    global class resSFDC { //NOSONAR
        /* llamada de respuesta a variable error del servicio REST*/
        global String error { get; set; }
        /* llamada de respuesta a variable message del servicio REST*/
        global String message { get; set; }
        /* llamada de respuesta variable id del servicio REST*/
        global String id { get; set; }
    }