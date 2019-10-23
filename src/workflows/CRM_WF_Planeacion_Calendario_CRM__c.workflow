<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CRM_WF_Alerta_Rechazo_Base_Calendario_CRM</fullName>
        <description>Alerta para rechazo de Base en Calendario CRM</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Rechazo_de_Carga_150</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Planeacion_AlertaParaNotificarCuandolaCargadeunaBaseesCancelada</fullName>
        <description>Se envía alerta cuando la carga de una base es cancelada</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Notificacion_de_Cancelacion_de_Carga_de_Base</template>
    </alerts>
    <alerts>
        <fullName>MX_WF_Planeacion_AlertaParaNotificarqueunRegistronecesitaAprobacion</fullName>
        <description>Planeación necesita aprobación</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Planeacion_necesita_aprobacion</template>
    </alerts>
    <fieldUpdates>
        <fullName>CRM_WF_Aprobacion</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Aprobado</literalValue>
        <name>Aprobacion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Aprobado</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Aprobado</literalValue>
        <name>Aprobado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Carga_Aprobada</fullName>
        <description>El estatus cambia a VoBo CRM</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Aprobado</literalValue>
        <name>Carga aprobada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Carga_rechazada</fullName>
        <description>si la carga se rechaza debe volver a documentación el estatus</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Rechazado</literalValue>
        <name>Carga rechazada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Estatus_Cambia_Documentacion</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Documentación</literalValue>
        <name>Estatus cambia a Documentación</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Estatus_Cambia_Lista_Espera</fullName>
        <description>Estado cambia a Validación de carga</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Lista de espera</literalValue>
        <name>Estatus cambia a Lista de Espera</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Estatus_cambia_a_lista</fullName>
        <description>El estatus cambia a Lista de Espera</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Lista de espera</literalValue>
        <name>Estatus cambia a Lista de Espera</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Rechazo</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Rechazado</literalValue>
        <name>Rechazo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Rechazo_Carga</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Rechazado</literalValue>
        <name>Rechazo de carga</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Recuperacion</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Documentación</literalValue>
        <name>Recuperación</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_RecuperacionCRM</fullName>
        <description>Acción de recuperación pasa a documentación</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Documentación</literalValue>
        <name>Recuperación</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
