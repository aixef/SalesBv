/****************************************************************************************************
Información general
-------------------
author: Javier Armando Tibamoza Cubillos
email: jtibamoza@avanxo.com
company: Avanxo Colombia
Project: Implementación Salesforce
Customer: WIBE
Description: Trigger para la lógica de desarrollos desde Oportunidad

Information about changes (versions)
-------------------------------------
Number    Dates           Author                       Description
------    --------        --------------------------   -----------
1.0       09-Mar-2016     Javier Tibamoza              Creación de la Clase
1.1       27-Abr-2017     Manuel Mendez                Modificacion de la Clase
2.0		  13-Feb-2019	  Javier Ortiz Flores		   Se agrega method para crear contratos en after update para proceso Outbound.
2.1		  13-Feb-2019	  Javier Ortiz Flores 		   Se delimita funcionalidad Outbound por tipo de registro para los tiempos de ejecución.
****************************************************************************************************/
trigger WB_Opportunity_tgr on Opportunity ( before insert, before update, after insert, after update) {
	new MX_SB_VTS_OpportunityTriggerHandler().run();
}