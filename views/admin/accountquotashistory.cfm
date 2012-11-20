<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%" class="sortable">
    <thead>
        <tr>
            <th style="width:30px;">##</th>
            <th>Plan Name</th>
            <th>Feature Name</th>
            <th style="width:80px;">Quota</th>
            <th style="width:80px;">Is Active</th>
            <th style="width:150px;">Started</th>
        </tr>
    </thead>
    <tbody>
    <cfloop query="accountquotas">
        <tr <cfif accountquotas.currentRow MOD 2>class="even"</cfif>>
            <td>#accountquotas.currentRow#)</td>
            <td>#linkTo(text=HTMLEditFormat(quotasCache[accountquotas.quotaid].planname), action="accountQuotasHistory", key=account.id, params="planid=#accountquotas.accountplanid#", title="View quotas history filtered by this plan period")#</td>
            <td>#HTMLEditFormat(quotasCache[accountquotas.quotaid].featurename)#</td>
            <td>
            <cfif quotasCache[accountquotas.quotaid].token EQ "Hosting">
            #quotaHostingValue(accountquotas.quota)#
            <cfelse>
            #accountquotas.quota#
            </cfif>
            </td>
            <td<cfif accountquotas.isactive> style="color:green;"</cfif>>#YesNoFormat(accountquotas.isactive)#</td>
            <td class="nowrap">#formatDateTime(accountquotas.createdAt)#</td>
        </tr>
    </cfloop>
    </tbody>
</table>

<div class="pagination right">
    #paginationLinksRouted(route="adminAccountQuotasHistory", key=params.key)#
</div>
</cfoutput>