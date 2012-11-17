component extends="Controller" hint="Controller for crum pages section" {

    public any function init() hint="Initialize the controller" {
        filters(through="memberOnly");
    }

    public any function createNewcategory() hint="Insert new category for posts" {
        var localStruct =  StructNew() ;
        localStruct.category=params.category;
        localStruct.createdby=getUserAttr("id");
        localStruct.updatedby=getUserAttr("id");

		newCategory = model("categorie").new(localStruct) ;
		newCategory.save() ;
    }

}
