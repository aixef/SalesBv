<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>MX_WF_Rechazo_de_canal</fullName>
        <description>Rechazo de canal</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Canal_Rechazado</template>
    </alerts>
<alerts>
        <fullName>CRM_WF_Alerta_Arte_Desclub</fullName>
        <description>Alerta para notificar la Aprobación de un Arte Desclub</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>CRM_WR_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>naiby.silva1@bbva.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Alerta_Brief_ArteDesclub_Aprobado</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Alerta_Arte_EG_G1</fullName>
        <description>Alerta para notificar la Aprobación de un Arte</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>CRM_WR_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>naiby.silva1@bbva.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Alerta_Brief_Arte</template>
    </alerts><alerts>
        <fullName>MX_WF_Alerta_JM_planeaci_n_de_recursos</fullName>
        <description>Alerta JM planeación de recursos</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Canal_pasa_a_planeacion_EG</template>
    </alerts>
    <alerts>
        <fullName>MX_WF_Notificaci_n_JM_Generaci_n_copy</fullName>
        <description>Notificación JM Generación copy</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Canal_pasa_a_Generaci_n_copy</template>
    </alerts>
    <alerts>
        <fullName>MX_WF_Alerta_de_bloque_de_contenido_aprobado</fullName>
        <description>Alerta de bloque de contenido aprobado</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Bloque_de_contenido_aprobado</template>
    </alerts>
    <alerts>
        <fullName>MX_WF_Alerta_de_rechazo_de_bloque_de_contenido</fullName>
        <description>Alerta de rechazo de bloque de contenido</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Bloque_de_contenido_rechazado</template>
    </alerts>
