component extends="Controller" hint="Controller for TEMPLATE section" {

	/* Init */
	public any function init() hint="Initialize the controller" {
		filters(through="accountOwnerOrDeveloperOnly");
    }


	/* View Template List */
	public any function index() hint="Template listing" {

		_view(pageTitle = "Templates", renderShowBy = true, stickyAttributes = "pagesize,sort,order");
        _view(headLink = linkTo(text="Add template", action="templateAdd"));

        initListParams(20, "templatename");

        templates = model("template").findAll(
        	select = "templates.id, templates.templatename, templates.isdefaulttemplate, templates.createdAt, templateroles.role, templates.isActive",
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

		Template = model("template").new(params.template);
		Template.userid = getUserAttr('id');

		if (Template.save()){
		    _event("I", "Successfully template created", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
		    flashInsert(success="Template created successfully.");
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

		params.template['updatedAt'] = Now();
		Template = model("template").findByKey(params.template.id);

		if( Template.update( properties = params.template ) ){
			_event("I", "Successfully template updated", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
		    flashInsert(success="Template updated successfully.");
	    	redirectTo(controller=params.controller);
		}
		else {
			_event("W", "Caught attempt to template update information not required", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));

	        _view(pageTitle = "Edit Template");
	        formParams.action = "processUpdateTemplate" ;
	        renderPage(template="addedittemplate") ;
		}
	}

	/**
	* Process Delete Template
	* 	Deleted process is using softdelete.
	* */
	public any function processDeleteTemplate() hint="Process Delete Template"{

		var isSuccessDeleted = 0;

		Template = model("template").findByKey(params.key);

		// Check first, is the template still used
		qPage = model("page").findOne(
						select = 'id',
						where="templateid = #params.key#",
						returnAs = 'query'
		);
		qPost = model("post").findOne(
						select = 'id',
						where="templateid = #params.key#",
						returnAs = 'query'
		);

		if( qPage.RecordCount EQ 0 AND qPost.RecordCount EQ 0){
			if( Template.delete() ){
				_event("I", "Deleted template ###Template.id# (#Template.templatename#)");
				flashInsert(success="Template was deleted successfully");
				redirectTo(controller=params.controller) ;
			}
			else{
				_event("E", "Failed to delete template ###Template.id# (#Template.templatename#))");
	            _error("Template deleting failed");
			}
		}
		else {
			_event("E", "Failed to delete template ###Template.id# (#Template.templatename#)) because it still used by pages/posts");
            flashInsert(success="Template deleting failed.  You will not be able to delete the template until no pages/posts are using the template.");
			redirectTo(controller=params.controller) ;
		}


	}

}