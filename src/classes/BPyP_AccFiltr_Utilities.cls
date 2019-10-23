/*
    Versiones       Fecha           Autor               Descripción
    1.0           03/07/2019      Hugo Carrillo      Created from the clipped code from the BPyP_AccFiltr class. It supports BPyP__AccFiltr.
    1.1           16/08/2019      Cindy Hernández    Se agregan referencias a los tipos de registro
													 MX_BPP_PersonAcc_Client y MX_BPP_PersonAcc_NoClient.
*/
public with sharing class BPyP_AccFiltr_Utilities {

    private BPyP_AccFiltr_Utilities() {}
    /** metodo genRedBBVA*/
    public static List<Integer> genRedBBVA() {
        return MX_BPP_CompUtils_cls.genRedBBVA();
    }
    /**metodo genGreenBBVA */
    public static List<Integer> genGreenBBVA() {
    	return MX_BPP_CompUtils_cls.genGreenBBVA();
    }
    /**metodo genBlueBBVA */
    public static List<Integer> genBlueBBVA() {
    	return MX_BPP_CompUtils_cls.genBlueBBVA();
    }
    /** */
    public static List<String> dedupllist(List<String> duplList) {
        /** setdedupl*/
        Set<String> setdedupl=new Set<String>();
        /**res */
        List<String> res=new List<String>();
        /** duplist*/
        for(String uni: duplList) {
            if(setdedupl.add(uni)) {
                res.add(uni); }
        }
        return res;
    }

    /**
    * --------------------------------------------------------------------------------------
    * @Author       Hugo Ivan Carrillo Béjar hugoivan.carrillo.contractor@bbva.com
    * Date          03-07-2019
    * @Description  Obtain the stacked chart.
    * @Comments     Created from the clipped code block of method fetchBkMData.
    * @param        List <AggregateResult> OffBpyp.
    * @return       OffBpyp
    * @example      public static List <AggregateResult> fetchBkMDataBkmEmpty(List <AggregateResult> OffBpyP) {
    **/
    public static List <AggregateResult> fetchBkMDataBkmEmpty(String divi,String office,String bkm,String type) {
        List <AggregateResult> OffBpyP = new List <AggregateResult>();
        //Clientes y prospectos
        if(type=='CP') {
            OffBpyP=[Select  Owner.Name, RecordType.Name rname, count(Id) RecordCount from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.BPyP_ls_NombreSucursal__c=:office and Owner.Divisi_n__c=:divi and Owner.IsActive=True and RecordType.DeveloperName in ('BPyP_tre_Cliente','BPyP_tre_noCliente','MX_BPP_PersonAcc_Client','MX_BPP_PersonAcc_NoClient') and Owner.Name=:bkm group by  Owner.Name, RecordType.Name];
        //Clientes
        } else if (type=='C') {
            OffBpyP=[Select  Owner.Name, RecordType.Name rname, count(Id) RecordCount from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.BPyP_ls_NombreSucursal__c=:office and Owner.Divisi_n__c=:divi and Owner.IsActive=True and (RecordType.DeveloperName='BPyP_tre_Cliente' OR RecordType.DeveloperName='MX_BPP_PersonAcc_Client') and Owner.Name=:bkm group by  Owner.Name, RecordType.Name];
        //Prospectos
        } else if (type=='P') {
            OffBpyP=[Select  Owner.Name, RecordType.Name rname, count(Id) RecordCount from Account where Owner.VP_ls_Banca__c = 'Red BPyP' and (NOT (Owner.BPyP_ls_NombreSucursal__c='')) and (NOT (Owner.Divisi_n__c='')) and Owner.BPyP_ls_NombreSucursal__c=:office and Owner.Divisi_n__c=:divi and Owner.IsActive=True and (RecordType.DeveloperName='BPyP_tre_noCliente' OR RecordType.DeveloperName='MX_BPP_PersonAcc_NoClient') and Owner.Name=:bkm group by  Owner.Name, RecordType.Name];
        }
        return OffBpyP;
    }
}