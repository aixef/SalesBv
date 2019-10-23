<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CRM_WF_Alerta_de_modificacion_por_parte_del_asesor_comercial</fullName>
        <description>Alerta de modificación por parte del asesor comercial</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WF_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Modificacion_por_parte_de_Asesor_Comercial</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Aprobar_Seguimiento</fullName>
        <description>Aprobar Seguimiento</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Aprobar_Seguimiento</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Cambio_Prioridad_Aprobado</fullName>
        <description>Cambio de Prioridad Aprobado</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WF_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>CRM_WF_Crm</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>CRM_WF_Fraudes</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>CRM_WF_Gerencia_Squads</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>CRM_WF_Inteligencia_Comercial</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>CRM_WF_Seguimiento</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>CRM_WF_Seguridad</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Cambio_Prioridad_Aprobado</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Cambio_Prioridad_Rechazado</fullName>
        <description>Cambio de Prioridad Rechazado</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WF_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Cambio_Prioridad_Rechazado</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Campana_Aprobada</fullName>
        <description>Campaña Aprobada</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WF_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Campana_Aprobada</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Campana_Rechazada</fullName>
        <description>Campaña Rechazada</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WF_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Campana_Rechazada</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Prioridad_Cambio_A_Urgente</fullName>
        <description>Prioridad cambia a Urgente</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Prioridad_Cambio_A_Urgente</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Solicitud_Cambio_Prioridad</fullName>
        <description>Solicitud de cambio de prioridad</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WF_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>CRM_WF_Crm</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Solicitud_De_Cambio_Prioridad</template>
    </alerts>
    <fieldUpdates>
        <fullName>CRM_WF_Act_Seguimiento_Aprobado</fullName>
        <field>CRM_WF_Estatus_De_Seguimiento__c</field>
        <literalValue>Aprobado</literalValue>
        <name>Seguimiento campaña cambia a aprobado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Act_Seguimiento_Pendiente</fullName>
        <field>CRM_WF_Estatus_De_Seguimiento__c</field>
        <literalValue>Pendiente</literalValue>
        <name>Seguimiento campaña cambia a pendiente</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Act_Seguimiento_Rechazado</fullName>
        <field>CRM_WF_Estatus_De_Seguimiento__c</field>
        <literalValue>Rechazado</literalValue>
        <name>Seguimiento campaña cambia a rechazado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Adquirente_No_Requiere_Checklist</fullName>
        <field>Requiere_Checklist__c</field>
        <literalValue>No</literalValue>
        <name>Adquirente No Requiere Checklist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Est_Validacion_Aprobada</fullName>
        <field>CRM_WF_Estatus_De_Validacion__c</field>
        <literalValue>Aprobado</literalValue>
        <name>Validacion campaña cambia a aprobado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Est_Validacion_Rechazada</fullName>
        <field>CRM_WF_Estatus_De_Validacion__c</field>
        <literalValue>Rechazado</literalValue>
        <name>Validacion campaña cambia a rechazado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Campana_Ejecucion</fullName>
        <field>Status</field>
        <literalValue>Ejecución</literalValue>
        <name>Etapa Campaña a Ejecución</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Campana_VoBo_Imp</fullName>
        <field>Status</field>
        <literalValue>Vo.Bo. Implementación</literalValue>
        <name>Etapa Campaña a VoBo Implementacion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Igual_Aprobaciones</fullName>
        <field>Status</field>
        <literalValue>Vo.Bo. Carta y/o Brief</literalValue>
        <name>Etapa carta origen cambia a aprobaciones</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Igual_Seguimiento</fullName>
        <field>Status</field>
        <literalValue>Vo.Bo. Seguimiento</literalValue>
        <name>Etapa carta origen cambia a seguimiento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Igual_Solicitud</fullName>
        <field>Status</field>
        <literalValue>Documentación</literalValue>
        <name>Etapa carta origen cambia a solicitud</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Igual_Validacion</fullName>
        <field>Status</field>
        <literalValue>Vo.Bo. CRM</literalValue>
        <name>Etapa carta origen cambia a validacion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Prioridad_Normal</fullName>
        <field>CRM_WF_Prioridad_del__c</field>
        <literalValue>Normal</literalValue>
        <name>Prioridad campaña cambia a Normal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Prioridad_Urgente</fullName>
        <field>CRM_WF_Prioridad_del__c</field>
        <literalValue>Urgente</literalValue>
        <name>Prioridad campaña cambia a Urgente</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Recordtype_Alianzas_Comerciales</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CRM_WF_Alianzas_Comerciales</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Recordtype Alianzas Comerciales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Valor_Duplicado_Campana_Name</fullName>
        <field>CRM_WF_Registro_Duplicado__c</field>
        <formula>Name</formula>
        <name>Valor duplicado Campaña Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Adq_No_Requiere_Criiterios_de_IC</fullName>
        <description>Actualización de Campo que cambio el valor del campo Criiterios de a No</description>
        <field>CRM_WF_Con_Criterios__c</field>
        <literalValue>No</literalValue>
        <name>Adquirente No Requiere Criiterios de IC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Campa_a_revisada_por_Adquirente</fullName>
        <field>MX_WF_Necesita_aprobaci_n_de_Squad__c</field>
        <literalValue>0</literalValue>
        <name>Campaña revisada por Adquirente</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Quitar_check_de_Enviar_alerta</fullName>
        <description>Actualización de campo que quita el check de la casilla &quot;Enviar para aprobación&quot;</description>
        <field>MX_WF_Enviar_alerta_de_correo_Adquirente__c</field>
        <literalValue>0</literalValue>
        <name>Quitar check de Enviar alerta</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Update_Fecha_de_Creacion</fullName>
        <field>MX_WF_Fecha_de_Creacion_Real__c</field>
        <formula>CreatedDate</formula>
        <name>Update Fecha de Creación</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Actualizar etapa de la Campaña a VoBo CRM</fullName>
        <actions>
            <name>CRM_WF_Etapa_Igual_Validacion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Vo.Bo. Seguimiento</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.CRM_WF_Estatus_De_Seguimiento__c</field>
            <operation>equals</operation>
            <value>Aprobado</value>
        </criteriaItems>
        <description>Regla de flujo de trabajo para actualizar la etapa de la campaña a Vo.Bo. CRM cuando la misma ya fue aprobada por seguimiento</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar prioridad de Campaña a Normal</fullName>
        <actions>
            <name>CRM_WF_Cambio_Prioridad_Rechazado</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CRM_WF_Prioridad_Normal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.CRM_WF_Estatus_Cambio_Prioridad_Urg__c</field>
            <operation>equals</operation>
            <value>Rechazado</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar prioridad de Campaña a Urgente</fullName>
        <actions>
            <name>CRM_WF_Cambio_Prioridad_Aprobado</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CRM_WF_Prioridad_Urgente</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.CRM_WF_Estatus_Cambio_Prioridad_Urg__c</field>
            <operation>equals</operation>
            <value>Aprobado</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Adquirente No Requiere Checklist</fullName>
        <actions>
            <name>CRM_WF_Adquirente_No_Requiere_Checklist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>( 1 ) OR ( 2 )</booleanFilter>
        <criteriaItems>
            <field>Campaign.CRM_WF_Area_Solicitante__c</field>
            <operation>equals</operation>
            <value>SQUAD_ADQUIRENCIA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Multipromoción</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MX_WF_ModificaciónAsesorComercial</fullName>
        <actions>
            <name>CRM_WF_Alerta_de_modificacion_por_parte_del_asesor_comercial</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>MX_WF_Quitar_check_de_Enviar_alerta</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.MX_WF_Enviar_alerta_de_correo_Adquirente__c</field>
            <operation>equals</operation>
            <value>true</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MX_WF_Update_Fecha_Creacion</fullName>
        <actions>
            <name>MX_WF_Update_Fecha_de_Creacion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(CreatedDate))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Recordtype igual a Alianzas Comerciales</fullName>
        <actions>
            <name>CRM_WF_Recordtype_Alianzas_Comerciales</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.CRM_WF_Alianzas_Comerciales__c</field>
            <operation>contains</operation>
            <value>Alianzas</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Valor duplicado en Nombre de Campaña</fullName>
        <actions>
            <name>CRM_WF_Valor_Duplicado_Campana_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
