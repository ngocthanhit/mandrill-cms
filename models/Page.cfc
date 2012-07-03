component extends="Model" {


    public void function init() hint="Define the validation rules and model relationships" {

        belongsTo(name="user",foreignkey="userid") ;
        belongsTo(name="status",foreignkey="statusid") ;
        validatesPresenceOf("content, title, description") ;
        validatesUniquenessOf("title") ;
        validate(method="checkPasswordFields") ;

        beforeSave(methods="hashPassword");

    }
    
     public void function checkPasswordFields() hint="this validates password field 'required', if isprotected or issubpageprotected is checked." {
             if ((this.isprotected is 1 OR this.issubpageprotected is 1) AND this.password eq "")
                {
                    adderror(property="password",message="Password field is required, if you want to protect page or sub-pages.") ;
                }
     }

      public void function hashPassword() hint="Hash password if entered on form" {

        if (this.password NEQ "" AND (NOT isValid("regex", this.password, "[A-Z0-9]{64}"))) {
            this.password = Hash(this.password & get("hashingKey"), "SHA-256");
        }

    }
    
}

