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


    private any function accountOwnerOnly() hint="Require user to be account owner to access actions" {

        if (NOT isAccountOwner()) {
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


    private any function ajaxOnly() hint="Restrict action only to AJAX requests" {

        if (NOT isAjax()) {
            redirectTo(controller="contacts");
        }

    }

    private any function restrictedAccessPosts() hint="restrict guest to access pages" {

        if (isGuest()) {
        _event("W", "Caught attempt to access forbidden member-only page", "", cgi.HTTP_USER_AGENT);
        flashInsert(success="access denied.") ;
        redirectTo(controller="posts");
        }

    }


    private any function restrictedAccessPages() hint="restrict guest to access pages" {

        if(isAuthor() or isGuest()){
        _event("W", "Caught attempt to access forbidden member-only page", "", cgi.HTTP_USER_AGENT);
        flashInsert(success="access denied.") ;
        redirectTo(controller="members");
        }

    }

    private any function restrictedAccessSites() hint="restrict guest to access pages" {

        if(isAuthor() or isGuest() or isEditor()){
        _event("W", "Caught attempt to access forbidden member-only page", "", cgi.HTTP_USER_AGENT);
        flashInsert(success="access denied.") ;
        redirectTo(controller="members");
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
