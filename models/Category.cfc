component extends="Model" {
     public void function init() hint="Define the validation rules and model relationships" {
         hasMany(name='postcategorymapping', modelname="postcategorymapping", foreignkey="categoryid") ;
     }
}
