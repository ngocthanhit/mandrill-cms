component extends="Model" {


    public void function init() hint="Define the validation rules and model relationships" {

        belongsTo(name="plan");
        belongsTo(name="discount");

        validatesNumericalityOf(property="price", greaterThanOrEqualTo=0, message="Plan price must be non-negative number");

        afterInitialization("formatPrice");

        beforeCreate(methods="setCreatedBy,setRenewed");

    }


    public any function formatPrice() hint="Create formatted version of price" {

        if (NOT this.isNew()) {
            this.price = NumberFormat(this.price, '.__');
        }

    }


    public void function setRenewed() hint="Populate plan renew date" {

        this.renewedAt = Now();

    }


}