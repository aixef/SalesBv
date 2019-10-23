/**
  Nombre: MX_SB_SAC_HorarioOficinaClsTest
  @author   Karen Sanchez (KB)
  Proyecto: MX_SB_SAC - BBVA Bancomer   
  Descripción : Clase test para agregar el horario de oficina a las asignaciones
 
             No.    Fecha            Autor             Description
                                                      
  @version  1.0   2019-04-24      Karen Belem (KB)      Creación
 */
@isTest
public class MX_SB_SAC_HorarioOficinaClsTest {
    @TestSetup 
    static void insertarRegistros() {
        final Account testAccount = MX_WB_TestData_cls.crearCuenta('Test','PersonAccount');
        insert testAccount;
        
        final Entitlement testEntitlement = MX_WB_TestData_cls.crearAsignacion('Test Asignacion' , testAccount.Id);
        insert testEntitlement;         
    }

    @isTest
    static void insertarSLAs() {
        final Entitlement objEntitlement = [SELECT Name FROM Entitlement WHERE Name = 'Test Asignacion'];   
        MX_SB_SAC_HorarioOficinaCLS.mHorarioOficina(new List<String> {objEntitlement.Id});
        final Database.SaveResult result = Database.update(objEntitlement);  
        System.assert(result.isSuccess(),'');
    }
}