component extends="components.models.User" {


    public void function init() hint="Define the validation rules and model relationships" {

        belongsTo(name="user",foreignkey="userid") ;
        belongsTo(name="status",foreignkey="statusid") ;
        hasMany(name='postcategorymapping', modelname="postcategorymapping", foreignkey="userid") ;
        validatesPresenceOf("content, title, description") ;
        validatesUniquenessOf("title") ;
        validate(method="checkCategory") ;

    }
    
     public void function checkCategory() hint="Define the validation rules and model relationships" {
         if (not IsDefined("form.categoryID"))
            {
                adderror(property="categoryid",message="Category field is required.") ;
            }
     }
    
}
