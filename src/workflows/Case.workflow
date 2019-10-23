<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EmailFirstResponse</fullName>
        <description>EmailFirstResponse</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_MembretePlantilla</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_BOCierreFolioNoExitoso_CorreoAlterno</fullName>
        <description>MX_SB_SAC_BOCierreFolioNoExitoso - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_BOCierreFolioNoExitoso</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_BOCierreFolioNoExitoso_CorreoCuenta</fullName>
        <description>MX_SB_SAC_BOCierreFolioNoExitoso - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_BOCierreFolioNoExitoso</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_BODocumentacionErronea_CorreoAlterno</fullName>
        <description>MX_SB_SAC_BODocumentacionErronea - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_BODocumentacionErronea</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_BODocumentacionErronea_CorreoCuenta</fullName>
        <description>MX_SB_SAC_BODocumentacionErronea - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_BODocumentacionErronea</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_EnvioCasosBackOffice</fullName>
        <description>Envio de casos a Back Office</description>
        <protected>false</protected>
        <recipients>
            <recipient>MX_SB_SAC_GrupoBackOffice</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MX_SB_SAC_PlantillaEmailSAC</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_CancelacionBOCierreFolio_CorreoAlterno</fullName>
        <description>MX_SB_SAC_CancelacionBOCierreFolio - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_CancelacionBOCierreFolio</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_CancelacionBOCierreFolio_CorreoCuenta</fullName>
        <description>MX_SB_SAC_CancelacionBOCierreFolio - Correo de la cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_CancelacionBOCierreFolio</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_FormatoDevolucion_CorreoCuenta</fullName>
        <description>MX_SB_SAC_Formato de Devolución - Correo de la cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_FormatoDevolucionSac</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_CierreCasoDevolucionBONoExitosoAlterno</fullName>
        <description>MX_SB_SAC_Cierre de Caso Devolucion BO no exitoso - correo alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_FormatoCierreBOSinDevolucionNoExitoso</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_CierreCasoDevolucionBONoExitosoCuenta</fullName>
        <description>MX_SB_SAC_Cierre de Caso Devolucion BO no exitoso - correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_FormatoCierreBOSinDevolucionNoExitoso</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ConsultasFirst_CorreoAlterno</fullName>
        <description>MX_SB_SAC_ConsultasFirst - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ConsultasFirst</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ConsultasFirst_CorreoCuenta</fullName>
        <description>MX_SB_SAC_ConsultasFirst - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ConsultasFirst</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ConsultasNoAutenticacion_CorreoAlterno</fullName>
        <description>MX_SB_SAC_ConsultasNoAutenticacion - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ConsultasNoAutenticacion</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_CierreCasoDevolucionBOExitosoCuenta</fullName>
        <description>MX_SB_SAC_Cierre de Caso Devolucion BO exitoso - correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_DevolucionBOCierreFolioExitoso</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_CierreCasoDevolucionBOExitosoAlterno</fullName>
        <description>MX_SB_SAC_Cierre de Caso Devolucion BO exitoso - correo alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_DevolucionBOCierreFolioExitoso</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ConsultasNoAutenticacion_CorreoCuenta</fullName>
        <description>MX_SB_SAC_ConsultasNoAutenticacion - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ConsultasNoAutenticacion</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_EndososCierre_CorreoAlterno</fullName>
        <description>MX_SB_SAC_EndososCierre - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_EndososCierre</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_EndososCierre_CorreoCuenta</fullName>
        <description>MX_SB_SAC_EndososCierre - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_EndososCierre</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_EnvioCorreoBO_CorreoAlterno</fullName>
        <description>MX_SB_SAC_EnvioCorreoBO_Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_EnvioCorreoBO</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_EnvioCorreoBO_CorreoCuenta</fullName>
        <description>MX_SB_SAC_EnvioCorreoBO_Correo Cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_EnvioCorreoBO</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_EscalarConDocumentos_CorreoAlterno</fullName>
        <description>MX_SB_SAC_Escalar con documentos - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_EscalarConDocumentosUp</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_EscalarConDocumentos_CorreoCuenta</fullName>
        <description>MX_SB_SAC_Escalar con documentos - Correo de la cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_EscalarConDocumentosUp</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_FormatoCancelacion_CorreoAlterno</fullName>
        <description>MX_SB_SAC_Formato de Cancelación - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_FormatoCancelacionSac</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_FormatoCancelacionServicio_CorreoCuenta</fullName>
        <description>MX_SB_SAC_Formato Cancelación Servicio- Correo de la cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_CierreCasoServicioUp</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_FormatoCancelacion_CorreoCuenta</fullName>
        <description>MX_SB_SAC_Formato de Cancelación - Correo de la cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_FormatoCancelacionSac</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_CierreCasoCorreoAlterno</fullName>
        <description>MX_SB_SAC_Cierre de Caso -  Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_CierreCasoUp</template>
    </alerts>
     <alerts>
        <fullName>MX_SB_SAC_CierreCaso</fullName>
        <description>MX_SB_SAC_Cierre de Caso</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_CierreCasoUp</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_EscalarSinDocumentos_CorreoAlterno</fullName>
        <description>MX_SB_SAC_Escalar sin documentos - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_EscalarSinDocumentosUp</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_EscalarSinDocumentos_CorreoCuenta</fullName>
        <description>MX_SB_SAC_Escalar sin documentos - Correo de la cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_EscalarSinDocumentosUp</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_FormatoCancelacionServicio_CorreoAlterno</fullName>
        <description>MX_SB_SAC_Formato Cancelación Servicio- Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_CierreCasoServicioUp</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_FormatoDevolucion_CorreoAlterno</fullName>
        <description>MX_SB_SAC_Formato de Devolución - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_FormatoDevolucionSac</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_FormatoUniversal_CorreoAlterno</fullName>
        <description>MX_SB_SAC_Formato universal - Correo alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_FormatoUniversalUp</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_FormatoUniversal_CorreoCuenta</fullName>
        <description>MX_SB_SAC_Formato universal - Correo de la cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_FormatoUniversalUp</template>
    </alerts>
    <alerts>
        <fullName>MX_RTE_Alerta_Alcance_Final</fullName>
        <description>Alerta que se manda cuando el campo &quot;Alcance final&quot; es modificado.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTE_Plantillas_RTE/MX_RTE_Alerta_Alcance_final</template>
    </alerts>
    <alerts>
        <fullName>EmailFirstResponse</fullName>
        <description>EmailFirstResponse</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_MembretePlantilla</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_EnvioBackOffice</fullName>
        <description>EnvioBackOffice</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_MembretePlantilla</template>
    </alerts>
    <alerts>
        <fullName>MX_WF_Mail_1_Asignacion_Folio</fullName>
        <description>Mail 1 Asignaciòn de Folio</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Mail_1_Asignacion_Folio</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_Retencion_CorreoCuenta</fullName>
        <description>MX_SB_SAC_Retencion - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_Retencion</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_Retencion_CorreoAlterno</fullName>
        <description>MX_SB_SAC_Retencion - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_Retencion</template>
    </alerts>
    <alerts>
        <fullName>MX_WF_Mail_2_3_Aviso_de_Rechazo_Asunto_Cuerpo</fullName>
        <description>Mail 2-3 Aviso de rechazo asunto y cuerpo</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Mail_2_3_Aviso_de_Rechazo_Asunto_Cuerpo</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ServiciosAperturaFormatoUniversal_CorreoAlterno</fullName>
        <description>MX_SB_SAC_ServiciosAperturaFormatoUniversal - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ServiciosAperturaFormatoUniversal</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ServiciosAperturaFolio_CorreoAlterno</fullName>
        <description>MX_SB_SAC_ServiciosAperturaFolio - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ServiciosAperturaFolio</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ServiciosAperturaFormatoUniversal_CorreoCuenta</fullName>
        <description>MX_SB_SAC_ServiciosAperturaFormatoUniversal - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ServiciosAperturaFormatoUniversal</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ServiciosAperturaFolio_CorreoCuenta</fullName>
        <description>MX_SB_SAC_ServiciosAperturaFolio - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ServiciosAperturaFolio</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ServiciosBOCierreFolioNoExitoso_CorreoAlterno</fullName>
        <description>MX_SB_SAC_ServiciosBOCierreFolioNoExitoso - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ServiciosBOCierreFolioNoExitoso</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ServiciosBOCierreFolioNoExitoso_CorreoCuenta</fullName>
        <description>MX_SB_SAC_ServiciosBOCierreFolioNoExitoso - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ServiciosBOCierreFolioNoExitoso</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ServiciosFirstFormatoCancelacion_CorreoAlterno</fullName>
        <description>MX_SB_SAC_ServiciosFirstFormatoCancelacion - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ServiciosFirstFormatoCancelacion</template>
    </alerts>
    <alerts>
        <fullName>MX_WF_Mail_5_6_Asignacion_Caso_Cambio_Estatus</fullName>
        <description>Mail 5-6 Asignaciòn del caso y cambio estatus</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Mail_5_6_Asignacion_Caso_Cambio_Estatus</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ServiciosFirstFormatoCancelacion_CorreoCuenta</fullName>
        <description>MX_SB_SAC_ServiciosFirstFormatoCancelacion - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ServiciosFirstFormatoCancelacion</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ServiciosFirstFormatoUniversal_CorreoAlterno</fullName>
        <description>MX_SB_SAC_ServiciosFirstFormatoUniversal - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ServiciosFirstFormatoUniversal</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ServiciosFirst_CorreoAlterno</fullName>
        <description>MX_SB_SAC_ServiciosFirst - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ServiciosFirst</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ServiciosFirstFormatoUniversal_CorreoCuenta</fullName>
        <description>MX_SB_SAC_ServiciosFirstFormatoUniversal - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ServiciosFirstFormatoUniversal</template>
    </alerts>
    <alerts>
        <fullName>MX_WF_Mail_7_Cierre_Del_Caso</fullName>
        <description>Mail 7 Cierre del Caso</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CRM_WF_Plantillas_WF/MX_WF_Mail_7_Cierre_Del_Caso</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_ALERTA</fullName>
        <description>Alerta</description>
        <protected>false</protected>
        <recipients>
            <recipient>MX_RTL_CSA_Primer_Nivel_Seguros</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_APROBACIONSEGUROS</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_APROBACION</fullName>
        <description>Aprobación</description>
        <protected>false</protected>
        <recipients>
            <recipient>MX_RTL_CSA_Aprobadores_Casos</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_APROBACIONSEGUROS</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_APROBACION_APLICATIVO</fullName>
        <description>Aprobación Aplicativo</description>
        <protected>false</protected>
        <recipients>
            <recipient>MX_RTL_CSA_APROBADORES_APLICATIVO</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_APROBACIONSEGUROS</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_APROBACION_CAMPANAS</fullName>
        <description>Aprobación Campañas</description>
        <protected>false</protected>
        <recipients>
            <recipient>MX_RTL_CSA_APROBADORES_CAMPANIAS</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_APROBACIONSEGUROS</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_APROBACION_CIERRE</fullName>
        <description>Envio de Correo cuando se apruebe el cierre del caso</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_INICIO_DE_APROBACION</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_APROBACION_RETAIL</fullName>
        <description>Aprobación Retail</description>
        <protected>false</protected>
        <recipients>
            <recipient>MX_RTL_CSA_APROBADORES_RETAIL</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_APROBACIONSEGUROS</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_CAMBIODWP</fullName>
        <description>Cambio de Etapa</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_CAMBIODWP</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_CERRADO</fullName>
        <description>Etapa Cerrado</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_CIERREDWP</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_CERRADOPORINSUMOS</fullName>
        <description>Etapa Cerrado por Falta de Insumos</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_ClosedCaseByInsumos</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_CERRADOWEB</fullName>
        <description>Etapa Cerrado Web</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_ClosedCase</template>
    </alerts>
        <alerts>
        <fullName>MX_RTL_CSA_CIERRE_TIEMPO_EXCEDIDO</fullName>
        <description>Etapa Cerrado por Exceso de Tiempo</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_CIERRE_PORTIEMPO</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_ESCALAMIENTO</fullName>
        <description>Escalamiento de Caso</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_ASIGNACIONWEB</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_ETAPA_ANALISIS</fullName>
        <description>Etapa Análisis</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_Etapa_Analisis</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_Etapa_Analisis_Web</fullName>
        <description>Etapa Análisis_web</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_Etapa_Analisis</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_Etapa_Espera</fullName>
        <description>Etapa en Espera de Insumos</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_Etapa_Desarrollo</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_Etapa_Resolucion</fullName>
        <description>Etapa Resolución</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_Etapa_Resolucion</template>
    </alerts>
    <alerts>
        <fullName>MX_RTL_CSA_Etapa_Resolucion_Web</fullName>
        <description>Etapa Resolución Web</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MX_RTL_CSA_PLANTILLASSOP/MX_RTL_CSA_Etapa_Resolucion</template>
    </alerts>
    <alerts>
        <fullName>MX_SB_SAC_ServiciosFirst_CorreoCuenta</fullName>
        <description>MX_SB_SAC_ServiciosFirst - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ServiciosFirst</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_ReactivacionErrorOperativo_CorreoAlterno</fullName>
        <description>MX_SB_SAC_ReactivacionErrorOperativo - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ReactivacionErrorOperativo</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_ReactivacionConDocumentos_CorreoCuenta</fullName>
        <description>MX_SB_SAC_ReactivacionConDocumentos - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ReactivacionConDocumentos</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_ReclamacionesCierreFolioExitoso_CorreoCuenta</fullName>
        <description>MX_SB_SAC_ReclamacionesCierreFolioExitoso - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ReclamacionesCierreFolioExitoso</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_ReclamacionesCierreFolioExitoso_CorreoAlterno</fullName>
        <description>MX_SB_SAC_ReclamacionesCierreFolioExitoso - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ReclamacionesCierreFolioExitoso</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_ReclamacionesAperturaFolio_CorreoCuenta</fullName>
        <description>MX_SB_SAC_ReclamacionesAperturaFolio - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ReclamacionesAperturaFolio</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_ReclamacionesAperturaFolio_CorreoAlterno</fullName>
        <description>MX_SB_SAC_ReclamacionesAperturaFolio - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ReclamacionesAperturaFolio</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_ReactivacionConDocumentos_CorreoAlterno</fullName>
        <description>MX_SB_SAC_ReactivacionConDocumentos - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ReactivacionConDocumentos</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_ReactivacionFirst_CorreoCuenta</fullName>
        <description>MX_SB_SAC_ReactivacionFirst - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ReactivacionFirst</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_ReactivacionFirst_CorreoAlterno</fullName>
        <description>MX_SB_SAC_ReactivacionFirst - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ReactivacionFirst</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_ReactivacionesBOCierreFolioNoExitoso_CorreoCuenta</fullName>
        <description>MX_SB_SAC_ReactivacionesBOCierreFolioNoExitoso - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ReactivacionesBOCierreFolioNoExitoso</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_ReactivacionesBOCierreFolioNoExitoso_CorreoAlterno</fullName>
        <description>MX_SB_SAC_ReactivacionesBOCierreFolioNoExitoso - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ReactivacionesBOCierreFolioNoExitoso</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_ReactivacionErrorOperativo_CorreoCuenta</fullName>
        <description>MX_SB_SAC_ReactivacionErrorOperativo - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_ReactivacionErrorOperativo</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_CotizacionNoExitosa_CorreoCuenta</fullName>
        <description>MX_SB_SAC_CotizacionNoExitosa - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_CotizacionNoExitosa</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_CotizacionNoExitosa_CorreoAlterno</fullName>
        <description>MX_SB_SAC_CotizacionNoExitosa - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_CotizacionNoExitosa</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_VentasASD_CorreoCuenta</fullName>
        <description>MX_SB_SAC_VentasASD - Correo cuenta</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_VentasASD</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_VentasASD_CorreoAlterno</fullName>
        <description>MX_SB_SAC_VentasASD - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_VentasASD</template>
    </alerts>
	<alerts>
        <fullName>MX_SB_SAC_BODocumentacionRecibidaCorrecta_CorreoAlterno</fullName>
        <description>MX_SB_SAC_BODocumentacionRecibidaCorrecta - Correo Alterno</description>
        <protected>false</protected>
        <recipients>
            <field>MX_SB_SAC_CorreoCuenta__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>karenbelemsanchezruiz@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MX_SB_SAC_Plantillas/MX_SB_SAC_BODocumentacionRecibidaCorrecta</template>
    </alerts>
    <fieldUpdates>
        <fullName>Act_comentarios_de_caso</fullName>
        <description>se Agregaran comentarios estándar a los casos cerrados por falta de información</description>
        <field>Description</field>
        <formula>&quot;Caso cerrado por falta de documentos por el cliente o información incorrecta&quot;</formula>
        <name>Act. comentarios de caso</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>MX_SB_SAC_QuitarCheckCorreoEnviado</fullName>
        <field>MX_SB_SAC_CorreoEnviado__c</field>
        <literalValue>0</literalValue>
        <name>Quitar Check correo enviado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
	 <fieldUpdates>
        <fullName>MX_SB_SAC_QuitarCheckCorreoEnviadoBO</fullName>
        <field>MX_SB_SAC_CorreoEnviadoBO__c</field>
        <literalValue>0</literalValue>
        <name>Quitar Check correo enviado BO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Aprobacion_Pentagono</fullName>
        <description>La fase de la feature cambia a Aprobación Pentágono</description>
        <field>MX_RTE_Fase__c</field>
        <literalValue>Aprobación Pentágono</literalValue>
        <name>Aprobación Pentágono</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_PyME_Case_Aprobacion_division_destino</fullName>
        <description>Bandera de aprobación por divisional origen</description>
        <field>MX_EU_Apoyo_oportunidad__c</field>
        <literalValue>1</literalValue>
        <name>Aprobación división destino</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_PyME_Case_Aprobacion_division_origen</fullName>
        <description>Bandera de aprobación por divisional origen</description>
        <field>MX_EU_Apoyo_cliente__c</field>
        <literalValue>1</literalValue>
        <name>Aprobación división origen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_ActCheckAtencionBO</fullName>
        <description>Campo que se actualizara cuando se asigne un caso al BO  y que servirá para de reportes</description>
        <field>MX_SB_SAC_FolioOperadoporBO__c</field>
        <literalValue>Si</literalValue>
        <name>Act. Check atencion de BO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_ActCheckCierrefaltaDoc</fullName>
        <description>servirá para identificar cuales son los folios que se cierran por falta de información o de documentos que no envió el cliente</description>
        <field>MX_SB_SAC_FaltaDocInffaltante__c</field>
        <literalValue>1</literalValue>
        <name>Act. Check Cierre por falta de Doc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_ActTipoRegistroAccidentesPerso</fullName>
        <description>Actualizar el Tipo de registro de Accidentes Personales</description>
        <field>RecordTypeId</field>
        <lookupValue>MX_SB_SAC_RTAccidentesPersonales</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Actualizar tipo de registro Accidentes P</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_ActTipoRegistroAuto</fullName>
        <description>Actualizar tipo de registro para auto</description>
        <field>RecordTypeId</field>
        <lookupValue>MX_SB_SAC_RT</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Actualizar Tipo de registro Auto</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_ActTipoRegistroDanos</fullName>
        <description>Actualizar el Tipo de registro de Daños</description>
        <field>RecordTypeId</field>
        <lookupValue>MX_SB_SAC_RTDanos</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Actualizar tipo de registro Daños</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_ActTipoRegistroSalud</fullName>
        <description>Actualizar el Tipo de registro de Salud</description>
        <field>RecordTypeId</field>
        <lookupValue>MX_SB_SAC_RTSalud</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Actualizar tipo de registro Salud</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_ActTipoRegistroVida</fullName>
        <description>Actualizar el Tipo de registro de Vida</description>
        <field>RecordTypeId</field>
        <lookupValue>MX_SB_SAC_RTVida</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Actualizar tipo de registro VIDA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_ActualizarEtapaResoluciondeTra</fullName>
        <description>Actualizara cuando el gerente realice la modificación de propietario</description>
        <field>MX_SB_SAC_Etapa__c</field>
        <literalValue>Resolución del tramite</literalValue>
        <name>Actualizar Etapa</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_Actualizarestatus</fullName>
        <description>Cuando el gerente asigne los folios a un usuario especifico, actualizara el estatus a asignado</description>
        <field>Status</field>
        <literalValue>Asignado</literalValue>
        <name>Actualizar estatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_CierreCaso</fullName>
        <description>Campo que se actualizara para la regla de validación</description>
        <field>MX_SB_SAC_CierreCaso__c</field>
        <literalValue>1</literalValue>
        <name>MX_SB_SAC_CierreCaso</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_EstatusBOEnespera</fullName>
        <field>MX_SB_SAC_EstatusBO__c</field>
        <literalValue>En espera</literalValue>
        <name>Act. estatus BO - en espera</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_EstatusCierre</fullName>
        <field>Status</field>
        <literalValue>Cerrado</literalValue>
        <name>Estatus Cierre</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_EtapaCierre</fullName>
        <description>actualizar la etapa a cerrado cuando se cumpla el tiempo</description>
        <field>MX_SB_SAC_Etapa__c</field>
        <literalValue>Cerrado</literalValue>
        <name>Actualizar Etapa a Cerrado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_Prioridad</fullName>
        <field>Priority</field>
        <literalValue>High</literalValue>
        <name>Prioridad</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>actualiza_estado</fullName>
        <description>actualiza estado a aprobada</description>
        <field>Status</field>
        <literalValue>Aprobada</literalValue>
        <name>actualiza estado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Actualiza_Campo_Unico_Ponderaci_n</fullName>
        <description>Ponderación Iniciativa + Pi + Resumen ponderación + Estado + Ponderación Stake Holder</description>
        <field>MX_RTE_Ponderaci_n__c</field>
        <formula>IF(
  ISPICKVAL(Status,&quot;Descartado&quot;)||  RecordType.DeveloperName  &lt;&gt; &apos;MX_RTE_Features&apos;,
  MX_RTE_Iniciativa__r.Name&amp; &apos;-&apos; &amp; MX_RTE_PI__r.Name&amp; &apos;-&apos; &amp;  
  TEXT(Status) &amp; TEXT(MX_RTE_Ponderacion__c)+ CaseNumber,
  MX_RTE_Iniciativa__r.Name&amp; &apos;-&apos; &amp; MX_RTE_PI__r.Name&amp; &apos;-&apos; &amp;  MX_RTE_Resumen_Ponderacion__r.Name &amp; &apos;-&apos;&amp;  
  TEXT(Status) &amp; TEXT(MX_RTE_Ponderacion__c)
)</formula>
        <name>Actualiza Campo Unico Ponderación</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Actualiza_a_Desarrollo</fullName>
        <description>El cambio se actualiza de Módulo RCI a En Desarrollo.</description>
        <field>Status</field>
        <literalValue>En Desarrollo</literalValue>
        <name>Actualiza a En Desarrollo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_dentroNS</fullName>
        <description>Sirve para saber si el SAL esta fuera del tiempo asignado para la resolución del caso</description>
        <field>MX_SB_SAC_DentroNS__c</field>
        <literalValue>NO</literalValue>
        <name>MX_SB_SAC_dentroNS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>rechazo_estado</fullName>
        <description>rechazo estado de acalaración</description>
        <field>Status</field>
        <literalValue>Rechazada</literalValue>
        <name>rechazo estado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Actualiza_a_RCI</fullName>
        <description>El campo pasa de Validación Portafolio a Módulo RCI</description>
        <field>Status</field>
        <literalValue>Módulo RCI</literalValue>
        <name>Actualiza a Módulo RCI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Actualiza_a_Validaci_n_Pentagono</fullName>
        <description>Product Owner aprueba y se actualiza a Validación Pentágono</description>
        <field>Status</field>
        <literalValue>Validación Pentágono</literalValue>
        <name>Actualiza a Validación Pentágono</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Actualiza_a_Validaci_n_Portafolio</fullName>
        <description>Al empezar el proceso de aprobación, el campo se actualiza a Validación Portafolio.</description>
        <field>Status</field>
        <literalValue>Validación Portafolio</literalValue>
        <name>Actualiza a Validación Portafolio</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Aprobacion_Pentagono</fullName>
        <description>Pentágono aprueba y el status pasa a &quot;Valoración&quot;</description>
        <field>MX_RTE_Aprobaci_n_Pent_gono__c</field>
        <literalValue>1</literalValue>
        <name>Pentágono a Cerrado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Aprobar_Portafolio</fullName>
        <description>Si el registro es aprobado, pasa de Validación Portafolio a Módulo RCI</description>
        <field>Status</field>
        <literalValue>Módulo RCI</literalValue>
        <name>Aprobar de Portafolio a Módulo RCI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Etapa_cambia_a_Cerrado</fullName>
        <description>Cambia la etapa a Valoración</description>
        <field>Status</field>
        <literalValue>Valoración</literalValue>
        <name>Etapa cambia a Valoración</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Etapa_cambia_a_Comprometida</fullName>
        <description>La etapa cambia a comprometida</description>
        <field>MX_RTE_Estatus__c</field>
        <literalValue>Comprometida</literalValue>
        <name>Etapa cambia a comprometida</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Etapa_cambia_a_En_validacion</fullName>
        <description>La etapa cambia a en Validación</description>
        <field>MX_RTE_Estatus__c</field>
        <literalValue>En validación</literalValue>
        <name>Etapa regresa a En Validación</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Etapa_cambia_a_Present_Iniciativa</fullName>
        <description>Estado cambia a Presentación de Iniciativa</description>
        <field>Status</field>
        <literalValue>Presentación de Iniciativas</literalValue>
        <name>Etapa cambia a Presentación de Iniciativ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Etapa_cambia_a_Priorizacion</fullName>
        <description>La etapa cambia a Priorización</description>
        <field>Status</field>
        <literalValue>Priorización de Features</literalValue>
        <name>Etapa cambia a Priorización</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Recuperar_registro</fullName>
        <description>El  usuario que comenzó el proceso de aprobación puede recuperarlo hacia el paso inicial.</description>
        <field>Status</field>
        <literalValue>Backlog</literalValue>
        <name>Recuperar registro hacia Documentación</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Regresa_Desarrollo</fullName>
        <description>AL rechazar, el status regresa a En Desarrollo</description>
        <field>Status</field>
        <literalValue>En Desarrollo</literalValue>
        <name>Regresa a En Desarrollo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_SB_SAC_EstatusCierre</fullName>
        <field>Status</field>
        <literalValue>Cerrado</literalValue>
        <name>Estatus Cierre</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Regresa_Validacion_Portafolio</fullName>
        <description>Si se rechaza, el Status cambia a Validación Portafolio</description>
        <field>Status</field>
        <literalValue>Validación Portafolio</literalValue>
        <name>Regresa a Validación Portafolio</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_RTE_Regresar_a_Modulo_RCI</fullName>
        <description>Si se rechaza, se cambia el status a Módulo RCI</description>
        <field>Status</field>
        <literalValue>Módulo RCI</literalValue>
        <name>Regresar a Módulo RCI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Cierre_Invalido</fullName>
        <field>MX_WF_Tipo_de_Cierre__c</field>
        <literalValue>Cierre invalido</literalValue>
        <name>Cierre Invalido</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Cierre_Valido</fullName>
        <field>MX_WF_Tipo_de_Cierre__c</field>
        <literalValue>Cierre valido</literalValue>
        <name>Cierre Valido</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Descripci_n_Cierre_a_Nulo</fullName>
        <field>MX_WF_Descripcion_Cierre_Caso__c</field>
        <name>Descripción Cierre a Nulo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Fecha_de_cierre_Incidencia</fullName>
        <field>MX_WF_Fecha_de_solucion__c</field>
        <formula>TODAY()</formula>
        <name>Fecha de cierre Incidencia</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Incidencia_En_Proceso</fullName>
        <field>Status</field>
        <literalValue>En proceso</literalValue>
        <name>Incidencia En Proceso</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Incidencia_Impl_Rechazada</fullName>
        <field>Status</field>
        <literalValue>Rechazada</literalValue>
        <name>Incidencia Implementación Rechazada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Incidencia_Implementaci_n_Cerrada</fullName>
        <field>Status</field>
        <literalValue>Cerrado</literalValue>
        <name>Incidencia Implementación Cerrada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Incidencia_Implementacion_jec</fullName>
        <field>Status</field>
        <literalValue>Ejecución</literalValue>
        <name>Incidencia Implementación Ejecución</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Rec_Incidencia_Sin_Asignar</fullName>
        <field>Status</field>
        <literalValue>Sin asignar</literalValue>
        <name>Recuperación de Incidencia - Sin Asignar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Validacion_Inicial_Caso_Resuelto</fullName>
        <field>MX_WF_Validaci_n_Inicial__c</field>
        <literalValue>Caso resuelto</literalValue>
        <name>Validación Inicial Caso Resuelto</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MX_WF_Validacion_Inicial_Rechazada</fullName>
        <field>MX_WF_Validaci_n_Inicial__c</field>
        <literalValue>Rechazo por cuerpo del correo</literalValue>
        <name>Validación Inicial Rechazada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
	    <fieldUpdates>
        <fullName>MX_SB_SAC_ActColaIncidencia</fullName>
        <description>se mandara a la cola de incidencias</description>
        <field>OwnerId</field>
        <lookupValue>MX_SB_SAC_IncidenciasBON3</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Actualizar Propietarios</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
      <rules>
        <fullName>MX_RTE_Ponderacion_Unica</fullName>
        <actions>
            <name>MX_RTE_Actualiza_Campo_Unico_Ponderaci_n</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>La ponderación debe ser unica para los features de una misma iniciativa y un mismo PI</description>
        <formula>(ISNEW() ||  ISCHANGED( MX_RTE_Ponderacion__c ) || ISCHANGED(Status))|| ISCHANGED( MX_RTE_Resumen_Ponderacion__c) &amp;&amp;  RecordType.DeveloperName = &apos;MX_RTE_Features&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>MX_SB_SAC_Act%2E Check de Correo de envió BO</fullName>
        <actions>
            <name>MX_SB_SAC_QuitarCheckCorreoEnviadoBO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.MX_SB_SAC_EstatusBO__c</field>
            <operation>equals</operation>
            <value>Recepción  Documentos</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Seguros SAC</value>
        </criteriaItems>
        <description>se ocupara cuando el motivo y detalle se actualice para que envié el correo electrónico nuevamente</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MX_SB_SAC_Act%2E Check de Correo de envió</fullName>
        <actions>
            <name>MX_SB_SAC_QuitarCheckCorreoEnviado</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>se ocupara cuando el motivo y detalle se actualice para que envié el correo electrónico nuevamente</description>
        <formula>RecordType.DeveloperName = &quot;MX_SB_SAC_RT&quot; &amp;&amp;
