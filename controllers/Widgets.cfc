component extends="Controller" hint="Controller for crum pages section" {

    public any function init() hint="Initialize the controller" {
	  filters(through="memberOnly");
    }

    public any function index() hint="Intercept direct access to /pages/" {
		 var local = {};
			1223
			abort;
         _view(pageTitle = "Widgets", renderShowBy = true, stickyAttributes = "pagesize,sort,order");

        initListParams(20, "createdAt");

        widgets = model("widget").findall(
               //include='user,status,pagesuser',
               // where="pagesusers.accountid=#getAccountAttr("id")# AND pagesusers.userid = #getUserAttr("id")# AND pagesusers.siteid = #varsiteid#",
              //  select="title,pages.id,firstname,lastname,pages.createdAt,status",
                page = params.page,
                perPage = params.pagesize,
                order = "#params.order# #params.sort#"
                ); //Get all pages in "pages" structure variable INNER JOIN "users" and  "statuses" table
    }
    
     public any function addeditwidget() hint="Add/Edit site to get new page details and show/ update information for existing sites" {

        if(StructKeyExists(params,"key"))
        {
            NewWidget= model("widget").findByKey(params.key) ;
            title = "Edit Widget" ;
            formAction = "SubmitEditWidget" ;
            createdBy = model("user").findbykey(key=NewWidget.userid,select="id,firstname, lastname") ;
        }
        else
        {
            NewWidget= model("widget").new() ;
            title = "Widgets" ;
            formAction = "SubmitaddNewWidget";
        }
    }

	public any function SubmitaddNewWidget() hint="Create new Widget"{
    
    	
   		StructInsert(params.NewWidget,"userid",getUserAttr("id"));
		StructInsert(params.NewWidget,"accountid",getAccountAttr("id"));
		
	    NewWidget = model("widget").new(params.NewWidget) ;    
        
        if (NewWidget.save())
            {
                _event("I", "Successfully widget created", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                flashInsert(success="Widget created successfully.") ;
                redirectTo(controller=params.controller) ;
            }
        else
            {
                title = "Widgets" ;
                formAction = "SubmitaddNewWidget" ;
                _event("W", "Caught attempt to widget add information not required", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                renderPage(template="addeditwidget") ;
            }
    }
	
    public any function SubmitEditWidget() hint="Update created info" {
      
	    NewWidget = model("widget").findByKey(params.NewWidget.id) ;
        
        if (NewWidget.update(params.NewWidget))
            {
                _event("I", "Successfully updated widget", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                flashInsert(success="Widget updated successfully.") ;
                redirectTo(controller=params.controller) ;
            }
        else
            {
                title = "Edit Widget" ;
                formAction = "SubmitEditWidget" ;
                createdBy = model("user").findbykey(key=NewWidget.userid,select="id,firstname, lastname") ;
                _event("W", "Caught attempt to widget edit changes not required", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                renderPage(template="addeditwidget") ;
            }
    
    }
    
}
