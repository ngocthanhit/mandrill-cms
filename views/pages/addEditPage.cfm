<cfoutput>
<!--- heading of the page --->
<h2>#title#</h2>
<!--- show error msg if validation properly work --->
#errorMessagesFor("Newpages")#

<!--- add / edit form page [start]--->
#startFormTag(name="createNewPageForm",method="post",action=formAction,autocomplete="off")#
<div class="span7">
    <div class="container-fluid" >
    #textArea(label="Main content<br />", objectName="Newpages", property="content",rows="10", cols="50")# <br />
    #textField(label="Page Title<br />", objectName="Newpages", property="title",size="64")# <br />
    #textArea(label="Description<br />", objectName="Newpages", property="description",rows="5", cols="50")# <br />
    #textField(label="Navigation title (optional)<br />", objectName="Newpages", property="navigationtitle",size="64")# <br />
    #submitTag(value="Save as Draft",name="draft",class="btn SubmitButton")# &nbsp; #submitTag(value="Save & Publish",name="publish",class="btn btn-primary SubmitButton")# <br />
    <cfif NOT StructKeyExists(Newpages,"pageid") >
        #linkto(text="Or publish at a future date ",class="futureDateCont")#
        <div id="futureDateCont">
            <br />
            Publish on date <br />
            #dateTimeSelect(objectName="Newpages", property="publisheddate",separator=" at ",timeorder="hour,minute",class="span1")# (24 hour format)<br />
            #submitTag(name="publishDate",value="Save & Publish on Date",class="btn btn-primary SubmitButton")#
        </div>
    <cfelse>
        #hiddenField(objectName="Newpages", property="pageid")#
    </cfif><br />
    </div>
</div>
<div class="span4">
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

<div style="clear:both;"></div>
<div class="bendl"></div>
<div class="bendr"></div>
