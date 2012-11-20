component extends="components.models.Maintenance" {


    public void function init() hint="Define the validation rules and model relationships" {

        hasMany(name="users", dependent="delete");
        hasMany(name='pagelink', modelname="pagesuser");
        hasMany(name='postlink', modelname="postssuser");

        validatesPresenceOf(property="name", message="Account Name can't be empty");
        validatesLengthOf(property="name", allowBlank=true, maximum=50, message="Account Name can't be longer than 50 characters");
        validatesUniquenessOf(property="name", allowBlank=true, includeSoftDeletes=false, message="This account name already exists");

        validatesFormatOf(property="expirationDate", allowBlank=true, type="date", message="Expires On is not valid date");

        validatesInclusionOf(property="status", list="active,locked,expired", message="Status is not selected");

        beforeSave(methods="syncCode");

        beforeUpdate(methods="saveChangesUpdated");
        beforeDelete(methods="saveChangesDeleted");

    }


    public void function syncCode() hint="Sync code with current account name" {

        this.code = CreateUUID();

    }


}
