<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%" class="table table-striped">
    <thead>
        <tr>
            <th style="width:20px;">&nbsp;</th>
            <th <cfif params.order EQ "email">class="headersort#params.sort#"</cfif>>#linkTo(text="Name", params="order=name&sort=#params.asort#")#</th>
            <th <cfif params.order EQ "firstName">class="headersort#params.sort#"</cfif>>#linkTo(text="Description", params="order=description&sort=#params.asort#")#</th>
            <th <cfif params.order EQ "lastName">class="headersort#params.sort#"</cfif>>#linkTo(text="URL", params="order=url&sort=#params.asort#")#</th>
        </tr>
    </thead>
    <tbody>
    <cfloop query="sites">
        <tr <cfif sites.currentRow MOD 2>class="even"</cfif>>
            <td>#sites.currentRow#)</td>
            <td>#linkTo(text=#HTMLEditFormat(sites.name)#,controller = "websites",action="set-choose-site",params="siteid=#sites.id#")#</td>
            <td>#HTMLEditFormat(sites.description)#</td>
            <td>#HTMLEditFormat(sites.url)#</td>
        </tr>
    </cfloop>
    </tbody>
</table>

<div class="pagination right">
    #paginationLinksFull()#
</div>

<script type="text/javascript">
$(document).ready( function(){
    $(".toggle").bindToggleLinks();
});
</script>
</cfoutput>