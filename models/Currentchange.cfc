component extends="components.models.Maintenance" {


    public void function init() hint="Define the validation rules and model relationships" {

        belongsTo(name="user", joinType="outer");

    }


}