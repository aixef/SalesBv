/*
???
_____________________________________________________________________________________________
Versión		Fecha			Autor					Descripción
1.0			30-Enero-2019	Adrián Pastor Pineda	Se crea el método: RISelected - para cubrir la clase BPyP_OppRep
1.1			20-Junio-2019	Cindy Hernández			Se eliminan referencias a métodos de la clase BPyP_OppRep que no se utilizan.
													Se agregan los métodos oppRepConstructor y RISelectedError.
													El método createData se mueve a la clase MX_BPP_AccAndOppDataFactory.
													Se modifican los métodos test_fetchDivData y test_fetchBkMData para agregar el try catch.
                                                    Se modifican los métodos test_fetchDivData y test_fetchOffData para agregar runAs.
													Se modifica el System.assert del método test_fetchOffData.
1.2			19-Julio-2019	Cindy Hernández			Se hace referencia al método fetchOpp en el método test_fetchOpp para aumentar porcentaje de cobertura.
Comments: Test class for BPyP_OppRep y BPyP_OppRep_Utilities.
*/
@isTest
private class BPyP_OppRepTest {

    /**
     * This is a test method for fetchDivData
     */
    static testMethod void test_fetchDivData() {
    	Test.startTest();
    	MX_BPP_AccAndOppDataFactory.createData();
       	final User u = [Select Id FROM User where BPyP_ls_NombreSucursal__c = '6388 PACHUCA'];
        String errorMessage = '';
        System.runAs(u) {
            try {
            	BPyP_OppRep.fetchTyoOp();
            	BPyP_OppRep.fetchDiv();
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
            System.assertEquals('Script-thrown exception', errorMessage);
            BPyP_OppRep_Utilities.WRP_ChartStacked result_fetchDivData = BPyP_OppRep.fetchDivData('C' , '' , System.Today() , System.Today());
            result_fetchDivData = BPyP_OppRep.fetchDivData('C' , '' , System.Today()-20 , System.Today()+20);
            result_fetchDivData = BPyP_OppRep.fetchDivData('P' , '' , System.Today() , System.Today());
            result_fetchDivData = BPyP_OppRep.fetchDivData('C' , '' , null , null);
            result_fetchDivData = BPyP_OppRep.fetchDivData('P' , '' , null , null);
            result_fetchDivData = BPyP_OppRep.fetchDivData('C' , 'Abierta' , null , null);
            result_fetchDivData = BPyP_OppRep.fetchDivData('P' , 'Abierta' , null , null);
            System.assert(result_fetchDivData.lsData.size()==0);
        }
        Test.stopTest();
    }

    /**
     * This is a test method for fetchOffData
     */
    static testMethod void test_fetchOffData() {
    	MX_BPP_AccAndOppDataFactory.createData();
        final User u = [Select Id FROM User where BPyP_ls_NombreSucursal__c = '6388 PACHUCA'];
        Test.startTest();
        System.runAs(u) {
            BPyP_OppRep.fetchOff('BAJIO');
            BPyP_OppRep.fetchOff('');
            BPyP_OppRep_Utilities.WRP_ChartStacked result_fetchOffData = BPyP_OppRep.fetchOffData('BAJIO' , 'P' , '' , System.Today() , System.Today());
            result_fetchOffData = BPyP_OppRep.fetchOffData('BAJIO' , 'P' , 'Seguros' , System.Today() , System.Today());
            result_fetchOffData = BPyP_OppRep.fetchOffData('BAJIO' , 'C' , '' , System.Today() , System.Today());
            result_fetchOffData = BPyP_OppRep.fetchOffData('BAJIO' , 'P' , 'Abierta' , null , null);
            result_fetchOffData = BPyP_OppRep.fetchOffData('BAJIO' , 'C' , '' , null , null);
            System.assert(result_fetchOffData.lsData.size() > 0);
        }
        Test.stopTest();
    }

    /**
     * This is a test method for fetchBkMData
     */
    static testMethod void test_fetchBkMData() {
    	Test.startTest();
    	MX_BPP_AccAndOppDataFactory.createData();
        BPyP_OppRep_Utilities.obtStAndEndDate(system.today().month(),'');
        BPyP_OppRep.fetchBankMan('6388 PACHUCA' , 'BAJIO');
        BPyP_OppRep.fetchBankMan('' , '');
        BPyP_OppRep_Utilities.WRP_ChartStacked result_fetchBkMData = BPyP_OppRep.fetchBkMData('6388 PACHUCA' , '' , 'BAJIO' , 'P' , '' , System.Today() , System.Today());
        result_fetchBkMData = BPyP_OppRep.fetchBkMData('6388 PACHUCA' , 'BAJIO' , '' , 'C' , '' , System.Today() , System.Today());
        result_fetchBkMData = BPyP_OppRep.fetchBkMData('' , '' , '' , 'C' , 'Abierta' , NULL , NULL);
        result_fetchBkMData = BPyP_OppRep.fetchBkMData('' , '' , '' , 'P' , '' , NULL , NULL);
        System.assert(result_fetchBkMData.lsData.size()==0);
        String errorMessage = '';
        try {
            System.assert(BPyP_OppRep.fetchbaseurl()!=null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        System.assertEquals('Script-thrown exception', errorMessage);
        errorMessage = '';
        try {
        	System.assert(BPyP_OppRep.fetchusdata()!=null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        System.assertEquals('Script-thrown exception', errorMessage);
        Test.stopTest();
    }

    /**
     * This is a test method for fetchOpp
     */
    static testMethod void test_fetchOpp() {
    	Test.startTest();
    	MX_BPP_AccAndOppDataFactory.createData();
        BPyP_OppRep.fetchPgs('' , 'P' , '' , System.Today() , System.Today());
        List<Opportunity> opps = BPyP_OppRep.fetchOpp('Banquero Patrimonial 1' , 'P' , '' , System.Today() , System.Today(),0);
        System.assert(opps.isEmpty());
        opps = BPyP_OppRep.fetchOpp('Banquero Patrimonial 1' , 'P' , '' , null , null,0);
        System.assert(opps.isEmpty());
        BPyP_OppRep.fetchPgs('Banquero Patrimonial 1' , 'P' , '' , System.Today() , System.Today());
        BPyP_OppRep.fetchPgs('Banquero Patrimonial 1' , 'C' , '' , System.Today() , System.Today());
        BPyP_OppRep.fetchPgs('Banquero Patrimonial 1' , 'P' , '' , null , null);
        BPyP_OppRep.fetchPgs('Banquero Patrimonial 1' , 'C' , '' , null , null);
        BPyP_OppRep.fetchPgs('Banquero Patrimonial 1' , 'P' , 'Abierta' , System.Today() , System.Today());
        BPyP_OppRep.fetchPgs('Banquero Patrimonial 1' , 'C' , 'Abierta' , System.Today() , System.Today());
        BPyP_OppRep.fetchPgs('Banquero Patrimonial 1' , 'P' , 'Abierta' , null , null);
        BPyP_OppRep.fetchPgs('Banquero Patrimonial 1' , 'C' , 'Abierta' , null , null);
        System.assertEquals(0, BPyP_OppRep.fetchPgs('Banquero Patrimonial 1' , 'C' , 'Abierta' , null , null));
        Test.stopTest();
    }

     @isTest
     static void RISelected() {
        final User u = MX_BPP_UserAndRIDataFactory.crearUsuario('Usertest', 'BPyP Estandar', 'BPYP BANQUERO TORRE BANCOMER');
        insert u;
        test.startTest();
        System.runAs(u) {
            final EU001_RI__c ri = MX_BPP_UserAndRIDataFactory.creaRI(u.Id);
            insert ri;
            final User RIu= BPyP_OppRep.getRISelect(ri.Id);
            System.assertNotEquals('', RIu.Divisi_n__c, 'getRiSelected correcto');
        }
        test.stopTest();
    }

     @isTest
     static void RISelectedError() {
        final User u = MX_BPP_UserAndRIDataFactory.crearUsuario('Usertest', 'BPyP Estandar', 'BPYP BANQUERO TORRE BANCOMER');
        insert u;
        String errorMessage = '';
        test.startTest();
        System.runAs(u) {
            try {
            	BPyP_OppRep.getRISelect('BadId');
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
        }
        test.stopTest();
        System.assertEquals('Script-thrown exception', errorMessage);
    }

    @isTest
    static void oppRepConstructor() {
        String errorMessage = '';
        test.startTest();
        try {
	        final BPyP_OppRep oppRep = new BPyP_OppRep();
      	    final BPyP_OppRep_Utilities oppRepUtilities = new BPyP_OppRep_Utilities();
            System.assert(oppRep != null);
            System.assert(oppRepUtilities != null);
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        test.stopTest();
        System.assertEquals('', errorMessage);
    }
}