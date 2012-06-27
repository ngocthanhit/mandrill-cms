<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%" class="table table-striped">
    <thead>
        <tr>
            <th style="width:20px;">&nbsp;</th>
            <th <cfif params.order EQ "email">class="headersort#params.sort#"</cfif>>#linkTo(text="Email", params="order=email&sort=#params.asort#")#</th>
            <th <cfif params.order EQ "firstName">class="headersort#params.sort#"</cfif>>#linkTo(text="First Name", params="order=firstName&sort=#params.asort#")#</th>
            <th <cfif params.order EQ "lastName">class="headersort#params.sort#"</cfif>>#linkTo(text="Last Name", params="order=lastName&sort=#params.asort#")#</th>
            <th>Role</th>
            <th style="width:80px;" <cfif params.order EQ "isActive">class="headersort#params.sort#"</cfif>>#linkTo(text="Active", params="order=isActive&sort=#params.asort#")#</th>
            <th style="width:80px;" <cfif params.order EQ "createdAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Created", params="order=createdAt&sort=#params.asort#")#</th>
            <th style="width:150px;" <cfif params.order EQ "updatedAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Updated", params="order=updatedAt&sort=#params.asort#")#</th>
            <td style="width:70px;">&nbsp;</td>
        </tr>
    </thead>
    <tbody>
    <cfloop query="users">
        <tr <cfif users.currentRow MOD 2>class="even"</cfif>>
            <td>#users.currentRow#)</td>
            <td <cfif users.id EQ getUserAttr("id")>style="font-weight:bold;" title="This is you"</cfif>>#HTMLEditFormat(users.email)#</td>
            <td>#HTMLEditFormat(users.firstName)#</td>
            <td>#HTMLEditFormat(users.lastName)#</td>
            <td>#getAccessLevelText(users.accessLevel)#</td>
            <td><cfif users.id NEQ getUserAttr("id")><a href="javascript:void(0);" class="toggle" model="user" key="#users.id#" field="isactive" title="Toggle status">#YesNoFormat(users.isactive)#</a><cfelse>Yes</cfif></td>
            <td class="nowrap">#formatDate(users.createdAt)#</td>
            <td class="nowrap">#formatDateTime(users.updatedAt)#</td>
            <td class="actions">
                #linkTo(text="Edit", action="memberEdit", key=users.id)#
                <cfif users.id NEQ getUserAttr("id")>
                    #linkTo(text="Delete", action="memberDelete", key=users.id, confirm="Are you sure you want to delete team member &quot;#HTMLEditFormat(users.email)#&quot;?")#
                <cfelse>
                    <strike title="Deleting own user account is not possible">Delete</strike>
                </cfif>
            </td>
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