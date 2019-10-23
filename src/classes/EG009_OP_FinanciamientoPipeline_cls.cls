/**
*----------------------------------Desarrollado por INDRA---------------------------------
*Autor:         Ing. Pedro Alan Hernandez Sierra
*Proyecto:      Pipeline Financiamiento PI7 BEyG
*Descripción:   Service del Handler Oportunidad_Handler_cls.
*_______________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        06/NOV/2017     Ing. Pedro Alan Hernandez Sierra    Creación.
*1.1        16/NOV/2017     Ing. Pedro Alan Hernandez Sierra    Se agrega método SumaOportunidadesAMadre.
*1.2        23/NOV/2017     Luis Ruben Quinto Muñoz             Se acambia validación en función UpdateStageOpportunity.
*1.3        30/ENE/2018     Ing. Pedro Alan Hernandez Sierra    Se instancian variables faltantes.
*                                                               Se agrega a la condición de entrada que entre también con un cambio
                                                                    de etapa en el método: SumaOportunidadesAMadre
*                                                               Se agregan los Métodos: AsingaTipoTechoDesdeProduct2 y ActualizaOLI
*1.4        06/ENE/2018     Luis Ruben Quinto Muñoz             Se quita método updateStageMonto
*1.5        15/FEB/2018     Luis Ruben Quinto Muñoz             Se modifican fechas para corregir incidencia productiva
*1.6        19/FEB/2018     Luis Ruben Quinto Muñoz             Se Agregan validaciones para las cargas de pipeline a travez de un id externo
*1.7        26/FEB/2018     Luis Ruben Quinto Muñoz             Se Separa método de carga de oportunidades madre
*1.8        28/FEB/2018     Luis Ruben Quinto Muñoz             Se ponen validaciones en método UpdateCamposClaveHija
*1.9        06/MAR/2018     Luis Ruben Quinto Muñoz             Se modifica método UpdateStageOpportunity para cerrar ganar Oportunidad de
*                                                                   financiamiento
*1.10       07/MAR/2018     Ing. Pedro Alan Hernandez Sierra    Se cambia la consulta de las oportunidades de las sumas para que no tome las
*                                                                   descartadas.
*1.11       21/MAR/2018     Luis Ruben Quinto Muñoz             Se modifica método UpdateStageOpportunity para actualizar el campo
*                                                                   EG009_fh_VencimientoPF__c durante la carga de Control de limites
*1.12       03/MAY/2018     Ing. Pedro Alan Hernandez Sierra    Se hace without sharing la clase
*2.0        05/JUN/2018     Ricardo Hernandez Reyes             Se Agrega la Condición de CurrencyIsoCode
*2.1        27/08/2018      Monserrat Gonzalez                  Se modifico método updateRecordTypeOportunity para cambiar el tipo de
*                                                                   registro de carta de crédito Cross Selling
*2.2        06/08/2018      Monserrar Gonzalez                  Se agrego funcionalidad en método AsignaProductoSeleccionadoCampoTipoProd
*                                                                   para actualizar el producto  de Cross Selling
*3.0        18/10/2018      Antony de la rosa                   Se agregó IF cuando se crean oportunidades de arrendamiento homologación a Pipeline
*3.1        19/10/2018      Cristian Espinosa                   Se agrega una validación para las oportunidades banca a la hora de asignar productos.
*3.2        08/11/2018      Antony de la rosa guzman            Se agrega tipos de registros arrendamiento homologación de productos Pipeline.
*3.3        09/07/2019      Jair Ignacio Gonzalez Gayosso       Se depuro clase con los metodos confirmados en la migracion de bpyp y pymes
*-----------------------------------------------------------------------------------------
*/
public without sharing class EG009_OP_FinanciamientoPipeline_cls {

    @TestVisible
    private EG009_OP_FinanciamientoPipeline_cls() {
  	}

    /**
    *Ejecución: Before insert
    *Descripción: Actualiza el tipo de registro de las oportunidades hijas
    */
    public static void updateRecordTypeOportunity(List<Opportunity> triggerNew, Map<Id, RecordType> mapRecordTypesOpp) {
        //El Map<Id, RecordType> lo convertimos en Map<String, RecordType> para tener en el indice el DeveloperName
        //Map<String, RecordType> mapRecordTyps = new Map<String, RecordType>(EG009_Utility_cls.orderRecordTypesByMap(mapRecordTypesOpp));
        for(Opportunity oppTN : triggerNew) {
            if(oppTN.op_amountPivote_dv__c != null && oppTN.op_amountPivote_dv__c > 0) {
                oppTN.EG009_dv_MontoAutrizado__c = oppTN.op_amountPivote_dv__c;
            }
        }
    }
}