<cfoutput>
<!--- heading of the page --->
<h1>#title#</h1>
<!--- show error msg if validation properly work --->
#errorMessagesFor("newPost")#

<!--- add / edit form page [start]--->
#startFormTag(name="createNewPostForm",method="post",action=formAction,autocomplete="off")#
<div style="float:left; background-color:##CCCCCC;border-radius:10px;padding:10px">

 	#textArea(label="Main content<br />", objectName="newPost", property="content",rows="10", cols="50")# <br />
    #textField(label="Page Title<br />", objectName="newPost", property="title",size="64")# <br />
	#textArea(label="Description<br />", objectName="newPost", property="description",rows="5", cols="50")# <br />
    #submitTag(name="submit",value="Save as Draft")# &nbsp; #submitTag(name="submit",value="Save & Publish")# <br />
	<cfif NOT StructKeyExists(newPost,"postid") >
	#linkto(text="Or publish at a future date »",onClick="return toggleDiv('PublishedFutureDateDiv');")#
	<div id="PublishedFutureDateDiv" style="display:none;">
		<br />
		Publish on date <br />
		#dateTimeSelect(objectName="newPost", property="publisheddate",separator=" at ",timeorder="hour,minute")# (24 hour format)<br />
		#submitTag(name="submit",value="Save & Publish on Date")#
	</div>
	<cfelse>
		#hiddenField(objectName="newPost", property="postid")#
	</cfif>
</div>
<div style="float:left;">&nbsp;<br /></div>
<div style="float:left; background-color:##CCCCCC;border-radius:10px;padding:10px">
		#select(label="Template<br />", objectName="newPost", property="templateid", options=getTemplates)# <br /><br /><br />
		<strong>Categories</strong>&nbsp;&nbsp;&nbsp;#linkTo(text="Add category")#<br>
		<cfloop query="ALlCatagories">
			<cfset check = "false">
			<cfif IsDefined("newPostCatergory") AND newPostCatergory.recordcount gt 0 >
				<cfif ListContainsNoCase(ValueList(newPostCatergory.categoryid),categoryid) GT 0>
					<cfset check = "true">
				 </cfif>
			</cfif>
			#checkBoxTag(name="categoryID", label=category,labelPlacement="after", value=categoryid ,checked=check)# <br>
		</cfloop>
		
		 <cfif StructKeyExists(newPost,"postid") >
				 <br />
			<br />
			<br />
			
			Created by: #linkto(text=createdBy.uname,controller="users",action="profile",key=createdBy.userid)# on #DateFormat(newPost.createdAt,"dd/mm/yyyy")# <br />
			<cfif IsDefined("updatedBy") >
			Last updated by: #linkto(text=updatedBy.uname,controller="users",action="profile",key=updatedBy.userid)# on #DateFormat(newPost.updatedat,"dd/mm/yyyy")#<br />
			</cfif>
			Status: #Status.status#<br />
			<br />
	 </cfif>
		
	</div>


#endFormTag()#
<!--- add / edit form page [end]--->
</cfoutput>