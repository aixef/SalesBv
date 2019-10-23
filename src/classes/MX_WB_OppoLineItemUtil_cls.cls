/**-------------------------------------------------------------------------
 * Nombre: MX_WB_OppoLineItemUtil_cls
 * Autor Ing. Daniel Goncalves
 * Proyecto: MW WB TM - BBVA Bancomer
 * Descripción : Clase utilitaria de OpportunityLineItem
 * --------------------------------------------------------------------------
 * Versión      Fecha           Autor                   Descripción
 * --------------------------------------------------------------------------
 * 1.0          11/02/2019      Ing. Daniel Goncalves   Creación
 * 1.1          15/02/2019      Ing. Daniel Goncalves   Se corrigen comentarios
 * 1.1.1       17/07/2019    Eduardo Hernández Cuamatzi   Cambio de tipo de dato para telefonos de cliente y asegurado
 * --------------------------------------------------------------------------
 */
public with sharing class MX_WB_OppoLineItemUtil_cls {

    /**
     * crearPricebookEntry
     * @description crea un objeto del tipo PricebookEntry
     * @param productoId ID del Producto a asociar
     * @param unitPrice Precio a asignar
     * @return Objeto de tipo PricebookEntry
     */
    public static PricebookEntry crearPricebookEntry ( String productoId, Decimal unitPrice ) {
        String strPriceBookId;
        PricebookEntry objPriceBookEntry;
        final List < Pricebook2 > lstPriBoo = [ SELECT ID FROM Pricebook2 WHERE isStandard = true LIMIT 1 ];
        if ( !lstPriBoo.isEmpty() ) {
            strPriceBookId = lstPriBoo[0].ID;
        }
        final List < PricebookEntry > lstPriBooEnt = [ SELECT ID, Pricebook2Id, UnitPrice, UseStandardPrice, IsActive,
                                                      Product2Id FROM PricebookEntry WHERE Pricebook2Id =: strPriceBookId
                                                      AND Product2Id =: productoId ];
        if ( lstPriBooEnt.isEmpty() ) {
            objPriceBookEntry = new PriceBookEntry();
            objPriceBookEntry.Pricebook2Id = strPriceBookId;
            objPriceBookEntry.Product2Id = productoId;
        } else {
			objPriceBookEntry = lstPriBooEnt[0];
        }
        system.debug(objPriceBookEntry.unitPrice+'----=asdfghjkl345678');
        objPriceBookEntry.UnitPrice = unitPrice;
        objPriceBookEntry.UseStandardPrice = false;
        objPriceBookEntry.IsActive = true;
        return objPriceBookEntry;
    }

    /**
     * crearOpportunityLineItem
     * @description crea un objeto del tipo OpportunityLineItem
     * @param productoId ID del Producto a asociar
     * @param pricebookId ID del Pricebook a asociar
     * @param unitPrice Precio a asignar
     * @return Objeto de tipo PricebookEntry
     */
    public static OpportunityLineItem crearOpportunityLineItem ( Opportunity objOpp, PricebookEntry objPriEntry ) {
        final OpportunityLineItem objOpLi = new OpportunityLineItem ();
        String strNombreAseg = '';
        if ( String.isNotBlank ( objOpp.Name ) ) {
            strNombreAseg = objOpp.Name;
            strNombreAseg = strNombreAseg.replace('0','');
            strNombreAseg = strNombreAseg.replace('1','');
            strNombreAseg = strNombreAseg.replace('2','');
            strNombreAseg = strNombreAseg.replace('3','');
            strNombreAseg = strNombreAseg.replace('4','');
            strNombreAseg = strNombreAseg.replace('5','');
            strNombreAseg = strNombreAseg.replace('6','');
            strNombreAseg = strNombreAseg.replace('7','');
            strNombreAseg = strNombreAseg.replace('8','');
            strNombreAseg = strNombreAseg.replace('9','');
        }
        objOpLi.MX_WB_nombreAsegurado__c = ( String.isBlank( strNombreAseg ) ? '' : strNombreAseg );
        objOpLi.MX_WB_emailAsegurado__c = ( String.isBlank( objOpp.CorreodelCliente__c ) ? '' : objOpp.CorreodelCliente__c );
        objOpLi.OpportunityId = objOpp.Id;
        objOpLi.Description = ( String.isBlank( objOpp.Description ) ? '' : objOpp.Description );
        objOpLi.Product2Id = objOpp.MX_WB_Producto__c;
        objOpLi.MX_WB_Sexo__c = ( String.isBlank( objOpp.Sexo_conductor__c ) ? '' : objOpp.Sexo_conductor__c );
        if ( String.isNotBlank( objOpp.TelefonoCliente__c ) ) {
            String strOppTelf = objOpp.TelefonoCliente__c;
            strOppTelf = strOppTelf.replace('(','');
            strOppTelf = strOppTelf.replace(')','');
            strOppTelf = strOppTelf.replace('-','');
            strOppTelf = strOppTelf.replace(' ','');
            objOpLi.MX_WB_telefonoAsegurado__c = strOppTelf;
        }
        objOpLi.Quantity = 1;
        objOpLi.TotalPrice = 0;
        objOpLi.PricebookEntryId = objPriEntry.Id;
        return objOpLi;
    }
}
