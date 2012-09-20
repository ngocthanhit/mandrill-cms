<cfoutput>

<!---  Listing of all "posts" --->

<table class="table table-striped table-bordered">
    <thead class="hero-unit">
        <tr>
            <th <cfif params.order EQ "host">class="headersort#params.sort#"</cfif>>#linkTo(text="Host",key="#params.key#",params="order=host&sort=#params.asort#")# </th>
            <th <cfif params.order EQ "serverprotocol">class="headersort#params.sort#"</cfif>>#linkTo(text="Server Protocol",key="#params.key#", params="order=serverprotocol&sort=#params.asort#")# </th>
            <th <cfif params.order EQ "createdAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Date",key="#params.key#", params="order=createdAt&sort=#params.asort#")# </th>
            <th>Options</th>
        </tr>
    </thead>
    <tbody>
    <cfloop query="siteSettings">
        <tr>
           <td>#siteSettings.host#</td>
           <td>#siteSettings.serverprotocol#</td>
           <td>#DateFormat(siteSettings.createdAt,"mm/dd/yyyy")#</td>
           <td>#linkto(text="Edit",action="addeditsitesettings",key=params.key,params="settingsid=#id#")# | #linkto(text="Delete",action="DeleteSiteSettings",key=params.key,params="settingsid=#id#",confirm="Are you sure you want to delete this site setting ?")#</td>
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
