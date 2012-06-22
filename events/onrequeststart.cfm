<cfscript>

    lock scope="session" type="exclusive" timeout="15" {

        // pull the current account/user objects by PKs stored in session
        request.account = model("account").findByKey(session.accountid);
        request.user = model("user").findByKey(session.userid);

        if (NOT isObject(request.account) OR NOT isObject(request.user)) {

            // make sure valid objects pulled, and fall to the visitors if needed

            session.accountid = get("visitorsAccountId");
            session.userid = get("visitorUserId");

            request.account = model("account").findByKey(get("visitorsAccountId"));
            request.user = model("user").findByKey(get("visitorUserId"));

        }
        else if (request.account.status EQ "locked") {

            // this is special check to catch active sessions of recently locked account

            if (StructKeyExists(session, "filters")) {
                StructDelete(session, "filters");
            }

            session.accountid = get("visitorsAccountId");
            session.userid = get("visitorUserId");

            redirectTo(controller="members", action="login", params="locked=yes");

        }

    }

    // container for view data and settings
    request.view = {
        "pageTitle" : "",
        "pageTitleAppend" : "",
        "sectionTitle" : "",
        "buttonLabel" : "",
        "headLinks" : [],
        "renderCustomLayout" : false,
        "renderFlash" : true,
        "renderShowBy" : false,
        "showByKey" : "",
        "showByController" : "",
        "stickyAttributes" : ""
    };

</cfscript>