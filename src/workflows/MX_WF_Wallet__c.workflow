<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>MX_WF_Alerta_de_rechazo_Wallet</fullName>
        <description>Alerta de rechazo Wallet</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Rechazo_promoci_n_Wallet</template>
    </alerts>
    <fieldUpdates>
        <fullName>MX_WF_Wallet_cambia_a_VoBo</fullName>
        <description>Estado de Walllet cambia a VoBo WALLET</description>
        <field>MX_WF_Estado__c</field>
        <literalValue>Vo.Bo. WALLET</literalValue>
        <name>Wallet cambia a VoBo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Wallet_pasa_a_Documentacion</fullName>
        <description>El estado de Wallet pasa a Documentación</description>
        <field>MX_WF_Estado__c</field>
        <literalValue>Documentación</literalValue>
        <name>Wallet pasa a Documentación</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Wallet_pasa_a_aprobado</fullName>
        <description>El estado de Wallet pasa a Aprobado</description>
        <field>MX_WF_Estado__c</field>
        <literalValue>Aprobado</literalValue>
        <name>Wallet pasa a aprobado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
