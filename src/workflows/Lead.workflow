<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Primera_Notificacion</fullName>
        <description>Primera Notificacion</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notificacion_15_Minutos</template>
    </alerts>
    <alerts>
        <fullName>Segunda_Notificacion_Leads</fullName>
        <description>Segunda Notificacion Leads</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notificacion_30_Minutos</template>
    </alerts>
    <alerts>
        <fullName>Tercera_Notificacion_Leads</fullName>
        <description>Tercera Notificacion Leads</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notificacion_45_Minutos</template>
    </alerts>
    <fieldUpdates>
        <fullName>Activar_Tercera_Notificacion</fullName>
        <description>Se encarga de disparar la actualizacion de campo 30 minutos despues de la hora de contacto</description>
        <field>Tercera_Notificacion__c</field>
        <literalValue>1</literalValue>
        <name>Activar Tercera Notificacion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualiza_tipo_de_registro</fullName>
        <description>Actualiza el tipo de registro ASD</description>
        <field>RecordTypeId</field>
        <lookupValue>ASD</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Actualiza tipo de registro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_Segunda_Notificacion</fullName>
        <description>Se encarga de actualizar la segunda notificacion</description>
        <field>Segunda_Notificacion__c</field>
        <literalValue>1</literalValue>
        <name>Actualizar Segunda Notificacion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actulizar_Primera_Notificacion</fullName>
        <description>Actuliza en true el campo</description>
        <field>Primera_Notificacion__c</field>
        <literalValue>1</literalValue>
        <name>Actulizar Primera Notificacion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LeadSeguroFronterizo</fullName>
        <description>Cuando el producto sea Seguro de auto fronterizo este debe cambiar a Seguro Fronterizo</description>
        <field>Producto_Interes__c</field>
        <literalValue>Seguro Fronterizo</literalValue>
        <name>Seguro Fronterizo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_VTS_LeadStageUp</fullName>
        <description>Actualiza la etapa inicial al crear un Lead</description>
        <field>Status</field>
        <literalValue>Contacto</literalValue>
        <name>Actualizar etapa Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_VTS_LeadUpTelemarketing</fullName>
        <description>Actualizar el valor de tipo de registro Telemarketing</description>
        <field>RecordTypeId</field>
        <lookupValue>MX_SB_VTS_Telemarketing</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Actualizar a tipo registro Telemarketing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SeguroLegalizado</fullName>
        <field>Producto_Interes__c</field>
        <literalValue>Seguro Legalizado</literalValue>
        <name>Seguro de auto legalizado = Seguro Legal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Activar Primera Notificación</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Llamada_Realizada__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Hora_contacto__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Primera_Notificacion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Se encarga de activar la primera notificacion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Actulizar_Primera_Notificacion</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Lead.Hora_de_contacto_15_min__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Lead.Hora_de_contacto_30_min__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Lead.Hora_de_contacto_45_min__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Activar Segunda Notificación</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Llamada_Realizada__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Hora_contacto__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Segunda_Notificacion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Se encarga de activar la Segunda notificacion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Actualizar_Segunda_Notificacion</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Lead.Hora_de_contacto_30_min__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Activar Tercera Notificación</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Llamada_Realizada__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Hora_contacto__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Tercera_Notificacion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Se encarga de activar la Tercera notificacion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Activar_Tercera_Notificacion</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Lead.Hora_de_contacto_45_min__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Actualiza tipo de registro por producto ASD</fullName>
        <actions>
            <name>Actualiza_tipo_de_registro</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Call me back</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Producto_Interes__c</field>
            <operation>equals</operation>
            <value>Auto Seguro Dinamico,Seguro Fronterizo,Seguro de Moto Bancomer</value>
        </criteriaItems>
        <description>Actualiza el tipo de registro de acuerdo a los productos. ASD</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Asignar tipo registro ramo Personas y Daños</fullName>
        <actions>
            <name>MX_SB_VTS_LeadStageUp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MX_SB_VTS_LeadUpTelemarketing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Call me back</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Producto_Interes__c</field>
            <operation>contains</operation>
            <value>Hogar,Vida</value>
        </criteriaItems>
        <description>Cambiar tipo de registro para los productos que pertenecen a los ramos de Personas y Daños</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Enviar Segunda Notificacion</fullName>
        <actions>
            <name>Segunda_Notificacion_Leads</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Envia la Segunda notificacion</description>
        <formula>AND (ISCHANGED( Segunda_Notificacion__c ),Primera_Notificacion__c, Segunda_Notificacion__c,Llamada_Realizada__c=False )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Enviar Tercera Notificacion</fullName>
        <actions>
            <name>Tercera_Notificacion_Leads</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Envia la Tercera notificacion</description>
        <formula>AND (ISCHANGED( Tercera_Notificacion__c ),Primera_Notificacion__c, Segunda_Notificacion__c, Tercera_Notificacion__c,Llamada_Realizada__c=False )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Enviar primera notificacion</fullName>
        <actions>
            <name>Primera_Notificacion</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Envia la primera notificacion</description>
        <formula>AND (ISCHANGED( Primera_Notificacion__c ),Primera_Notificacion__c,  Llamada_Realizada__c=False )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Seguro de auto fronterizo %3D Seguro fronterizo</fullName>
        <actions>
            <name>LeadSeguroFronterizo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Producto_Interes__c</field>
            <operation>contains</operation>
            <value>Seguro de auto fronterizo</value>
        </criteriaItems>
        <description>Cuando se envíe Seguro de auto fronterizo debe cambiar a Seguro Fronterizo</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Seguro de auto legalizado %3D Seguro Legalizado</fullName>
        <actions>
            <name>SeguroLegalizado</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Producto_Interes__c</field>
            <operation>contains</operation>
            <value>Seguro de auto legalizado,LEGALIZADOS</value>
        </criteriaItems>
        <description>Cuando se envíe Seguro de auto legalizado debe cambiar a Seguro Legalizado</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