<alerts>
        <fullName>MX_WF_Alerta_JM_planeaci_n_de_recursos</fullName>
        <description>Alerta JM planeación de recursos</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Canal_pasa_a_planeacion_EG</template>
    </alerts>
    <alerts>
        <fullName>MX_WF_Notificaci_n_JM_Generaci_n_copy</fullName>
        <description>Notificación JM Generación copy</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Canal_pasa_a_Generaci_n_copy</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Alerta_Arte_EG_G2</fullName>
        <ccEmails>sandrajimena.plascencia.contractor@bbva.com</ccEmails>
        <ccEmails>zaira.duran.contractor@bbva.com</ccEmails>
        <description>Alerta para notificar solicitud de Arte a agencia EG+ (grupo 2)</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WR_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>naiby.silva1@bbva.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Alerta_Brief_Arte</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Alerta_Arte_GM</fullName>
        <ccEmails>jose.trujillo@bbva.com</ccEmails>
        <description>Alerta para notificar solicitud de Arte a agencia Grupo Medios</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WR_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>brendagabriela.mondragon1@bbva.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Alerta_Brief_Arte</template>
    </alerts>
    <alerts>
        <fullName>CRM_WF_Solicitud_de_Tracking_Code</fullName>
        <ccEmails>gerardo.delgado@bbva.com</ccEmails>
        <description>Solicitud de Tracking Code</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WR_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/CRM_WF_Solicitud_de_Tracking_Code</template>
    </alerts>
    <alerts>
        <fullName>MX_WF_Link_Arte_aprobado_JM</fullName>
        <description>Link del Arte aprobado JM</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Link_del_Arte_aprobado_JM</template>
    </alerts>
    <alerts>
        <fullName>MX_WF_Link_del_Arte_aprobado_LB</fullName>
        <description>Link del Arte aprobado LB</description>
        <protected>false</protected>
        <recipients>
            <field>CRM_WR_Buzon_Squad__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>ednadaniela.jimenezdel1@bbva.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Link_Arte_Aprobado_LB</template>
    </alerts>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_a_Inicio_proceso_Approval</fullName>
        <description>Etapa que cambia A Inicio proceso Approval</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Inicio Proceso Approval</literalValue>
        <name>Etapa a Inicio proceso Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_a_Aprobaci_n_material</fullName>
        <description>Actualización de campo que permite cambiar el estado a Aprobación del material</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Aprobación del material</literalValue>
        <name>Etapa cambia a Aprobación de material</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambi_Realiza_ajustes_HTML</fullName>
        <description>Actualización de campo para la aplicación WF que cambia el Estatus a Generacion Copy</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Realizar ajustes en HTML</literalValue>
        <name>Etapa cambia a Realizar ajustes de HTML</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_a_Aprobacion_interna</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Aprobación interna de propuesta</literalValue>
        <name>Etapa cambia a Aprobacion interna de pro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_a_Generacion_Copy</fullName>
        <description>Actualización para la aplicación Workflow. Etapa cambia a Desarrollo Copy</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Generación de Copy</literalValue>
        <name>Etapa cambia a Generacion Copy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Aprobacion_Arte</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Aprobación Arte</literalValue>
        <name>Aprobación  Arte</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Aprobacion_Brief_EG</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Aprobación Brief EG+</literalValue>
        <name>Aprobación Brief EG</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Canal_Etapa_ABrief</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Aprobación Brief JM</literalValue>
        <name>Etapa cambia a Aprobación Brief JM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Canal_Etapa_Aprobado</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Aprobado</literalValue>
        <name>Etapa cambia a Canal Aprobado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Canal_Etapa_DSpot</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Desarrollo Spot</literalValue>
        <name>Etapa cambia a Desarrollo Spot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Canal_Etapa_DStory</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Desarrollo Spot</literalValue>
        <name>Etapa cambia a Desarrollo Story</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Canal_Etapa_Especificaciones</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Especificaciones Pauta</literalValue>
        <name>Etapa cambia a Especificaciones Pauta</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Canal_Etapa_PMedios</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Plan de Medios</literalValue>
        <name>Etapa cambia a Plan de Medios</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Canal_Etapa_Rstory</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Revision Story Board</literalValue>
        <name>Etapa cambia a Revision Story</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Canal_Adaptacion</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Adaptación Materiales</literalValue>
        <name>Etapa Canal cambia a Adaptación</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Canal_Base_de_Datos</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Base de datos</literalValue>
        <name>Etapa Canal cambia a Base de Datos</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Canal_Diseno_Arte</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Diseño Arte</literalValue>
        <name>Etapa Canal cambia a Diseño Arte</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Canal_HTML</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Desarrollo HTML</literalValue>
        <name>Etapa Canal cambia a HTML</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Canal_Match</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Match</literalValue>
        <name>Etapa Canal cambia a Match</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Canal_RevisionArte</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Revisión Arte</literalValue>
        <name>Etapa Canal cambia a Revisión Arte</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Canal_Trackeo</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Trackeo - Preimplementación</literalValue>
        <name>Etapa Canal cambia a Trackeo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_Canal_Workfront</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Proceso Workfront</literalValue>
        <name>Etapa Canal cambia a Workfront</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_Revision_material_JM</fullName>
        <description>Etapa cambia Revision del material JM</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Revisión del material JM</literalValue>
        <name>Etapa cambia a Revision del material JM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_cambia_a_Revisi_n_del_mater</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Revisión del material JM</literalValue>
        <name>Etapa cambia a Revisión del material JM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_cambia_a_Subject_Preheader</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Subject &amp; Preheader</literalValue>
        <name>Etapa cambia a Subject &amp; Preheader</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_a_Subject_Preheader</fullName>
        <description>Etapa a Subject &amp; Preheader</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Subject &amp; Preheader</literalValue>
        <name>Etapa a Subject &amp; Preheader</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_a_Aprob_Subject_Pre</fullName>
        <description>Etapa cambia a Aprob Subject &amp; Preheader</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Aprobación Subject &amp; Preheader</literalValue>
        <name>Etapa cambia a Aprob Subject &amp; Preheader</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_a_Generaci_n_Copy</fullName>
        <description>Actualización de campo para la aplicación WF, cambia la etapa a generación de copy</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Generación de Copy</literalValue>
        <name>Etapa cambia a Generación Copy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Etapa_cambia_a_Cierre</fullName>
        <description>Etapa cambia a Cierre</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Cierre</literalValue>
        <name>Etapa cambia a Cierre</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Aprobacion_Subject_Preheader</fullName>
        <description>Aprobacion Subject &amp; Preheader</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Aprobación Subject &amp; Preheader</literalValue>
        <name>Aprobacion Subject &amp; Preheader</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etap_cabia_Revisin_interna_de_prop</fullName>
        <description>Etapa cambia a Revisión interna de prop</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Revisión interna de propuesta</literalValue>
        <name>Etapa cambia a Revisión interna de prop</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_a_Subject_Preheader</fullName>
        <description>Etapa cambia Etapa cambia a Subject &amp; Preheader</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Subject &amp; Preheader</literalValue>
        <name>Etapa cambia a Subject &amp; Preheader</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_realiza_ajustes_HTML</fullName>
        <description>Actualización de campo para la aplicación WF, cambia la etapa Realizar ajustes en HTML</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Realizar ajustes en HTML</literalValue>
        <name>Etapa cambia  realizar ajustes de HTML</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Etapa_a_Aproabacion_Subject_Preheader</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Aprobación Subject &amp; Preheader</literalValue>
        <name>Etapa a Aproabación Subject &amp; Preheader</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Canal_Etapa_Copy</fullName>
        <description>Actualización de campo para la aplicación WF, cambia la etapa a generación de copy</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Generación de Copy</literalValue>
        <name>Etapa cambia a Generación Copy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_a_Desarrollo_HTM</fullName>
        <description>Actualización de campo para la aplicación WF, cambia la etapa a Desarrollo de HTML</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Desarrollo pieza HTML</literalValue>
        <name>Etapa cambia a Desarrollo HTML</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Canal_Etapa_HTML</fullName>
        <description>Actualización de campo para la aplicación WF, cambia la etapa a Desarrollo de HTML</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Desarrollo pieza HTML</literalValue>
        <name>Etapa cambia a Desarrollo HTML</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Canal_Etapa_RMaterial</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Revisión del material JM</literalValue>
        <name>Etapa cambia a Revisión Material</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_a_Revision_final_Copy</fullName>
        <description>Actualización de campo para la aplicación WF, cambia la etapa a Revision fin de Copy</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Revisión final de copy</literalValue>
        <name>Etapa cambia a Revision final Copy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Canal_Etapa_cambia_a_Planeacion</fullName>
        <description>Actualización para la aplicación WF, cambia la etapa a planeación de recursos</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Planeación y asignación de recursos</literalValue>
        <name>Etapa cambia a Planeación</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Email_cambia_Silverpop_con_cambios</fullName>
        <description>Cambia el tipo de registro a Silverpop con cambios</description>
        <field>RecordTypeId</field>
        <lookupValue>Email_Silverpop_con_cambios</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Email cambia a Silverpop con cambios</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_Cambia_Aprob_Interna_Prop</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Aprobación interna de propuesta</literalValue>
        <name>Etapa cambia a Aprobación interna de pro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_Cambia_Processo_Approval</fullName>
        <description>Cambia el valor de la etapa a Proceso approval marketing cloud</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Proceso approval marketing cloud</literalValue>
        <name>Etapa cambia a proceso approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_Cambia_Revision_Comentarios</fullName>
        <description>Actualización de campo para la aplicación WF, la etapa cambiia a Revision de comentarios</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Revisión de comentarios</literalValue>
        <name>Etapa cambia a Revisión de comentarios</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_Cambia_Revision_Final_Arte</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Revisión final de arte</literalValue>
        <name>Etapa cambia a revisión final arte</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_Cambia_Revision_Final_Cont</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Revisión final de content</literalValue>
        <name>Etapa cambia a revisión final content</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_Cambia_Revision_Final_Copy</fullName>
        <description>Actualización de campo para la aplicación WF, la etapa cambia a revisión final de copy</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Revisión final de copy</literalValue>
        <name>Etapa cambia a revisión final copy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_Cambia_Revision_Final_Proof</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Revisión final de proof</literalValue>
        <name>Etapa cambia a revisión final proof</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_Cambia_Subir_Editable_Drive</fullName>
        <description>Actualización para la aplicaci+on WF cambia el estatus a subir editable a drive</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Subir editable a Drive</literalValue>
        <name>Etapa cambia a subir editable a Drive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_Revision_Interna</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Revisión interna de propuesta</literalValue>
        <name>Etapa cambia a Revisión interna de prop</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_Aprobacion_Brief_Art</fullName>
        <description>Actualización de campo para la aplicación WF, cambia la etapa a aprobación bref arte</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Aprobación Brief Arte</literalValue>
        <name>Etapa cambia a Aprobación Brief Arte</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_Realizar_Ajustes_HTML</fullName>
        <description>Actualización de campo para la aplicación WF, en la que la etapa cambia a Realizar ajustes HTML</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Realizar ajustes en HTML</literalValue>
        <name>Etapa cambia a Realizar ajustes HTML</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_a_Brief_Arte</fullName>
        <description>Actualización de campo para la aplicación WF, cambia al inicio de la etapa</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Brief Arte</literalValue>
        <name>Etapa cambia a Brief Arte</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_a_HTML_y_Copy</fullName>
        <description>Actualización para la aplicación Workflow. Etapa cambia a Desarrollo de pieza HTML y Copy</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Desarrollo pieza HTML y Copy</literalValue>
        <name>Etapa cambia a HTML y Copy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_a_Inicio_Proceso_Appr</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Inicio Proceso Approval</literalValue>
        <name>Etapa cambia a Inicio Proceso Approv</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_a_Proof_HQ</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Proof HQ</literalValue>
        <name>Etapa cambia a Proof HQ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_a_ajustes_HTML_y_copy</fullName>
        <description>Actualización de campo para la aplicación WF que cambia el Estatus a Realizar ajustes HTML y Copy</description>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Realizar ajustes en HTML y Copy</literalValue>
        <name>Etapa cambia a ajustes HTML y copy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Etapa_cambia_a_cierre</fullName>
        <field>CRM_WF_Estatus__c</field>
        <literalValue>Cierre</literalValue>
        <name>Etapa cambia a cierre</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Link_arte_aprobado_a_Nulo</fullName>
        <field>MX_WF_URL_Final_Del_Arte__c</field>
        <name>Link arte aprobado a Nulo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Preheader_cambia_a_Null</fullName>
        <field>CRM_WF_Preheader__c</field>
        <name>Preheader cambia a Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Registro_cambia_Desclub_Cambios</fullName>
        <description>Actualización de campo para la aplicación Workflow que cambia el tipo de registro a Desclub con cambios</description>
        <field>RecordTypeId</field>
        <lookupValue>MX_WF_Email_Desclub_Con_Cambios</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Registro cambia a Desclub con cambios</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Registro_cambia_Email_Cambios</fullName>
        <description>Actualizción de campo para la aplicación WF que permite cambiar el tipo de registro a email con cambios</description>
        <field>RecordTypeId</field>
        <lookupValue>MX_WF_Email_Aplicacion_de_Cambios</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Registro cambia a email con cambios</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Si_se_versiona</fullName>
        <description>Actualización para la aplicación WF, cambia la lista de selección para que se versione el 
