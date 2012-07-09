component extends="Model" {


    public void function init() hint="Define the validation rules and model relationships" {

		belongsTo(name="category") ;
		belongsTo(name="post") ;

    }
	
}

