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
    
     /*
     * HELPERS
     */


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

}
