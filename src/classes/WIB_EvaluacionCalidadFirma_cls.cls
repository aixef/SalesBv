/** 
* 
*Creación de clase WIB_EvaluacionCalidadFirma_cls
*/
public with sharing class WIB_EvaluacionCalidadFirma_cls {
	/** variable sIdeval*/
	public String sIdeval {get;Set;}
	/** variable Eval*/
	public Evaluacion__c Eval {get;Set;}

  /**Un constructor por default*/
	public WIB_EvaluacionCalidadFirma_cls() {
		sIdeval = ApexPages.currentPage().getParameters().get('idEval');
    	Eval = [Select id, RepresentanteCalidad__c, Encuestado__c,  CreatedDate
      	From Evaluacion__c Where id =:sIdeval];

  	}
		/** Método */
  	public PageReference cancelEvaluacion() {
    	final PageReference pageRef = new ApexPages.StandardController(Eval).view();
    	pageRef.setRedirect(true);
    	return pageRef;
  	}


}