<cfoutput>
<!--- alert or msg --->
#flash("success")#
<br />
<!--- password check form to provide page access to valid users --->
	#startFormTag(method="post",action="checkinconfirm",key=params.key)#
		#passwordFieldTag(label="Enter Password to edit this page:",name="password")#
		#submitTag(name="checkinSubmitButton",value="Continue")# #linkTo(text="Cancel",controller="pages")#
	#endFormTag()#
</cfoutput>