component extends="Wheels" {


    /*
     * This is the parent model file that all your models should extend.
     * You can add functions to this file to make them globally available in all your models.
     * Do not delete this file.
     */
     
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


}