<!---  Link to add new page --->

<div class="span7"><h2>Pages</h2></div> <cfoutput>#linkTo(text="+ Add Page",action="addeditpage",class="btn btn-primary")#</cfoutput>
<br /><br />

<!---  Listing of all "pages" --->
	<table class="table table-striped table-bordered">
		<thead class="hero-unit">
			<tr>
				<th>Page</th>
				<th>Author</th>
				<th>Status</th>
				<th>Date</th>
			</tr>
		</thead>
		<tbody>
     <cfoutput query="pages">
			<tr>
				<td>#linkto(text=HtmlEditFormat(title),action="addeditpage",key=pageid)#</td>
				<td>#HtmlEditFormat(firstname)# #HtmlEditFormat(lastname)#</td>
				<td>#STATUS#</td>
				<td>#DateFormat(createdAt,"mm/dd/yyyy")#</td>
			</tr>
    </cfoutput>
	</tbody>
</table>

