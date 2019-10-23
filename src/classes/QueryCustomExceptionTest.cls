/**-------------------------------------------------------------------------
 * Nombre: QueryCustomExceptionTest
 * Autor Ing. Karen Sanchez
 * Proyecto: MX SB SAC - BBVA Bancomer
 * --------------------------------------------------------------------------
 * Versión      Fecha           Autor                   Descripción
 * -------------------------------------------------------------------
 * 1.0          19/06/2019      Ing. Karen Sanchez      Modificación: Se cambia el objeto de Opp por Contratos
 * --------------------------------------------------------------------------
 */
@isTest
public with sharing class QueryCustomExceptionTest  {

    /**
    * Recupera mensaje
    */
	@isTest
    public static void message() {
        final QueryCustomException queryCustom = new QueryCustomException('Message','cause','100',1); 
        System.assertEquals('Message', queryCustom.returnMessage(), 'Recuperar Mensaje');
    }

    /**
    * Recupera mensaje de error
    */
    @isTest
    public static void code() {
        final QueryCustomException queryCustom = new QueryCustomException('Message','cause','100',1); 
        System.assertEquals('100', queryCustom.returnCode(), 'Recuperar codigo de error');
    }

    /**
    * Recupera mensaje de causa
    */
    @isTest
    public static void cause() {
        final QueryCustomException queryCustom = new QueryCustomException('Message','cause','100',1); 
        System.assertEquals('cause', queryCustom.returnCause(), 'Recuperar causa');
    }

    /**
    * Mensaje Recuperar Linea de Error
    */
    @isTest
    public static void lineError() {
        final QueryCustomException queryCustom = new QueryCustomException('Message','cause','100',1); 
        System.assertEquals(1, queryCustom.returnlineError(), 'Recuperar Linea de Error');
    }			
}