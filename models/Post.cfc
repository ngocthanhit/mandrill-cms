component extends="Model" {


    public void function init() hint="Define the validation rules and model relationships" {

        belongsTo(name="user") ;
        belongsTo(name="status") ;
        hasMany(name='postscategory', modelname="postscategory") ;
        hasMany(name="postsuser") ;
        validatesPresenceOf("content, title, description") ;
       // validatesUniquenessOf("title") ;
        validate(method="checkCategory") ;

    }

     public void function checkCategory() hint="Define the validation rules and model relationships" {
         if (not IsDefined("form.categoryID"))
            {
                adderror(property="categoryid",message="Category field is required.") ;
            }
     }

}
