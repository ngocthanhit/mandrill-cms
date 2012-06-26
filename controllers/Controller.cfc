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


}