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


</cfscript>