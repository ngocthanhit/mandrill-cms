component extends="Wheels" {


    private void function setCreatedBy() hint="Populate model with current values" {
        if (NOT StructKeyExists(this, "accountid") OR this.accountid EQ 0) {
            this.accountid = getAccountAttr('id');
        }
        this.createdBy = getUserAttr('id');
    }


    private void function setUpdatedBy() hint="Populate model with current values" {
        this.updatedBy = getUserAttr('id');
    }


    private void function saveChangesUpdated() hint="Write current state into changes history before update event" {
        saveChanges("r");
    }


    private void function saveChangesDeleted() hint="Write current state into changes history before delete event" {
        saveChanges("d");
    }


    private void function saveChanges(string type) hint="Write current state into changes history" {

        // make sure user object already instantiated and belongs to non-visitor
        if (NOT StructKeyExists(request, "user") OR request.user.id EQ get("visitorUserId")) {
            return;
        }

        model("currentchange").create({
            userid : getUserAttr("id"),
            type : arguments.type,
            modelcode : LCase(ListLast(GetMetaData(this).fullname, ".")),
            modelid : this.id,
            packet : SerializeJSON(this.properties()),
        });

    }


    private string function getPermissionsModel() hint="Get this model name of this object" {
        return (getModelName() & "permissions");
    }


    private string function getModelName() hint="Get model name of this object" {
        return LCase(ListLast(getMetaData(this).name, "."));
    }


    /*
     * @access Permission access 2-char code
     */
    /*
     *
     * Feature is postponed, see ticket https://nerve.codebasehq.com/projects/nervecentral/tickets/79
     *
    public boolean function granted(required string access) hint="Get current user access to this object" {

        // check makes sense only for TM and persisted objects

        if (getUserAttr("accessLevel") GT get("accessLevelMember") OR this.isNew()) {
            return true;
        }

        // try to find permission entry by composite PK

        local.args = {
            "#getModelName()#id" : this.id,
            "userid" : getUserAttr("id"),
            "access" : arguments.access
        };

        local.obj = model(getPermissionsModel()).findOne(argumentcollection = local.args);

        if (isObject(local.obj)) {
            return true;
        }
        else if (NOT getSetting("StrictPermissionsPolicy")) {
            // set up new entry if does not exist yet and LOOSE policy is active
            model(getPermissionsModel()).create(local.args);
            return true;
        }
        else {
            return false;
        }

    }
    */


}