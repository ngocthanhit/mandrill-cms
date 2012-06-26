<!---  Link to add new post --->
<div class="span7"><h2>Posts</h2></div> <cfoutput>#linkTo(text="+ Add Post",action="addeditpost",class="btn btn-primary")#</cfoutput>
<br /><br />

<!---  Listing of all "posts" --->
<table class="table table-striped table-bordered">
	<thead class="hero-unit">
		<tr>
			<th>Post</th>
			<th>Author</th>        
			<th>Status </th>                
			<th>Date</th>                        
		</tr>
	</thead>
	<tbody>
    <cfoutput query="allPosts">
		<tr>
			<td>#linkTo(text=HtmlEditFormat(title),action="addeditpost",key=postid)#</td>
			<td>#HtmlEditFormat(firstname)# #HtmlEditFormat(lastname)#</td>        
			<td>#STATUS#</td>
			<td>#DateFormat(createdAt,"mm/dd/yyyy")#</td>        
		</tr>    
    </cfoutput>
	</tbody>
</table>
