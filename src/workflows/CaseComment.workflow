<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MX_SB_SAC_updCampoPublico</fullName>
        <description>Actualizar el campo de público a true para que todos los usuario puedan verlo</description>
        <field>IsPublished</field>
        <literalValue>1</literalValue>
        <name>Actualizar campo a público</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MS_SB_SAC_comentariosPublicos</fullName>
        <actions>
            <name>MX_SB_SAC_updCampoPublico</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CaseComment.CommentBody</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <description>Sirve para poner los comentarios públicos (cualquier usuario podrá verlo)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
