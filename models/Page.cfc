component extends="components.models.User" {


    public void function init() hint="Define the validation rules and model relationships" {

        belongsTo(name="user",foreignkey="userid") ;
        belongsTo(name="status",foreignkey="statusid") ;
        validatesPresenceOf("content, title, description") ;
        validatesUniquenessOf("title") ;
        validate(method="checkPasswordFields") ;

    }
    
     public void function checkPasswordFields() hint="this validates password field 'required', if isprotected or issubpageprotected is checked." {
             if ((this.isprotected is 1 OR this.issubpageprotected is 1) AND this.password eq "")
                {
                    adderror(property="password",message="Password field is required, if you want to protect page or sub-pages.") ;
                }
     }
    
}

