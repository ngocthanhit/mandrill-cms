component extends="Model" {
    public void function init() hint="Define the validation rules and model relationships" {
        hasMany(name="sitessettingsmapping") ;
         validatesPresenceOf("serverprotocol,host,username,password,port,remotepath") ;
    }
}

