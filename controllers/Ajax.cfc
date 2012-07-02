component extends="Controller" hint="Controller for AJAX requests handling" {


    _view(sectionTitle = "AJAX");

    public any function init() hint="Initialize the controller" {
        filters(through="memberOnly");
        //if (get("environment") NEQ "design") { filters(through="ajaxOnly"); }
        provides("json");
    }



    /*
     * HELPERS
     */


    public any function toggle() hint="Toggle status of given model field" {

        var local = {};

        local.response = {"success" : true, "message" : ""};

        param name="params.model" default="";
        param name="params.field" default="";

        local.object = getModelByKey(params.model);
        
        if (NOT isObject(local.object)) {
            _event("E", "Invalid #params.model# model #params.key# requested");
            local.response.success = false;
            local.response.message = "Invalid data record requested";
        }
        else if (NOT StructKeyExists(local.object, params.field) OR NOT isBoolean(local.object[params.field])) {
            _event("E", "Invalid #params.model# field #params.field# requested");
            local.response.success = false;
            local.response.message = "Invalid data record requested";
        }
        else {
            local.object.toggle(params.field);
            local.response.message = YesNoFormat(local.object[params.field]);
            _event("I", "Toggled status of #params.field# #params.model# ###params.key#");
        }
        
        renderWith(local.response);

    }


}