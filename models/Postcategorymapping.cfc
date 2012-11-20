component extends="Model" {


    public void function init() hint="Define the validation rules and model relationships" {

		belongsTo(name="category",foreignkey="categoryid") ;
		belongsTo(name="post",foreignkey="postid") ;

    }
	
}

