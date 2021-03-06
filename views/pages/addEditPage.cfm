<cfoutput>

<!--- show error msg if validation properly work --->
#errorMessagesFor("Newpages")#

<!--- add / edit form page [start]--->
#startFormTag(name="createNewPageForm",method="post",action=formAction,autocomplete="off",id="dataForm")#
<div class="span8">
    <div class="container-fluid" >
    #textArea(label="Add Javascript code to top of page just before the end HEAD tag (optional)<br />", objectName="Newpages", property="prefix",rows="5", cols="50",style="width:715px;")# <br />
    #textArea(label="Main content<br />", objectName="Newpages", property="content",class="markItUp",style="width:650px;height:100px")# <br />
    #textArea(label="Add Javascript code to bottom of page just before the end BODY tag (optional)<br />", objectName="Newpages", property="suffix",rows="5", cols="50",style="width:715px;")# <br />
    #textField(label="Page Title<br />", objectName="Newpages", property="title",size="64",style="width:715px;")# <br />
    #textArea(label="Description<br />", objectName="Newpages", property="description",rows="5", cols="50",style="width:715px;")# <br />
    #textField(label="Navigation title (optional)<br />", objectName="Newpages", property="navigationtitle",size="64",style="width:715px;")# <br />
    #submitTag(value="Preview",name="preview",class="btn",id="previewBtn")# &nbsp; #submitTag(value="Save as Draft",name="draft",class="btn SubmitButton")# &nbsp; #submitTag(value="Save & Publish",name="publish",class="btn btn-primary SubmitButton")#<br /><br />
    <cfif NOT StructKeyExists(Newpages,"id") >
        #linkto(text="Or publish at a future date ",class="futureDateCont")#
        <div id="futureDateCont">
            <br />
            Publish on date <br />
             <div class="dateField">#dateTimeSelect(objectName="Newpages", property="publisheddate",separator=" at ",timeorder="hour,minute")# (24 hour format)</div><br />
            #submitTag(name="publishDate",value="Save & Publish on Date",class="btn btn-primary SubmitButton")#
        </div>
    <cfelse>
        #hiddenField(objectName="Newpages", property="id")#
    </cfif><br />
    </div>
</div>
<div class="span4">
    #select(label="Parent page<br />", objectName="Newpages", property="parentid", options=getPages,includeBlank="true")# <br />
    #select(label="Template<br />", objectName="Newpages", property="templateid", options=getTemplates)# <br /><br /><br />
    #selectTag(label="Navigation<br />",options="Show in main navigation,Show page in footer navigation",name="navigation",selected=params.navigation)# <br /><br />
    #selectTag(label="Password protection<br />",id="protected",options="No password required,Password required to view page",valueField="1,2",name="protected",selected=params.protected)# <br /><br />
    #passwordFieldTag(name="password",id="password", style="display:none")#<br /><br />
<!---    #passwordfield(label="Password<br />", objectName="Newpages", property="password")#--->
    <cfif StructKeyExists(Newpages,"id") >
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
<div class="bendr"><script text="javascript">
$(document).ready(function() {
    $("#protected").change(function() {
     if ($(this).val() == "Password required to view page") {
	 	$("#password").show();
	 	$("#password").before("<label for=password>Password</label>")
	 }
	 else{
	 	$("label[for=password], input#password").hide();
	 }
    });
});

</script></div>

