component extends="Model" {


    public void function init() hint="Define the validation rules and model relationships" {

        validatesPresenceOf(property="name", message="Feature name can't be empty");
        validatesLengthOf(property="name", allowBlank=true, maximum=50, message="Feature name can't be longer than 50 characters");

        validatesNumericalityOf(property="position", message="Position must be valid number");

        beforeUpdate(methods="setUpdatedBy,saveChangesUpdated");
        beforeDelete(methods="saveChangesDeleted");

    }


}