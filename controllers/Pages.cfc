component extends="Controller" hint="Controller for crum pages section" {

    public any function init() hint="Initialize the controller" {
       getPages = model("page").findALL(); //This gets all pages to fill in drop down to bind this page as sub page to another parent page, if any.
       getTemplates= model("template").findALL(); // page layouts/ templates
       filters(through="restrictedAccessPages");
    }

    public any function index() hint="Intercept direct access to /pages/" {

         _view(pageTitle = "Pages", renderShowBy = true, stickyAttributes = "pagesize,sort,order");

        initListParams(20, "createdAt");

        pages= model("page").findall(
                include='user,status',
                page = params.page,
                perPage = params.pagesize,
                order = "#params.order# #params.sort#"
                ); //Get all pages in "pages" structure variable INNER JOIN "users" and  "statuses" table
    }

    public any function addeditpage() hint="Add/Edit Page to get new page details and show/ update information for existing pages" {

        if(StructKeyExists(params,"key"))
        {
            if (NOT isdefined("params.checkin"))
            {
            var checkin = checkinconfirm(params.key) ;
            }
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


    public any function checkinconfirm() hint="Cal this function, if page is password protectted." {

        var redirect = true ;
        var getPageData = model("page").findBykey(params.key) ;
        var tocheckPass = "";
        if (getPageData.isprotected EQ 1)
            {
                redirect = false ;
                tocheckPass = getPageData.password ;
            }
         else if (getPageData.parentid NEQ 0)
             {
                var getParentPageData = model("page").findBykey(getPageData.parentid) ;
                tocheckPass = getParentPageData.password ;
                if (getParentPageData.issubpageprotected EQ 1)
                    {
                        redirect = false ;
                    }
             }

        if (NOT redirect)
            {
                if (IsDefined("Params.password"))
                    {
                        if (Compare(tocheckPass, Params.password) eq 0)
                            {
                                redirectTo(action="addEditPage",key=params.key,params="checkin=#hash(params.key)#") ;
                            }
                        else
                            {
                                flashInsert(success="Please enter valid password.") ;
                                redirectTo(back=true) ;
                            }
                    }
                else
                    {
                         redirectTo(action="checkin",key=params.key) ;
                    }
            }

    }

    public any function SubmitaddNewPage() hint="Add new page - form submission is done here" {

        params.Newpages.userid = getLoggedinUserID() ;
        params.Newpages.updatedby = getLoggedinUserID() ;
        params.Newpages.statusid = 1 ;
        if (IsDefined("params.draft"))
            {
                params.Newpages.statusid = 2 ;
            }
        else if (IsDefined("params.publish"))
            {
                params.Newpages.publisheddate = Now() ;
                params.Newpages.publishedby = getLoggedinUserID() ;
            }
        params.Newpages.title = xmlFormat(params.Newpages.title) ;
        params.Newpages.navigationtitle = xmlFormat(params.Newpages.navigationtitle);

        Newpages = model("page").new(params.Newpages) ;

        if (Newpages.save())
            {
                flashInsert(success="The page was created successfully.") ;
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


        params.Newpages.statusid = 1 ;
        params.Newpages.updatedby = getLoggedinUserID() ;
        if (IsDefined("params.draft"))
            {
                params.Newpages.statusid = 2 ;
            }
        else if (IsDefined("params.publish"))
            {
                params.Newpages.publisheddate = Now() ;
                params.Newpages.publishedby = getLoggedinUserID() ;
            }
        params.Newpages.title = xmlFormat(params.Newpages.title) ;
        params.Newpages.navigationtitle = xmlFormat(params.Newpages.navigationtitle);
        Newpages = model("page").findByKey(params.Newpages.pageid) ;

        if (Newpages.update(params.Newpages))
            {
                flashInsert(success="The page was updated successfully.") ;
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
}