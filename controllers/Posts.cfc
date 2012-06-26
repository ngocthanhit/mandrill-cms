component extends="Controller" hint="Controller for crum posts section" {

    
    
    // public any function init() hint="Initialize the controller" {
      // filters(through="memberOnly", except="login,logout,password,forbidden,signup");
        getTemplates= model("template").findALL() ;
        ALlCatagories = model("category").findALL() ;
    //}
        
    
    
    public any function index() hint="listing of all posts" {
        allPosts = model("post").findAll(include="user,status") ;
    }
    
    
    public any function addeditpost() hint="listing of all posts" {
    
        if (StructKeyExists(params,"key"))
            {
                newPost = model("post").findByKey(params.key) ;
                newPostCatergory = model("postcategorymapping").findAll(where="postid=" & params.key,select="categoryid") ;
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
                newPost = model("post").new() ;
                title = "Posts" ; 
                formAction = "SubmitAddNewPost" ;
            }
    }
    
    
    public any function SubmitAddNewPost() hint="listing of all posts" {
    
        params.newPost.userid = getLoggedinUserID() ;
        params.newPost.updatedby = getLoggedinUserID() ;
        params.newPost.statusid = 1 ;
        
        if (IsDefined("params.draft"))
            {
                params.newPost.statusid = 2 ;
            }
        else if (IsDefined("params.publish"))
            {
                params.newPost.publisheddate = Now() ;
                params.newPost.publishedby = getLoggedinUserID() ;
            }
        params.newPost.title =  xmlFormat(params.newPost.title);
        newPost = model("post").new(params.newPost) ;
            
        if(newPost.save())
            {
                if (IsDefined("params.categoryID"))
                    {
                        var newPostId = newPost.postid ;
                        for (i = 1; i lte ListLen(params.categoryID); i = i + 1)  
                          {
                            var newCategory = model("postcategorymapping").new(categoryid=categoryid[i], postid=newPostId) ;
                            newCategory.save() ;
                         }    
                    }
                flashInsert(success="The post was created successfully.") ;
                redirectTo(controller=params.controller) ;
            }
        else
            {
                title = "Posts" ;
                formAction = "SubmitAddNewPost"  ;
                renderPage(template="addeditpost") ;
            }
    }    
    
    
    public any function SubmitEditPost() hint="listing of all posts" {
    
        params.newPost.updatedby = getLoggedinUserID() ;
        params.newPost.statusid = 1 ;
        
        if (IsDefined("params.draft"))
            {
                params.newPost.statusid = 2 ;
            }
        else if (IsDefined("params.publish"))
            {
                params.newPost.publisheddate = Now() ;
                params.newPost.publishedby = getLoggedinUserID() ;
            }
        params.newPost.title =  xmlFormat(params.newPost.title);
        newPost = model("post").findByKey(params.newPost.postid) ;
            
        if (newPost.update(params.newPost))
            {
                var newPostId = params.newPost.postid  ;
                mapCAtagoriesdel = model("postcategorymapping").deleteAll(where="postid=" & newPostId) ;
                if (IsDefined("params.categoryID"))
                    {
                    
                        for (i = 1; i lte ListLen(params.categoryID); i = i + 1)  
                          {
                            var newCategory = model("postcategorymapping").new(categoryid=categoryid, postid=newPostId) ;
                            newCategory.save()  ;
                         }    
                    }        
                flashInsert(success="The post was created successfully.") ;
                redirectTo(controller=params.controller) ;
            }
        else
            {
                title = "Edit post" ;
                formAction = "SubmitEditPost" ;
                createdBy = model("user").findbykey(key=newPost.userid,select="id,firstname, lastname") ;
                if(newPost.updatedby neq "")
                    {
                        updatedBy = model("user").findbykey(key=newPost.updatedby,select="id,firstname, lastname") ;
                    }
                Status = model("status").findbykey(key=newPost.statusid,select="statusid,status") ;
                renderPage(template="addeditpost") ;
            }
    }
    
}