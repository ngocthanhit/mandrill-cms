component extends="Controller" hint="Controller for registered members section" {

	public any function init() hint="Initialize the controller" {
        filters(through="memberOnly", except="login,logout,password,forbidden,signup");
    }

    public any function index() hint="Intercept direct access to /members/" {

        redirectTo(route="home");

    }
    
    
    
    /*
     * Current user features
     */


    public any function dashboard() hint="Current user dashboard" {

        if (NOT isLoggedIn()) {
            redirectTo(action="login");
        }

        var local = {};

        _view(pageTitle = "Dashboard");

    }
    
    
    
    /*
     * Authentication routines
     */



    public any function login() hint="Member login form and process" {

        var local = {};

        _view(pageTitle = "Log In");


        // if form is submitted -- try to log in user

        if (StructKeyExists(params, "email") AND StructKeyExists(params, "password")) {

            try {

                // check if user exists and active

                local.user = model("user").findOneByEmail(Trim(params.email));

                if (NOT isObject(local.user) OR local.user.id EQ get("visitorUserId")) {
                    throw(type="failed");
                }

                if (NOT local.user.isactive) {
                    throw(type="inactive", errorcode="locked");
                }

                // check if parent account is active

                local.account = model("account").findByKey(local.user.accountid);

                if (NOT isObject(local.account)) {
                    throw(type="Application");
                }

                if (local.account.status NEQ "active") {
                    throw(type="inactive", errorcode=local.account.status);
                }

                // check if password matches

                if (Hash(params.password & get("hashingKey"), "SHA-256") NEQ local.user.password) {
                    throw(type="failed");
                }

                // switch active user

                lock scope="session" type="exclusive" timeout="5" {
                    session.accountid = local.account.id;
                    session.userid = local.user.id;
                }

                // renew last visit timestamp

                model('user').updateByKey(key=local.user.id, visitedAt=Now());

                // install/remove autologin cookie, if applicable

                if (StructKeyExists(params, "rememberme")) {
                    cookie name=get("autologinCookie") value=crypt(local.user.id, true) expires=get("autologinPeriod");
                }
                else if (StructKeyExists(cookie, get("autologinCookie"))) {
                    StructDelete(cookie, get("autologinCookie"));
                }

                // save event for logged user
                _event("I", "Successfully logged in", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", local.account.id, local.user.id);

                redirectTo(route="home");

            }
            catch (any local.e) {

                if (local.e.type EQ "inactive") {
                    _event("W", "Caught attempt to log in with email #params.email# while account is #local.e.errorcode#");
                    flashInsert(warning="We apologize, but your account is #local.e.errorcode#");
                }
                else if (local.e.type EQ "failed") {
                    _event("W", "Caught failed attempt to log in with email #params.email#");
                    flashInsert(warning="Invalid login credentials, please try again");
                }
                else {
                    _event("E", "Caught unexpected login failure, email was #params.email#", "", "#local.e.Message# ~ #local.e.Detail#");
                    flashInsert(error="Unexpected login failure, please try again later");
                }

                redirectTo(action="login");

            }

        }


        // see onRequestStart event
        if (StructKeyExists(params, "locked")) {
            flashInsert(warning="Sorry, but your account was recently locked");
            redirectTo(action="login");
        }


        renderPage(layout="publiclayout");

    }
	
	
	public any function logout() hint="Process member logout" {

        if (isLoggedIn()) {

            _event("I", "Successfully logged out", "Sessions", "Session id was #session.sessionid#");

            lock scope="session" type="exclusive" timeout="15" {

                if (StructKeyExists(session, "filters")) {
                    StructDelete(session, "filters");
                }

                session.accountid = get("visitorsAccountId");
                session.userid = get("visitorUserId");

            }

        }


        redirectTo(action="login");

    }


}