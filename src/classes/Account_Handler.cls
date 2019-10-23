/*----------------------------------Desarrollado por INDRA---------------------------------
*Autor:         Ing. Pedro Alan Hernandez Sierra
*Proyecto:      Max BBVA PI7
*Descripción:   Manejador para el trigger Account_Trigger del objeto Account. Toda
*				lógica debe llamarse desde esta clase.
*_______________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        16/NOV/2017     Ing. Pedro Alan Hernandez Sierra
    Creación.
*1.1        02/FEB/2018     Ricardo Almanza Angeles
    Agregar trigger para procesmiento de clientes importados de datamart y asignación de los mismos a los banqueros
*1.2        28/FEB/2018     Arsenio Perez Lopez
    Agregan funcionalidades de triggers
*1.3        11/jun/2018     Luis Fernando Romero
    Se agrega logica para reconstruir sinergia hp en afterUpdate
*1.4        22/Ago/2018     F. Javier Bueno
    Agrega ENGMX_No_de_Cliente_R para recortar No. de Cliente a los 2 primeros digitos
*1.5        06/Ene/2019		Jhovanny De La Cruz
    Carterización unica para clientes nuevos PyME en carga masiva
    (metodo:  MX_PYME_Acc_OwnerAssignment_cls.ownerAssignment)
-----------------------------------------------------------------------------------------*/
public without sharing class Account_Handler extends TriggerHandler {

    /** Mapa mapRecordTypes*/
    private static Map<Id, RecordType> mapRecordTypes = new Map<Id, RecordType>([SELECT Id, DeveloperName FROM RecordType WHERE sObjectType = 'Account']);
    /** Lista newAccounts*/
    List<Account> newAccounts= (list<Account>)(Trigger.new);
	/** Lista oldAccounts*/
    List<Account> oldAccounts= (list<Account>)(Trigger.old);
	/** Maá newMpas*/
    Map<Id,Account> newMaps= (Map<Id,Account>)(Trigger.newMap);
	/** Mapa oldMaps*/
    Map<Id,Account> oldMaps= (Map<Id,Account>)(Trigger.oldMap);

    /*
    @beforeInsert event override en la Clase TriggerHandler
    Logica Encargada de los Eventos BeforeInsert */
    protected override void beforeInsert() {
        ENGMX_No_de_Cliente_R.fixClientNumber(newAccounts);
        MX_PYME_Acc_OwnerAssignment_cls.ownerAssignment(newAccounts);
        if(Trigger_Oportunidad__c.getInstance().BPyP_ClienteImportar_cls__c) {
            BPyP_ClienteImportar_cls.asignaBkm(mapRecordTypes,newAccounts);
        }
    }
    /*
    @beforeUpdate event override en la Clase TriggerHandler
    Logica Encargada de los Eventos BeforeUpdate*/
    protected override void beforeUpdate() {
			//new  Account_cls().ADQ_ReasignaActividadesGoogle_beforeUpdate(newAccounts,newMaps,oldAccounts);
			new  Account_cls().AccUsrTrigger_beforeUpdate(mapRecordTypes,newAccounts,oldMaps);
		if(Trigger_Oportunidad__c.getInstance().BPyP_ClienteImportar_cls__c) {
            BPyP_ClienteImportar_cls.asignaBkm(mapRecordTypes,newAccounts);
        }
    }

    /*
    @afterUpdate event override en la Clase TriggerHandler
    Logica Encargada de los Eventos afterUpdate*/
    protected override void afterUpdate() {
			new Account_cls().cambiarGrupoOppsAfterUpdate( newAccounts, newMaps,oldMaps);
			new Account_cls().clientePropietarioAfterUpdate( newAccounts, newMaps,oldMaps);
    }
}