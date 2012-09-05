component extends="Model" {
    public void function init() hint="Define the validation rules and model relationships" {

        validatesPresenceOf("name,url,serverprotocol,host,username,password,port,remotepath") ;
        validatesUniquenessOf("name") ;
    }
}

