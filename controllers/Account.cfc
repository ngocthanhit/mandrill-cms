component extends="Controller" hint="Controller for Account-related actions" {


    _view(sectionTitle = "Your Account");

    public any function init() hint="Initialize the controller" {
        filters(through="accountOwnerOnly");
    }


    public any function index() hint="Intercept direct access to /account/" {

        redirectTo(action="activity");

    }


    public any function activity() hint="Account activity listing" {

        var local = {};

        _view(pageTitle = "Account Activity");

    }


    public any function billing() hint="Account billing dashboard" {

        var local = {};

        _view(pageTitle = "Account Billing");

        // get active plan
        accountplan = model("accountplan").findOne(
            where = "accountid=#getAccountAttr('id')# AND isactive=1",
            include = "plan,discount"
        );

        if (NOT isObject(accountplan)) {
            return _error("Account does not have a plan set");
        }


        // read inactive account plans history
        accountplans = model("accountplan").findAll(
            where = "accountid=#getAccountAttr('id')# AND isactive=0",
            order = "createdat desc",
            include = "plan,discount"
        );


        // read all active features
        features = model("feature").findAll(
            where = "isactive = 1"
        );


        // cache account quotas

        quotasCacheAccount = {};

        for (local.idx=1; local.idx LTE features.recordCount; local.idx++) {

            quotasCacheAccount[features.id[local.idx]] = {
                "current" : getQuotaCurrent(features.token[local.idx]),
                "quota" : getQuotaValue(features.token[local.idx])
            };

        }


        // read active plans and discounts
        plans = model("plan").findAll(
            where = "isactive=1 AND ispublic=1",
            order = "position asc"
        );


        // cache existing quotas

        quotas = model("quota").findAll();

        quotasCachePlan = {};

        for (local.idx=1; local.idx LTE quotas.recordCount; local.idx++) {
            quotasCachePlan[quotas.featureid[local.idx]][quotas.planid[local.idx]] = quotas.quota[local.idx];
        }


    }


    public any function upgrade() hint="Account upgrade options" {

        var local = {};

        _view(pageTitle = "Upgrade Billing Plan", renderFlash = false);
        _view(headLink = linkTo(text="&larr; Back to billing", action="billing"));


        param name="params.planid" default="";
        param name="params.coupon" default="";

        // step requires strict validation
        if (NOT StructKeyExists(params, "step") OR NOT ListFind("options,confirm,payment,completed", params.step)) {
            params.step = "options";
        }

        warnings = [];

        // no plan and discount selected by default
        plan = false;
        discount = false;


        // get active plan
        accountplan = model("accountplan").findOne(
            where = "accountid=#getAccountAttr('id')# AND isactive=1",
            include = "plan,discount"
        );

        if (NOT isObject(accountplan)) {
            return _error("Account does not have a plan set");
        }


        // validate the plan id, if selected

        if (params.planid NEQ "" AND params.planid NEQ accountplan.planid) {

            plan = model("plan").findByKey(params.planid);

            if (NOT isObject(plan) OR NOT plan.isactive OR NOT plan.ispublic) {
                params.planid = "";
                plan = false;
            }

        }


        // read all active features
        features = model("feature").findAll(
            where = "isactive = 1"
        );


        // read active plans and discounts
        plans = model("plan").findAll(
            where = "isactive=1 AND ispublic=1",
            order = "position asc"
        );


        // cache existing quotas

        quotas = model("quota").findAll();

        quotasCachePlan = {};

        for (local.idx=1; local.idx LTE quotas.recordCount; local.idx++) {
            quotasCachePlan[quotas.featureid[local.idx]][quotas.planid[local.idx]] = quotas.quota[local.idx];
        }


        // to second phase of processing if plan is selected

        if (isObject(plan)) {


            // read all active features
            features = model("feature").findAll(
                where = "isactive = 1"
            );


            // cache current quota values against selected plan

            for (local.idx=1; local.idx LTE features.recordCount; local.idx++) {

                if (getQuotaCurrent(features.token[local.idx]) GT quotasCachePlan[features.id[local.idx]][plan.id]) {
                    ArrayAppend(warnings, {"property" : "quota", "message" : "Your account is exceeding quota '#HTMLEditFormat(features.name[local.idx])#' of selected plan."});
                }

            }


        }


        // validate the coupon code if entered

        if (params.coupon NEQ "") {

            // try to find discount by coupon code
            discount = model("discount").findOne(
                where = "coupon='#params.coupon#' AND isactive=1"
            );

            if (NOT isObject(discount)) {
                ArrayAppend(warnings, {"property" : "coupon", "message" : "Entered coupon code is not valid."});
            }
            else if (isObject(plan) AND discount.discount GT 0) {
                // recalculate the plan price
                plan.price = plan.price - plan.price * discount.discount / 100;
            }

        }


        switch (params.step) {
            case "confirm":

                if (NOT isObject(plan)) {
                    ArrayAppend(warnings, {"property" : "planid", "message" : "Please select new plan in order to continue."});
                }
                else {
                    renderPage(action="upgradeConfirm");
                }

                break;
            case "payment":

                if (NOT isObject(plan)) {
                    return _error("Plan was not selected for upgrade.");
                }

                renderPage(action="upgradePayment");

                break;
            case "completed":

                // TODO: this code has to be moved to the Recurly webhook handler

                // replace the account plan

                if (isObject(discount)) {
                    switchAccountPlan(accountplan, plan.id, discount.id, plan.price);
                }
                else {
                    switchAccountPlan(accountplan, plan.id, get("defaultDiscountId"));
                }

                if (flashIsEmpty()) {
                    flashInsert(success="New billing plan was activated successfully. Thank you!");
                }

                redirectTo(action="billing");

                break;
            default:

                if (ArrayLen(warnings) EQ 0) {
                    renderPage(action="upgradeOptions");
                }

        }


        if (ArrayLen(warnings)) {
            flashInsert(warning="There are some problems with your submission:");
            renderPage(action="upgradeOptions");
        }

    }



    /*
     * ACCOUNT SETTINGS
     */


    public any function delete() hint="Account deleting confirmation and action" {

        var local = {};

        _view(pageTitle = "Delete Account");

        // get clone of current account object
        account = model("account").findByKey(getAccountAttr("id"));

        if (StructKeyExists(params, "confirm")) {

            _event("I", "Account manager ###getUserAttr('id')# (#getUserAttr('email')#) requested account ###account.id# (#account.name#) deleting");

            // notify the admin

            param name="params.comments" default="";

            local.maildata = {
                name : "#account.name# (###account.id#)",
                email : "#getUserAttr('email')# (#getUserAttr('firstname')# #getUserAttr('lastname')#)",
                comments : params.comments
            }

            sendEmail(
                from = get("defaultEmail"),
                to = get("supportEmail"),
                cc = get("defaultEmail"),
                subject = get("accountDeletingEmailSubject") & account.name,
                template = "/emails/accountdeleted",
                detectMultipart = false,
                type = "html",
                layout = "/shared/emailadmin",
                maildata = local.maildata
            );

            // cleanup the storage

            local.storagePath = ExpandPath(get("filePath"))  & "/" & account.id;

            if (DirectoryExists(local.storagePath)) {
                DirectoryDelete(local.storagePath, true);
            }


            // delete the account

            account.delete();

            // log out current user

            lock scope="session" type="exclusive" timeout="15" {

                if (StructKeyExists(session, "filters")) {
                    StructDelete(session, "filters");
                }

                session.accountid = get("visitorsAccountId");
                session.userid = get("visitorUserId");

            }

            // relocate to login screen
            redirectTo(controller="members", action="login");

        }


    }
    
    
    
    /*
     * TEAM MEMBERS
     */


    public any function members() hint="Team members listing" {

        var local = {};

        _view(pageTitle = "Team Members", renderShowBy = true, stickyAttributes = "pagesize,sort,order");
        _view(headLink = linkTo(text="Add team member", action="memberAdd"));

        initListParams(20, "email");

        users = model("users").findAll(
            where = "accountid = #getAccountAttr('id')#",
            page = params.page,
            perPage = params.pagesize,
            order = "#params.order# #params.sort#"
        );

    }


    public any function memberAdd() hint="New team member form" {

        var local = {};

        _view(pageTitle = "Add Team Member", buttonLabel = "Create Member");
        _view(headLink = linkTo(text="Back to team members &uarr;", action="members"));

        user = model("user").new();

        // handy defaults
        user.timezoneid = get("defaultTimeZone");
        user.isactive = 1;
        user.accessLevel = get("accessLevelGuest");
        user.accountid = getAccountAttr("id");

        // pull available time zones
        timezones = model("timezone").findAll();

    }


    public any function memberCreate() hint="Create new team member" {

        var local = {};

        _view(pageTitle = "Add Team Member", buttonLabel = "Create Member", renderFlash = false);
        _view(headLink = linkTo(text="Back to team members &uarr;", action="members"));

        if (getQuotaLeft("TeamMembers") LTE 0) {
            return _error(ReplaceNoCase(get("quotaReachedMessage"), "{FEATURE}", "team members") & linkTo(text="upgrading", controller="account", action="upgrade"));
        }

        param name="params.user" default={};
        param name="params.user.accessLevel" default=1;

        // pre-validation actions for password

        if (StructKeyExists(params, "password1") AND params.password1 NEQ "") {
            params.user["password"] = params.password1;
        }
        if (StructKeyExists(params, "password2") AND StructKeyExists(params.user, "password")) {
            params.user["passwordConfirmation"] = params.password2;
        }

        // make sure they wont abuse access level and account

        if (NOT ListFind("1,2,3,4", params.user.accessLevel)) {
            params.user.accessLevel = 1;
        }

        params.user.accountid = getAccountAttr("id");


        user = model("user").create(params.user);

        if (NOT user.hasErrors()) {

            _event("I", "Created team member ###user.id# (#user.email#)", "Team Members");
            flashInsert(success="Team member '#user.email#' created successfully");

            redirectTo(action="members");

        }
        else {

            // pull available time zones
            timezones = model("timezone").findAll();

            flashInsert(warning="There are some problems with your submission:");

            renderPage(action="memberAdd");

        }

    }


    public any function memberEdit() hint="Existing team member form" {

        var local = {};

        _view(pageTitle = "Edit Team Member", buttonLabel = "Save Member", renderFlash = false);
        _view(headLink = linkTo(text="Back to team members &uarr;", action="members"));

        user = getModelByKey("user");

        if (NOT isObject(user)) {
            return _error("Team member was not found");
        }

        // pull available time zones
        timezones = model("timezone").findAll();

    }


    public any function memberUpdate() hint="Update existing user" {

        var local = {};

        _view(pageTitle = "Edit Team Member", buttonLabel = "Save Member", renderFlash = false);
        _view(headLink = linkTo(text="Back to team members &uarr;", action="members"));

        user = getModelByKey("user");

        if (NOT isObject(user)) {
            return _error("Team member was not found");
        }

        param name="params.user" default={};

        // pre-validation actions for password
        if (StructKeyExists(params, "password1") AND params.password1 NEQ "") {
            params.user["password"] = params.password1;
        }
        if (StructKeyExists(params, "password2") AND StructKeyExists(params.user, "password")) {
            params.user["passwordConfirmation"] = params.password2;
        }

        user.setProperties(params.user);

        if (user.save()) {
            _event("I", "Updated team member ###user.id# (#user.email#)", "Team Members");
            flashInsert(success="Team member '#user.email#' updated successfully");
            redirectTo(action="members");
        }
        else {

            // pull available time zones
            timezones = model("timezone").findAll();

            flashInsert(warning="There are some problems with your submission:");

            renderPage(action="memberEdit");

        }

    }


    public any function memberDelete() hint="Delete team member" {

        var local = {};

        _view(pageTitle = "Delete Team Member");
        _view(headLink = linkTo(text="Back to team members &uarr;", action="members"));

        user = getModelByKey("user");

        if (NOT isObject(user)) {
            return _error("Team member was not found");
        }

        if (user.id EQ getUserAttr("id")) {
            return _error("Sorry, you cannot delete yourself");
        }

        if (user.delete()) {
            _event("I", "Deleted team member ###user.id# (#user.email#)", "Team Members");
            flashInsert(success="Team member '#user.email#' deleted successfully");
            redirectTo(action="members");
        }
        else {
            _event("E", "Failed to delete the user ###user.id# (#user.email#)");
            _error("Team member deleting failed");
        }

    }
    
     
}