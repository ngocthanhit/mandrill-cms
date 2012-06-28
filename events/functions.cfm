<cfscript>


    /*
     * Place functions here that should be globally available in your application.
     */


    /*
     * @type Event type (I,W,E)
     * @message Basic event text
     * @category Event category for account activity
     * @detail Extended event text
     * @accountid Override current account id
     * @userid Override current user id
     */
    void function _event(
        required string type,
        required string message,
        string category = "",
        string detail = "",
        numeric accountid = 0,
        numeric userid = 0
    )
    hint="Save system log event" {

        var local = {};

        local.event = {
            "type" : arguments.type,
            "message" : arguments.message,
            "category" : arguments.category,
            "detail" : arguments.detail,
            "remoteIp" : cgi.REMOTE_ADDR
        };

        local.event["accountid"] = (arguments.accountid NEQ 0) ? arguments.accountid : getAccountAttr("id");
        local.event["userid"] = (arguments.userid NEQ 0) ? arguments.userid : getUserAttr("id");
        local.event["action"] = isDefined("params") ? (LCase(params.controller) & "." & params.action) : "page.home";

        local.currentevent = model("currentevent").create(local.event);

        if (local.currentevent.hasErrors()) {
            local.errors = local.currentevent.allErrors();
            _text("error", "#local.errors[1].property# - #local.errors[1].message#");
        }

    }


    /*
     * @type Type (severity) of the message (information,warning,error,fatal)
     * @text Message text to log
     * @file Message file. Specify only the main part of the filename.
     */
    void function _text(
        required string type,
        required string text,
        string file = "application"
    )
    hint="Save text log message" {

        writeLog(type=arguments.type, file=arguments.file, text=arguments.text);

    }
    
    
    /*
     * @key Attribute name to read
     */
    any function getAccountAttr(required string key) hint="Get active account attribute" {
        return request.account[arguments.key];
    }


    /*
     * @key Attribute name to read
     */
    any function getUserAttr(required string key) hint="Get active user attribute" {
        return request.user[arguments.key];
    }
    
    
    boolean function isLoggedIn(string key) hint="Check if current user is logged in" {
        return (getUserAttr("id") GT get("visitorUserId"));
    }
    
    
    boolean function isAccountOwner() hint="Check if current user is account manager" {
        return (getUserAttr("accessLevel") GTE get("accessLevelAccountOwner"));
    }


    boolean function isAdmin() hint="Check if current user is admin" {
        return (getUserAttr("accessLevel") EQ get("accessLevelAdmin"));
    }


    boolean function isDeveloper() hint="Check if current user is developer" {
        return (ListFind(get("developersUserId"), getUserAttr("id")));
    }

    boolean function isAuthor() hint="Check if current user is author" { //maimun
        return (getUserAttr("accessLevel") EQ get("accessLevelAuthor"));
    }

    boolean function isEditor() hint="Check if current user is editor" { //maimun
        return (getUserAttr("accessLevel") EQ get("accessLevelEditor"));
    }

    boolean function isGuest() hint="Check if current user is guest" { //maimun
        return (getUserAttr("accessLevel") EQ get("accessLevelGuest"));
    }
    
    any function ShortUUID() hint="Get short version of UUID" {
        return ListFirst(CreateUUID(), "-");
    }
    

</cfscript>