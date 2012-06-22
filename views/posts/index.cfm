<!---  Link to add new post --->
<cfoutput>#linkTo(text="+ Add post",action="addeditpost")#</cfoutput>


<!---  Listing of all "posts" --->
<table border="1" cellpadding="3" cellspacing="3">
	<tr>
		<th>Post</th>
		<th>Author</th>		
		<th>Status</th>				
		<th>Date</th>						
	</tr>
	<cfoutput query="allPosts">
	<tr>
		<td>#linkTo(text=title,action="addeditpost",key=postid)#</td>
		<td>#firstname# #lastname#</td>		
		<td>#STATUS#</td>
		<td>#DateFormat(createdAt,"mm/dd/yyyy")#</td>		
	</tr>	
	</cfoutput>
</table>
