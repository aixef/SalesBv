/*
* @Name         Case_cls
* @Author       Eduardo Santiago Meza
* @ModifiedBy
* @Version      V1.0
* @CreatedDate  02-10-2017
* @UsedBy       Trigger Intrusion_tgr, Clase Case_Handler_cls
*-------------------------------------------------------------------------------------------------------------------
* @Description
*               Contiene validaciones previas a la insercion de Casos de los tipos Alerta CRM e Inclusion de Alerta CRM
*--------------------------------------------------------------------------------------------------------------------
* @Changes
*  V1.1         Eduardo Santiago Meza
*  06-10-2017   Se añadio la logica relacionada a la Quick Action Levantar Aclaracion
*  V1.2         Walter A. Calles
*  15-03-2018   Cobertura de clase Case_cls para Carterización otras Bancas
*  V1.3
*  13-04-2018   Jose Mario Rodriguez  -  Sergio Andres Ortiz
*               Se Modifica la Clase para usar el Framework de Kevin Ohara
*               Se eliminan Querys dentro de ciclos
*               Se Elimina Bug que modificaba el propietario antes de realizar la aprobacion
*  V1.4         Eulises Aguilar Rodriguez
*  22-05-2018   Se anexa proceso para la historia de carterización "Cambio de segmento"
*  V1.5         Eulises Aguilar Rodriguez
*  29-05-2018   Se anexa proceso para la historia de carterización "Clientes Masa"
*  V1.6         Eulises Aguilar Rodriguez
*  25-06-2018   Se anexa proceso de validación para los casos generados de "Cambio de segmento"
*  26-07-2018   Se agrega lógica para el cambio de tipo de registro del cliente.
*  V1.7         Francisco Javier
*  28-06-2018   Se añade funcionalidad de compartición de apoyos, se añade validación para aprobaciones.
*  12-08.2018   Francisco J Licona - Se modifica logica de CaseShare para evalúar tipos de registro y se elimina mensaje de error en aprobaciones.
*  01-11-2018   Francisco J Licona - Se agregan tipos de registro para flujo de apoyos a las validaciones del método 'getCaseName'
*  03-12-2018   Francisco J Licona - Se agrega tipo de registro para apoyos que se crean a partir de acuerdos de visitas.
*  V2.1         Juan C Villalpando
*  22-01-2019   Se corrige Incidencia 00044847. Los casos de Aclaraciones de Alertas CRM, no necesitan
*               el alta de un registro caseShare
*  23-01-2019   Jhovanny De La C.C. - Se construye funcionalidad y validaciones para la generación de casos y recarterizaciones PyME.
*  23-01-2019   Jhovanny De La C.C. - Se construye método para el cambio de propietarios en recarterizaciones y
                                      se insertan etiquetas para manejo de errores.
*  25-01-2019   Jhovanny De La C.C. - Validación de llave 'PYME' para traspasos mavisos
*  31-01-2019   Jhovanny De La C.C. - Cambio en la referencia a booleano  MX_EU_Apoyo_oportunidad__c
*  06-02-2019   Jhovanny De La C.C. - Se agrega validación y asignaciones para carga de cartera masiva PyME
*  07-02-2019   Jhovanny De La C.C. - Se agrega método InvocableMethod "createCaseTeamMemeber" para asignación
                                      de CaseShare a aprobadores en diferentes divisiones
*  13-02-2019   Jhovanny De La C.C. - Se guarda la "M" del ejecutivo destino reutilizando el campo CS_tx_ejectutivo__c
*  18-02-2019   Jhovanny De La C.C. - Se corrigen validaciones para la ejecución de la carterización masiva
*  18-02-2019   Jhovanny De La C.C. - Validaciones, si existen ejecutivos de divisiones  "OCCIDENTE PYME" o
                                      "REGIONAL OCCIDENTE PYME" no se tomen como divisiones diferentes
*  19-02-2019   Jhovanny De La C.C. - Validaciones a campo "Traspaso divisional"
*  01-03-2019   Jhovanny De La C.C. - Corrección de validaciones en traspasos entre mismo centro de negocio
*  01-04-2019   Daniel García       - Se agregó validación sobre campo MX_PyME_Division_origen__c para registros de pecera PyME
*  16-04-2019   Iván Cabrer         - Se crea método assignDesignate para asignar al propietario del caso como usuario designado en casos BIE.
*  12-05-2019 	Daniel García	    - Se modifica método cambioPropietarioPyME
*  09-07-2019   Cindy Hernández     - Se eliminan los métodos ValidaAlertaCRM, ValidaCambioPropietario, AsignaPropietario,
                                      ValidaConversionCliente, ConvierteCliente, getCaseName y assignDesignate ya que no son utilizados en BPyP ni en PyME.
*  11-07-2019   Cindy Hernández     - Resolución de code smells detectados por sonar.
                                      Se agregan los métodos updateApprovedAccounts y getNoClientesList.
*--------------------------------------------------------------------------------------------------------------------
*/
public without sharing class Case_cls {

/*------------------------------------------------------------------------------------------------------
*@Description Execution of change of owner, SME customers
* -----------------------------------------------------------------------------------------------------
* @Author   Jhovanny De La Cruz Cruz
* @Date     2019-01-23
* @param    lstNewCase List of new update cases type TriggerNew
* @param    mapOldCase Map of old update cases type Trigger.oldMap
* @return   void
* @example  new Case_cls().cambioPropietarioPyME(lstNewCase,mapOldCase);
* -----------------------------------------------------------------------------------------------------
*/

    public void cambioPropietarioPyME(List<Case> lstNewCase,Map<Id, Case> mapOldCase) {
        final Map<String,String> accOwner = new Map<String,String>();
        final Map<String,Account> noClientesMap = new Map<String,Account>();

        final List<String> noClientes = getNoClientesList(lstNewCase);

        final List<Account> lst = [Select Id,No_de_cliente__c from Account where No_de_cliente__c in :noClientes];
        for(Account cuent: lst) {
            noClientesMap.put(cuent.no_de_cliente__c,cuent);
        }
        for(Case cs: lstNewCase) {
            if(cs.RecordTypeId == RecordTypeMemory_cls.getRecType('Case','MX_PyME_Case_CarterizacionPyME') && 'Aprobada'.equals(cs.Status) && cs.MX_EU_Apoyo_oportunidad__c && (mapOldCase.get(cs.Id).Status != cs.Status)) {
                final String accs = cs.Detalle_de_soluci_n__c.mid(1, cs.Detalle_de_soluci_n__c.length()-2);
                for(String accNum:accs.split(', ')) {
                    accOwner.put(noClientesMap.get(accNum).Id,cs.CS_rb_nombreEjecutivo__c);
                }
            }
        }
        updateApprovedAccounts(accOwner);
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          11-07-2019
* @Description  Update approved accounts.
* @Comments     Created from the clipped code block of class cambioPropietarioPyME.
* @param        Map<String,String> accOwner
* @return       void
* @example      updateApprovedAccounts(accOwner)
**/
    public void updateApprovedAccounts(Map<String,String> accOwner) {
        if(!accOwner.keySet().isEmpty()) {
            final List<Account> AprobCuentaAct = new List<Account>();
            final List<Account> AprobCuenta = [SELECT id,Name,Ownerid FROM Account WHERE id IN:accOwner.keySet()];
            if(!AprobCuenta.isEmpty()) {
                for(Account acc:AprobCuenta) {
                    acc.Cuentas_Bloqueadas__c = true;
                    acc.OwnerId = accOwner.get(acc.id);
                    AprobCuentaAct.add(acc);
                }
            }
            update AprobCuentaAct;
        }
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          11-07-2019
* @Description  Update approved accounts.
* @Comments     Created from the clipped code block of class cambioPropietarioPyME.
* @param        List<Case> lstNewCase
* @return       List<String>
* @example      getNoClientesList(lstNewCase)
**/
    public List<String> getNoClientesList(List<Case> lstNewCase) {
        final List<String> noClientes = new List<String>();

        for(Case cs: lstNewCase) {
            if(cs.RecordTypeId == RecordTypeMemory_cls.getRecType('Case','MX_PyME_Case_CarterizacionPyME')) {
                final String accs = cs.Detalle_de_soluci_n__c.mid(1, cs.Detalle_de_soluci_n__c.length()-2);
                for(String accNum:accs.split(', ')) {
                    noClientes.add(accNum.trim());
                }
            }
        }
        return noClientes;
    }

/*------------------------------------------------------------------------------------------------------
*@Description Method for the generation and assignment of case share for divisional transfers of clients
* -----------------------------------------------------------------------------------------------------
* @Author   Jhovanny De La Cruz Cruz
* @Date     2019-02-06
* @param    lstNewCaseShare List of new share cases
* @return   void
* @example  The method is called through a process builder by its label "MX_PyME_CaseShare" referencing the list variable "lstNewCaseShare"
* */

    @InvocableMethod(label='MX_PyME_CaseShare' description='A case is shared with the next approver')
    public  static void createCaseTeamMemeber(List<Case> lstNewCaseShare) {
        final Map<String,String> psiActorId = new Map<String,String>();
        List<ProcessInstance> prss = new List<ProcessInstance>();
        final List<CaseShare> jobShrLst  = new List<CaseShare>();
        List<Case> filterCases  = new List<Case>();
        CaseShare jobShr;
        filterCases = [SELECT id FROM Case WHERE id IN:new Map<Id, Case>(lstNewCaseShare).keySet()];
        if(!filterCases.isEmpty()) {
            prss = [ SELECT Id,TargetObjectid, Status,(select id,actor.name from Workitems),(SELECT Id, StepStatus, Comments,Actor.Name FROM Steps),(SELECT actor.name,originalactorid,StepStatus FROM StepsAndWorkitems WHERE StepStatus = 'Pending') FROM ProcessInstance where TargetObjectId IN:new Map<Id, Case>(filterCases).keySet()];
            if(!prss.isEmpty()) {
                for(ProcessInstance psi :prss) {
                    for(ProcessInstanceHistory  st : psi.StepsAndWorkitems) {
                        psiActorId.put(psi.TargetObjectId, st.ActorId);
                    }
                }
            }
            for(Case cs : filterCases) {
                jobShr  = new CaseShare();
                jobShr.CaseId = cs.Id;
                jobShr.UserOrGroupId = psiActorId.get(cs.id);
                jobShr.CaseAccessLevel = 'Read';
                jobShr.RowCause = 'Manual';
                jobShrLst.add(jobShr);
            }
        }
        if(!jobShrLst.isEmpty()) {
            insert jobShrLst;
        }
    }

}