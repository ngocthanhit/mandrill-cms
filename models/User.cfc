component extends="components.models.User" {


    public void function init() hint="Define the validation rules and model relationships" {

        belongsTo(name="account");
        hasMany(name='pagelink', modelname="pagesuser");
        hasMany(name='postof', modelname="posts");

        validatesPresenceOf(property="firstName", message="First Name can't be empty");
        validatesLengthOf(property="firstName", allowBlank=true, maximum=50, message="First Name can't be longer than 50 characters");

        validatesPresenceOf(property="lastName", message="Last Name can't be empty");
        validatesLengthOf(property="lastName", allowBlank=true, maximum=50, message="Last Name can't be longer than 50 characters");

        validatesPresenceOf(property="email", message="Email can't be empty");
        validatesFormatOf(property="email", allowBlank=true, type="email", message="Entered email is not valid");
        validatesLengthOf(property="email", allowBlank=true, maximum=50, message="Email can't be longer than 50 characters");
        validatesUniquenessOf(property="email", allowBlank=true, includeSoftDeletes=false, message="Entered email already exists");

        validatesPresenceOf(property="password", when="onCreate", message="Password can't be empty");
        validatesConfirmationOf(property="password", message="Password doesn't match the confirmation");

        validate(methods="checkTimeZone,checkDateFormat");

        beforeSave(methods="hashPassword");

        beforeUpdate(methods="saveChangesUpdated");
        beforeDelete(methods="saveChangesDeleted");

    }


    public void function checkTimeZone() hint="Special validation for timezone id" {

        param name="this.timezoneid" default="0";

        var timezone = model("timezone").findByKey(this.timezoneid);

        if (NOT isObject(timezone)) {
            addError(property="timezone", message="Time zone not selected");
        }

    }


    public void function checkDateFormat() hint="Special validation for date format" {

        var local = {};

        local.matches = false;

        for (local.key in get('viewDateFormats')) {
            if (local.key.format EQ this.dateFormat) {
                local.matches = true;
            }
        }

        if (NOT local.matches) {
            addError(property="dateformat", message="Date format not selected");
        }

    }


    public void function hashPassword() hint="Hash password if entered on form" {

        if (NOT isValid("regex", this.password, "[A-Z0-9]{64}")) {
            this.password = Hash(this.password & get("hashingKey"), "SHA-256");
        }

    }


    public numeric function getTimeOffset() hint="Get offset by user time zone id" {

        // cache the object in case of multiple calls
        if (NOT StructKeyExists(this, "timezone")) {
            this.timezone = model("timezone").findByKey(this.timezoneid);
        }

        return this.timezone.offset;

    }


}
