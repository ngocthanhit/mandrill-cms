component extends="Controller" hint="Controller for crum pages section" {
    public any function init() hint="Initialize the controller" {
      filters(through="memberOnly");
      filters(through="restrictedAccessSites");
    }

    public any function index() hint="Intercept direct access to /pages/" {
         var local = {};
         _view(pageTitle = "Site Settings<div class='headingLink'>#linkTo(text="+ Add New Site",action="addeditproject",class="btn btn-primary")#</div>", renderShowBy = true, stickyAttributes = "pagesize,sort,order");

        initListParams(20, "createdAt");

        sites = model("site").findall(
               include='sitesuser',
                where="sitesusers.accountid=#getAccountAttr("id")# AND sitesusers.userid = #getUserAttr("id")#",
                page = params.page,
                perPage = params.pagesize,
                order = "#params.order# #params.sort#"
                ); //Get all pages in "pages" structure variable INNER JOIN "users" and  "statuses" table
    }

     public any function addeditproject() hint="Add/Edit Site Settings to get new page details and show/ update information for existing sites" {

        if(StructKeyExists(params,"key"))
        {
            _view(pageTitle = "Edit Site", renderShowBy = true);
            NewSites= model("site").findByKey(params.key) ;
            title = "Edit Site" ;
            formAction = "SubmitEditSite" ;
            createdBy = model("user").findbykey(key=getUserAttr("id"),select="id,firstname, lastname") ;
        }
        else
        {
            _view(pageTitle = "Add Site", renderShowBy = true);
            NewSites= model("site").new() ;
            title = "Site" ;
            formAction = "SubmitaddNewSite";
        }
    }

    public any function SubmitaddNewSite() hint="Create new site"{
        dump(params);
        abort;


        NewSites = model("site").new(params.NewSites) ;    
        if (NewSites.save())
            {
                NewSitesUsers = model("sitesuser").new(userid=getUserAttr("id"),accountid=getAccountAttr("id"),siteid=NewSites.id) ;  
                NewSitesUsers.save()
                _event("I", "Successfully site created", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                flashInsert(success="Site created successfully.") ;
                redirectTo(controller=params.controller) ;
            }
        else
            {
                title = "Site" ;
                formAction = "SubmitaddNewSite" ;
                _event("W", "Caught attempt to site add information not required", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                renderPage(template="addeditproject") ;
            }
    }

    public any function SubmitEditSite() hint="Update created info" {
        NewSites = model("site").findByKey(params.NewSites.id) ;
        if (NewSites.update(params.NewSites))
            {
               //var deleteSiteUsers = model("sitesuser").findbykey(params.NewSites.id) ;
                   //deleteSiteUsers.delete();
                 var updateSiteUser = model("sitesuser").findByKey(params.NewSites.id);
                updateSiteUser.update(userid=getUserAttr("id"),accountid=getAccountAttr("id"),siteid=params.NewSites.id) ;

                _event("I", "Successfully updated site", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                flashInsert(success="Site updated successfully.") ;
                redirectTo(controller=params.controller) ;
            }
        else
            {
                title = "Edit Site" ;
                formAction = "SubmitEditSite" ;
                createdBy = model("user").findbykey(key=NewSites.userid,select="id,firstname, lastname") ;
                _event("W", "Caught attempt to site edit changes not required", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                renderPage(template="addeditproject") ;
            }
    }

    public any function Deleteproject() hint="Delete site settings" {
        var getallsitesettings = model("sitessettingsmapping").findall(where="siteid=#params.key#");
        if (getallsitesettings.recordcount GT 0){
              var getSettingsid = ValueList(getallsitesettings.sitessettingid);
            var deletesitessettingmapping = model("sitessettingsmapping").deleteAll(where="siteid=#params.key#");
            var deletesitessetting = model('sitessetting').deleteAll(where="id In (#getSettingsid#)");
        }
        var deleteSiteUsers = model("sitesuser").findbykey(params.key) ;
              deleteSiteUsers.delete();.
        var project = model("site").findByKey(params.key) ;
            project.delete();
         _event("I", "Successfully deleted site", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
        flashInsert(success="Successfully site deleted from list.") ;
        redirectTo(controller=params.controller) ;
    }

    public any function Choose() hint="choose site options" {
        sites = model("site").findALL(include="sitesuser",where="accountid=#getAccountAttr("id")# AND userid=#getUserAttr("id")#");
        if(sites.recordcount EQ 0){
             flashInsert(success="No site created,first create site.") ;
            redirectTo(controller="websites",action="addeditproject")
        }
    }

    public any function setChooseSite() hint="Set choose site global" {
        Session.siteid = params.siteid ;
        redirectTo(controller="members");
    }

    public any function siteSettings() hint="get particlar site settings" {
         var getsitesDetail = model("site").findbyKEy(params.key);
         var local = {};

         _view(pageTitle = "Site Settings  (#getsitesDetail.name#)<div class='headingLink'>#linkTo(text="+ Add Site Settings",action="addeditsitesettings",class="btn btn-primary",key=#params.key#)#</div>", renderShowBy = true, stickyAttributes = "pagesize,sort,order");

        initListParams(20, "createdAt");

        siteSettings = model('sitessetting').findall(include="sitessettingsmapping",where="sitessettingsmappings.siteid=#params.key#", page = params.page,
                perPage = params.pagesize,
                order = "#params.order# #params.sort#");
    }

    public any function addeditsitesettings() {
         getsitesDetail = model("site").findbyKEy(params.key);
         if(StructKeyExists(params,"settingsid"))
        {
             _view(pageTitle = "Edit Site Settings", renderShowBy = true);
            NewSiteSettings= model("sitessetting").findByKey(params.settingsid) ;
            title = "Edit Site Settings" ;
            formAction = "SubmitEditSiteSettings" ;
            createdBy = model("user").findbykey(key=getUserAttr("id"),select="id,firstname, lastname") ;
        }
        else
        {
             _view(pageTitle = "Add Site Settings", renderShowBy = true);
            NewSiteSettings= model("sitessetting").new() ;
            title = "Site Settings" ;
            formAction = "SubmitaddNewSiteSettings";
        }
    }

    public any function SubmitaddNewSiteSettings() {
         getsitesDetail = model("site").findbyKEy(params.key);
        NewSiteSettings = model("sitessetting").new(params.NewSiteSettings) ;
        if (NewSiteSettings.save())
            {
                NewSitesSettingsmappings = model("sitessettingsmapping").new(siteid=params.key,sitessettingid=NewSiteSettings.id) ;  
                NewSitesSettingsmappings.save();
                _event("I", "Successfully site setting created", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                flashInsert(success="Site settind created successfully.") ;
                redirectTo(controller=params.controller,action="siteSettings",key=params.key) ;
            }
        else
            {
                title = "Site Settings" ;
                formAction = "SubmitaddNewSiteSettings";
                _event("W", "Caught attempt to site setting add information not required", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                renderPage(template="addeditsitesettings") ;
            }
    }

    public any function SubmitEditSiteSettings() {
         getsitesDetail = model("site").findbyKEy(params.key);
         NewSiteSettings = model("sitessetting").findByKey(params.NewSiteSettings.id) ;
        if (NewSiteSettings.update(params.NewSiteSettings))
            {
                _event("I", "Successfully updated site settings", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                flashInsert(success="Site Settings updated successfully.") ;
                redirectTo(controller=params.controller,action="siteSettings",key=params.key) ;
            }
        else
            {
                 title = "Edit Site Settings" ;
                    formAction = "SubmitEditSiteSettings" ;
                 createdBy = model("user").findbykey(key=getUserAttr("id"),select="id,firstname, lastname") ;
                _event("W", "Caught attempt to site setting edit changes not required", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                renderPage(template="addeditsitesettings") ;
            }
    }

   public any function DeleteSiteSettings(){
        var deletesitessettingMapping = model('sitessettingsmapping').findbykey(params.settingsid);
        deletesitessettingMapping.delete();
        var deletesitessetting = model('sitessetting').findbykey(params.settingsid);
        deletesitessetting.delete();
         _event("I", "Successfully deleted site settings", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
        flashInsert(success="Successfully site settings deleted from list.") ;
        redirectTo(controller=params.controller,action="siteSettings",key=params.key) ;
   }
}
