/**-------------------------------------------------------------------------
 * Nombre: QueryCustomException
 * Autor Ing. Eduardo Hernandez
 * Proyecto: MW WB LG - BBVA Bancomer
 * Descripción : Clase para Excepciones personalizadas
 * --------------------------------------------------------------------------
 * Versión      Fecha           Autor                   Desripción
 * -------------------------------------------------------------------
 * 1.0          26/11/2018      Ing. Eduardo Hernandez  Creacion
 * 1.1.1        07/01/2019      Ing. Eduardo Hernandez  Adecuaciones de Integración
 * --------------------------------------------------------------------------
 */
public class QueryCustomException extends Exception  {
    /**
     * Mensaje de error
     */
    public String message {get;set;}
    /**
     * Causa del error
     */
    public String cause {get;set;}
    /**
     * Codigo de error de la excepción
     */
    public String code {get;set;}
    /**
     * linea que provoca el error
     */
    public Integer lineError {get;set;}
    /**
     * QueryCustomException Constructor para instanciar excepcion personalizada
     */
    public QueryCustomException(String message, String cause, String code, Integer lineError)  {
        this.message = message;
        this.cause = cause;
        this.code = code;
        this.lineError = lineError;
    }
    /**
     * returnCode Recuperar codigo de error
     * @return   code
     */
    public String returnCode() {
        return this.code;
    }

    /**
     * returnMessage Recuperar mensaje
     * @return   message
     */
    public String returnMessage() {
        return this.message;
    }
    /**
     * returnCause Recuperar Causa
     * @return   cause
     */
    public String returnCause() {
        return this.cause;
    }
    /**
     * returnlineError Recuperar linea de error
     * @return   lineError
     */
    public Integer returnlineError() {
        return this.lineError;
    }
}