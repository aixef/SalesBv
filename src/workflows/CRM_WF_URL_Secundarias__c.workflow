<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CRM_WF_Actualiza_URL_Texto</fullName>
        <description>Actualiza el campo de URL Texto si el campo ¿Cual es la URL? No es nulo</description>
        <field>CRM_WF_URL_Text__c</field>
        <formula>CRM_WF_Cual_Es_La_URL__c</formula>
        <name>Actualiza URL Texto</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CRM_WF_Actualizar_URL</fullName>
        <actions>
            <name>CRM_WF_Actualiza_URL_Texto</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT( ISBLANK( CRM_WF_Cual_Es_La_URL__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
