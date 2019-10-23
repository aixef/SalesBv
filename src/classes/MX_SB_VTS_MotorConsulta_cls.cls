/**
*
* @author Arsenio Perez Lopez 
* @description API to auto assign leads from Smart Center to call center agents
*
*           No  |     Date     |     Author      |    Description
* @version  1.0    24/06/2019     Arsenio Perez      Create API for Smart Center
*
*/
public without sharing class MX_SB_VTS_MotorConsulta_cls {//NOSONAR
	/*Variables globales.*/
    static List<MX_WB_MotivosNoContacto__c> mcs = MX_WB_MotivosNoContacto__c.getAll().values();
    /**
* Method: ConsltaMotor
* @param iDaccion: Accion a devolver     
* @param level1: Nivel de consulta 1 
* @param level2: Nivel de consulta 2
* @param level3: Nivel de consulta 3
* @param level4: Nivel de consulta 4
* @param level5: Nivel de consulta 5
* @param level6: Nivel de consulta 6
* @param level7: Nivel de consulta 7
* @param level8: Nivel de consulta 8
* @param level9: Nivel de consulta 9
* @param level10: Nivel de consulta 10
*/ 
    public static String ConsltaMotor(String IDObjeto) {
        String retur='0';
        final Map<String, String> mapaniveles = new Map<String, String>();
        SObject otemp;
        Integer iDaccion=0;
        try {
            if(IDObjeto.startsWith('00Q')) {
                otemp = [Select id, MX_WB_ContadorRemarcado__c, MX_WB_lst_EstatusPrimerContacto__c, Estatusdecotizacion__c, SAN151_ContactoEfectivo__c FROM Lead WHERE id=:IDObjeto];
                mapaniveles.put('1',validanull((String)otemp.get('MX_WB_lst_EstatusPrimerContacto__c')));
                mapaniveles.put('2',validanull((String)otemp.get('Estatusdecotizacion__c')));
                mapaniveles.put('3',validanull((String)otemp.get('SAN151_ContactoEfectivo__c')));
                mapaniveles.put('4','');
                mapaniveles.put('5','');
                mapaniveles.put('6','');
                mapaniveles.put('7','');
                mapaniveles.put('8','');
                mapaniveles.put('9','');
                mapaniveles.put('10','');
            } else {
                otemp = [Select id, MX_WB_ContadorRemarcado__c, MX_WB_lst_EstatusPrimerContacto__c, MX_WB_estatusCotizacion__c,SAN152_ContactoEfectivo__c, 
                         Motivosnoventa__c, MX_SB_VTS_DetalleNoventa__c, MX_SB_VTS_Motivo_de_no_cargo__c FROM Opportunity WHERE id=:IDObjeto];
                mapaniveles.put('1',validanull((String)otemp.get('MX_WB_lst_EstatusPrimerContacto__c')));
                mapaniveles.put('2',validanull((String)otemp.get('MX_WB_estatusCotizacion__c')));
                mapaniveles.put('3',validanull((String)otemp.get('SAN152_ContactoEfectivo__c')));
                mapaniveles.put('4',validanull((String)otemp.get('Motivosnoventa__c')));
                mapaniveles.put('5',validanull((String)otemp.get('MX_SB_VTS_DetalleNoventa__c')));
                mapaniveles.put('6',validanull((String)otemp.get('MX_SB_VTS_Motivo_de_no_cargo__c')));
                mapaniveles.put('7','');
                mapaniveles.put('8','');
                mapaniveles.put('9','');
                mapaniveles.put('10','');
            }
            iDaccion=retIDaccion(Integer.valueOf(otemp.get('MX_WB_ContadorRemarcado__c')));
            retur= Validfor(mapaniveles,iDaccion);
        } catch (DmlException e) {
            retur = System.Label.MX_WB_LG_ErrorBack;
            throw new DmlException(System.Label.MX_WB_LG_ErrorBack + e);
        }
        return retur;
    }
    private static Integer retIDaccion(Integer iDaccion) {
        Integer idret = 0;
        if(iDaccion>4 && iDaccion <6) {
            idret = 3;
        } else if(iDaccion > 6) {
            idret = 4;
        } else if(String.isNotEmpty(String.valueOf(iDaccion))) {
            idret=iDaccion;
        }
        return idret;
    }
    private static string Validfor(Map<String, String> niveles, Integer iDaccion) {
        String retur='0';
        system.debug('iDaccion'+iDaccion);
        for(MX_WB_MotivosNoContacto__c mxc: mcs) {
            retur=ifreturn(mxc, iDaccion, niveles);
        }
        return retur;
    }
    Private static string ifreturn (MX_WB_MotivosNoContacto__c mxc, Integer iDaccion, Map<String, String> niveles) {
        String retur='0';
        if (niveles.get('1').equals(validanull(mxc.MX_SB_VTS_Nivel_1__c)) && 
                niveles.get('2').equals(validanull(mxc.MX_SB_VTS_Nivel_2__c)) &&
                niveles.get('3').equals(validanull(mxc.MX_SB_VTS_Nivel_3__c)) &&
                niveles.get('4').equals(validanull(mxc.MX_SB_VTS_Nivel_4__c)) &&
                niveles.get('5').equals(validanull(mxc.MX_SB_VTS_Nivel_5__c)) &&
                niveles.get('6').equals(validanull(mxc.MX_SB_VTS_Nivel_6__c))) {
                   retur =  retoption(mxc,iDaccion);
                }
        return retur;
    }
    private static string retoption (MX_WB_MotivosNoContacto__c mxc, Integer iDaccion) {
        String retur='0';
        if(iDaccion==mxc.MX_SB_VTS_IDACCION__c) {
            retur = String.valueOf(mxc.MX_SB_VTS_HoraDuracion__c);
        }
        return retur;
    }
    
    private static String validanull(String val) {
        return String.isBlank(val)||String.isEmpty(val)? '': val; 
    }
}
