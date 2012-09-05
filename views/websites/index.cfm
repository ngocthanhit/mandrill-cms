<cfoutput>

<!---  Link to add new post --->
#linkTo(text="+ Add Site Settings",action="addeditproject",class="btn btn-primary")#
<br /><br />

<!---  Listing of all "posts" --->

<table class="table table-striped table-bordered">
    <thead class="hero-unit">
        <tr>
            <th <cfif params.order EQ "name">class="headersort#params.sort#"</cfif>>#linkTo(text="Name", params="order=name&sort=#params.asort#")# </th>
            <th <cfif params.order EQ "url">class="headersort#params.sort#"</cfif>>#linkTo(text="Url", params="order=url&sort=#params.asort#")# </th>
            <th <cfif params.order EQ "createdAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Date", params="order=createdAt&sort=#params.asort#")# </th>
        </tr>
    </thead>
    <tbody>
    <cfloop query="sites">
        <tr>
           <td>#linkTo(text=sites.name,action="addeditproject",key=id)#</td>
           <td>#sites.url#</td>
           <td>#DateFormat(sites.createdAt,"mm/dd/yyyy")#</td>
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
