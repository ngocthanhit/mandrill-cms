<cfcomponent extends="controller">

		<!--- This gets all pages to fill in drop down to bind this page as sub page to another parent page, if any.--->
		<cfset getPages= model("page").findALL() >
		<!--- page layouts/ templates--->
		<cfset getTemplates= model("template").findALL() >


	<!--- listing of all pages --->
	<cffunction name="index" access="public" >
		<!--- Get all pages in "pages" structure variable INNER JOIN "users" and  "statuses" table --->
		<cfset pages= model("page").findall(include='user,status') >
	</cffunction>
	
	<!--- Add/Edit Page to get new page details and show/ update information for existing pages --->
	<cffunction name="addeditpage" >
		
		<!--- if found key or pageid in params --->
		<cfif StructKeyExists(params,"key") > 
			<cfif not isdefined("params.checkin") >
				<cfset checkin = checkinconfirm(params.key) >
			</cfif>
			<!--- get existing page details and show in form to update --->
			<cfset Newpages= model("page").findByKey(params.key) >
			<cfset title = "Edit Page" >
			<cfset formAction = "SubmitEditPage" >
			<cfset createdBy = model("user").findbykey(key=Newpages.userid,select="userid,uname") >
			<cfif Newpages.updatedby neq "">
				<cfset updatedBy = model("user").findbykey(key=Newpages.updatedby,select="userid,uname") >	
			</cfif>
			<cfset Status = model("status").findbykey(key=Newpages.statusid,select="statusid,status") >	
		<cfelse>
			<!--- else create a blank structure for form to add new page details --->
			<cfset Newpages= model("page").new() >
			<cfset Newpages.showinnavigation = 1>
			<cfset title = "Pages" >
			<cfset formAction = "SubmitaddNewPage" >			
		</cfif>
		
	</cffunction>
	
	<!--- Cal this function, if page is password protectted. --->
	<cffunction name="checkinconfirm">
		<!--- redirect variable default set as true.  --->
		<cfset var redirect = true >
		<cfset getPageData = model("page").findBykey(params.key)>
		
		<!--- checks if the requested page isprotectted--->
		<cfif getPageData.isprotected EQ 1 >
			<cfset redirect = false > 
			<cfset tocheckPass = getPageData.password >
		<cfelseif getPageData.parentid NEQ 0>
			<!--- checks if parent of this page has protection for sub pages --->
			<cfset getParentPageData = model("page").findBykey(getPageData.parentid)>
			<cfset tocheckPass = getParentPageData.password >
			<cfif getParentPageData.issubpageprotected EQ 1 >
				<cfset redirect = false >
			</cfif>
		</cfif>
		<!--- if redirect is false, we need password to go ahead for editing --->
		<cfif NOT redirect  >
			<cfif IsDefined("Params.password") > <!--- if page submitted with to validate password --->
				<!--- if page's password and password entered by user is same. --->
				<cfif Compare(tocheckPass, Params.password) eq 0 >
					<!--- and set redirect variable true to redirect to page edit form--->
					<cfset redirectTo(action="addEditPage",key=params.key,params="checkin=#hash(params.key)#") >
				<cfelse>
					<!---if password fails redirect with a message --->
					<cfset flashInsert(success="Please enter valid password.")>
					<cfset redirectTo(back=true)>					
				</cfif>
			<cfelse>
				<cfset redirectTo(action="checkin",key=params.key) >
			</cfif>
		</cfif>
	</cffunction>
	
	
	<!--- Add new page - form submission is done here --->
	<cffunction name="SubmitaddNewPage">
		<!--- set Author id for the page ---->
		<cfset params.Newpages.userid = getLoggedinUserID() >
		<cfset params.Newpages.updatedby = getLoggedinUserID() >
		<!---  page Published now, status default to 1 (published) --->
		<cfset params.Newpages.statusid = 1 >
		<!--- checks if user want to save as draft--->
		<cfif params.submit EQ "Save as Draft">
			<cfset params.Newpages.statusid = 2 >
		<cfelseif params.submit EQ "Save & Publish">
			<!--- else if want to save and publish now. If these two "conditions" are not validated then user wants to publish page in future date entered by user  --->
			<cfset params.Newpages.publisheddate = Now() >
			<cfset params.Newpages.publishedby = getLoggedinUserID() >			
		</cfif>
		
		<!--- create new structure with values passed with form --->
		<cfset Newpages = model("page").new(params.Newpages)>
		
		<!--- save new page structure in table "pages"  --->
		<cfif Newpages.save()> <!---Checks if page insertion is successful--->
			<cfset flashInsert(success="The page was created successfully.")>
			<!--- redirect to page listing with success message --->
			<cfset redirectTo(controller=params.controller)>
		<cfelse>
			<cfset title = "Pages" >
			<cfset formAction = "SubmitaddNewPage" >			
			<!--- if page insertion fails --->
			<cfset renderPage(template="addEditPage")>
		</cfif>
	</cffunction>
	
	
	<!--- Let's edit page details - form submission comes here --->
	<cffunction name="SubmitEditPage">
		<!--- set page staus published default  --->
		<cfset params.Newpages.statusid = 1 >
		<!--- set updated by user ---->
		<cfset params.Newpages.updatedby = getLoggedinUserID() >
		<!--- if user want to save as draft --->
		<cfif params.submit EQ "Save as Draft">
			<!---  set page status - draft --->
			<cfset params.Newpages.statusid = 2 >
		<cfelseif params.submit EQ "Save & Publish">
			<!--- elseif user wants to publish page now. --->
			<cfset params.Newpages.publisheddate = Now() >
			<cfset params.Newpages.publishedby = getLoggedinUserID() >
		</cfif>
		<!--- create structure with data value to update existing page --->
		<cfset Newpages = model("page").findByKey(params.Newpages.pageid)>
		<!--- update requested page information  --->
		<cfif Newpages.update(params.Newpages)><!--- Page updation is successfull --->
			<cfset flashInsert(success="The page was updated successfully.")>
			<!--- its redirect with success message on page listing  --->
			<cfset redirectTo(controller=params.controller)>
		<cfelse>
			<!--- page updation failed --->
			<cfset title = "Edit Page" >
			<cfset formAction = "SubmitEditPage" >	
			<cfset createdBy = model("user").findbykey(key=Newpages.userid,select="userid,uname") >
			<cfif Newpages.updatedby neq "">
				<cfset updatedBy = model("user").findbykey(key=Newpages.updatedby,select="userid,uname") >			
			</cfif>		
			<cfset Status = model("status").findbykey(key=Newpages.statusid,select="statusid,status") >	
			<cfset renderPage(template="addEditPage")>
		</cfif>
	</cffunction>
	
</cfcomponent>