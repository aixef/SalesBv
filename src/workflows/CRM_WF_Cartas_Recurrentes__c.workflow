<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CRM_WF_Carta_Recurrente_Aprobada</fullName>
        <description>Carta Recurrente Aprobada</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>CRM_WF_Buzun_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Carta_Recurrente_Aprobada</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Not_de_Salida_con_Brief_Buzon</fullName>
        <description>Notificación de Salida con Brief Buzon</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WF_Buzun_Squad__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Notificacion_Salida_con_Brief</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Notificacion_de_Salida_con_Brief</fullName>
        <description>Notificación de Salida con Brief</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WF_Buzun_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>CRM_WF_Inteligencia_Comercial</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Notificacion_Salida_con_Brief</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Rechazo_de_Carta_Recurrente</fullName>
        <description>Rechazo de Carta Recurrente</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WF_Buzun_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Carta_Recurrente_Rechazada</template>
    </alerts>
    <fieldUpdates>
        <fullName>CRM_WF_Carta_R_Cambia_a_Rec_por_Prov</fullName>
        <field>CRM_WF_Etapa_De_Salida_De_Informacion__c</field>
        <literalValue>Base recibida por proveedor</literalValue>
        <name>Etapa Carta R Cambia a Recibida por Prov</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Carta_Rec_Igual_Cancelada</fullName>
        <field>CRM_WF_Etapa_De_Salida_De_Informacion__c</field>
        <literalValue>Cancelada</literalValue>
        <name>Etapa carta recurr cambia a cancelada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Igual_Base_Prov</fullName>
        <field>CRM_WF_Etapa_De_Salida_De_Informacion__c</field>
        <literalValue>Base enviada a proveedor</literalValue>
        <name>Etapa carta r cambia a enviada prov</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Igual_Pendiente</fullName>
        <field>CRM_WF_Etapa_De_Salida_De_Informacion__c</field>
        <literalValue>Pendiente</literalValue>
        <name>Etapa carta r cambia a pendiente</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Fecha_Carga_Seg_Now</fullName>
        <field>CRM_WF_Fecha_De_Carga_Seguridad__c</field>
        <formula>NOW ()</formula>
        <name>Fecha de carga seguridad</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Fecha_Salida_de_Informacion</fullName>
        <field>CRM_WF_Fecha_De_La_C_Recurrente__c</field>
        <formula>NOW ()</formula>
        <name>Fecha de salida de Información</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Actualizar Carta Recurrente a Cancelada</fullName>
        <actions>
            <name>CRM_WF_Etapa_Carta_Rec_Igual_Cancelada</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CRM_WF_Cartas_Recurrentes__c.CRM_WF_Desea_Cancelar_Carta_Recurrente__c</field>
            <operation>equals</operation>
            <value>Si</value>
        </criteriaItems>
        <description>Regla de flujo de trabajo para cambiar la etapa de la carta recurrente a cancelada</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
