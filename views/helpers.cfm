<cfscript>


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


</cfscript>