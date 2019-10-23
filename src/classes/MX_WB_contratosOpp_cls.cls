/****************************************************************************************************
author: Javier Ortiz Flores
company: Indra
Description: controlador After Update para proceso Outbound,
donde se crea un contrato por opportunityLineItem asociado a Oportunidad

Information about changes (versions)
-------------------------------------
Number    Dates           Author                       Description
------    --------        --------------------------   -----------
1.0       01-Ene-2019     Javier Ortiz Flores          Creación de la Clase
1.1       11-Feb-2019     Eduardo Hernández            Log de ultima modificación - Se agregan y quitan System debugs para clase Test
1.2   6/5/2019 17:16:30   Eduardo Hernández Cuamatzi   Cambio de modelo y adecuación para multi producto
1.2.1       13/05/2019     Arsenio Perez               Corrección lógica de consulta.
1.2.2       22/05/2019     Eduardo Hernández           Se agrega consulta anidada para recuperar Leads de campaña activa
1.2.3       20/6/2019     Eduardo Hernández Cuamatzi   Corecciónes sonar
1.3         17/07/2019    Jaime Terrats                Se agrega fix para actualizar el status del contrato de draft a activated
1.3.1       17/07/2019    Eduardo Hernández Cuamatzi   Cambio de tipo de dato para telefonos de cliente y asegurado
1.4         21/08/2019    Jaime Terrats                Se remueve switch para generar contrato en base a producto
****************************************************************************************************/
public without sharing class MX_WB_contratosOpp_cls {

    /**
* MX_WB_contratosOpp_cls Constructor
* @return   constructor para issue singleton
*/
    private MX_WB_contratosOpp_cls () {} //NOSONAR
    /** ID tipo de registro **/
    public static final Id idRecTypOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(System.Label.MX_SB_VTS_RecordTypeOutOpp).getRecordTypeId();

    /**
* creaContrato Creacion de contrato
* @param	lstOLI Una lista de la oportunidad
* @param	valuesOpp Valores de la oportunidad
* @param	valuesProduct	Valores del producto
* @param	clippNums	Cadena String
*/
    public static void creaContrato(List<OpportunityLineItem> lstOLI, Map<Id, Opportunity> valuesOpp, Map<Id, Product2> valuesProduct, Set<String> clippNums, List<Lead> leadsOutbound) {
        final List<Contract> listContratos = new List<Contract>();
        final Map<Id, Contract> valuesContract = new Map<Id, Contract>([Select Name,MX_WB_noPoliza__c from Contract where Name IN :clippNums]);
        for(OpportunityLineItem iteraOLI : lstOLI) {
            if(!checkContrato(iteraOLI.MX_WB_noPoliza__c, valuesContract)) {
                final Contract contratoNew = generaContrato(iteraOLI, valuesOpp, valuesProduct);
                if(listContratos.contains(contratoNew)==false) {
                    listContratos.add(contratoNew);
                }

                if (valuesOpp.get(iteraOLI.OpportunityId).RecordType.DeveloperName.equals(System.Label.MX_SB_VTS_RecordTypeOutOpp)) {
                    createTask(valuesOpp.get(iteraOLI.OpportunityId), leadsOutbound);
                }
            }
        }
        if(!listContratos.isEmpty()) {
            insert listContratos;
            activateContract(listContratos);
            closeOppor(listContratos,valuesOpp);
        }
    }
    /**
* @Method: Close to Opportunity
* @Param: listContratos and valuesOpp
* @Description:
*/
    private static void closeOppor(List<Contract> listContratos, Map<Id, Opportunity> valuesOpp) {
        final List<Opportunity> OppstoUpdate = new List<Opportunity>();
        Map<Id, Contract> MapCont = new Map<Id,Contract>();
        for(Contract temp: listContratos) {
            MapCont.put(temp.MX_WB_Oportunidad__c, temp);
        }
        for(Opportunity opptem: valuesOpp.values()) {
            if( String.isNotEmpty(MapCont.get(opptem.Id).Id) &&
               String.isNotEmpty(opptem.Owner.Profile.Name) &&
               opptem.Owner.Profile.Name == system.label.MX_SB_VTS_ProfileAdmin ||
               opptem.Owner.Profile.Name == System.Label.MX_SB_VTS_IntUser) {
                   opptem.StageName=system.label.MX_SB_VTS_CLOSEDWON_LBL;
                   OppstoUpdate.add(opptem);
               }
        }
        if(OppstoUpdate.isEmpty()==false) {
            update OppstoUpdate;
        }
    }

    /**
* createTask Creacion de tarea
* @param	iteraOpp Una iteración de la oportunidad
*/
    public static void createTask(opportunity iteraOpp, List<Lead> leadsOutbound) {
        final set<id> idLeads = new set<id>();
        for(Lead iteraLead : leadsOutbound) {
            if(String.isNotBlank(iteraLead.ConvertedAccountId) && iteraLead.ConvertedAccountId.equals(iteraOpp.AccountId)) {
                idLeads.add(iteraLead.Id);
            }
        }

        if(!idLeads.isEmpty()) {
            for(id iteraId : idLeads) {
                MX_WB_regresosCall_cls.procesaCall(iteraId, 'ASD', iteraOpp.Id);
            }
        }
    }

    /**
* checkContrato Revisión de contrato
* @param	clippNum	Una cadena
* @param	valuesContract	valores del contrato
* @return	existe Valor boolean
*/
    public static boolean checkContrato(String clippNum, Map<Id, Contract> valuesContract) {
        boolean existe = false;
        for(contract iteraContrato : valuesContract.values()) {
            if(iteraContrato.MX_WB_noPoliza__c.equals(clippNum)) {
                existe = true;
            }
        }
        return existe;
    }

    /**
* generaContrato Generación de contrato
* @param	iteraOppLineItm	Un articulo de la oportunidad
* @param	valuesOpp	valores de la oportunidad
* @param	valuesProduct	valores del producto
* @return	contratoNew Nuevo contrato
*/
    public static contract generaContrato(OpportunityLineItem iteraOppLineItm, Map<Id, Opportunity> valuesOpp, Map<Id, Product2> valuesProduct) {
        Contract contratoNew = new Contract();
        contratoNew.AccountId = valuesOpp.get(iteraOppLineItm.OpportunityId).AccountId;
        contratoNew.MX_WB_Oportunidad__c = iteraOppLineItm.OpportunityId;
        Opportunity updOpp = valuesOpp.get(iteraOppLineItm.OpportunityId);
        updOpp.MX_SB_VTS_Aplica_Cierre__c = true;
        contratoNew= fillContractASD(iteraOppLineItm, contratoNew);
        update updOpp;
        return contratoNew;
    }

    /**
* generaContrato Generación de contrato
* @param	iteraOppLineItm	Un articulo de la oportunidad
* @param	contratoNew	Nuevo contrato
*/
    public static Contract fillContractASD(OpportunityLineItem iteraOppLineItm, Contract contratoNew) {
        contratoNew.MX_WB_Sexo__c = validEmptyField(iteraOppLineItm.MX_WB_Sexo__c);
        contratoNew.MX_WB_edad_de_conductor_adicional__c =  validEmptyField(iteraOppLineItm.MX_WB_edad_de_conductor_adicional__c);
        contratoNew.MX_WB_EsContratante__c = validEmptyField(iteraOppLineItm.MX_WB_EsContratante__c);
        contratoNew.MX_WB_nombreAsegurado__c = validEmptyField(iteraOppLineItm.MX_WB_nombreAsegurado__c);
        contratoNew.MX_WB_apellidoMaternoAsegurado__c = validEmptyField(iteraOppLineItm.MX_WB_apellidoMaternoAsegurado__c);
        contratoNew.MX_WB_apellidoPaternoAsegurado__c = validEmptyField(iteraOppLineItm.MX_WB_apellidoPaternoAsegurado__c);
        contratoNew.MX_WB_emailAsegurado__c = validEmptyField(iteraOppLineItm.MX_WB_emailAsegurado__c);
        contratoNew.MX_WB_celularAsegurado__c = iteraOppLineItm.MX_WB_celularAsegurado__c;
        contratoNew.MX_WB_telefonoAsegurado__c = iteraOppLineItm.MX_WB_telefonoAsegurado__c;
        contratoNew.MX_WB_noPoliza__c = iteraOppLineItm.MX_WB_noPoliza__c;
        contratoNew.Name = iteraOppLineItm.MX_WB_noPoliza__c;
        contratoNew.MX_WB_Descuento_con_cupones__c = validEmptyField(iteraOppLineItm.MX_WB_Descuento_con_cupones__c);
        contratoNew.StartDate = iteraOppLineItm.MX_WB_fechaEmision__c;
        contratoNew.MX_WB_Producto__c = validEmptyField(iteraOppLineItm.Product2Id);
        contratoNew.status = System.Label.MX_SB_VTS_ContractStatus;
        contratoNew.MX_WB_cuenta_con_dispositivo_satelital__c = validEmptyField(iteraOppLineItm.MX_WB_cuenta_con_dispositivo_satelital__c);
        contratoNew.MX_WB_SaleACarretera__c = validEmptyField(iteraOppLineItm.MX_WB_SaleACarretera__c);
        contratoNew.MX_WB_Alguien_mas_conduce__c = validEmptyField(iteraOppLineItm.MX_WB_Alguien_mas_conduce__c);
        contratoNew.MX_WB_comentariosPersonalizados__c = validEmptyField(iteraOppLineItm.MX_WB_comentariosPersonalizados__c);
        contratoNew.MX_WB_existen_conductores_adicionales__c = validEmptyField(iteraOppLineItm.MX_WB_existen_conductores_adicionales__c);
        contratoNew.MX_WB_numeroSerie__c = validEmptyField(iteraOppLineItm.MX_WB_numeroSerie__c);
        contratoNew.MX_WB_Modelo__c = validEmptyField(iteraOppLineItm.MX_WB_Modelo__c);
        contratoNew.MX_WB_placas__c = validEmptyField(iteraOppLineItm.MX_WB_placas__c);
        contratoNew.MX_WB_origen__c = validEmptyField(iteraOppLineItm.MX_WB_origen__c);
        contratoNew.MX_WB_subMarca__c = validEmptyField(iteraOppLineItm.MX_WB_subMarca__c);

        return  fillContractASD2(iteraOppLineItm, contratoNew);
    }
    /**Método fillContractASD2 */
    public static Contract fillContractASD2(OpportunityLineItem iteraOppLine, Contract contrato) {
        Contract contratoNew = contrato;
        OpportunityLineItem  iteraOppLineItm = iteraOppLine;
        contratoNew.MX_WB_Marca__c = validEmptyField(iteraOppLineItm.MX_WB_Marca__c);
        contratoNew.MX_WB_Tipo_de_auto__c = validEmptyField(iteraOppLineItm.MX_WB_Tipo_de_auto__c);
        contratoNew.MX_SB_VTS_Precio_Anual__c = String.valueOf(iteraOppLineItm.TotalPrice);
        contratoNew.MX_SB_VTS_Aneurisma_Trombosis_Embolia__c = iteraOppLineItm.MX_SB_VTS_Aneurisma_Trombosis_Embolia__c;
        contratoNew.MX_SB_VTS_Cancer_Tumores_Leucemia_Lupus__c = iteraOppLineItm.MX_SB_VTS_Cancer_Tumores_Leucemia_Lupus__c;
        contratoNew.MX_SB_VTS_Casa_o_Departamento__c = iteraOppLineItm.MX_SB_VTS_Casa_o_Departamento__c;
        contratoNew.MX_SB_VTS_Cercania_Mantos_Aquiferos__c = iteraOppLineItm.MX_SB_VTS_Cercania_Mantos_Aquiferos__c;
        contratoNew.MX_SB_VTS_Ciudad__c = iteraOppLineItm.MX_SB_VTS_Ciudad__c;
        contratoNew.MX_SB_VTS_Colonia__c = iteraOppLineItm.MX_SB_VTS_Colonia__c;
        contratoNew.MX_SB_VTS_Danos_Contenidos__c = iteraOppLineItm.MX_SB_VTS_Danos_Contenidos__c;
        contratoNew.MX_SB_VTS_Danos_Inmueble__c = iteraOppLineItm.MX_SB_VTS_Danos_Inmueble__c;
        contratoNew.MX_SB_VTS_EmficemaBronquitisTuberculosis__c= iteraOppLineItm.MX_SB_VTS_EmficemaBronquitisTuberculosis__c;
        contratoNew.MX_SB_VTS_Equipo_Electronico__c = iteraOppLineItm.MX_SB_VTS_Equipo_Electronico__c;
        contratoNew.MX_SB_VTS_Estado__c =iteraOppLineItm.MX_SB_VTS_Estado__c;
        contratoNew.MX_SB_VTS_FamilaProducto__c = iteraOppLineItm.MX_SB_VTS_FamilaProducto__c;
        contratoNew.MX_SB_VTS_Frecuencia_de_Pago__c = iteraOppLineItm.MX_SB_VTS_Frecuencia_de_Pago__c;
        contratoNew.MX_SB_VTS_Insuficiencias_Cirrosis_Hepati__c = iteraOppLineItm.MX_SB_VTS_Insuficiencias_Cirrosis_Hepati__c;
        contratoNew.MX_SB_VTS_Meses_sin_Intereses__c = iteraOppLineItm.MX_SB_VTS_Meses_sin_Intereses__c;
        contratoNew.MX_SB_VTS_Monto_Mensualidad__c = iteraOppLineItm.MX_SB_VTS_Monto_Mensualidad__c;
        contratoNew.MX_SB_VTS_Muros_Tabique_Ladrillo_Block__c = iteraOppLineItm.MX_SB_VTS_Muros_Tabique_Ladrillo_Block__c;
        contratoNew.MX_SB_VTS_No_Pisos_Inmueble__c = iteraOppLineItm.MX_SB_VTS_No_Pisos_Inmueble__c;
        contratoNew.MX_SB_VTS_Nombre_Intermediario__c =iteraOppLineItm.MX_SB_VTS_Nombre_Intermediario__c;
        contratoNew.MX_SB_VTS_Numero_Exterior__c = iteraOppLineItm.MX_SB_VTS_Numero_Exterior__c;
        contratoNew.MX_SB_VTS_Numero_Interior__c = iteraOppLineItm.MX_SB_VTS_Numero_Interior__c;
        contratoNew.MX_SB_VTS_Piso_Habitado__c = iteraOppLineItm.MX_SB_VTS_Piso_Habitado__c;
        contratoNew.MX_SB_VTS_Por_Robo__c = iteraOppLineItm.MX_SB_VTS_Por_Robo__c;
        contratoNew.MX_SB_VTS_Precio_Anual__c = iteraOppLineItm.MX_SB_VTS_Precio_Anual__c;
        contratoNew.MX_SB_VTS_Proteccion_Sismo__c = iteraOppLineItm.MX_SB_VTS_Proteccion_Sismo__c;
        contratoNew.MX_SB_VTS_RespPrivada_Familiar__c = iteraOppLineItm.MX_SB_VTS_Proteccion_Sismo__c;
        contratoNew.MX_SB_VTS_RFC__c = iteraOppLineItm.MX_SB_VTS_RFC__c;
        contratoNew.MX_SB_VTS_Rotura_Cristales__c = iteraOppLineItm.MX_SB_VTS_Rotura_Cristales__c;
        contratoNew.MX_SB_VTS_Techo_Tabique_Ladrillo_Block__c = iteraOppLineItm.MX_SB_VTS_Techo_Tabique_Ladrillo_Block__c;
        contratoNew.MX_SB_VTS_Total_Fallecimiento__c = iteraOppLineItm.MX_SB_VTS_Total_Fallecimiento__c;
        contratoNew.MX_SB_VTS_Total_Gastos_Funerarios__c = iteraOppLineItm.MX_SB_VTS_Total_Gastos_Funerarios__c;
        contratoNew.MX_SB_VTS_Total_Muerte_Accidental__c = iteraOppLineItm.MX_SB_VTS_Total_Muerte_Accidental__c;
        contratoNew.MX_WB_celularAsegurado__c = iteraOppLineItm.MX_WB_celularAsegurado__c;
        contratoNew.MX_WB_noMotor__c = iteraOppLineItm.MX_WB_noMotor__c;
        contratoNew.MX_WB_Oportunidad__c = iteraOppLineItm.OpportunityId;
        contratoNew.MX_SB_VTS_FechaInicio__c = iteraOppLineItm.MX_SB_VTS_FechaInicio__c;
        contratoNew.MX_SB_VTS_FechaFin__c = iteraOppLineItm.MX_SB_VTS_FechaFin__c;
        return contratoNew;
    }

    /**
* validEmptyField Valida campo
* @param	evaluateValue	Valida valor
* @return	validField	Retorna campo validado
*/
    public static String validEmptyField(String evaluateValue) {
        String validField = '';
        if (String.isNotBlank(evaluateValue) && String.isNotEmpty(evaluateValue)) {
            validField = evaluateValue;
        }
        return validField ;
    }

    /*
    * Update contract status to activated
    *
    */
    public static void activateContract(List<Contract> contracts) {
        try {
            for(Integer i = 0; i < contracts.Size(); i++) {
                contracts[i].Status = 'Activated';
            }
            Database.update(contracts);
        } catch(DmlException dmlEx) {
            throw new DmlException(System.label.MX_WB_LG_ErrorBack + dmlEx);
        }
    }
}
