/********************************************************************************
*   @Desarrollado por:      Estrategia Tecnológica                              *
*   @Autor:                 Angel Fuertes Gómez                                 *
*   @Proyecto:              Bancomer                                            *
*   @Descripción:           Minuta a enviar en el Kit de Visita                 *
*                                                                               *
*   Cambios (Versiones)                                                         *
*   --------------------------------------------------------------------------  *
*   No.     Fecha               Autor                   Descripción             *
*   ------  ----------  ----------------------      --------------------------- *
*   1.0     15/05/2018  Angel Fuertes Gomez          Creación de controlador    *
*   2.0     29/05/2018  Angel Fuertes Gomez          Modificación               *
*   3.0     01/08/2018  Angel Fuertes Gomez          Se agrega funcionalidad que*
*                                                    permite mostrar errores de *
*                                                    reglas de validación en el *
*                                                    modal.                     *
*   4.0     01/08/2018  Angel Fuertes Gomez          Se cambio un campo el la   *
*                                                    consulta que obtiene la    *
*                                                    información del ejecutivo  *
*                                                    y su jefe, se agregaron    *
*                                                    los correos del jefe y     *
*                                                    del ejecutivo al correo    *
*                                                    que se envía como CCO.     *
*   5.0     01/08/2018  Angel Fuertes Gomez          Nueva casuística a la hora *
*                                                    de consultar al jefe del   *
*                                                    ejecutivo.                 *
*   5.1     01/10/2018  Angel Fuertes Gomez          Nuevo método para obtener  *
*                                                    las fechas comprensibles   *
*                                                    para los usuarios          *
*   5.2     29/01/2019  Ruben Quinto                 Se agrega el pdf de la minuta al correo *
*   5.3     25/02/2019  Ruben Quinto                 Se modifica la llamada a las imagenes para su muestra en el pdf *
*	5.4		10/04/2019	Iván Cabrer					 Se agrega campo dwp_kitv__disclosure_info_type__c al query de visita
													 Se agrega condición para que la minuta se envíe al director del sector
														del cliente y no al gestor, cuando se trate de una visita BIE.
*   6.0     08/04/2019  Lisandro Ortiz Reynosa       Se agrega el campo "Description" a la consulta de Tareas*
*   7.0     29/08/2019  Cindy Hernández              Se elimina el método       *
                                                     getDirSector y sus referen-*
                                                     cias ya que se utilizaba   *
                                                     para registros con tipos de*
                                                     registro que contuvieran   *
                                                     MX_BIE_.
*   7.1     04/09/2019  Cindy Hernández              Se realizan modificaciones *
                                                     para resolver code smells  *
                                                     detectados por sonar.      *
*********************************************************************************/
public without sharing class MX_EU_Minuta_Ctrl {
    /*String FIELDATTACHFILE*/
    static final String FIELDATTACHFILE = 'dwp_kitv__Attach_file__c';
    /*Accesor dwp_kitv__Visit__c visitObj*/
    public dwp_kitv__Visit__c visitObj {get;set;}
    /*Accesor User userObj*/
    public User userObj {get;set;}
    /*Accesor User visitResponsible*/
    public User visitResponsible {get; set;}
    /*Accesor String fechStartDate*/
    public String fechStartDate {get;set;}
    /*Accesor String fechCheckIn*/
    public String fechCheckIn {get;set;}
    /*Accesor String todayS*/
    public String todayS {get;set;}
    /*Accesor boolean correoEnviado*/
    public boolean correoEnviado {get;set;}
    /*Accesor boolean enviar*/
    public boolean enviar {get;set;}
    /*Accesor List<ContentVersion> documents*/
    transient public List<ContentVersion> documents {get;set;}
    /*Accesor boolean vfError*/
    public boolean vfError {get;set;}
    /*Accesor dwp_kitv__Template_for_type_of_visit_cs__c myCS*/
    public dwp_kitv__Template_for_type_of_visit_cs__c myCS {get;set;}
    /*Accesor String logoAzul*/
    public String logoAzul { get; set; }
    /*Accesor String logoBlanco*/
    public String logoBlanco { get; set; }
    /*Accesor String iconFacebook*/
    public String iconFacebook { get; set; }
    /*Accesor String iconTwiter*/
    public String iconTwiter { get; set; }


/*
* @Descripción Constructor de la clase
* @return No retorna nada
*/
    public MX_EU_Minuta_Ctrl() {
        //Obtiene el id de la visita
        final Id currentId = ApexPages.currentPage().getParameters().get('Id');
        final string sMyCS = getParamater('myCS');
        final string sDocuments = getParamater('documents');
        vfError = false;
        final Map<String, Document> mapDocument = new Map<String, Document>();
        final List<Document> lstDocument = Test.isRunningTest() ? [SELECT Id, DeveloperName FROM Document WHERE DeveloperName IN ('PenguinsDoc') ] : [SELECT Id, DeveloperName FROM Document WHERE DeveloperName IN ('MX_EUSV_Bancomer_Navy','MX_EUSV_BBVA_Bancomer','MX_EUSV_BBVA_fb_icon','MX_EUSV_BBVA_tw_icon') ];
        for (Document document : lstDocument) {
            mapDocument.put(document.DeveloperName, document);
        }
        final String urlString = '/servlet/servlet.ImageServer?id=';
        final String urlComplement = '&oid=';
        this.logoAzul =  Test.isRunningTest() ? '' : URL.getSalesforceBaseUrl().toExternalForm() + urlString + mapDocument.get('MX_EUSV_Bancomer_Navy').Id + urlComplement + UserInfo.getOrganizationId();
        this.iconFacebook =  Test.isRunningTest() ? '' : URL.getSalesforceBaseUrl().toExternalForm() + urlString + mapDocument.get('MX_EUSV_BBVA_fb_icon').Id + urlComplement + UserInfo.getOrganizationId();
        this.iconTwiter =  Test.isRunningTest() ? '' : URL.getSalesforceBaseUrl().toExternalForm() + urlString + mapDocument.get('MX_EUSV_BBVA_tw_icon').Id + urlComplement + UserInfo.getOrganizationId();
        this.logoBlanco =  Test.isRunningTest() ? '' : URL.getSalesforceBaseUrl().toExternalForm() + urlString + mapDocument.get('MX_EUSV_BBVA_Bancomer').Id + urlComplement + UserInfo.getOrganizationId();
        //Consulta para obtener los parametros necesarios de la visita
        this.visitObj = [select id,  name, dwp_kitv__visit_status_type__c, RecordType.name,RecordType.DeveloperName, dwp_kitv__account_id__r.id,
                         dwp_kitv__visit_start_date__c, Owner.Name,Check_In_Date_Time__c, dwp_kitv__account_id__r.Name, dwp_kitv__disclosure_info_type__c,
                         (select id, name, dwp_kitv__contact_id__r.name, dwp_kitv__contact_id__r.Account.Name from dwp_kitv__Visit_Contacts__r
                          where dwp_kitv__Main_contact__c=True),
                         (select id, Subject, Description, ActivityDate, Owner.Name, dwp_kitv__visit_done__c, Status, ActivityType, MX_EU_Responsable__c from dwp_kitv__Activities__r
                          where ActivityType='Agreement'
                          AND MX_EU_AgregarAMinuta__c = TRUE ORDER BY Status ASC,ActivityDate ASC)
                         from dwp_kitv__Visit__c where Id = :currentId];
        this.todayS = getFecha(date.today());
        this.fechStartDate = getFecha(this.visitObj.dwp_kitv__visit_start_date__c);
        this.fechCheckIn = getFecha(this.visitObj.Check_In_Date_Time__c);
        if(!String.isBlank(sDocuments.unescapeHtml4())) {
            this.documents = (List<ContentVersion>)System.JSON.deserialize(sDocuments.unescapeHtml4(), List<ContentVersion>.class);
        }
        if(!String.isBlank(sMyCS.unescapeHtml4())) {
            this.enviar = true;
            this.myCS =(dwp_kitv__Template_for_type_of_visit_cs__c)System.JSON.deserialize(sMyCS.unescapeHtml4(), dwp_kitv__Template_for_type_of_visit_cs__c.class);
        }
        //Consulta para obtener los parametros del propietario de la visita y de su jefe
        this.userObj = [select id, CompanyName, Name, Title, Email, MobilePhone, Manager.Name,Manager.Title,
                        Manager.Email, Manager.MobilePhone,Manager.CompanyName
                        from User where Id =:this.visitObj.OwnerId];

        //Consulta al director del sector BIE
        this.visitResponsible = this.userObj.Manager;
    }

/**
* @Description método que regresa la fecha completa.
* @return Regresa una cadena que contiene una fecha.
**/
    public string getFecha(datetime fechIn) {
        String fechFinal = '';
        if(fechIn != null) {
            final string[] fechRes = string.valueofGmt(fechIn).split(' ')[0].split('-');
            fechFinal = fechRes[2] + ' de ' + getMes(fechRes[1]) + ' del ' + fechRes[0];
        }
        return fechFinal;
    }

/**
* @Description método que regresa el mes.
* @return Regresa una cadena que contiene el mes.
**/
    public string getMes(String mesIn) {
        String mesF = '';
        final Map<String, String> monthValues = new Map<String, String>();
        monthValues.put('01', 'Enero');
        monthValues.put('02', 'Febrero');
        monthValues.put('03', 'Marzo');
        monthValues.put('04', 'Abril');
        monthValues.put('05', 'Mayo');
        monthValues.put('06', 'Junio');
        monthValues.put('07', 'Julio');
        monthValues.put('08', 'Agosto');
        monthValues.put('09', 'Septiembre');
        monthValues.put('10', 'Octubre');
        monthValues.put('11', 'Noviembre');
        monthValues.put('12', 'Diciembre');
        if(monthValues.containskey(mesIn)) {
            mesF = monthValues.get(mesIn);
        }
        return mesF;
    }

/**
* @Description Metodo que ejecuta el enviado del email.
* @return No regresa nada.
**/
    public void sendMail() {
        //La custom setting sirve de bandera para saber si se mandara el correo
        if(enviar == true) {
            final String statusOldVisit = visitObj.dwp_kitv__visit_status_type__c;
            sendTemplateEmail(visitObj, myCS, documents, statusOldVisit);
        }
    }

/**
* @Description Method that generates the elements that are sent in the mail as well as
* send the mail to the recipients
* @param visitObj Object with the general details of the visit
* @param myCS Custom Settings that will give the configuration for the shipment
* @return MinutePagerWrapper A class with the necessary elements to work on the view
**/
    public void sendTemplateEmail(dwp_kitv__Visit__c visitObj, dwp_kitv__Template_for_type_of_visit_cs__c myCS,List<ContentVersion> documents, String statusOldVisit) {
        //keep the status of the visit
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'La minuta se esta enviando...'));
        String templateConverted = 'BODY NULL';
        Blob docBlob;
        try {
            //First update the status of the visit, the contacts that will be sent and
            //team members
            dwp_kitv.Minute_Generator_Ctrl.updateStatusVisit(visitObj,'05');
            //Get the visit object with the updates
            final dwp_kitv__Visit__c visitObjNew=dwp_kitv.Minute_Generator_Ctrl.getVisitObj(visitObj.Id);

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            //Valid which type of template is assigned to the type of record

            //You have to pass the ID of the visit
            final PageReference templateVF = Page.MX_EU_Minuta_VF;
            templateVF.getParameters().put('id',visitObjNew.Id);
            templateVF.setRedirect(true);

            //insertar pdf, agregar a la lista con el check
            //adjuntar al registro

            //The visualforce is converted to the mail body
            try {
                docBlob = templateVF.getContentAsPDF();
                templateConverted = templateVF.getContent().tostring();
            } catch(VisualforceException e) {
                docBlob = Blob.valueOf('Texto de prueba para pdf ' + e);
            }

            final ContentVersion pdfMinuta = insertMinuta(docBlob, visitObjNew);

            documents.add(pdfMinuta);

            final String htmlBody = '<![CDATA[ <html lang="es">'+
                '<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'+ templateConverted+ '</html>';
            email.setHtmlBody(htmlBody);
            email.setSubject(myCS.dwp_kitv__Subject__c);

            //Get the list of recipients
            final List<String> typeAddress= dwp_kitv.Minute_Generator_Ctrl.getTypeAddress();
            email = dwp_kitv.Minute_Generator_Ctrl.setAddressToEmail(email,typeAddress,visitObjNew);
            final String[] correosEjec = new String[]{String.valueOf(userObj.Email)};
            if(userObj.Manager != null) {
                correosEjec.add(String.valueOf(userObj.Manager.Email));
            }
            email.setBccAddresses( correosEjec);
            //validate if attachments are sent
            final boolean attachFile= dwp_kitv.Minute_Generator_Ctrl.getExistField(myCS, FIELDATTACHFILE);
            final List<Id> ltsIdDoc = dwp_kitv.Minute_Generator_Ctrl.getIdsDocuments(documents);
            email = dwp_kitv.Minute_Generator_Ctrl.setFiles(email, ltsIdDoc, attachFile);
            email.setSaveAsActivity(false);

            final Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {email};
            final Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            if (results[0].isSuccess() && !vfError) {
                correoEnviado = true;
                dwp_kitv.Minute_Generator_Ctrl.createActivity(visitObjNew.Id, myCS);
            } else {
                correoEnviado = false;
                dwp_kitv.Minute_Generator_Ctrl.updateStatusVisit(visitObjNew,statusOldVisit);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error al enviar el email: ' + results[0].errors[0].message));
            }
        } catch(Exception ex) {
            correoEnviado = false;
            dwp_kitv.Minute_Generator_Ctrl.updateStatusVisit(visitObj,statusOldVisit);
            String errorMessage = ex.getMessage();
            Integer occurence;
            if (errorMessage.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') || vfError) {
                occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
                errorMessage = errorMessage.mid(occurence, errorMessage.length()).mid(errorMessage.indexOf(',') + 1, errorMessage.length()).mid(0, errorMessage.lastIndexOf(':'));
            } else {
                errorMessage = ex.getMessage();
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error al enviar el email: ' + errorMessage ));
        }
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          05-09-2019
* @Description  Insert minuta.
* @Comments     Created from the clipped code block of method sendTemplateEmail.
* @param        Blob docBlob, String visitObjNewName
* @return       ContentVersion
* @example      ContentVersion minuta = insertMinuta(docBlob, visitObjNewName);
**/
    public ContentVersion insertMinuta(Blob docBlob, dwp_kitv__Visit__c visitObjNew) {

        final ContentVersion pdfMinuta = new ContentVersion();
        pdfMinuta.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        pdfMinuta.VersionData = docBlob;
        pdfMinuta.Title = 'Minuta ' + visitObjNew.Name;
        pdfMinuta.PathOnClient = 'Minuta ' + visitObjNew.Name + '.pdf';
        pdfMinuta.IsAssetEnabled = true;

        insert pdfMinuta;

        insertContentDocLink(pdfMinuta.Id, visitObjNew.Id);

        return pdfMinuta;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          05-09-2019
* @Description  Insert content document link.
* @Comments     Created from the clipped code block of method sendTemplateEmail.
* @param        Id pdfMinutaId, Id visitObjNewId
* @return
* @example      insertContentDocLink(pdfMinutaId, visitObjNewId);
**/
    public void insertContentDocLink(Id pdfMinutaId, Id visitObjNewId) {
        final ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: pdfMinutaId].ContentDocumentId;
        cdl.LinkedEntityId = visitObjNewId;
        cdl.ShareType = 'V';
        insert cdl;
    }

/**
* --------------------------------------------------------------------------------------
* @Author       Cindy Hernández cindyarianna.hernandez.nieto.contractor@bbva.com
* Date          09-09-2019
* @Description  Get the escaped paramater.
* @Comments     Created from the clipped code block of method sendTemplateEmail.
* @param        String, parameterToGet.
* @return       String, the escaped parameter.
* @example      getParamater('documents');
**/
    public String getParamater(String parameterToGet) {
        String param = '';
        param = String.isBlank(ApexPages.currentPage().getParameters().get(parameterToGet)) ? param : ApexPages.currentPage().getParameters().get(parameterToGet);
        return param.escapeHtml4();
    }
}