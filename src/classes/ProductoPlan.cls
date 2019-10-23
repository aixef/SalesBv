/**
 * @File Name          : ProductoPlan.cls
 * @Description        : Clase wrapper para atributo enviado por Aplicativos web
 * @Author             : Eduardo Hernández Cuamatzi
 * @Group              : BBVA
 * @Last Modified By   : Eduardo Hernández Cuamatzi
 * @Last Modified On   : 21/5/2019 10:09:50
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    21/5/2019 10:08:55   Eduardo Hernández Cuamatzi     Initial Version
**/
global class ProductoPlan {
    /*Variable de respuesta codigoProducto alservicio REST */
    global String codigoProducto {get;set;}
    /*Variable de respuesta codigoPlan alservicio REST */
    global String codigoPlan {get;set;}
    /*Variable de respuesta revisionPlan alservicio REST */
    global String revisionPlan {get;set;}
    /*Variable de respuesta codigoRamo alservicio REST */
    global String codigoRamo {get;set;}
}