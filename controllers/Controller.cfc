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
    
    private any functrion restrictedAccessPosts() hint="restrict guest to access pages" {

        if (isGuest()) {
        flashInsert(success="access denied.") ;
        redirectTo(controller="posts");
        }

	}
    
    
    private any functrion restrictedAccessPages() hint="restrict guest to access pages" {

        if(isAuthor() or isGuest())
        flashInsert(success="access denied.") ;
        redirectTo(controller="pages");
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