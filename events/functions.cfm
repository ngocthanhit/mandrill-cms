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


    boolean function isManager() hint="Check if current user is account manager" {
        return (getUserAttr("accessLevel") GTE get("accessLevelManager"));
    }


    boolean function isAdmin() hint="Check if current user is admin" {
        return (getUserAttr("accessLevel") EQ get("accessLevelAdmin"));
    }


    boolean function isDeveloper() hint="Check if current user is developer" {
        return (ListFind(get("developersUserId"), getUserAttr("id")));
    }


    any function ShortUUID() hint="Get short version of UUID" {
        return ListFirst(CreateUUID(), "-");
    }


    /*
     * @source String to convert
     * @replacer Forbidden characters replacer
     * @uppercase Uppercase the string before output
     */
    string function tokenize(required string source, string replacer="-", boolean uppercase=false)
    hint="Convert the string to the safe token" {

        var token = LCase(Trim(arguments.source));

        token = Replace(token, " ", arguments.replacer, "ALL");
        token = Replace(token, "@", arguments.replacer, "ALL");
        token = ReReplace(token, "[^0-9a-z\#arguments.replacer#]", "", "ALL");
        token = ReReplace(token, "\#arguments.replacer#+", arguments.replacer, "ALL");
        token = Left(token, 255);

        if (arguments.uppercase) {
            token = UCase(token);
        }

        return token;

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
     * Notes on composite keys for setting values.
     * - Account id and user id depend on access level of the setting token.
     * - If access level is 1 (user), used accountid of current account and userid of current user.
     * - If access level is 2 (account), used accountid of current account and userid of visitor.
     * - If access level is 3 (application), used accountid of visitors and userid of visitor.
     * This way composite keys are unique and predictable.
     */


    /*
     * @token Target setting token
     */
    any function getSetting(required string token) hint="Get setting value by composite key with parent token" {

        return getSettingObject(arguments.token).value;

    }


    /*
     * @token Target setting token
     */
    any function getSettingObject(required string token) hint="Get setting value object by composite key with parent token" {

        var local = {};

        // get model by token, restrict to existing records only

        local.settingtoken = model("settingtoken").findOneByToken(arguments.token);

        if (isObject(local.settingtoken)) {

            // pull the ids according to access level (see notes above)
            if (local.settingtoken.accesslevel EQ get("accessLevelAdmin")) {
                local.accountid = get("visitorsAccountId");
                local.userid = get("visitorUserId");
            }
            else if (local.settingtoken.accesslevel EQ get("accessLevelManager")) {
                local.accountid = getAccountAttr("id");
                local.userid = get("visitorUserId");
            }
            else {
                local.accountid = getAccountAttr("id");
                local.userid = getUserAttr("id");
            }

            // try to get value by PK
            local.settingvalue = model("settingvalue").getByCompositeKey(
                settingtokenid = local.settingtoken.id,
                accountid = local.accountid,
                userid = local.userid
            );

            // init the value with defaults if does not exist yet
            if (NOT isObject(local.settingvalue)) {

                local.settingvalue = model("settingvalue").create({
                    settingtokenid : local.settingtoken.id,
                    accountid : local.accountid,
                    userid : local.userid,
                    value : local.settingtoken.defaultvalue
                });

            }

            return local.settingvalue;

        }
        else {
            throw(message = "Setting token #arguments.token# does not exist");
        }

    }


    /*
     * @token Target setting token
     * @value Value to set
     */
    any function setSetting(required string token, required any value)
    hint="Update/create setting value by composite key with parent token" {

        var local = {};

        // get model by token, restrict to existing records only

        local.settingtoken = model("settingtoken").findOneByToken(arguments.token);

        if (isObject(local.settingtoken)) {

            // pull the ids according to access level (see notes above)
            if (local.settingtoken.accesslevel EQ get("accessLevelAdmin")) {
                local.accountid = get("visitorsAccountId");
                local.userid = get("visitorUserId");
            }
            else if (local.settingtoken.accesslevel EQ get("accessLevelManager")) {
                local.accountid = getAccountAttr("id");
                local.userid = get("visitorUserId");
            }
            else {
                local.accountid = getAccountAttr("id");
                local.userid = getUserAttr("id");
            }

            // try to get value by PK
            local.settingvalue = model("settingvalue").getByCompositeKey(
                settingtokenid = local.settingtoken.id,
                accountid = local.accountid,
                userid = local.userid
            );

            // init the value with defaults if does not exist yet, or update existing
            if (NOT isObject(local.settingvalue)) {

                local.settingvalue = model("settingvalue").create({
                    settingtokenid : local.settingtoken.id,
                    accountid : local.accountid,
                    userid : local.userid,
                    value : arguments.value
                });

            }
            else {

                local.settingvalue.update(value = arguments.value);

            }

            return local.settingvalue;

        }
        else {
            throw(message = "Setting token #arguments.token# does not exist");
        }

    }


    /*
     * @token Target setting token
     * @defaultvalue Default value
     */
    void function createSetting(
        required string token,
        required string datatype,
        required numeric accesslevel,
        any defaultvalue = "",
        string description = "",
        numeric islisted = 0,
        numeric isrequired = 1,
        numeric minvalue = 0,
        numeric maxvalue = 0
    )
    hint="Create setting token with given defaults" {


        var settingtoken = model("settingtoken").create({
            token : arguments.token,
            datatype : arguments.datatype,
            accesslevel : arguments.accesslevel,
            defaultvalue : arguments.defaultvalue,
            description : arguments.description,
            islisted : arguments.islisted,
            isrequired : arguments.isrequired,
            minvalue : arguments.minvalue,
            maxvalue : arguments.maxvalue
        });

        if (settingtoken.hasErrors()) {
            flashInsert(error="Failed to create the setting");
        }

    }


    /*
     * @token Target setting token
     */
    void function deleteSetting(required string token) hint="Delete setting token" {
        model("settingtoken").findOneByToken(arguments.token).delete();
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
            case "Contacts":
                return model("contact").count(where = "accountid=#local.accountid#");
            case "CustomFields":
                return model("customfield").count(where = "accountid=#local.accountid#");
            case "MailTemplates":
                return model("mailtemplate").count(where = "accountid=#local.accountid#");
            case "DiskSpace":
                local.space = model("mailtemplate").sum(property = "filesize", where = "accountid=#local.accountid#");
                return isNumeric(local.space) ? Ceiling(local.space / 1024) : 0;
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

                    model("accountquota").create({
                        accountid : local.accountplan.accountid,
                        quotaid : local.quotas.id[local.idx],
                        accountplanid : local.accountplan.id,
                        quota : local.quotas.quota[local.idx],
                        isactive : 1
                    });

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



    /*
     * @token Target permissionsing token
     */
    boolean function granted(required string token) hint="Get current user access by permission token" {

        // check makes sense only for TM

        if (getUserAttr("accessLevel") GT get("accessLevelMember")) {
            return true;
        }

        // check if permission is cached

        local.cacheKey = "#getUserAttr('id')#-#arguments.token#";

        if (cacheKeyExists(key = local.cacheKey, cacheName = get("cacheGlobalPermissions"))) {
            return cacheGet(id = local.cacheKey, cacheName = get("cacheGlobalPermissions"));
        }

        // pull token and corresponding value by composite PK

        local.permissiontoken = model("permissiontoken").findOneByToken(arguments.token);

        if (NOT isObject(local.permissiontoken)) {
            throw(message="Undefined permission token #arguments.token#");
        }

        local.permissionvalue = model("permissionvalue").findOne(
            where = "userid = #getUserAttr('id')# AND permissiontokenid = #local.permissiontoken.id#"
        );

        // cache permission value (timeout settings are in web-context)

        local.cachedValue = (isObject(local.permissionvalue) ? local.permissionvalue.granted : false);

        cachePut(id = local.cacheKey, value = local.cachedValue, cacheName = get("cacheGlobalPermissions"));

        return local.cachedValue;

    }


    /*
     * @key Target app setting name
     */
    string function getFilesServerPath(required string key) hint="Get full path of files sub directory for current account" {

        var path = ExpandPath(get("filePath") & Replace(get(arguments.key), "{id}", getAccountAttr("id")));

        if (NOT DirectoryExists(path)) {
            DirectoryCreate(path);
        }

        return path;

    }


    /*
     * @key Target app setting name
     */
    string function getFilesWebPath(required string key) hint="Get full path of files sub directory for current account" {

        return "/" & get("filePath") & Replace(get(arguments.key), "{id}", getAccountAttr("id"));

    }


</cfscript>



<cffunction name="queryToJavaArray" returntype="array" access="public" output="false" hint="Convert query into the Java-casted array with headers">
    <cfargument name="input" type="query" required="true" hint="Source contacts query" />
    <cfargument name="columnlist" type="string" required="false" default="" hint="Restrict listing to these columns" />
    <cfargument name="headers" type="string" required="false" default="" hint="Override standard CC headers with list" />
    <cfset var local = {} />


    <cfset local.output = [] />


    <!--- get case-sensitive list of columns --->

    <cfset local.columns = (arguments.columnlist NEQ "") ? arguments.columnlist : arguments.input.getColumnlist(false) />


    <!--- write the headers row --->

    <cfset local.row = [] />

    <cfif ListLen(arguments.headers)>

        <cfloop list="#arguments.headers#" index="local.column">
            <cfset ArrayAppend(local.row, local.column) />
        </cfloop>

    <cfelse>

        <cfloop list="#local.columns#" index="local.column">
            <cfset ArrayAppend(local.row, getLabelByColumn(local.column)) />
        </cfloop>

    </cfif>

    <cfset ArrayAppend(local.output, JavaCast("string[]", local.row)) />


    <cfloop query="arguments.input">

        <cfset local.row = [] />

        <cfloop list="#local.columns#" index="local.column">
            <cfset local.value = arguments.input[local.column][arguments.input.currentRow] />
            <cfif local.column EQ "createdAt">
                <cfset ArrayAppend(local.row, formatDate(local.value)) />
            <cfelseif local.column EQ "updatedAt">
                <cfset ArrayAppend(local.row, formatDateTime(local.value)) />
            <cfelseif local.column EQ "country">
                <cfset ArrayAppend(local.row, StructKeyExists(request.countries, local.value) ? HTMLEditFormat(request.countries[local.value]) : "") />
            <cfelse>
                <cfset ArrayAppend(local.row, local.value) />
            </cfif>
        </cfloop>

        <cfset ArrayAppend(local.output, JavaCast("string[]", local.row)) />

    </cfloop>


    <cfreturn local.output />


</cffunction>



<cffunction name="filterMailChimpSubscriptions" returntype="query" access="public" output="false" hint="Filter out inactive list subscriptions (emails)">
    <cfargument name="contacts" type="query" required="true" hint="Contacts query" />
    <cfargument name="listid" type="string" required="true" hint="Target MailChimp list id" />
    <cfset var local = {} />

    <cfquery datasource="#get('dataSourceName')#" name="local.filters">
        select distinct(contactid) as contactid
        from mailchimpemails
        where listid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.listid#" />
        and status != <cfqueryparam cfsqltype="cf_sql_char" value="sub" />
    </cfquery>

    <cfquery dbtype="query" name="local.contacts">
        select * from arguments.contacts
        where id not in (<cfqueryparam cfsqltype="cf_sql_char" value="#ValueList(local.filters.contactid)#" list="true" />)
    </cfquery>

    <cfreturn local.contacts />

</cffunction>



<cffunction name="queryToArrayOfStructs" returntype="array" access="public" output="false" hint="Convert query into the array of structures by given keys">
    <cfargument name="input" type="query" required="true" hint="Source contacts query" />
    <cfargument name="keys" type="struct" required="true" hint="Collection with key for output and value for query column" />
    <cfargument name="filters" type="struct" required="true" hint="Filter records by key-value matches" />
    <cfset var local = {} />


    <cfset local.output = [] />


    <!--- TODO: maybe run QoQ to apply filters in batch? --->


    <cfloop query="arguments.input">


        <!--- check skip restrictions --->

        <cfset local.skip = false />

        <cfloop collection="#arguments.filters#" item="local.key">

            <cfif arguments.input[local.key][arguments.input.currentRow] EQ arguments.filters[local.key]>
                <cfset local.skip = true />
                <cfbreak />
            </cfif>

        </cfloop>


        <!--- collect row values --->

        <cfif NOT local.skip>

            <cfset local.row = {} />

            <cfloop collection="#arguments.keys#" item="local.key">

                <cfset local.column = arguments.keys[local.key] />
                <cfset local.value = arguments.input[local.column][arguments.input.currentRow] />

                <cfif local.column EQ "createdAt">
                    <cfset local.row[local.key] = formatDate(local.value) />
                <cfelseif local.column EQ "updatedAt">
                    <cfset local.row[local.key] = formatDateTime(local.value) />
                <cfelseif local.column EQ "country">
                    <cfset local.row[local.key] = (StructKeyExists(request.countries, local.value) ? HTMLEditFormat(request.countries[local.value]) : "") />
                <cfelse>
                    <cfset local.row[local.key] = local.value />
                </cfif>

            </cfloop>

            <cfset ArrayAppend(local.output, local.row) />

        </cfif>


    </cfloop>


    <cfreturn local.output />


</cffunction>



<cffunction name="getLabelByColumn" returntype="string" access="public" output="false" hint="Get label for contact column">
    <cfargument name="column" type="string" required="true" hint="Source contacts query">
    <cfargument name="nobreak" type="boolean" required="false" default="false" hint="Use no-break spaces">

    <cfif Left(arguments.column, Len("custom")) EQ "custom">

        <cfquery datasource="#get('dataSourceName')#" name="local.customfield">
            select fieldname
            from customfields
            where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ReplaceNoCase(arguments.column,'custom','')#" />
        </cfquery>

        <cfreturn (local.customfield.recordCount) ? (arguments.nobreak ? Replace(local.customfield.fieldname, " ", "&nbsp;") : local.customfield.fieldname) : arguments.column />

    <cfelse>

        <cfset var cols = {
            "id" : "Contact ID",
            "salutation" : "Salutation",
            "firstname" : "First Name",
            "lastname" : "Last Name",
            "title" : "Title",
            "ismailable" : "Accepts Mail",
            "iscontactable" : "Can Be Contacted",
            "isactive" : "Is Active",
            "createdat" : "Created",
            "updatedat" : "Updated",
            "emailType" : "Email Type",
            "email" : "Email Address",
            "phoneType" : "Phone Type",
            "number" : "Phone Number",
            "addressType" : "Address Type",
            "company" : "Company",
            "country" : "Country",
            "postcode" : "Zip/Postcode",
            "address" : "Address Lines 1-3",
            "address1" : "Address Line 1",
            "address2" : "Address Line 2",
            "address3" : "Address Line 3",
            "city" : "City",
            "state" : "State/County",
            "websiteType" : "Website Type",
            "website" : "Website URL"
        } />

        <cfreturn StructKeyExists(cols, arguments.column) ? (arguments.nobreak ? Replace(cols[arguments.column], " ", "&nbsp;") : cols[arguments.column]) : arguments.column />

    </cfif>

</cffunction>



<cffunction name="getStandardColumns" returntype="string" access="public" output="false" hint="Get columns for standard contact attributes">
    <cfscript>
        var standardcolumns = "id,salutation,firstname,lastname,title,iscontactable,isactive,";
        standardcolumns &= "createdAt,updatedAt,emailType,email,phoneType,number,addressType,company,";
        standardcolumns &= "country,postcode,address1,address2,address3,city,state,websiteType,website";
        return standardcolumns;
    </cfscript>
</cffunction>



<cffunction name="arrayToCsvFile" returntype="void" access="public" output="false" hint="Write array dataset into the CSV file">
    <cfargument name="dataset" type="array" required="true" hint="Dataset to save" />
    <cfargument name="csvpath" type="string" required="true" hint="Path to write the file" />
    <cfset var local = {} />
    <cfscript>

        // write dataset using 3rd-party Java component OpenCSV
        local.fileWriter = CreateObject("java","java.io.FileWriter").init(arguments.csvpath);
        local.csvWriter = CreateObject("java","au.com.bytecode.opencsv.CSVWriter").init(local.fileWriter, ',', '"');
        local.csvWriter.writeAll(arguments.dataset);
        local.csvWriter.close();

    </cfscript>
</cffunction>



<cffunction name="fileToZip" returntype="void" access="public" output="false" hint="Zip file in the filesystem">
    <cfargument name="file" type="string" required="true" hint="Full path of the file to write" />
    <cfargument name="source" type="string" required="true" hint="Source directory to zip" />
    <cfargument name="filter" type="string" required="true" hint="Filter files in the source directory" />

    <cfzip
        action="zip"
        file="#arguments.file#"
        source="#arguments.source#"
        filter="#arguments.filter#"
        overwrite="true"
        storepath="false"
        />

</cffunction>



<cffunction name="fileToTemp" returntype="any" access="public" output="false" hint="Upload and save file to a temporary directory on the server">
    <cfargument name="filefield" type="string" required="true" hint="Name of form field used to select the file" />
    <cfargument name="accept" type="string" required="true" hint="Limits the MIME types to accept" />

    <cfset var result = {} />

    <cftry>

        <cffile
            action="upload"
            filefield="#arguments.filefield#"
            destination="#GetTempDirectory()#"
            accept="#arguments.accept#"
            nameconflict="makeunique"
            result="result"
                />

    <cfcatch type="any">

        <cfset result.fileWasSaved = false />
        <cfset result.exception = cfcatch />

    </cfcatch>
    </cftry>

    <cfreturn result />

</cffunction>



<cffunction name="getPdfInfo" returntype="any" access="public" output="false" hint="Wrapper for cfpdf / getinfo tag">
    <cfargument name="source" type="string" required="true" hint="Source file to analyze" />

    <cfset var result = {} />

    <cfpdf
        action="getinfo"
        source="#arguments.source#"
        name="result"
            />

    <cfreturn result />

</cffunction>



<cffunction name="genPdfThumbnail" returntype="void" access="public" output="false" hint="Extended wrapper for cfpdf / thumbnail tag">
    <cfargument name="source" type="string" required="true" hint="Source file to get thumbnail for" />

    <cfset var result = {} />

    <cfpdf
        action="thumbnail"
        source="#arguments.source#"
        destination="#GetDirectoryFromPath(arguments.source)#"
        pages="1"
        format="jpeg"
        resolution="low"
        overwrite="true"
        scale="25"
        />

    <cffile
        action="move"
        source="#Replace(arguments.source, '.pdf', '_page_1.jpg')#"
        destination="#Replace(arguments.source, '.pdf', '.jpg')#"
        />

</cffunction>



<cffunction name="saveSchedulerTask" returntype="void" access="public" output="false" hint="Wrapper for cfschedule action=update">
    <cfargument name="task" type="string" required="true" hint="Name of the task" />
    <cfargument name="url" type="string" required="true" hint="URL of the page to execute" />
    <cfargument name="startDate" type="string" required="true" hint="Date on which to first run the scheduled task" />
    <cfargument name="startTime" type="string" required="true" hint="Time at which to run the scheduled of task starts" />
    <cfargument name="endDate" type="string" required="false" default="" hint="Date when scheduled task ends" />
    <cfargument name="endTime" type="string" required="false" default="" hint="Time when scheduled task ends" />
    <cfargument name="interval" type="string" required="false" default="once" hint="Interval at which task is scheduled" />
    <cfargument name="requestTimeOut" type="numeric" required="false" default="900" hint="Can be used to extend the default timeout period" />
    <cfargument name="publish" type="boolean" required="false" default="false" hint="Save the result to a file" />
    <cfargument name="file" type="string" required="false" default="" hint="Name of the file in which to store the published output of the scheduled task" />
    <cfargument name="path" type="string" required="false" default="" hint="Path to the directory in which to put the published file" />

    <cfschedule
        action = "update"
        task = "#arguments.task#"
        operation = "HTTPRequest"
        url = "#arguments.url#"
        startDate = "#arguments.startDate#"
        startTime = "#arguments.startTime#"
        endDate = "#arguments.endDate#"
        endTime = "#arguments.endTime#"
        interval = "#arguments.interval#"
        requestTimeOut = "#arguments.requestTimeOut#"
        publish = "#arguments.publish#"
        file = "#arguments.file#"
        path = "#arguments.path#"
             />

</cffunction>


<cffunction name="pauseSchedulerTask" returntype="any" access="public" output="false" hint="Wrapper for cfschedule action=pause">
    <cfargument name="task" type="string" required="true" hint="Name of the task" />

    <cfschedule
        action = "pause"
        task = "#arguments.task#"
             />

</cffunction>


<cffunction name="resumeSchedulerTask" returntype="any" access="public" output="false" hint="Wrapper for cfschedule action=resume">
    <cfargument name="task" type="string" required="true" hint="Name of the task" />

    <cfschedule
        action = "resume"
        task = "#arguments.task#"
             />

</cffunction>


<cffunction name="deleteSchedulerTask" returntype="any" access="public" output="false" hint="Wrapper for cfschedule action=delete">
    <cfargument name="task" type="string" required="true" hint="Name of the task" />

    <cfschedule
        action = "delete"
        task = "#arguments.task#"
             />

</cffunction>




