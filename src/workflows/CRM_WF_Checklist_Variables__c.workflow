<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>MX_WF_Notificaci_n_a_LB_de_un_nuevo_Checklist_Variable_creado</fullName>
        <description>Notificación a LB de un nuevo Checklist Variable creado</description>
        <protected>false</protected>
        <recipients>
            <recipient>ednadaniela.jimenezdel1@bbva.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Checklist_Variable_LB</template>
    </alerts>
    <rules>
        <fullName>MX_WF_Creacion_De_Nuevo_Checklist_Variable</fullName>
        <actions>
            <name>MX_WF_Notificaci_n_a_LB_de_un_nuevo_Checklist_Variable_creado</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CRM_WF_Checklist__c.CRM_WF_Estatus_Checklist__c</field>
            <operation>equals</operation>
            <value>Aprobado</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
