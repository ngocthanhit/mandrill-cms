component extends="Model" {


    public void function init() hint="Define the validation rules and model relationships" {

        hasOne(name='status', modelname="page") ;
        hasOne(name='status', modelname="post") ;

    }
    
}
