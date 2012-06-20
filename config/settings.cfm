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


</cfscript>
