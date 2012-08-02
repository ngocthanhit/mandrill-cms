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
            local.output &= "<"&"div class=""alert #LCase(local.key)#"">";
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
                return "Visitor";
            case 1:
                return "Guest";
            case 2:
                return "Author";
            case 3:
                return "Editor";
            case 4:
                return "Developer";
            case 5:
                return "Account Owner";
            case 6:
                return "Administrator";
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

        links &= "<ul>" & "<li>" & linkTo(text="&laquo;", params="page=#iif(paging.currentPage EQ 1, 1, paging.currentPage-1)#", controller=arguments.controller) & "</li>";

        if (arguments.handle NEQ "") {
            links &= paginationLinks(linkToCurrentPage=true, classForCurrent="active", showSinglePage=true, handle=arguments.handle, controller=arguments.controller, prependToPage="<li>", prependOnFirst="true", appendToPage="</li>", appendOnLast="true");
        }
        else {
            links &= paginationLinks(linkToCurrentPage=true, classForCurrent="active", showSinglePage=true, controller=arguments.controller, prependToPage="<li>", prependOnFirst="true", appendToPage="</li>", appendOnLast="true");
        }

        links &= "<li>" & linkTo(text="&raquo;", params="page=#iif(paging.currentPage EQ paging.totalPages, paging.totalPages, paging.currentPage+1)#", controller=arguments.controller) & "</li>" & "</ul>";

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

        links &= "<ul>" & "<li>" & linkTo(text="&laquo;", params="page=#iif(paging.currentPage EQ 1, 1, paging.currentPage-1)#", route=arguments.route, key=arguments.key) & "</li>";

        links &= paginationLinks(linkToCurrentPage=true, classForCurrent="active", showSinglePage=true, route=arguments.route, key=arguments.key, prependToPage="<li>", prependOnFirst="true", appendToPage="</li>", appendOnLast="true");

        links &= "<li>" &  linkTo(text="&raquo;", params="page=#iif(paging.currentPage EQ paging.totalPages, paging.totalPages, paging.currentPage+1)#", route=arguments.route, key=arguments.key) & "</li>" & "</ul>";

        return links;

    }


    /*
     * @text Text to wrap
     * @prepend Prepend output with this text, typically <br/>
     */
    string function noteText(required string text, string prepend = "") hint="Get text wrapped into notes block" {

        return arguments.prepend & "<"&"span class=""note"">" & arguments.text & "<"&"/span>";

    }


    /*
     * @value numeric value of Hosting quota feature
     */
    string function quotaHostingValue(required numeric value) hint="Get text of Hosting quota"  {
        return YesNoFormat(arguments.value - 1);
    }


</cfscript>