Arte</description>
        <field>MX_WF_Crear_Una_Nueva_Version__c</field>
        <literalValue>Sí</literalValue>
        <name>Sí se versiona</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Subject_cambia_a_Null</fullName>
        <field>CRM_WF_Subject__c</field>
        <name>Subject cambia a Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Suma_1_en_versiones</fullName>
        <description>Actualización de campo para la aplicación WF, que te suma un 1 al campo de conteo versiones</description>
        <field>MX_WF_Conteo_De_Versiones__c</field>
        <formula>MX_WF_Conteo_De_Versiones__c + 1</formula>
        <name>Suma 1 en versiones</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MX_WF_Link_Arte_Aprobado_LB</fullName>
        <actions>
            <name>MX_WF_Link_del_Arte_aprobado_LB</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CRM_WF_Artes__c.MX_WF_URL_Final_Del_Arte__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MX_WF_MandarAlertaJM</fullName>
        <active>false</active>
        <booleanFilter>1 AND ( 2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>CRM_WF_Artes__c.CRM_WF_Estatus__c</field>
            <operation>equals</operation>
            <value>Subject &amp; Preheader</value>
        </criteriaItems>
        <criteriaItems>
            <field>CRM_WF_Artes__c.CRM_WF_Preheader__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CRM_WF_Artes__c.CRM_WF_Subject__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
