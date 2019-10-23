<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CRM_WF_Banco_Costo_De_La_Campa_a</fullName>
        <ccEmails>daniel.gonzalez.rodriguez@bbva.com</ccEmails>
        <description>Banco % Costo de la Campaña</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Banco_Costo_Campa_a</template>
    </alerts>
    <rules>
        <fullName>MX_WF_Alerta_Banco_Costo</fullName>
        <actions>
            <name>CRM_WF_Banco_Costo_De_La_Campa_a</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>CRM_WF_Beneficios__c.CRM_WF_Banco__c</field>
            <operation>greaterThan</operation>
            <value>0.01</value>
        </criteriaItems>
        <description>Regla de flujo de trabajo para la aplicación WF, manda una alerta al usuario definido por  negocio cuando el banco tiene una particiáción monetaria en el costo de una campaña</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
