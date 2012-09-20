<cfoutput>
<!--- show error msg if validation properly work --->
#errorMessagesFor("NewSiteSettings")#

<!--- add / edit form page [start]--->
#startFormTag(name="createNewSiteSettingsettingForm",method="post",action=formAction,autocomplete="off",key="#params.key#")# <!--- ,autocomplete="off" ---->
<div class="span4">
    <div class="container-fluid" >
    #textField(label="Name<br />", objectName="getsitesDetail", property="name",disabled="true")# <br />
    #textField(label="Url<br />", objectName="getsitesDetail", property="url",disabled="true")# <br />
    #textArea(label="Description<br />", objectName="getsitesDetail", property="description",rows="5", cols="50",disabled="true")#
    </div>
</div>
<div class="span4">
    #select(label="Server protocol (FTP, SFTP)<br />",objectName="NewSiteSettings", property="serverprotocol",options="FTP,SFTP")# <br />
    #textField(label="Server host<br />", objectName="NewSiteSettings", property="host")# <br />
    #textField(label="Server username<br />", objectName="NewSiteSettings", property="username")# <br />
    #textField(label="Server password<br />", objectName="NewSiteSettings", property="password")# <br />
    #textField(label="Server port<br />", objectName="NewSiteSettings", property="port")# <br />           
    #textField(label="Server remote path<br />", objectName="NewSiteSettings", property="remotepath")# <br />           
     #submitTag(value="Save Changes to Site Settings",name="draft",class="btn SubmitButton")#  <br />
    <cfif StructKeyExists(NewSiteSettings,"id") >
        #hiddenField(objectName="NewSiteSettings", property="id")#
    </cfif><br />     
</div>
#endFormTag()#
<!--- add / edit form page [end]--->
</cfoutput>

<div style="clear:both;"></div>
<div class="bendl"></div>
<div class="bendr"></div>
