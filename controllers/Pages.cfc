component extends="Controller" hint="Controller for crum pages section" {
    varsiteid = getSiteId();
    getPages = model("page").findALL(include="pagesuser",where="pagesusers.siteid = '#varsiteid#'"); //This gets all pages to fill in drop down to bind this page as sub page to another parent page, if any.
    //getTemplates= model("template").findALL(); // page layouts/ templates
    
    getTemplates = model("template").findAll(where = "userid = #getUserAttr('id')# AND templateroleid = 4",order = "templatename");

    public any function init() hint="Initialize the controller" {
    filters(through="memberOnly");
       filters(through="restrictedAccessPages");
       filters(through="restictedwithSite");
    }

    public any function index() hint="Intercept direct access to /pages/" {

     var local = {};

         _view(pageTitle = "Pages<div class='headingLink'>#linkTo(text="+ Add Page",action="addeditpage",class="btn btn-primary pull-right")#</div>", renderShowBy = true, stickyAttributes = "pagesize,sort,order");

        initListParams(20, "createdAt");

        pages= model("page").findall(
                include='user,status,pagesuser',
                where="pagesusers.accountid=#getAccountAttr("id")# AND pagesusers.userid = #getUserAttr("id")# AND pagesusers.siteid = #varsiteid#",
                select="title,pages.id,firstname,lastname,pages.createdAt,status,parentid,pages.updatedAt",
                page = params.page,
                perPage = params.pagesize,
                order = "#params.order# #params.sort#"
                ); //Get all pages in "pages" structure variable INNER JOIN "users" and  "statuses" table
    }

    public any function addeditpage() hint="Add/Edit Page to get new page details and show/ update information for existing pages" {
		params.navigation="";
		params.protected="No password required"
		password = 0;
		
        if(StructKeyExists(params,"key"))
        {
             _view(pageTitle = "Edit Page", renderShowBy = true);
            checkconfirmpage(params.key);
	        Newpages= model("page").findByKey(params.key) ;
	        title = "Edit Page" ;
	        formAction = "SubmitEditPage" ;
	        createdBy = model("user").findbykey(key=Newpages.userid,select="id,firstname, lastname") ;
	        if (Newpages.updatedby NEQ "")
	        {
	        	updatedBy = model("user").findbykey(key=Newpages.updatedby,select="id,firstname, lastname") ;
	        }
	        Status = model("status").findbykey(key=Newpages.statusid,select="statusid,status");
	
	        if(Newpages.showinnavigation){
	            params.navigation = "Show in main navigation";
	        }
			if(Newpages.showinfooternavigation){
	            params.navigation = "Show page in footer navigation";
	        }
	
	        if(Newpages.isprotected){
	            params.protected = "Password protect page";
	        }
	        if(Newpages.issubpageprotected){
	            params.protected = "Protect sub-pages";
	        } 
	        if(Newpages.password NEQ "") {
	            password = 1;
	        }
	        Newpages.password = "";
        }
        else
        {
			_view(pageTitle = "Add Page", renderShowBy = true);
	     	Newpages= model("page").new() ;
	        Newpages.showinnavigation = 1 ;
	        title = "Pages" ;
	        formAction = "SubmitaddNewPage";
        }
    }

    public any function SubmitaddNewPage() hint="Add new page - form submission is done here" {

        params.Newpages.userid = getUserAttr("id") ;
        params.Newpages.updatedby = getUserAttr("id") ;
        params.Newpages.statusid = 1 ;
         if(params.navigation EQ "Show in main navigation"){
             params.Newpages.showinnavigation = true;
        } else {
            params.Newpages.showinnavigation = false;
        }
         if(params.navigation EQ "Show page in footer navigation"){
             params.Newpages.showinfooternavigation =true;
        } else {
            params.Newpages.showinfooternavigation = false;
        }

         if(params.protected EQ "No password required"){
             params.Newpages.isprotected = false;
        }

         if(params.protected EQ "Password protect page"){
             params.Newpages.isprotected = true;
        } else {
            params.Newpages.isprotected = false;
        }
         if(params.protected EQ "Protect sub-pages"){
             params.Newpages.issubpageprotected =true;
        } else {
            params.Newpages.issubpageprotected = false;
        }

        if (IsDefined("params.draft"))
            {
                params.Newpages.statusid = 2 ;
            }
        else if (IsDefined("params.publish"))
            {
                params.Newpages.publisheddate = Now() ;
                params.Newpages.publishedby = getUserAttr("id") ;
            }
        params.Newpages.title = xmlFormat(params.Newpages.title) ;
        params.Newpages.navigationtitle = xmlFormat(params.Newpages.navigationtitle);

        Newpages = model("page").new(params.Newpages) ;

        if (Newpages.save())
            {
                var createpageusermapping = model("pagesuser").new(pageid=Newpages.id,userid=getUserAttr("id"),accountid=getAccountAttr("id"),siteid=varsiteid);
                createpageusermapping.save();

                if (IsDefined("params.publish")) {
                    try {
                        var getPgeSiteSettingsID = model("sitessettingsmapping").findone(where="siteid=#varsiteid#");
                        var getPgeSiteSettings = model("sitessetting").findall(where="id=#getPgeSiteSettingsID.sitessettingid#");
                        if (getPgeSiteSettings.recordcount GT 0){
                            savecontent variable="pageHtml" {
                                writeoutput("<html>");
                                    writeoutput("<head>");
                                           writeoutput("<title>");
                                            writeoutput(params.Newpages.title);
                                        writeoutput("</title>");
                                    writeoutput("</head>");
                                    writeoutput("<body>");
                                       writeoutput(params.Newpages.content);
                                    writeoutput("</body>");
                                writeoutput("</html>");
                            }
                            var filename = params.Newpages.navigationtitle;
                            if(filename EQ ""){
                                filename = params.Newpages.title;
                            }
                                filename = "#Replace(filename," ","_","ALL")#.html";
                                var path = "#expandpath("/")#assets/tmpfile/";
                                   if (!DirectoryExists(path))
                                {
                                    DirectoryCreate(path);
                                }
                            ftp action = "open"  server = "#getPgeSiteSettings.host#"  username="#getPgeSiteSettings.username#" password="#getPgeSiteSettings.password#" connection = "MyConn" passive="yes" timeout="300";
                            if(cfftp.Succeeded) {
                                FileWrite("#path##filename#","#pageHtml#");
                                ftp action="putfile" connection="MyConn" localfile="#path##filename#" remotefile="#getPgeSiteSettings.remotepath##filename#" passive="yes" stoponerror="yes" ;
                                ftp action="close" connection="MyConn";
                                FileDelete("#path##filename#");
                          _event("I", "Successfully publish file", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                            }
                         }
                    } catch (any e) {
                         _event("W", "Caught attempt to page edit for some error like this '<strong>error : </strong>#e.message#.'", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                        //abort;
                    }
                }

                _event("I", "Successfully page created", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                flashInsert(success="Page created successfully.") ;
                redirectTo(controller=params.controller) ;
            }
        else
            {
                title = "Pages" ;
                formAction = "SubmitaddNewPage" ;
                _event("W", "Caught attempt to page add information not required", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                renderPage(template="addEditPage") ;
            }
    }

    public any function SubmitEditPage() hint="Let's edit page details - form submission comes here" {

        checkconfirmpage(params.Newpages.id);
        params.Newpages.password =  params.password ;
        if((params.protected neq "") AND params.Newpages.password eq ""){
            StructDelete(params.Newpages,"password");
        }
        params.Newpages.statusid = 1 ;
        params.Newpages.updatedby = getUserAttr("id") ;
         if(params.navigation EQ "Show in main navigation"){
             params.Newpages.showinnavigation = true;
        } else {
            params.Newpages.showinnavigation = false;
        }
         if(params.navigation EQ "Show page in footer navigation"){
             params.Newpages.showinfooternavigation =true;
        } else {
            params.Newpages.showinfooternavigation = false;
        }

         if(params.protected EQ "No password required"){
             params.Newpages.isprotected = false;
        }

        if(params.protected EQ "Password protect page"){
             params.Newpages.isprotected = true;
        } else {
            params.Newpages.isprotected = false;
        }
         if(params.protected EQ "Protect sub-pages"){
             params.Newpages.issubpageprotected =true;
        } else {
            params.Newpages.issubpageprotected = false;
        }
        if (IsDefined("params.draft"))
            {
                params.Newpages.statusid = 2 ;
            }
        else if (IsDefined("params.publish"))
            {
                params.Newpages.publisheddate = Now() ;
                params.Newpages.publishedby = getUserAttr("id") ;
            }
        params.Newpages.title = xmlFormat(params.Newpages.title) ;
        params.Newpages.navigationtitle = xmlFormat(params.Newpages.navigationtitle);
        Newpages = model("page").findByKey(params.Newpages.id) ;

        if (Newpages.update(params.Newpages))
            {
                if (IsDefined("params.publish")) {
                    try {
                        var getPgeSiteSettingsID = model("sitessettingsmapping").findone(where="siteid=#varsiteid#");
                        var getPgeSiteSettings = model("sitessetting").findall(where="id=#getPgeSiteSettingsID.sitessettingid#");
                        if (getPgeSiteSettings.recordcount GT 0){
                            savecontent variable="pageHtml" {
                                writeoutput("<html>");
                                    writeoutput("<head>");
                                           writeoutput("<title>");
                                            writeoutput(params.Newpages.title);
                                        writeoutput("</title>");
                                    writeoutput("</head>");
                                    writeoutput("<body>");
                                       writeoutput(params.Newpages.content);
                                    writeoutput("</body>");
                                writeoutput("</html>");
                            }
                            var filename = params.Newpages.navigationtitle;
                            if(filename EQ ""){
                                filename = params.Newpages.title;
                            }
                                filename = "#Replace(filename," ","_","ALL")#.html";
                                var path = "#expandpath("/")#assets/tmpfile/";
                                   if (!DirectoryExists(path))
                                {
                                    DirectoryCreate(path);
                                }
                            ftp action = "open"  server = "#getPgeSiteSettings.host#"  username="#getPgeSiteSettings.username#" password="#getPgeSiteSettings.password#" connection = "MyConn" passive="yes" timeout="300";
                            if(cfftp.Succeeded) {
                                FileWrite("#path##filename#","#pageHtml#");
                                ftp action="putfile" connection="MyConn" localfile="#path##filename#" remotefile="#getPgeSiteSettings.remotepath##filename#" passive="yes" stoponerror="yes" ;
                                ftp action="close" connection="MyConn";
                                FileDelete("#path##filename#");
                          _event("I", "Successfully publish file", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                            }
                         }
                    } catch (any e) {
                         _event("W", "Caught attempt to page edit for some error like this '<strong>error : </strong>#e.message#.'", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                        //abort;
                    }
                }
                _event("I", "Successfully updated page", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                flashInsert(success="Page updated successfully.") ;
                redirectTo(controller=params.controller) ;
            }
        else
            {
                title = "Edit Page" ;
                formAction = "SubmitEditPage" ;
                createdBy = model("user").findbykey(key=Newpages.userid,select="id,firstname, lastname") ;
                if (Newpages.updatedby neq "")
                    {
                        updatedBy = model("user").findbykey(key=Newpages.updatedby,select="id,firstname, lastname") ;
                    }
                Status = model("status").findbykey(key=Newpages.statusid,select="statusid,status") ;
                _event("W", "Caught attempt to page edit changes not required", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                renderPage(template="addEditPage") ;
            }
    }

    public any function checkconfirmpage(required numeric pageid) {
        var checkpagesuser   =  model("pagesuser").findall(where="pageid=#pageid# AND accountid = #getAccountAttr("id")#");
           if(checkpagesuser.recordcount EQ 0) {
                _event("W", "Caught attempt to access forbidden member-only page", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                flashInsert(success="You not a valid user for this page.") ;
                redirectTo(controller=params.controller) ;
            }

    }


    public any function list() hint="list of pages" {

     var local = {};

        pages= model("page").findall(
                include='user,status,pagesuser',
                where="pagesusers.accountid=#getAccountAttr("id")# AND pagesusers.userid = #getUserAttr("id")# AND pagesusers.siteid = #varsiteid#",
                select="title,pages.id,firstname,lastname,pages.createdAt,status"
                ); //Get all pages in "pages" structure variable INNER JOIN "users" and  "statuses" table

    }
    public any function getpagedata() hint="get page content html" {
         var getpageHTMl= model("page").findbykey(params.pageID);
        writeOutput(getpageHTMl.content);
        abort;
    }

    public any function deletepage() hint="delete page and its sub-pages" {
        page = model("page").findByKey(params.key) ;
        page.delete() ;
        subPages = model("page").deleteAll(where="parentid=#params.key#", instantiate=false);
        pagesusers = model("pagesuser").deleteAll(where="pageid=#params.key#", instantiate=false);
          _event("I", "Successfully deleted page", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
        flashInsert(success="Successfully page deleted from list.") ;
        redirectTo(controller=params.controller) ;
    }

    public any function cerateDuplicate() hint="create duplicate copy of existing pages or sub-pages" {
         checkTitle = model("page").findAll(where="title='#params.title#'") ;
         if(checkTitle.recordcount GT 0) {
              _event("W", "Title already exist", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
            flashInsert(success="Your enter title already exist.") ;
            redirectTo(controller=params.controller) ;
         }
         GetpageData = model("page").findByKey(params.key) ;
         GetpageData.title = params.title;
         StructDelete(GetpageData,"id");
         Newpages = model("page").new(GetpageData) ;
         Newpages.save();
        var createpageusermapping = model("pagesuser").new(pageid=Newpages.id,userid=getUserAttr("id"),accountid=getAccountAttr("id"),siteid=varsiteid);
        createpageusermapping.save();
        _event("I", "Successfully page created", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
        flashInsert(success="Page created successfully.") ;
        redirectTo(controller=params.controller,action="addeditpage",key=Newpages.id) ;
    }

}
