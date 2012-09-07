component extends="Controller" hint="Controller for crum pages section" {

    public any function init() hint="Initialize the controller" {
    	writedump('test');
    	abort;
    	filters(through="memberOnly");
    }

    public any function createNewcategory() hint="Insert new category for posts" {

     	 var newCategory = model("postscategory").new(category=params.category) ;
         newCategory.save() ;
         writedump('Done');
 		 abort;
    }

}
