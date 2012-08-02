<cfscript>



    /*
     * ACCOUNTS & USERS
     */


    public any function accounts() hint="Registered accounts listing" {

        var local = {};

        _view(pageTitle = "Browse Accounts", renderShowBy = true, stickyAttributes = "pagesize,sort,order");
        _view(headLink = linkTo(text="Add account", action="accountAdd"));

        initListParams(20, "name");

        accounts = model("account").findAll(
            where="id != #get('visitorsAccountId')#",
            page=params.page,
            perPage=params.pagesize,
            order="#params.order# #params.sort#"
        );

    }


    public any function accountAdd() hint="New account form" {

        var local = {};

        _view(pageTitle = "Add Account");
        _view(buttonLabel = "Create Account");
        _view(headLink = linkTo(text="Back to accounts &uarr;", action="accounts"));

        // new objects for account

        account = model("account").new({status : "active"});

        accountplan = model("accountplan").new();

        // read active plans and discounts

        plans = model("plan").findAll(
            where = "isactive=1",
            order = "position asc"
        );

        discounts = model("discount").findAll(
            where = "isactive=1",
            order = "name asc"
        );

    }


    public any function accountCreate() hint="Create new account" {

        var local = {};

        _view(pageTitle = "Add Account");
        _view(buttonLabel = "Create Account");
        _view(headLink = linkTo(text="Back to accounts &uarr;", action="accounts"));
        _view(renderFlash = false);

        param name="params.account" default={};
        param name="params.accountplan.planid" default="";
        param name="params.accountplan.discountid" default="";

        // validate the plan

        local.plan = model("plan").findByKey(params.accountplan.planid);

        if (NOT isObject(local.plan) OR NOT local.plan.isactive) {
            return _error("Selected plan not found");
        }


        // validate the discount

        local.discount = model("discount").findByKey(params.accountplan.discountid);

        if (NOT isObject(local.discount) OR NOT local.discount.isactive) {
            return _error("Selected discount not found");
        }
        else if (local.discount.discount GT 0) {

            // recalculate the price if discount is selected
            local.plan.price = local.plan.price - local.plan.price * local.discount.discount / 100;

        }

        // try to create the account

        account = model("account").create(params.account);

        if (NOT account.hasErrors()) {

            // create the account plan

            local.accountplan = model("accountplan").create({
                accountid : account.id,
                planid : local.plan.id,
                discountid : local.discount.id,
                price : local.plan.price,
                isactive : 1
            });

            _event("I", "Created account ###account.id# (#account.name#)");

            flashInsert(success="Account was created successfully, please create first account owner now");

            redirectTo(action="userAdd", key=account.id);

        }
        else {

            accountplan = model("accountplan").new();

            // read active plans and discounts

            plans = model("plan").findAll(
                where = "isactive=1",
                order = "position asc"
            );

            discounts = model("discount").findAll(
                where = "isactive=1",
                order = "name asc"
            );

            flashInsert(warning="There are some problems with your submission:");
            renderPage(action="accountAdd");

        }

    }


    public any function accountEdit() hint="Existing account form" {

        var local = {};

        _view(pageTitle = "Edit Account");
        _view(buttonLabel = "Save Account");
        _view(headLink = linkTo(text="Back to accounts &uarr;", action="accounts"));
        _view(renderFlash = false);

        account = getModelByKey("account", false);

        if (NOT isObject(account)) {
            _event("E", "Invalid account record #params.key# requested");
            _error("Account was not found");
        }
        else {
            _view(pageTitleAppend = "###params.key#");
            account.expirationDate = DateFormat(account.expirationDate, get("defaultDateFormat"));
        }

    }


    public any function accountUpdate() hint="Update existing account" {

        var local = {};

        _view(pageTitle = "Edit Account");
        _view(buttonLabel = "Save Account");
        _view(headLink = linkTo(text="Back to accounts &uarr;", action="accounts"));
        _view(renderFlash = false);

        account = getModelByKey("account", false);

        if (NOT isObject(account)) {
            _event("E", "Invalid account record #params.key# requested");
            _error("Account was not found");
        }
        else {

            param name="params.account" default={};
            account.setProperties(params.account);

            if (account.save()) {
                _event("I", "Updated account ###account.id# (#account.name#)");
                flashInsert(success="Account was updated successfully");
                redirectTo(action="accounts");
            }
            else {
                _view(pageTitleAppend = "###params.key#");
                account.expirationDate = DateFormat(account.expirationDate, get("defaultDateFormat"));
                flashInsert(warning="There are some problems with your submission:");
                renderPage(action="accountEdit");
            }

        }

    }


    public any function accountDelete() hint="Delete existing account" {

        var local = {};

        _view(pageTitle = "Delete Account");
        _view(headLink = linkTo(text="Back to accounts &uarr;", action="accounts"));

        account = getModelByKey("account", false);

        if (NOT isObject(account)) {
            _event("E", "Invalid account record #params.key# requested");
            _error("Account was not found");
        }
        else if (account.id LTE get("adminsAccountId")) {
            _event("E", "Tried to delete internal account ###account.id# (#account.name#)");
            _error("This account can't be deleted");
        }
        else {

            if (account.delete()) {
                _event("I", "Deleted account ###account.id# (#account.name#)");
                flashInsert(success="Account was deleted successfully");
                redirectTo(action="accounts");
            }
            else {
                _event("E", "Failed to delete the account ###account.id# (#account.name#)");
                _error("Account deleting failed");
            }

        }

    }


    public any function accountUsers() hint="List current account users" {

        var local = {};

        _view(pageTitle = "Browse Users of Account", renderShowBy = true, showByKey = params.key, stickyAttributes = "pagesize,sort,order");

        account = getModelByKey("account", false);

        if (NOT isObject(account)) {
            _event("E", "Invalid account record #params.key# requested");
            _error("Account was not found");
        }
        else {

            _view(pageTitleAppend = "&laquo;#account.name#&raquo;");
            _view(headLink = linkTo(text="Back to accounts &uarr;", action="accounts"));
            _view(headLink = linkTo(text="Add user", key=account.id, action="user-add"));

            initListParams(20, "email");

            users = model("users").findAll(
                where="accountid = #account.id#",
                page=params.page,
                perPage=params.pagesize,
                order="#params.order# #params.sort#"
            );

        }

    }


    public any function userAdd() hint="New user form" {

        var local = {};

        _view(pageTitle = "Add User for Account", buttonLabel = "Create User", renderFlash = false);

        account = getModelByKey("account", false);

        if (NOT isObject(account)) {
            _event("E", "Invalid account record #params.key# requested");
            _error("Parent account was not found");
        }
        else {

            _view(pageTitleAppend = "&laquo;#account.name#&raquo;");
            _view(headLink = linkTo(text="Back to users &uarr;", key=account.id, action="account-users"));

            user = model("user").new();

            // handy defaults
            user.timezoneid = get("defaultTimeZone");
            user.isactive = 1;
            user.accessLevel = get("accessLevelGuest");
            user.accountid = account.id;

            // pull available time zones
            timezones = model("timezone").findAll();

        }

    }


    public any function userCreate() hint="Create new user" {

        var local = {};

        _view(pageTitle = "Add User for Account", buttonLabel = "Create User", renderFlash = false);

        account = getModelByKey("account", false);

        if (NOT isObject(account)) {
            _event("E", "Invalid account record #params.key# requested");
            _error("Parent account was not found");
        }
        else {

            param name="params.user" default={};

            // pre-validation actions for password
            if (StructKeyExists(params, "password1") AND params.password1 NEQ "") {
                params.user["password"] = params.password1;
            }
            if (StructKeyExists(params, "password2") AND StructKeyExists(params.user, "password")) {
                params.user["passwordConfirmation"] = params.password2;
            }

            params.user.accountid = account.id;
            user = model("user").create(params.user);

            if (NOT user.hasErrors()) {
                _event("I", "Created user ###user.id# (#user.email#)");
                flashInsert(success="User was created successfully");
                redirectTo(action="account-users", key=account.id);
            }
            else {

                _view(pageTitleAppend = "&laquo;#account.name#&raquo;");
                _view(headLink = linkTo(text="Back to users &uarr;", key=account.id, action="account-users"));

                // pull available time zones
                timezones = model("timezone").findAll();

                flashInsert(warning="There are some problems with your submission:");
                renderPage(action="userAdd");

            }

        }

    }


    public any function userEdit() hint="Existing user form" {

        var local = {};

        _view(pageTitle = "Edit User");
        _view(buttonLabel = "Save User");
        _view(renderFlash = false);

        user = getModelByKey("user", false);

        if (NOT isObject(user)) {
            _event("E", "Invalid user record #params.key# requested");
            _error("User was not found");
        }
        else {

            _view(headLink = linkTo(text="Back to users &uarr;", key=user.accountid, action="account-users"));

            // pull available time zones
            timezones = model("timezone").findAll();

        }

    }


    public any function userUpdate() hint="Update existing user" {

        var local = {};

        _view(pageTitle = "Edit User");
        _view(buttonLabel = "Save User");
        _view(renderFlash = false);

        user = getModelByKey("user", false);

        if (NOT isObject(user)) {
            _event("E", "Invalid user record #params.key# requested");
            _error("User was not found");
        }
        else {

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
                _event("I", "Updated user ###user.id# (#user.email#)");
                flashInsert(success="User was updated successfully");
                redirectTo(action="account-users", key=user.accountid);
            }
            else {

                _view(headLink = linkTo(text="Back to users &uarr;", key=user.accountid, action="account-users"));

                // pull available time zones
                timezones = model("timezone").findAll();

                flashInsert(warning="There are some problems with your submission:");
                renderPage(action="userEdit");

            }

        }

    }


    public any function userDelete() hint="Delete existing user" {

        var local = {};

        _view(pageTitle = "Delete User", renderFlash = false);

        user = getModelByKey("user", false);

        if (NOT isObject(user)) {
            _event("E", "Invalid user record #params.key# requested");
            _error("User was not found");
        }
        else if (user.id EQ get("visitorUserId")) {
            _event("E", "Tried to delete Visitor");
            _error("This user can't be deleted");
        }
        else {

            if (user.delete()) {
                _event("I", "Deleted user ###user.id# (#user.email#)");
                flashInsert(success="User was deleted successfully");
                redirectTo(action="account-users", key=user.accountid);
            }
            else {
                _view(headLink = linkTo(text="Back to users &uarr;", key=user.accountid, action="account-users"));
                _event("E", "Failed to delete the user ###user.id# (#user.email#)");
                _error("User deleting failed");
            }


        }

    }


</cfscript>