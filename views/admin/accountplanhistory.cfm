<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%" class="sortable">
    <thead>
        <tr>
            <th style="width:30px;">##</th>
            <th>Plan Name</th>
            <th>Plan Price</th>
            <th>Discount Name</th>
            <th>Discount Value</th>
            <th>Billed Price</th>
            <th style="width:80px;">Is Active</th>
            <th style="width:150px;">Started</th>
            <th style="width:40px;">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
    <cfloop query="accountplans">
        <tr <cfif accountplans.currentRow MOD 2>class="even"</cfif>>
            <td>#accountplans.currentRow#)</td>
            <td>#HTMLEditFormat(accountplans.name)#</td>
            <td>#DollarFormat(accountplans.planprice)#</td>
            <td>#HTMLEditFormat(accountplans.discountname)#</td>
            <td>#accountplans.discount#%</td>
            <td>#DollarFormat(accountplans.price)#</td>
            <td<cfif accountplans.isactive> style="color:green;"</cfif>>#YesNoFormat(accountplans.isactive)#</td>
            <td class="nowrap">#formatDateTime(accountplans.createdAt)#</td>
            <td class="actions">
                #linkTo(text="Quotas", action="accountQuotasHistory", key=account.id, params="planid=#accountplans.id#", title="View quotas history for this plan period")#
            </td>
        </tr>
    </cfloop>
    </tbody>
</table>
<p></p>
</cfoutput>