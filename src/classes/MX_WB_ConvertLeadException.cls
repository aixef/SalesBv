/**-------------------------------------------------------------------------
* Nombre: MX_WB_ConvertLeadException
* Autor Alexis Pérez
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Custom exception for lead convert.

* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Desripción<p />
* -------------------------------------------------------------------
* 1.0           16/01/2019      Alexis Pérez		   	Creación
* --------------------------------------------------------------------------
*/
public class MX_WB_ConvertLeadException extends Exception {
    
    /**
     * Exception message.
     */
    public String message {get; set;}
    
    /**
     * Number Line Exception
     */
    public Integer line {get; set;}
    
    /**
     * Assign the class properties.
     * @param String Message, Integer Line
     */
    public MX_WB_ConvertLeadException(String message, Integer line) {
        this.message = message;
        this.line = line;
    }
}