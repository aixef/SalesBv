<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>getFinancialSituationMock</label>
    <protected>false</protected>
    <values>
        <field>iaso__Authentication_Service__c</field>
        <value xsi:type="xsd:string">bbvaGrantingTicketsMx</value>
    </values>
    <values>
        <field>iaso__Blocked_Service__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>iaso__Custom_Setting__c</field>
        <value xsi:type="xsd:string">getDataServicesPyME</value>
    </values>
    <values>
        <field>iaso__Headers_Class__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Http_Headers_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Http_Headers_LTA__c</field>
        <value xsi:type="xsd:string">{&quot;Content-Type&quot;: &quot;application/json;charset=UTF-8&quot;}</value>
    </values>
    <values>
        <field>iaso__Http_Method__c</field>
        <value xsi:type="xsd:string">GET</value>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Mock_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Mock_LTA__c</field>
        <value xsi:type="xsd:string">{&quot;financialSituation&quot;:{&quot;date&quot;:&quot;2018-12-17&quot;,&quot;loan&quot;:{&quot;percentageCredit&quot;:0.37,&quot;totalCredit&quot;:{&quot;amount&quot;:2077624.05}},&quot;balance&quot;:{&quot;percentageCaption&quot;:99.63,&quot;totalBalance&quot;:{&quot;amount&quot;:558013246.28}}},&quot;pagination&quot;:{&quot;previousPaginationKey&quot;:&quot;007425930500108812&quot;,&quot;nextPaginationKey&quot;:&quot;00748200029892787474&quot;,&quot;moreMovements&quot;:&quot;N&quot;},&quot;listfinancialSituation&quot;:[{&quot;loan&quot;:{&quot;loanBase&quot;:{&quot;productDescription&quot;:&quot;TDC NEGOCIOS&quot;},&quot;impactIndicator&quot;:&quot;N&quot;},&quot;balance&quot;:{&quot;debitBalance&quot;:{&quot;amount&quot;:814861.92},&quot;creditNumber&quot;:&quot;007425930500108812&quot;},&quot;fiscalPersonality&quot;:{&quot;type&quot;:&quot;A&quot;}},{&quot;loan&quot;:{&quot;loanBase&quot;:{&quot;productDescription&quot;:&quot;CREDITO SIMPLE&quot;},&quot;impactIndicator&quot;:&quot;N&quot;},&quot;balance&quot;:{&quot;debitBalance&quot;:{&quot;amount&quot;:857143.00},&quot;creditNumber&quot;:&quot;00748200049681283316&quot;},&quot;fiscalPersonality&quot;:{&quot;type&quot;:&quot;B&quot;}},{&quot;loan&quot;:{&quot;loanBase&quot;:{&quot;productDescription&quot;:&quot;CREDITO SIMPLE PYME&quot;},&quot;impactIndicator&quot;:&quot;N&quot;},&quot;balance&quot;:{&quot;debitBalance&quot;:{&quot;amount&quot;:333333.48},&quot;creditNumber&quot;:&quot;00748200029892787474&quot;},&quot;fiscalPersonality&quot;:{&quot;type&quot;:&quot;B&quot;}}],&quot;lstService&quot;:[{&quot;shortDescription&quot;:&quot;CARTA DE CREDITO&quot;,&quot;id&quot;:&quot;CRTC&quot;,&quot;indicator&quot;:&quot;N&quot;},{&quot;shortDescription&quot;:&quot;SEGUROS&quot;,&quot;id&quot;:&quot;SEGR&quot;,&quot;indicator&quot;:&quot;N&quot;},{&quot;shortDescription&quot;:&quot;TPV&quot;,&quot;id&quot;:&quot;TPVS&quot;,&quot;indicator&quot;:&quot;N&quot;},{&quot;shortDescription&quot;:&quot;ACTIVO&quot;,&quot;id&quot;:&quot;BCOM&quot;,&quot;indicator&quot;:&quot;R&quot;},{&quot;shortDescription&quot;:&quot;NO CONTRATADO&quot;,&quot;id&quot;:&quot;BMOV&quot;,&quot;indicator&quot;:&quot;R&quot;},{&quot;shortDescription&quot;:&quot;NO CONTRATADO&quot;,&quot;id&quot;:&quot;BSMS&quot;,&quot;indicator&quot;:&quot;R&quot;}],&quot;lstProduct&quot;:[{&quot;type&quot;:&quot;VISTA&quot;,&quot;balance&quot;:{&quot;balanceDaily&quot;:{&quot;amount&quot;:534645782.00},&quot;balancePreviousMonth&quot;:{&quot;amount&quot;:4235234234.15},&quot;balanceVariation&quot;:{&quot;amount&quot;:0.00}}},{&quot;type&quot;:&quot;PLAZO&quot;,&quot;balance&quot;:{&quot;balanceDaily&quot;:{&quot;amount&quot;:9.53},&quot;balancePreviousMonth&quot;:{&quot;amount&quot;:124.89},&quot;balanceVariation&quot;:{&quot;amount&quot;:0.00}}},{&quot;type&quot;:&quot;FONDOS&quot;,&quot;balance&quot;:{&quot;balanceDaily&quot;:{&quot;amount&quot;:23367454.75},&quot;balancePreviousMonth&quot;:{&quot;amount&quot;:9.00},&quot;balanceVariation&quot;:{&quot;amount&quot;:0.00}}}]}</value>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA__c</field>
        <value xsi:type="xsd:string">V02/#customerId#/financialSituation</value>
    </values>
    <values>
        <field>iaso__Retrieve_Mock_LTA_TEMP__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>iaso__Retrieve_Mock_LTA__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
</CustomMetadata>
