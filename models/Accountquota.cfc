component extends="components.models.Accountquota" {


    public void function init() hint="Define the validation rules and model relationships" {

        belongsTo(name="quota");

        validatesNumericalityOf(property="quota", onlyInteger=true, greaterThan=0, message="Quota value must be positive ordinal number");

        beforeCreate(methods="setCreatedBy");

    }


}