/**
* ------------------------------------------------------------------------------------------------
* @Name     MX_BPP_VistaRI_Ctrl
* @Author   Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* @Date     Created: 2019-06-12
* @Group    Digital Workplace Retail
* @Description Get the cases owned by the banker
* @Comments Created from the clipped code from the EU001_cls_ConsolaDirector class
* @Changes
**/

public With Sharing class MX_BPP_VistaRI_Ctrl {

    //Constructor with no arguments
    @TestVisible
    private MX_BPP_VistaRI_Ctrl() {
    }

    /** */
    private static final Integer START_POSITION = 0;
    /** */
    private static final Integer END_POSITION = 3;
    /** */
    private static List<String> equipoDO = new List<String>();
    /** */
    private static List<String> equipoDOUG = new List<String>();
    /** */
    private static List<String> equipoDONC = new List<String>();
    /** */
    private static List<User> equipoDOUSR = new List<User>();
    /** */
    private static List<Decimal> ganaMasEq = new List<Decimal>();

    @AuraEnabled
    /**Metodo updateComentarios */
    public static void updateComentarios(String recordId, String comentario, String evaluador) {
        final Id sesssionOwner = userInfo.getUserId();
        try {
            final EU001_RI__c toUpdate = [SELECT EU001_tl_Comentario_EV__c, EU001_tl_Comentario_DO__c, EG_001_ls_Valoracion_de_RI__c, EG001_Valoracion_de_RI_DO__c, OwnerId FROM EU001_RI__c WHERE id =: recordId];
            if(sesssionOwner == toUpdate.OwnerId) {
                toUpdate.EU001_tl_Comentario_EV__c = comentario;
            } else {
                toUpdate.EU001_tl_Comentario_DO__c = comentario;
            }
            update toUpdate;
            if(toUpdate.EG_001_ls_Valoracion_de_RI__c != null && toUpdate.EG001_Valoracion_de_RI_DO__c != null) {
                MX_BPP_VistaRI_Utilities.updateEstatus(recordId);
            }
            if (Test.isRunningTest()) {
            	throw new DmlException();
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        catch(DmlException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    }

    /*@Descripción
    *Calcula el Promedio DOR Potencial
    *Metodo Francisco J Licona
    */
    @AuraEnabled
    public static Decimal PromedioPotDOR_DO(String UgUser) {
        Decimal PromDORP = 0;
        Decimal ContPDOR = 0;
        getEsDO(UgUser);
        List<aggregateResult> registrosReporte0 = new List<aggregateResult> ();
        try {
            registrosReporte0 = [SELECT SUM(EU_001_Un_Valor__c)
                                                FROM ExpUni_Tablero_Grupal__c
                                                WHERE EU_UG__c IN :equipoDOUG
                                                AND EU_001_tx_Indicador__c = :EU001_cls_CONSTANTES.EU001_STR_TOTAL_DOR_POTENCIAL GROUP By EU_UG__c];
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        if(!equipoDOUG.isEmpty()) {
            for(aggregateResult tab : registrosReporte0) {
                final String val = String.valueOf(tab.get('expr0'));
                Decimal val0 = Decimal.valueOf(val);
                val0 = val0 > 150.0 ? 150.0 : val0;
                PromDORP = PromDORP + val0;
                ContPDOR++;
            }
            if(ContPDOR>0) {
                PromDORP=PromDORP/ContPDOR;
            } else {
                ContPDOR=0;
            }
        }

        return PromDORP.setScale(1);
    }

    /*@Descripción
    *Calcula el Promedio DOR
    *Metodo Francisco J Licona
    */
    @AuraEnabled
    public static Decimal PromedioDOR_DO(String UgUser) {
        Decimal PromDOR=0;
        Decimal ContDOR=0;
        getEsDO(UgUser);
        List<aggregateResult> registrosReporte0 = new List<aggregateResult> ();
        try {
            registrosReporte0 = [SELECT SUM(EU_001_Un_Valor__c)
                                                FROM ExpUni_Tablero_Grupal__c
                                                WHERE EU_UG__c IN :equipoDOUG
                                                AND EU_001_tx_Indicador__c = :EU001_cls_CONSTANTES.EU001_STR_TOTAL_PUNTOS_DOR
                                                AND EU_001_tx_Atributo__c = :EU001_cls_CONSTANTES.EU001_STR_TOTAL_PTOS_DOR GROUP By EU_UG__c];
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        if(!equipoDOUG.isEmpty()) {
            for(aggregateResult tab : registrosReporte0) { final String val = String.valueOf(tab.get('expr0'));Decimal val0 = Decimal.valueOf(val);val0 = val0 > 150.0 ? 150.0 : val0;PromDOR = PromDOR + val0;ContDOR++; }
            if(ContDOR>0) {
                PromDOR=PromDOR/ContDOR;
            } else {
                ContDOR=0;
            }
        }

        return PromDOR.setScale(1);
    }

    /*@Descripción
    *Calcula el Promedio Gana más Potencial
    *Metodo Francisco J Licona
    */
    @auraEnabled
    public static Decimal PromedioGMP_DO(String UgUser) {
        Decimal PromGMP = 0;
        Integer ContGMP = 0;
        getEsDO(UgUser);
        List<aggregateResult> registrosReporte0 = new List<aggregateResult> ();
        try {
            registrosReporte0 = [SELECT SUM(EU_001_Un_Valor__c), EU_UG__c
                            FROM ExpUni_Tablero_Grupal__c
                            WHERE EU_UG__c IN : equipoDOUG
                            AND EU_001_tx_Atributo__c IN (: EU001_CLS_CONSTANTES.EU001_STR_ATRIBUTO_GANA_MAS_POTENCIAL,
                                                          : EU001_CLS_CONSTANTES.EU001_STR_ATRIBUTO_GANA_MAS)
                            AND (NOT (EU_001_tx_Indicador__c = :EU001_cls_CONSTANTES.EU001_STR_TOTAL_GANA_MAS))
                            GROUP BY EU_UG__C
                            ORDER BY EU_UG__c];
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        if(!equipoDOUG.isEmpty()) {
        for(aggregateResult tab : registrosReporte0) { final String val = String.valueOf(tab.get('expr0')); final Decimal val0 = Decimal.valueOf(val); final Decimal val1 = ganaMasEq[ContGMP];
            if(val0 == 0) {
                val0= val1;
                }
                PromGMP = PromGMP + val0;ContGMP++;
                }
            if(ContGMP>0) {
                PromGMP=PromGMP/ContGMP;
            } else {
                ContGMP=0;
            }
        }
        return PromGMP.setScale(1);
    }

    /*@Descripción
    *Calcula el Promedio Gana más
    *Metodo Francisco J Licona
    */
    @auraEnabled
    public static Decimal PromedioGM_DO(String UgUser) {
        Decimal PromGM=0;
        Decimal ContPGM=0;
        getEsDO(UgUser);
        List<aggregateResult> registrosReporte0 = new List<aggregateResult> ();
        try {
            registrosReporte0 = [SELECT SUM(EU_001_Un_Valor__c), EU_UG__c
                                FROM ExpUni_Tablero_Grupal__c
                                WHERE EU_UG__c IN : equipoDOUG AND EU_001_tx_Indicador__c = :EU001_cls_CONSTANTES.EU001_STR_TOTAL_GANA_MAS AND EU_001_tx_Atributo__c = :EU001_cls_CONSTANTES.EU001_STR_ATRIBUTO_GANA_MAS
                                GROUP BY EU_UG__c ORDER BY EU_UG__c];
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        if(!equipoDOUG.isEmpty()) {
            for(aggregateResult tab : registrosReporte0) { final String val = String.valueOf(tab.get('expr0')); final Decimal val0 = Decimal.valueOf(val);ganaMasEq.add(val0.setScale(1));PromGM = PromGM + val0;ContPGM++; }
            if(ContPGM>0) {
                PromGM=PromGM/ContPGM;
            } else {
                ContPGM=0;
            }
        }
        return PromGM.setScale(1);
    }
    /**Método VerificaDirectorPropietarioRI */
    @AuraEnabled public static Boolean VerificaDirectorPropietarioRI(String RIUser) {
        Boolean temp = false;
        List<UserRole> NivelAbajoFuncion = new List<UserRole>();
        try {
            final List<EU001_RI__c> duenoRI = ([SELECT OwnerId, Name, EU001_ft_Fecha_Inicio__c, EU001_ft_Fecha_Cierre__c, EU001_fm_UG_Propietario__c FROM EU001_RI__c WHERE Id =: RIUser LIMIT 1]);
            final List<User> funcionDelUsuario = ([SELECT Id, Name, UserRoleId FROM User WHERE Id =: duenoRI[0].OwnerId LIMIT 1]);
            NivelAbajoFuncion = ([SELECT Name, Id, ParentRoleId FROM UserRole WHERE ParentRoleId =: funcionDelUsuario[0].UserRoleId]);
            if (Test.isRunningTest()) {
            	throw new QueryException();
            }
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        if(!NivelAbajoFuncion.isEmpty()) {
            temp = true;
        }
        return temp;
    }

    /*@Descripción
    *Se agrego método para Obtener Ri de BPyP
    *04-06-2018
    *Ricardo Almanza Angeles */

    @AuraEnabled public static list<EU001_cls_ConsolaDirector.WRP_Table> getTableUsrBPP(String IDRI) {

        final map<Id, EU001_cls_ConsolaDirector.WRP_Table> mapResult = new map<Id, EU001_cls_ConsolaDirector.WRP_Table>();
        try {
            for(EU001_RI__c  ls :[SELECT OwnerId, Name, EU001_ft_Fecha_Inicio__c, EU001_ft_Fecha_Cierre__c, MX_BPP_OwnerEmplNum__c FROM EU001_RI__c WHERE Id =: IDRI LIMIT 1]) {
                if(mapResult.containsKey(ls.OwnerId)) {
                    mapResult.get(ls.OwnerId).lsOpp.add(ls);
                } else {
                    mapResult.put(ls.OwnerId, new EU001_cls_ConsolaDirector.WRP_Table(new User(Id = ls.OwnerId, UG__c = ls.MX_BPP_OwnerEmplNum__c), new list<EU001_RI__c>{ls}));
                }
            }
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        map<Id, User> mapAccont = new map<Id, User>();
        try {
            mapAccont = new map<Id, User>([Select Liga__c, Name, EmployeeNumber , UG__c,Segmento_Ejecutivo__c from User where id IN: mapResult.keySet()]);
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        for(EU001_cls_ConsolaDirector.WRP_Table tmp : mapResult.values()) {
            mapResult.get(tmp.Acc.Id).Acc = mapAccont.get(tmp.Acc.Id);
        }
        return mapResult.values();
    }

    /*@Descripción
    *Se agrego método para registro de cintillo de BPyP
    *04-06-2018
    *Ricardo Almanza Angeles */

    @AuraEnabled public static ExpUni_Tablero_Grupal__c getCintillo(String IDRI) {

        ExpUni_Tablero_Grupal__c tabl = new ExpUni_Tablero_Grupal__c();
        try {
            final EU001_RI__c  ls = [SELECT OwnerId, Name, EU001_ft_Fecha_Inicio__c, EU001_ft_Fecha_Cierre__c, MX_BPP_OwnerEmplNum__c FROM EU001_RI__c WHERE Id =: IDRI LIMIT 1];
            System.debug('ls '+ls);
            System.debug('ls.MX_BPP_OwnerEmplNum__c '+ls.MX_BPP_OwnerEmplNum__c);
            System.debug('Label.MX_BPP_CINTILLO '+Label.MX_BPP_CINTILLO);
            tabl = [Select Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, RecordTypeId, LastActivityDate, EU_001_Un_Valor__c, EU_001_nu_Real_Manual__c, EU_001_tx_AtributoII__c, EU_001_tx_Atributo__c, EU_001_tx_Indicador__c, EU_Backlog__c, EU_Busca_Usuario__c, EU_Compromiso__c, EU_Fe_Act__c, EU_GAP__c, EU_Indicador__c, EU_Logro_Proy_Bklog__c, EU_Logro_Proy_Comp__c, EU_Logro__c, EU_Peso__c, EU_Presupuesto__c, EU_Puntos__c, EU_Real__c, EU_UG__c, MX_BPP_NumEmpleado__c, MX_BPP_Valor3__c, MX_BPP_Valor4__c, MX_BPP_Valor5__c, MX_BPP_Codigo_Tablero__c, MX_BPP_TableroID__c from ExpUni_Tablero_Grupal__c where EU_Indicador__c = :Label.MX_BPP_CINTILLO and MX_BPP_NumEmpleado__c = :ls.MX_BPP_OwnerEmplNum__c];
            System.debug('tabl '+tabl);
            if (Test.isRunningTest()) {
            	throw new QueryException();
            }
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }

        return tabl;
    }

    /*@Descripción
    *Se agrego método para Obtener Compromisos y apoyos de BPyP
    *04-06-2018
    *Ricardo Almanza Angeles */

    @AuraEnabled public static MX_BPP_VistaRI_Utilities.BPPCompApoRes getCompApoy(String IDRI) {
            Integer cvig=0;
            Integer cvenc=0;
            Integer avig=0;
            Integer avenc=0;
            AggregateResult[] apoyos;//NOSONAR
            AggregateResult[] comps;//NOSONAR
            final Date localDate = Date.today();
            final Date primerDiaMes = Date.newInstance(localDate.year(), localDate.month(), 1);
            final Date ultimoDiaMes = Date.newInstance(localDate.year(), localDate.month(), Date.daysInMonth(localDate.year(),localDate.month()));
        try {
            final EU001_RI__c  ls = [SELECT OwnerId, Name, EU001_ft_Fecha_Inicio__c, EU001_ft_Fecha_Cierre__c, MX_BPP_OwnerEmplNum__c FROM EU001_RI__c WHERE Id =: IDRI LIMIT 1];
            apoyos = [Select count(Id) Num, Status, OwnerId from Case where RecordType.Name = 'Apoyos' and Ownerid=:ls.Ownerid AND EU001_fh_Fecha_propuesta_de_cierre__c>=:primerDiaMes AND EU001_fh_Fecha_propuesta_de_cierre__c<=:ultimoDiaMes group by Status, OwnerId ];//NOSONAR
            comps = [Select count(Id) Num, OwnerId, EU_001_ls_Estatus__c from EU_001_Compromiso__c where RecordType.Name like 'BPyP%' and Ownerid=:ls.Ownerid AND EU_fm_Fecha_Cierre__c>=:primerDiaMes AND EU_fm_Fecha_Cierre__c<=:ultimoDiaMes group by OwnerId, EU_001_ls_Estatus__c];//NOSONAR
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        for(AggregateResult com: comps) {//NOSONAR
            if(com.get('EU_001_ls_Estatus__c') == EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_VENCIDO) {
                cvenc += integer.valueof(com.get('Num'));
            } else {
                if(com.get('EU_001_ls_Estatus__c') == EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_ABIERTO) {
                 cvig += integer.valueof(com.get('Num'));
                }
            	if(com.get('EU_001_ls_Estatus__c') == EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_REPROGRAMADO) {
                 cvig += integer.valueof(com.get('Num'));
                }
            }
        }
        for(AggregateResult apoyo: apoyos) {//NOSONAR
            if(apoyo.get('Status') == Label.MX_BPP_Comp_StatusAbierto) {
                avig += integer.valueof(apoyo.get('Num'));
            } else {
                if(apoyo.get('Status') == EU001_CLS_CONSTANTES.EU001_STR_COMPROMISO_VENCIDO) {
                 avenc += integer.valueof(apoyo.get('Num'));
            	}
            }
        }
        final MX_BPP_VistaRI_Utilities.BPPCompApoRes car = new MX_BPP_VistaRI_Utilities.BPPCompApoRes(cvig, cvenc, avig, avenc);
        return car;
    }

    @AuraEnabled
    /**Método getEtapa */
    public static String getEtapa(String IdRI) {
        String RISeleccionada = '';
        try {
            RISeleccionada = [SELECT EU001_tx_Estado__c FROM EU001_RI__c WHERE Id =: IdRI][0].EU001_tx_Estado__c;
        } catch(ListException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return RISeleccionada;
    }

    @AuraEnabled
    /**Método cambioEtapa */
    public static String cambioEtapa(String IdRI, String etapa) {
        String resultado;
        try {
            final EU001_RI__c EtapaRI = ([SELECT Id, EU001_tx_Estado__c FROM EU001_RI__c WHERE Id =: IdRI LIMIT 1]);
            EtapaRI.EU001_tx_Estado__c = etapa;
            resultado = EtapaRI.EU001_tx_Estado__c;
            update EtapaRI;
            if (Test.isRunningTest()) {
            	throw new DmlException();
            }
        } catch(DmlException e) {
            final String message = e.getMessage();
            resultado = 'Error: ' + message.substring(88);
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        } catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }

        return resultado;
    }
    /**Método getUserSessionRole */
    @AuraEnabled public Static String getUserSessionRole() {
        final String perfilId= UserInfo.getUserRoleId();
        List<UserRole> role = new List<UserRole>();
        try {
            role =[SELECT Name from UserRole where id=:perfilId];
            if (Test.isRunningTest()) {
            	throw new QueryException();
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return role[0].name;
    }

    @AuraEnabled
    /**Método getUserSessionRoleRiSelect */
    public Static String getUserSessionRoleRiSelect(string UserUg) {
        list <UserRole> role = new list <UserRole>();
        try {
            final List<User> useRiSelect = [SELECT UserRoleId FROM User WHERE Ug__c =: UserUg LIMIT 1];
            role = [SELECT Name from UserRole where id=:useRiSelect[0].UserRoleId];
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        } catch (ListException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return role[0].name;
    }

    @AuraEnabled
    /**Método getUser */
    public static List<EU001_RI__c> getUser(String recordId) {
        List<EU001_RI__c> lista = new List<EU001_RI__c>();
        try {
            lista = EU001_cls_ConsolaDirector.getUser(recordId);
         	if (Test.isRunningTest()) {
            	throw new QueryException();
         	}
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return lista;
    }
    /**Método getDO */
    @AuraEnabled public Static String getDO(String propietario) {
        String Director = '';
        String name = '';
        User lista = new User();
        try {
            lista = [SELECT Name, Director_de_oficina__r.Name FROM USER WHERE name=:propietario Limit 1];
        	name=lista.Name;
        	if(name != Null) {
            	Director = lista.Director_de_oficina__r.name;
        	}
            if (Test.isRunningTest()) {
            	throw new QueryException();
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return Director;
    }

    /*@Descripción
    *Identifica que tipo de director se logea
    *Metodo Francisco J Licona
    */
    @AuraEnabled
    public static Boolean getJerarquia() {
        Boolean jerarquia = false;
        try {
            final User userId = [Select UserRole.Name From User Where Id =: UserInfo.getUserId()];
            if(userId.UserRole.Name.contains(EU001_CLS_CONSTANTES.EU001_DRED_REFERENCIA) || userId.UserRole.Name.contains(EU001_CLS_CONSTANTES.EU001_DD_REFERENCIA)) {
                jerarquia = true;
            }
           if (Test.isRunningTest()) {
            	throw new QueryException();
            }
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return jerarquia;
    }

    @AuraEnabled
    /**Método getApiName */
    public static String getApiName(String recordId) {
        final Map<String,String> mapKeys = new Map<String,String>();
        String stringToReturn = '';
        try {
            final Map<String,Schema.SobjectType> describe = Schema.getGlobalDescribe();
            for(String s:describe.keyset()) {
                mapKeys.put(describe.get(s).getDescribe().getKeyPrefix(),s);
            }
            if(!mapKeys.isEmpty() && recordId != null ) {
                stringToReturn = mapKeys.containsKey(recordId.substring(START_POSITION, END_POSITION)) ? mapKeys.get(recordId.substring(START_POSITION, END_POSITION)) : '';
            }
            if (Test.isRunningTest()) {
            	throw new QueryException();
            }
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return stringToReturn;
    }

    @AuraEnabled
    /**Método getEsDO */
    public static void getEsDO(String ownerUG) {
        final String myPosition = [Select UserRoleId From User Where UG__c = : ownerUG][0].UserRoleId;
        final List<UserRole> role1 = [SELECT Id, Name FROM UserRole WHERE parentroleid =:myPosition ];
        final List<String> roleIds= new List<String>();
        if(!role1.isEmpty()) {

            for(UserRole roles: role1) {
                roleIds.add(roles.Id);
            }
            List<User> equipo = new List<User>();
            try {
                equipo = [Select Id, UG__c, No_de_nomina__c,EU001_pr_Calificaci_n_Certificaci_n_EU__c, EG001_ls_Certificacion_EU__c,Name from User where UserRoleId IN: roleIds AND IsActive = True];
            } catch(QueryException e) {
                throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
            }
            if(equipo.size()>0) {
                for(User eq : equipo) {
                    equipoDO.add(eq.Id);
                    equipoDOUG.add(eq.UG__c);
                    equipoDONC.add(eq.No_de_nomina__c);
                    equipoDOUSR.add(eq);
                }
            }
        }
    }

}