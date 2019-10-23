<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
<fieldUpdates>
        <fullName>ActTipodeRegistroOppSinPoliza</fullName>
        <description>Cuando la Opp nazca de un caso y el producto que se oferta no sea del ramo auto</description>
        <field>RecordTypeId</field>
        <lookupValue>MX_SB_SAC_SinPoliza</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Act. Tipo de Registro - Opp sin Poliza</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualiza</fullName>
        <field>CorreoVerificacionEnviado__c</field>
        <literalValue>No enviado</literalValue>
        <name>Actualiza Correo Verifcación</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ActualizaCampoNoRenovo</fullName>
        <field>NoRenovo__c</field>
        <literalValue>1</literalValue>
        <name>Actualiza campo No Renovo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ActualizaCorreoCoolDrive</fullName>
        <description>Actualiza el valor del campo a No enviado</description>
        <field>Correo_cool_drive__c</field>
        <literalValue>No enviado</literalValue>
        <name>ActualizaCorreoCoolDrive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ActualizaCorreoElectronico</fullName>
        <field>correoElectronicoContratante__c</field>
        <formula>Account.PersonContact.Account.PersonContact.Email</formula>
        <name>Actualiza Correo Electrónico</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualiza_fecha_de_cierre</fullName>
        <description>Se actualiza la fecha de cierre de acuerdon con la fecha que se concluye el ciclo de la Oportunidad</description>
        <field>CloseDate</field>
        <formula>TODAY()</formula>
        <name>Actualiza fecha de cierre</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ActualizaFechaVenta</fullName>
        <description>Actualiza la fecha de venta cuando el estatus de la cotización pasa a Emitida y no fue carga inicial osea que la esta creando desde SFDC</description>
        <field>Fechaventa__c</field>
        <formula>Now()</formula>
        <name>Actualiza Fecha Venta</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ActualizaFechaVerificacion</fullName>
        <description>Actualiza la fecha de verificación con la fecha hora de ahora</description>
        <field>FechaVerificacion__c</field>
        <formula>NOW()</formula>
        <name>ActualizaFechaVerificacion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ActualizaMotivo</fullName>
        <field>Reason__c</field>
        <literalValue>Venta</literalValue>
        <name>Actualiza Motivo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualiza_Fecha_Nacimiento</fullName>
        <field>Fecha_Nacimiento_Contratante__c</field>
        <formula>Account.Fecha_de_Nacimiento__c</formula>
        <name>Actualiza Fecha Nacimiento</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualiza_telefono_Celular</fullName>
        <description>Actualiza el telefono del contratante</description>
        <field>telefonoCelularContratante__c</field>
        <formula>Account.Telefono_Celular2__c</formula>
        <name>Actualiza telefono Celular</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_Apellido_contratante</fullName>
        <description>Actualiza el apellido del contratante</description>
        <field>apellidoPaternoContratante__c</field>
        <formula>Account.LastName</formula>
        <name>Actualizar Apellido contratante</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_Nombre_Contratante</fullName>
        <field>nombreDelContratante__c</field>
        <formula>Account.FirstName</formula>
        <name>Actualizar Nombre Contratante</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CotiSeguroFronterizo</fullName>
        <description>Cuando el producto sea Seguro de auto fronterizo este debe cambiar a Seguro Fronterizo</description>
        <field>Producto__c</field>
        <literalValue>Seguro Fronterizo</literalValue>
        <name>Seguro Fronterizo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Etapa_Diagnostico</fullName>
        <field>StageName</field>
        <literalValue>Diagnóstico de necesidades</literalValue>
        <name>Etapa Diagnóstico</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HoraEnvioCTI</fullName>
        <field>Horaaproximadaenvio__c</field>
        <formula>NOW()</formula>
        <name>HoraEnvioCTI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PolizaEspejo</fullName>
        <field>PolizaEspejo__c</field>
        <formula>NumerodePoliza__c</formula>
        <name>PolizaEspejo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SeguroLegalizado</fullName>
        <field>Producto__c</field>
        <literalValue>Seguro Legalizado</literalValue>
        <name>Seguro de auto legalizado = Seguro Legal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VentaWeb</fullName>
        <field>Ventaweb__c</field>
        <literalValue>1</literalValue>
        <name>VentaWeb</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>ActTipodeRegistroOppSinPoliza</fullName>
        <description>Cuando la Opp nazca de un caso y el producto que se oferta no sea del ramo auto</description>
        <field>RecordTypeId</field>
        <lookupValue>MX_SB_SAC_SinPoliza</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Act. Tipo de Registro - Opp sin Poliza</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Actualiza Correo Verificación</fullName>
        <actions>
            <name>Actualiza</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Aplicaverificaciondigital__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Actualiza al valor &quot;Correo no Enviado&quot; cuando se marca la casilla &quot;Aplica verificación digital&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Actualiza motivo de la Oportunidad</fullName>
        <actions>
            <name>ActualizaMotivo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ActualizaFechaVerificacion</fullName>
        <actions>
            <name>ActualizaFechaVerificacion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Aplicaverificaciondigital__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.FechaVerificacion__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Actualiza el campo Fecha verificación cuando se activa el campo aplica verificación digital</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ActualizacionesCoolDrive</fullName>
        <actions>
            <name>ActualizaCorreoCoolDrive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Invitacion_cool_drive__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Correo_cool_drive__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Actualiza el campo cool drive para no enviado cuando se active la casilla invitación cool drive</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar datos Contratante</fullName>
        <actions>
            <name>ActualizaCorreoElectronico</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Actualiza_Fecha_Nacimiento</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Actualiza_telefono_Celular</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Actualizar_Apellido_contratante</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Actualizar_Nombre_Contratante</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CargaInicial__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.VieneDeLaInterface__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Se encarga de actualizar los datos de contratante cuando se crea un registro</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Actualiza fecha de cierre</fullName>
        <actions>
            <name>Actualiza_fecha_de_cierre</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Descartada / Rechazada</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Producto en uso</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Crédito dispuesto</value>
        </criteriaItems>
        <description>Cuando se seleccione la etapa Descartada, la fecha de cierre se debera actualizar la fecha en la que se hizo el descarte. De igual forma, cuando la USAC o todos aquellos con permiso de seleccionar la etapa de cerrado (Producto en Uso o Crédito Dispuesto).</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Actualiza Oportunidad Seguros</fullName>
        <actions>
            <name>Etapa_Diagnostico</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>5 AND (1 OR 2 OR 3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Tipo_de_Registro_Manual2__c</field>
            <operation>equals</operation>
            <value>Seguros</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Tipo_de_Registro_Manual2__c</field>
            <operation>equals</operation>
            <value>CIB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Tipo_de_Registro_Manual2__c</field>
            <operation>equals</operation>
            <value>Fiduciario</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Tipo_de_Registro_Manual2__c</field>
            <operation>equals</operation>
            <value>Inversiones</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Administrador del sistema</value>
        </criteriaItems>
        <!-- <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>System Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>DWP Delegados</value>
        </criteriaItems> -->
        <description>Actualiza la oportunidad</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HoraEnvioCTI</fullName>
        <actions>
            <name>HoraEnvioCTI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.EnviarCTI__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Llena fecha de venta II</fullName>
        <actions>
            <name>ActualizaFechaVenta</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Estatus__c</field>
            <operation>equals</operation>
            <value>Emitida</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CargaInicial__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MX_SB_SAC_Act%2ETipodeRegistro</fullName>
        <actions>
            <name>ActTipodeRegistroOppSinPoliza</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Se ocupara cuando la oportunidad nazca de un casa por el SAC y el producto que se este vendiendo</description>
        <formula>NOT(ISPICKVAL(Caso_Relacionado__r.MX_SB_SAC_ProductosVenta__c, &quot;Auto Seguro Dinámico&quot; )) &amp;&amp; 
NOT(ISPICKVAL(Caso_Relacionado__r.MX_SB_SAC_ProductosVenta__c,&quot;&quot;)) &amp;&amp;
RecordType.DeveloperName = &quot;ASD&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mandar a MKT</fullName>
        <actions>
            <name>ActualizaCampoNoRenovo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.ESTATUS_CLIPERT__c</field>
            <operation>equals</operation>
            <value>ANULADA</value>
        </criteriaItems>
        <description>Cuando el campo estatus Clipert este en anulada modificará el campo de no renovo para se pueda mandar la encuesta de No renovado.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PolizaEspejo</fullName>
        <actions>
            <name>PolizaEspejo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>equals</operation>
            <value>THIS YEAR</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Seguro de auto fronterizo %3D Seguro fronterizo</fullName>
        <actions>
            <name>CotiSeguroFronterizo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Producto__c</field>
            <operation>equals</operation>
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
            <field>Opportunity.Producto__c</field>
            <operation>contains</operation>
            <value>Seguro de auto legalizado</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Producto__c</field>
            <operation>contains</operation>
            <value>LEGALIZADOS</value>
        </criteriaItems>
        <description>Cuando se envíe Seguro de auto legalizado debe cambiar a Seguro Legalizado</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VentaWeb</fullName>
        <actions>
            <name>VentaWeb</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Agencia__c</field>
            <operation>contains</operation>
            <value>INTERNET</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
