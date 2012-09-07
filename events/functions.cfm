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

    boolean function issiteID() hint="get siteid" {
        return (IsDefined("session.siteID"));
    }

    any function getsiteID() hint="get siteid" {
        if(IsDefined("session.siteID")){
            return (session.siteID);
        } else {
            return 0;
        }
    }
    
    
    void function saveStickyAttributes() hint="Save the sticky attributes for current page" {

        lock scope="session" type="exclusive" timeout="15" {

            index = 1;
            total = ListLen(request.view.stickyAttributes);

            page = request.wheels.params.controller & "." & request.wheels.params.action;

            while (index <= total) {

                if (NOT StructKeyExists(session.stickyAttributes, page)) {
                    session.stickyAttributes[page] = {};
                }

                key = ListGetAt(request.view.stickyAttributes, index);

                if (StructKeyExists(request.wheels.params, key)) {
                    session.stickyAttributes[page][key] = request.wheels.params[key];
                }

                index++;

            }

        }

    }


    /*
     * @src String to encrypt/decrypt
     * @enc Action is Encrypt
     */
    string function crypt(required string src, required boolean enc) hint="Encrypt/Decrypt given string" {

        if (arguments.enc) {
            return Encrypt(arguments.src, get("encryptionKey"), get("encryptionAlgorithm"), get("encryptionEncoding"));
        }
        else {
            return Decrypt(arguments.src, get("encryptionKey"), get("encryptionAlgorithm"), get("encryptionEncoding"));
        }

    }


    /*
     * @token Target feature token
     */
    numeric function getQuotaValue(required string token, numeric accountid = 0) hint="Get current account quota value by parent feature token" {

        return getQuotaObject(arguments.token, arguments.accountid).quota;

    }


    /*
     * @token Target feature token
     */
    numeric function getQuotaCurrent(required string token, numeric accountid = 0) hint="Get current account quota status by parent feature token" {

        local.accountid = arguments.accountid ? arguments.accountid : getAccountAttr('id');

        switch (arguments.token) {
            case "TeamMembers":
                return model("user").count(where = "accountid=#local.accountid#");
            case "WebSites":
                // TODO:
                // return model("site").count(where = "accountid=#local.accountid#");
                return 0;
            case "Hosting":
                return getQuotaValue("Hosting", local.accountid);
            default:
                throw(message = "Feature token #arguments.token# does not exist");
        }

    }


    /*
     * @token Target feature token
     */
    numeric function getQuotaLeft(required string token, numeric accountid = 0) hint="Get available account quota value by parent feature token" {

        var local = {};

        local.value = getQuotaValue(arguments.token, arguments.accountid);

        local.current = getQuotaCurrent(arguments.token);

        return (local.value GT local.current) ? (local.value - local.current) : 0;

    }


    /*
     * @token Target feature token
     */
    any function getQuotaObject(required string token, numeric accountid = 0) hint="Get account quota object by parent feature token" {

        var local = {};

        local.accountid = arguments.accountid ? arguments.accountid : getAccountAttr('id');

        // get model by token, restrict to existing records only

        local.accountquota = model("accountquota").findQuotaByFeatureToken(arguments.token, local.accountid);

        if (isObject(local.accountquota)) {

            return local.accountquota;

        }
        else {

            // get active plan and default quotas

            local.accountplan = model("accountplan").findOne(
                where = "accountid=#local.accountid# AND isactive=1"
            );

            local.quotas = model("quota").findAll(
                where = "planid = #local.accountplan.planid#"
            );

            // create missing quotas, if any were added recently

            for (local.idx=1; local.idx LTE local.quotas.recordCount; local.idx++) {

                local.found = model("accountquota").count(
                    where = "accountid=#local.accountplan.accountid# AND quotaid=#local.quotas.id[local.idx]# AND isactive=1"
                );

                if (NOT local.found) {

                    local.added=model("accountquota").create({
                        accountid : local.accountplan.accountid,
                        quotaid : local.quotas.id[local.idx],
                        accountplanid : local.accountplan.id,
                        quota : local.quotas.quota[local.idx],
                        isactive : 1
                    });
                    if(local.added.hasErrors()){
                        writeDump(var=local.added.allErrors()); abort;
                    }

                }

            }

            // try again to find the quota

            local.accountquota = model("accountquota").findQuotaByFeatureToken(arguments.token, local.accountid);

            if (isObject(local.accountquota)) {
                return local.accountquota;
            }
            else {
                throw(message = "Quota for feature #arguments.token# does not exist");
            }

        }

    }
    

</cfscript>