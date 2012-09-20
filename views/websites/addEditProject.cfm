<cfoutput>
<!--- show error msg if validation properly work --->
#errorMessagesFor("NewSites")#

<!--- add / edit form page [start]--->
#startFormTag(name="createNewSiteForm",method="post",action=formAction,autocomplete="off")# <!--- ,autocomplete="off" ---->
<div class="span4">
    <div class="container-fluid" >
    #textField(label="Site name<br />", objectName="NewSites", property="name")# <br />
    #textField(label="Site url<br />", objectName="NewSites", property="url")# <br />
    #textArea(label="Description<br />", objectName="NewSites", property="description",rows="5", cols="50")# <br /><br />
   #submitTag(value="Save",name="draft",class="btn btn-primary SubmitButton")#  <br />
    <cfif StructKeyExists(NewSites,"id") >
        #hiddenField(objectName="NewSites", property="id")#
    </cfif><br />
    </div>
</div>
#endFormTag()#
<!--- add / edit form page [end]--->
</cfoutput>

<div style="clear:both;"></div>
<div class="bendl"></div>
<div class="bendr"></div>
