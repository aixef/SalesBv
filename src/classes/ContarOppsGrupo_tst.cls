/*
Empresa:        Softtek
Autor:                  Emmanuel Cruz Barajas
Proyecto:               Bancomer
Descripción:            Clase de prueba para desencadenador ContarOppsGrupo
--------------------------------------------------------------------------
No.     Fecha               Autor                   Descripción
------  ----------  ----------------------      --------------------------
1.0     02-09-2014  Emmanuel Cruz Barajas(ECB)  Creación
1.1   21-09-2015  Eduardo Godinez Loza(EGL) Se agrega metodo cancelacion de solicitud
1.2     13-09-2017    Jhovanny De La Cruz Cruz        Creación
1.3     20-04-2018   Carlos Ricardo Hernandez R.  Agrega un update para cambiar el propietario de la Opp.
1.4     08-05-2018   Sergio Ortiz                 Se agrega assert
1.5     03-10-2018  Fernando Jaime				Se cambia Administrador del sistema por etiqueta de personalizada
												Se agrega producto en uso para corregir fallo en metodo
2.0		10-10-2018	Cristian Espinosa			Se elimina dependencia hacia producto custom.
												*Se re estructura la clase para que cumpla con los estándares actuales.
2.1     11/07/2019  Jair Ignacio Gonzalez G     Se depuro clase con los metodos confirmados en la migracion de bpyp y pymes
*/
@isTest
private class ContarOppsGrupo_tst {

    /** Colocación */
    static final String STGFAM = 'Colocación';
    /** Collares */
    static final String STGPROD = 'Collares';
    /** MX_BPP_RedBpyp */
    static final String STGRTOPP = 'MX_BPP_RedBpyp';
    /** Cliente */
    static Account cliente;
    /** Grupo */
    static Account grupo;
    /** Usuarios */
    static User usuario,usuario2;
    /** Usuario actual */
    static User thisUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];

    static void crearUsuario() {
        usuario = UtilitysDataTest_tst.crearUsuario('Prueba', Label.MX_PERFIL_SystemAdministrator, 'EJECUTIVO GOBIERNO Y EMPRESAS OAXACA');
        usuario.Alias = 'userUno';
        usuario.UG__c = '2468135';
        usuario.Director_de_oficina__c = usuario2.Id;
        insert usuario;
    }

    static void crearUsuario2() {
        usuario2 = UtilitysDataTest_tst.crearUsuario('Prueba2', Label.MX_PERFIL_SystemAdministrator, 'EJECUTIVO GOBIERNO Y EMPRESAS OAXACA');
        usuario2.Alias = 'userDos';
        usuario2.UG__c = '2468136';
        insert usuario2;
    }

    static void crearGrupo() {
        grupo = UtilitysDataTest_tst.crearCuenta('Prueba grupo', 'BPyP_tre_familyGroup');
        grupo.No_de_cliente__c = '1234765';
        grupo.OwnerId = usuario.Id;
        insert grupo;
    }

    static void crearCliente() {
        cliente = UtilitysDataTest_tst.crearCuenta('Prueba cliente', 'BPyP_tre_Cliente');
        cliente.No_de_cliente__c = '1234768';
        cliente.OwnerId = usuario.Id;
        cliente.MX_GroupItBelongs__c = grupo.Id;
        insert cliente;
    }

    static testMethod void contarOppsGrupoTest() {
        System.runAs(thisUser) {
            crearUsuario2();
            crearUsuario();
        }
        final Integer maxQuery = Limits.getLimitQueries();
        final Integer numQuery = maxQuery - 1;
        final Trigger_Oportunidad__c setting = new Trigger_Oportunidad__c();
        setting.ContarOppsGrupo__c = true;
        insert setting;

        System.runAs(usuario) {
        	crearGrupo();
        }
        crearCliente();
        UtilitysDataTest_tst.crearProdForm('Colocación', 'Collares');
        final List<Opportunity> listaOps = new List<Opportunity>();
        final Opportunity opp = UtilitysDataTest_tst.crearOportunidad('Op Abierta', cliente.Id, usuario.Id, STGFAM, STGPROD, null, STGRTOPP);
        listaOps.add(opp);

        final Opportunity opp2 = UtilitysDataTest_tst.crearOportunidad('Op Cerrada', cliente.Id, usuario.Id, STGFAM, STGPROD, null, STGRTOPP);
        listaOps.add(opp2);

        final Opportunity opp3 = UtilitysDataTest_tst.crearOportunidad('Op Descartado', cliente.Id, usuario.Id, STGFAM, STGPROD, null, STGRTOPP);
        listaOps.add(opp3);

        final Opportunity opp4 = UtilitysDataTest_tst.crearOportunidad('Op Abierta2', cliente.Id, usuario.Id, STGFAM, STGPROD, null, STGRTOPP);
        listaOps.add(opp4);

        final Opportunity opp5 = UtilitysDataTest_tst.crearOportunidad('Op Cerrada2', cliente.Id, usuario.Id, STGFAM, STGPROD, null, STGRTOPP);
        listaOps.add(opp5);

        final Opportunity opp6 = UtilitysDataTest_tst.crearOportunidad('Op Descartado2', cliente.Id, usuario.Id, STGFAM, STGPROD, null, STGRTOPP);
        listaOps.add(opp6);
        insert listaOps;

        listaOps[0].ownerId = usuario2.id;
        update listaOps[0];

        System.runAs(usuario) {
            for(Opportunity o :listaOps) {
                if(o.Name == 'Op Cerrada' || o.Name == 'Op Cerrada2') {
                    //o.op_ca_productoUso__c = true;
                    o.StageName = 'Cerrada Ganada';
                }

                if(o.Name == 'Op Descartado' || o.Name == 'Op Descartado2') {
                    o.StageName = 'Descartada / Rechazada';
                    o.HI_ls_MotivoDescarte__c = 'Expediente incompleto';
                }
            }
            update listaOps;
            //Handler_Recursividad.UnaVez = true;

            borrarOpp(listaOps);

        }
        System.assert(Limits.getQueries() < numQuery, 'numero de querys dentro del rango  permitido');
    }

    static void borrarOpp(List<Opportunity> listaOps) {
        final List<Opportunity> listaBorrar = new List<Opportunity>();
            for(Opportunity o :listaOps) {
                if(o.Name == 'Op Abierta' || o.Name == 'Op Cerrada' || o.Name == 'Op Descartado') {
                    listaBorrar.add(o);
                }
            }
    }

}