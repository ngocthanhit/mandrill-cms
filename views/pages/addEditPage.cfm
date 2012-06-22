<cfoutput>
<!--- heading of the page --->
<h1>#title#</h1>
<!--- show error msg if validation properly work --->
#errorMessagesFor("Newpages")#

<!--- add / edit form page [start]--->
#startFormTag(name="createNewPageForm",method="post",action=formAction,autocomplete="off")#
<div style="float:left; background-color:##CCCCCC;border-radius:10px;padding:10px">

 	#textArea(label="Main content<br />", objectName="Newpages", property="content",rows="10", cols="50")# <br />
    #textField(label="Page Title<br />", objectName="Newpages", property="title",size="64")# <br />
	#textArea(label="Description<br />", objectName="Newpages", property="description",rows="5", cols="50")# <br />
	#textField(label="Navigation title (optional)<br />", objectName="Newpages", property="navigationtitle",size="64")# <br />
    #submitTag(name="submit",value="Save as Draft")# &nbsp; #submitTag(name="submit",value="Save & Publish")# <br />
	<cfif NOT StructKeyExists(Newpages,"pageid") >
	#linkto(text="Or publish at a future date »",onClick="return toggleDiv('PublishedFutureDateDiv');")#
	<div id="PublishedFutureDateDiv" style="display:none;">
		<br />
		Publish on date <br />
		#dateTimeSelect(objectName="Newpages", property="publisheddate",separator=" at ",timeorder="hour,minute")# (24 hour format)<br />
		#submitTag(name="submit",value="Save & Publish on Date")#
	</div>
	<cfelse>
		#hiddenField(objectName="Newpages", property="pageid")#
	</cfif>
</div>
<div style="float:left;">&nbsp;<br /></div>
<div style="float:left; background-color:##CCCCCC;border-radius:10px;padding:10px">


	#select(label="Parent page<br />", objectName="Newpages", property="parentid", options=getPages,includeBlank="true")# <br />
	#select(label="Template<br />", objectName="Newpages", property="templateid", options=getTemplates)# <br /><br /><br />
	#checkbox(label="Show page in navigation",objectName="Newpages", property="showinnavigation")#<br />
	#checkbox(label="Show page in footer navigation",objectName="Newpages", property="showinfooternavigation")#<br /><br />

	 #checkBox(label="Password protect page",objectName="Newpages", property="isprotected")# <br />
	 #checkBox(label="Protect sub-pages", objectName="Newpages", property="issubpageprotected")# <br />
	 #passwordfield(label="Password<br />", objectName="Newpages", property="password")# <br />
	 <cfif StructKeyExists(Newpages,"pageid") >
	 <br />
<br />
<br />

Created by: #linkto(text=createdBy.firstname & " " & createdBy.lastname ,controller="users",action="profile",key=createdBy.id)# on #DateFormat(Newpages.createdAt,"dd/mm/yyyy")# <br />
<cfif IsDefined("updatedBy") >
Last updated by: #linkto(text=updatedBy.firstname & " " & updatedBy.lastname,controller="users",action="profile",key=updatedBy.id)# on #DateFormat(Newpages.updatedat,"dd/mm/yyyy")#<br />
</cfif>
Status: #Status.status#<br />
<br />
	 </cfif>
</div>
#endFormTag()#
<!--- add / edit form page [end]--->
</cfoutput>