<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Actualiza_fecha_valoraci_n_DG_RED</fullName>
        <field>Fecha_Valoracion_DG_RED__c</field>
        <formula>TODAY()</formula>
        <name>Actualiza fecha valoración DG RED</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualiza_fecha_valoracion_DD_DR</fullName>
        <field>Fecha_Valoracion_DD_DR__c</field>
        <formula>TODAY()</formula>
        <name>Actualiza fecha valoración DD/DR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualiza_fecha_valoracion_DO</fullName>
        <field>Fecha_Valoracion_DO__c</field>
        <formula>TODAY()</formula>
        <name>Actualiza fecha valoración DO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_AprobacionAceptadaDP</fullName>
        <description>Actualizacion del campo a verdadero una vez que el Director Promocional acepta el Plan de Cuenta</description>
        <field>BPyP_ca_AprobacionDP__c</field>
        <literalValue>1</literalValue>
        <name>Aprobacion aceptada Director Promocional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_AprobacionDD</fullName>
        <description>Utilizado para el proceso de aprobacion</description>
        <field>BPyP_ca_AprobacionDD__c</field>
        <literalValue>1</literalValue>
        <name>Aprobacion aceptada Director Divisio</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_AprobacionDDDO</fullName>
        <description>Actualizacion del campo a falso para aprobación DO</description>
        <field>BPyP_ca_AprobacionDO__c</field>
        <literalValue>0</literalValue>
        <name>Borrado de Aprobacion DO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_AprobacionDDDP</fullName>
        <description>Actualizacion del campo a falseo a la aprobación de DP</description>
        <field>BPyP_ca_AprobacionDP__c</field>
        <literalValue>0</literalValue>
        <name>Borrado de aprobación DP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_AprobacionDO</fullName>
        <description>Actualizacion del campo a verdadero una vez que el Director Oficina acepta el Plan de Cuenta</description>
        <field>BPyP_ca_AprobacionDO__c</field>
        <literalValue>1</literalValue>
        <name>Aprobacion aceptada Director Oficina</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_BorradoAprobacionDD</fullName>
        <description>Borrado de aprobación de Director Divisional</description>
        <field>BPyP_ca_AprobacionDD__c</field>
        <literalValue>0</literalValue>
        <name>Borrado de Aprobacion DD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_BorradoComentariosDD</fullName>
        <description>Borrado de comentarios de Director Divisional</description>
        <field>Comentarios_DDDR__c</field>
        <name>Borrado Comentarios DD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_BorradoComentariosDO</fullName>
        <description>Borrado de comentarios de DO</description>
        <field>Comentarios_DO__c</field>
        <name>Borrado Comentarios DO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_BorradoValoracionDD</fullName>
        <description>Borrado de campo de Valoración de Director Divisional</description>
        <field>Valoracion_DDDR__c</field>
        <name>Borrado Valoración DD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_BorradoValoracionDO</fullName>
        <description>Borrado de valoración de Director de Oficina</description>
        <field>Valoracion_DO__c</field>
        <name>Borrado Valoración DO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_BorradoValoracionDP</fullName>
        <field>BPyP_ls_ValoracionPromocional__c</field>
        <name>Borrado Valoracion DP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_PlanCtaCr</fullName>
        <description>Actualización de campo para CR de plan de cuenta de bpyp</description>
        <field>CR__c</field>
        <formula>Owner:User.CR__c</formula>
        <name>BPyP_aca_PlanCtaCr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_PlanCtaDiv</fullName>
        <description>Campo que actualiza en plan de cuenta la división del plan de cuenta con respecto a la división</description>
        <field>Division__c</field>
        <formula>Owner:User.DivisionFormula__c</formula>
        <name>BPyP_aca_PlanCtaDiv</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_PlanCtaOf</fullName>
        <description>Actualización de campo de plan de cuenta para poner la oficina del propietario del plan de cuenta</description>
        <field>Oficina__c</field>
        <formula>TEXT(Owner:User.BPyP_ls_NombreSucursal__c)</formula>
        <name>BPyP_aca_PlanCtaOf</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_PlanCtaStatApro</fullName>
        <description>Actualización campo Status a Aprobado</description>
        <field>Estatus_Ficha__c</field>
        <literalValue>Aprobado</literalValue>
        <name>BPyP_aca_PlanCtaStatApro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_PlanCtaStatEnApp</fullName>
        <description>Actualización de campo Status a &quot;En aprobación&quot;</description>
        <field>Estatus_Ficha__c</field>
        <literalValue>En aprobación</literalValue>
        <name>BPyP_aca_PlanCtaStatEnApp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_PlanCtaStatRech</fullName>
        <description>Actualización de campo status para rechazado</description>
        <field>Estatus_Ficha__c</field>
        <literalValue>Rechazado</literalValue>
        <name>BPyP_aca_PlanCtaStatRech</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BPyP_rft_PlanCuenta</fullName>
        <actions>
            <name>BPyP_aca_PlanCtaCr</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BPyP_aca_PlanCtaDiv</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BPyP_aca_PlanCtaOf</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Ficha_de_conocimiento__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>BPyP</value>
        </criteriaItems>
        <description>Regla que actualiza campos dependientes del banquero para desplegar en Plan de cuenta</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Fecha Valorización DD%2FDR</fullName>
        <actions>
            <name>Actualiza_fecha_valoracion_DD_DR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(  Valoracion_DDDR__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Fecha Valorización DG RED</fullName>
        <actions>
            <name>Actualiza_fecha_valoraci_n_DG_RED</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(   Valoracion_RED__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Fecha Valorización DO</fullName>
        <actions>
            <name>Actualiza_fecha_valoracion_DO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Valoracion_DO__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
