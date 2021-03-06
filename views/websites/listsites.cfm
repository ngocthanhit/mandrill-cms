<cfoutput>

<!---  Listing of all "posts" --->

<table class="table table-striped table-bordered">
    <thead class="hero-unit">
        <tr>
            <th <cfif params.order EQ "name">class="headersort#params.sort#"</cfif>>#linkTo(text="Name", params="order=name&sort=#params.asort#")# </th>
            <th <cfif params.order EQ "url">class="headersort#params.sort#"</cfif>>#linkTo(text="Url", params="order=url&sort=#params.asort#")# </th>
            <th <cfif params.order EQ "createdAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Date", params="order=createdAt&sort=#params.asort#")# </th>
            <th>Options</th>
        </tr>
    </thead>
    <tbody>
    <cfloop query="sites">
        <tr>
           <td>#linkTo(text=#HTMLEditFormat(sites.name)#,controller = "websites",action="set-choose-site",params="siteid=#sites.id#")#</td>
           <td>#sites.url#</td>
           <td>#DateFormat(sites.createdAt,"mm/dd/yyyy")#</td>
           <td>#linkto(text="Edit",action="addeditproject",key=id)# | #linkto(text="Delete",action="Deleteproject",key=id,confirm="Are you sure you want to delete this site ?")# | #linkto(text="Settings",action="SiteSettings",key=id)#</td>
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
