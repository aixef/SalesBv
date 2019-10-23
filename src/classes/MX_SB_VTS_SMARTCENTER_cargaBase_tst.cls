/**-------------------------------------------------------------------------
* Nombre: MX_SB_VTS_SMARTCENTER_cargaBase_cls
* @author Vincent Juárez
* Proyecto: 
* Descripción : 

* --------------------------------------------------------------------------
*                         Fecha           Autor                   Desripción
* -------------------------------------------------------------------
* @version 1.0           02/05/2019      Vincent Juárez           Creación
* @version 1.0           27/08/2019      Arsenio Perez           Codesmell
* --------------------------------------------------------------------------*/

@isTest
public class MX_SB_VTS_SMARTCENTER_cargaBase_tst {
    @isTest static void methodOne() {
        final User userTest = MX_WB_TestData_cls.crearUsuario('UserOwnerTest01', 'Campanias');
        System.runAs(userTest) {
            Test.startTest();
            final System.HttpRequest req = new System.HttpRequest();
            req.setEndpoint('http://www.example.com/Crear_Carga');
            final MX_SB_VTS_SMARTCENTER_cargaBase_cls cargaBase = new MX_SB_VTS_SMARTCENTER_cargaBase_cls();
            cargaBase.modifyRequest(req);
            System.assertEquals(req.getEndpoint(), 'http://www.example.com/Crear_Carga','Correcto');
            Test.stopTest();
        }
    }
    @isTest static void methodtwin() {
        final User userTest = MX_WB_TestData_cls.crearUsuario('UserOwnerTest01', 'Campanias');
        System.runAs(userTest) {
            Test.startTest();
            final System.HttpRequest req = new System.HttpRequest();
            req.setEndpoint('http://www.example.com/Ent_RegistroGestion');
            final MX_SB_VTS_SMARTCENTER_cargaBase_cls cargaBase = new MX_SB_VTS_SMARTCENTER_cargaBase_cls();
            cargaBase.modifyRequest(req);
            System.assertEquals(req.getEndpoint(), 'http://www.example.com/Ent_RegistroGestion','Correcto');
            Test.stopTest();
        }        
    }
}