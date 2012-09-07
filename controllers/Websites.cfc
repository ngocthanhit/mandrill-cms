component extends="Controller" hint="Controller for crum pages section" {
    public any function init() hint="Initialize the controller" {
      filters(through="memberOnly");
      filters(through="restrictedAccessSites");
    }

    public any function index() hint="Intercept direct access to /pages/" {
         var local = {};
         _view(pageTitle = "Site Settings", renderShowBy = true, stickyAttributes = "pagesize,sort,order");

        initListParams(20, "createdAt");

        sites = model("site").findall(
               //include='user,status,pagesuser',
               // where="pagesusers.accountid=#getAccountAttr("id")# AND pagesusers.userid = #getUserAttr("id")# AND pagesusers.siteid = #varsiteid#",
              //  select="title,pages.id,firstname,lastname,pages.createdAt,status",
                page = params.page,
                perPage = params.pagesize,
                order = "#params.order# #params.sort#"
                ); //Get all pages in "pages" structure variable INNER JOIN "users" and  "statuses" table
    }

     public any function addeditproject() hint="Add/Edit Site Settings to get new page details and show/ update information for existing sites" {

        if(StructKeyExists(params,"key"))
        {
            NewSites= model("site").findByKey(params.key) ;
            title = "Edit Site Settings" ;
            formAction = "SubmitEditSite" ;
            createdBy = model("user").findbykey(key=NewSites.userid,select="id,firstname, lastname") ;
        }
        else
        {
            NewSites= model("site").new() ;
            title = "Site Settings" ;
            formAction = "SubmitaddNewSite";
        }
    }

    public any function SubmitaddNewSite() hint="Create new site"{
        StructInsert(params.NewSites,"userid",getUserAttr("id"));
        StructInsert(params.NewSites,"accountid",getAccountAttr("id"));
        NewSites = model("site").new(params.NewSites) ;    
        if (NewSites.save())
            {
                _event("I", "Successfully site created", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                flashInsert(success="Site created successfully.") ;
                redirectTo(controller=params.controller) ;
            }
        else
            {
                title = "Site Settings" ;
                formAction = "SubmitaddNewSite" ;
                _event("W", "Caught attempt to site add information not required", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                renderPage(template="addeditproject") ;
            }
    }

    public any function SubmitEditSite() hint="Update created info" {
        NewSites = model("site").findByKey(params.NewSites.id) ;
        if (NewSites.update(params.NewSites))
            {
                _event("I", "Successfully updated site", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                flashInsert(success="Site updated successfully.") ;
                redirectTo(controller=params.controller) ;
            }
        else
            {
                title = "Edit Site Settings" ;
                formAction = "SubmitEditSite" ;
                createdBy = model("user").findbykey(key=NewSites.userid,select="id,firstname, lastname") ;
                _event("W", "Caught attempt to site edit changes not required", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                renderPage(template="addeditproject") ;
            }
    }

    public any function Deleteproject() hint="Delete site settings" {
        project = model("site").findByKey(params.key) ;
        project.delete();
         _event("I", "Successfully deleted site settings", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
        flashInsert(success="Successfully site settings deleted from list.") ;
        redirectTo(controller=params.controller) ;
    }

    public any function Choose() hint="choose site options" {
        sites = model("site").findALL(where="accountid=#getAccountAttr("id")# AND userid=#getUserAttr("id")#");
        if(sites.recordcount EQ 0){
             flashInsert(success="No site created,first create site.") ;
            redirectTo(controller="websites",action="addeditproject")
        }
    }

    public any function setChooseSite() hint="Set choose site global" {
        Session.siteid = params.siteid ;
        redirectTo(controller="members");
    }
}
