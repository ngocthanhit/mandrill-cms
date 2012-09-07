<cfoutput>
#startformtag(action="cerateDuplicate",key=params.key,onsubmit="javascript:return validateCreateDuplicateForm();")#
     #textFieldtag(label="Enter new title: ",name="title",id="title")#
     <input type="hidden" name="categoryID" value="0">
     #submitTag(value="save")#
#endformtag()#
</cfoutput>
<cfabort>