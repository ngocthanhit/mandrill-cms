<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%" class="table table-striped">
    <thead>
        <tr>
            <th style="width:20px;">&nbsp;</th>
            <th <cfif params.order EQ "name">class="headersort#params.sort#"</cfif>>#linkTo(text="Account Name", params="order=name&sort=#params.asort#")#</th>
            <th <cfif params.order EQ "code">class="headersort#params.sort#"</cfif>>#linkTo(text="Account Code", params="order=code&sort=#params.asort#")#</th>
            <th style="width:80px;" <cfif params.order EQ "status">class="headersort#params.sort#"</cfif>>#linkTo(text="Status", params="order=status&sort=#params.asort#")#</th>
            <th style="width:80px;" <cfif params.order EQ "expirationDate">class="headersort#params.sort#"</cfif>>#linkTo(text="Exp. Date", params="order=expirationDate&sort=#params.asort#")#</th>
            <th style="width:80px;" <cfif params.order EQ "createdAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Created", params="order=createdAt&sort=#params.asort#")#</th>
            <th style="width:150px;" <cfif params.order EQ "updatedAt">class="headersort#params.sort#"</cfif>>#linkTo(text="Updated", params="order=updatedAt&sort=#params.asort#")#</th>
            <th style="width:100px;">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
    <cfloop query="accounts">
        <tr <cfif accounts.currentRow MOD 2>class="even"</cfif>>
            <td>#accounts.currentRow#)</td>
            <td>#HTMLEditFormat(accounts.name)#</td>
            <td>#HTMLEditFormat(accounts.code)#</td>
            <td>#HTMLEditFormat(accounts.status)#</td>
            <td>#formatDate(accounts.expirationDate)#</td>
            <td class="nowrap">#formatDate(accounts.createdAt)#</td>
            <td class="nowrap">#formatDateTime(accounts.updatedAt)#</td>
            <td class="actions">
                #linkTo(text="Users", action="accountUsers", key=accounts.id)#
                #linkTo(text="Billing", action="accountBilling", key=accounts.id)#
                #linkTo(text="Edit", action="accountEdit", key=accounts.id)#
                <cfif accounts.id GT get("adminsAccountId")>
                #linkTo(text="Delete", action="accountDelete", key=accounts.id, confirm="Are you sure you want to delete account &quot;#HTMLEditFormat(accounts.name)#&quot; and ALL related data? This cannot be undone. Click OK to proceed.")#
                <cfelse>
                <strike title="Deleting admins account is forbidden">Delete</strike>
                </cfif>
            </td>
        </tr>
    </cfloop>
    </tbody>
</table>

<div class="pagination right">
    #paginationLinksFull()#
</div>
</cfoutput>