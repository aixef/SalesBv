/**
* Nombre: MX_SB_SAC_AgregarSlasClsTest
* @author   Karen Sanchez (KB)
* Proyecto: MX_SB_SAC - BBVA Bancomer   
* Descripción : Clase test para asignar los Slas a una asignación desde un caso
*
*            No.    Fecha            Autor             Description
*                                                     
* @version  1.0   2019-04-24      Karen Belem (KB)      Creación
*/
@isTest
public class MX_SB_SAC_AgregarSlasClsTest {
    @TestSetup 
    static void insertarRegistros() {
        
        final Account testAccount = MX_WB_TestData_cls.crearCuenta('Test','PersonAccount');
        insert testAccount;
        
        final Opportunity testOpportunity = MX_WB_TestData_cls.createOppClosed('Opportunity Test',testAccount.Id,'ASD');
        insert testOpportunity;
        
        final Entitlement testEntitlement = MX_WB_TestData_cls.crearAsignacion('Test Asignacion' , testAccount.Id);
        insert testEntitlement; 
        
        final Case testCase = MX_WB_TestData_cls.createCase(testOpportunity.Id, 'Nuevo');
        testCase.Reason = 'Servicios'; 
        testCase.MX_SB_SAC_SubOrigenCaso__c = 'Facebook';
        testCase.EntitlementId = testEntitlement.Id;
        insert testCase;
    }
    
    @isTest
    static void insertarSLAs() {        
        final Case objCaso = [SELECT Status,EntitlementId, Entitlement.SlaProcessId, Reason FROM Case WHERE Status NOT IN ('')];
        MX_SB_SAC_AgregarSlasCls.mAgregaSLA(new List<String> {objCaso.Id});
        final Entitlement objEntitlement = [SELECT Id,Name FROM Entitlement WHERE Name = 'Test Asignacion'];    
        objEntitlement.Id = objCaso.EntitlementId;
        final Database.SaveResult result = Database.update(objEntitlement);  
        System.assert(result.isSuccess(),'');
    }   
}