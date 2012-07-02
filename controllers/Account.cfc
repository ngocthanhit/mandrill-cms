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