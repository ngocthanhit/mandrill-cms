<cfscript>

    // add server-specific settings as needed
    // see this for help http://cfwheels.org/docs/1-1/chapter/switching-environments

    switch (cgi.SERVER_NAME) {
        case "mandrillcms.com":
            set(environment="production");
            break;
        case "dev.mandrillcms.com":
            set(environment="testing");
            break;
        default:
            set(environment="development");
    }

</cfscript>
