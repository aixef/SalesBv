/**-------------------------------------------------------------------------
* Nombre: MX_WB_ConvertirLeadController
* Autor Alexis Pérez
* Proyecto: MW WB Tlmkt - BBVA Bancomer
* Descripción : Class for the conversion of Lead to Account, Contact and opportunity.
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           15/01/2019      Alexis Pérez		   	Creación
* --------------------------------------------------------------------------
* 1.1           20/02/2019      Alexis Pérez		   	Se modifica el método convertirLead para atrapar la excepción QueryException
														y se modifica el query para obtener las cuentas.
* 1.2           21/02/2019      Oscar Martínez		   	Se modifica el método convertirLead para validar el estatus del Lead.
* 1.3			05/03/2019		Alexis Pérez			Se modifica la clase de tal manera que ahora se manejan PersonAccount.
* 1.4			02/05/2019		Eduardo Hernández		Se modifica clase para adecuaciones al nuevo modelo de datos
* 1.4.1			02/05/2019		Eduardo Hernández		Fix búsqueda de productos
* 1.4.2         18/05/2019      Jaime Terrats           Se remueven System debugs de la clase
* 1.4.2			23/06/2019		Eduardo Hernández		Fix recuperar Id de producto de interes
* --------------------------------------------------------------------------
*/
public without sharing class MX_WB_ConvertirLeadController extends MX_SB_VTS_LeadConvert_Ext {

    /**
	 * Lead recovered from the component. Contains the Id of the Lead convert.
	 */
    public static String objLeadToConvert { get; set; }

    /**
     * List of existing accounts.
     */
    public static List<Account> lstAccExistentes { get; set; }

    /**
     * List with the recordTypes of type to outbound.
     */
    public static List<RecordType> lstRTOutbound {get; set;}

    /**
     * Convert Lead to Account, Contact and Opportunity.
     * @params Id idLead.
     * @return Opportunity Id.
     */
    @AuraEnabled
    public static Map<String,String> convertirLead(Id idLead) {
        final Savepoint objSaveP = Database.setSavepoint();
        final Database.LeadConvert objLConvert = new database.LeadConvert();
        final Map<String,String> mpRetornoMsg = new Map<String,String>();
        try {
            final Lead leadToconvert = [Select Id, Email, RecordTypeId, LastName, FirstName, Apellido_Materno__c,
            MX_WB_ph_Telefono1__c, MX_WB_ph_Telefono2__c,
            MX_WB_ph_Telefono3__c, MX_WB_TipoTelefono1__c, MX_WB_TipoTelefono2__c,
            MX_WB_TipoTelefono3__c, MX_WB_txt_Extension1__c, MX_WB_txt_Extension2__c, MX_WB_txt_Extension3_del__c,
            MX_WB_int_TerminacionTarjeta__c, Producto_Interes__c, Name, MX_WB_txt_NumClienteEnmascarado__c,
            MX_WB_Cliente_Unico_BBVA__c, MX_WB_Cliente_Unico_Seguros__c, MX_WB_No_envios_CTI__c, MX_WB_txt_BCOM__c,
            MX_WB_txt_BMOV__c, MX_WB_txt_Clave_Texto__c, MX_WB_txt_Prefijo_1__c, MX_WB_txt_Prefijo_2__c, MX_WB_txt_Prefijo_3__c,
            LeadSource, MX_WB_Circulacion__c, MX_WB_Poliza__c, MX_WB_Prima__c, MX_WB_TipoCuenta__c, MX_WB_Cuenta__c,
            MX_WB_TieneAuto__c, MX_WB_TipoPersona__c, MX_WB_FechaPolizaAnterior__c, Origen__c, MX_WB_lst_EstatusPrimerContacto__c,
            Status, CodigoPostal__c, Fecha_Nacimiento__c,OwnerId, MobilePhone, RecordType.DeveloperName,TelefonoCelular__c,
            Resultadollamada__c, MX_SB_VTS_Tipificacion_LV2__c, MX_SB_VTS_Tipificacion_LV3__c, MX_SB_VTS_ContadorLlamadasEfectivas__c,
            MX_SB_VTS_ContadorLlamadasNoEfectivas__c, MX_SB_VTS_ContadorRemarcado__c,MX_SB_VTS_Llamadas_Efectivas__c,MX_SB_VTS_Llamadas_No_Efectivas__c,
            MX_SB_VTS_LlamadasTotales__c, MX_SB_VTS_ContadorLlamadasTotales__c, Description,
            MX_SB_VTS_Contador_Email__c from Lead where Id =: idLead];

            Boolean flag1 = false, flag2 = false, flag3 = false;

            switch on leadToconvert.RecordType.DeveloperName {
                when 'ASD' {
                    flag1 = validateFields(leadToconvert);
                }
                when 'MX_WB_rt_Telemarketing' {
                    flag2 = validateFields(leadToconvert);
                }
                when 'MX_SB_VTS_Telemarketing' {
                    flag3 = validateNewFlow(leadToconvert);
                }
            }
            if(flag1) {
                convertLead(leadToconvert, objLConvert, mpRetornoMsg, leadToconvert.RecordType.DeveloperName,'');
            } else if(flag2) {
                final CampaignMember objCampMem = [SELECT CampaignId, LeadId FROM CampaignMember WHERE LeadId =: leadToconvert.Id
                AND Campaign.Type  =: System.Label.MX_SB_VTS_RecordOutbound AND Campaign.IsActive=true];
                convertLead(leadToconvert, objLConvert, mpRetornoMsg,leadToconvert.RecordType.DeveloperName, objCampMem.CampaignId);
            } else if(flag3) {
                newBUConvert(leadToconvert, objLConvert, mpRetornoMsg);
            } else {
                mpRetornoMsg.put('ERROR',Label.MX_SB_VTS_InvalidRecordLead);
            }
        } catch(DMLException ex) {
            Database.rollback(objSaveP);
            throw new AuraHandledException(Label.MX_WB_lbl_MsgConvertException +ex.getLineNumber());//NOSONAR
        } catch(QueryException qe) {
            Database.rollback(objSaveP);
            throw new AuraHandledException(Label.MX_WB_lbl_MsgNoPerteneceCampania+qe.getLineNumber());//NOSONAR
        }
        return  mpRetornoMsg;
    }

    /**
     * validateFields Valida campos requeridos para la conversion
     * @param  leadData Datos del Lead
     * @return          return Booleano exitoso si no hubo error en las validaciones
     */
    public static Boolean validateFields(Lead leadData) {
        final Boolean isOk = true;
        final Id user = System.UserInfo.getUserId();
        if (System.Label.MX_SB_VTS_ContactoEfectivo.equals(leadData.MX_WB_lst_EstatusPrimerContacto__c) == false) {
            throw new AuraHandledException(Label.MX_SB_VTS_EstatusEfectivo);
        } else if (String.isBlank(leadData.Email)) {
            throw new AuraHandledException(Label.MX_SB_VTS_EmailRequerido);
        } else if(user.equals(leadData.OwnerId) == false) {
            throw new AuraHandledException(Label.MX_SB_VTS_OwnerLead);
        } else if (String.isBlank(leadData.Producto_Interes__c)) {
            throw new AuraHandledException(Label.MX_SB_VTS_ProductoInteres);
        } else if ((String.isBlank(leadData.MobilePhone) && String.isBlank(leadData.TelefonoCelular__c))
            && leadData.RecordType.DeveloperName.equals(System.Label.MX_SB_VTS_RecordTypeASD)) {
            throw new AuraHandledException(Label.MX_SB_VTS_InvalidPhone);
        }
        return isOk;
    }

    /**
     * convertLead description
     * @param  objLead      objeto del Lead con todos los datos
     * @param  objLConvert  objLConvert objeto de conversion Standard
     * @param  mpRetornoMsg mapa de resultados
     * @param  recordTy     tipo de registro para flujo de Outbound e Inbound
     * @param  campaignId   Id de la campaña
     */
    public static void convertLead(Lead objLead, Database.LeadConvert objLConvert,Map<String,String> mpRetornoMsg, String recordTy, String campaignId) {

        objLConvert.setLeadId(objLead.Id);
        lstAccExistentes = [SELECT Id, PersonEmail, Correo_Electronico__c FROM Account WHERE Correo_Electronico__c =: objLead.Email
        OR PersonEmail =: objLead.Email];

        if (objLead.Status.equals(System.Label.MX_SB_VTS_EtapaCotizada) || objLead.Status.equals(System.Label.MX_SB_VTS_ContactoEfectivo)) {
            objLead.Estatusdecotizacion__c = Label.MX_WB_lbl_EstatusCotizacion;
            update objLead;
            Account objAcc = new Account();
            Opportunity objOpp = new Opportunity();

            if(lstAccExistentes.isEmpty() == false) {
                objAcc = verificaExistenciaAcc(objLead);
            } else {
                objAcc = creaCuenta(System.Label.MX_SB_VTS_PersonRecord, objLead);
            }

            objLConvert.setAccountId(objAcc.Id);
            objLConvert.setConvertedStatus(System.Label.MX_SB_VTS_EtapaCotizada);

            String recordLabel = '';
            switch on recordTy {
                when 'ASD' {
                    recordLabel = System.Label.MX_SB_VTS_RecordTypeASD;
                    objOpp = creaOportunidad(objAcc.Id, campaignId, recordLabel, objLead);
                }
                when 'MX_WB_rt_Telemarketing' {
                    recordLabel = System.Label.MX_SB_VTS_RecordTypeOutOpp;
                    objOpp = creaOportunidad(objAcc.Id, campaignId, recordLabel, objLead);
                }
            }

            objLead.MX_WB_Convertido__c = true;
            objLead.MX_WB_RCuenta__c = objAcc.Id;
            objLead.MX_WB_Oportunidad__c = objOpp.Id;
            update objLead;
            objLConvert.setOpportunityId(objOpp.Id);
            final Database.LeadConvertResult lcResult = Database.convertLead(objLConvert);
            mpRetornoMsg.put('OK',lcResult.getOpportunityId());
        } else {
            mpRetornoMsg.put('ERROR',Label.MX_WB_lbl_MsgValidPrimerContacto);
        }
    }

    /**
     * Returns the account if existing.
     * @return Account.
     */
    public static Account verificaExistenciaAcc(Lead objLead) {
        Account objAcc = new Account();
        for(Account itAcc : lstAccExistentes) {
            if((String.isNotBlank(itAcc.Correo_Electronico__c) && itAcc.Correo_Electronico__c == objLead.Email) ||
            (String.isNotBlank(itAcc.PersonEmail) && itAcc.PersonEmail == objLead.Email)) {
                objAcc = itAcc;
            }
        }
        return objAcc;
    }

    /**
     * Create a Account from the Lead data.
     * @return The account created.
     */
    public static Account creaCuenta(String recordTy, Lead objLead) {
        final String idRTAcc = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordTy).getRecordTypeId();
        final Account objAcc = new Account();

        objAcc.ApellidoMaterno__c = objLead.Apellido_Materno__c;
        objAcc.PersonEmail = objLead.Email;
        objAcc.Correo_Electronico__c = objLead.Email;
        objAcc.MX_WB_txt_NumClienteEnmascarado__c = objLead.MX_WB_txt_NumClienteEnmascarado__c;
        objAcc.RecordTypeId = idRTAcc;
        objAcc.MX_WB_PolizaAnterior__c = objLead.MX_WB_Poliza__c;
        objAcc.MX_WB_FechaPolizaAnterior__c =objLead.MX_WB_FechaPolizaAnterior__c;
        objAcc.MX_WB_TipoCuenta__c = objLead.MX_WB_TipoCuenta__c;
        objAcc.MX_WB_Cuenta__c = objLead.MX_WB_Cuenta__c;
		objAcc.FirstName = objLead.FirstName;
		objAcc.LastName = objLead.LastName;
        objAcc.MX_WB_txt_Apellido_Materno__pc = objLead.Apellido_Materno__c;

        objAcc.MX_WB_txt_NumClienteEnmascarado__pc = String.valueOf(objLead.MX_WB_FechaPolizaAnterior__c);
        objAcc.MX_WB_ph_Telefono1__pc = objLead.MX_WB_ph_Telefono1__c;
        objAcc.MX_WB_ph_Telefono2__pc = objLead.MX_WB_ph_Telefono2__c;
        objAcc.MX_WB_ph_Telefono3__pc = objLead.MX_WB_ph_Telefono3__c;
        objAcc.MX_WB_TipoTelefono1__pc = objLead.MX_WB_TipoTelefono1__c;
        objAcc.MX_WB_TipoTelefono2__pc = objLead.MX_WB_TipoTelefono2__c;
        objAcc.MX_WB_TipoTelefono3__pc = objLead.MX_WB_TipoTelefono3__c;
        objAcc.MX_WB_txt_Extension1__pc = objLead.MX_WB_txt_Extension1__c;
        objAcc.MX_WB_txt_Extension2__pc = objLead.MX_WB_txt_Extension2__c;
        objAcc.MX_WB_txt_Extension3__pc = objLead.MX_WB_txt_Extension3_del__c;
        objAcc.MX_WB_txt_Prefijo_1__pc = objLead.MX_WB_txt_Prefijo_1__c;
        objAcc.MX_WB_txt_Prefijo_2__pc = objLead.MX_WB_txt_Prefijo_2__c;
        objAcc.MX_WB_txt_Prefijo_3__pc = objLead.MX_WB_txt_Prefijo_3__c;
        objAcc.MX_WB_int_TerminacionTarjeta__pc = objLead.MX_WB_int_TerminacionTarjeta__c;
        objAcc.MX_WB_txt_NumClienteEnmascarado__pc = objLead.MX_WB_txt_NumClienteEnmascarado__c;
        objAcc.MX_WB_Cliente_Unico_BBVA__pc = objLead.MX_WB_Cliente_Unico_BBVA__c;
        objAcc.MX_WB_Cliente_Unico_Seguros__pc = objLead.MX_WB_Cliente_Unico_Seguros__c;
        ObjAcc.MX_WB_txt_BCOM__pc = objLead.MX_WB_txt_BCOM__c;
        ObjAcc.MX_WB_txt_BMOV__pc = objLead.MX_WB_txt_BMOV__c;

        objAcc.PersonMailingPostalCode = objLead.CodigoPostal__c;
        objAcc.PersonBirthdate = objLead.Fecha_Nacimiento__c;
        objAcc.PersonMobilePhone = String.isNotBlank(objLead.MobilePhone) ? objLead.MobilePhone : objLead.TelefonoCelular__c;
        objAcc.Phone = objAcc.PersonMobilePhone;
        insert objAcc;
        return objAcc;
    }

    /**
     * Create a Opportunity from the Lead data.
     * @param String idAcc, String campId, String idFamProduct
     * @return The account created.
     */
    public static Opportunity creaOportunidad(String idAcc, String campId, String recordTyp, Lead objLead) {
        final String idRTOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(recordTyp).getRecordTypeId();
        final Opportunity objOpp = new Opportunity();
        objOpp.AccountId = idAcc;
        objOpp.Name = objLead.Name;
        objOpp.RecordTypeId = idRTOpp;
        final String prodCorrectName = MX_SB_VTS_CierreOpp.validacionproducto(objLead.Producto_Interes__c);
        objOpp.Producto__c = prodCorrectName;
        if(recordTyp.equals(System.Label.MX_SB_VTS_RecordTypeASD)) {
            if (objLead.LeadSource.equals(System.Label.MX_SB_VTS_OrigenCallMeBack) ||
            objLead.LeadSource.equals(System.Label.MX_SB_VTS_InboundLabel)) {
                objOpp.StageName = System.Label.MX_SB_VTS_OppEtapaPoliticas;
            } else {
                objOpp.StageName = System.Label.MX_SB_VTS_OppEtapaObjeciones;
            }
            objOpp.MX_WB_Producto__c = findIdproduct(prodCorrectName);
            objOpp.CloseDate = Date.today().addDays(1);
            objOpp.Reason__c = 'Venta';
        } else if(recordTyp.equals(System.Label.MX_SB_VTS_RecordTypeOutOpp)) {
            objOpp.StageName = System.Label.MX_SB_VTS_OppEtapaObjeciones;
            objOpp.CloseDate = Date.today().addDays(7);
            objOpp.CampaignId = campId;
        }
        objOpp.Origen__c = objLead.Origen__c;
        objOpp.TelefonoCliente__c = objLead.MX_WB_ph_Telefono1__c;
        objOpp.MX_WB_txt_Clave_Texto__c = objLead.MX_WB_txt_Clave_Texto__c;
        objOpp.LeadSource = objLead.LeadSource;
        insert objOpp;
        return objOpp;
    }

    /**
     * findIdproduct recuperar Id de producto igual
     * @param  name Nombre de producto
     * @return      Id del producto buscado
     */
    public static String findIdproduct(String name) {
        String correctProductId = '';
        for(Product2 prods : [Select Id, Name from Product2 where Name =: name]) {
            if(prods.Name.equals(name)) {
                correctProductId = prods.Id;
            }
        }
        return correctProductId;
    }

    /**
    **/
    public static void newBUConvert(Lead leadToConvert, Database.LeadConvert objLConvert, Map<String,String> mpRetornoMsg) {
        if(String.isEmpty(leadToConvert.Email) || String.isBlank(leadToConvert.Email)) {
            leadToConvert.Email = createDummyEmail(leadToConvert);
            update leadToConvert;
        }
        lstAccExistentes = [SELECT Id, PersonEmail, Correo_Electronico__c FROM Account WHERE Correo_Electronico__c =: leadToConvert.Email
        OR PersonEmail =: leadToConvert.Email];
        if(System.Label.MX_SB_VTS_AperturaCuenta.equals(leadToConvert.Status)) {
            objLConvert.setLeadId(leadToConvert.Id);
            Account newAcc = new Account();
            Opportunity newOpp = new Opportunity();
            if(lstAccExistentes.isEmpty() == false) {
                newAcc = verificaExistenciaAcc(leadToConvert);
            } else {
                newAcc = creaCuenta(System.Label.MX_SB_VTS_PersonRecord, leadToConvert);
            }

            objLConvert.setAccountId(newAcc.Id);
            objLConvert.setConvertedStatus(System.Label.MX_SB_VTS_AperturaCuenta);
            newOpp = createOppExt(leadToConvert, newAcc.Id);
            newOpp.MX_WB_Producto__c = findIdproduct(newOpp.Producto__c);
            Database.Insert(newOpp);
            objLConvert.setOpportunityId(newOpp.Id);
            final Database.LeadConvertResult lcResult = Database.convertLead(objLConvert);
            mpRetornoMsg.put('OK',lcResult.getOpportunityId());
        } else {
            mpRetornoMsg.put('ERROR',Label.MX_WB_lbl_MsgValidPrimerContacto);
        }
    }
}