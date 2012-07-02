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


    public any function profile() hint="Current user profile" {

        var local = {};

        _view(pageTitle = "Personal Profile", buttonLabel = "Save Profile", renderFlash = false);

        // alias for _user partial re-use
        user = request.user;

        // pull available time zones
        timezones = model("timezone").findAll();

    }


    public any function profileUpdate() hint="Save current user profile" {

        var local = {};

        _view(pageTitle = "Personal Profile", buttonLabel = "Save Profile", renderFlash = false);
        _view(headLink = linkTo(text="Personal Settings", action="settings"));

        // alias for _user partial re-use
        user = request.user;

        param name="params.user" default={};

        // pre-validation actions for password
        if (StructKeyExists(params, "password1") AND params.password1 NEQ "") {
            params.user["password"] = params.password1;
        }
        if (StructKeyExists(params, "password2") AND StructKeyExists(params.user, "password")) {
            params.user["passwordConfirmation"] = params.password2;
        }

        // copy collected attrs into the user model
        user.setProperties(params.user);

        if (user.update()) {
            _event("I", "Updated personal profile information", "Profiles");
            flashInsert(success="Profile saved successfully");
            redirectTo(action="profile")
        }
        else {
            timezones = model("timezone").findAll();
            flashInsert(warning="There are some problems with your submission:");
            renderPage(action="profile");
        }

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
	
	
	
	public any function password() hint="Password reset form and processing" {

        var local = {};

        _view(pageTitle = "Reset Password");

        // display email form by default
        params.phase = "email";


        // if form is submitted -- validate email and send confirmation link

        if (StructKeyExists(params, "email")) {

            try {

                // check if user exists and active

                local.user = model("user").findOneByEmail(Trim(params.email));

                if (NOT isObject(local.user) OR local.user.id EQ get("visitorUserId")) {
                    throw(type="failed");
                }

                // create and send confirmation link

                local.maildata = {
                    firstname : local.user.firstname,
                    email : local.user.email,
                    link : linkTo(route="passwordConfirm", stamp=crypt(local.user.id & "-ma1l", true), onlyPath=false)
                }

                sendEmail(
                    from = get("defaultEmail"),
                    replyto = get("supportEmail"),
                    to = local.user.email,
                    subject = getSetting("ResetPasswordEmailSubject"),
                    template = "/emails/resetpassword",
                    detectMultipart = false,
                    type = "html",
                    layout = "/shared/emailgeneric",
                    maildata = local.maildata
                );

                _event("I", "Sent confirmation link to #local.user.email# (user #local.user.id#)");

                flashInsert(success="Please check you mailbox for further instructions");

            }
            catch (any local.e) {

                if (local.e.type EQ "failed") {
                    _event("W", "Caught failed attempt to restore password by invalid email #params.email#");
                    flashInsert(warning="Email was not found, please re-check and try again");
                }
                else {
                    _event("E", "Caught unexpected failure, email was #params.email#", "", "#local.e.Message# ~ #local.e.Detail#");
                    flashInsert(error="Unexpected failure happened, please try again later");
                }

            }

            redirectTo(action="password");

        }


        // if link is clicked -- validate hash and propose to enter new password

        if (StructKeyExists(params, "stamp")) {

            try {
                local.userid = ListFirst(crypt(params.stamp, false), "-");
            }
            catch (any local.ex) {
                flashInsert(warning="Link is incorrect, please re-check your email");
                local.userid = 0;
            }

            if (local.userid) {

                local.user = model("user").findByKey(local.userid);

                if (NOT isObject(local.user) OR local.user.id EQ get("visitorUserId")) {
                    flashInsert(warning="Link is incorrect, please re-check your email");
                }
                else {
                    // switch to two-password form display
                    params.phase = "passwords";
                }

            }

        }


        // if passwords form submitted -- update account

        if (StructKeyExists(params, "stamp") AND StructKeyExists(params, "password1") AND StructKeyExists(params, "password2")) {

            try {
                local.userid = ListFirst(crypt(params.stamp, false), "-");
            }
            catch (any local.ex) {
                flashInsert(warning="Link is incorrect, please re-check your email");
                local.userid = 0;
            }

            if (local.userid) {

                local.user = model("user").findByKey(local.userid);

                if (NOT isObject(local.user) OR local.user.id EQ get("visitorUserId")) {
                    flashInsert(warning="Link is incorrect, please re-check your email");
                }
                else if (params.password1 EQ "" OR params.password2 EQ "") {
                    flashInsert(warning="Please enter both passwords");
                }
                else if (params.password1 NEQ params.password2) {
                    flashInsert(warning="Password doesn't match the confirmation");
                }
                else {

                    // copy collected attrs into the user model
                    local.user.setProperties({
                        password : params.password1,
                        passwordConfirmation : params.password2
                    });

                    if (local.user.update()) {
                        _event("I", "Successfully set new password", "Profiles", "", local.user.accountid, local.user.id);
                        flashInsert(success="Password updated successfully");
                        redirectTo(action="login");
                    }
                    else {
                        flashInsert(error="Unexpected failure happened, please try again later");
                    }

                }

            }

        }


        renderPage(layout="publiclayout");

    }
	
	
		
	/*
     * Registration routines
     */



	public any function signup() hint="Member registration pre- and post-processing steps" {

        var local = {};

        _view(pageTitle = "Registration");


        if (StructKeyExists(params, "accountname")) {

            // TODO: validation and adding data

            try {

                params.account = {name : params.accountname, status : "active"};

                params.user = {
                    "accesslevel" : get("accessLevelAccountOwner"),
                    "timezoneid" : get("defaultTimeZone"),
                    "dateformat" : get("viewDateFormats")[1].format,
                    "timeformat" : get("viewTimeFormats")[1].format,
                    "isactive" : 1
                };

                // pre-validation actions for password
                if (StructKeyExists(params, "password1") AND params.password1 NEQ "") {
                    params.user["password"] = params.password1;
                }
                if (StructKeyExists(params, "password2") AND StructKeyExists(params.user, "password")) {
                    params.user["passwordConfirmation"] = params.password2;
                }

                WriteDump(params);
                abort;

            }
            catch (any local.e) {

                _event("E", "Caught unexpected signup failure", "", "#local.e.Message# ~ #local.e.Detail#");
                flashInsert(error="Unexpected failure happened, please try again later");

            }

        }


        renderPage(layout="publiclayout");


    }



    public any function forbidden() hint="Warning for unauthorized access event" {

        var local = {};

        _view(pageTitle = "Forbidden");

    }


}