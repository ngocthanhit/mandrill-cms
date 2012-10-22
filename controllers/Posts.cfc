component extends="Controller" hint="Controller for crum posts section" {

    varsiteid = getSiteId();
    getTemplates = model("template").findAll(where = "userid = #getUserAttr('id')# AND templateroleid = 2",order = "templatename");
    ALlCatagories = model("category").findALL() ;
    public any function init() hint="Initialize the controller" {
        filters(through="memberOnly");

        filters(through="restrictedAccessPosts", except="index");
        filters(through="restictedwithSite");
    }

    public any function index() hint="listing of all posts" {

        _view(pageTitle = "Posts<div class='headingLink'>#linkTo(text="+ Add Post",action="addeditpost",class="btn btn-primary")#</div>", renderShowBy = true, stickyAttributes = "pagesize,sort,order");

        initListParams(20, "createdAt");

            allPosts = model("post").findAll(
                include="user,status,postsuser",
                where="postsusers.accountid=#getAccountAttr("id")# AND postsusers.userid = #getUserAttr("id")# AND postsusers.siteid = #varsiteid#",
                select="title,posts.id,firstname,lastname,posts.createdAt,status,posts.updatedAt",
                page = params.page,
                perPage = params.pagesize,
                order = "#params.order# #params.sort#"
                );
    }


    public any function addeditpost() hint="listing of all posts" {

        if (StructKeyExists(params,"key"))
            {
                 _view(pageTitle = "Edit Post", renderShowBy = true);
                checkconfirmpost(params.key);
                newPost = model("post").findByKey(params.key) ;
                if(isAuthor() && (newPost.userid NEQ getUserAttr("id")) OR isGuest())
                {
                    flashInsert(success="access denied.") ;
                    redirectTo(controller="posts");
                }
                newPostCatergory = model("postscategory").findAll(where="postid=" & params.key,select="categoryid") ;
                title = "Edit post" ;
                formAction = "SubmitEditPost" ;
                createdBy = model("user").findbykey(key=newPost.userid,select="id,firstname, lastname") ;
                if (newPost.updatedby neq "")
                    {
                        updatedBy = model("user").findbykey(key=newPost.updatedby,select="id,firstname, lastname") ;
                    }
                Status = model("status").findbykey(key=newPost.statusid,select="statusid,status") ;
            }
        else
            {
                 _view(pageTitle = "Add Post", renderShowBy = true);
                newPost = model("post").new() ;
                title = "Posts" ;
                formAction = "SubmitAddNewPost" ;
            }
    }


    public any function SubmitAddNewPost() hint="listing of all posts" {

        params.newPost.userid = getUserAttr("id") ;
        params.newPost.updatedby = getUserAttr("id") ;
        params.newPost.statusid = 1 ;

        if (IsDefined("params.draft"))
            {
                params.newPost.statusid = 2 ;
            }
        else if (IsDefined("params.publish"))
            {
                params.newPost.publisheddate = Now() ;
                params.newPost.publishedby = getUserAttr("id") ;
            }
        params.newPost.title =  xmlFormat(params.newPost.title);
        newPost = model("post").new(params.newPost) ;

        if(newPost.save())
            {
                 _event("I", "Successfully post created", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                if (IsDefined("params.categoryID"))
                    {
                        var newPostId = newPost.id ;
            var categoryarray = listtoarray(params.categoryID);
                for (i = 1; i lte ArrayLen(categoryarray); i = i + 1)
                          {
                           var newCategory = model("postscategory").new(categoryid=categoryarray[i], postid=newPostId) ;
                            newCategory.save() ;
                         }
                    }
                var createpostusermapping = model("postsuser").new(postid=newPostId,userid=getUserAttr("id"),accountid=getAccountAttr("id"),siteid=varsiteid);
                createpostusermapping.save();
                flashInsert(success="Post created successfully.") ;
                redirectTo(controller=params.controller) ;
            }
        else
            {
                param name="params.categoryID" default="0";
                newPostCatergory = params.categoryID;
                title = "Posts" ;
                formAction = "SubmitAddNewPost"  ;
                _event("W", "Caught attempt to post add information not required", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                renderPage(template="addeditpost") ;
            }
    }


    public any function SubmitEditPost() hint="listing of all posts" {
        if(isAuthor() && (params.userid NEQ getUserAttr("id")) OR isGuest())
            {
                _event("W", "Caught attempt to access forbidden member-only page", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id")); 
                flashInsert(success="access denied.") ;
                redirectTo(controller="posts");
            }
         checkconfirmpost(params.newPost.id);
        params.newPost.updatedby = getUserAttr("id") ;
        params.newPost.statusid = 1 ;

        if (IsDefined("params.draft"))
            {
                params.newPost.statusid = 2 ;
            }
        else if (IsDefined("params.publish"))
            {
                params.newPost.publisheddate = Now() ;
                params.newPost.publishedby = getUserAttr("id") ;
            }
        params.newPost.title =  xmlFormat(params.newPost.title);
        newPost = model("post").findByKey(params.newPost.id) ;

        if (newPost.update(params.newPost))
            {
             _event("I", "Successfully updated post", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
               var newPostId = params.newPost.id  ;
                mapCAtagoriesdel = model("postscategory").deleteAll(where="postid=" & newPostId) ;
                 if (IsDefined("params.categoryID"))
                    {
                        var newPostId = newPost.id ;
            var categoryarray = listtoarray(params.categoryID);
                for (i = 1; i lte ArrayLen(categoryarray); i = i + 1)
                          {
                           var newCategory = model("postscategory").new(categoryid=categoryarray[i], postid=newPostId) ;
                            newCategory.save() ;
                         }
                    }

                flashInsert(success="Post updated successfully.") ;
                redirectTo(controller=params.controller) ;
            }
        else
            {
                param name="params.categoryID" default="0";
                newPostCatergory = params.categoryID;
                title = "Edit post" ;
                formAction = "SubmitEditPost" ;
                createdBy = model("user").findbykey(key=newPost.userid,select="id,firstname, lastname") ;
                if(newPost.updatedby neq "")
                    {
                        updatedBy = model("user").findbykey(key=newPost.updatedby,select="id,firstname, lastname") ;
                    }
                Status = model("status").findbykey(key=newPost.statusid,select="statusid,status") ;
                _event("W", "Caught attempt to post edit changes not required", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
                renderPage(template="addeditpost") ;
            }
    }

     public any function checkconfirmpost(required numeric postid) {
        var checkpostsuser   =  model("postsuser").findall(where="postid=#postid# AND accountid = #getAccountAttr("id")#");
           if(checkpostsuser.recordcount EQ 0) {
               _event("W", "Caught attempt to access forbidden member-only page", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id")); 
                flashInsert(success="You not a valid user for this post.") ;
                redirectTo(controller=params.controller) ;
            }

    }

    public any function Deletepost() hint="Delete post and its mapping" {
        post = model("post").findByKey(params.key) ;
        post.delete(softDelete=false) ;
        mappings = model("postscategorie").deleteAll(where="postid=#params.key#", instantiate=false);
        postsusers = model("postsuser").deleteAll(where="postid=#params.key#", instantiate=false);
          _event("I", "Successfully deleted post", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
        flashInsert(success="Successfully post deleted from list.") ;
        redirectTo(controller=params.controller) ;
    }

     public any function cerateDuplicate() hint="create duplicate copy of existing pages or sub-pages" {
         checkTitle = model("post").findAll(where="title='#params.title#'") ;
         if(checkTitle.recordcount GT 0) {
              _event("W", "Title already exist", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
            flashInsert(success="Your enter title already exist.") ;
            redirectTo(controller=params.controller) ;
         }
         GetpostData = model("post").findByKey(params.key) ;
         var postData = structNew();
         postdata.title =  params.title;
         postdata.userid =  getUserAttr("id");
         postdata.content =  GetpostData.content;
         postdata.description =  GetpostData.description ;
         postdata.publishedby =  GetpostData.publishedby;
         postdata.publisheddate =  GetpostData.publisheddate;
         postdata.statusid =  GetpostData.statusid;
         newPost = model("post").new(postdata) ;
         param name="form.categoryID" default="0";
         newPost.save();
         var getPostcategories = model("postscategorie").findALL(where="postid=#params.key#");
         for (x = 1; x <= getPostcategories.RecordCount; x=x+1) {
            var newCategory = model("postscategory").new(categoryid=getPostcategories.categoryid[x], postid=newPost.id) ;
            newCategory.save() ;
         }
          var createpostusermapping = model("postsuser").new(postid=newPost.id,userid=getUserAttr("id"),accountid=getAccountAttr("id"),siteid=varsiteid);
          createpostusermapping.save();
            _event("I", "Successfully page created", "Sessions", "Session id is #session.sessionid#, useragent is #CGI.USER_AGENT#", getAccountAttr("id"), getUserAttr("id"));
        flashInsert(success="Page created successfully.") ;
        redirectTo(controller=params.controller,action="addeditpost",key=newPost.id) ;
    }
}
