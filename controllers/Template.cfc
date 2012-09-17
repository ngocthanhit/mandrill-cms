component extends="Controller" hint="Controller for TEMPLATE section" {
	
	/* Init */
	public any function init() hint="Initialize the controller" {
		filters(through="memberOnly");
		filters(through="restrictedAccessSites");
    }
    
    
	/* View Template List */
	public any function index() hint="Template listing" { 
		
		_view(pageTitle = "Templates", renderShowBy = true, stickyAttributes = "pagesize,sort,order");
        _view(headLink = linkTo(text="Add template", action="templateAdd"));

        initListParams(20, "templatename");

        templates = model("template").findAll(
        	select = "templates.id, templates.templatename, templates.isdefaulttemplate, templates.createdAt, templateroles.role",
            where = "userid = #getUserAttr('id')#",
            include = "templaterole",
            page = params.page,
            perPage = params.pagesize,
            order = "#params.order# #params.sort#"
        );
		
	}
	
	/* View Add / Edit Template */
	public any function addEditTemplate() hint="Add and/or Edit Template"{
		
		templateRoles = model("templaterole").findAll();
		
		if(StructKeyExists(params,"key")){
			_view(pageTitle = "Edit Template");
			formParams.action = 'processUpdateTemplate';
			
			Template = model("template").findByKey(params.key);
		}
		else {
			_view(pageTitle = "Add Template");	
			formParams.action = 'processCreateTemplate';
			defaultParams.isactive = 1;
			
			Template = model("template").new(isactive=1);
		}
		
	}
	
	
	/* Process Create Template */
	public any function processCreateTemplate() hint="Process Create Template"{
		
		newTemplate = model("template").new(params.template);    
		newTemplate.userid = getUserAttr('id');
		
		if (newTemplate.save()){
		    _event("I", "Successfully template created", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
		    flashInsert(success="Template created successfully.") ;
	    	redirectTo(controller=params.controller) ;
		}
		else{
			_event("W", "Caught attempt to template add information not required", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
					
	        _view(pageTitle = "Add Template");	
	        formParams.action = "processCreateTemplate" ;
	        renderPage(template="addedittemplate") ;
		}
	}
	
	/* Process Update Template */
	public any function processUpdateTemplate() hint="Process Update Template"{
		
	}
	
	/* Process Delete Template */
	public any function processDeleteTemplate() hint="Process Delete Template"{
		
	}
	
}