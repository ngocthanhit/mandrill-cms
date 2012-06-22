<cfscript>



    /*
     * @timestamp Time stamp to format
     */
    string function formatDateTime(required any timestamp) hint="Format time stamp as date+time string according to current user prefs" {

        if (NOT isDate(arguments.timestamp)) {
            return ("");
        }

        local.timestamp = DateAdd("n", request.user.getTimeOffset()*60, arguments.timestamp);

        return DateFormat(local.timestamp, getUserAttr("dateformat")) & " at " & TimeFormat(local.timestamp, getUserAttr("timeformat"));

    }


    /*
     * @timestamp Time stamp to format
     */
    string function formatDateTimeCompact(required any timestamp) hint="Format time stamp as date+time string in EU format for compact output" {

        if (NOT isDate(arguments.timestamp)) {
            return ("");
        }

        local.timestamp = DateAdd("n", request.user.getTimeOffset()*60, arguments.timestamp);

        return DateFormat(local.timestamp, "dd.mm.yyyy") & " " & TimeFormat(local.timestamp, "HH:mm");

    }


    /*
     * @timestamp Time stamp to format
     */
    string function formatDate(required any timestamp) hint="Format time stamp as date string according to current user prefs" {

        return isDate(arguments.timestamp) ? DateFormat(arguments.timestamp, getUserAttr("dateformat")) : "";

    }


    /*
     * @objectName Name of the object to get error messages for
     * @warnings Prepared string of sub-warnings to inject into the messsage
     */
    string function flashRender(string objectName, array warnings) hint="Render current errors and messages as customized HTML block" {

        var local = {};

        local.output = "";

        if (flashIsEmpty()) {
            return local.output;
        }

        for (local.key in flash()) {

            // render current flash message with corresponding styling
            local.output &= "<"&"div class=""message #LCase(local.key)#"">";
            local.output &= "<"&"p>" & flash(local.key) & "<"&"/p>";

            // render sub-warnings, if any
            if (StructKeyExists(arguments, "objectName") AND local.key EQ "warning" AND isDefined(arguments.objectName)) {
                local.output &= errorMessagesFor(arguments.objectName, "problems");
            }

            // inject sub-warnings
            if (StructKeyExists(arguments, "warnings")) {
                local.output &= '<ul class="problems">';
                for (local.idx=1; local.idx LTE ArrayLen(arguments.warnings); local.idx++) {
                    local.output &= "<li>" & arguments.warnings[local.idx].message & "</li>";
                }
                local.output &= '</ul>';
            }

            local.output &= "<"&"/div>";

        }

        return local.output;

    }



    /*
     * @type Short type code
     */
    string function getLogTypeText(required string type) hint="Get full name of system log event type" {

        switch (arguments.type) {
            case "I":
                return "Information";
            case "W":
                return "Warning";
            case "E":
                return "Error";
        }

    }



    /*
     * @type Short type code
     */
    string function getLogTypeColor(required string type) hint="Get color of system log event type" {

        switch (arguments.type) {
            case "I":
                return "666666";
            case "W":
                return "ff7e00";
            case "E":
                return "ff000f";
        }

    }


    /*
     * @accesslevel Numeric representation of access level
     */
    string function getAccessLevelText(required numeric accesslevel) hint="Get text name for user accesslevel" {

        switch (arguments.accesslevel) {
            case 0:
                return "Guest";
            case 1:
                return "Team Member";
            case 2:
                return "Account Manager";
            case 3:
                return "Administrator";
        }

    }


    /*
     * @status Short status code
     */
    string function getSubStatusText(required string status) hint="Get text name for subscription status" {

        switch (arguments.status) {
            case "sub":
                return "Active";
            case "uns":
                return "Unsubscribed";
            case "cle":
                return "Cleaned";
            default:
                return arguments.status;
        }

    }


    /*
     * @handle The handle given to the query that the pagination links should be displayed for
     * @controller Controller to use in linkTo
     */
    string function paginationLinksFull(string handle = "", string controller = "") hint="Get paging bar with Next/Prev links" {

        var links = "";

        var paging = StructKeyExists(arguments, "pagination") ? arguments.pagination : pagination();

        if (paging.totalRecords EQ 0) {
            return links;
        }

        links = "Page #paging.currentPage# of #paging.totalPages# (total #paging.totalRecords# records)&nbsp;&nbsp;&nbsp;";

        links &= linkTo(text="&laquo;", params="page=#iif(paging.currentPage EQ 1, 1, paging.currentPage-1)#", controller=arguments.controller);

        if (arguments.handle NEQ "") {
            links &= paginationLinks(linkToCurrentPage=true, classForCurrent="active", showSinglePage=true, handle=arguments.handle, controller=arguments.controller);
        }
        else {
            links &= paginationLinks(linkToCurrentPage=true, classForCurrent="active", showSinglePage=true, controller=arguments.controller);
        }

        links &= linkTo(text="&raquo;", params="page=#iif(paging.currentPage EQ paging.totalPages, paging.totalPages, paging.currentPage+1)#", controller=arguments.controller);

        return links;

    }


    /*
     * @route Route name to use for building links
     * @key Params key value
     */
    string function paginationLinksRouted(required string route, required string key) hint="Get paging bar with Next/Prev links" {

        var links = "";
        var paging = pagination();

        if (paging.totalRecords EQ 0) {
            return links;
        }

        links = "Page #paging.currentPage# of #paging.totalPages# (total #paging.totalRecords# records)&nbsp;&nbsp;&nbsp;";

        links &= linkTo(text="&laquo;", params="page=#iif(paging.currentPage EQ 1, 1, paging.currentPage-1)#", route=arguments.route, key=arguments.key);

        links &= paginationLinks(linkToCurrentPage=true, classForCurrent="active", showSinglePage=true, route=arguments.route, key=arguments.key);

        links &= linkTo(text="&raquo;", params="page=#iif(paging.currentPage EQ paging.totalPages, paging.totalPages, paging.currentPage+1)#", route=arguments.route, key=arguments.key);

        return links;

    }


    /*
     * @pagination Data structure with paging attributes
     * @controller Controller to use in linkTo
     */
    string function paginationLinksCustom(struct pagination, string controller = "", string action = "") hint="Get paging bar with Next/Prev links" {

        var local = {};

        local.links = "";
        local.paging = StructCopy(arguments.pagination);

        if (local.paging.totalRecords EQ 0) {
            return local.links;
        }

        local.links = "Page #local.paging.currentPage# of #local.paging.totalPages# (total #local.paging.totalRecords# records)&nbsp;&nbsp;&nbsp;";
        local.links &= linkTo(controller=arguments.controller, action=arguments.action, text="&laquo;", params="page=#iif(local.paging.currentPage EQ 1, 1, local.paging.currentPage-1)#");

        if (local.paging.currentPage EQ 2) {
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text="1", params="page=1");
        }
        else if (local.paging.currentPage EQ 3) {
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text="1", params="page=1");
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text="2", params="page=2");
        }
        else if (local.paging.currentPage EQ 4) {
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text="1", params="page=1");
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text="2", params="page=2");
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text="3", params="page=3");
        }
        else if (local.paging.currentPage GT 4) {
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text="1", params="page=1");
            local.links &= "...";
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text=local.paging.currentPage-2, params="page=#local.paging.currentPage-2#");
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text=local.paging.currentPage-1, params="page=#local.paging.currentPage-1#");
        }

        local.links &= linkTo(controller=arguments.controller, action=arguments.action, text=local.paging.currentPage, params="page=#local.paging.currentPage#", class="active");

        if (local.paging.currentPage EQ local.paging.totalPages-3) {
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text=local.paging.currentPage+1, params="page=#local.paging.currentPage+1#");
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text=local.paging.currentPage+2, params="page=#local.paging.currentPage+2#");
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text=local.paging.totalPages, params="page=#local.paging.totalPages#");
        }
        else if (local.paging.currentPage EQ local.paging.totalPages-2) {
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text=local.paging.currentPage+1, params="page=#local.paging.currentPage+1#");
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text=local.paging.totalPages, params="page=#local.paging.totalPages#");
        }
        else if (local.paging.currentPage EQ local.paging.totalPages-1) {
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text=local.paging.totalPages, params="page=#local.paging.totalPages#");
        }
        else if (local.paging.currentPage LT local.paging.totalPages-3) {
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text=local.paging.currentPage+1, params="page=#local.paging.currentPage+1#");
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text=local.paging.currentPage+2, params="page=#local.paging.currentPage+2#");
            local.links &= "...";
            local.links &= linkTo(controller=arguments.controller, action=arguments.action, text=local.paging.totalPages, params="page=#local.paging.totalPages#");
        }

        local.links &= linkTo(controller=arguments.controller, action=arguments.action, text="&raquo;", params="page=#iif(local.paging.currentPage EQ local.paging.totalPages, local.paging.totalPages, local.paging.currentPage+1)#");

        return local.links;

    }


    /*
     * @qry Source query
     * @row Row number
     */
    struct function getQueryRow(required query qry, required numeric row) hint="Get specific query row as structure" {

        var i = 0;
        var rowData = {};
        var cols = ListToArray(arguments.qry.getColumnlist(false));

        for (i=1; i LTE ArrayLen(cols); i++) {
            rowData[cols[i]] = arguments.qry[cols[i]][arguments.row];
        }

        return rowData;

    }



    /*
     * @column Target column name
     */
    string function getStyleByColumn(required string column) hint="Get CSS for contact listing column" {

        var style = "";

        switch (arguments.column) {
            case "id":
                style = "width:20px;";
                break;
            case "isMailable":
            case "isContactable":
            case "isActive":
                style = "width:120px;";
                break;
            case "createdAt":
                style = "width:80px;";
                break;
            case "updatedAt":
                style = "width:150px;";
                break;
        }

        return style;

    }


    /*
     * @column Target column name
     * @value Value to format
     */
    string function formatContactField(required string column, required any value) hint="Format contact listing fields according to column type" {

        var field = "";

        switch (arguments.column) {
            case "isMailable":
            case "isContactable":
            case "isActive":
                field = YesNoFormat(arguments.value);
                break;
            case "createdAt":
                field = formatDate(arguments.value);
                break;
            case "updatedAt":
                field = formatDateTime(arguments.value);
                break;
            case "country":
                // countries must be cached on controller level as iso-name pairs
                field = StructKeyExists(request.countries, arguments.value) ? HTMLEditFormat(request.countries[arguments.value]) : "";
                break;
            default:
                field = HTMLEditFormat(arguments.value);
        }

        return field;

    }



    /*
     * @datatype Data type code from database
     */
    string function getSettingTypeText(required string datatype) hint="Get text representation of setting data type" {

        switch(arguments.datatype) {
            case "string":
                return "String";
            break;
            case "integer":
                return "Ordinal Number";
            break;
            case "float":
                return "Real number";
            break;
            case "boolean":
                return "Yes/No";
            break;
            case "email":
                return "Email";
            break;
            case "date":
                return "Date";
            break;
            default:
                return "N/A";
        }

    }



    /*
     * @source Text to mask
     */
    string function maskText(required string source, numeric borders = 5, string char = "*") hint="Get masked version of the string" {

        return Left(arguments.source, arguments.borders) & RepeatString(arguments.char, Len(arguments.source)-arguments.borders*2) & Right(arguments.source, arguments.borders);

    }



    /*
     * @text Text to wrap
     * @prepend Prepend output with this text, typically <br/>
     */
    string function noteText(required string text, string prepend = "") hint="Get text wrapped into notes block" {

        return arguments.prepend & "<"&"span class=""note"">" & arguments.text & "<"&"/span>";

    }



    /*
     * @number Source number
     * @text Text to use for replacement
     */
    string function zeroToText(required numeric number, string text = "none") hint="Replace zero number with nice text" {

        return (arguments.number) ? arguments.number : arguments.text;

    }



</cfscript>