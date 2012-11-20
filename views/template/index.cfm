<cfoutput>

<!---  Link to add new post --->
<div class="buttonList">#linkTo(text="+ Add New Template",action="addedittemplate",class="btn btn-primary")#</div>

<!---  Listing of all "posts" --->
<table class="table table-striped table-bordered">
	<thead class="hero-unit">
		<tr>
			<th <cfif params.order EQ "templatename">class="headersort#params.sort#"</cfif>>#linkTo(text="Name", params="order=name&sort=#params.asort#")# </th>
			<th <cfif params.order EQ "templaterole">class="headersort#params.sort#"</cfif>>#linkTo(text="Role", params="order=url&sort=#params.asort#")# </th>
			<th>Default Template?</th>
			<th <cfif params.order EQ "createdAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Date", params="order=createdAt&sort=#params.asort#")# </th>
			<th>Active</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
	<cfloop query="templates">
		<tr>
			<td>#templates.templatename#</td>
			<td>#templates.role#</td>
			<td>#YesNoFormat(templates.isdefaulttemplate)#</td>
			<td>#DateFormat(templates.createdAt,"mm/dd/yyyy")#</td>
			<td>#YesNoFormat(templates.isActive)#</td>
			<td>#linkto(text="Edit",action="addedittemplate",key=id)# | #linkto(text="Delete",action="processDeleteTemplate",key=id,confirm="Are you sure you want to delete this template ?")#</td>
		</tr>
	</cfloop>
	</tbody>
</table>

<div class="pagination right">
    #paginationLinksFull()#
</div>

</cfoutput>
<div style="clear:both;"></div>
<div class="bendl"></div>
<div class="bendr"></div>
