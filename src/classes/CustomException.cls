/**-------------------------------------------------------------------------
* Nombre: CustomException
* @author Ing. Daniel Goncalves
* Proyecto: MW WB LG - BBVA Bancomer
* Descripción : Clase de Excepción Personalizada

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* --------------------------------------------------------------------------
* @version 1.0           06/12/2018      Ing. Daniel Goncalves   Creación
* --------------------------------------------------------------------------
*/
public class CustomException extends Exception {
/**
*mensaje para la excepcion
*/   
    final String message {get;set;}
/**
*motivo de la causa del error
*/    
    final String cause {get;set;}
/**
*codigo de error
*/    
    final String code {get;set;}
/**
*numero de linea del error
*/    
    final Integer lineError {get;set;}
/**
*constructor
*/    
	public CustomException(String message, String cause, String code, Integer lineError) {
        this.message = message;
        this.cause = cause;
        this.code = code;
		this.lineError = lineError;
	}

/**
*retorna el codigo de error
*/    
    public String returnCode() {
        return this.code;
    }

/**
*retorna el mensaje de error
*/    
    public String returnMessage() {
        return this.message;
    }
}