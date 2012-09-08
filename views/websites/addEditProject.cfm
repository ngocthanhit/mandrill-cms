<cfoutput>
<!--- heading of the page --->
<h2>#title#</h2>
<!--- show error msg if validation properly work --->
#errorMessagesFor("NewSites")#

<!--- add / edit form page [start]--->
#startFormTag(name="createNewSiteForm",method="post",action=formAction,autocomplete="off")# <!--- ,autocomplete="off" ---->
<div class="span3">
    <div class="container-fluid" >
    #textField(label="Name<br />", objectName="NewSites", property="name")# <br />
    #textField(label="Url<br />", objectName="NewSites", property="url")# <br />
    #textArea(label="Description<br />", objectName="NewSites", property="description",rows="5", cols="50")# <br /><br />
    <br /><br /><br /><br />
   #submitTag(value="Save",name="draft",class="btn SubmitButton",style="float:right;")#  <br />  
    <cfif StructKeyExists(NewSites,"id") >
        #hiddenField(objectName="NewSites", property="id")#
    </cfif><br />
    </div>
</div>
<div class="span4">
    #textField(label="Server protocol (FTP, SFTP)<br />", objectName="NewSites", property="serverprotocol")# <br />
    #textField(label="Server host<br />", objectName="NewSites", property="host")# <br />
    #textField(label="Server username<br />", objectName="NewSites", property="username")# <br />
    #textField(label="Server password<br />", objectName="NewSites", property="password")# <br />
    #textField(label="Server port<br />", objectName="NewSites", property="port")# <br />           
    #textField(label="Server remote path<br />", objectName="NewSites", property="remotepath")# <br />                
</div>
#endFormTag()#
<!--- add / edit form page [end]--->
</cfoutput>

<div style="clear:both;"></div>
<div class="bendl"></div>
<div class="bendr"></div>
