component extends="Model" {


    public void function init() hint="Define the validation rules and model relationships" {
		
		belongsTo(name="user");		
		belongsTo(name="templaterole");
        validatesPresenceOf(property="templatename,templatecontent,templateroleid");

    }


    
}
