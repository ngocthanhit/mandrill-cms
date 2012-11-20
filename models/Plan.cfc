component extends="Model" {


    public void function init() hint="Define the validation rules and model relationships" {

        validatesPresenceOf(property="name", message="Plan name can't be empty");
        validatesLengthOf(property="name", allowBlank=true, maximum=50, message="Plan name can't be longer than 50 characters");

        validatesNumericalityOf(property="price", greaterThanOrEqualTo=0, message="Plan price must be non-negative number");

        validatesNumericalityOf(property="position", message="Position must be valid number");

        afterInitialization("formatPrice");

        beforeCreate(methods="setCreatedBy");
        beforeUpdate(methods="setUpdatedBy,saveChangesUpdated");
        beforeDelete(methods="saveChangesDeleted");

    }


    public any function formatPrice() hint="Create formatted version of price" {

        if (NOT this.isNew()) {
            this.price = NumberFormat(this.price, '.__');
        }

    }


    public boolean function isUsed() hint="Check if plan is used by any accounts" {

        return (StructKeyExists(this, "id") AND model("accountplan").count(where="planid=#this.id#") GT 0);

    }


}