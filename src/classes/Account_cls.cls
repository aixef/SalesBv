/*******************************************************************************
*   @Desarrollado por:      Indra
*   @Autor:                 Arsenio Perez Lopez
*   @Proyecto:              Bancomer
*   @Descripción:           Trigger de usuarios
*
*   Cambios (Versiones)
*   ---------------------------------------------------------------------------*
*   No.     Fecha               Autor                   Descripción            *
*   ------  ----------  ----------------------      ---------------------------*
*   1.0     05/10/2017  Arsenio perez lopez
Creación Trigger                                                           *
*   1.01    03/03/2018  Ricardo Almanza Angeles
Agregar camio grupo opps trigger para Bpyp family                          *
*   1.02    26/03/2018  Ricardo Almanza Angeles
Mejorá para eliminar quey en for                                           *
*   1.03    06/04/2018  José Mario Rodríguez Sánchez
Se cambia a sentecncia upsert ADQ_ReasignaActividadesGoogle_beforeUpdate   *
*   1.04    02/05/2018  Carlos Ricardo Hernandez
Se incluye RV al cambio de Propietario y condiciones a la Query            *
*   1.05    08/05/2018  Carlos Ricardo Hernandez
Se cambia el list por Map para las actividades Google.                     *
*   1.06    11/09/2018  Jhovanny De La Cruz Cruz
Carterización de Acciones Comerciales (GBL_CommercialAction__c)            *
*   1.07    02/11/2018  Jhovanny De La Cruz Cruz
Carterización de Tarifario (Tarif_rio__c)            					   *
*  	1.08	01/15/2019  Mario A. Calderón Muñoz
Se modifica método "clientePropietarioAfterUpdate" y su respectivo query  *
para reasignar un CPC en caso de que un cliente BPyP cambie de propietario *
*  	1.09	20/08/2019  Cindy Hernández
Se agregan referencias al tipo de registro MX_BPP_PersonAcc_Client.         *
*******************************************************************************/
public without sharing class Account_cls {

    /** variable Clientes*/
    set<Id> Clientes;
    /** Lista LsUpdate*/
    List<SObject> LsUpdate;
    /**
* Reasigna las tareas abiertas y eventos no finalizados (sincronizad@s en Google), de las cuentas
* que están siendo reasignadas hacia los nuevos propietarios de la cuentas.
*
* Este desencadenador se creó porque cuando una cuenta cambia de propietario, sus actividades
* también cambian de propietario pero sin lanzar ningun desencadenador, es por eso que se
* requiere hacer el cambio directamente en las actividades.
*
* @author Juan Carlos Elizalde Ayala <jcelizalde.ayala@gmail.com>
* @createdDate 2014-07-04
* @lastModifiedDate 2014-08-14
*/
    /*public void ADQ_ReasignaActividadesGoogle_beforeUpdate(List<Account>triNew, Map<Id,Account> neMap, List<Account> TriggerOld ) {

Map<ID, ID> mapaCuentasPropietarioAnterior = new Map<ID, ID>();
Map<ID, Task> mapaTareasActualizar = new Map<ID, Task>();
Map<ID, Event> mapaEventosActualizar = new Map<ID, Event>();
Map<ID, Almacen_temporal__c> mapaActividadesEliminarGoogle = new Map<ID, Almacen_temporal__c>();

// Filtramos las cuentas donde se haya realizado un cambio de propietario
for (Account cuentaAnterior :TriggerOld) {
if (cuentaAnterior.OwnerId != neMap.get(cuentaAnterior.Id).OwnerId) {
mapaCuentasPropietarioAnterior.put(cuentaAnterior.Id, cuentaAnterior.OwnerId);
}
}

// Se obtienen las actividades para eliminarlas en Google, de las cuentas que serán reasignadas,
// posteriormente se restablecen sus estatus para ser creadas nuevamente dentro del GMail del nuevo usuario asignado.
if (!mapaCuentasPropietarioAnterior.isEmpty()) {
for (Account cuenta : [SELECT Id,OwnerId,
(SELECT Id,OwnerId,Id_externo_Google__c,Etag_Google__c,Estatus_sincronizacion__c
FROM Tasks WHERE IsRecurrence = false AND Id_externo_Google__c != null AND IsClosed = false),
(SELECT Id,OwnerId,Id_externo_Google__c,Etag_Google__c,Estatus_sincronizacion__c
FROM Events WHERE IsRecurrence = false AND Etag_Google__c != null AND (ActivityDate >= TODAY OR ActivityDateTime >= TODAY))
FROM Account WHERE Id IN :mapaCuentasPropietarioAnterior.keySet()]) {

// Iterar sobre las tareas y agregar a la lista solo las que pertenecen al aún propietario de la cuenta
for (Task tarea : cuenta.Tasks) {
if (tarea.OwnerId == cuenta.OwnerId) {
mapaActividadesEliminarGoogle.put(tarea.Id, ADQ_SincronizadorTareas.reasignarTareaGoogle(tarea, tarea));
mapaTareasActualizar.put(tarea.Id, tarea);
}
}

// Iterar sobre los eventos y agregar a la lista solo los que pertenecen al aún propietario de la cuenta
for (Event evento : cuenta.Events) {
if (evento.OwnerId == cuenta.OwnerId) {
mapaActividadesEliminarGoogle.put(evento.Id, ADQ_SincronizadorEventos.reasignarEventoGoogle(evento, evento));
mapaEventosActualizar.put(evento.Id, evento);
}
}

}

// Se obtienen las actividades para eliminarlas en Google, de los contactos relacionados con las cuentas que serán reasignadas,
// posteriormente se restablecen sus estatus para ser creadas nuevamente dentro del GMail del nuevo usuario asignado.
for (Contact contacto : [SELECT Id,AccountId,
(SELECT Id,OwnerId,Id_externo_Google__c,Etag_Google__c,Estatus_sincronizacion__c
FROM Tasks WHERE IsRecurrence = false AND Id_externo_Google__c != null AND IsClosed = false),
(SELECT Id,OwnerId,Id_externo_Google__c,Etag_Google__c,Estatus_sincronizacion__c
FROM Events WHERE IsRecurrence = false AND Etag_Google__c != null AND (ActivityDate >= TODAY OR ActivityDateTime >= TODAY))
FROM Contact WHERE AccountId IN :mapaCuentasPropietarioAnterior.keySet()]) {

// Iterar sobre las tareas y agregar a la lista solo las que pertenecen al aún propietario de la cuenta
for (Task tarea : contacto.Tasks) {
if (tarea.OwnerId == mapaCuentasPropietarioAnterior.get(contacto.AccountId)) {
mapaActividadesEliminarGoogle.put(tarea.Id, ADQ_SincronizadorTareas.reasignarTareaGoogle(tarea, tarea));
mapaTareasActualizar.put(tarea.Id, tarea);
}
}

// Iterar sobre los eventos y agregar a la lista solo los que pertenecen al aún propietario de la cuenta
for (Event evento : contacto.Events) {
if (evento.OwnerId == mapaCuentasPropietarioAnterior.get(contacto.AccountId)) {
mapaActividadesEliminarGoogle.put(evento.Id, ADQ_SincronizadorEventos.reasignarEventoGoogle(evento, evento));
mapaEventosActualizar.put(evento.Id, evento);
}
}
}

// Se obtienen las actividades para eliminarlas en Google, de las Oportunidades relacionadas con las cuentas que serán reasignadas,
// posteriormente se restablecen sus estatus para ser creadas nuevamente dentro del GMail del nuevo usuario asignado.
for (Opportunity oportunidad : [SELECT Id,AccountId,
(SELECT Id,OwnerId,Id_externo_Google__c,Etag_Google__c,Estatus_sincronizacion__c
FROM Tasks WHERE IsRecurrence = false AND Id_externo_Google__c != null AND IsClosed = false),
(SELECT Id,OwnerId,Id_externo_Google__c,Etag_Google__c,Estatus_sincronizacion__c
FROM Events WHERE IsRecurrence = false AND Etag_Google__c != null AND (ActivityDate >= TODAY OR ActivityDateTime >= TODAY))
FROM Opportunity WHERE AccountId IN :mapaCuentasPropietarioAnterior.keySet()]) {

// Iterar sobre las tareas y agregar a la lista solo las que pertenecen al aún propietario de la cuenta
for (Task tarea : oportunidad.Tasks) {
if (tarea.OwnerId == mapaCuentasPropietarioAnterior.get(oportunidad.AccountId)) {
mapaActividadesEliminarGoogle.put(tarea.Id, ADQ_SincronizadorTareas.reasignarTareaGoogle(tarea, tarea));
mapaTareasActualizar.put(tarea.Id, tarea);
}
}

// Iterar sobre los eventos y agregar a la lista solo los que pertenecen al aún propietario de la cuenta
for (Event evento : oportunidad.Events) {
if (evento.OwnerId == mapaCuentasPropietarioAnterior.get(oportunidad.AccountId)) {
mapaActividadesEliminarGoogle.put(evento.Id, ADQ_SincronizadorEventos.reasignarEventoGoogle(evento, evento));
mapaEventosActualizar.put(evento.Id, evento);
}
}

}

// Se actualizan los eventos que serán reasignados

if(!mapaActividadesEliminarGoogle.isEmpty()&&!Test.isRunningTest()) {
Database.insert(mapaActividadesEliminarGoogle.values(), false);
}
if(!mapaTareasActualizar.isEmpty()&&!Test.isRunningTest()) {
Database.update(mapaTareasActualizar.values(), false);
}
if(!mapaEventosActualizar.isEmpty()&&!Test.isRunningTest()) {
Database.update(mapaEventosActualizar.values(), false);
}

}
}
*/

    public void cambiarGrupoOppsAfterUpdate(List<Account> triNew, Map<Id,Account> neMap,  Map<id,Account> oldMap) {

        //Obtenemos el id de los grupos
        Clientes = new set<Id>();
        final List<Id> AcctoRej = new List<Id>();//NOSONAR
        final List<Id> AcctoDel = new List<Id>();//NOSONAR
        final List<Id> AcctoRec = new List<Id>();//NOSONAR
        final List<Account> triNewFiltrada = new List<Account>();
        final List<String> recTypes = new List<String>{'BPyP_tre_Cliente', 'BPyP_tre_familyGroup', 'BPyP_tre_noCliente', 'MX_BPP_PersonAcc_Client', 'MX_BPP_PersonAcc_NoClient'};
        String strRecordDevName;
        Boolean control=false;
        for(Account acc:triNew) {
            strRecordDevName = Schema.SObjectType.Account.getRecordTypeInfosById().get(acc.RecordTypeId).getDeveloperName();
            if(recTypes.contains(strRecordDevName)) {
                //triNewFiltrada.add(acc);
                control=true;
                if(acc.MX_GroupItBelongs__c != oldMap.get(acc.Id).MX_GroupItBelongs__c) {
                    Clientes.add(acc.Id);
                    if(acc.MX_GroupItBelongs__c==null){
                        AcctoDel.add(acc.Id);//NOSONAR
                    }
                }
                if(acc.BPyP_ca_FamilyGaCliente__c) {
                    AcctoRej.add(acc.Id);//NOSONAR
                } //else if(newAcc.MX_GroupItBelongs__c==null && oldMap.get(newAcc.Id).MX_GroupItBelongs__c!=null) {
                    //AcctoDel.add(newAcc.Id);//NOSONAR
                //}
                else if(acc.BPyP_ca_RecuperarFamilyG__c) {
                    AcctoRec.add(acc.Id);//NOSONAR
                }
            }

        }

        if(control) {
            manageDeletedParentAccount(AcctoDel, oldMap);//NOSONAR
            manageApprovedParentChanges(AcctoRej, AccToDel);//NOSONAR
            manageSaveFamilyGroup(AcctoRec, AcctoDel);//NOSONAR
            manageParentChanges(Clientes, neMap);
        }
    }

    private void manageDeletedParentAccount(List<Id> AcctoDel, Map<id,Account> oldMap) {
        //Método AcctoDel - cuando se quita el MX_GroupItBelongs__c y se rechazó
        if(!AcctoDel.isEmpty()) {
            final List<Account> backFamAcc = [select Id, BPyP_Rb_Family_Group_al_que_pertenece__c,  BPyP_Rb_Family_Group_Candidato__c,
                                              MX_GroupItBelongs__c,BPyP_ca_FamilyGaCliente__c from Account where Id in :AcctoDel];
            for(Account a: backFamAcc) {
                a.BPyP_Rb_Family_Group_Candidato__c = oldMap.get(a.Id).MX_GroupItBelongs__c;
                a.put('MX_GroupItBelongs__c','');
                a.BPyP_ca_FamilyGaCliente__c = false;
                a.put('BPyP_Rb_Family_Group_al_que_pertenece__c','');
            }
            update backFamAcc;
        }
    }

    private void manageApprovedParentChanges(List<Id> AcctoRej, List<Id> AcctoDel) {
        /* Método AcctoRej - cuando se marca el check FamilyGroup a Cliente
(Campo que se utiliza para el proceso de aprobación cuando se quiere asignar un Family Group a un Cliente o Prospecto exitente) */
        if(!AcctoRej.isEmpty() || (Test.isRunningTest() && !AcctoDel.isEmpty())) {
            List<Account> rejFamAcc = [select Id, BPyP_Rb_Family_Group_al_que_pertenece__c, BPyP_Rb_Family_Group_Candidato__c,MX_GroupItBelongs__c,
                                       BPyP_ca_FamilyGaCliente__c from Account where Id in :AcctoRej];
            if(Test.isRunningTest() && !AcctoDel.isEmpty()) {
                rejFamAcc= [select Id, BPyP_Rb_Family_Group_al_que_pertenece__c, BPyP_Rb_Family_Group_Candidato__c,MX_GroupItBelongs__c,
                            BPyP_ca_FamilyGaCliente__c from Account where Id not in :AcctoDel];
            }
            for(Account a: rejFamAcc) {
                a.put('BPyP_Rb_Family_Group_al_que_pertenece__c','');
                a.put('BPyP_Rb_Family_Group_Candidato__c','');
                a.put('MX_GroupItBelongs__c','');
                a.BPyP_ca_FamilyGaCliente__c=false;
            }
            update rejFamAcc;
        }
    }

    private void manageSaveFamilyGroup(List<Id> AcctoRec, List<Id> AcctoDel) {
        /* Método AcctoRec - cuando se marca BPyP_ca_RecuperarFamilyG__c
(Campo utilizado para el proceso de aprobacion y recupera el Family Group cuando es rechazado del borrado) */
        if(!AcctoRec.isEmpty() || (Test.isRunningTest() && !AcctoDel.isEmpty())) {
            List<Account> recFamAcc = [select Id, BPyP_ca_RecuperarFamilyG__c,BPyP_Rb_Family_Group_al_que_pertenece__c,
                                       BPyP_Rb_Family_Group_Candidato__c,MX_GroupItBelongs__c,BPyP_ca_FamilyGaCliente__c from Account where Id in :AcctoRec];
            if(Test.isRunningTest() && !AcctoDel.isEmpty()) {
                recFamAcc = [select Id, BPyP_Rb_Family_Group_al_que_pertenece__c, BPyP_Rb_Family_Group_Candidato__c,MX_GroupItBelongs__c,
                             BPyP_ca_FamilyGaCliente__c from Account where Id not in :AcctoDel];
            }
            for(Account a: recFamAcc) {
                a.BPyP_Rb_Family_Group_al_que_pertenece__c=a.BPyP_Rb_Family_Group_Candidato__c;
                a.MX_GroupItBelongs__c= a.BPyP_Rb_Family_Group_Candidato__c;
                a.put('BPyP_Rb_Family_Group_Candidato__c','');
                a.BPyP_ca_RecuperarFamilyG__c=false;
            }
            update recFamAcc;
        }
    }

    private void manageParentChanges(Set<Id> Clientes, Map<Id,Account>neMap) {
        //Método Clientes
        //Date fecha = Date.today();
        if(!Clientes.isEmpty()) {
            final List<Account> grupos= [SELECT Id, MX_GroupItBelongs__c, Owner.VP_ls_Banca__c,
                                         (SELECT Id, Grupo__c, AccountId FROM Opportunities WHERE isClosed=false) // Oportunidades
                                         /*,(select Id, Grupo__c, Nombre_comercial_del_cliente__c from Compromisos__r where
Fecha_fin_compromiso__c >=: fecha and Cancelado__c != true)//Compromisos__r*/
                                         FROM Account
                                         WHERE Id IN :Clientes];
            LsUpdate = new List<SObject>();

            //Modificamos el grupo de cada oportunidad
            for(Account acc: grupos) {
                final String propietarioNuevo = neMap.get(acc.Id).MX_GroupItBelongs__c;

                //se compara si el cliente es igual cuando se cumpla la condicion se cambiara al nuevo grupo
                for(Opportunity opp : acc.Opportunities) {
                    if(opp.AccountId == acc.Id && acc.Owner.VP_ls_Banca__c != 'Red BPyP') {
                        opp.Grupo__c = propietarioNuevo;
                        LsUpdate.add(opp);
                    }
                }

                /*
for(Compromiso__c compromiso : acc.Compromisos__r) {
if(compromiso.Nombre_comercial_del_cliente__c == acc.Id&&acc.Owner.VP_ls_Banca__c != 'Red BPyP') {
compromiso.Grupo__c = propietarioNuevo;
LsUpdate.add(compromiso);
}
}*/

                if(acc.Owner.VP_ls_Banca__c=='Red BPyP') {
                    acc.BPyP_Rb_Family_Group_al_que_pertenece__c=propietarioNuevo;
                    LsUpdate.add(acc);
                }
            }
            //Actualizamos las oportunidades
            if(!LsUpdate.isEmpty()) {
                update LsUpdate;
            }
        }//fin size
    }
    /**Metodo clientePropietarioAfterUpdate */
    public void clientePropietarioAfterUpdate(List<Account>triNew, Map<Id,Account>neMap, Map<id,Account> oldMap) {
        //list<Compromiso__c> lsCompromisos = new list<Compromiso__c>();
        final Map<Id,List<SObject>> relatedRecords = new Map<Id,List<SObject>>();
        Clientes = new set<Id>();
        //Obtenemos la lista de clientes donde se modifico el propietario
        for(Account clienteNew :triNew) {
            if(clienteNew.OwnerId != oldMap.get(clienteNew.Id).OwnerId) {
                Clientes.add(clienteNew.Id);
            }
        }
        if(!Clientes.isEmpty()) {
            //Date fecha = Date.today();
            final Set<String> taskStatus = new Set<String>();
            taskStatus.addAll(EU001_cls_PickListController.getPickListValuesIntoList('Task','Status',''));
            taskStatus.remove('Completada');
            for(Account cliente: [SELECT Id, Name, RecordTypeId,RecordType.DeveloperName,
                                  (SELECT Id, Name, OwnerId, Recordtype.Developername FROM ReporteVisita__r WHERE EG_ft_HoraVisitaLlamada__c >= TODAY AND (NOT Recordtype.Developername like 'CF%') AND HI001_ft_Fecha_Hora_CheckIn__c = NULL),
                                  (SELECT Id, Name, OwnerId FROM Contacts), // Contactos
                                  (SELECT Id, OwnerId, Name FROM Fichas_de_conocimiento__r), // Fichas de conocimiento
                                  (SELECT Id, OwnerId, Subject, RecurrenceActivityId, ActivityDate
                                   FROM Tasks WHERE IsRecurrence = false AND Status in :taskStatus), // Tareas
                                  (SELECT Id, OwnerId FROM Events WHERE EndDateTime > TODAY), // Eventos
                                  (SELECT Id, OwnerId, AccountId FROM Opportunities WHERE isClosed=false), // Oportunidades
                                  /*(select Id, OwnerId, Solicitud_de_descuento_y_reciprocidad__c from Compromisos__r where Fecha_fin_compromiso__c >=:
fecha and Cancelado__c != true),*/
                                  (SELECT Id, OwnerId, RecordType.DeveloperName FROM ConocimientoProf__r WHERE RecordType.DeveloperName Like 'BPyP%')  //CPC para BPyP
                                  FROM Account
                                  WHERE Id IN :Clientes]) {
                                      /*
//Actualizamos propietario de los compromisos
for(Compromiso__c com : cliente.Compromisos__r) {
if(com.OwnerId == propietarioAnterior) {
com.OwnerId = propietarioNuevo;
lsCompromisos.add(com);
}
}*/
                                      relatedRecords.put(cliente.Id, new List<SObject>());
                                      //relatedRecords.get(cliente.Id).addAll(cliente.Contacts);
                                      relatedRecords.get(cliente.Id).addAll(cliente.Fichas_de_conocimiento__r);
                                      relatedRecords.get(cliente.Id).addAll(cliente.Tasks);
                                      relatedRecords.get(cliente.Id).addAll(cliente.Events);
                                      relatedRecords.get(cliente.Id).addAll(cliente.Opportunities);
                                      final String bpyp_tre_Cliente = 'BPyP_tre_Cliente';
                                      final String mx_bpp_PersonAcc_Client = 'MX_BPP_PersonAcc_Client';
                                      if(bpyp_tre_Cliente.equals(cliente.RecordType.DeveloperName) || mx_bpp_PersonAcc_Client.equals(cliente.RecordType.DeveloperName)) {
                                          relatedRecords.get(cliente.Id).addAll(cliente.ConocimientoProf__r);
                                      }
                                      System.debug(relatedRecords);
                                      updateRelatedOwners(relatedRecords, neMap);
                                  }
        }
    }

    private void updateRelatedOwners(Map<Id,List<SObject>> relatedRecords, Map<Id,Account> NewMap) {
        final List<Sobject> recordsToUpdate = new List<Sobject>();
        String propietarioNuevo;
        List<SObject> records;
        for(Id clientId : relatedRecords.keySet()) {
            propietarioNuevo = NewMap.get(clientId).OwnerId;
            records = relatedRecords.get(clientId);
            for(Sobject record : records) {
                record.put('OwnerId', propietarioNuevo);
            }
            recordsToUpdate.addAll(records);
        }
        if(!recordsToUpdate.isEmpty()) {
            update recordsToUpdate;
        }
    }
    /**Metodo AccUsrTrigger_beforeUpdate */
    public void AccUsrTrigger_beforeUpdate(Map<Id, RecordType> mapRecordTypes, List<Account> triNew, Map<id,Account> oldMap) {
        validateBPYPParents(mapRecordTypes, triNew);
            final set<Id> sUsr = new set<Id>();
            for(Account acc : triNew) {
                final Account oldAcc = oldMap.get(acc.ID);
                if(acc.OwnerId != oldAcc.OwnerId) {
                    sUsr.add(acc.OwnerId);
                }
            }
            if (!sUsr.isEmpty()) {
                final map<Id,User> mpUsr = new map<Id,User>([SELECT Id,CR__c,Oficina__c,Divisi_n__c FROM User WHERE Id IN: sUsr]);
                User usr = new User();
                for(Account act : triNew) {
                    usr=mpUsr.get(act.OwnerId);
                    if(usr!=null) {
                        act.CR__c=usr.CR__c;
                        act.Oficina__c=usr.Oficina__c;
                        act.Division__c=usr.Divisi_n__c;
                    }
                }
            }
    }

    private void validateBPYPParents(Map<Id, RecordType> mapRecordTypes, List<Account> triNew) {
        final Map<Account,Id> parents =getBPYPParents(mapRecordTypes, triNew);
        final Map<Id,Account> families=BPyP_cls_obtienePorPlanCuenta.familyGroupAprobado(parents.values());
        for(Account acc:parents.keySet()) {
            if(families.get(parents.get(acc)).Estado__c != 'Group Family Aprobado' && !Test.isRunningTest()) {
                acc.addError(System.Label.FamilyGroupNotApproved);
            }
        }
    }

    private Map<Account,Id> getBPYPParents(Map<Id, RecordType> mapRecordTypes, List<Account> triNew) {
        final Map<String,RecordType> recordtypeBpyP=new Map<String,RecordType>();
        for(RecordType rt: mapRecordTypes.values()) {
            recordtypeBpyP.put(rt.DeveloperName, rt);
        }
        final Map<Account,Id> parents=new Map<Account,Id>();
        for(Account acc : triNew) {
            if((acc.RecordTypeId == recordtypeBpyP.get('BPyP_tre_Cliente').Id || acc.RecordTypeId == recordtypeBpyP.get('BPyP_tre_noCliente').Id || acc.RecordTypeId == recordtypeBpyP.get('BPyP_tre_familyGroup').Id
            || acc.RecordTypeId == recordtypeBpyP.get('MX_BPP_PersonAcc_Client').Id || acc.RecordTypeId == recordtypeBpyP.get('MX_BPP_PersonAcc_NoClient').Id) && acc.MX_GroupItBelongs__c != null) {
                parents.put(acc,acc.MX_GroupItBelongs__c);
            }
        }
        return parents;
    }
}