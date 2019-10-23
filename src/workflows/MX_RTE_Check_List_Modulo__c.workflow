<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MX_RTE_Actualiza_A_Mesa</fullName>
        <description>EL Órgano de sanción cambia de RCI/Contraloría a Mesa de especialistas.</description>
        <field>MX_RTE_Organo_de_sanci_n__c</field>
        <literalValue>Mesa de especialistas</literalValue>
        <name>Actualiza a Mesa de especialistas</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Actualiza_a_Aprobado</fullName>
        <description>EL Órgano de sanción pasa de Comité ARO a Aprobado</description>
        <field>MX_RTE_Organo_de_sanci_n__c</field>
        <literalValue>Aprobado</literalValue>
        <name>Actualiza a Aprobado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Actualiza_a_Comit_ARO</fullName>
        <description>El Órgano de sanción pasa de Mesa de especialistas a Comité ARO.</description>
        <field>MX_RTE_Organo_de_sanci_n__c</field>
        <literalValue>Comité ARO</literalValue>
        <name>Actualiza a Comité ARO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Actualiza_a_RCI</fullName>
        <description>Al mandarse a aprobación, el campo Órgano de Sanción se actializa a RCI/Contraloría</description>
        <field>MX_RTE_Organo_de_sanci_n__c</field>
        <literalValue>RCI/Contraloría</literalValue>
        <name>Actualiza a RCI/Contraloría</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Documentacion</fullName>
        <description>SI se recupera el regustra, regresa al primer paso-</description>
        <field>MX_RTE_Organo_de_sanci_n__c</field>
        <literalValue>Documentación</literalValue>
        <name>Regresa a Documentación</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
