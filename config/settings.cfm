<cfscript>


    /*
     * FRAMEWORK SETTINGS
     */

    // default datasource name for ORM
    set(dataSourceName="mandrillcms");

    // full rewriting enabled
    set(URLRewriting="On");

    // form helper defaults
    set(functionName="textField", labelPlacement="before");
    set(functionName="passwordField", labelPlacement="before");
    set(functionName="passwordFieldTag", labelPlacement="before");
    set(functionName="textarea", labelPlacement="before");
    set(functionName="select", labelPlacement="before");
    set(functionName="selectTag", labelPlacement="before");

    // assets grouped for easier CDN implementation
    set(imagePath="assets/img");
    set(javascriptPath="assets/javascripts");
    set(stylesheetPath="assets/stylesheets");
    set(filePath="assets/files");
    set(dataPath="assets/data");

    // disable automatic validation -- it is rubbish
    set(automaticValidations=false);

    // disable populating updatedAt on create
    set(setUpdatedAtOnCreate=false);

    // hide this by default
    set(showDebugInformation=true);


    /*
     * APPLICATION SETTINGS
     */

    // base URL for absolute paths
    set(baseURL="http://#cgi.SERVER_NAME#");
    
    // application emails
    set(defaultEmail="mandrillbot@mandrillcms.com");
    set(supportEmail="hello@mandrillcms.com");
    
    // marketing/sales website URL
    set(metaWebsiteURL="http://dev.mandrillcms.com");
    
    // encryption key / hashing salt
    set(encryptionKey="be5466cfc52eK0ab45TR21e6");
    set(encryptionAlgorithm="BLOWFISH");
    set(encryptionEncoding="Base64");
    set(hashingKey="&0Dsxs2kB.fO");
    
    // ACL settings
    set(visitorsAccountId=1);
    set(visitorUserId=1);
    set(adminsAccountId=2);
    set(accessLevelVisitor=0);    
    set(accessLevelGuest=1);
    set(accessLevelAuthor=2);
    set(accessLevelEditor=3);
    set(accessLevelDeveloper=4);
    set(accessLevelAccountOwner=5);
    set(accessLevelAdmin=6);    
    // append id to access developer-only features
    set(developersUserId="3,4,5");
    
    // common defaults
    set(defaultTimeZone=27);

    // autologin
    set(autologinCookie="mandrillcms_rememberme");
    set(autologinPeriod=30); // in days

    // pre-defined view/layout settings
    set(viewDateFormats=[
        {"format" : "dd mmm yyyy", "label" : "31 Dec 2011 at 06:23 PM"},
        {"format" : "mm/dd/yyyy", "label" : "12/31/2011 at 06:23 PM"},
        {"format" : "dd/mm/yyyy", "label" : "31/12/2011 at 06:23 PM"}
    ]);
    set(viewTimeFormats=[
        {"format" : "hh:mm tt", "label" : "06:23 PM"}
    ]);

    // paging sizes
    set(showBySize="10,20,50");

    // scheduler links protection key
    set(schedulerAuthKey="8740fj37d705k2");

    // API webhooks protection key
    set(apiWebhookAuthKey="8740fj37d705k3");

    // keep log events before archiving
    set(keepEventsPeriod=30); // days

    // keep data history before archiving
    set(keepChangesPeriod=30); // days

    // keep anonymous searches before deleting
    set(keepSearchPeriod=6); // hours

    // date format for non-customizable values
    set(defaultDateFormat="dd mmm yyyy");


</cfscript>
