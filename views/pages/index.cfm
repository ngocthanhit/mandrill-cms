<!---  Link to add new page --->
<cfoutput>#linkTo(text="+ Add Page",action="addeditpage")#</cfoutput>


<!---  Listing of all "pages" --->
<table border="1" cellpadding="3" cellspacing="3">
	<tr>
		<th>Page</th>
		<th>Author</th>		
		<th>Status</th>				
		<th>Date</th>						
	</tr>
	<cfoutput query="pages">
	<tr>
		<td>#linkto(text=title,action="addeditpage",key=pageid)#</td>
		<td>#firstname# #lastname#</td>		
		<td>#STATUS#</td>
		<td>#DateFormat(createdAt,"mm/dd/yyyy")#</td>		
	</tr>	
	</cfoutput>
</table>
