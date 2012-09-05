component extends="Controller" hint="Controller for TEMPLATE section" {

	/*
	* Template Lists
	*/
	public any function index() hint="Template listing" { 
		
		var loc = {};
		
		_view(pageTitle = "Templates", renderShowBy = true, stickyAttributes = "pagesize,sort,order");
        _view(headLink = linkTo(text="Add template", action="templateAdd"));

        initListParams(20, "templatename");

        users = model("templates").findAll(
            where = "userid = #getUserAttr('id')#",
            page = params.page,
            perPage = params.pagesize,
            order = "#params.order# #params.sort#"
        );
		
	}
}