<cfscript>


    /*
     * FRAMEWORK SETTINGS
     */

    // default datasource name for ORM
    set(dataSourceName="mandrillcms");

    // full rewriting enabled
    set(URLRewriting="On");

    // assets grouped for easier CDN implementation
    set(imagePath="assets/images");
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
    
    // ACL settings
    set(visitorsAccountId=1);
    set(visitorUserId=1);
    set(adminsAccountId=2);
    set(accessLevelVisitor=0);
    set(accessLevelMember=1);
    set(accessLevelManager=2);
    set(accessLevelAdmin=3);
    // append id to access developer-only features
    set(developersUserId="3");


</cfscript>
