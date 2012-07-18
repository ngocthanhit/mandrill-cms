component extends="Controller" hint="Controller for crum pages section" {

    getPages = model("page").findALL(); //This gets all pages to fill in drop down to bind this page as sub page to another parent page, if any.
    getTemplates= model("template").findALL(); // page layouts/ templates
    varsiteid = 1;
    public any function init() hint="Initialize the controller" {
    filters(through="memberOnly");
       filters(through="restrictedAccessPages");
    }

    public any function index() hint="Intercept direct access to /pages/" {

     var local = {};

         _view(pageTitle = "Pages", renderShowBy = true, stickyAttributes = "pagesize,sort,order");

        initListParams(20, "createdAt");

        pages= model("page").findall(
                include='user,status,pagesuser',
                where="pagesusers.accountid=#getAccountAttr("id")# AND pagesusers.userid = #getUserAttr("id")# AND pagesusers.siteid = #varsiteid#",
                select="title,pages.id,firstname,lastname,pages.createdAt,status",
                page = params.page,
                perPage = params.pagesize,
                order = "#params.order# #params.sort#"
                ); //Get all pages in "pages" structure variable INNER JOIN "users" and  "statuses" table

    }

    public any function addeditpage() hint="Add/Edit Page to get new page details and show/ update information for existing pages" {

        if(StructKeyExists(params,"key"))
        {
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
        }
        else
        {
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
                flashInsert(success="Page created successfully.") ;
                redirectTo(controller=params.controller) ;
            }
        else
            {
                title = "Pages" ;
                formAction = "SubmitaddNewPage" ;
                renderPage(template="addEditPage") ;
            }
    }


    public any function SubmitEditPage() hint="Let's edit page details - form submission comes here" {

        checkconfirmpage(params.Newpages.id);
        params.Newpages.statusid = 1 ;
        params.Newpages.updatedby = getUserAttr("id") ;
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
                renderPage(template="addEditPage") ;
            }
    }

    public any function checkconfirmpage(required numeric pageid) {
        var checkpagesuser   =  model("pagesuser").findall(where="pageid=#pageid# AND accountid = #getAccountAttr("id")#");
           if(checkpagesuser.recordcount EQ 0) {
                flashInsert(success="You not a valid user for this page.") ;
                redirectTo(controller=params.controller) ;
            }

    }
}
