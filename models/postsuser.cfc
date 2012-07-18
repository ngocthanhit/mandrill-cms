component extends="Model" {


    public void function init() hint="Define the validation rules and model relationships" {

        hasMany(name='postof', modelname="posts");
        hasMany(name='userof', modelname="users");
        hasMany(name='accountof', modelname="accounts");
    }


