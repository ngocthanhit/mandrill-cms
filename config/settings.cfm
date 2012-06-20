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

    // maintenance exceptions IP list
    // or passed along in the URL as except=127.0.0.1
    set(ipExceptions="127.0.0.1");

    // hide this by default
    set(showDebugInformation=false);

    // error notification settings
    set(sendEmailOnError=false);
    set(errorEmailAddress="sergey@contactchimp.com");
    set(errorEmailSubject="Unexpected failure at #cgi.SERVER_NAME#");


    /*
     * APPLICATION SETTINGS
     */

    // base URL for absolute paths
    set(baseURL="http://#cgi.SERVER_NAME#");


</cfscript>
