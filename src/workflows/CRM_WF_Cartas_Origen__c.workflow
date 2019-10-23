<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CRM_WF_Aprobar_Carta_Origen</fullName>
        <description>Aprobar Carta Origen</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Aprobar_Carta_Origen</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Carta_Origen_Autorizada</fullName>
        <description>Carta Origen Autorizada</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>CRM_WF_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Carta_Origen_Autorizada</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Carta_Origen_Cancelada_CRM</fullName>
        <description>Carta Origen Cancelada CRM</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>CRM_WF_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>bfinteligenciacomercial.mx@bbva.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>campanas.crm.mx@bbva.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Carta_Origen_Cancelada</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Carta_Origen_Cancelada_Fraudes</fullName>
        <description>Carta Origen Cancelada Fraudes</description>
        <protected>false</protected>
        <recipients>
            <recipient>juancarlos.arenas1@bbva.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Carta_Origen_Cancelada</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Carta_Origen_Cancelada_Seg</fullName>
        <description>Carta Origen Cancelada Seguridad</description>
        <protected>false</protected>
        <recipients>
            <recipient>bfautorizaseg.mx1@bbva.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Carta_Origen_Cancelada</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Carta_Origen_Rechazada</fullName>
        <description>Carta Origen Rechazada</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>CRM_WF_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Carta_Origen_Rechazada</template>
    </alerts>
    <fieldUpdates>
        <fullName>CRM_WF_Aprob_Extension_Borrado_Inf</fullName>
        <field>CRM_WF_Ap_De_Extension_Borrado_Inf__c</field>
        <formula>CRM_WF_Sol_De_Extension_Borrado_Inf__c</formula>
        <name>Aprobación Extensión en Borrado de Inf</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Autorizacion_CRM</fullName>
        <field>CRM_WF_Etapa_Carta_Custodia__c</field>
        <literalValue>Autorización CRM</literalValue>
        <name>Carta Origen Autorizacion Crm</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Autorizacion_Fraudes</fullName>
        <field>CRM_WF_Etapa_Carta_Custodia__c</field>
        <literalValue>Autorización Fraudes</literalValue>
        <name>Carta Origen Autorizacion Fraudes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Autorizacion_Generador</fullName>
        <field>CRM_WF_Etapa_Carta_Custodia__c</field>
        <literalValue>Autorización Generador</literalValue>
        <name>Carta Origen Autorización Generador</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Autorizacion_IC</fullName>
        <field>CRM_WF_Etapa_Carta_Custodia__c</field>
        <literalValue>Autorización Inteligencia Comercial</literalValue>
        <name>Carta Origen Autorizacion IC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Autorizacion_Seguridad</fullName>
        <field>CRM_WF_Etapa_Carta_Custodia__c</field>
        <literalValue>Autorización Seguridad</literalValue>
        <name>Carta Origen Autorizacion Seguridad</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Carta_Origen_Readonly</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CRM_WF_Carta_Origen_Readonly</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Carta Origen Readonly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Carta_Igual_Aprobada</fullName>
        <field>CRM_WF_Etapa_Carta_Custodia__c</field>
        <literalValue>Aprobada</literalValue>
        <name>Etapa carta origen cambia a aprobada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Carta_Igual_Cancelada</fullName>
        <field>CRM_WF_Etapa_Carta_Custodia__c</field>
        <literalValue>Cancelada</literalValue>
        <name>Etapa carta origen cambia a cancelada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Carta_Igual_Rechazada</fullName>
        <field>CRM_WF_Etapa_Carta_Custodia__c</field>
        <literalValue>Rechazada</literalValue>
        <name>Etapa carta origen cambia a rechazada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Carta_Igual_Solicitud</fullName>
        <description>La etapa de la Carta Origen cambia a Solicitud</description>
        <field>CRM_WF_Etapa_Carta_Custodia__c</field>
        <literalValue>Solicitud</literalValue>
        <name>Etapa carta origen cambia a solicitud</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Fecha_Aprobacion_Seguridad</fullName>
        <field>CRM_WF_Fecha_Aprobacion_Seguridad__c</field>
        <formula>NOW ()</formula>
        <name>Fecha de aprobacion seguridad</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Fecha_Aprobada_Ext</fullName>
        <field>CRM_WF_Fecha_Aprobada_Ext_Borrado__c</field>
        <formula>CRM_WF_Fecha_Solicitud_De_Ext_Borrado__c</formula>
        <name>Fecha aprobada de extensión</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Fecha_Inicio_Carta_Origen</fullName>
        <field>CRM_WF_A_Partir_De__c</field>
        <formula>NOW ()</formula>
        <name>Fecha de inicio Carta Origen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Actualizar Carta Origen a Cancelada</fullName>
        <actions>
            <name>CRM_WF_Etapa_Carta_Igual_Cancelada</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CRM_WF_Cartas_Origen__c.CRM_WF_Desea_Cancelar_La_Carta_Origen__c</field>
            <operation>equals</operation>
            <value>Si</value>
        </criteriaItems>
        <description>Regla de flujo de trabajo para cambiar la etapa de la carta origen a cancelada</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Carta Origen Cancelada CRM</fullName>
        <actions>
            <name>CRM_WF_Carta_Origen_Cancelada_CRM</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 3) OR (2 AND 3)</booleanFilter>
        <criteriaItems>
            <field>CRM_WF_Cartas_Origen__c.CRM_WF_Tipo_de_Envio__c</field>
            <operation>equals</operation>
            <value>Interno</value>
        </criteriaItems>
        <criteriaItems>
            <field>CRM_WF_Cartas_Origen__c.CRM_WF_Tipo_de_Envio__c</field>
            <operation>equals</operation>
            <value>Externo</value>
        </criteriaItems>
        <criteriaItems>
            <field>CRM_WF_Cartas_Origen__c.CRM_WF_Etapa_Carta_Custodia__c</field>
            <operation>equals</operation>
            <value>Cancelada</value>
        </criteriaItems>
        <description>Flujo de trabajo que envía una notificación a los aprobadores de CRM cuando una Carta Origen es Cancelada y el Tipo de envío es igual a Interno o Externo</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Carta Origen Cancelada Fraudes</fullName>
        <actions>
            <name>CRM_WF_Carta_Origen_Cancelada_Fraudes</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CRM_WF_Cartas_Origen__c.CRM_WF_Etapa_Carta_Custodia__c</field>
            <operation>equals</operation>
            <value>Cancelada</value>
        </criteriaItems>
        <criteriaItems>
            <field>CRM_WF_Cartas_Origen__c.CRM_WF_Requiere_Aprobacion_De_Fraudes__c</field>
            <operation>equals</operation>
            <value>Si</value>
        </criteriaItems>
        <description>Flujo de trabajo que envía una notificación a los aprobadores de Fraudes cuando una Carta Origen es Cancelada y el campo ¿Requiere Tarjeta en Claro? es igual a &quot;Si&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Carta Origen Cancelada Seguridad</fullName>
        <actions>
            <name>CRM_WF_Carta_Origen_Cancelada_Seg</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>CRM_WF_Cartas_Origen__c.CRM_WF_Tipo_de_Envio__c</field>
            <operation>equals</operation>
            <value>Externo</value>
        </criteriaItems>
        <criteriaItems>
            <field>CRM_WF_Cartas_Origen__c.CRM_WF_Canales_Com_Carta_Custodia__c</field>
            <operation>notEqual</operation>
            <value>Correo Electrónico</value>
        </criteriaItems>
        <criteriaItems>
            <field>CRM_WF_Cartas_Origen__c.CRM_WF_Etapa_Carta_Custodia__c</field>
            <operation>equals</operation>
            <value>Cancelada</value>
        </criteriaItems>
        <description>Flujo de trabajo que envía una notificación a los aprobadores de Seguridad cuando una Carta Origen es Cancelada, el Tipo de envío es igual a externo y el Canal de Comunicación es distinto a Correo Electrónico</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