(ISCHANGED(Reason)  ||
 (
  NOT(ISPICKVAL(MX_SB_SAC_Detalle__c , &quot;&quot;)) &amp;&amp;
 ISCHANGED( MX_SB_SAC_Detalle__c )
 )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MX_SB_SAC_CierreCasoEstatusBO</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.MX_SB_SAC_EstatusBO__c</field>
            <operation>equals</operation>
            <value>No Procesable,En espera</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>MX_SB_SAC_BOCierreFolioNoExitoso_CorreoCuenta</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Act_comentarios_de_caso</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>MX_SB_SAC_ActCheckCierrefaltaDoc</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>MX_SB_SAC_EstatusCierre</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>MX_SB_SAC_EtapaCierre</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>MX_SB_SAC_Prioridad</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
	<rules>
        <fullName>Actualizar tipo de registro VIDA</fullName>
        <actions>
            <name>MX_SB_SAC_ActTipoRegistroVida</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.MX_SB_SAC_Ramo__c</field>
            <operation>equals</operation>
            <value>Vida</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Seguros SAC - Vida</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MX_SB_SAC_FinalizaFlujo__c</field>
            <operation>equals</operation>
            <value>true</value>
        </criteriaItems>
        <description>Actualizar el Tipo de registro a vida</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>MX_SB_SAC_ActCheckCierre</fullName>
        <actions>
            <name>MX_SB_SAC_CierreCaso</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Cerrado</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>true</value>
        </criteriaItems>
        <description>Se ocupara para la activación de un check al cerrar el caso, esto con el fin de detonar una regla de validación y que no truene los Flujos y procces</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>Actualizar tipo de registro Daños</fullName>
        <actions>
            <name>MX_SB_SAC_ActTipoRegistroDanos</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.MX_SB_SAC_Ramo__c</field>
            <operation>equals</operation>
            <value>Daños</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Seguros SAC - Daños</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MX_SB_SAC_FinalizaFlujo__c</field>
            <operation>equals</operation>
            <value>true</value>
        </criteriaItems>
        <description>Actualizar el Tipo de registro a Daños</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>Act%2E estatus BO - en espera</fullName>
        <actions>
            <name>MX_SB_SAC_EstatusBOEnespera</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Modificara el estatus y una vez que se mande a una cola de BO</description>
        <formula>ISPICKVAL(PRIORVALUE( MX_SB_SAC_Etapa__c ),&quot;Ejecución de tramite&quot;) &amp;&amp; ISPICKVAL( MX_SB_SAC_EstatusBO__c, &quot;&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar tipo de registro Auto</fullName>
        <actions>
            <name>MX_SB_SAC_ActTipoRegistroAuto</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.MX_SB_SAC_Ramo__c</field>
            <operation>equals</operation>
            <value>Auto</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Seguros SAC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MX_SB_SAC_FinalizaFlujo__c</field>
            <operation>equals</operation>
            <value>true</value>
        </criteriaItems>
        <description>Actualizar el Tipo de registro a auto</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>Act%2E estatus BO - Administración colas</fullName>
        <actions>
            <name>MX_SB_SAC_ActCheckAtencionBO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MX_SB_SAC_ActualizarEtapaResoluciondeTra</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MX_SB_SAC_Actualizarestatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Modificara el estatus y la etapa una vez que se asigne un caso de BO</description>
        <formula>ISPICKVAL( MX_SB_SAC_Etapa__c , &quot;En espera de atención&quot;)&amp;&amp;
ISCHANGED(OwnerId) &amp;&amp; $Profile.Name = &quot;MX_SB_SAC_GerenteSuperN2&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>MX_WF_Cierre_De_Incidencia_Implementacion</fullName>
        <actions>
            <name>MX_WF_Mail_7_Cierre_Del_Caso</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>MX_WF_Incidencia_Implementaci_n_Cerrada</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Case.MX_WF_Validaci_n_Inicial__c</field>
            <operation>equals</operation>
            <value>Caso resuelto</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
	<rules>
        <fullName>Actualizar tipo de registro Accidentes Personales</fullName>
        <actions>
            <name>MX_SB_SAC_ActTipoRegistroAccidentesPerso</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.MX_SB_SAC_Ramo__c</field>
            <operation>equals</operation>
            <value>Accidentes Personales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Seguros SAC - AccidentesPersonales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MX_SB_SAC_FinalizaFlujo__c</field>
            <operation>equals</operation>
            <value>true</value>
        </criteriaItems>
        <description>Actualizar el Tipo de registro a Accidentes Personales</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MX_WF_Rechazo_De_Incidencia_Implementacion</fullName>
        <actions>
            <name>MX_WF_Mail_2_3_Aviso_de_Rechazo_Asunto_Cuerpo</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>MX_WF_Incidencia_Impl_Rechazada</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1) OR (2)</booleanFilter>
        <criteriaItems>
            <field>Case.MX_WF_Validaci_n_Inicial__c</field>
            <operation>equals</operation>
            <value>Rechazo por asunto</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MX_WF_Validaci_n_Inicial__c</field>
            <operation>equals</operation>
            <value>Rechazo por cuerpo del correo</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MX_SB_SAC_CierreCasoEstatusBOCorreoAlterno</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.MX_SB_SAC_EstatusBO__c</field>
            <operation>equals</operation>
            <value>No Procesable,En espera</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MX_SB_SAC_EsCorreoAlterno__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MX_SB_SAC_EmailAlterno__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Cerrado</value>
        </criteriaItems>
        <description>Se solicita para enviar el correo alternativo de cierre despues de 30 dias y se cierra el caso.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>MX_SB_SAC_BOCierreFolioNoExitoso_CorreoAlterno</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
	<rules>
        <fullName>Actualizar tipo de registro Salud</fullName>
        <actions>
            <name>MX_SB_SAC_ActTipoRegistroSalud</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.MX_SB_SAC_Ramo__c</field>
            <operation>equals</operation>
            <value>Salud</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Seguros SAC - Salud</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MX_SB_SAC_FinalizaFlujo__c</field>
            <operation>equals</operation>
            <value>true</value>
        </criteriaItems>
        <description>Actualizar el Tipo de registro a salud</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>MX_SB_SAC_Act Propietario Incidencia</fullName>
        <actions>
            <name>MX_SB_SAC_ActColaIncidencia</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>equals</operation>
            <value>Incidencia</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MX_SB_SAC_Detalle__c</field>
            <operation>equals</operation>
            <value>Cotizador web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Identificación de cliente</value>
        </criteriaItems>
        <description>regla que aplica únicamente a los casos de incidencia</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
