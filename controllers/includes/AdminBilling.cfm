<cfscript>



    /*
     * BILLING SETTINGS
     */



    public any function billing() hint="Billing settings options listing" {

        var local = {};

        _view(pageTitle = "Billing Settings");

    }



    public any function features() hint="Billing features listing" {

        var local = {};

        _view(pageTitle = "Billed Features", renderShowBy = true, stickyAttributes = "pagesize,sort,order");
        _view(headLink = linkTo(text="Back to billing home &uarr;", action="billing"));


        initListParams(20, "position");

        // read all the features

        features = model("feature").findAll(
            page = params.page,
            perPage = params.pagesize,
            order = "#params.order# #params.sort#"
        );

    }


    public any function featureEdit() hint="Feature settings form" {

        var local = {};

        _view(pageTitle = "Edit Feature", renderFlash = false);
        _view(headLink = linkTo(text="Back to features &uarr;", action="features"));

        feature = getModelByKey("feature", false);

        if (NOT isObject(feature)) {
            return _error("Feature was not found");
        }

        _view(pageTitleAppend = "&laquo;#feature.name#&raquo;");

    }


    public any function featureUpdate() hint="Update feature settings" {

        var local = {};

        _view(pageTitle = "Edit Feature", renderFlash = false);
        _view(headLink = linkTo(text="Back to features &uarr;", action="features"));

        feature = getModelByKey("feature", false);

        if (NOT isObject(feature)) {
            return _error("Feature was not found");
        }

        _view(pageTitleAppend = "&laquo;#feature.name#&raquo;");

        param name="params.feature" default={};

        feature.setProperties(params.feature);

        if (feature.save()) {
            _event("I", "Updated feature ###feature.id# (#feature.name#)");
            flashInsert(success="Feature '#feature.name#' was updated successfully");
            redirectTo(action="features");
        }
        else {
            flashInsert(warning="There are some problems with your submission:");
            renderPage(action="featureEdit");
        }

    }



    public any function discounts() hint="Billing discounts listing" {

        var local = {};

        _view(pageTitle = "Discounts", renderShowBy = true, stickyAttributes = "pagesize,sort,order");
        _view(headLink = linkTo(text="Back to billing home &uarr;", action="billing"));
        _view(headLink = linkTo(text="Add discount", action="discountAdd"));


        initListParams(20, "name");

        // read all the discounts

        discounts = model("discount").findAll(
            page = params.page,
            perPage = params.pagesize,
            order = "#params.order# #params.sort#"
        );

    }


    public any function discountAdd() hint="New discount form" {

        var local = {};

        _view(pageTitle = "Add Discount", buttonLabel = "Create Discount", renderFlash = false);
        _view(headLink = linkTo(text="Back to discounts &uarr;", action="discounts"));

        discount = model("discount").new({isactive = 1});

    }


    public any function discountCreate() hint="Create new discount" {

        var local = {};

        _view(pageTitle = "Add Discount", buttonLabel = "Create Discount", renderFlash = false);
        _view(headLink = linkTo(text="Back to discounts &uarr;", action="discounts"));

        param name="params.discount" default={};

        discount = model("discount").create(params.discount);

        if (NOT discount.hasErrors()) {
            _event("I", "Created discount ###discount.id# (#discount.name#)");
            flashInsert(success="The discount '#discount.name#' was created successfully");
            redirectTo(action="discounts");
        }
        else {
            flashInsert(warning="There are some problems with your submission:");
            renderPage(action="discountAdd");
        }

    }


    public any function discountEdit() hint="Existing discount form" {

        var local = {};

        _view(pageTitle = "Edit Discount", buttonLabel = "Save Discount", renderFlash = false);
        _view(headLink = linkTo(text="Back to discounts &uarr;", action="discounts"));

        discount = getModelByKey("discount", false);

        if (NOT isObject(discount)) {
            return _error("Discount was not found");
        }

        _view(pageTitleAppend = "&laquo;#discount.name#&raquo;");
        discount.expirationDate = DateFormat(discount.expirationDate, get("defaultDateFormat"));

    }


    public any function discountUpdate() hint="Save existing discount" {

        var local = {};

        _view(pageTitle = "Edit Discount", buttonLabel = "Save Discount", renderFlash = false);
        _view(headLink = linkTo(text="Back to discounts &uarr;", action="discounts"));

        discount = getModelByKey("discount", false);

        if (NOT isObject(discount)) {
            return _error("Discount was not found");
        }

        _view(pageTitleAppend = "&laquo;#discount.name#&raquo;");

        param name="params.discount" default={};

        discount.setProperties(params.discount);

        if (discount.save()) {
            _event("I", "Updated discount ###discount.id# (#discount.name#)");
            flashInsert(success="Discount '#discount.name#' was updated successfully");
            redirectTo(action="discounts");
        }
        else {
            flashInsert(warning="There are some problems with your submission:");
            renderPage(action="discountEdit");
        }

    }


    public any function discountApply() hint="Apply discount to multiple accounts in batch - form" {

        var local = {};

        _view(pageTitle = "Apply Discount");
        _view(headLink = linkTo(text="Back to discounts &uarr;", action="discounts"));

        discount = getModelByKey("discount", false);

        if (NOT isObject(discount)) {
            return _error("Discount was not found");
        }

        _view(pageTitleAppend = "&laquo;#discount.name#&raquo;");

        // pull active accounts
        // think of some filtering later

        accounts = model("account").findAllWithBilling(
            status = "active",
            order = "name asc"
        );

    }


    public any function discountApplyProceed() hint="Apply discount to multiple accounts in batch - proceed" {

        var local = {};

        _view(pageTitle = "Apply Discount");
        _view(headLink = linkTo(text="Back to discounts &uarr;", action="discounts"));

        discount = getModelByKey("discount", false);

        if (NOT isObject(discount)) {
            return _error("Discount was not found");
        }

        param name="params.accounts" default=[];

        for (local.idx=1; local.idx LTE ArrayLen(params.accounts); local.idx++) {

            if (NOT isNumeric(params.accounts[local.idx])) {
                continue;
            }

            // get the plan
            local.accountplan = model("accountplan").findOne(
                where = "accountid=#params.accounts[local.idx]# AND isactive=1",
                include = "plan"
            );

            // recalculate the price
            local.price = local.accountplan.plan.price - local.accountplan.plan.price * discount.discount / 100;

            // skip if discount is the same or lower than current
            if (local.accountplan.discountid NEQ discount.id AND local.accountplan.price GT local.price) {

                // clone current plan with adjusted price
                switchAccountPlan(local.accountplan, local.accountplan.planid, discount.id, local.price);

                // TODO: queue Recurly subscription update (queue API request)

            }

        }

        flashInsert(success="Discount was applied to selected accounts");
        redirectTo(action="discountApply", key=params.key);

    }


    public any function discountDelete() hint="Delete existing discount" {

        var local = {};

        _view(pageTitle = "Delete Discount");
        _view(headLink = linkTo(text="Back to discounts &uarr;", action="discounts"));

        discount = getModelByKey("discount", false);

        if (NOT isObject(discount)) {
            return _error("Discount was not found");
        }
        else if (discount.isUsed()) {
            return _error("This discount is in use and cannot be deleted");
        }

        if (discount.delete()) {
            _event("I", "Deleted discount ###discount.id# (#discount.name#)");
            flashInsert(success="Discount '#discount.name#' was deleted successfully");
            redirectTo(action="discounts");
        }
        else {
            _event("E", "Failed to delete the discount ###discount.id# (#discount.name#)");
            return _error("Discount deleting failed");
        }

    }




    public any function plans() hint="Billing plans listing" {

        var local = {};

        _view(pageTitle = "Billing Plans", renderShowBy = true, stickyAttributes = "pagesize,sort,order");
        _view(headLink = linkTo(text="Back to billing home &uarr;", action="billing"));
        _view(headLink = linkTo(text="Add plan", action="planAdd"));

        initListParams(20, "position");

        // read all the plans

        plans = model("plan").findAll(
            page = params.page,
            perPage = params.pagesize,
            order = "#params.order# #params.sort#"
        );

    }


    public any function planAdd() hint="New billing plan form" {

        var local = {};

        _view(pageTitle = "Add Plan", buttonLabel = "Create Plan", renderFlash = false);
        _view(headLink = linkTo(text="Back to plans &uarr;", action="plans"));

        plan = model("plan").new({isactive = 1, ispublic = 1});

    }


    public any function planCreate() hint="Create new billing plan" {

        var local = {};

        _view(pageTitle = "Add Plan", buttonLabel = "Create Plan", renderFlash = false);
        _view(headLink = linkTo(text="Back to plans &uarr;", action="plans"));

        param name="params.plan" default={};

        plan = model("plan").create(params.plan);

        if (NOT plan.hasErrors()) {
            _event("I", "Created billing plan ###plan.id# (#plan.name#)");
            flashInsert(success="The billing plan '#plan.name#' was created successfully, please set up default quotas to start using it");
            redirectTo(action="planQuotas", key=plan.id);
        }
        else {
            flashInsert(warning="There are some problems with your submission:");
            renderPage(action="planAdd");
        }

    }


    public any function planEdit() hint="Existing billing plan form" {

        var local = {};

        _view(pageTitle = "Edit Plan", buttonLabel = "Save Plan", renderFlash = false);
        _view(headLink = linkTo(text="Back to plans &uarr;", action="plans"));

        plan = getModelByKey("plan", false);

        if (NOT isObject(plan)) {
            return _error("Plan was not found");
        }

        _view(pageTitleAppend = "&laquo;#plan.name#&raquo;");

    }


    public any function planUpdate() hint="Save existing billing plan" {

        var local = {};

        _view(pageTitle = "Edit Plan", buttonLabel = "Save Plan", renderFlash = false);
        _view(headLink = linkTo(text="Back to plans &uarr;", action="plans"));

        plan = getModelByKey("plan", false);

        if (NOT isObject(plan)) {
            return _error("Plan was not found");
        }

        _view(pageTitleAppend = "&laquo;#plan.name#&raquo;");

        param name="params.plan" default={};

        plan.setProperties(params.plan);

        if (plan.save()) {
            _event("I", "Updated plan ###plan.id# (#plan.name#)");
            flashInsert(success="Plan '#plan.name#' was updated successfully");
            redirectTo(action="plans");
        }
        else {
            flashInsert(warning="There are some problems with your submission:");
            renderPage(action="planEdit");
        }

    }


    public any function planDelete() hint="Delete existing billing plan" {

        var local = {};

        _view(pageTitle = "Delete Plan");
        _view(headLink = linkTo(text="Back to plans &uarr;", action="plans"));

        plan = getModelByKey("plan", false);

        if (NOT isObject(plan)) {
            return _error("Plan was not found");
        }
        else if (plan.isUsed()) {
            return _error("This plan is in use and cannot be deleted");
        }

        if (plan.delete()) {
            _event("I", "Deleted plan ###plan.id# (#plan.name#)");
            flashInsert(success="Plan '#plan.name#' was deleted successfully");
            redirectTo(action="plans");
        }
        else {
            _event("E", "Failed to delete the billing plan ###plan.id# (#plan.name#)");
            return _error("Plan deleting failed");
        }

    }


    public any function planQuotas() hint="Billing plan quotas form" {

        var local = {};

        _view(pageTitle = "Quotas for Plan");
        _view(headLink = linkTo(text="Back to plans &uarr;", action="plans"));


        plan = getModelByKey("plan", false);

        if (NOT isObject(plan)) {
            return _error("Plan was not found");
        }

        _view(pageTitleAppend = "&laquo;#plan.name#&raquo;");


        // read all active features

        features = model("feature").findAll(
            where = "isactive = 1"
        );


        // cache existing quotas

        quotas = model("quota").findAll(
            where = "planid = #plan.id#"
        );

        quotasCache = {};

        for (local.idx=1; local.idx LTE quotas.recordCount; local.idx++) {
            quotasCache[quotas.featureid[local.idx]] = quotas.quota[local.idx];
        }

    }


    public any function planQuotasUpdate() hint="Save billing plan quotas" {

        var local = {};

        _view(pageTitle = "Quotas for Plan");
        _view(headLink = linkTo(text="Back to plans &uarr;", action="plans"));


        plan = getModelByKey("plan", false);

        if (NOT isObject(plan)) {
            return _error("Plan was not found");
        }

        _view(pageTitleAppend = "&laquo;#plan.name#&raquo;");


        // read all active features

        features = model("feature").findAll(
            where = "isactive = 1"
        );


        param name="params.quotas" default={};


        // search quota value for each feature

        for (local.idx=1; local.idx LTE features.recordCount; local.idx++) {

            local.fid = features.id[local.idx];

            if (StructKeyExists(params.quotas, local.fid)
                AND isValid("integer", params.quotas[local.fid])
                AND params.quotas[local.fid] GT 0) {

                // check if quota already registered

                local.quota = model("quota").findOne(
                    where = "planid = #plan.id# AND featureid = #local.fid#"
                );

                if (isObject(local.quota)) {

                    local.quota.update(quota = params.quotas[local.fid]);

                    _event("I", "Updated quota ###local.quota.id# for plan ###plan.id# (#plan.name#)");

                    // toggle plan update event
                    plan.save();

                }
                else {

                    local.quota = model("quota").create({
                       planid : plan.id,
                       featureid : local.fid,
                       quota : params.quotas[local.fid]
                    });

                    if (NOT local.quota.hasErrors()) {
                        _event("I", "Created quota ###local.quota.id# for plan ###plan.id# (#plan.name#) and feature ###local.fid#");
                    }
                    else {
                        _event("E", "Failed to create quota for billing plan ###plan.id# (#plan.name#) and feature ###local.fid#", "", local.quota.allErrors()[1].message);
                        return _error("Quotas saving failed: #local.quota.allErrors()[1].message#");
                    }

                }

            }
            else {
                flashInsert(warning="Some quota values were skipped as invalid");
            }

        }


        flashInsert(success="Quotas for plan '#plan.name#' were saved successfully");
        redirectTo(action="planQuotas", key=params.key);

    }





    public any function accountBilling() hint="List account billing options" {

        var local = {};

        _view(pageTitle = "Billing of Account");

        account = getModelByKey("account", false);

        if (NOT isObject(account)) {
            return _error("Account was not found");
        }

        _view(pageTitleAppend = "&laquo;#account.name#&raquo;");
        _view(headLink = linkTo(text="Back to accounts &uarr;", action="accounts"));


        // get active plan
        accountplan = model("accountplan").findOne(
            where = "accountid=#account.id# AND isactive=1",
            include = "plan,discount"
        );

        if (NOT isObject(accountplan)) {
            return _error("Account does not have a plan set");
        }


        // read all active features
        features = model("feature").findAll(
            where = "isactive = 1"
        );


        // cache account quotas

        quotasCacheAccount = {};

        for (local.idx=1; local.idx LTE features.recordCount; local.idx++) {

            quotasCacheAccount[features.id[local.idx]] = {
                "current" : getQuotaCurrent(features.token[local.idx], account.id),
                "quota" : getQuotaValue(features.token[local.idx], account.id)
            };

        }


    }


    public any function accountQuotasEdit() hint="Account quotas form" {

        var local = {};


        _view(pageTitle = "Quotas of Account");

        account = getModelByKey("account", false);

        if (NOT isObject(account)) {
            return _error("Account was not found");
        }

        _view(pageTitleAppend = "&laquo;#account.name#&raquo;");
        _view(headLink = linkTo(text="&larr; Back to account billing", action="accountBilling", key=account.id));
        _view(headLink = linkTo(text="Back to accounts &uarr;", action="accounts"));


        // get active plan
        accountplan = model("accountplan").findOne(
            where = "accountid=#account.id# AND isactive=1",
            include = "plan"
        );

        if (NOT isObject(accountplan)) {
            return _error("Account does not have a plan set");
        }


        // read all active features

        features = model("feature").findAll(
            where = "isactive = 1"
        );


        // cache account quotas

        quotasCache = {};

        for (local.idx=1; local.idx LTE features.recordCount; local.idx++) {

            local.quota = getQuotaObject(features.token[local.idx], account.id);

            quotasCache[features.id[local.idx]] = {
                "id" : local.quota.id,
                "quota" : local.quota.quota
            };

        }

    }


    public any function accountQuotasUpdate() hint="Account quotas form" {

        var local = {};


        _view(pageTitle = "Quotas of Account");

        account = getModelByKey("account", false);

        if (NOT isObject(account)) {
            return _error("Account was not found");
        }

        _view(pageTitleAppend = "&laquo;#account.name#&raquo;");
        _view(headLink = linkTo(text="&larr; Back to account billing", action="accountBilling", key=account.id));
        _view(headLink = linkTo(text="Back to accounts &uarr;", action="accounts"));


        // get active plan
        accountplan = model("accountplan").findOne(
            where = "accountid=#account.id# AND isactive=1",
            include = "plan"
        );

        if (NOT isObject(accountplan)) {
            return _error("Account does not have a plan set");
        }


        // get current account quotas

        accountquotas = model("accountquota").findAll(
            where = "accountid=#account.id# AND isactive=1",
            include = "quota"
        );


        param name="params.quotas" default={};


        // search value for each quota

        for (local.idx=1; local.idx LTE accountquotas.recordCount; local.idx++) {

            local.qid = accountquotas.id[local.idx];

            if (StructKeyExists(params.quotas, local.qid)
                AND isValid("integer", params.quotas[local.qid]) AND params.quotas[local.qid] GT 0
                AND params.quotas[local.qid] NEQ accountquotas.quota[local.idx]) {

                // create new quota

                local.accountquota = model("accountquota").create({
                    accountid : account.id,
                    quotaid : accountquotas.quotaid[local.idx],
                    accountplanid : accountquotas.accountplanid[local.idx],
                    quota : params.quotas[local.qid],
                    isactive : 1
                });

                if (NOT local.accountquota.hasErrors()) {

                    // archive current quota
                    model("accountquotas").updateByKey(key = local.qid, isactive = 0);

                    _event("I", "Created quota ###local.accountquota.id# value (#params.quotas[local.qid]#) of account ###account.id# (#account.name#)");
                    _event("I", "Archived quota ###local.qid# value (#accountquotas.quota[local.idx]#) of account ###account.id# (#account.name#)");

                }
                else {
                    return _error("Failed to create new plan entry");
                }

            }

        }


        flashInsert(success="Quotas for account '#account.name#' were saved successfully");
        redirectTo(action="accountQuotasEdit", key=params.key);


    }


    public any function accountQuotasHistory() hint="Account quotas history" {

        var local = {};


        _view(pageTitle = "Quotas History of Account");

        account = getModelByKey("account", false);

        if (NOT isObject(account)) {
            return _error("Account was not found");
        }

        _view(pageTitleAppend = "&laquo;#account.name#&raquo;");
        _view(headLink = linkTo(text="&larr; Back to account billing", action="accountBilling", key=account.id));
        _view(headLink = linkTo(text="Back to accounts &uarr;", action="accounts"));


        // find all account quotas

        initListParams(20, "isactive");

        if (StructKeyExists(params, "planid") AND isNumeric(params.planid)) {

            accountquotas = model("accountquota").findAll(
                where = "accountid=#account.id# AND accountplanid=#params.planid#",
                page = params.page,
                perPage = params.pagesize,
                order = "isactive desc, id desc"
            );

        }
        else {

            accountquotas = model("accountquota").findAll(
                where = "accountid=#account.id#",
                page = params.page,
                perPage = params.pagesize,
                order = "isactive desc, id desc"
            );

        }


        // cache all quotas

        quotas = model("quota").findAll(
            include = "feature,plan"
        );

        quotasCache = {};

        for (local.idx=1; local.idx LTE quotas.recordCount; local.idx++) {
            quotasCache[quotas.id[local.idx]] = {
                token : quotas.token[local.idx],
                featurename : quotas.name[local.idx],
                planname : quotas.planname[local.idx],
                planid : quotas.planid[local.idx]
            };
        }


    }


    public any function accountPlanEdit() hint="Account plan change form" {

        var local = {};


        _view(pageTitle = "Billing Plan of Account");

        account = getModelByKey("account", false);

        if (NOT isObject(account)) {
            return _error("Account was not found");
        }

        _view(pageTitleAppend = "&laquo;#account.name#&raquo;");
        _view(headLink = linkTo(text="&larr; Back to account billing", action="accountBilling", key=account.id));
        _view(headLink = linkTo(text="Back to accounts &uarr;", action="accounts"));

        // get active plan

        accountplan = model("accountplan").findOne(
            where = "accountid=#account.id# AND isactive=1",
            include = "plan"
        );

        if (NOT isObject(accountplan)) {
            return _error("Account does not have a plan set");
        }

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


    public any function accountPlanUpdate() hint="Update current account plan" {

        var local = {};


        _view(pageTitle = "Billing Plan of Account");

        account = getModelByKey("account", false);

        if (NOT isObject(account)) {
            return _error("Account was not found");
        }

        _view(pageTitleAppend = "&laquo;#account.name#&raquo;");
        _view(headLink = linkTo(text="&larr; Back to account billing", action="accountBilling", key=account.id));
        _view(headLink = linkTo(text="Back to accounts &uarr;", action="accounts"));


        // get active plan

        local.activeplan = model("accountplan").findOne(
            where = "accountid=#account.id# AND isactive=1",
            include = "plan"
        );

        if (NOT isObject(local.activeplan)) {
            return _error("Account does not have a plan set");
        }


        param name="params.accountplan" default={};


        // handle plan change

        if (StructKeyExists(params.accountplan, "planid") AND params.accountplan.planid NEQ local.activeplan.planid) {

            // replace plan with default discount

            if (switchAccountPlan(local.activeplan, params.accountplan.planid, get("defaultDiscountId"))) {
                flashInsert(success="New plan was activated for account '#account.name#'");
                // TODO: queue Recurly subscription update (queue API request)
            }

        }


        // handle discount change

        if (StructKeyExists(params.accountplan, "discountid") AND params.accountplan.discountid NEQ local.activeplan.discountid) {

            // get the discount

            local.discount = model("discount").findByKey(params.accountplan.discountid);

            if (NOT isObject(local.discount) OR NOT local.discount.isactive) {
                return _error("Selected discount not found");
            }

            // recalculate the price

            local.price = local.activeplan.plan.price - local.activeplan.plan.price * local.discount.discount / 100;

            // clone current plan with adjusted price

            if (switchAccountPlan(local.activeplan, local.activeplan.planid, params.accountplan.discountid, local.price)) {
                flashInsert(success="Discount was applied to account '#account.name#'");
                // TODO: queue Recurly subscription update (queue API request)
            }


        }


        if (flashIsEmpty()) {
            flashInsert(warning="No changes were made to account '#account.name#' billing settings");
        }

        redirectTo(action="accountPlanEdit", key=params.key);


    }



    public any function accountPlanHistory() hint="Account plans history" {

        var local = {};


        _view(pageTitle = "Plans History of Account");

        account = getModelByKey("account", false);

        if (NOT isObject(account)) {
            return _error("Account was not found");
        }

        _view(pageTitleAppend = "&laquo;#account.name#&raquo;");
        _view(headLink = linkTo(text="&larr; Back to account billing", action="accountBilling", key=account.id));
        _view(headLink = linkTo(text="Back to accounts &uarr;", action="accounts"));

        // read account plans history

        accountplans = model("accountplan").findAll(
            where = "accountid=#account.id#",
            order = "createdat desc",
            include = "plan,discount"
        );

    }


</cfscript>