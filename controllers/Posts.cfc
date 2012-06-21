<cfcomponent extends="controller">

	<cfset getTemplates= model("template").findALL() >
	<cfset ALlCatagories = model("category").findALL() >
	
	
	<!--- listing of all posts --->
	<cffunction name="index" access="public" >
		<cfset allPosts = model("post").findAll(include="user,status") >
	</cffunction>
	
	
	<cffunction name="addeditpost" access="public" >
		<cfif StructKeyExists(params,"key") >
			<cfset newPost = model("post").findByKey(params.key) >
			<cfset newPostCatergory = model("postcategorymapping").findAll(where="postid=" & params.key,select="categoryid") >
			<cfset title = "Edit post">
			<cfset formAction = "SubmitEditPost"> 	
			<cfset createdBy = model("user").findbykey(key=newPost.userid,select="userid,uname") >
			<cfif newPost.updatedby neq "">
				<cfset updatedBy = model("user").findbykey(key=newPost.updatedby,select="userid,uname") >	
			</cfif>
			<cfset Status = model("status").findbykey(key=newPost.statusid,select="statusid,status") >			
		<cfelse>
			<cfset newPost = model("post").new() >
			<cfset title = "Posts">
			<cfset formAction = "SubmitAddNewPost" > 
		</cfif>	
	</cffunction>
	
	
	<cffunction name="SubmitAddNewPost">
	
		<cfset params.newPost.userid = getLoggedinUserID() >
		<cfset params.newPost.updatedby = getLoggedinUserID() >
		
		<cfset params.newPost.statusid = 1 >
		
		<cfif params.submit EQ "Save as Draft">
			<cfset params.newPost.statusid = 2 >
		<cfelseif params.submit EQ "Save & Publish">
			<cfset params.newPost.publisheddate = Now() >
			<cfset params.newPost.publishedby = getLoggedinUserID() >			
		</cfif>
		
		<cfset newPost = model("post").new(params.newPost)>
			
		<cfif newPost.save()> 
			<cfif IsDefined("params.categoryID") >
				<cfset newPostId = newPost.postid >
				<cfloop list="#params.categoryID#" index="categoryid">
					<cfset newCategory = model("postcategorymapping").new(categoryid=categoryid, postid=newPostId)>
					<cfset newCategory.save() >
				</cfloop>
			</cfif>
		
			<cfset flashInsert(success="The post was created successfully.")>
			<cfset redirectTo(controller=params.controller)>
		<cfelse>
			<cfset title = "Posts" >
			<cfset formAction = "SubmitAddNewPost" >			
			<cfset renderPage(template="addeditpost")>
		</cfif>

	</cffunction>	
	
	<cffunction name="SubmitEditPost">
		
		<cfset params.newPost.updatedby = getLoggedinUserID() >
		<cfset params.newPost.statusid = 1 >
		
		<cfif params.submit EQ "Save as Draft">
			<cfset params.newPost.statusid = 2 >
		<cfelseif params.submit EQ "Save & Publish">
			<cfset params.newPost.publisheddate = Now() >
			<cfset params.newPost.publishedby = getLoggedinUserID() >			
		</cfif>
		
		<cfset newPost = model("post").findByKey(params.newPost.postid)>
			
		<cfif newPost.update(params.newPost)> 
			<cfset newPostId = params.newPost.postid >
			<cfset mapCAtagoriesdel = model("postcategorymapping").deleteAll(where="postid=" & newPostId)>
			<cfif IsDefined("params.categoryID") >
				<cfloop list="#params.categoryID#" index="categoryid">
					<cfset newCategory = model("postcategorymapping").new(categoryid=categoryid, postid=newPostId)>
					<cfset newCategory.save() >
				</cfloop>
			</cfif>
		
			<cfset flashInsert(success="The post was created successfully.")>
			<cfset redirectTo(controller=params.controller)>
		<cfelse>
			<cfset title = "Edit post">
			<cfset formAction = "SubmitEditPost"> 	
			<cfset createdBy = model("user").findbykey(key=newPost.userid,select="userid,uname") >
			<cfif newPost.updatedby neq "">
				<cfset updatedBy = model("user").findbykey(key=newPost.updatedby,select="userid,uname") >	
			</cfif>
			<cfset Status = model("status").findbykey(key=newPost.statusid,select="statusid,status") >
			<cfset renderPage(template="addeditpost")>
		</cfif>
		
	</cffunction>
	
</cfcomponent>