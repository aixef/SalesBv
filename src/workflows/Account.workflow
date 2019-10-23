<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Actualiza_Fecha_de_asignaci_n</fullName>
        <field>Fecha_de_ltima_asignaci_n__c</field>
        <formula>NOW()</formula>
        <name>Actualiza Fecha de asignación</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualiza_Fecha_de_conversi_n</fullName>
        <field>Fecha_de_conversi_n__c</field>
        <formula>NOW()</formula>
        <name>Actualiza Fecha de conversión</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_GrupoAprobado</fullName>
        <field>BPyP_ca_FamilyGaCliente__c</field>
        <literalValue>0</literalValue>
        <name>Miembro Familiar Aprobado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_GrupoRechazado</fullName>
        <field>BPyP_ca_FamilyGaCliente__c</field>
        <literalValue>1</literalValue>
        <name>Miembro Familiar Rechazado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aca_RecuperarFamilyG</fullName>
        <description>Manda a verdadero cuando es rechazado el borrado</description>
        <field>BPyP_ca_RecuperarFamilyG__c</field>
        <literalValue>1</literalValue>
        <name>Recuperar Respaldo Family Group</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_aprp_estatusAprob</fullName>
        <description>Actualiza el estatus de asignación del cliente en el family Group</description>
        <field>Estado__c</field>
        <formula>&quot;Pendiente de Asignación de Family Group&quot;</formula>
        <name>BPyP_aprp_estatusAprob</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_cre_estatusAprobacionPend</fullName>
        <field>Estado__c</field>
        <formula>&quot;Pendiente de Aprobación&quot;</formula>
        <name>BPyP_cre_estatusAprobacionPend</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_cre_estatusAprobado</fullName>
        <description>Actualiza el estatus del registro a aprobado</description>
        <field>Estado__c</field>
        <formula>&quot;Asignación Aprobada&quot;</formula>
        <name>BPyP_cre_estatusAprobado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_cre_estatusRechazo</fullName>
        <description>Elimina la relación al group family relacionado</description>
        <field>Grupo_al_que_pertenece__c</field>
        <name>BPyP_cre_estatusRechazo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_cre_estatusRechazoFG</fullName>
        <description>Actualiza el campo de Family Group</description>
        <field>Estado__c</field>
        <formula>&quot;Asignación de Family GRoup Rechazada&quot;</formula>
        <name>BPyP_cre_estatusRechazoFG</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_cre_registroAprobado</fullName>
        <description>Se actualiza el campo del estatus del registro</description>
        <field>Estado__c</field>
        <formula>&quot;Group Family Aprobado&quot;</formula>
        <name>BPyP_cre_registroAprobado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BPyP_cre_stAprobGF</fullName>
        <description>Actualiza el estatus del Family Group a Aprobado</description>
        <field>Estado__c</field>
        <formula>&quot;Group Family Aprobado&quot;</formula>
        <name>BPyP_cre_stAprobGF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Actualizar_Comercio</fullName>
        <field>GBL_WF_Busqueda_Comercio__c</field>
        <formula>Name</formula>
        <name>Actualizar Comercio</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_WF_Valor_Duplicado_Cliente_Name</fullName>
        <field>GBL_WF_Registro_Duplicado__c</field>
        <formula>Name</formula>
        <name>Valor duplicado Cliente Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ultima_asignacion</fullName>
        <field>Fecha_de_ltima_asignaci_n__c</field>
        <formula>now()</formula>
        <name>Ultima asignación</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Actualización del Comercio</fullName>
        <actions>
            <name>CRM_WF_Actualizar_Comercio</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Flujo de trabajo que actualiza el comercio de la cuenta en la aplicación Workflow</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Fecha de asignación cliente</fullName>
        <actions>
            <name>Actualiza_Fecha_de_asignaci_n</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Se coloca la última fecha de asignación de cliente</description>
        <formula>ISCHANGED( Ownership )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Fecha de conversión</fullName>
        <actions>
            <name>Actualiza_Fecha_de_conversi_n</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Conversi_n__c</field>
            <operation>equals</operation>
            <value>true</value>
        </criteriaItems>
        <description>Se guarda la fecha en que fue convertido de prospecto a cliente</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Última asignación</fullName>
        <actions>
            <name>Ultima_asignacion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Valor duplicado en Nombre de Cliente CRM</fullName>
        <actions>
            <name>CRM_WF_Valor_Duplicado_Cliente_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Agencia,Comercios,Proveedores,Área Solicitante,Grupos Comerciales</value>
        </criteriaItems>
        <description>Flujo de trabajo que no permite duplicar Cuentas con el mismo nombre para los tipos de registro del Workflow de Campañas</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
