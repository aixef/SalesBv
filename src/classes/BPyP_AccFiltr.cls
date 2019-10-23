/*
    Versiones       Fecha           Autor               Descripción
    1.0             ?               ?                   ?
    1.1             18/01/2018      Cristian Espinosa   Se cambia el campo telefono__c por Phone. (SHIELD)
	1.2				12/11/2018		Cristian Espinosa	Se hace uso de una clase de utilidades para los componentes de la página de inicio
														de BPyP, que guarda los resultados de las consultas en variables estaticas para no
														llegar al límite de los registros retornados por consulta (50,000).
    1.3             03/07/2019      Hugo Carrillo       Resolución de Code Smells detectados por Sonar.
    1.4             15/08/2019      Cindy Hernández     Se agregan referencias a los tipos de registro
														MX_BPP_PersonAcc_Client y MX_BPP_PersonAcc_NoClient.
    1.5             16/08/2019      Gabriel Garcia      Se agregan campo MX_LastSecondName para cuentas personales
    1.6             27/08/2019      Cindy Hernández     Se utiliza etiqueta NOSONAR para falsos positrivos en Potentially unused variable 
                                                        found.
*/
public with sharing class BPyP_AccFiltr {

    private BPyP_AccFiltr() {}

    @AuraEnabled
    /**Método fetchAcc */
    public static List<Account> fetchAcc(String BkMn,String type,Integer off) {
        List<Account> BpypAcc=new List<Account>();
        //System.debug('BkMn '+BkMn); System.debug('type '+type); System.debug('off '+off);
        try {
            if(type=='CP') {
                BpypAcc=[SELECT Id,Name, AccountNumber, BPyP_Rb_Family_Group_al_que_pertenece__c, BPyP_Rb_Family_Group_al_que_pertenece__r.Name , Phone,  RecordType.Name,Owner.Name,BPyP_Fecha_de_ultima_visita__c FROM Account where Owner.Name=:BkMn and RecordType.DeveloperName in ('BPyP_tre_Cliente','BPyP_tre_noCliente','MX_BPP_PersonAcc_Client','MX_BPP_PersonAcc_NoClient') Limit 10 Offset :off]; //NOSONAR
            } else if (type=='C') {
                BpypAcc=[SELECT Id,Name, AccountNumber, BPyP_Rb_Family_Group_al_que_pertenece__c, BPyP_Rb_Family_Group_al_que_pertenece__r.Name , Phone,  RecordType.Name,Owner.Name,BPyP_Fecha_de_ultima_visita__c FROM Account where Owner.Name=:BkMn and (RecordType.DeveloperName='BPyP_tre_Cliente' OR RecordType.DeveloperName='MX_BPP_PersonAcc_Client') Limit 10 Offset :off ]; //NOSONAR
            } else if (type=='P') {
                BpypAcc=[SELECT Id,Name, AccountNumber, BPyP_Rb_Family_Group_al_que_pertenece__c, BPyP_Rb_Family_Group_al_que_pertenece__r.Name , Phone,  RecordType.Name,Owner.Name,BPyP_Fecha_de_ultima_visita__c FROM Account where Owner.Name=:BkMn and (RecordType.DeveloperName='BPyP_tre_noCliente' OR RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') Limit 10 Offset :off ]; //NOSONAR
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return BpypAcc;
    }

    @AuraEnabled
    /**Metodo fetchPgs */
    public static Integer fetchPgs(String BkMn,String type) {
        //System.debug('BkMn '+BkMn); System.debug('type '+type);
        AggregateResult ar=null;
        Integer numpgs=null;
        try {
            if(type=='CP') {
                ar=[SELECT Count(Id) FROM Account where Owner.Name=:BkMn and RecordType.DeveloperName in ('BPyP_tre_Cliente','BPyP_tre_noCliente','MX_BPP_PersonAcc_Client','MX_BPP_PersonAcc_NoClient')]; //NOSONAR
            } else if (type=='C') {
                ar=[SELECT Count(Id) FROM Account where Owner.Name=:BkMn and (RecordType.DeveloperName='BPyP_tre_Cliente' OR RecordType.DeveloperName='MX_BPP_PersonAcc_Client')]; //NOSONAR
            } else if (type=='P') {
                ar=[SELECT Count(Id) FROM Account where Owner.Name=:BkMn and (RecordType.DeveloperName='BPyP_tre_noCliente' OR RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient')]; //NOSONAR
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        System.debug(ar);
        Integer n=(Integer)ar.get('expr0');
        numpgs=math.mod((n),10)==0?((n)/10):((n)/10)+1;
        System.debug('numpgs '+numpgs);
        return numpgs;
    }

    @AuraEnabled
    /**Metodo fetchbaseurl */
    public static String fetchbaseurl() {
        String url = '';
        try {
            url = MX_BPP_CompUtils_cls.getBaseUrl();
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return url;
    }

    @AuraEnabled
    /**Método fetchusdata */
    public static List<String> fetchusdata() {
        List<String> usrData = new List<String>();
        try {
            usrData = MX_BPP_CompUtils_cls.getUsrData();
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return usrData;
    }

    @AuraEnabled
    /**Metodo fetchDiv */
    public static List<AggregateResult> fetchDiv() {
        List<AggregateResult> bpypDivisions = new List<AggregateResult>();
        try {
            bpypDivisions = MX_BPP_CompUtils_cls.getBPyPDivisions();
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return bpypDivisions;
    }

    @AuraEnabled
    /**Metodo fetchDivData */
    public static WRP_Chart fetchDivData(String type) {
        List <AggregateResult> DivBpyP;
        List<Integer> red=BPyP_AccFiltr_Utilities.genRedBBVA();
        List<Integer> green=BPyP_AccFiltr_Utilities.genGreenBBVA();
        List<Integer> blue=BPyP_AccFiltr_Utilities.genBlueBBVA();
        Integer numbCol=25;
        try {
            //Clientes y prospectos
            if(type=='CP'||type==null) {
                DivBpyP=[Select  Owner.Divisi_n__c, RecordType.Name, count(Id) RecordCount from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.IsActive=True and RecordType.DeveloperName in ('BPyP_tre_Cliente','BPyP_tre_noCliente','MX_BPP_PersonAcc_Client','MX_BPP_PersonAcc_NoClient') group by  Owner.Divisi_n__c, RecordType.Name]; //NOSONAR
            //Clientes
            } else if (type=='C') {
                DivBpyP=[Select  Owner.Divisi_n__c, RecordType.Name, count(Id) RecordCount from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.IsActive=True and RecordType.DeveloperName in ('BPyP_tre_Cliente','MX_BPP_PersonAcc_Client') group by  Owner.Divisi_n__c, RecordType.Name]; //NOSONAR
            //Prospectos
            } else if (type=='P') {
                DivBpyP=[Select  Owner.Divisi_n__c, RecordType.Name, count(Id) RecordCount from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.IsActive=True and RecordType.DeveloperName in ('BPyP_tre_noCliente','MX_BPP_PersonAcc_NoClient') group by  Owner.Divisi_n__c, RecordType.Name]; //NOSONAR
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }

        List<String> div=new List<String>();
        List<String> tempTyAc=new List<String>();
        Map<String, Integer> num= new Map<String, Integer>();
        List<String> color= new List<String>();
        System.debug('DivBpyP '+DivBpyP);
        //Creation of objects to sent and added to the lists
        Integer idx=0;
        for(AggregateResult ar: DivBpyP) {
            String c='rgb('+red[Math.mod(idx,numbCol)]+', '+green[Math.mod(idx,numbCol)]+', '+blue[Math.mod(idx,numbCol)]+')';
            String d=(String)ar.get('Divisi_n__c');
            String nm=(String)ar.get('Name');
            Integer n=(Integer)ar.get('RecordCount'); idx++;
            div.add(d);
            tempTyAc.add(nm);
            num.put(d+nm,n);
            color.add(c);
            //addition to the lists
            //Values for rgbo on grpahs
            //Double mult=1000*Math.random(); Integer limcolor=256;
            //Generation of rgb string
            /* String c='rgb('+Math.mod((Math.random()*mult).intValue(), limcolor)+', '+
            Math.mod((Math.random()*mult).intValue(), limcolor)+', '+
            Math.mod((Math.random()*mult).intValue(), limcolor)+')'; */
        }
        List<String> tyAc=BPyP_AccFiltr_Utilities.dedupllist(tempTyAc);
        List<String> tempDiv=BPyP_AccFiltr_Utilities.dedupllist(div);
        color.add('rgb');
        WRP_Chart res=new WRP_Chart(tempDiv,tyAc,num,color);
        return res;
    }

    @AuraEnabled
    /**Metodo fetchOff */
    public static List<AggregateResult> fetchOff(String div) {
        List<AggregateResult> bpypOffices = new List<AggregateResult>();
        try {
            bpypOffices = MX_BPP_CompUtils_cls.getBPyPOffices(div);
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        return bpypOffices;
    }

    @AuraEnabled
    /**Metodo fetchOffData */
    public static WRP_Chart fetchOffData(String divi, String type) {
        List <AggregateResult> OffBpyP;
        List<Integer> red=BPyP_AccFiltr_Utilities.genRedBBVA();
        List<Integer> green=BPyP_AccFiltr_Utilities.genGreenBBVA();
        List<Integer> blue=BPyP_AccFiltr_Utilities.genBlueBBVA();
        Integer numbCol=25;
        try {
            //Clientes y prospectos
            if(type=='CP') {
                OffBpyP=[Select  Owner.BPyP_ls_NombreSucursal__c, RecordType.Name, count(Id) RecordCount from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.Divisi_n__c=:divi and Owner.IsActive=True and RecordType.DeveloperName in ('BPyP_tre_Cliente','BPyP_tre_noCliente','MX_BPP_PersonAcc_Client','MX_BPP_PersonAcc_NoClient') group by  Owner.BPyP_ls_NombreSucursal__c, RecordType.Name]; //NOSONAR
            //Clientes
            } else if (type=='C') {
                OffBpyP=[Select  Owner.BPyP_ls_NombreSucursal__c, RecordType.Name, count(Id) RecordCount from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.Divisi_n__c=:divi and Owner.IsActive=True and (RecordType.DeveloperName='BPyP_tre_Cliente' OR RecordType.DeveloperName='MX_BPP_PersonAcc_Client') group by  Owner.BPyP_ls_NombreSucursal__c, RecordType.Name]; //NOSONAR
            //Prospectos
            } else if (type=='P') {
                OffBpyP=[Select  Owner.BPyP_ls_NombreSucursal__c, RecordType.Name, count(Id) RecordCount from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.Divisi_n__c=:divi and Owner.IsActive=True and (RecordType.DeveloperName='BPyP_tre_noCliente' OR RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') group by  Owner.BPyP_ls_NombreSucursal__c, RecordType.Name]; //NOSONAR
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        List<String> div=new List<String>();
        List<String> tempTyAc=new List<String>();
        Map<String, Integer> num= new Map<String, Integer>();
        List<String> color= new List<String>();
        //Creation of objects to sent and added to the lists
        Integer idx=0;
        for(AggregateResult ar: OffBpyP) {String c='rgb('+red[Math.mod(idx,numbCol)]+', '+green[Math.mod(idx,numbCol)]+', '+blue[Math.mod(idx,numbCol)]+')'; idx++; String d=(String)ar.get('BPyP_ls_NombreSucursal__c'); String nm=(String)ar.get('Name'); Integer n=(Integer)ar.get('RecordCount'); div.add(d); tempTyAc.add(nm); num.put(d+nm,n); color.add(c);}
        List<String> tyAc=BPyP_AccFiltr_Utilities.dedupllist(tempTyAc);
        List<String> tempDiv=BPyP_AccFiltr_Utilities.dedupllist(div);
        color.add('rgb');
        //Added string to obtain last color as split is ),
        WRP_Chart res=new WRP_Chart(tempDiv,tyAc,num,color);
        return res;
    }

    @AuraEnabled
    /**Metodo fetchBankMan */
    public static List<AggregateResult> fetchBankMan(String div,String office) {
        List<AggregateResult> bpypUsrs = new List<AggregateResult>();
        try {
            bpypUsrs = MX_BPP_CompUtils_cls.getBPyPUsrs(div, office);
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
    	return bpypUsrs;
    }

    @AuraEnabled
    /**Metodo fetchBkmData */
    public static WRP_Chart fetchBkMData(String divi,String office,String bkm,String type) {
        List <AggregateResult> OffBpyP;
        List<Integer> red=BPyP_AccFiltr_Utilities.genRedBBVA();
        List<Integer> green=BPyP_AccFiltr_Utilities.genGreenBBVA();
        List<Integer> blue=BPyP_AccFiltr_Utilities.genBlueBBVA();
        Integer numbCol=25;
        try {
            //Clientes y prospectos
            if(String.isNotBlank(bkm)) {
                OffBpyP = BpyP_AccFiltr_Utilities.fetchBkMDataBkmEmpty(divi, office, bkm, type);
            } else if(type=='CP') {
                OffBpyP=[Select  Owner.Name, RecordType.Name rname, count(Id) RecordCount from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.BPyP_ls_NombreSucursal__c=:office and Owner.Divisi_n__c=:divi and Owner.IsActive=True and RecordType.DeveloperName in ('BPyP_tre_Cliente','BPyP_tre_noCliente','MX_BPP_PersonAcc_Client','MX_BPP_PersonAcc_NoClient') group by  Owner.Name, RecordType.Name]; //NOSONAR
            //Clientes
            } else if (type=='C') {
                OffBpyP=[Select  Owner.Name, RecordType.Name rname, count(Id) RecordCount from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.BPyP_ls_NombreSucursal__c=:office and Owner.Divisi_n__c=:divi and Owner.IsActive=True and (RecordType.DeveloperName='BPyP_tre_Cliente' OR RecordType.DeveloperName='MX_BPP_PersonAcc_Client') group by  Owner.Name, RecordType.Name]; //NOSONAR
            //Prospectos
            } else if (type=='P') {
                OffBpyP=[Select  Owner.Name, RecordType.Name rname, count(Id) RecordCount from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.BPyP_ls_NombreSucursal__c=:office and Owner.Divisi_n__c=:divi and Owner.IsActive=True and (RecordType.DeveloperName='BPyP_tre_noCliente' OR RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') group by  Owner.Name, RecordType.Name]; //NOSONAR
            }
        } catch (QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico+ ' ' + e);
        }
        List<String> div=new List<String>();
        List<String> tempTyAc=new List<String>();
        Map<String, Integer> num= new Map<String, Integer>();
        List<String> color= new List<String>();
        Integer idx=0;
        for(AggregateResult ar: OffBpyP) {
            String c='rgb('+red[Math.mod(idx,numbCol)]+', '+green[Math.mod(idx,numbCol)]+', '+blue[Math.mod(idx,numbCol)]+')';
            idx++; String d=(String)ar.get('Name'); String nm=(String)ar.get('rname'); Integer n=(Integer)ar.get('RecordCount');
            div.add(d);
            tempTyAc.add(nm);
            num.put(d+nm,n);
            color.add(c);
        }
        List<String> tyAc=BPyP_AccFiltr_Utilities.dedupllist(tempTyAc);
        List<String> tempDiv=BPyP_AccFiltr_Utilities.dedupllist(div);
        color.add('rgb');
        WRP_Chart res=new WRP_Chart(tempDiv,tyAc,num,color);
        return res;
    }

    /**Wrapper class for chart.js with labels, data and color */
    public class WRP_Chart {
        /** lista lsLabels*/
        @AuraEnabled public list<String> lsLabels {get; set;}
        /** Lista lsTyAcc*/
        @AuraEnabled public list<String> lsTyAcc {get; set;}
        /** lista lscolor*/
        @AuraEnabled public list<String> lscolor {get; set;}
        /** lsData*/
        @AuraEnabled public Map<String, Integer> lsData {get; set;}
        /** */
        public WRP_Chart(list<String> label,list<String> tyAcc,Map<String, Integer> data,list<String> color) {
            lsLabels=label;
            lsTyAcc=tyAcc;
            lsData=data;
            lscolor=color;
        }

    }
}