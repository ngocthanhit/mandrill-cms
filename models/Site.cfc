component extends="Model" {
    public void function init() hint="Define the validation rules and model relationships" {
        hasMany(name="sitesuser") ;
        validatesPresenceOf("name,url") ;
        validatesUniquenessOf("name") ;
    }
}
