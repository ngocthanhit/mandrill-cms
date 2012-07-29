<cfoutput>
<h2>Current plan:</h2>

#includePartial("/account/currentplan")#


<h2>Current quotas:</h2>

#includePartial("/account/currentquotas")#

<p></p>


<p>
    Please select the section to proceed:
</p>

<ul>
    <li>#linkTo(text="Change account quotas", action="accountQuotasEdit", key=params.key)#</li>
    <li>#linkTo(text="View history of quota changes", action="accountQuotasHistory", key=params.key)#</li>
    <li>#linkTo(text="Change account plan", action="accountPlanEdit", key=params.key)#</li>
    <li>#linkTo(text="View history of plan changes", action="accountPlanHistory", key=params.key)#</li>
</ul>
</cfoutput>