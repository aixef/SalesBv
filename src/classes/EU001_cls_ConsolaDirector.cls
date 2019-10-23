/**
*Desarrollado por:       Indra
*Autor:                  Javier Ortiz
*Proyecto:               Experiencia Unica
*Descripción:            Clase Test para la clase EU001_cls_ConsolaDirector
*
*Cambios (Versiones)        prueba
*-------------------------------------------------------------------------------
*No.         Fecha            Autor                           Descripción
*------   ----------------   --------------------   ----------------------------
*1.0      14-12-2017         Javier Ortiz                Creación
*2.0      01-02-2018         Isaías Velázquez            Modificación
*3.0      07-02-2018         Isaías Velázquez            Modificación
*3.0      08-02-2018         Francisco J Licona          Modificación
*3.1      07-03-2018         Isaías Velázquez            Modificación
*3.2      06-03-2018         Francisco J Licona          Modificación
*3.3      07-02-2018         Isaías Velázquez            Modificación
*3.4      09-02-2018         Francisco J Licona          Modificación
*3.5      27-03-2018         Francisco J Licona          Modificación de parametro para directores Regionales
*4.0      04-04-2018         Francisco J Licona          Modificación de equipos director para graficos dor y gana mas, incidencia
*4.1      04-04-2018         Francisco J Licona          Modificación de llenado de lista de ranking valoración equipo listado, incidencia
*4.2      04-04-2018         Francisco J Licona          Modificación de consulta tab experiencia única, tab equipo, incidencia
*5.0      06-04-2018         Javier Ortiz F              Se agregan funciones para consultar el tablero en vez de realizar el calculo
                                                         por ejecutivo para directores para evitar 101 SOQL Queries
*5.1      06-04-2018         Javier Ortiz F              Se modifica función que extrae logros para correcta asignación al equipo un nivel abajo
*5.2      06-04-2018         Javier Ortiz F              Se crean funciones para extraer el equipo un nivel abajo sin y con director dueño de la RI
*5.3      06-04-2018         Francisco J Licona          Se realiza modificación para la gráfica de PI en compromisos priorizados
*5.4      06-04-2018         Francisco J Licona          Se realiza modificación para la lista de ejecutivos ranking valoración
*5.5      06-04-2018         Francisco J Licona          Se agrega validación para gráfica gana más en jerarquía DD
*6.0      09-04-2018         Francisco J Licona          Se agrega validación en graficos EQUIPOS y apoyos NIVEL SUPERIOR de no
                                                         incluir a los gerentes de oficina a nivel perfil
*6.1      09-04-2018         Francisco J Licona          Se modifica la logica de Rankign Valoración para no repetir nombres con el loop de usuarios.
*7.0      13-04-2018         Francisco J Licona          Se modifica graficas de Indicadores DOR y puntos maximos
*8.0      20-04-2018         Francisco J Licona          Se modifica logica de tablas CRM para mostrar planes de choque sin gestión y totales
*8.1      20-04-2018         Javier Ortiz F.             Se elimina Id en duro, se utiliza utilidad de tipos de registro, se elimina N/A para
                                                         los casos de 1 único agrupador
*9.0      08/08/2018         Francisco J Licona          Se adiciona funcionalidad que evalua si la nueva funcionalidad de RI para PI10 esta activa,
                                                         por división para liberación parcial.
*10.0     13/08/2018         Luis Fernando Romero        Se agrega parametro de indicador a búsqueda de compromisos, se agrega filtro en consulta
                                                         de impacto en los compromisos
*10.1     06/11/2018         Cristian Espinosa           Método getTeamDirector y getTeamDirectorDO, se agrega condición
                                                         para que no muestre los usuarios con UG vacia.
*10.2     07-11-2018         César Villanueva            Se agrega método para la actualización de trackings del usuario logueado
*10.3	  30-01-2019		 Mario Calderón				 Se agregan parámetros al método "getTableCompromisos" para añadir búsqueda de campos a query dinámico.
*10.4     23-05-2019         Cindy Hernández             Resolución de code smells detectados por sonar.
*10.5     28-05-2019		 Cindy Hernández             Recorte de las referencias al objeto GF001_Parametria__c.
*10.5     12-06-2019		 Cindy Hernández             La clase se descompuso en las clases MX_BPP_RI_ListaCompromisos_Ctrl,
                                                         EU001_graficasConParametros_Ctrl, EU001_modApoyos_Ctrl, EU001_VistaApoyos_Ctrl y
                                                        MX_BPP_VistaRI_Ctrl para que actualizaciones futuras sean más fáciles de realizar.
**/

