<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CRM_WF_Mod_De_Campa_a_Autorizada</fullName>
        <description>Modificación de Campaña Autorizada</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WF_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Mod_De_Campana_Aprobada</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Mod_De_Campana_Rechazada</fullName>
        <description>Modificación de Campaña Rechazada</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WF_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Mod_De_Campana_Rechazada</template>
    </alerts>
    <fieldUpdates>
        <fullName>CRM_WF_Estado_De_Modificacion_Aprobado</fullName>
        <field>Estado_de_Modificaci_n__c</field>
        <literalValue>Aprobado</literalValue>
        <name>Estado de Modificación Aprobado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Estado_De_Modificacion_Rechazado</fullName>
        <field>Estado_de_Modificaci_n__c</field>
        <literalValue>Rechazado</literalValue>
        <name>Estado de Modificación Rechazado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Estado_Mod_En_Proceso</fullName>
        <field>Estado_de_Modificaci_n__c</field>
        <literalValue>En Proceso</literalValue>
        <name>Estado de Modificación En Proceso</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Estado_Mod_Vo_Bo_Generador</fullName>
        <field>Estado_de_Modificaci_n__c</field>
        <literalValue>Vo.Bo. Generador</literalValue>
        <name>Estado de Modificación Vo.Bo. Generador</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Modificacion_cambia_a_LB_SUN</fullName>
        <field>Estado_de_Modificaci_n__c</field>
        <literalValue>Vo.Bo. Línea Bancomer/SUN</literalValue>
        <name>Modificacion cambia a LB SUN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
