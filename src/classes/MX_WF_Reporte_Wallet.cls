/**
* ------------------------------------------------------------------------------
* @Nombre: MX_WF_Reporte_Wallet
* @Autor: Sandra Ventura García
* @Proyecto: Workflow Campañas
* @Descripción : Clase para envío de reportes de afilicaciones y promociones.
* ------------------------------------------------------------------------------
* @Versión       Fecha           Autor                         Descripción
* ------------------------------------------------------------------------------
* 1.0           18/09/2019     Sandra Ventura García	         test
* ------------------------------------------------------------------------------
*/
public with sharing class MX_WF_Reporte_Wallet implements Schedulable {
  /**
  * @description: Apex scheduler.
  * @author Sandra Ventura
  */ 
    public void execute(SchedulableContext ctx) {
        envioEmail();
    }
  /**
  * @description: Reporte Afiliaciones.
  * @author Sandra Ventura
  */ 
    public static Blob rptAfiliacion() {
        
       final List<MX_WF_Afiliaciones__c> registros = [SELECT MX_WF_Wallet__r.Name, Name
                                                      FROM MX_WF_Afiliaciones__c
                                                      WHERE MX_WF_Wallet__r.MX_WF_Fecha_fin__c >= today AND MX_WF_Wallet__r.MX_WF_Estado__c= 'Aprobado'];       

        final String[] csvData = New String[] {'Wallet:Folio de registro,',
                                               'Afiliaciones:Numero de afiliacion\n'};
        
            for(MX_WF_Afiliaciones__c w: registros) {  
               
                csvData.add('"' + w.MX_WF_Wallet__r.Name + '"' + ',');
                csvData.add('"' + w.Name + '"' + '\n');  
                
           }
   
        final String csvStr = String.join(csvData, '');        
         return Blob.valueOf(csvStr);
            
    }
    
  /**
  * @description: Reporte promociones.
  * @author Sandra Ventura
  */ 
    public static Blob rptPromocion() {
        
       final List<MX_WF_Wallet__c> registros = [SELECT Name,
                                           Nombre_del_comercio_f__c,
                                           MX_WF_Url_Comercio__c,
                                           MX_WF_Resenia_de_comercio__c,
                                           MX_WF_Codigo_de_tipo_de_descuento__c,
                                           MX_WF_Tipo_de_promoci_n_nombre__c,
                                           MX_WF_Nombre_de_promocion__c,
                                           MX_WF_Promocion_Corta__c,
                                           MX_WF_Promocion_extendida__c,
                                           MX_WF_Restricciones__c,
                                           MX_WF_Tipo_de_uso__c,
                                           MX_WF_Url_promocion__c,
                                           MX_WF_Codigo_Categorias__c,
                                           MX_WF_Imagen__c,
                                           MX_WF_Fecha_inicio_promoci_n__c,
                                           Fecha_fin_de_promoci_n__c,
                                           MX_WF_Fecha_de_publicacion__c,
                                           MX_WF_Grupo_de_tarjetas__c,
                                           MX_WF_Keywords_de_busqueda__c
                                           FROM MX_WF_Wallet__c 
                                           WHERE MX_WF_Fecha_fin__c >= today AND MX_WF_Estado__c = 'Aprobado'
                                           ];       
                                                                                     
      
        final String[] csvData = New String[] {'Folio del registro,',
                                        'Comercio:Nombre,',
                                        'Url Comercio,',
                                        'Resena de comercio,',
                                        'Codigo de tipo de descuento,',
                                        'Tipo de promocion:Nombre,',
                                        'Nombre de promocion,',
                                        'Promocion corta,',
                                        'Promocion extendida,',
                                        'Restricciones,',
                                        'Tipo de uso,',
                                        'Url promoción,',
                                        'Codigo de categorias,',
                                        'Imagen,',
                                        'Fecha inicio promocion,',
                                        'Fecha fin promocion,',
                                        'Fecha de publicacion,',
                                        'Grupo de tarjetas,',
                                        'Keywords de busqueda\n'};
        
            for(MX_WF_Wallet__c w: registros) {  
                              
                csvData.add('"' + w.Name + '"' + ',');
                csvData.add('"' + w.Nombre_del_comercio_f__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Url_Comercio__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Resenia_de_comercio__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Codigo_de_tipo_de_descuento__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Tipo_de_promoci_n_nombre__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Nombre_de_promocion__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Promocion_Corta__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Promocion_extendida__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Restricciones__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Tipo_de_uso__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Url_promocion__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Codigo_Categorias__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Imagen__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Fecha_inicio_promoci_n__c + '"' + ',');
                csvData.add('"' + w.Fecha_fin_de_promoci_n__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Fecha_de_publicacion__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Grupo_de_tarjetas__c + '"' + ',');
                csvData.add('"' + w.MX_WF_Keywords_de_busqueda__c + '"' + '\n');  
                    
              }
      
       final String csvStr = String.join(csvData, '');      
       return Blob.valueOf(csvStr);
    }
    
  /**
  * @description: Envio email.
  * @author Sandra Ventura
  */ 
    public static void envioEmail () {
        
        final Blob csv_afiliaciones = MX_WF_Reporte_Wallet.RptAfiliacion();
        final Blob csv_promociones = MX_WF_Reporte_Wallet.RptPromocion();
        
        final String hoyStr = String.valueOf(Date.today());	
        final String fecha = hoyStr.replace('-', ''); 
        
        final String[] emails = new String[] { 'isis.chavez@bbva.com','roman.rodriguez.contractor@bbva.com','vianey.rodriguez.torres.contractor@bbva.com'};
        
        final Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        final Messaging.EmailFileAttachment adjAfiliaciones = new Messaging.EmailFileAttachment();
        final Messaging.EmailFileAttachment adjPromociones = new Messaging.EmailFileAttachment();        
 
        adjAfiliaciones.setFileName('MMPEZ_D02_' + fecha + '_PromoId.csv');
        adjAfiliaciones.setBody(csv_promociones);
        adjAfiliaciones.setContentType('text/csv');
        
        adjPromociones.setFileName('MMPEZ_D02_' + fecha + '_RelaIdAfi.csv');
        adjPromociones.setBody(csv_afiliaciones);
        adjPromociones.setContentType('text/csv');
        
        email.setReplyTo('noreply@noreply.com');
        email.setSenderDisplayName('Salesforce');
        

        email.setSubject('Salesforce: Reportes de Afiliaciones y promociones');
        email.setToAddresses(emails);
        email.setPlainTextBody('Los documentos CSV adjuntos contienen los reportes de afiliaciones y promociones');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] { adjAfiliaciones, adjPromociones });
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        
    }
    
}