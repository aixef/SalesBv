/*
*
* @author Tania Vazquez
* @description Banquero Process
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    04/10/2019     Tania Vazquez     Create Account, Opportunities assignated to Banquero
*/
public without sharing class MX_SB_BCT_Ban_Convert_cls { //NOSONAR
    	/*Variable phone default*/
    	 public static final String PHONEVAR= '0000000000';
        /*Llamado a conf personalizada */
        public static final String IDBAN_DEFAUL =[SELECT Id, FederationIdentifier FROM User where FederationIdentifier=:MX_SB_VTS_Generica__c.getValues('MX_SB_BCT_user_Banquero').MX_SB_BCT_user_Banquero_Default__c limit 1].id;
        
        /*Recupera las cuentas del objeto Banquero y las coloca en un Set<String>
          Recupera los usuarios del objeto Banquero y las coloca en un Set<String>
        * @param List<Banquero__c banList: Lista de banqueros a insertar.
        * @param boolean des: Verdadero si es cliente false si es usuarios.*/
        public static  Set<String> getListDataInput (List<Banquero__c> banList, boolean desci) {
            final Set<String> xVar  = new Set<String>();
            for(Banquero__c banque: banList) {
                if(desci) {
                   xVar.add(banque.MX_SB_BCT_Id_Cliente__c); 
                } else {
                   xVar.add(banque.MX_SB_BCT_Id_Banquero__c);
                }
            }
            return xVar;
        }
        
        /*Recupera las cuentas existentes en SF del objeto Banquero y las coloca en un Set<String>
          Recupera los usuarios existentes en SF del objeto Banquero y las coloca en un Set<String>
        * @param Set<String> x: Lista de las cuentas/usuarios del objeto de Banquero (Resultado del method getListDataInput()).
        * @param String obj: Objeto sobe el cual se realizará la consulta.
        * @param String field: Campo del objeto que contiene el id externo de (Usuario/Cuentas).
        * @param String otherFields: Campos a consultar (Usuario/Cuentas).*/
        public static List<sObject> recoverData (Set<String> xSet, String objeto, String field, String otherFields) {
            return Database.query(string.escapeSingleQuotes('SELECT Id,' + field + otherFields+ ' FROM '+ objeto + ' WHERE ' + field + ' IN: xSet'));
        }
        
        /*Realiza la creación de un mapa que contiene la key (id externo) y el registro del objeto.
        * @param String field: Campo del objeto que contiene el id externo de (Usuario/Cuentas).
        * @param List<sObject> listX: Lista que contiene las cuentas/usuarios que existen en SF (Resultado del method recoverData()).*/
        public static Map<String,sObject> intoMap (String field,List<sObject> listX) {
            final Map<String, sObject> xMap = new Map<String,sObject>(); 
                for(sObject objX: listX) {
                    xMap.put((String)objX.get(field), objX);
                }
             return xMap;
         }
        
         /*Realiza la asignacion de los Ids de Sf de Cuentas y Usuarios en los campos correspondientes del Objeto de Banquero.
        * @param List<Banquero__c> banList:  Lista de banqueros a insertar.
        * @param Map<String, sObject> objX: Mapa que contiene el registro y la key (id externo) (Resultado del method IntoMap()).
        * @param String fieldBuscar: Campo que contiene el id externo del objeto.
        * @param String fieldAsignar:  Campo que contiene el id de SF que corresponde al Id externo del objeto.
        * @param Set<String> x: Lista de las cuentas/usuarios del objeto de Banquero (Resultado del method getListDataInput())*/
        public static Set<String> assignIdToBanquero (List<Banquero__c> banList, Map<String, sObject> objX, String fieldBuscar,String fieldAsignar, Set<String> xSet) {
            for(Banquero__c banque: banList) {
                if(objX.containsKey((String)banque.get(fieldBuscar)) == true) {
                    banque.put(fieldAsignar,(String)objX.get((String)banque.get(fieldBuscar)).Id);
                    xSet.remove((String)banque.get(fieldBuscar));            
                }
            }
           return xSet;
         }
       
        /*Realiza la busqueda de oportunidades relacionadas a las cuentas provenientes de banquero y las asignan al owner definido por banquero.
        * @param String x:  Id de la cuenta en SF.
        * @param String ownerIdUser: Id del User al que le pertenecerian las cuentas.*/ 
        public static List<Opportunity> searchToAssign(String strx, String ownerIdUser) {  
            String query;  
            query = 'Select Id, (select Id  from Contratos_TLMK__r), (select Id from Quotes) from Opportunity where AccountId =:strx';
            final List<Opportunity> listaX = Database.query(String.escapeSingleQuotes(query));
            final List<sObject> listaY = new List<sObject>();
             if(listaX.isEmpty() == false) {
                 for(Opportunity opptemp: listaX) {
                     opptemp.OwnerId=ownerIdUser;
                     listaY.add(opptemp);
                     for(SObject rel2: opptemp.Contratos_TLMK__r) {
                         rel2.put('OwnerId',ownerIdUser);
                         listaY.add(rel2);
                     }
                }
             }
            return listaY;
        }
        
         /*Realiza el llamado al method searchToAssign() por cada una de las cuentas que se encontraron el Salesforce
        * @param List<sObject> x:  Lista de Cuentas existentas encontradas en SF.*/ 
        public static void assignToBanquero(List<sObject> xList) {
             final List<sObject> updateObjTotal = new List<sObject> ();
             for(SObject t: xList) {
                 if(String.isNotEmpty((String)t.get('Id'))) {
                    final List<sObject> updateObj =searchToAssign((String)t.get('Id'),String.valueOf(t.get('OwnerId')));
                    if(updateObj.isEmpty() == false) {
                        updateObjTotal.addAll(updateObj);
                    }
                 }
               }
             update updateObjTotal;
        }
        
        /*Realiza la selección del owner correcto. 
        * @param String idUser:   Id del User recuperado de Banquero.*/ 
        public static String assignOwner(String idUser) {
           return String.isEmpty(idUser) ?  IDBAN_DEFAUL:idUser;   
           
        }
        
        /*Realiza la creación de una lista de cuentas a Insertar/Actualizar. 
        * @param String String idCliente:  Id Externo de la cuenta en Banaquero.
        * @param banquero__c  ban:  Lista de banqueros a insertar */ 
        public static Account createAccountToList(String idCliente, banquero__c  ban) {
            final String randomEmail = '.'+ Math.random()+'@example.com';
            return String.isEmpty(idCliente) ? new Account(LastName = ban.MX_SB_BCT_Id_Cliente__c , Phone = PHONEVAR, 
                                                              PersonEmail = ban.MX_SB_BCT_Id_Cliente__c + randomEmail, 
                                                              MX_SB_BCT_Es_Banquero_Contigo__c = true, 
                                                              MX_SB_BCT_Id_Cliente_Banquero__c = ban.MX_SB_BCT_Id_Cliente__c, 
                                                              OwnerID = ban.MX_SB_BCT_Banquero__c):
                                                new Account(Id =ban.MX_SB_BCT_Cliente__c, MX_SB_BCT_Es_Banquero_Contigo__c = true, 
                                                            OwnerID = ban.MX_SB_BCT_Banquero__c);   
            
        }
        
        /*Realiza El proceso completo de Banquero. 
         * Antes de la Inserción del Objeto de Banquero,
         * 	1. Obtiene los Id's Externos de las cuentas y los usuarios a insertar en Banquero.
         *  2. Recupera las cuentas y los usuarios existentes en SF.
         * 	3. Inserta los Id's Externos con key y los objetos de Cuentas y Usuarios como value en un mapa.
         *  4. Asigna los Id's encontrados en SF a el objeto Banquero
         *  5. Evalua el Owner que tendrán los objetos.
         *  6. Crea la cuenta a Insertar/Actualizar.
         *  7. REaliza el Upsert de Cuentas.
         *  8. Evalua los resultados de Ids de las cuentas
         *  9. Los asigna a el Banquero.
         * 10. Inserta los Banqueros.
        * @param String String idCliente:  Id Externo de la cuenta en Banaquero.
        * @param banquero__c  ban:  Lista de banqueros a insertar */ 
        public static void searchAccountBanquero (List<Banquero__c> banList) {
                final Set<String> clien  = getListDataInput(banList, true);
                final Set<String> banq  = getListDataInput(banList, false);
    
                final List<Account> banAccountsUpdate = recoverData(clien,'Account','MX_SB_BCT_Id_Cliente_Banquero__c',',OwnerId, MX_SB_BCT_Es_Banquero_Contigo__c');
                final List<User> banUsersUpdate = recoverData(banq,'User',label.MX_SB_BCT_Banquero_Id_Banquero_User,'');
         
                final Map<String, sObject> accMap = intoMap(label.MX_SB_BCT_Cliente_Id_Banquero_Account,banAccountsUpdate);
                final Map<String, sObject> userMap = intoMap(label.MX_SB_BCT_Banquero_Id_Banquero_User,banUsersUpdate);
    
                assignIdToBanquero(banList, accMap, label.MX_SB_BCT_Id_Cliente_Externo_Banquero,label.MX_SB_BCT_Id_Cliente_SF_Banquero, clien);
                assignIdToBanquero(banList, userMap, label.MX_SB_BCT_Id_User_Externo_Banquero,label.MX_SB_BCT_Id_User_SF_Banquero, banq);
            
                final List<Account> newAccListUp =new List<Account> ();
                for(Banquero__c banque: banList) {
                    banque.MX_SB_BCT_Banquero__c = assignOwner(banque.MX_SB_BCT_Banquero__c);
                    final Account tempAcc = createAccountToList(banque.MX_SB_BCT_Cliente__c, banque);
                    newAccListUp.add(tempAcc);
                }
                assignToBanquero(newAccListUp);
                integer cont = 0;
                for(Database.upsertResult result:Database.upsert(newAccListUp)) {
                    newAccListUp.get(cont).id = result.getId();
                    cont= cont + 1;
                }
                assignIdToBanquero(banList, intoMap(label.MX_SB_BCT_Cliente_Id_Banquero_Account,newAccListUp), label.MX_SB_BCT_Id_Cliente_Externo_Banquero,label.MX_SB_BCT_Id_Cliente_SF_Banquero, clien);
            } 
}