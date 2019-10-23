/*******************************************************************************
*   @Desarrollado por:      Indra                                              *
*   @Autor:                 Ricardo Almanza                                    *
*   @Proyecto:              Bancomer                                           *
*   @Descripción:           Clase para obtener Contactabilidad                 *
*                            y tipo de Contactabilidad                         *
*                                                                              *
*   Cambios (Versiones)                                                        *
*   -------------------------------------------------------------------------- *
*   No.     Fecha               Autor                   Descripción            *
*   ------  ----------  ----------------------      ---------------------------*
* 1.0     21/12/2017  Ricardo Almanza Angeles
    Creación Clase                  											*
* 1.1     12/03/2018  Ricardo Almanza Angeles
    Mejora para problema de fecha   											*
* 1.2     12/11/2018	Cristian Espinosa
    Se hace uso de una clase de utilidades para los componentes de la página de inicio	*
    de BPyP, que guarda los resultados de las consultas en variables estaticas para no	*
    llegar al límite de los registros retornados por consulta (50,000).					*
* 1.3	    21/12/2018	Cristian Espinosa
    Corrección de incidencia, se crea el campo MX_BPP_PropietarioVisitaYCliente__c, el	*
    cual devuelve verdadero si el propietario del reporte de visita y el cliente es el 	*
    mismo usuario. Este campo se utiliza en las consultas para que solo cuenten los RV	*
    que haya hecho el usuario propietario del cliente.									*
* 2.0     15/01/2019  Francisco Javier Licona
    Se crean métodos que procesan y devuelven listas de Clientes contactados y 			*
    no contactados de BPyP.
* 2.1		28/01/2019  Adrián Pastor Pineda
    Se crea método para obtener el cargo de un Banquero atravez de su RI				*
* 2.2		21/02/2019	Cristian Espinosa
    Se agrega un día a los filtros de fecha de inicio, ya que por defecto, muestra un	*
    día menos.																			*
* 3.0     11/03/2019  Francisco J Licona
    Se re estructuran métodos que devuelven listado de contactabilidad                  *
    de clientes.                                                                        *
* 3.1     19/03/2019  Francisco J Licona
    Se modifica condición en periodos de fechas de contactabilidad del cliente. 	    *
* 3.2     23/05/2019  Cindy Hernández
    Resolución de code smells detectados por sonar. 	                                *
* 3.3     29/05/2019  Cindy Hernández
    Recorte de métodos que no se utilizan (No son llamados por otras clases ni por      *
    componentes).                                    	                                *
* 3.4     25/06/2019  Cindy Hernández
    Se modifica el método retmonth para reducir la complejidad del mismo y resolver un  *
    code smell detectado por Sonar.                                                     *
* 3.5     02/07/2019  Hugo Carrillo
    Se agregan métodos que habian sido borrados y que son necesarios para la pantalla   *
    de inicio de BPyP
* 3.6     05/07/2019  Cindy Hernández
    Se agrega el método getTitle para evitar código repetido y disminuir la complejidad*
    de los métodos fetchOffChanData,fetchBkMChanData Y fetchBkMOnlyChanData.           *
* 3.7     16/08/2019  Cindy Hernández
    Se agregan referencias a los tipos de registro MX_BPP_PersonAcc_Client y
	MX_BPP_PersonAcc_NoClient.
* 3.8     27/08/2019  Cindy Hernández
    Se agrega la etiqueta NOSONAR para falsos positivos para Potentially unused variable
    found.                                											   *
* 3.9    03/09/2019  Cindy Hernández
    Se modifica clase para apuntar a kit de visita (Este cambio se realizó en el repo de
    empresas el 08/05/2019 por Ricardo Almanza).                                        *
* 3.10   03/09/2019  Cindy Hernández
    Mejora para limpieza de codigo  (Este cambio se realizó en el repo de empresas el
    23/05/2019 por Ricardo Almanza).                                        *
*****************************************************************************************/
public with sharing class BPyP_Contact_Acc {

    //Constructor with no arguments
    @TestVisible
    private BPyP_Contact_Acc() {
    }
    /*Variable global que  reemplaza por St*/
    static final String VAR_ST='St';
    /*Variable global que  reemplaza por En*/
    static final String VAR_EN='En';
    /*Variable global que  reemplaza por Privado*/
    static final String VAR_PRD='PRIVADO';
    /*Variable global que reemplaza por Patrimonial*/
    static final String VAR_PATRIM='patrimonial';
    /*Variable global que reemplaza por Patrimonial*/
    static final String VAR_PATRIM_SR='PATRIMONIAL SR';
    /*Variable global que  reemplaza por sm*/
    static final String STR_SM='sm';
    /*Variable global que  reemplaza por em*/
    static final String STR_EM='em';
    /*Variable global que  reemplaza por pas*/
    static final String VAR_PAS='pas';
    /*Variable global que  reemplaza por pas*/
    static final String VAR_PA='Pa';
     /*Variable global que  reemplaza por tempsetlabel*/
    static final String VAR_TMPSTLB='tempsetlabel';
    /*Variable global que  reemplaza por RecordCount*/
    static final String VAR_RCDCOUNT='RecordCount';
    /*Variable global que  reemplaza por No contactado*/
    static final String VAR_NCONTACT='No contactado';
    /*Variable global que  reemplaza por contactado*/
    static final String VAR_CONTACT='Contactado';
    /*Variable global que  reemplaza por pr*/
    static final String VAR_PR='Pr';
    /*Variable global que  reemplaza por Name*/
    static final String V_NAME='Name';
    /*Variable global que  reemplaza por tempdata*/
    static final String V_TDATA='tempdata';
    /*Variable global tempColor*/
    static list<String> tempColor=new list<String>();
    /*Variable global numbCol*/
    static Integer numbCol;
    /*Variable global contact*/
    static boolean contact;
    /*Variable global resultados*/
    static WRP_ChartStacked resultados=null;
    /*Variable global red*/
    static List<Integer> red;
    /*Variable global blue*/
    static List<Integer> blue;
    /*Variable global blue*/
    static List<Integer> green;
    /*Variable global acceptNull*/
    static Boolean acceptNull;
    /*Variable global divOrBranch*/
    static String divOrBranch;
    /*Lista auxiliar para queries Visita periodo efectivo*/
    static List <AggregateResult> visEfec = null;
    /*Lista auxiliar para queries Obtention of Divisions y total de clientes*/
    static List <AggregateResult> total = null;

    /*Metodo obtStAndEndDate*/
    public static Datetime obtStAndEndDate(Integer month,String type) {
        Datetime dateToReturn = null;
        if(type == VAR_ST) {
            dateToReturn = datetime.newInstance(system.today().year(),month,1);
        } else if (type == VAR_EN) {
            final Integer numberOfDays = Date.daysInMonth(system.today().year(), month);
            dateToReturn = datetime.newInstance(system.today().year(),month,numberOfDays);
        }
        return dateToReturn;
    }
    @AuraEnabled
    /** */
    public static List<AggregateResult> fetchDiv() {
        try {
             return MX_BPP_CompUtils_cls.getBPyPDivisions();
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    }

    @AuraEnabled
    /** */
    public static List<String> fetchusdata() {
        try {
            return MX_BPP_CompUtils_cls.getUsrData();
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    }

    @AuraEnabled
    /** */
    public static WRP_ChartStacked fetchDivData(String type,Datetime startDte,Datetime endDte) {
        //fechas de inicio y fin dependiendo de tipo de figura
        Datetime sDate, eDate;
        String title;
        //bimestral de privado
        if(startDte == null || endDte == null) {
            if(type == VAR_PR || type == null) {
                title = VAR_PRD;
                sDate = obtStAndEndDate(system.today().month(),VAR_ST);
                eDate = obtStAndEndDate(system.today().month(),VAR_EN);
                //mensual en privado
            } else if (type == VAR_PA) {
                 final Integer VAR_SM = retmonth(STR_SM);
                 final Integer var_em = retmonth(STR_EM);
                title = VAR_PATRIM;
                sDate = obtStAndEndDate(VAR_SM,VAR_ST);
                eDate = obtStAndEndDate(var_em,VAR_EN);
            } else if (type == VAR_PAS) {
                title = VAR_PATRIM_SR;
                sDate = obtStAndEndDate(system.today().month(),VAR_ST);
                eDate = obtStAndEndDate(system.today().month(),VAR_EN);}
        } else {
            sDate = datetime.newInstance(startDte.year(),startDte.month(),(startDte.day()+1));
            eDate = datetime.newInstance(endDte.year(),endDte.month(),(endDte.day()+1));
            acceptNull = true;
            title = getTitle(type, acceptNull);
        }

        try {
            visEfec=[Select dwp_kitv__account_id__r.Owner.Divisi_n__c,
                     		COUNT_DISTINCT(dwp_kitv__account_id__c) RecordCount
                     from dwp_kitv__Visit__c
                     where dwp_kitv__account_id__r.Owner.VP_ls_Banca__c = 'Red BPyP'
                     and (NOT(dwp_kitv__account_id__r.Owner.Divisi_n__c=''))
                     and (dwp_kitv__visit_status_type__c = '05' or dwp_kitv__visit_status_type__c = '06')
                     and (dwp_kitv__account_id__r.RecordType.DeveloperName='BPyP_tre_Cliente' OR dwp_kitv__account_id__r.RecordType.DeveloperName='MX_BPP_PersonAcc_Client')
                     and MX_BPP_VerifyOwner__c= true
                     and LastModifiedDate >=:sDate
                     and LastModifiedDate <=:(eDate+1)
                     and dwp_kitv__account_id__r.Owner.Title=:title
                     group by dwp_kitv__account_id__r.Owner.Divisi_n__c];

            total = [
                SELECT Owner.Divisi_n__c,count(Id) RecordCount
                FROM Account
                WHERE Owner.VP_ls_Banca__c = 'Red BPyP'
                AND (NOT (Owner.BPyP_ls_NombreSucursal__c = ''))
                AND (NOT (Owner.Divisi_n__c = ''))
                AND Owner.IsActive=True
                AND Owner.Title=:title
                AND (RecordType.DeveloperName='BPyP_tre_Cliente' OR RecordType.DeveloperName='MX_BPP_PersonAcc_Client')
                GROUP BY  Owner.Divisi_n__c];
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        //Creación de mapa para visitas Efectiva
        final Map<String,Decimal> visiEff = new Map<String,Decimal>();

        for(AggregateResult viE: visEfec) {
            visiEff.put((String)viE.get('Divisi_n__c'),(Decimal)vie.get(VAR_RCDCOUNT));
        }
         divOrBranch = 'Divisi_n__c';
        return getStackedChart(total, visiEff, divOrBranch);
    }

    private static list<String> gentempTyOpp() {
        final list<String> tempTyOpp = new list<String>();
        tempTyOpp.add(VAR_NCONTACT);
        tempTyOpp.add(VAR_CONTACT);
        return tempTyOpp;
    }
    private static list<String> gentempColor() {
        tempColor = new list<String>();
        tempColor.add('rgba(216,97,79,1)');
        tempColor.add('rgba(42,128,254,1)');
        tempColor.add('rgba');
        return tempColor;
    }

    private static List<Integer> genRedBBVA() {
        return MX_BPP_CompUtils_cls.genRedBBVA();
    }
    private static List<Integer> genGreenBBVA() {
        return MX_BPP_CompUtils_cls.genGreenBBVA();
    }
    private static List<Integer> genBlueBBVA() {
        return MX_BPP_CompUtils_cls.genBlueBBVA();
    }

    private static Integer retmonth(String type) {
        final Integer month = system.today().month();
        final Map<String, List<Integer>> monthValues = new Map<String, List<Integer>>();
        monthValues.put(STR_SM, new List<Integer>{1,1,3,3,5,5,7,7,9,9,11,11});
        monthValues.put(STR_EM, new List<Integer>{2,2,4,4,6,6,8,8,10,10,12,12});
		return  monthValues.get(type)[month-1];
    }

    private static String setTittle(String type) {
        String title;
        if(type==VAR_PR||type==null) {
            title=VAR_PRD;
        } else if (type==VAR_PAS) {
            title=VAR_PATRIM_SR;
        } else if (type==VAR_PA) {
            title=VAR_PATRIM;
        }
        return title;
    }

    @AuraEnabled
    /**Metodo fetchDivChanData */
    public static WRP_ChartStacked fetchDivChanData(String type,Datetime startDte,Datetime endDte) {
        numbCol=25;
        //fechas de inicio y fin dependiendo de tipo de figura
        Datetime sDate,eDate;
        String title;
        if(startDte==null||endDte==null) {
            //bimestral de privado
            if(type==VAR_PR||type==null) {
                title=VAR_PRD;
                sDate=obtStAndEndDate(system.today().month(),VAR_ST);
                eDate=obtStAndEndDate(system.today().month(),VAR_EN);
            //mensual en privado
            } else if (type==VAR_PAS) {
                title=VAR_PATRIM_SR;
                sDate=obtStAndEndDate(system.today().month(),VAR_ST);
                eDate=obtStAndEndDate(system.today().month(),VAR_EN);
            } else if (type==VAR_PA) {
                final Integer VAR_SM = retmonth(STR_SM);
                final Integer var_em = retmonth(STR_EM);
                title=VAR_PATRIM;
                sDate=obtStAndEndDate(VAR_SM,VAR_ST);
                eDate=obtStAndEndDate(var_em,VAR_EN);
            }
        } else {
            sDate=datetime.newInstance(startDte.year(),startDte.month(),(startDte.day()+1));
            eDate=datetime.newInstance(endDte.year(),endDte.month(),(endDte.day()+1));
            title = setTittle(type);
        }
        //System.debug('sDate '+sDate); System.debug('eDate '+eDate);
        //visita Efectiva en periodo
        try {
            visEfec=[Select RecordType.Name,MX_BIE_TipoVisitaLLamada__c,dwp_kitv__account_id__r.Owner.Divisi_n__c,count(Id) RecordCount from dwp_kitv__Visit__c where dwp_kitv__account_id__r.Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT(dwp_kitv__account_id__r.Owner.Divisi_n__c='')) and (dwp_kitv__visit_status_type__c = '05' or dwp_kitv__visit_status_type__c = '06') and (dwp_kitv__account_id__r.RecordType.DeveloperName='BPyP_tre_Cliente' OR dwp_kitv__account_id__r.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and MX_BPP_VerifyOwner__c= true and LastModifiedDate >=:sDate and LastModifiedDate <=:(eDate+1) and dwp_kitv__account_id__r.Owner.Title=:title group by dwp_kitv__account_id__r.Owner.Divisi_n__c,RecordType.Name,MX_BIE_TipoVisitaLLamada__c];

        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return agruparresultados(visEfec,numbCol,'Divisi_n__c');
    }

    /**Metodo genbbvacolor */
    public static list<String> genbbvacolor(list<String> tempTyOpp,list<Integer> red,list<Integer> green,list<Integer> blue,Integer numbCol) {
        for(Integer idx = 0; idx < tempTyOpp.size(); idx++) {
            final String colour='rgba('+red[Math.mod(idx,numbCol)]+', '+green[Math.mod(idx,numbCol)]+', '+blue[Math.mod(idx,numbCol)]+',1)';
            tempColor.add(colour);
            //Generation of rgb string
        }
        tempColor.add('rgba');
        return tempColor;
    }
    /**Metodo shorttyvis */
    public static String shorttyvis(String tyVis, String type) {
        String retstr=tyVis;
        retstr = retstr.lastIndexOf('BPyP FI') == retstr.length()-7 ? retstr.left(retstr.length()-7) : retstr;
        retstr = retstr.indexOf('Visita ') == 0 ? 'Vis ' + retstr.mid(7,retstr.length()) : retstr.indexOf('Llamada ') == 0 ? 'Llam' + retstr.mid(7,retstr.length()) : retstr;
        return retstr+type;
    }

    @AuraEnabled
    /** */
    public static List<AggregateResult> fetchOff(String div) {
        try {
            return  MX_BPP_CompUtils_cls.getBPyPOffices(div);
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    }

    @AuraEnabled
    /** */
    public static WRP_ChartStacked fetchOffData(String type, String divi, Datetime startDte, Datetime endDte) {
        //fechas de inicio y fin dependiendo de tipo de figura
        Datetime sDate, eDate;
        String title;
        if(startDte == null || endDte == null) {
            if (type == VAR_PR) {
                title =VAR_PRD;
                sDate = obtStAndEndDate(system.today().month(),VAR_ST);
                eDate = obtStAndEndDate(system.today().month(),VAR_EN);
            } else if (type == VAR_PA) {
                final Integer VAR_SM = retmonth(STR_SM);
                final Integer var_em = retmonth(STR_EM);
                title = VAR_PATRIM;
                sDate = obtStAndEndDate(VAR_SM,VAR_ST);
                eDate = obtStAndEndDate(var_em,VAR_EN);
            } else if (type == VAR_PAS) {
                title = VAR_PATRIM_SR;
                sDate = obtStAndEndDate(system.today().month(),VAR_ST);
                eDate = obtStAndEndDate(system.today().month(),VAR_EN);
            }
        } else {
            sDate = datetime.newInstance(startDte.year(),startDte.month(),(startDte.day()+1));
            eDate = datetime.newInstance(endDte.year(),endDte.month(),(endDte.day()+1));
            acceptNull = false;
            title = getTitle(type, acceptNull);
        }
        try {
            visEfec=[Select dwp_kitv__account_id__r.Owner.BPyP_ls_NombreSucursal__c,COUNT_DISTINCT(dwp_kitv__account_id__c) RecordCount from dwp_kitv__Visit__c where dwp_kitv__account_id__r.Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT(dwp_kitv__account_id__r.Owner.Divisi_n__c='')) and (NOT(dwp_kitv__account_id__r.Owner.BPyP_ls_NombreSucursal__c='')) and (dwp_kitv__visit_status_type__c = '05' or dwp_kitv__visit_status_type__c = '06') and (dwp_kitv__account_id__r.RecordType.DeveloperName='BPyP_tre_Cliente' OR dwp_kitv__account_id__r.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and MX_BPP_VerifyOwner__c= true and dwp_kitv__account_id__r.Owner.Divisi_n__c=:divi and LastModifiedDate >=:sDate and LastModifiedDate <=:(eDate+1) and dwp_kitv__account_id__r.Owner.Title=:title group by dwp_kitv__account_id__r.Owner.BPyP_ls_NombreSucursal__c];
            total = [
                SELECT Owner.BPyP_ls_NombreSucursal__c,count(Id) RecordCount
                FROM Account
                WHERE Owner.VP_ls_Banca__c = 'Red BPyP'
                AND (NOT (Owner.BPyP_ls_NombreSucursal__c = ''))
                AND (NOT (Owner.Divisi_n__c = ''))
                AND Owner.Divisi_n__c=:divi
                AND (NOT (Owner.BPyP_ls_NombreSucursal__c = ''))
                AND Owner.IsActive=True
                AND Owner.Title=:title
                AND (RecordType.DeveloperName='BPyP_tre_Cliente' OR RecordType.DeveloperName='MX_BPP_PersonAcc_Client')
                GROUP BY  Owner.BPyP_ls_NombreSucursal__c];
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        //Creación de mapa para visitas Efectiva
        final Map<String,Decimal> visiEff = new Map<String,Decimal>();
        for(AggregateResult viE: visEfec) {
            visiEff.put((String)viE.get('BPyP_ls_NombreSucursal__c'),(Decimal)vie.get(VAR_RCDCOUNT));
        }
        divOrBranch = 'BPyP_ls_NombreSucursal__c';
        resultados = getStackedChart(total, visiEff, divOrBranch);
        return resultados;
    }

    @AuraEnabled
    /**Metodo fetchOffChanData */
    public static WRP_ChartStacked fetchOffChanData(String type,String div,Datetime startDte,Datetime endDte) {
        numbCol = 25;
        //fechas de inicio y fin dependiendo de tipo de figura
        Datetime sDate,eDate;
        final String title = getTitle(type);
        //bimestral de privado
        if(startDte == null || endDte == null) {
            if (type == VAR_PR) {
                sDate = obtStAndEndDate(system.today().month(),VAR_ST);
                eDate = obtStAndEndDate(system.today().month(),VAR_EN);
            //mensual en privado
            } else if (type == VAR_PAS) {
                sDate = obtStAndEndDate(system.today().month(),VAR_ST);
                eDate = obtStAndEndDate(system.today().month(),VAR_EN);
            } else if (type == VAR_PA) {
                final Integer VAR_SM = retmonth(STR_SM);
                final Integer var_em = retmonth(STR_EM);
                sDate = obtStAndEndDate(VAR_SM,VAR_ST);
                eDate = obtStAndEndDate(var_em,VAR_EN);
            }
        } else {
            sDate = datetime.newInstance(startDte.year(),startDte.month(),(startDte.day()+1));
            eDate = datetime.newInstance(endDte.year(),endDte.month(),(endDte.day()+1));
        }
        //System.debug('sDate '+sDate); System.debug('eDate '+eDate);
        //visita Efectiva en periodo
        try {
            visEfec=[Select RecordType.Name,MX_BIE_TipoVisitaLLamada__c,dwp_kitv__account_id__r.Owner.BPyP_ls_NombreSucursal__c,count(Id) RecordCount from dwp_kitv__Visit__c where dwp_kitv__account_id__r.Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT(dwp_kitv__account_id__r.Owner.Divisi_n__c='')) and (NOT(dwp_kitv__account_id__r.Owner.BPyP_ls_NombreSucursal__c='')) and (dwp_kitv__visit_status_type__c = '05' or dwp_kitv__visit_status_type__c = '06') and (dwp_kitv__account_id__r.RecordType.DeveloperName='BPyP_tre_Cliente' OR dwp_kitv__account_id__r.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and MX_BPP_VerifyOwner__c= true and dwp_kitv__account_id__r.Owner.Divisi_n__c=:div and LastModifiedDate >=:sDate and LastModifiedDate <=:(eDate+1) and dwp_kitv__account_id__r.Owner.Title=:title group by dwp_kitv__account_id__r.Owner.BPyP_ls_NombreSucursal__c,RecordType.Name,MX_BIE_TipoVisitaLLamada__c];
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return agruparresultados(visEfec,numbCol,'BPyP_ls_NombreSucursal__c');
    }

    /*
    *@Descripción   Método que Agrupa resultados y los agrega a un objeto Wrapper para gráfico
    *@Author        Ricardo Almanza ricardo.almanza.contractor@bbva.com
    *@Date          23/05/2019
    *@Param         visEfec resultado de los resultados del query
    *@Param         numbCol parametro de número de colores
    *@Param         nvlBusqueda Cadena de para obtener busqueda
    *@return        WRP_ChartStacked Objeto Wrapper para gráfico
    *@example       agruparresultados(visEfec,numbCol,'BPyP_ls_NombreSucursal__c');
    */
    public static WRP_ChartStacked agruparresultados(List <AggregateResult> visEfec,Integer numbCol,String nvlBusqueda) {
        red=genRedBBVA();
        green=genGreenBBVA();
        blue=genBlueBBVA();
        //Creación de mapa para visitas Efectiva
        final Map<String,Decimal> visiEff=new Map<String,Decimal>();
        final Set<String> tempsetlabel=new Set<String>();
        final Set<String> tempsettyopp=new Set<String>();
        for(AggregateResult viE: visEfec) {
            String tyVis=(String)vie.get(V_NAME);
            tyVis=shorttyvis(tyVis,(String)vie.get('MX_BIE_TipoVisitaLLamada__c'));
            final String divi=(String)viE.get(nvlBusqueda);
            tempsetlabel.add(divi);
            tempsettyopp.add(tyVis);
            visiEff.put(tyVis+divi,(Decimal)vie.get(VAR_RCDCOUNT));

        }
        final list<String> tempTyOpp=new list<String>(tempsettyopp);
        final list<String> tempLabel=new list<String>(tempsetlabel);
        //Lista para color
        tempColor=genbbvacolor(tempTyOpp,red,green,blue,numbCol);
        //Creación de obj de respuesta
        resultados= new WRP_ChartStacked(tempLabel,tempTyOpp,tempColor,visiEff,null);
        return resultados;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          05-07-2019
* @Description  Obtain the title.
* @Comments     Created from the clipped code block of method fetchOffChanData, fetchBkMChanData and fetchBkMOnlyChanData.
* @param        String type
* @return       String
* @example      public static String getTitle(type) {
**/
    public static String getTitle(String type) {
        String title;
        if(type == VAR_PR) {
            title = VAR_PRD;
        } else if (type == VAR_PA) {
            title = VAR_PATRIM;
        } else if (type == VAR_PAS) {
            title = VAR_PATRIM_SR;
        }
        return title;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          10-06-2019
* @Description  Obtain the stacked chart.
* @Comments     Created from the clipped code block of method fetchOffData and fetchDivData.
* @param        List <AggregateResult> total, Map<String,Decimal> visiEff, String divOrBranch
* @return       WRP_ChartStacked
* @example      public static WRP_ChartStacked getStackedChart(List <AggregateResult> total, Map<String,Decimal> visiEff, String divOrBranch) {
**/
    public static WRP_ChartStacked getStackedChart(List <AggregateResult> total, Map<String,Decimal> visiEff, String divOrBranch) {
        //Creación de data y label para gráficos
        final Map<String,Decimal> tempdata = new Map<String,Decimal>();
        final Map<String,Decimal> tempvis = new Map<String,Decimal>();
        final list<String> tempLabel = new list<String>();
        for(AggregateResult dat: total) {
           final String div = (String)dat.get(divOrBranch);
            final Decimal totVis = (Decimal)dat.get(VAR_RCDCOUNT);
            Decimal effVis = 0;
            if (visiEff.get(div) != null) {
                effVis = visiEff.get(div);
            }
            tempvis.put(VAR_CONTACT+div, effVis);
            tempvis.put(VAR_NCONTACT+div, (totVis-effVis));
            final Decimal opAux = (effVis*100)/totVis;
            final Decimal percEffVis =opAux.setScale(2);
            final Decimal opValue = (totVis-effVis)*100/totVis;
            final Decimal percPendVis = opValue.setScale(2);
            tempLabel.add(div);
            tempdata.put(VAR_CONTACT+div,percEffVis);
            tempdata.put(VAR_NCONTACT+div,percPendVis); //Label de division //#total de clientes
            //#visitas Efectivas //%visitas Efectivas //%visitas Pendientes
            //System.debug('div '+div); System.debug('totVis '+totVis); System.debug('effVis '+effVis); System.debug('percEffVis '+percEffVis);
            //System.debug('percPendVis '+percPendVis);
        }
        //System.debug('tempdata '+tempdata);
        //Listas de subconjuntos para etiquetas
        final list<String> tempTyOpp = gentempTyOpp();
        //Lista para color
        tempColor = gentempColor();
        //Creación de obj de respuesta
        resultados = new WRP_ChartStacked(tempLabel,tempTyOpp,tempColor,tempdata,tempvis);
        return resultados;
    }

    @AuraEnabled
    /** */
    public static List<AggregateResult> fetchBankMan(String div,String office) {
        final List <AggregateResult> bankManBpyP = new List <AggregateResult>();
        try {
            if(String.isNotBlank(div) && String.isNotBlank(office)) {
                for(AggregateResult agr : [
                    SELECT OwnerId,Owner.Name
                    FROM Account
                    WHERE Owner.VP_ls_Banca__c = 'Red BPyP'
                    AND (NOT (Owner.BPyP_ls_NombreSucursal__c = ''))
                    AND (NOT (Owner.Divisi_n__c = ''))
                    AND Owner.BPyP_ls_NombreSucursal__c=:office
                    AND Owner.Divisi_n__c=:div
                    AND Owner.IsActive=True
                    AND Owner.Title in (:VAR_PATRIM,:VAR_PRD,:VAR_PATRIM_SR)
                    GROUP BY  OwnerId,Owner.Name]) {
                    bankManBpyP.add(agr);
                }
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return bankManBpyP;
    }
    @AuraEnabled
    /** */
    public static WRP_ChartStacked fetchBkMData(String type,String divi,String off,Datetime startDte,Datetime endDte) {
        //fechas de inicio y fin dependiendo de tipo de figura
        Datetime sDate,eDate;
        String title;
        //bimestral de privado
        if(startDte == null || endDte == null) {
            if (type == VAR_PR) {
                title = VAR_PRD;
                sDate = obtStAndEndDate(system.today().month(),VAR_ST);
                eDate = obtStAndEndDate(system.today().month(),VAR_EN);
            //mensual en privado
            } else if (type == VAR_PA) {
                final Integer VAR_SM = retmonth(STR_SM);
                final Integer var_em = retmonth(STR_EM);
                title = VAR_PATRIM;
                sDate = obtStAndEndDate(VAR_SM,VAR_ST);
                eDate = obtStAndEndDate(var_em,VAR_EN);
            } else if (type == VAR_PAS) {
                title = VAR_PATRIM_SR;
                sDate = obtStAndEndDate(system.today().month(),VAR_ST);
                eDate = obtStAndEndDate(system.today().month(),VAR_EN);
            }
        } else {
            sDate=datetime.newInstance(startDte.year(),startDte.month(),(startDte.day()+1));
            eDate=datetime.newInstance(endDte.year(),endDte.month(),(endDte.day()+1));
            acceptNull = false;
            title = getTitle(type, acceptNull);
        }
        try {
            visEfec=[Select dwp_kitv__account_id__r.Owner.Name,COUNT_DISTINCT(dwp_kitv__account_id__c) RecordCount from dwp_kitv__Visit__c where dwp_kitv__account_id__r.Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT(dwp_kitv__account_id__r.Owner.Divisi_n__c='')) and (NOT(dwp_kitv__account_id__r.Owner.BPyP_ls_NombreSucursal__c='')) and (NOT(dwp_kitv__account_id__r.Owner.Name='')) and (dwp_kitv__visit_status_type__c = '05' or dwp_kitv__visit_status_type__c = '06') and (dwp_kitv__account_id__r.RecordType.DeveloperName='BPyP_tre_Cliente' OR dwp_kitv__account_id__r.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and MX_BPP_VerifyOwner__c= true and dwp_kitv__account_id__r.Owner.Divisi_n__c=:divi and dwp_kitv__account_id__r.Owner.BPyP_ls_NombreSucursal__c=:off and LastModifiedDate >=:sDate and LastModifiedDate <=:(eDate+1) and dwp_kitv__account_id__r.Owner.Title=:title group by dwp_kitv__account_id__r.Owner.Name];
            total = [
                SELECT Owner.Name,count(Id) RecordCount
                FROM Account
                WHERE Owner.VP_ls_Banca__c = 'Red BPyP'
                AND (NOT (Owner.BPyP_ls_NombreSucursal__c = ''))
                AND Owner.BPyP_ls_NombreSucursal__c=:off
                AND (NOT (Owner.Divisi_n__c = ''))
                AND Owner.Divisi_n__c=:divi
                AND (NOT (Owner.Name = ''))
                AND Owner.IsActive=True
                AND Owner.Title=:title
                AND (RecordType.DeveloperName='BPyP_tre_Cliente' OR RecordType.DeveloperName='MX_BPP_PersonAcc_Client')
                GROUP BY  Owner.Name];
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        //Creación de mapa para visitas Efectiva
        final Map<String,Decimal> visiEff=genvisieff(visEfec);
        //Creación de data y label para gráficos
        final Map<String,Decimal> tempdata=gentdtv(total,visiEff,V_TDATA);
        final list<String> tempLabel=gentl(total);
        final Map<String,Decimal> tempvis=gentdtv(total,visiEff,'tempvis');
        //System.debug('tempdata '+tempdata);
        //Listas de subconjuntos para etiquetas
        final list<String> tempTyOpp = gentempTyOpp();
        //Lista para color
        tempColor  = gentempColor();
        //Creación de obj de respuesta
        resultados= new WRP_ChartStacked(tempLabel,tempTyOpp,tempColor,tempdata,tempvis);
        return resultados;
    }
    /** */
    public static Map<String,Decimal> gentdtv(list<AggregateResult> total,Map<String,Decimal> visiEff,String ret) {
        final Map<String,Decimal> temp = new Map<String,Decimal>();
        for(AggregateResult dat: total) {
            final String div = (String)dat.get(V_NAME);
            final Decimal totVis = (Decimal)dat.get(VAR_RCDCOUNT);
            Decimal effVis = 0;
            if (visiEff.get(div) != null) {
                effVis = visiEff.get(div);
            }
            if(ret == V_TDATA) {
                final Decimal opAux = (effVis*100)/totVis;
                final Decimal percEffVis =opAux.setScale(2);
                final Decimal opValue = (totVis-effVis)*100/totVis;
                final Decimal percPendVis = opValue.setScale(2);
                temp.put(VAR_CONTACT+div,percEffVis);
                temp.put(VAR_NCONTACT+div,percPendVis);
            } else {
                temp.put(VAR_CONTACT+div, effVis);
                temp.put(VAR_NCONTACT+div, (totVis-effVis));
            }
        }
        return temp;
    }
    /** */
    public static list<String> gentl(list<AggregateResult> total) {
        final list<String> tempLabel=new list<String>();
        for(AggregateResult dat: total) { final String div=(String)dat.get(V_NAME); tempLabel.add(div);
        }
        return tempLabel;
    }
    /** */
    public static Map<String,Decimal> genvisieff(list<AggregateResult> visEfec) {
        final Map<String,Decimal> visiEff=new Map<String,Decimal>();
        for(AggregateResult viE: visEfec) { visiEff.put((String)viE.get(V_NAME),(Decimal)vie.get(VAR_RCDCOUNT)); }
        return visiEff;
    }

    @AuraEnabled
    /**Metodo fetchBkmChanData */
    public static WRP_ChartStacked fetchBkMChanData(String type,String div,String off,Datetime startDte,Datetime endDte) {
        red=genRedBBVA();
        green=genGreenBBVA();
        blue=genBlueBBVA();

        numbCol=25;
        //fechas de inicio y fin dependiendo de tipo de figura
        Datetime sDate,eDate;
        final String title = getTitle(type);
        //bimestral de privado
        if(startDte==null||endDte==null) {
            if (type==VAR_PR) {
                sDate=obtStAndEndDate(system.today().month(),VAR_ST);
                eDate=obtStAndEndDate(system.today().month(),VAR_EN);
            //mensual en privado
            } else if (type==VAR_PAS) {
                sDate=obtStAndEndDate(system.today().month(),VAR_ST);
                eDate=obtStAndEndDate(system.today().month(),VAR_EN);
            } else if (type==VAR_PA) {
                final Integer VAR_SM = retmonth(STR_SM);
                final Integer var_em = retmonth(STR_EM);
                sDate=obtStAndEndDate(VAR_SM,VAR_ST);
                eDate=obtStAndEndDate(var_em,VAR_EN);
            }
        } else {
            sDate=datetime.newInstance(startDte.year(),startDte.month(),(startDte.day()+1));
            eDate=datetime.newInstance(endDte.year(),endDte.month(),(endDte.day()+1));
        }
        try {
            visEfec=[Select RecordType.Name rname,MX_BIE_TipoVisitaLLamada__c,dwp_kitv__account_id__r.Owner.Name,count(Id) RecordCount from dwp_kitv__Visit__c where dwp_kitv__account_id__r.Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT(dwp_kitv__account_id__r.Owner.Divisi_n__c='')) and (NOT(dwp_kitv__account_id__r.Owner.BPyP_ls_NombreSucursal__c='')) and (NOT(dwp_kitv__account_id__r.Owner.Name='')) and (dwp_kitv__visit_status_type__c = '05' or dwp_kitv__visit_status_type__c = '06') and (dwp_kitv__account_id__r.RecordType.DeveloperName='BPyP_tre_Cliente' OR dwp_kitv__account_id__r.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and MX_BPP_VerifyOwner__c= true and dwp_kitv__account_id__r.Owner.Divisi_n__c=:div and dwp_kitv__account_id__r.Owner.BPyP_ls_NombreSucursal__c=:off and LastModifiedDate >=:sDate and LastModifiedDate <=:(eDate+1) and dwp_kitv__account_id__r.Owner.Title=:title group by dwp_kitv__account_id__r.Owner.Name,RecordType.Name,MX_BIE_TipoVisitaLLamada__c];
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        //Creación de mapa para visitas Efectiva
        final Map<String,Decimal> visiEff=genvisieffr(visEfec);
        final Set<String> tempsetlabel=gentsltstr(visEfec,VAR_TMPSTLB);
        final list<String> tempLabel=new list<String>(tempsetlabel);
        final Set<String> tempsettyopp=gentsltstr(visEfec,'tempsettyopp');
        final list<String> tempTyOpp=new list<String>(tempsettyopp);
        tempColor=genbbvacolor(tempTyOpp,red,green,blue,numbCol);
        //Creación de obj de respuesta
        resultados= new WRP_ChartStacked(tempLabel,tempTyOpp,tempColor,visiEff,null);
        return resultados;
    }
    /**Metodo gentsltstr */
    public static Set<String> gentsltstr(list<AggregateResult> visEfec,String ret) {
        final Map<String,Decimal> visiEff=new Map<String,Decimal>();
        final Set<String> tempsetlabel=new Set<String>();
        Set<String> tempsettyopp=new Set<String>();
        for(AggregateResult viE: visEfec) {
            String tyVis=(String)vie.get('rname');
            tyVis=shorttyvis(tyVis,(String)vie.get('MX_BIE_TipoVisitaLLamada__c'));
            final String divi=(String)viE.get(V_NAME);
            tempsetlabel.add(divi);
            tempsettyopp.add(tyVis);
            visiEff.put(tyVis+divi,(Decimal)vie.get(VAR_RCDCOUNT));
        }
        if(ret==VAR_TMPSTLB) {
            tempsettyopp = tempsetlabel;
        }
        return tempsettyopp;
    }
    /**Método genvisieffr */
    public static Map<String,Decimal> genvisieffr(list<AggregateResult> visEfec) {
        final Map<String,Decimal> visiEff=new Map<String,Decimal>();
        for(AggregateResult viE: visEfec) {
            String tyVis=(String)vie.get('rname');
            tyVis=shorttyvis(tyVis,(String)vie.get('MX_BIE_TipoVisitaLLamada__c'));
            final String divi=(String)viE.get(V_NAME);
            visiEff.put(tyVis+divi,(Decimal)vie.get(VAR_RCDCOUNT));
        }
        return visiEff;
    }

    @AuraEnabled
    /** */
    public static WRP_ChartStacked fetchBkMOnlyData(String type, String bkM, Datetime startDte, Datetime endDte) {
        String title;
        Datetime sDate, eDate;
        if(startDte == null || endDte == null) {
            if (type == VAR_PR) {
                title = VAR_PRD;
                sDate = obtStAndEndDate(system.today().month(),VAR_ST);
                eDate = obtStAndEndDate(system.today().month(),VAR_EN);
            } else if (type == VAR_PA) {
                final Integer VAR_SM = retmonth(STR_SM);
                final Integer var_em = retmonth(STR_EM);
                title = VAR_PATRIM;
                sDate = obtStAndEndDate(VAR_SM,VAR_ST);
                eDate = obtStAndEndDate(var_em,VAR_EN);
            } else if (type == VAR_PAS) {
                title = VAR_PATRIM_SR;
                sDate = obtStAndEndDate(system.today().month(),VAR_ST);
                eDate = obtStAndEndDate(system.today().month(),VAR_EN);
            }
        } else {
            sDate = datetime.newInstance(startDte.year(),startDte.month(),(startDte.day()+1));
            eDate = datetime.newInstance(endDte.year(),endDte.month(),(endDte.day()+1));
            acceptNull = false;
            title = getTitle(type, acceptNull);
        }
        try {
            visEfec=[Select dwp_kitv__account_id__r.Owner.Name,COUNT_DISTINCT(dwp_kitv__account_id__c) RecordCount from dwp_kitv__Visit__c where dwp_kitv__account_id__r.Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT(dwp_kitv__account_id__r.Owner.Divisi_n__c='')) and (NOT(dwp_kitv__account_id__r.Owner.BPyP_ls_NombreSucursal__c='')) and (NOT(dwp_kitv__account_id__r.Owner.Name='')) and (dwp_kitv__visit_status_type__c = '05' or dwp_kitv__visit_status_type__c = '06') and (dwp_kitv__account_id__r.RecordType.DeveloperName='BPyP_tre_Cliente' OR dwp_kitv__account_id__r.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and MX_BPP_VerifyOwner__c= true and dwp_kitv__account_id__r.Owner.Name=:bkM and LastModifiedDate >=:sDate and LastModifiedDate <=:(eDate+1) and dwp_kitv__account_id__r.Owner.Title=:title group by dwp_kitv__account_id__r.Owner.Name];
            total = [
                SELECT Owner.Name,count(Id) RecordCount
                FROM Account
                WHERE Owner.VP_ls_Banca__c = 'Red BPyP'
                AND (NOT (Owner.BPyP_ls_NombreSucursal__c = ''))
                AND (NOT (Owner.Divisi_n__c = ''))
                AND (NOT (Owner.Name = ''))
                AND Owner.Name=:bkM
                AND Owner.IsActive=True
                AND Owner.Title=:title
                AND (RecordType.DeveloperName='BPyP_tre_Cliente' OR RecordType.DeveloperName='MX_BPP_PersonAcc_Client')
                GROUP BY  Owner.Name];
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
        //Creación de mapa para visitas Efectiva
        final Map<String,Decimal> visiEff = genvisieff(visEfec);
        //Creación de data y label para gráficos
        final Map<String,Decimal> tempdata = gentdtv(total,visiEff,V_TDATA);
        final Map<String,Decimal> tempvis = gentdtv(total,visiEff,'tempvis');
        final list<String> tempLabel = gentl(total);
        //Listas de subconjuntos para etiquetas
        final list<String> tempTyOpp = gentempTyOpp();
        //Lista para color
        tempColor = gentempColor();
        //Creación de obj de respuesta
        resultados = new WRP_ChartStacked(tempLabel,tempTyOpp,tempColor,tempdata,tempvis);
        return resultados;
    }

    @AuraEnabled
    /**Metodo fetchBKMOnlyChanData */
    public static WRP_ChartStacked fetchBkMOnlyChanData(String type,String bkM,Datetime startDte,Datetime endDte) {
        red=genRedBBVA();
        blue=genBlueBBVA();
        green=genGreenBBVA();

        numbCol=25;
        //fechas de inicio y fin dependiendo de tipo de figura
        Datetime sDate,eDate;
        final String title = getTitle(type);
        //bimestral de privado
        if(startDte==null||endDte==null) {
            if (type==VAR_PR) {
                sDate=obtStAndEndDate(system.today().month(),VAR_ST);
                eDate=obtStAndEndDate(system.today().month(),VAR_EN);
            //mensual en privado
            } else if (type==VAR_PAS) {
                sDate=obtStAndEndDate(system.today().month(),VAR_ST);
                eDate=obtStAndEndDate(system.today().month(),VAR_EN);
            } else if (type==VAR_PA) {
                final Integer VAR_SM = retmonth(STR_SM);
                final Integer var_em = retmonth(STR_EM);
                sDate=obtStAndEndDate(VAR_SM,VAR_ST);
                eDate=obtStAndEndDate(var_em,VAR_EN);
            }
        } else {
            sDate=datetime.newInstance(startDte.year(),startDte.month(),(startDte.day()+1));
            eDate=datetime.newInstance(endDte.year(),endDte.month(),(endDte.day()+1));
        }
        try {
            visEfec=[Select RecordType.Name rname,MX_BIE_TipoVisitaLLamada__c,dwp_kitv__account_id__r.Owner.Name,count(Id) RecordCount from dwp_kitv__Visit__c where dwp_kitv__account_id__r.Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT(dwp_kitv__account_id__r.Owner.Divisi_n__c='')) and (NOT(dwp_kitv__account_id__r.Owner.BPyP_ls_NombreSucursal__c='')) and (NOT(dwp_kitv__account_id__r.Owner.Name='')) and (dwp_kitv__visit_status_type__c = '05' or dwp_kitv__visit_status_type__c = '06') and (dwp_kitv__account_id__r.RecordType.DeveloperName='BPyP_tre_Cliente' OR dwp_kitv__account_id__r.RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and MX_BPP_VerifyOwner__c= true and dwp_kitv__account_id__r.Owner.Name=:bkM and LastModifiedDate >=:sDate and LastModifiedDate <=:(eDate+1) and dwp_kitv__account_id__r.Owner.Title=:title group by dwp_kitv__account_id__r.Owner.Name,RecordType.Name,MX_BIE_TipoVisitaLLamada__c];
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        //Creación de mapa para visitas Efectiva
        final Map<String,Decimal> visiEff=genvisieffr(visEfec);
        final Set<String> tempsetlabel=gentsltstr(visEfec,VAR_TMPSTLB);
        final Set<String> tempsettyopp=gentsltstr(visEfec,'tempsettyopp');
        final list<String> tempTyOpp=new list<String>(tempsettyopp);
        final list<String> tempLabel=new list<String>(tempsetlabel);
        //Lista para color
        tempColor=genbbvacolor(tempTyOpp,red,green,blue,numbCol);
        //Creación de obj de respuesta
        resultados= new WRP_ChartStacked(tempLabel,tempTyOpp,tempColor,visiEff,null);
        return resultados;
    }
/**Creación de metodo getTitle */
    public static String getTitle(String type, Boolean acceptNull) {
        String title = '';
        if(acceptNull) {
            if(type == VAR_PR || type == null) {
                title = VAR_PRD;
            }
        } else {
            if(type == VAR_PR) {
                title = VAR_PRD;
            }
        }
        if (type == VAR_PA) {
            title = VAR_PATRIM;
        } else if (type == VAR_PAS) {
            title = VAR_PATRIM_SR;
        }
        return title;
    }

    /** Wrapper class for chart.js with labels, data and color*/
    public class WRP_ChartStacked {
        /**Lista lsLabels */
        @AuraEnabled public list<String> lsLabels {get; set;}
        /**Lista lsTyOpp */
        @AuraEnabled public list<String> lsTyOpp {get; set;}
        /**Lista lsColor */
        @AuraEnabled public list<String> lsColor {get; set;}
        /** Mapa lsData*/
        @AuraEnabled public Map<String, Decimal> lsData {get; set;}
        /**Mapa numVis*/
        @AuraEnabled public Map<String, Decimal> numVis {get; set;}
        /** Metodo */
        public WRP_ChartStacked(list<String> label,list<String> tyOpp,list<String> color,Map<String, Decimal> data,Map<String, Decimal> vis) {
            lsLabels=label;
            lsTyOpp=tyOpp;
            lsColor=color;
            lsData=data;
            numVis=vis;
        }
    }
    /*
    *@Descripción   Método de procesamiento de Clientes Contactados y No Contactados.
    *@Author        Francisco J Licona, Email: franciscojavier.licona.rodrig@bbva.com
    *@Date          15/01/2019
    *@Param         banquero (Nombre del Banquero)
    *@Param         contactType (Indica el tipo de contactabilidad)
    *@Param         startDte (Fecha de Inicio)
    *@Param         endDte (Fecha de Finalización)
    *@Param         tittle (Tipo de Figura del Banquero)
    *@return        Regresa lista de Clientes procesados.
    *@example       BPyP_Contact_Acc.contactabilityAccount('EJEMPLO BANQUERO', 'Contact', System.now(), System.now().addDays(5), VAR_PATRIM);
    */
    @AuraEnabled
    public static List<Account> contactabilityAccount(String banquero, String contactType, DateTime startDte, DateTime endDte, String tittle) {
        Integer varSm;
        Integer varEm;
        if(tittle == VAR_PATRIM) {
             varSm = retmonth(STR_SM);
             varEm = retmonth(STR_EM);
        } else {
             varSm = system.today().month();
             varEm = system.today().month();
        }
        DateTime stDate = obtStAndEndDate(varSm,VAR_ST);
        DateTime enDate = obtStAndEndDate(varEm,VAR_EN);
        if(startDte != null ||endDte != null) {
            stDate = datetime.newInstance(DateTime.ValueOf(startDte).year(),DateTime.ValueOf(startDte).month(),(DateTime.ValueOf(startDte).day()+1));
            enDate = datetime.newInstance(DateTime.ValueOf(endDte).year(),DateTime.ValueOf(endDte).month(),(DateTime.ValueOf(endDte).day()+1));
        }
        try {
            final List<Account> accResult = new List<Account>();
            for(Account acc: [SELECT Id, Name, No_de_cliente__c, BPyP_Rb_Family_Group_al_que_pertenece__c, Phone, Owner.Name, BPyP_Fecha_de_ultima_visita__c, (SELECT Id, Name, dwp_kitv__visit_status_type__c FROM dwp_kitv__Visits__r WHERE ((NOT(dwp_kitv__account_id__r.Owner.Divisi_n__c=null)) AND (NOT(dwp_kitv__account_id__r.Owner.BPyP_ls_NombreSucursal__c=null)) AND dwp_kitv__account_id__r.Owner.Name=:banquero AND LastModifiedDate >=:stDate AND LastModifiedDate <=:(enDate+1) AND dwp_kitv__account_id__r.Owner.Title=:tittle AND (dwp_kitv__account_id__r.RecordType.DeveloperName='BPyP_tre_Cliente' OR dwp_kitv__account_id__r.RecordType.DeveloperName='MX_BPP_PersonAcc_Client'))) FROM Account WHERE Owner.Name=:banquero AND (RecordType.DeveloperName = 'BPyP_tre_Cliente' OR RecordType.DeveloperName = 'MX_BPP_PersonAcc_Client') AND Owner.Title=:tittle LIMIT 10000]) {
                final Set<Account> accSet = processAccounts(acc, contactType);
                if(!accSet.isEmpty()) {
                    accResult.addAll(accSet);
                }
            }
            return accResult;
        } catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          07-06-2019
* @Description  Process the accounts to know the contacted an not contacted clients.
* @Comments     Created from the clipped code block of method contactabilityAccount.
* @param        Account acc, String contactType
* @return       Set<Account>
* @example      public static Set<Account> processAccounts(Account acc, String contactType) {
**/
    public static Set<Account> processAccounts(Account acc, String contactType) {
    final Set<Account> accSet = new Set<Account>();
    final String nfive='05',nsix='06', nContact='Contact',noContact='NonContact'; //NOSONAR
        contact = false;
        if(acc.dwp_kitv__Visits__r.size()>0) {
            for(dwp_kitv__Visit__c rv: acc.dwp_kitv__Visits__r) {
                if (nfive.equals(rv.dwp_kitv__visit_status_type__c) || nsix.equals(rv.dwp_kitv__visit_status_type__c) ) {
                    if(nContact.equals(contactType)) {
                        accSet.add(acc);
                    }
                    contact = true;
                } else if(!contact && noContact.equals(contactType)) {
                    accSet.add(acc);
                }
            }
        } else {
            if(noContact.equals(contactType)) {
                accSet.add(acc);
            }
        }
        return accSet;
    }

    /*
    *@Descripción   Método que extrae datos del owner apartir de su RI.
    *@Author        Adrián Pastor Pineda, Email: adrian.pastor.contractor@bbva.com
    *@Date          28/01/2019
    *@Param         vIdRI (RI del Banquero)
    *@return        Regresa la consulta en String.
    *@example       BPyP_Contact_Acc.getRISelect('06m1B000001GaPeQAK');
    */
	@AuraEnabled
    public static String getRISelect(String vIdRI) {
       String result=''; //NOSONAR
       try {
           if(BPyP_OppRep.getRISelect(vIdRI) != null) {
               result= BPyP_OppRep.getRISelect(vIdRI).Title; //NOSONAR
            }
       } catch (Exception e) {
           throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
       }
       return result;
    }
}