<cfoutput>
<p>
    When discount is applied new price becomes effective starting from next billing cycle.<br/>
    If account currently has other bigger discount, current one is not applied.<br/>
    TODO: update Recurly subscription on pricing change (queue API request).
</p>

#startFormTag(action="discountApplyProceed", key=params.key)#

<table cellpadding="0" cellspacing="0" class="sortable">
    <thead>
        <tr>
            <th style="width:20px;"><input type="checkbox" class="check_all" title="Toggle all accounts on this page" /></th>
            <th>Account Name</th>
            <th>Plan</th>
            <th>Discount</th>
            <th>Price</th>
            <th style="width:30px;">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
    <cfloop query="accounts">
        <tr <cfif accounts.currentRow MOD 2>class="even"</cfif>>
            <td><input type="checkbox" name="accounts[]" value="#accounts.id#" class="bulk-accounts" /></td>
            <td>#HTMLEditFormat(accounts.accountname)#</td>
            <td>#HTMLEditFormat(accounts.planname)#</td>
            <td>#accounts.discount#%</td>
            <td>#DollarFormat(accounts.price)#</td>
            <td class="actions">#linkTo(text="Billing", action="accountBilling", key=accounts.id)#</td>
        </tr>
    </cfloop>
    </tbody>
</table>

<div class="tableactions">
    #submitTag(class="submit mid", value="Apply Discount")#
</div>

#endFormTag()#
</cfoutput>