<cfoutput>

<!--- show error msg if validation properly work --->
#errorMessagesFor("Template")#

<!--- add / edit form page [start]--->
#startFormTag(name="formTemplate", method="post", action="#formParams.action#", class="form")#
	<fieldset>
			<!--- #textField(label="Name<br />", objectName="NewSites", property="name")# <br />
			#textField(label="Url<br />", objectName="NewSites", property="url")# <br />
			#textArea(label="Description<br />", objectName="NewSites", property="description",rows="5", cols="50")# <br /><br />
			
			<cfif StructKeyExists(NewSites,"id") >
			#hiddenField(objectName="NewSites", property="id")#
			</cfif>
			
			#submitTag(value="Save",name="draft",class="btn SubmitButton")# --->
			
			<p class="field contentarea no_pad">
				#textArea(label="", objectName="template", property="templatecontent", class="span9 editor_area")#
			</p>
			<p class="field">
				<strong>Template name:</strong><br />
				#textField(label="", objectName="template", property="templatename", class="span6")#
			</p>
			<p class="field">
				#select(objectName="template", property="templateroleid", options=templateRoles, label="<strong>Template function</strong>")#
			</p>
			<p class="field field-radio">
				<strong>Status:</strong><br />
				#radioButton(label="Enable", objectName="template", property="isactive", tagValue="1", class="radio", labelPlacement="after")#
				#radioButton(label="Disable", objectName="template", property="isactive", tagValue="0", class="radio", labelPlacement="after")#
			</p>
			<p class="field field-checkbox">
				#checkBox(objectName="template", property="isdefaulttemplate", label="Set as default template", labelPlacement="after")#
			</p>
			<p class="button-wrap">
				<cfif StructKeyExists(template, 'id')>
					#hiddenField(objectName="template", property="id")#
				</cfif>
				#submitTag(name="submit",value="Save",class="btn btn-primary")#
				#submitTag(name="submit",value="Preview",id="template-preview",class="btn")#
			</p>
	</fieldset>
	
	<cfif StructKeyExists(template,"id") >
		#hiddenField(objectName="template", property="id")#
	</cfif>
#endFormTag()#
<!--- add / edit form page [end]--->
</cfoutput>

<div style="clear:both;"></div>
<div class="bendl"></div>
<div class="bendr"></div>
