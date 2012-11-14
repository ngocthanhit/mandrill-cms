<cfoutput>

<!--- show error msg if validation properly work --->
#errorMessagesFor("Template")#

<!--- add / edit form page [start]--->
#startFormTag(name="formTemplate", method="post", action="#formParams.action#", class="form")#
	<fieldset>

		<p class="field contentarea no_pad">
			<!---
				We need to make the scriptProtect="none" in the /config/app.cfm so the server will not
				change some tags into <invalidtag />
			 --->
			#javaScriptIncludeTag("codemirror/lib/codemirror.js,codemirror/mode/xml/xml.js,codemirror/mode/javascript/javascript.js")#
			#styleSheetLinkTag("codemirror")#
		    #javaScriptIncludeTag("codemirror/mode/htmlmixed/htmlmixed.js")#

			#textArea(label="", objectName="template", property="templatecontent", class="span9 editor_area", id="template-editor")#
			<script>
				var editor = CodeMirror.fromTextArea(document.getElementById("template-editor"), {
					lineNumbers: true
				});
			</script>
		</p>
		<p class="field">
			<strong>Template name:</strong><br />
			#textField(label="", objectName="template", property="templatename", class="span6")#
		</p>
		<p class="field">
			#select(objectName="template", property="templateroleid", options=templateRoles, label="<strong>Role (type of page)</strong>")#
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
#endFormTag()#
<!--- add / edit form page [end]--->

</cfoutput>

<div style="clear:both;"></div>
<div class="bendl"></div>
<div class="bendr"></div>
