<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MX_RTE_Actualiza_Fecha_de_ejecucion</fullName>
        <field>MX_RTE_Proxima_Ejecucion__c</field>
        <formula>MX_RTE_Proxima_Ejecucion__c +1</formula>
        <name>Actualiza Fecha de ejecución</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Ejecutar_Process_Falso</fullName>
        <field>MX_RTE_Ejecuta_Reporte__c</field>
        <literalValue>0</literalValue>
        <name>Ejecutar Process = Falso</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Ejecutar Process Builder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>MX_RTE_Process_Builder_Execute__c.MX_RTE_Ejecuta_Reporte__c</field>
            <operation>equals</operation>
            <value>true</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>MX_RTE_Actualiza_Fecha_de_ejecucion</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>MX_RTE_Ejecutar_Process_Falso</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>MX_RTE_Process_Builder_Execute__c.MX_RTE_Proxima_Ejecucion__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
