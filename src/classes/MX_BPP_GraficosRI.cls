/**
*Desarrollado por:       Indra
*Autor:                  Ricardo Almanza
*Proyecto:               BpyP
*Descripción:            Clase para obtención de graficos de Ri y tableros
*
*Cambios (Versiones) prueba
*--------------------------------------------------------------------------------------------------------------------------
*No.         Fecha            Autor                           						Descripción
*------   ----------------   --------------------   -----------------------------------------------------------------------
*1.0      01-06-2018         Monserrat Gonzalez         Creación
*1.1      15-06-2018         Ricardo Almanza            Mejora para EU de BPyP
*1.2      26-06-2018         Ricardo Almanza            Se agrega con o sin acentos ignorando casing,  por carga data mart
*1.3      24/05/2019         Cindy Hernández            Resolución de code smells detectados por sonar.
**/
public With Sharing class MX_BPP_GraficosRI {

   //Constructor with no arguments
   @TestVisible
   private MX_BPP_GraficosRI() {
   }

    private static List<Integer> genRedBBVA() {
        final List<Integer> red=new List<Integer>();
        red.add(0); red.add(10); red.add(45); red.add(42); red.add(216); red.add(90); red.add(247); red.add(243); red.add(70); red.add(247);
        red.add(247); red.add(100); red.add(190); red.add(215); red.add(212); red.add(156); red.add(183); red.add(40); red.add(2); red.add(197);
        red.add(185); red.add(143); red.add(247); red.add(103); red.add(39);
        return red;
    }
    private static List<Integer> genGreenBBVA() {
        final List<Integer> green=new List<Integer>();
        green.add(69); green.add(95); green.add(204); green.add(134); green.add(190); green.add(190); green.add(137); green.add(94); green.add(175); green.add(205);
        green.add(140); green.add(100); green.add(190); green.add(55); green.add(237); green.add(108); green.add(158); green.add(133); green.add(132); green.add(105);
        green.add(42); green.add(122); green.add(137); green.add(84); green.add(122);
        return green;
    }
    private static List<Integer> genBlueBBVA() {
        final List<Integer> blue=new List<Integer>();
        blue.add(130); blue.add(180); blue.add(205); blue.add(202); blue.add(117); blue.add(255); blue.add(59); blue.add(97); blue.add(100); blue.add(82);
        blue.add(232); blue.add(100); blue.add(190); blue.add(80); blue.add(252); blue.add(1); blue.add(94); blue.add(202); blue.add(132); blue.add(185);
        blue.add(69); blue.add(229); blue.add(60); blue.add(184); blue.add(62);
        return blue;
    }

    @AuraEnabled
    /**Metodo fetchEUBPP */
    public static WRP_Chart fetchEUBPP(String IDRI) {
        final List<Integer> red = genRedBBVA();
        final List<Integer> green = genGreenBBVA();
        final List<Integer> blue = genBlueBBVA();
        final Integer numbCol = 25;
        System.debug('IDRI '+IDRI);
        EU001_RI__c  ls = new EU001_RI__c();
        try {
            ls = [SELECT OwnerId, Name, EU001_ft_Fecha_Inicio__c, EU001_ft_Fecha_Cierre__c, MX_BPP_OwnerEmplNum__c FROM EU001_RI__c WHERE Id =: IdRi LIMIT 1];
		} catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
        System.debug('ls '+ls);
        System.debug('ls.MX_BPP_OwnerEmplNum__c '+ls.MX_BPP_OwnerEmplNum__c);
        final Decimal numEmpl = Decimal.valueof(ls.MX_BPP_OwnerEmplNum__c);
        System.debug('Label.MX_BPP_EU '+Label.MX_BPP_EU);
        final ExpUni_Tablero_Grupal__c[] tabl = [Select EU_001_tx_Indicador__c, EU_Puntos__c, EU_001_tx_AtributoII__c, MX_BPP_TableroID__c, EU_Indicador__c, MX_BPP_Valor5__c from ExpUni_Tablero_Grupal__c where EU_Indicador__c = :Label.MX_BPP_EU and MX_BPP_Valor5__c=:numEmpl];
        System.debug('tabl '+tabl);
        final Map<String, Decimal> valu = new Map<String, Decimal>();
        final List<String> color = new List<String>();
        final String[] nmEvalEU = new List<String>();
        Integer idx = 0;
        final String ty = 'Porcentaje';
        for(ExpUni_Tablero_Grupal__c val:tabl) {
            final Decimal lim = obtainLim(val.EU_001_tx_Indicador__c);
            final String c = 'rgb('+red[Math.mod(idx,numbCol)]+', '+green[Math.mod(idx,numbCol)]+', '+blue[Math.mod(idx,numbCol)]+')';
            color.add(c);
            nmEvalEU.add(val.EU_001_tx_Indicador__c);
            valu.put(val.EU_001_tx_Indicador__c+ty,((val.EU_Puntos__c/lim)*100).setscale(2));
            idx++;
        }
        final List<String> tyAc = new List<String>{ty};
        final WRP_Chart res = new WRP_Chart(nmEvalEU,tyAc,valu,color);
        return res;
    }
    /** Metodo obtainLim */
    public static Decimal obtainLim(String Indicador) {
        final List<String> ptsEvalEU = new list<String> { Label.MX_BPP_Limite_Pts_Siste, Label.MX_BPP_Limite_Pts_ACC_EECC, Label.MX_BPP_Limite_Pts_Acc_IGBPyP, Label.MX_BPP_Limite_Pts_IRENE_2_0, Label.MX_BPP_Limite_Pts_EFICI_CORREOS, Label.MX_BPP_Limite_Pts_FORM};
        Decimal lim;
        if(Indicador.equalsignorecase('SISTEMÁTICA')||Indicador.equalsignorecase('SISTEMATICA')) {
            lim = Decimal.valueOf(ptsEvalEU[0]);
        } else if(Indicador.equalsignorecase('EECC')) {
            lim = Decimal.valueOf(ptsEvalEU[1]);
        } else if(Indicador.equalsignorecase('IGBPyP')) {
            lim = Decimal.valueOf(ptsEvalEU[2]);
        } else if(Indicador.equalsignorecase('IRENE 2.0')) {
            lim = Decimal.valueOf(ptsEvalEU[3]);
        } else if(Indicador.equalsignorecase('EFICIENCIA DE CORREOS')) {
            lim = Decimal.valueOf(ptsEvalEU[4]);
        } else if(Indicador.equalsignorecase('FORMACIÓN')||Indicador.equalsignorecase('FORMACION')) {
            lim = Decimal.valueOf(ptsEvalEU[5]);
        }
        return lim;
    }

    @AuraEnabled
    /**Método fethPuntosBPP */
    public static WRP_Chart fetchPuntosBPP(String IDRI) {
        final List<Integer> red = genRedBBVA();
        final List<Integer> green = genGreenBBVA();
        final List<Integer> blue = genBlueBBVA();
        final Integer numbCol = 25;
        ExpUni_Tablero_Grupal__c[] tabl;

        System.debug('IDRI '+IDRI);
        try {
            final EU001_RI__c  ls = [SELECT OwnerId, Name, EU001_ft_Fecha_Inicio__c, EU001_ft_Fecha_Cierre__c, MX_BPP_OwnerEmplNum__c FROM EU001_RI__c WHERE Id =: IdRi LIMIT 1];
            System.debug('ls '+ls);
            System.debug('ls.MX_BPP_OwnerEmplNum__c '+ls.MX_BPP_OwnerEmplNum__c);
            System.debug('Label.MX_BPP_TABLERO '+Label.MX_BPP_TABLERO);
            tabl=[Select Id, OwnerId, EU_001_tx_Atributo__c, EU_001_tx_Indicador__c, EU_Fe_Act__c, EU_Indicador__c, EU_Real__c, MX_BPP_Valor3__c, MX_BPP_Valor4__c, EU_Logro_Proy_Comp__c, MX_BPP_Valor5__c, MX_BPP_Codigo_Tablero__c, MX_BPP_TableroID__c, MX_BPP_FechaIndicador__c, MX_BPP_FechaCierre__c from ExpUni_Tablero_Grupal__c where EU_Indicador__c = :Label.MX_BPP_TABLERO and MX_BPP_Codigo_Tablero__c = :ls.MX_BPP_OwnerEmplNum__c];
            System.debug('tabl '+tabl);
		} catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
        List<String> div = new List<String>();
        final List<String> tempTyAc = new List<String>();
        final Map<String, Decimal> num = new Map<String, Decimal>();
        final List<String> color = new List<String>();
        //Creation of objects to sent and added to the lists
        Integer idx = 0;
        for(ExpUni_Tablero_Grupal__c elem: tabl) {
            final String c = 'rgb('+red[Math.mod(idx,numbCol)]+', '+green[Math.mod(idx,numbCol)]+', '+blue[Math.mod(idx,numbCol)]+')';
            final String l = elem.EU_001_tx_Indicador__c; final String nm='Logro'; final Decimal pp=elem.MX_BPP_Valor4__c;
            System.debug('l '+l); System.debug('nm '+nm); System.debug('pp '+pp.setscale(2));
            idx++;
            div.add(l);
            tempTyAc.add(nm);
            num.put(l+nm,pp.setscale(2));
            color.add(c);
        }
        final List<String> tyAc = dedupllist(tempTyAc);
        final List<String> tempDiv = dedupllist(div);
        div = new List<String>();
        for(Integer i = tempDiv.size() - 1; i >= 0; i--) {
            div.add(tempDiv[i]);
        }
        color.add('rgb');
        System.debug('tempDiv '+tempDiv); System.debug('tyAc '+tyAc);
        final WRP_Chart res = new WRP_Chart(div,tyAc,num,color);
        return res;
    }
    /** */
    public static List<String> dedupllist(List<String> duplList) {
        final Set<String> setdedupl = new Set<String>();
        final List<String> res = new List<String>();
        for(String uni: duplList) { if(setdedupl.add(uni)) {
            res.add(uni);
            } }
        return res;
    }

    /**Wrapper class for chart.js with labels, data and color */
    public class WRP_Chart {
        /** */
        @AuraEnabled public list<String> lsLabels {get; set;}
        /** */
        @AuraEnabled public list<String> lsTyAcc {get; set;}
        /** */
        @AuraEnabled public list<String> lscolor {get; set;}
        /** */
        @AuraEnabled public Map<String, Decimal> lsData {get; set;}
        /** */
        public WRP_Chart(list<String> label,list<String> tyAcc,Map<String, Decimal> data,list<String> color) {
            lsLabels = label;
            lsTyAcc = tyAcc;
            lsData = data;
            lscolor = color;
        }

    }

/*
    Versiones       Fecha           Autor                   Descripción
    1.0             04-06-2018      Monserrat Gonzalez      Clase para Mostrar Indicadores
*/
   @AuraEnabled
    public static String getFieldLabel( String objectName, String fieldName ) {
        String label = '';
        try {
            label = Schema.getGlobalDescribe().get( objectName ).getDescribe().fields.getMap().get( fieldName ).getDescribe().getLabel();
    	} catch(Exception e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
        return label;
    }
    @AuraEnabled
    /** */
    public static List<PicklistOption> getPicklistOptions( String objectName, String fieldName, String fieldEmpleado ) {
       final List<PicklistOption> options = new List<PicklistOption>();
        List<ExpUni_Tablero_Grupal__c> sIndicadores = new List<ExpUni_Tablero_Grupal__c>();
        try {
            sIndicadores = [Select EU_001_tx_Indicador__c from ExpUni_Tablero_Grupal__c
                                                      where MX_BPP_Codigo_Tablero__c=:fieldEmpleado
                                                      and EU_Indicador__c =:Label.MX_BPP_Tablero];
		} catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
        for(ExpUni_Tablero_Grupal__c sIndicador: sIndicadores) {
            final PicklistOption opt = new PicklistOption( sIndicador.EU_001_tx_Indicador__c, sIndicador.EU_001_tx_Indicador__c );
            options.add( opt );

        }
        System.debug( 'options=' + options );
        return options;
    }
    /** Clase PicklistOption */
    public class PicklistOption {
        @AuraEnabled
        /** label*/
        public String label { get; set; }
        @AuraEnabled
        /**value */
        public String value { get; set; }
        /**picklistOption */
        public PicklistOption( String label, String value ) {
            this.label = label;
            this.value = value;
        }

    }
/*
    Versiones       Fecha           Autor                   Descripción
    1.0             04-06-2018      Monserrat Gonzalez      Clase para Recuadro de Indicadores provenientes de la parametria de tablero
*/

    @AuraEnabled
    public static List<ExpUni_Tablero_Grupal__c> getDataTablero(String indicador, String fieldEmpleado) {
        List<ExpUni_Tablero_Grupal__c> sqlTablero = new List<ExpUni_Tablero_Grupal__c>();
        try {
            sqlTablero = [Select EU_001_tx_Indicador__c,EU_Real__c,MX_BPP_Valor3__c,MX_BPP_Valor4__c,MX_BPP_Valor5__c,EU_Logro_Proy_Comp__c,
                                                     EU_Fe_Act__c,MX_BPP_FechaIndicador__c,MX_BPP_FechaCierre__c
                                                     from ExpUni_Tablero_Grupal__c
                                                     where MX_BPP_Codigo_Tablero__c=:fieldEmpleado
                                                     and EU_Indicador__c =:Label.MX_BPP_Tablero];
		} catch(QueryException e) {
            throw new AuraHandledException(System.Label.MX_BPP_PyME_Error_Generico + ' ' + e);
        }
        System.debug(sqlTablero);
        return sqlTablero;
    }

}