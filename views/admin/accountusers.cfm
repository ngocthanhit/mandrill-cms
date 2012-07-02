<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%" class="table table-striped">
    <thead>
        <tr>
            <th style="width:20px;">&nbsp;</th>
            <th <cfif params.order EQ "email">class="headersort#params.sort#"</cfif>>#linkTo(text="Email", key=account.id, params="order=email&sort=#params.asort#")#</th>
            <th <cfif params.order EQ "firstName">class="headersort#params.sort#"</cfif>>#linkTo(text="First Name", key=account.id, params="order=firstName&sort=#params.asort#")#</th>
            <th <cfif params.order EQ "lastName">class="headersort#params.sort#"</cfif>>#linkTo(text="Last Name", key=account.id, params="order=lastName&sort=#params.asort#")#</th>
            <th>Role</th>
            <th style="width:80px;" <cfif params.order EQ "isActive">class="headersort#params.sort#"</cfif>>#linkTo(text="Active", key=account.id, params="order=isActive&sort=#params.asort#")#</th>
            <th style="width:80px;" <cfif params.order EQ "createdAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Created", key=account.id, params="order=createdAt&sort=#params.asort#")#</th>
            <th style="width:150px;" <cfif params.order EQ "updatedAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Updated", key=account.id, params="order=updatedAt&sort=#params.asort#")#</th>
            <td style="width:90px;">&nbsp;</td>
        </tr>
    </thead>
    <tbody>
    <cfloop query="users">
        <tr <cfif users.currentRow MOD 2>class="even"</cfif>>
            <td>#users.currentRow#)</td>
            <td>#HTMLEditFormat(users.email)#</td>
            <td>#HTMLEditFormat(users.firstName)#</td>
            <td>#HTMLEditFormat(users.lastName)#</td>
            <td>#getAccessLevelText(users.accessLevel)#</td>
            <td><a href="javascript:void(0);" class="toggle" model="user" key="#users.id#" field="isactive" title="Toggle status">#YesNoFormat(users.isactive)#</a></td>
            <td class="nowrap">#formatDate(users.createdAt)#</td>
            <td class="nowrap">#formatDateTime(users.updatedAt)#</td>
            <td class="actions">
                #linkTo(text="Edit", action="user-edit", key=users.id)#
                #linkTo(text="Delete", action="user-delete", key=users.id, confirm="Are you sure you want to delete user &quot;#HTMLEditFormat(users.email)#&quot; and ALL related data? This cannot be undone. Click OK to proceed.")#
            </td>
        </tr>
    </cfloop>
    <cfif users.recordCount EQ 0>
        <tr class="even">
            <td colspan="10">This account currently does not have users</td>
        </tr>
    </cfif>
    </tbody>
</table>

<div class="pagination right">
    #paginationLinksRouted(route="adminAccountUsers", key=params.key)#
</div>

<script type="text/javascript">
$(document).ready( function(){
    $(".toggle").bindToggleLinks();
});
</script>
</cfoutput>