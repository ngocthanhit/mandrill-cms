component extends="Model" {

    public void function init() hint="Define the validation rules and model relationships" {

        belongsTo(name="user") ;
        belongsTo(name="status") ;
        hasMany(name="pagesuser") ;
        validatesPresenceOf("content, title, description") ;
       // validatesUniquenessOf("title") ;
        validate(method="checkPasswordFields") ;
        beforeSave(methods="hashPassword");
    }

     public void function checkPasswordFields() hint="this validates password field 'required', if isprotected or issubpageprotected is checked." {
             if ((form.protected neq "No password required")) {
                if (form.password eq "" AND ((NOT IsDefined("this.password")) OR this.password EQ "")) {
                    adderror(property="password",message="Password field is required, if you want to protect page or sub-pages.") ;
                 }
                if(form.password NEQ form.confirmPassword AND ((NOT IsDefined("this.password")) OR this.password EQ "")) {
                    adderror(property="password",message="Password field is required match with confirmPassword field, if you want to protect page or sub-pages.") ;
                }else if(((NOT IsDefined("this.password")) OR this.password NEQ "") AND form.password NEQ form.confirmPassword){
                    adderror(property="password",message="Password field is required match with confirmPassword field, if you want to protect page or sub-pages.") ;                
                }
            }
     }

      public void function hashPassword() hint="Hash password if entered on form" {

        if (form.password NEQ "" AND (NOT isValid("regex", form.password, "[A-Z0-9]{64}"))) {
            form.password = Hash(form.password & get("hashingKey"), "SHA-256");
        }

    }
}
