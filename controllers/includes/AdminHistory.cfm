<cfscript>



    /*
     * DATA HISTORY
     */


    public any function syslog() hint="System log listing" {

        var local = {};

        _view(pageTitle = "System Log", renderCustomLayout = true);
        _view(stickyAttributes = "datefrom,dateto,fuserid,fpage,ftype,pagesize,sort,order");

        // archive the expired records
        model("currentevent").archiveExpiredEvents(get("keepEventsPeriod"));

        initListParams(50, "createdAt", "desc");

        // handle custom params

        if (StructKeyExists(params, "reset")) {
            params.datefrom = "";
            params.dateto = "";
            params.fuserid = "";
            params.fpage = "";
            params.ftype = "";
            params.order = "createdAt";
            params.sort = "desc";
        }

        param name="params.datefrom" default="";
        param name="params.dateto" default="";
        param name="params.fuserid" default="";
        param name="params.fpage" default="";
        param name="params.ftype" default="";

        // build the query based on filters

        local.clause = "id != 0";

        if (isDate(params.datefrom)) {
            local.clause &= " AND createdAt >= '#params.datefrom#'";
        }
        else {
            params.datefrom = "";
        }

        if (isDate(params.dateto)) {
            local.clause &= " AND createdAt <= '#DateAdd('d',1,params.dateto)#'";
        }
        else {
            params.dateto = "";
        }

        if (params.fuserid NEQ "") {
            local.clause &= " AND userid = #params.fuserid#";
        }

        if (params.fpage NEQ "") {
            local.clause &= " AND action = '#params.fpage#'";
        }

        if (params.ftype NEQ "") {
            local.clause &= " AND type = '#params.ftype#'";
        }

        currentEvents = model("currentevent").findAll(
            where=local.clause,
            page=params.page, perPage=params.pagesize,
            order="#params.order# #params.sort#, id desc",
            include="user", includeSoftDeletes=true
        );

        // pull data for filters

        pages = model("currentevent").findAll(
            select="action", distinct=true, order="action asc"
        );

        users = model("users").findAll(
            order="email asc"
        );

    }


    public any function syslogEvent() hint="Single system log event summary" {

        var local = {};

        _view(pageTitle = "System Log Event");
        _view(headLink = linkTo(text="Back to log &uarr;", action="syslog"));

        currentEvent = getModelByKey("currentevent", false);

        if (NOT isObject(currentEvent)) {
            _event("E", "Invalid system log event #params.key# requested");
            _error("System log event was not found");
        }
        else {
            _view(pageTitleAppend = "###params.key#");
            currentEventUser = model("user").findByKey(currentEvent.userid);
            currentEventAccount = model("account").findByKey(currentEvent.accountid);
        }

    }


    public any function history() hint="Data changes history listing" {

        var local = {};

        _view(pageTitle = "Data History", renderCustomLayout = true);
        _view(stickyAttributes = "datefrom,dateto,fuserid,fmodel,ftype,pagesize,sort,order");

        // archive the expired records
        model("currentchange").archiveExpiredChanges(get("keepChangesPeriod"));

        initListParams(50, "createdAt", "desc");

        // handle custom params

        if (StructKeyExists(params, "reset")) {
            params.datefrom = "";
            params.dateto = "";
            params.fuserid = "";
            params.fmodel = "";
            params.ftype = "";
            params.order = "createdAt";
            params.sort = "desc";
        }

        param name="params.datefrom" default="";
        param name="params.dateto" default="";
        param name="params.fuserid" default="";
        param name="params.fmodel" default="";
        param name="params.ftype" default="";

        // build the query based on filters

        local.clause = "id != 0";

        if (isDate(params.datefrom)) {
            local.clause &= " AND createdAt >= '#params.datefrom#'";
        }
        else {
            params.datefrom = "";
        }

        if (isDate(params.dateto)) {
            local.clause &= " AND createdAt <= '#DateAdd('d',1,params.dateto)#'";
        }
        else {
            params.dateto = "";
        }

        if (params.fuserid NEQ "") {
            local.clause &= " AND userid = #params.fuserid#";
        }

        if (params.fmodel NEQ "") {
            local.clause &= " AND modelcode = '#params.fmodel#'";
        }

        if (params.ftype NEQ "") {
            local.clause &= " AND type = '#params.ftype#'";
        }

        currentChanges = model("currentchange").findAll(
            where=local.clause,
            page=params.page, perPage=params.pagesize,
            order="#params.order# #params.sort#, id desc",
            include="user", includeSoftDeletes=true
        );

        // pull data for filters

        objects = model("currentchange").findAll(
            select="modelcode", distinct=true, order="modelcode asc"
        );

        users = model("users").findAll(
            order="email asc"
        );


    }


    public any function historyPacket() hint="Single changes history packet" {

        var local = {};

        _view(pageTitle = "Data History Packet");
        _view(headLink = linkTo(text="Back to history &uarr;", action="history"));

        currentChange = getModelByKey("currentchange", false);

        if (NOT isObject(currentChange)) {
            _event("E", "Invalid changes history packet #params.key# requested");
            _error("Data history packet was not found");
        }
        else {
            _view(pageTitleAppend = "###params.key#");
            currentChangeUser = model("user").findByKey(currentChange.userid);
            if (isObject(currentChangeUser)) {
                currentChangeAccount = model("account").findByKey(currentChangeUser.accountid);
            }
        }

    }



</cfscript>