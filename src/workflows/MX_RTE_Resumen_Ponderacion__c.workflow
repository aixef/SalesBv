<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MX_RTE_Concatenar_Ponderacion</fullName>
        <field>MX_RTE_Ponderacion__c</field>
        <formula>TEXT( MX_RTE_Resumen__c *100)&amp;&apos;%&apos;</formula>
        <name>Concatenar Ponderacion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Concatena Ponderación</fullName>
        <actions>
            <name>MX_RTE_Concatenar_Ponderacion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(MX_RTE_Resumen__c  ) || NOT(ISBLANK(MX_RTE_Resumen__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
