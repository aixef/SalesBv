/**Proyecto : Shield Platform Encryption
 * Autor	: Cristian Espinosa
 * Fecha	: 26/Enero/2018
 * Descripción : Clase creada para que active los checkbox de Contacto, creados para verificar
 * 			  	 que el contacto tiene telefono, nombre, etc (SHIELD). No se utilizan formulas
 * 				 debido a que Shield no lo permite.
 * ___________________________________________________________________________________________
 * Version		Fecha			Autor					Descripción
 * 1.1			26/01/2018		Cristian Espinosa		Release
 * 1.2			20/02/2018		Ricardo Hernandez		Validación con Plan de Cuenta
 * */
public class CheckContactField_cls {

    private CheckContactField_cls() {
    }

    /* @run time : beforeInsert, beforeUpdate
     * @params : newContact, oldContact, newMap, oldMap, mapRecordtypeContacts
     * @return : none
     */
    public static void checkContactFields(List<Contact> newContact, List<Contact> oldContact, map<Id, Contact> newMap, map<Id, Contact> oldMap, map<Id, RecordType> mapRecordtypeContacts) {
        for(Contact con : newContact) {
			//Activación del checkbox Phone
            if(con.Phone == null) {
                con.ca_tieneTelefono__c = false;
            }else {
               con.ca_tieneTelefono__c = true;
            }

            //Activación del checkbox Name
            if(con.Name == null) {
                con.ca_tieneNombre__c = false;
            }else {
                con.ca_tieneNombre__c = true;
            }

            //Activación del checkbox Email
            if(con.Email == null) {
                con.ca_tieneEmail__c = false;
            }else {
                con.ca_tieneEmail__c = true;
            }

        }
    }
}