component extends="Wheels" {


    /*
     * This is the parent controller file that all your controllers should extend.
     * You can add functions to this file to make them globally available in all your controllers.
     * Do not delete this file.
     */


    // view data alias
    view = request.view;


    // security tokens map for checkAccess()
    // populate this within your controller
    // for specific actions: "action" : "token"
    // for whole controller "*" : "token"
    variables.securityTokens = {};


    /*
     * ACCESS CONTROL
     */


    private any function memberOnly() hint="Require user to be authenticated to access actions" {

        if (NOT isLoggedIn()) {
            _view(pageTitle = "Forbidden");
            _event("W", "Caught attempt to access forbidden member-only page", "", cgi.HTTP_USER_AGENT);
            renderPage(controller="members", action="forbidden");
        }

    }


    private any function managerOnly() hint="Require user to be account manager to access actions" {

        if (NOT isManager()) {
            _view(pageTitle = "Forbidden");
            _event("W", "Caught attempt to access forbidden manager-only page", "", cgi.HTTP_USER_AGENT);
            renderPage(controller="members", action="forbidden");
        }

    }


    private any function adminOnly() hint="Require user to be admin to access actions" {

        if (NOT isAdmin()) {
            _view(pageTitle = "Forbidden");
            _event("W", "Caught attempt to access forbidden admin-only page", "", cgi.HTTP_USER_AGENT);
            renderPage(controller="members", action="forbidden");
        }

    }


    private any function developerOnly() hint="Require user to be developer to access actions" {

        if (NOT isDeveloper()) {
            _view(pageTitle = "Forbidden");
            _event("W", "Caught attempt to access forbidden developer-only page", "", cgi.HTTP_USER_AGENT);
            renderPage(controller="members", action="forbidden");
        }

    }


    private any function ajaxOnly() hint="Restrict action only to AJAX requests" {

        if (NOT isAjax()) {
            redirectTo(controller="contacts");
        }

    }


    private any function grantedOnly() hint="Require user to have permission granted to access actions" {

        if (StructKeyExists(variables.securityTokens, "*")) {
            local.token = variables.securityTokens["*"];
        }
        else if (StructKeyExists(variables.securityTokens, params.action)) {
            local.token = variables.securityTokens[params.action];
        }
        else {
            return;
        }

        if (NOT granted(local.token)) {
            _view(pageTitle = "Forbidden");
            _event("W", "Caught attempt to access forbidden granted-only page");
            renderPage(controller="members", action="forbidden");
        }

    }



    /*
     * HELPERS
     */


    private boolean function _error(required string message) hint="Render error page with given error message" {

        _view(renderCustomLayout = false);

        if (view.pageTitle EQ "") {
            _view(pageTitle = "Error");
        }

        flashInsert(error=arguments.message);

        renderPage(controller="members", action="error");

        return false;

    }


    private any function _view() hint="View variables setter decorator" {

        var key = "";
        var page = "";

        for (key in arguments) {

            if (key EQ "headLink") {
                ArrayAppend(view.headLinks, arguments[key]);
            }
            else if (StructKeyExists(view, key)) {
                view[key] = arguments[key];
            }

        }

        // restore the sticky attributes for current page

        if (StructKeyExists(arguments, "stickyAttributes")) {

            lock scope="session" type="readonly" timeout="15" {

                if (NOT StructKeyExists(session, "stickyAttributes")) {
                    session["stickyAttributes"] = {};
                }

                page = request.wheels.params.controller & "." & request.wheels.params.action;

                if (StructKeyExists(session.stickyAttributes, page)) {

                    for (key in session.stickyAttributes[page]) {
                        if (NOT StructKeyExists(params, key)) {
                            params[key] = session.stickyAttributes[page][key];
                        }
                    }

                }

            }

        }


    }


    private any function getModelByKey(
        required string name,
        boolean verifyaccount = true,
        string securitytoken = ""
    ) hint="Check if params.key is valid and try to get the model" {

        var obj = "";

        param name="params.key" default="";

        if (isValid("integer", params.key)) {
            if (StructKeyExists(arguments, "include")) {
                obj = model(arguments.name).findByKey(key=params.key, include=arguments.include);
            }
            else {
                obj = model(arguments.name).findByKey(params.key);
            }
        }

        if (NOT isObject(obj)) {
            return ("Object ###params.key# not found");
        }

        // check if object belongs to current account
        if (arguments.verifyaccount AND obj.accountid NEQ getAccountAttr('id')) {
            return ("Object #arguments.name# ###obj.id# does not belong to current account");
        }

        // check if user has permission to access this object
        if (arguments.securitytoken NEQ "" AND NOT granted(arguments.securitytoken) AND obj.createdBy NEQ getUserAttr("id")) {
            return ("User does not have permission to access object #arguments.name# ###obj.id#");
        }

        return obj;

    }


    private any function getContactByKey() hint="Check if params.contactid is valid and try to get the model" {

        var obj = "";

        param name="params.contactid" default="";

        if (isValid("integer", params.contactid)) {
            obj = model("contact").findByKey(params.contactid);
        }

        if (isObject(obj) AND obj.accountid NEQ getAccountAttr('id')) {
            obj = false;
        }

        return obj;

    }


    private void function initListParams(
        required numeric pagesize,
        required string order,
        string sort = "asc"
    ) hint="Set up standard params for listing" {

        // TODO: implement allowed sort columns check

        param name="params.order" default=arguments.order;

        if (NOT StructKeyExists(params, "sort") OR NOT ListFind("asc,desc", LCase(params.sort))) {
            params.sort = arguments.sort;
        }
        else {
            params.sort = LCase(params.sort);
        }

        params.asort = (params.sort EQ "asc") ? "desc" : "asc";

        if (NOT StructKeyExists(params, "page") OR NOT isNumeric(params.page)) {
            params.page = 1;
        }

        if (NOT StructKeyExists(params, "pagesize") OR NOT ListFind(get("showBySize"), params.pagesize)) {
            params.pagesize = arguments.pagesize;
        }

    }


    private void function checkPrimaryRecord(
        required query dataset,
        required string modelname
    ) hint="Make sure single dataset entry is primary" {

        if (arguments.dataset.recordCount EQ 1 AND arguments.dataset.isPrimary EQ 0) {

            var obj = model(arguments.modelname).findByKey(arguments.dataset.id);

            obj.isPrimary = 1;
            obj.save();

            arguments.dataset.isPrimary = 1;

        }

    }


    private array function getModelWarnings(
        required array warnings,
        required object model
    ) hint="Append given model warnings to the container" {

        var local = {};

        local.warnings = arguments.warnings;
        local.tmpErrors = arguments.model.allErrors();

        for (local.idx = 1; local.idx LTE ArrayLen(local.tmpErrors); local.idx++) {
            ArrayAppend(local.warnings, local.tmpErrors[local.idx]);
        }

        return local.warnings;

    }


    private struct function getModelFields(
        required string container,
        required string keys,
        required string uid
    ) hint="Collect model fields from posted params" {

        var local = {};

        local.fields = {};

        for (local.idx = 1; local.idx LTE ListLen(arguments.keys); local.idx++) {

            local.key = ListGetAt(arguments.keys, local.idx);

            if (local.key EQ "isprimary") {
                local.fields[local.key] = (StructKeyExists(params[arguments.container], "isprimary") AND params[arguments.container].isprimary EQ arguments.uid) ? 1 : 0;
            }
            else if (StructKeyExists(params[arguments.container], local.key) AND StructKeyExists(params[arguments.container][local.key], arguments.uid)) {
                local.fields[local.key] = params[arguments.container][local.key][arguments.uid];
            }

        }

        return local.fields;

    }


    private struct function getCustomPaging(
        required numeric total,
        required numeric page,
        required numeric pagesize
    ) hint="Prepare paging dataset compatible with built-in pagination" {

        var local = {};

        local.paging = {
            "totalRecords" : arguments.total,
            "currentPage" :  arguments.page,
            "totalPages" : Ceiling(arguments.total / arguments.pagesize),
            "queryOffset" : (arguments.page - 1) * arguments.pagesize,
            "queryCount" : arguments.pagesize
        };

        // adjust the query count for the last page
        if (arguments.page*arguments.pagesize GT arguments.total) {
            local.paging.queryCount = arguments.total MOD arguments.pagesize;
        }

        return local.paging;

    }



    private void function syncSettingValues(
        required query tokens,
        required numeric accountid,
        required numeric userid
    ) hint="Create missing values for given setting tokens dataset" {


        for (local.idx=1; local.idx LTE arguments.tokens.recordCount; local.idx++) {

            // try to get value by PK
            local.settingvalue = model("settingvalue").getByCompositeKey(
                settingtokenid = arguments.tokens.id[local.idx],
                accountid = arguments.accountid,
                userid = arguments.userid
            );

            // init the value with defaults if does not exist yet
            if (NOT isObject(local.settingvalue)) {

                local.settingvalue = model("settingvalue").create({
                    settingtokenid : arguments.tokens.id[local.idx],
                    accountid : arguments.accountid,
                    userid : arguments.userid,
                    value : arguments.tokens.defaultvalue[local.idx]
                });

            }

        }

    }


    private array function checkSettingValues(
        required query settings,
        required struct postdata
    ) hint="Validate posted settings by queried dataset" {

        var warnings = [];

        for (local.idx=1; local.idx LTE arguments.settings.recordCount; local.idx++) {

            if (StructKeyExists(arguments.postdata, arguments.settings.id[local.idx])) {

                // override value to use if form displayed again
                arguments.settings.value[local.idx] = arguments.postdata[arguments.settings.id[local.idx]];

                // try to validate the setting value

                local.settingvalue = model("settingvalue").findByKey(arguments.settings.id[local.idx]);

                local.settingvalue.value = arguments.postdata[arguments.settings.id[local.idx]];

                if (NOT local.settingvalue.valid()) {
                    warnings = getModelWarnings(warnings, local.settingvalue);
                    arguments.settings.invalid[local.idx] = "yes";
                }

            }

        }

        return warnings;

    }



    private void function saveSettingValues(
        required query settings,
        required struct postdata
    ) hint="Save posted settings by queried dataset" {

        for (local.idx=1; local.idx LTE arguments.settings.recordCount; local.idx++) {

            if (StructKeyExists(arguments.postdata, arguments.settings.id[local.idx])) {

                local.settingvalue = model("settingvalue").findByKey(arguments.settings.id[local.idx]);

                if (local.settingvalue.update(value = arguments.postdata[settings.id[local.idx]])) {
                    _event("I", "Updated setting value ###local.settingvalue.id# (#local.settingvalue.value#)");
                }
                else {
                    _event("E", "Failed to update setting value ###local.settingvalue.id# (#local.settingvalue.value#)", "", SerializeJSON(local.settingvalue.allErrors()));
                }

            }

        }

    }


    private void function initExportParams() hint="Set up default params for export dataset" {

        // simple defaults

        param name="params.fieldsmode" default="all";
        param name="params.totalRecords" default=0;
        param name="params.order" default="firstname";
        param name="params.sort" default="asc";
        param name="params.pagesize" default=20;
        param name="params.page" default=1;
        param name="params.searchid" default="";

        // a bit smarter check for mode

        if (StructKeyExists(params, "contactsmode") AND ListFind("curpage,filtered,all", params.contactsmode)) {
            params.outputSelected = true;
        }
        else {
            params.contactsmode = "curpage";
        }

        // collect the filtering options of listing page, if any

        lock scope="session" type="readonly" timeout="15" {
            if (StructKeyExists(session, "filters")) {
                for (local.key in session.filters) {
                    params[local.key] = session.filters[local.key];
                }
            }
        }

        // make sure search id is numeric

        params.searchid = (params.searchid EQ "") ? 0 : params.searchid;

    }


    private query function getExportDataset() hint="Read export dataset by options" {

        var local = {};


        // pull the contacts dataset

        if (params.contactsmode EQ "filtered") {

            local.contactsQuery = model("contact").findContactsWithData(
                accountid = getAccountAttr('id'),
                searchid = params.searchid,
                order = "#params.order# #params.sort#"
            );

        }
        else if (params.contactsmode EQ "curpage") {

            // get total contacts count

            if (params.searchid) {
                local.totalRecords = params.totalRecords;
            }
            else {
                local.totalRecords = model("contact").countContactsByAccount(getAccountAttr('id'));
            }

            if (params.page GT Ceiling(local.totalRecords/params.pagesize)) {
                params.page = 1;
            }

            // build paging bar
            paging = getCustomPaging(local.totalRecords, params.page, params.pagesize);


            // query actual data with filtering and paging

            local.contactsQuery = model("contact").findContactsWithData(
                accountid = getAccountAttr('id'),
                searchid = params.searchid,
                order = "#params.order# #params.sort#",
                offset = paging.queryOffset,
                count = paging.queryCount
            );

        }
        else {

            local.contactsQuery = model("contact").findContactsWithData(
                accountid = getAccountAttr('id'),
                order = "#params.order# #params.sort#"
            );

        }


        return local.contactsQuery;


    }


    private void function cacheCountries() hint="Cache countries for search and listing replacements" {

        local.countries = model("country").findAll(where = "iso is not null", order = "name asc");

        request.countries = {};

        for (local.idx=1; local.idx LTE countries.recordCount; local.idx++) {
            request.countries[countries.iso[local.idx]] = countries.name[local.idx];
        }

    }



    private boolean function switchAccountPlan(
        required object activeplan,
        required numeric planid,
        required numeric discountid,
        any price = ""
    ) hint="Replace the account billing plan with history recording" {

        var local = {};


        // find the selected plan

        local.plan = model("plan").findByKey(arguments.planid);

        if (NOT isObject(local.plan) OR NOT local.plan.isactive) {
            return _error("Selected plan not found");
        }

        // create new plan

        local.accountplan = model("accountplan").create({
            accountid : arguments.activeplan.accountid,
            planid : local.plan.id,
            price : isNumeric(arguments.price) ? arguments.price : local.plan.price,
            discountid : arguments.discountid,
            isactive : 1
        });

        if (NOT local.accountplan.hasErrors()) {
            _event("I", "Created plan ###local.accountplan.id# (#arguments.activeplan.plan.name#, #DollarFormat(local.accountplan.price)#) for account ###arguments.activeplan.accountid#");
            // archive current plan
            arguments.activeplan.update(isactive = 0);
        }
        else {
            _event("E", "Failed to create new plan entry for account ###arguments.activeplan.accountid# and plan ###local.plan.id#", "", local.accountplan.allErrors()[1].message);
            return _error("Failed to create new plan entry");
        }


        // archive current account quotas

        local.accountquotas = model("accountquota").findAll(
            where = "accountid=#arguments.activeplan.accountid# AND isactive=1",
            include = "quota"
        );

        for (local.idx=1; local.idx LTE local.accountquotas.recordCount; local.idx++) {

            model("accountquotas").updateByKey(key = local.accountquotas.id[local.idx], isactive = 0);

        }


        // push new plan quotas

        local.quotas = model("quota").findAll(
            where = "planid=#local.plan.id#"
        );

        for (local.idx=1; local.idx LTE local.quotas.recordCount; local.idx++) {

            local.accountquota = model("accountquota").create({
                accountid : arguments.activeplan.accountid,
                quotaid : local.quotas.id[local.idx],
                accountplanid : arguments.activeplan.id,
                quota : local.quotas.quota[local.idx],
                isactive : 1
            });

            if (local.accountquota.hasErrors()) {
                _event("E", "Failed to create quota for billing plan ###local.plan.id# (#local.plan.name#) and feature ###local.quotas.featureid[local.idx]#", "", local.accountquota.allErrors()[1].message);
                return _error("Quotas saving failed: #local.accountquota.allErrors()[1].message#");
            }

        }


        return true;


    }



}