public With Sharing class EU001_cls_ConsolaDirector {

    //Constructor with no arguments
    @TestVisible
    private EU001_cls_ConsolaDirector() {
    }

    /*@Descripción
    *Se modificó metodo verificaStaff, para filtrar roles de directores de BPyP, ya que de momento no se tiene RI para directores de BPyP
    *04-13-2018
    *Ricardo Almanza Angeles */
    @AuraEnabled
    public static Boolean verificaStaff() {
        Boolean esStaff = false;
        try {
            final User verificaUsuario = [SELECT userRoleId FROM User WHERE Id =: userInfo.getUserId() LIMIT 1];
            final userRole roleVerificar = [SELECT Id FROM userRole WHERE Name =: EU001_cls_CONSTANTES.EU001_STR_FUNCION_STAFFCENTRAL LIMIT 1];
            if(verificaUsuario.userRoleId == roleVerificar.Id || [Select Id, Name, DeveloperName from UserRole where Id=:verificaUsuario.userRoleId].DeveloperName.containsIgnoreCase('BPYP_DIRECTOR')) {
                esStaff = true;
            }
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return esStaff;
    }

    /*@Descripcion
    *Trae la lista de RI's Inicio.
    *Francisco J Licona Rodriguez
    *-------------------------------------------------------------
    *@Return Lista WRP RI's
    */
    @AuraEnabled public static list<WRP_Table> getRI() {
        final Boolean verificaStaff = verificaStaff();
        Boolean director = true;
        final Set<Id> usersDown = new Set<Id>();
        final Set<Id> RISet = new Set<Id>();
        final List<Id> RIList = new List<Id>();
        map<Id, WRP_Table> mapRIS = new map<Id, WRP_Table>();
        map<Id, User> mapUsers = new map<Id, User>();
        try {
            final List<UserRole>roleDown = ([SELECT Name, Id, ParentRoleId FROM UserRole WHERE ParentRoleId =:  UserInfo.getUserRoleId()]);
            if(roleDown.isEmpty()) {
                    director = false;
                    RISet.add(userInfo.getUserId());
            } else if(!roleDown.isEmpty()) {
                for(UserRole IteraUrole : roleDown) {
                    usersDown.add(IteraURole.Id);
                }
                for(User IteraUsuarios : [Select Id, Name, UserRoleId from User where UserRoleId IN: usersDown AND isActive=:true]) {
                    RISet.add(IteraUsuarios.Id);
                }
            }
            RIList.addAll(RISet);
            mapRIS = getRIMap(director, verificaStaff, RIList);
            final map<Id, User> mapUsersQuery = new map<Id, User>([SELECT Id, Liga__c, Name, UG__c FROM User WHERE Id IN: mapRIS.keySet()]);
            mapUsers = mapUsersQuery;
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        for(WRP_Table tmp : mapRIS.values()) {
            mapRIS.get(tmp.Acc.Id).Acc = mapUsers.get(tmp.Acc.Id);
        }
        return mapRIS.values();
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          13-06-2019
* @Description  Get RI map.
* @Comments     Created from the clipped code block of method getRI.
* @param        Boolean director, Boolean verificaStaff, List<Id> RILis
* @return       Map<Id, WRP_Table>
* @example      public static Map<Id, WRP_Table> getRIMap(Boolean director, Boolean verificaStaff, List<Id> RIList) {
**/
    public static Map<Id, WRP_Table> getRIMap(Boolean director, Boolean verificaStaff, List<Id> RIList) {
        final Map<Id, WRP_Table> mapRIS = new map<Id, WRP_Table>();
        if(director) {
            if(verificaStaff) {
                for(EU001_RI__c  getRI :[SELECT OwnerId, Name, Id, EU001_tx_Estado__c, EU001_ft_Fecha_Inicio__c, EU001_ft_Fecha_Cierre__c, EU001_fm_UG_Propietario__c FROM EU001_RI__c WHERE (ownerid =: RIList AND (EU001_tx_Estado__c = 'Presentación' OR EU001_tx_Estado__c = 'Evaluacion' OR EU001_tx_Estado__c = 'Finalizacion'))]) {
                    if(mapRIS.containsKey(getRI.OwnerId)) {
                        mapRIS.get(getRI.OwnerId).lsOpp.add(getRI);
                    } else {
                        mapRIS.put(getRI.OwnerId, new WRP_Table(new User(Id = getRI.OwnerId, UG__c = getRI.EU001_fm_UG_Propietario__c), new list<EU001_RI__c>{getRI}));
                    }
                }
            } else {
                for(EU001_RI__c  getRI :[SELECT OwnerId, Name, Id, EU001_tx_Estado__c, EU001_ft_Fecha_Inicio__c, EU001_ft_Fecha_Cierre__c, EU001_fm_UG_Propietario__c FROM EU001_RI__c WHERE (ownerid =: RIList AND (EU001_tx_Estado__c = 'Presentación' OR EU001_tx_Estado__c = 'Evaluacion' OR EU001_tx_Estado__c = 'Finalizacion')) OR ownerid =: userInfo.getUserId()]) {
                    if(mapRIS.containsKey(getRI.OwnerId)) {
                        mapRIS.get(getRI.OwnerId).lsOpp.add(getRI);
                    } else {
                        mapRIS.put(getRI.OwnerId, new WRP_Table(new User(Id = getRI.OwnerId, UG__c = getRI.EU001_fm_UG_Propietario__c), new list<EU001_RI__c>{getRI}));
                    }
                }
            }
        } else {
                for(EU001_RI__c  getRI :[SELECT OwnerId, Name, Id, EU001_tx_Estado__c, EU001_ft_Fecha_Inicio__c, EU001_ft_Fecha_Cierre__c, EU001_fm_UG_Propietario__c FROM EU001_RI__c WHERE ownerid =: RIList or ownerid =: userInfo.getUserId()]) {
                    if(mapRIS.containsKey(getRI.OwnerId)) {
                        mapRIS.get(getRI.OwnerId).lsOpp.add(getRI);
                    } else {
                        mapRIS.put(getRI.OwnerId, new WRP_Table(new User(Id = getRI.OwnerId, UG__c = getRI.EU001_fm_UG_Propietario__c), new list<EU001_RI__c>{getRI}));
                    }
                }
            }
        return mapRIS;
    }
    /**Método getRISelect */
    @AuraEnabled public static String getRISelect(String IdRI) {
        EU001_RI__c RISeleccionada = new EU001_RI__c();
        String ownerUG = '';
        try {
            RISeleccionada = [SELECT Id, OwnerId FROM EU001_RI__c WHERE Id =: IdRI LIMIT 1];
            ownerUG = [SELECT UG__c FROM User WHERE id =: RISeleccionada.OwnerId][0].UG__c;
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return ownerUG;
    }
    /**Método getUser */
    @AuraEnabled public static List<EU001_RI__c> getUser(String recordId) {
        List<EU001_RI__c> lista = new List<EU001_RI__c>();
        try {
            lista = [Select Id, CreatedBy.Name, OwnerId, Owner.Name,Name, EG_001_ls_Valoracion_de_RI__c, EG001_Valoracion_de_RI_DO__c, EU001_tx_Estado__c, EU001_tl_Comentario_EV__c, EU001_tl_Comentario_DO__c  from EU001_RI__c where id =: recordId limit 1];
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return lista;
    }
/**
*@
*Clase WRP_Table
 */
    public class WRP_Table {
        /** */
        @AuraEnabled public User Acc {get; set;}
        /** */
        @AuraEnabled public list<EU001_RI__c> lsOpp {get; set;}
        /** */
        @AuraEnabled public Boolean expanded {get; set;}
        /** */
        public WRP_Table(User toAcc, list<EU001_RI__c> toOpp) {
            this.Acc = toAcc;
            this.lsOpp = toOpp;
            this.expanded = false;
        }
    }

    /*@Descripcion
    *Genera un nuevo registro de EU001_RI__c.
    *-------------------------------------------------------------
    *@Return Id del registro creado
    */

    @AuraEnabled
    public static String generaNuevoRI() {
        String resultado = '';

        try {
            final EU001_RI__c nuevoRi01 = new EU001_RI__c();
            insert nuevoRi01;

            final EU001_RI__c nuevoRi02 = [SELECT Name FROM EU001_RI__c WHERE ID=:nuevoRi01.Id];
            resultado = nuevoRi01.Id+';'+nuevoRi02.Name;
        } catch (DmlException e) {
            final String message = e.getMessage();
            resultado = 'Error: ' + message.substring(88);
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }

        return resultado;
    }

    @AuraEnabled
    /**Creacion de metodo VerificaDirector */
    public static Boolean VerificaDirector() {
        Boolean temp = false;
        List<UserRole> NivelAbajoFuncion = new List<UserRole>();
        try {
            final List<User> funcionDelUsuario = ([SELECT Id, Name, UserRoleId FROM User WHERE Id =: userInfo.getUserId() LIMIT 1]);
            NivelAbajoFuncion = [SELECT Name, Id, ParentRoleId FROM UserRole WHERE ParentRoleId =: funcionDelUsuario[0].UserRoleId];
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
         if(!NivelAbajoFuncion.isEmpty()) {
            temp = true;
        }
        return temp;
    }
}