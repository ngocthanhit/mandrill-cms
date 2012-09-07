<cfoutput>
#startformtag(action="cerateDuplicate",key=params.key,onsubmit="javascript:return validateCreateDuplicateForm();")#
     #textFieldtag(label="Enter new title: ",name="title",id="title")#
     #submitTag(value="save")#
#endformtag()#
</cfoutput>
<cfabort>