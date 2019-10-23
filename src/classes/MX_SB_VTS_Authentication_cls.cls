/**
* @author bbva.com developers
* @date 2017
*
* @group iaso
*
* @description Class implementing IASO BBVA authentication method. 
* Class parameters has to be filled in authentication service Custom Metadata Type
*************************************************************************************************************
*           No  |     Date       |     Author      |    Description
* @version  1.0     26/08/2019      Arsenio Perez        Creacion
**/
global with sharing class MX_SB_VTS_Authentication_cls implements iaso.GBL_Integration_Authentication {
    /**variable isAuthenticated */
    global static Boolean isAuthenticated(iaso__GBL_Authentication_Service__mdt authenticationConfig) {
        // Check if the session is stored in the cache
        Cache.Partition partition;
        boolean ret = false;
        if (authenticationConfig.iaso__isOrgCache__c) {
            Cache.OrgPartition orgPart = Cache.Org.getPartition(authenticationConfig.iaso__Cache_Partition__c);
            partition = orgPart;
        } else {
            Cache.SessionPartition sessionPart = Cache.Session.getPartition(authenticationConfig.iaso__Cache_Partition__c);
            partition = sessionPart;
        }
        // Retrieve cache value from the partition
        Map < String, String > credentials = (Map < String, String > ) partition.get(authenticationConfig.iaso__Cache_Key__c);
        // if credentials are not set in the cache, reset
        if (credentials != null && credentials.get('tsec') != null) {//NOSONAR
            ret=  true;
        }
        return ret;
    }
    /**variable resetToken */
    global static iaso__GBL_Application_Log__c resetToken(iaso__GBL_Authentication_Service__mdt authenticationConfig) {
        Datetime initTime = Datetime.now();
        Http http = new Http();
        HttpRequest validationRequest = new HttpRequest();
        //validationRequest.setEndpoint(iaso__GBL_Integration_Util.getUrlFromCustomSettings(authenticationConfig.iaso__Custom_Setting__c));
        validationRequest.setEndpoint('https://bbvacifrado.smartcenterservicios.com/ws_salesforce_desarrollo/api/login/authenticate');
        validationRequest.setMethod('POST');
        validationRequest.setHeader('Content-Type', 'application/json;charset=UTF-8');
        validationRequest.setHeader('Content-Type', 'application/json');
        validationRequest.setHeader('Accept-Encoding', 'gzip,deflate');
        validationRequest.setHeader('Host', 'bbvacifrado.smartcenterservicios.com');
        validationRequest.setHeader('Connection', 'Keep-Alive');
        validationRequest.setHeader('User-Agent', 'PostmanRuntime/7.11.0');
        validationRequest.setHeader('Postman-Token', 'f29cb004-838d-4a96-8362-18753bc80f49');
        validationRequest.setHeader('content-length', '56');
        validationRequest.setHeader('Cache-Control', 'no-cache');
        validationRequest.setHeader('Accept', '*/*');
        String validationRequestBody ='{"Username": "'+authenticationConfig.iaso__User__c+'","Password":"'+getAuth(authenticationConfig)+'"}';
        validationRequest.setBody(validationRequestBody);
        HttpResponse response = http.send(validationRequest);
        // Parse the JSON response
        final String retpcode = String.valueOf(response.getStatusCode());
        if ('200'.equals(retpcode)==false && '202'.equals(retpcode)==false) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            String jsonResponse = response.getBody();
            jsonResponse= jsonResponse.remove('"');
            string tsec = jsonResponse;
            Map < String, String > credentials = new Map < String, String > ();
            // Add cache value to the partition
            credentials.put('tsec', tsec);
            //credentials.put('clientId', clientId);
            Cache.Partition partitionn;
            if (authenticationConfig.iaso__isOrgCache__c) {
                Cache.OrgPartition orgPart = Cache.Org.getPartition(authenticationConfig.iaso__Cache_Partition__c);
                partitionn = orgPart;
            } else { 
                Cache.SessionPartition sessionPart = Cache.Session.getPartition(authenticationConfig.iaso__Cache_Partition__c);
                partitionn = sessionPart;
            }
            partitionn.put(authenticationConfig.iaso__Cache_Key__c, credentials);
        }

        return new iaso__GBL_Application_Log__c(iaso__Start_Time__c = initTime,
            iaso__End_Time__c = Datetime.now(),
            iaso__Message_LTA__c = 'REQUEST: ' + validationRequest.getEndpoint() + '\n' + validationRequest.getBody() + '\n--\n--\n\nRESPONSE:\n' + response.getBody(),
            Name = 'GrantingTickets',
            iaso__Type__c = 'Integration',
            iaso__User__c = UserInfo.getUserId());


    }
    /** */
    public static HttpRequest applySecurity(HttpRequest request, iaso__GBL_Authentication_Service__mdt authenticationConfig) {

        // Check if the session is stored in the cache
        Cache.Partition partition;
        if (authenticationConfig.iaso__isOrgCache__c) {
             Cache.OrgPartition orgPart = Cache.Org.getPartition(authenticationConfig.iaso__Cache_Partition__c);
            partition = orgPart;
        } else {
            Cache.SessionPartition sessionPart = Cache.Session.getPartition(authenticationConfig.iaso__Cache_Partition__c);
            partition = sessionPart;
        }
        // Retrieve cache value from the partition
        Map < String, String > credentials = (Map < String, String > ) partition.get(authenticationConfig.iaso__Cache_Key__c);
        // if credentials are not set in the cache, reset
        if (credentials != null && credentials.get('tsec') != null) {
            string barrer = 'Bearer '+credentials.get('tsec'); 
            barrer= barrer.remove('"');    
            request.setHeader(authenticationConfig.iaso__Header_Token__c, barrer);
        }        
        return request;
    }
    private static String getAuth(iaso__GBL_Authentication_Service__mdt authenticationConfig) {
        Blob cryptoKey = EncodingUtil.base64Decode(authenticationConfig.iaso__CryptoKey__c);
        Blob encryptedPassword = EncodingUtil.base64Decode(authenticationConfig.iaso__Password__c);
        Blob decryptedData = Crypto.decryptWithManagedIV(Label.MX_SB_VTS_KriptoK, cryptoKey, encryptedPassword);//NOSONAR
        String authorizationHeader = decryptedData.toString();
        return authorizationHeader;
    }

}