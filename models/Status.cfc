component extends="components.models.User" {


    public void function init() hint="Define the validation rules and model relationships" {

        hasOne(name='status', modelname="page", foreignkey="statusid") ;
        hasOne(name='status', modelname="post", foreignkey="statusid") ;

    }
    
}
