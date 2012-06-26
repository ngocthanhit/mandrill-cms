<cfscript>


    // log session creating
    _text("information", "New session: #session.sessionid#, useragent is #CGI.USER_AGENT#", "sessions");


    // defaults
    session.accountid = get("visitorsAccountId");
    session.userid = get("visitorUserId");


    // check autologin cookie
    if (StructKeyExists(cookie, get("autologinCookie"))) {

        try {
            userid = crypt(cookie[get("autologinCookie")], false);
        }
        catch (any ex) {
            userid = 0;
        }

        if (isNumeric(userid) AND userid GT get("visitorUserId")) {

            user = model("user").findByKey(userid);

            if (isObject(user)) {

                // switch active user
                session.accountid = user.accountid;
                session.userid = user.id;

                // renew last login timestamp
                user.update(visitedAt=Now());

                // renew the cookie
                cookie name=get("autologinCookie") value=crypt(user.id, true) expires=get("autologinPeriod");

                _event("I", "Automatically logged in with remember-me cookie", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", session.accountid, session.userid);

            }
            else {
                // cleanup invalid cookie if user not found
                StructDelete(cookie, get("autologinCookie"));
            }

        }
        else {
            // cleanup invalid cookie if user id is invalid
            StructDelete(cookie, get("autologinCookie"));
        }

    }


</cfscript>