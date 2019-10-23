/**
* ------------------------------------------------------------------------------------------------
* @Name     MX_PYME_Acc_OwnerAssignment_Test
* @Author   Jhovanny De La Cruz Cruz jhovanny.delacruz.contractor@bbva.com
* @Date     Created: 2019-02-06
* @Group    Test Clase for MX_PYME_Acc_OwnerAssignment_cls
* @Description Test Clase for MX_PYME_Acc_OwnerAssignment_cls
* @Changes
*
*  |2019-02-06  jhovanny.delacruz.contractor@bbva.com
*               Creation MX_PYME_Acc_OwnerAssignment_Test functionality class
*  |2019-04-01  Daniel García Domínguez
*               Account of manual record type "MASA_PYME" added
*/
@isTest
public class MX_PYME_Acc_OwnerAssignment_Test {
    /** */
    public static User creaUserEjecPyme() {
        return UtilitysDataTest_tst.crearUsuario('USUARIO EJEC', 'Ejecutivo PyME Plus', 'EJEC PYME PLUS AGUASCALIENTES');
    }
    /** */
    public static User creaUserDcnpPyme() {
        return UtilitysDataTest_tst.crearUsuario('USUARIO DCNP', 'D. CN PyME', 'D. CN PyME AGUASCALIENTES');
    }
    static Testmethod void newAccountPyME() {
        User udcnp = creaUserEjecPyme();
        udcnp.VP_ls_Banca__c = 'Red PyME';
        udcnp.Divisi_n__c = 'BAJIO PYME';
        udcnp.FederationIdentifier = 'mb01023';
        insert udcnp;
        User masaUser = creaUserDcnpPyme();
        masaUser.CommunityNickname = 'NoCarPyME';
        insert masaUser;
        System.runAs(udcnp) {
            Account acc = UtilitysDataTest_tst.crearCuenta('New Clients PyME', 'VP_tre_Cliente_PyME');
            acc.BPyP_tx_ActividadGiro__c = udcnp.FederationIdentifier;
            acc.Tipo_de_Registro_Manual__c = 'PYME';
            insert acc;
            Account clMas = UtilitysDataTest_tst.crearCuenta('Cl Masa PyME', 'VP_tre_Cliente_PyME');
            clMas.Tipo_de_Registro_Manual__c = 'MASA_PYME';
            insert clMas;
            List<Account> AccOnwerAssignment = [SELECT id FROM Account LIMIT 1];
            System.assertEquals(!AccOnwerAssignment.isEMpty(), true ,'Error al realizar la carterización única de clientes PyME');
        }
    }
    static Testmethod void newAccountPyMEError() {
        User udcnp = creaUserEjecPyme();
        udcnp.VP_ls_Banca__c = 'Red PyME';
        udcnp.Divisi_n__c = 'BAJIO PYME';
        udcnp.FederationIdentifier = 'mb01023';
        insert udcnp;
        System.runAs(udcnp) {
            Account acc = UtilitysDataTest_tst.crearCuenta('New Clients PyME', 'VP_tre_Cliente_PyME');
            acc.BPyP_tx_ActividadGiro__c = '';
            acc.Tipo_de_Registro_Manual__c = 'PYME';
            try {
                insert acc;
            }catch(DmlException e) {
                System.assertEquals(acc.id, null,Label.MX_PyME_Error_9_Referencia_a_propietario_del_cliente);
            }
        }
    }
}