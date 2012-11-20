component extends="Model" {


    public void function init() hint="Define the validation rules and model relationships" {

        validatesPresenceOf(property="name", message="Discount name can't be empty");
        validatesLengthOf(property="name", allowBlank=true, maximum=50, message="Discount name can't be longer than 50 characters");

        validatesNumericalityOf(property="discount", greaterThanOrEqualTo=0, message="Discount value must be non-negative integer");

        validatesLengthOf(property="coupon", allowBlank=true, maximum=50, message="Coupon code can't be longer than 50 characters");

        validatesFormatOf(property="expirationDate", allowBlank=true, type="date", message="Expires On is not valid date");

        beforeCreate(methods="setCreatedBy");
        beforeUpdate(methods="setUpdatedBy,saveChangesUpdated");
        beforeDelete(methods="saveChangesDeleted");

    }


    public boolean function isUsed() hint="Check if discount is used by any accounts" {

        return (StructKeyExists(this, "id") AND model("accountplan").count(where="discountid=#this.id#") GT 0);

    }


}