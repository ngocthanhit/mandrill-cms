component extends="Model" {


    public void function init() hint="Define the validation rules and model relationships" {

        belongsTo(name="feature");
        belongsTo(name="plan");

        validatesNumericalityOf(property="quota", onlyInteger=true, greaterThan=0, message="Quota value must be positive ordinal number");

        beforeCreate(methods="setCreatedBy");
        beforeUpdate(methods="setUpdatedBy,saveChangesUpdated");
        beforeDelete(methods="saveChangesDeleted");

    }


}