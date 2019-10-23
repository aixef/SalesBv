/*
    Proyecto :	ENGMX
    Versión     Fecha           Autor                   Descripción
    ___________________________________________________________________________________________________
    1.0         08-Nov-2018     Cristian Espinosa       Creación de la clase.
														Clase de utilidades para los componentes BPyP_AccountFiltr,
														BPyP_Contact_Acc,BPyP_OppRep,BPyP_Contact_Chan.
														Generalmente usada para retornar información de los usuarios.
														*Clases de pruebas : BPyP_AccFiltrTest,BPyP_OppRepTest,BPyP_Contact_AccTest.
	1.1			21-Nov-2018		Cristian Espinosa		Se agrega campo title al método getUsrData.
*/
public with sharing class MX_BPP_CompUtils_cls {

    //Constructor with no arguments
    private MX_BPP_CompUtils_cls() {
    }

    /** Lista divBpyp*/
    private static List<AggregateResult> divBpyP = new List<AggregateResult>();
    /** Mapa offBpyp*/
    private static Map<String,List<AggregateResult>> offBpyP = new Map<String,List<AggregateResult>>();
    /** Mapa usrBpyp*/
    private static Map<String,List<AggregateResult>> usrBpyP = new Map<String,List<AggregateResult>>();
    /** Lista red*/
    private static List<Integer> red = new List<Integer>();
    /** Lista blue*/
    private static List<Integer> blue = new List<Integer>();
    /** Lista green*/
    private static List<Integer> green = new List<Integer>();

    /*
    	@description: 	Método que obtiene todas las divisiones de los usuarios BPyP activos.
						Se hace uso de variables estáticas para evitar hacer consultas innecesarias.
	*/
    public static List<AggregateResult> getBPyPDivisions() {
        //Obtention of Divisions
        if(divBpyP.isEmpty()) {
            for(AggregateResult agr : [Select Owner.Divisi_n__c from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.IsActive=True group by  Owner.Divisi_n__c]) {
                divBpyP.add(agr);
            }
        }
        return divBpyP;
    }

    /*
    	@description: 	Método que obtiene las oficinas de los usuarios BPyP activos de alguna división.
						Se hace uso de variables estáticas para evitar hacer consultas innecesarias.
	*/
    public static List<AggregateResult> getBPyPOffices(String div) {
        List <AggregateResult> lsReturn = new List <AggregateResult>();
        //if no divisions will send null to clear errors
        if(String.isNotBlank(div)) {
            lsReturn = new List <AggregateResult>();
            if(offBpyP.containsKey(div)) {
                lsReturn = offBpyP.get(div);
            } else {
                for(AggregateResult agr : [Select Owner.BPyP_ls_NombreSucursal__c from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT(Owner.Divisi_n__c = '')) and Owner.Divisi_n__c=:div and Owner.IsActive=True group by  Owner.BPyP_ls_NombreSucursal__c]) {
                    lsReturn.add(agr);
                }
                offBpyP.put(div,lsReturn);
            }
        }
        return lsReturn;
    }

    /*
    	@description: 	Método que obtiene las oficinas de los usuarios BPyP activos de alguna división.
						Se hace uso de variables estáticas para evitar hacer consultas innecesarias.
	*/
    public static List<AggregateResult> getBPyPUsrs(String div,String office) {
        List <AggregateResult> lsReturn = new List <AggregateResult>();
        if(String.isNotBlank(div) && String.isNotBlank(office)) {
            lsReturn = new List <AggregateResult>();
            if(usrBpyP.containsKey(office)) {
                lsReturn = usrBpyP.get(office);
            } else {
                for(AggregateResult agr : [SELECT OwnerId,Owner.Name from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT(Owner.BPyP_ls_NombreSucursal__c = '')) and (NOT (Owner.Divisi_n__c = '')) and Owner.BPyP_ls_NombreSucursal__c=:office and Owner.Divisi_n__c=:div and Owner.IsActive=True group by  OwnerId,Owner.Name]) {
                    lsReturn.add(agr);
                }
                usrBpyP.put(office,lsReturn);
            }
        }
        return lsReturn;
    }
    /**Metodo getUsrData */
    public static List<String> getUsrData() {
        final List<String> res = new List<String>();
        final User actusr = [select Id,Name,Divisi_n__c,BPyP_ls_NombreSucursal__c,profile.Name,Title from User where Id = :UserInfo.getUserId()];
        if(actusr.profile.Name == null) {
            res.add(' ');
        } else {
            res.add(actusr.profile.Name);
        }
        if(actusr.Divisi_n__c == null) {
            res.add(' ');
        } else {
            res.add(actusr.Divisi_n__c);
        }
        if(actusr.BPyP_ls_NombreSucursal__c == null) {
            res.add(' ');
        } else {
            res.add(actusr.BPyP_ls_NombreSucursal__c);
        }
        if(actusr.Name == null) {
            res.add(' ');
        } else {
            res.add(actusr.Name);
        }
        if(actusr.Title == null) {
            res.add(' ');
        } else {
            res.add(actusr.Title);
        }
        return res;
    }
    /**Metodo getbaseUrl */
	public static String getBaseUrl( ) {
        String dir=URL.getSalesforceBaseUrl().toExternalForm() + '/';
        dir=dir.mid(0,dir.indexOf('.'))+'.lightning.force.com/one/one.app#/sObject/';
        return dir;
    }

    /*
    	Métodos que crean arreglos de enteros para generar colores, los usan todos los componentes.
    */
    public static List<Integer> genRedBBVA() {
        if(red.isEmpty()) {
            red.add(0); red.add(10); red.add(45); red.add(42); red.add(216); red.add(90); red.add(247); red.add(243); red.add(70); red.add(247);
            red.add(247); red.add(100); red.add(190); red.add(215); red.add(212); red.add(156); red.add(183); red.add(40); red.add(2); red.add(197);
            red.add(185); red.add(143); red.add(247); red.add(103); red.add(39);
        }
        return red;
    }
    /** Metodo genGreenBBVA */
    public static List<Integer> genGreenBBVA() {
        if(green.isEmpty()) {
            green.add(69); green.add(95); green.add(204); green.add(134); green.add(190); green.add(190); green.add(137); green.add(94); green.add(175); green.add(205);
            green.add(140); green.add(100); green.add(190); green.add(55); green.add(237); green.add(108); green.add(158); green.add(133); green.add(132); green.add(105);
            green.add(42); green.add(122); green.add(137); green.add(84); green.add(122);
        }
        return green;
    }
    /**Método genBlueBBVA */
    public static List<Integer> genBlueBBVA() {
        if(blue.isEmpty()) {
            blue.add(130); blue.add(180); blue.add(205); blue.add(202); blue.add(117); blue.add(255); blue.add(59); blue.add(97); blue.add(100); blue.add(82);
            blue.add(232); blue.add(100); blue.add(190); blue.add(80); blue.add(252); blue.add(1); blue.add(94); blue.add(202); blue.add(132); blue.add(185);
            blue.add(69); blue.add(229); blue.add(60); blue.add(184); blue.add(62);
        }
        return blue;
    }

}